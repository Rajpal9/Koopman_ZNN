function [rd,rd_dot] = paths(c,tilt,x_initial,t,T,path)
    n = 1;
    if path=="cardioid"
        rd = [2*c*cos(2*n*pi*t/T)-c*cos(4*n*pi*t/T)+x_initial(1)-c; %desired end effector position
              2*c*sin(2*n*pi*t/T)-c*sin(4*n*pi*t/T)+x_initial(2)];

        rd_dot =  [-2*n*c*2*pi*sin(2*n*pi*t/T)/T+c*n*4*pi*sin(4*n*pi*t/T)/T;
                    2*c*n*2*pi*cos(2*n*pi*t/T)/T-c*n*4*pi*cos(4*n*pi*t/T)/T];

    elseif path=="lissajous"
        rd = [0.3*sin(2*pi*t/T)+x_initial(1);
              0.15*sin(4*pi*t/T+pi/6)+x_initial(2)-0.15*sin(pi/6)];
        
        rd_dot = [0.3*cos(2*pi*t/T)*2*pi/T;
                  0.15*cos(4*pi*t/T+pi/6)*4*pi/T];

    elseif path=="star"
        rd = [0.1*cos(6*pi*t/T)-0.25*cos(-12*pi*t/3/T)+0.15+x_initial(1);
              0.1*sin(6*pi*t/T)-0.25*sin(-12*pi*t/3/T)+x_initial(2)];

        rd_dot = [-0.1*sin(6*pi*t/T)*(6*pi/T)+0.25*sin(-4*pi*t/T)*(-4*pi/T);
                 0.1*cos(6*pi*t/T)*(6*pi/T)-0.25*cos(-4*pi*t/T)*(-4*pi/T)];
    elseif path == "curve1"
        rd = [c*((sin(4*pi*t/T) + 3*sin(2*pi*t/T)))+x_initial(1);
              c*2*sin(6*pi*t/T) + x_initial(2)];

        rd_dot = [c*(cos(4*pi*t/T)*(4*pi/T) + 3*cos(2*pi*t/T)*(2*pi/T));
                  c*2*cos(6*pi*t/T)*(6*pi/T)];
              
    elseif path == "lissajous2"
        
        rd = [c*cos(6*pi*t/T)-c+x_initial(1);
              c*sin(4*pi*t/T)+x_initial(2)];
          
        rd_dot = [-c*sin(6*pi*t/T)*(6*pi/T);
                   c*cos(4*pi*t/T)*(4*pi/T)];

    elseif path == "epicycloid"
        rd = [4*c*cos(2*pi*t/T)-c*cos(8*pi*t/T)-3*c+x_initial(1);
              4*c*sin(2*pi*t/T)-c*sin(8*pi*t/T)+x_initial(2)];

        rd_dot = [-4*c*sin(2*pi*t/T)*(2*pi/T)+c*sin(8*pi*t/T)*(8*pi/T);
                   4*c*cos(2*pi*t/T)*(2*pi/T)-c*cos(8*pi*t/T)*(8*pi/T)];
    elseif path == "curve2"
        rd = [c*(cos(2*pi*2*t/T)-cos(2*pi*1*t/T).^3)+x_initial(1);
              c*(sin(2*pi*2*t/T)-sin(2*pi*1*t/T).^3)+x_initial(2)];

        rd_dot = [c*(-sin(2*2*pi*t/T)*(2*2*pi/T)+3*cos(2*pi*t/T).^2)*sin(2*pi*t/T)*(2*pi/T);
                  c*(cos(2*2*pi*t/T)*(2*2*pi/T)-3*sin(2*pi*t/T).^2)*cos(2*pi*t/T)*(2*pi/T)];

    elseif path == "curve3"
        rd = [c*(cos(1*pi*2*t/T)-cos(2*pi*2*t/T).^3)+x_initial(1);
              c*(sin(2*pi*2*t/T)-sin(2*pi*1*t/T).^3)+x_initial(2)];

        rd_dot = [c*(-sin(1*2*pi*t/T)*(1*2*pi/T)+3*cos(2*2*pi*t/T).^2)*sin(2*2*pi*t/T)*(2*2*pi/T);
                  c*(cos(2*2*pi*t/T)*(2*2*pi/T)-3*sin(2*pi*t/T).^2)*cos(2*pi*t/T)*(2*pi/T)];
    end

end