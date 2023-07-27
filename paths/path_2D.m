% 3d trajectory
function [rd, rd_dot, rd_ddot] = path_2D(c,tilt, rd_0,t, t_end, shape)
%%%% Input arguement
% c - size parameter
% rd_0 -  starting point for the trajectory
% t - time instant
% t_end -  total time for trajectory
% shape  -  shape of trajectory
%%% Output Arguements
% rd -  desired position
% rd_dot -  desired velocity
% rd_ddot -  desired position
    n = 10/t_end;
    t = t*10/t_end;
    if strcmpi(shape,'adobe') == 1
        rd = [2*c*cos(0.4*pi*t) + 3*c*cos(0.2*pi*t) + rd_0(1) - 5*c;
              2*c*sin(0.4*pi*t) - 3*c*sin(0.2*pi*t) + rd_0(2)];
           
        rd_dot = [-0.8*n*pi*c*sin(0.4*pi*t) - 0.6*n*pi*c*sin(0.2*pi*t);
                   0.8*n*pi*c*cos(0.4*pi*t) - 0.6*n*pi*c*cos(0.2*pi*t)];
                   
        rd_ddot = [-0.32*(n*pi)^2*c*cos(0.4*pi*t) - 0.12*(n*pi)^2*c*cos(0.2*pi*t);
                  -0.32*(n*pi)^2*c*sin(0.4*pi*t) + 0.12*(n*pi)^2*c*sin(0.2*pi*t)];
              
    elseif strcmpi(shape,'hyp') == 1
       rd = [2*c*cos(0.2*pi*t) - c*cos(0.8*pi*t) + rd_0(1) - c;
             2*c*sin(0.2*pi*t) - c*sin(0.8*pi*t) + rd_0(2)];
                   
        rd_dot =  [-0.4*c*n*pi*sin(0.2*pi*t)+ 0.8*c*n*pi*sin(0.8*pi*t);
                   0.4*c*n*pi*cos(0.2*pi*t)- 0.8*c*n*pi*cos(0.8*pi*t)];
                   
        rd_ddot = [-0.08*c*(n*pi)^2*cos(0.2*pi*t)+ 0.64*c*(n*pi)^2*cos(0.8*pi*t);
                 -0.08*c*(n*pi)^2*sin(0.2*pi*t) + 0.64*c*(n*pi)^2*sin(0.8*pi*t)];
             
     
    elseif strcmp(shape,'lissajous')

        rd = [4*c*sin(0.2*pi*t) + rd_0(1);
                       3*c*sin(0.4*pi*t)+rd_0(2);];

        rd_dot = [4*c*(0.2*pi/n)*cos(0.2*pi*t);
                  3*c*(0.4*pi/n)*cos(0.4*pi*t);];
    
        rd_ddot = [-4*c*((0.2*pi/n)^2)*sin(0.4*pi*t);
                   -3*c*((0.4*pi/n)^2)*sin(0.2*pi*t);];
   
    elseif strcmp(shape,"epicycloid")
        rd = [4*c*cos(0.2*pi*t)-c*cos(0.8*pi*t)-3*c+rd_0(1);
              4*c*sin(0.2*pi*t)-c*sin(0.8*pi*t)+rd_0(2)];

        rd_dot = [-4*c*sin(0.2*pi*t)*(0.2*pi*n)+c*sin(0.8*pi*t)*(0.8*pi*n);
                   4*c*cos(0.2*pi*t)*(0.2*pi*n)-c*cos(0.8*pi*t)*(0.8*pi*n)];

        rd_ddot = [-4*c*cos(0.2*pi*t)*(0.2*pi*n)^2+c*cos(0.8*pi*t)*(0.8*pi*n)^2;
                   -4*c*sin(0.2*pi*t)*(0.2*pi*n)^2+c*sin(0.8*pi*t)*(0.8*pi*n)^2];

    elseif strcmpi(shape,'circle') == 1
       rd =  [c*cos(0.2*pi*t)+ rd_0(1) - c;
              c*sin(0.2*pi*t) + rd_0(2)];
                   
       rd_dot = [-c*0.2*n*pi*sin(0.2*pi*t);
                  c*0.2*n*pi*cos(0.2*pi*t)];
                   
       rd_ddot = [-c*((0.2*n*pi)^2)*cos(0.2*pi*t);
                  -c*((0.2*n*pi)^2)*sin(0.2*pi*t)];
    
    elseif strcmpi(shape,'cardioid') == 1
       rd = [2*c*cos(0.2*pi*t)-c*cos(0.4*pi*t)+rd_0(1)-c;
             2*c*sin(0.2*pi*t)-c*sin(0.4*pi*t)+rd_0(2)];
                   
       rd_dot = [-2*c*0.2*n*pi*sin(0.2*pi*t)+c*0.4*n*pi*sin(0.4*pi*t);
                  2*c*0.2*n*pi*cos(0.2*pi*t)-c*0.4*n*pi*cos(0.4*pi*t)];
                   
        rd_ddot = [-2*c*(0.2*n*pi)^2*cos(0.2*pi*t)+c*0.4^2*(n*pi)^2*cos(0.4*pi*t);
                   -2*c*(0.2*n*pi)^2*sin(0.2*pi*t)+c*0.4^2*(n*pi)^2*sin(0.4*pi*t)];
             
             
    
    elseif strcmpi(shape,'tricuspid') == 1
       rd = [c*cos(0.4*pi*t)+2*c*cos(0.2*pi*t)+ rd_0(1)-3*c;
             c*sin(0.4*pi*t)-2*c*sin(0.2*pi*t)+rd_0(2)];
                   
        rd_dot = [-c*0.4*n*pi*sin(0.4*pi*t)-2*c*0.2*n*pi*sin(0.2*pi*t);
                   c*0.4*n*pi*cos(0.4*pi*t)-2*c*0.2*n*pi*cos(0.2*pi*t)];
                   
        rd_ddot = [-c*((0.4*n*pi)^2)*cos(0.4*pi*t)-2*c*((0.2*n*pi)^2)*cos(0.2*pi*t);
                   -c*((0.4*n*pi)^2)*sin(0.4*pi*t)+2*c*((0.2*n*pi)^2)*sin(0.2*pi*t)];
    
    elseif strcmpi(shape,'star') == 1
       rd = [c*cos(0.6*pi*t)+2*c*cos(0.4*pi*t)+rd_0(1)-3*c;
             c*sin(0.6*pi*t)-2*c*sin(0.4*pi*t)+rd_0(2)];
                   
        rd_dot = [-c*0.6*n*pi*sin(0.6*pi*t)-2*c*0.4*n*pi*sin(0.4*pi*t);
                 c*0.6*pi*n*cos(0.6*pi*t)-2*c*0.4*n*pi*cos(0.4*pi*t)];
                   
        rd_ddot =  [-c*((0.6*n*pi)^2)*cos(0.6*pi*t)-2*c*((0.4*n*pi)^2)*cos(0.4*pi*t);
                    -c*((0.6*n*pi)^2)*sin(0.6*pi*t)+2*c*((0.4*n*pi)^2)*sin(0.4*pi*t)];
                
    elseif strcmpi(shape,'petal') == 1
       rd = [c*cos(0.2*pi*t) + c*cos(1.2*pi*t)+ rd_0(1)- 2*c;
             c*sin(0.2*pi*t)- c*sin(1.2*pi*t)+rd_0(2)];  
       
       rd_dot = [-(0.2*n*pi)*c*sin(0.2*pi*t) - (0.6*n*pi)*c*sin(0.6*pi*t);
                 (0.2*n*pi)*c*cos(0.2*pi*t) - (0.6*n*pi)*c*cos(0.6*pi*t)];  
       
       rd_ddot = [-((0.2*n*pi)^2)*c*cos(0.2*pi*t) - ((0.6*n*pi)^2)*c*cos(0.6*pi*t);
                 -((0.2*n*pi)^2)*c*sin(0.2*pi*t) + ((0.6*n*pi)^2)*c*sin(0.6*pi*t)];
    end
        
        
end