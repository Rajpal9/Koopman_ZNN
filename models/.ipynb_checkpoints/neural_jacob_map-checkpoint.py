import torch
def neural_jacobian(map_net,joint_angles):
    theta = torch.from_numpy(joint_angles).float()
    
    if map_net.map_net_params['hidden_depth']>0:
        s = map_net.map_net_in(theta)
        x = map_net.activation_fcn(s)
        s_dot = map_net.map_net_in.weight
        x_dot = torch.matmul(torch.diag(1/torch.cosh(s)**2),s_dot) # J = df/dx = sec^h(wx)*x

        for layer in map_net.map_net_hid:
            s = layer(x)
            x = map_net.activation_fcn(s)
            s_dot = torch.matmul(layer.weight,x_dot)
            x_dot = torch.matmul(torch.diag(1/torch.cosh(s)**2),s_dot) 

    W = torch.matmul(map_net.map_net_out.weight,x_dot).detach().numpy()
    
    return W

def neural_jacobian_dot(map_net,joint_angles, joint_velocity):
    theta = torch.from_numpy(joint_angles).float()
    theta_dot = torch.from_numpy(joint_velocity).float()
    
    
    if map_net.map_net_params['hidden_depth']>0:
        s = map_net.map_net_in(theta)
        x = map_net.activation_fcn(s)
        s_dot = map_net.map_net_in.weight
        x_dot = torch.matmul(torch.diag(1/torch.cosh(s)**2),s_dot) 
        x_ddot = - torch.matmul(torch.diag(torch.mul(torch.mul(x,1/torch.cosh(s)),torch.matmul(s_dot,theta_dot))),s_dot)
        for layer in map_net.map_net_hid:
            s = layer(x)
            x = map_net.activation_fcn(s)
            s_dot = torch.matmul(layer.weight,x_dot)
            x_dot = torch.matmul(torch.diag(1/torch.cosh(s)**2),s_dot) 
            x_ddot = -torch.matmul(torch.diag(torch.mul(torch.mul(x,1/torch.cosh(s)),torch.matmul(s_dot,theta_dot))),s_dot) + torch.mul(x_dot, x_ddot)

    W_dot = torch.matmul(map_net.map_net_out.weight,x_ddot).detach().numpy()
    
    return W_dot