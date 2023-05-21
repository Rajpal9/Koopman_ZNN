"""CREATE A NEURAL NETWORK TO MAP FROM THETA TO POSITION OF END EFFECTOR"""
import torch 
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torch.utils.data import random_split
import torch.optim as optim
from torch.utils.data import random_split
import os
import numpy as np
from sys import exit
import matplotlib.pyplot as plt

class map_Net(nn.Module):

    def __init__(self,map_net_params):
        super(map_Net, self).__init__()
        self.map_net_params = map_net_params
        self.opt_parameters_map = []



    def create_model(self):
        input_dim = self.map_net_params['input_dim']
        hidden_depth = self.map_net_params['hidden_depth']
        hidden_width = self.map_net_params['hidden_width']
        output_dim = self.map_net_params['output_dim']
        activation_type = self.map_net_params['activation_type']


        if hidden_depth>0:
            #input_layer
            self.map_net_in = nn.Linear(input_dim,hidden_width)
            self.opt_parameters_map.append(self.map_net_in.weight)
            self.opt_parameters_map.append(self.map_net_in.bias)
            self.map_net_hid = nn.ModuleList()

            #hidden layers
            for i in range(1,hidden_depth):
                self.map_net_hid.append(nn.Linear(hidden_width,hidden_width))
                self.opt_parameters_map.append(self.map_net_hid[-1].weight)
                self.opt_parameters_map.append(self.map_net_hid[-1].bias)


            self.map_net_out = nn.Linear(hidden_width,output_dim)
            self.opt_parameters_map.append(self.map_net_out.weight)
            self.opt_parameters_map.append(self.map_net_out.bias)


        else: #no hidden layers
            self.map_net_out = nn.Linear(input_dim,output_dim)
            self.opt_parameters_map.append(self.map_net_out.weight)
            self.opt_parameters_map.append(self.map_net_out.bias)


        #activation functions
        if activation_type == 'relu':
            self.activation_fcn = F.relu

        elif activation_type == 'elu':
            self.activation_fcn = nn.ELU

        elif activation_type == 'tanh':
            self.activation_fcn = torch.tanh

        elif activation_type == 'sigmoid':
            self.activation_fcn = torch.sigmoid

        else:
            exit("Exit : invalid activation function")


    def forward(self, theta):
        #this computes the forward operations
        if self.map_net_params['hidden_depth']>0:
            x = self.activation_fcn(self.map_net_in(theta))

            for layer in self.map_net_hid:
                x = self.activation_fcn(layer(x))

        x = self.map_net_out(x)

        return x


    def set_optimizer(self):
        if self.map_net_params['optimizer']=='adam':
            lr = self.map_net_params['lr']
            weight_decay = self.map_net_params['l2_reg']
            self.optimizer = optim.Adam(self.parameters(),lr = lr, weight_decay = weight_decay)
        elif self.map_net_params['optimizer']=='adamax':
            lr = self.map_net_params['lr']
            weight_decay = self.map_net_params['l2_reg']
            self.optimizer = optim.Adamax(self.parameters(),lr = lr, weight_decay = weight_decay)


    def loss(self,output, label):
        criterion = nn.MSELoss()
        loss = criterion(output,label)
        #l1 regularization
        l1_reg = self.map_net_params['l1_reg']
        l1_norm = torch.norm(self.map_net_in.weight.view(-1),p=1)+torch.norm(self.map_net_in.bias.view(-1),p=1)+torch.norm(self.map_net_out.weight.view(-1),p=1)+torch.norm(self.map_net_out.bias.view(-1),p=1)
        for i in range(0,self.map_net_params['hidden_depth']-1):
            l1_norm+= torch.norm(self.map_net_hid[i].weight.view(-1),p=1)+torch.norm(self.map_net_hid[i].bias.view(-1),p=1)

        l1_loss = l1_reg*l1_norm
        total_loss = loss+l1_loss

        return total_loss


    def set_dataset_map(self,xs_map_train,ys_map_train,xs_map_val,ys_map_val):
        order = 'F'
        n = self.map_net_params['input_dim'] #number of angles
        m = self.map_net_params['output_dim'] #x and y position of end effector
        n_traj_train = xs_map_train.shape[0]
        n_traj_val = xs_map_val.shape[0]
        n_data_pts_train = n_traj_train*xs_map_train.shape[1]
        n_data_pts_val = n_traj_val*xs_map_train.shape[1]

        self.xs_map_train = xs_map_train.T.reshape((n,n_data_pts_train),order=order)
        self.ys_map_train = ys_map_train.T.reshape((m,n_data_pts_train),order=order)
        self.xs_map_val = xs_map_val.T.reshape((n,n_data_pts_val),order=order)
        self.ys_map_val = ys_map_val.T.reshape((m,n_data_pts_val),order=order)

        self.xs_map_train= self.xs_map_train.T
        self.xs_map_val= self.xs_map_val.T
        self.ys_map_train= self.ys_map_train.T
        self.ys_map_val= self.ys_map_val.T

    def data_pipeline(self):
        self.create_model()
        self.set_optimizer()
        X_map_train_t, y_map_train_t = torch.from_numpy(self.xs_map_train).float(), torch.from_numpy(self.ys_map_train).float()
        X_map_val_t, y_map_val_t = torch.from_numpy(self.xs_map_val).float(), torch.from_numpy(self.ys_map_val).float()
        dataset_train = torch.utils.data.TensorDataset(X_map_train_t, y_map_train_t)
        dataset_val = torch.utils.data.TensorDataset(X_map_val_t, y_map_val_t)

        self.train_map_model(dataset_train,dataset_val)


    def train_map_model(self,dataset_train,dataset_val):
        # Train Network
        trainloader = torch.utils.data.DataLoader(dataset_train, batch_size = self.map_net_params['batch_size'], shuffle = True)
        valloader = torch.utils.data.DataLoader(dataset_val, batch_size = self.map_net_params['batch_size'])

        val_loss_prev = np.inf
        self.train_loss_hist = []
        self.val_loss_hist = []
        for epoch in range(self.map_net_params['epochs']):
            running_loss = 0.0
            epoch_steps = 0

            for data in trainloader:
                inputs, labels = data

                self.optimizer.zero_grad()
                output = self(inputs)
                loss = self.loss(output,labels)
                loss.backward()
                self.optimizer.step()

                running_loss += float(loss.detach())
                epoch_steps += 1

            val_loss = 0.0
            val_steps =0

            for data in valloader:
                with torch.no_grad():
                    inputs, val_labels = data

                    val_output = self(inputs)
                    loss= self.loss(val_output,val_labels)

                    val_loss += float(loss.detach())
                    val_steps += 1

            #print epoch loss

            self.train_loss_hist.append(running_loss/epoch_steps)
            self.val_loss_hist.append(val_loss/val_steps)
            print('Epoch %3d: train loss: %.10f, validation loss: %.10f' %(epoch + 1, self.train_loss_hist[-1],self.val_loss_hist[-1]))

        print("Finished training")

    def plot_loss(self):
        #plot
        epochs = np.arange(0, self.map_net_params['epochs'])
        plt.figure(figsize=(15,8))
        plt.plot(epochs, self.train_loss_hist, color='tab:orange', label='Training loss')
        plt.plot(epochs, self.val_loss_hist, color='tab:blue', label='Validation loss')

        plt.legend()
        plt.xlabel('Epoch')
        plt.ylabel('Loss')
        plt.yscale('log')
        plt.show()