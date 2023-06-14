import roboticstoolbox as rtb
import numpy as np
robot = rtb.models.DH.Puma560()

def dynamics_puma560_data_gen(dt,robot,num_traj,num_snaps,num_states,num_inputs):
    

    # matrix initializations
    X = np.empty((num_traj,num_snaps+1,num_states)) # cartesian state matrix
    U = np.empty((num_traj,num_snaps,num_inputs)) # input matrix
    x_end = np.empty((num_traj,num_snaps+1,3)) # position of end effector

    for i in range(num_traj):
    # initialize the values for the trajectory
      # joint angles
        X[i,0,0:int(num_states/2)] = np.pi*(2*np.random.rand(1,1,int(num_states/2))-1) # theta values
          # joint velocities
        X[i,0,int(num_states/2):num_states] = 0.1*(2*np.random.rand(1,1,int(num_states/2))-1) # theta values
        htf = np.array(robot.fkine(X[i,0,0:int(num_states/2)]))
        x_end[i,0,:]= htf[:3,3]
        


        for j in range(num_snaps):

            # inputs
            U[i,j,:] = 1*(2*np.random.rand(1,1,num_inputs)-1)
            
            th_ddot = robot.accel(X[i,j,:int(num_states/2)], U[i,j,:], X[i,j,int(num_states/2):num_states])
            # theta evolution
            X[i,j+1,int(num_states/2):num_states] = th_ddot*dt + X[i,j+1,int(num_states/2):num_states] 
            X[i,j+1,0:int(num_states/2)] =  X[i,j+1,int(num_states/2):num_states]*dt + X[i,j+1,:int(num_states/2)]
            htf = np.array(robot.fkine(X[i,j+1,0:int(num_states/2)]))
            x_end[i,j+1,:]= htf[:3,3]
    return x_end,X,U