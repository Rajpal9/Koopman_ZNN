function [th_next,th_dot_next] = dynamics_3R(th,th_dot,tau)
    g = 9.81*0;
    %dynamic friction coess
    fd = 0.0;
    %lengths of links
    a1 =0.33;
    a2 = 0.33;
    a3 = 0.33;
    
    %mass of links
    m1 = 0.1;
    m2 = 0.1;
    m3 = 0.1;
    
    %moment of inertia of links
    I1 = 1;
    I2 = 1;
    I3 = 1;
    
    %position of CM
    l1 = a1/2;
    l2 = a2/2;
    l3 = a3/2;
    
    dt =0.005;
    %angles
    th1 = th(1);
    th2 = th(2);
    th3 = th(3);
    th1_dot = th_dot(1);
    th2_dot = th_dot(2);
    th3_dot = th_dot(3);
    
    %mass matrix
    m11 = I1+I2+I3+m1*l1^2+m2*(a1^2+l2^2+2*a1*l2*cos(th2))+m3*(a1^2+a2^2+l3^2+2*a1*a2*cos(th2)+2*a1*l3*cos(th2+th3)+2*a2*l3*cos(th3));
    m22 = I2+I3+m2*l2^2+m3*(a2^2+l3^2+2*a2*l3*cos(th3));
    m33 = I3+m3*l3^2;
    m12 = I2+I3+m2*(l2^2+a1*l2*cos(th2))+m3*(a2^2+l3^2+a1*a2*cos(th2)+a1*l3*cos(th2+th3)+2*a2*l3*cos(th3));
    m21 = m12;
    m13 = I3+m3*(l3^2+a1*l3*cos(th2+th3)+a2*l3*cos(th3));
    m31 = m13;
    m23 = I3+m3*(l3^2+a2*l3*cos(th3));
    m32 = m23;
    
    %mass matrix
    M  = [m11 m12 m13;
          m21 m22 m23;
          m31 m32 m33];
      
    %corollois term
        c11 = -(m3*a1*l3*sin(th2+th3)+m3*a2*l3*sin(th3))*th3_dot-(m2+m3*a1*a2*sin(th2)+a1*l2*sin(th2)+m3*a1*l3*sin(th2+th3))*th2_dot;
        c22 = -m3*a2*l3*sin(th3)*th3_dot;
        c33 = -(m3*a1*a2*sin(th2))*th2_dot-(m3*a2*l3*sin(th3))*th3_dot;
        c12 = -(m2*a1*l2*sin(th2)+m3*a1*l3*sin(th2+th3)+m3*a1*a2*sin(th2))*th1_dot-(m3*a1*a2*sin(th2)+m3*a1*l3*sin(th2+th3)+m2*a1*l2*sin(th2))*th2_dot-(m3*a2*l3*sin(th3)+m3*a1*l3*sin(th2+th3))*th3_dot;
        c13 = -(m3*a1*l3*sin(th2+th3)+m3*a2*l3*sin(th3))*th1_dot-(m3*a1*l3*sin(th2+th3)+m3*a2*l3*sin(th3))*th2_dot-(m3*a2*l3*sin(th2)+m3*a1*l3*sin(th2+th3))*th3_dot;
        c21 = (m2*a1*l2*sin(th2)+m3*a1*a2*sin(th2)+m3*a1*l3*sin(th2+th3))*th1_dot-(m3*a2*l3*sin(th3))*th3_dot;
        c23 = -(m3*a2*l3*sin(th3))*th1_dot-(m3*a2*l3*sin(th3))*th2_dot-(m3*a2*l3*sin(th3))*th3_dot;
        c31 = (m3*a1*l3*sin(th2+th3)+m3*a2*l3*sin(th3))*th1_dot+(m3*a2*l3*sin(th3))*th2_dot;
        c32 = (m3*a2*l3*sin(th3))*th1_dot+(m3*a2*l3*sin(th3))*th2_dot-(m3*a2*l3*sin(th3))*th3_dot;

    C = [c11 c12 c13;c21 c22 c23;c31 c32 c33];

    % gravity terms     
    g1 = (m2*l2+m3*a2)*g*cos(th1+th2)+m3*l3*g*cos(th1+th2+th3)+(m1*l1+m3*a1+m2*a1)*g*cos(th1);
    g2 = (m2*l2+m3*a2)*g*cos(th1+th2)+m3*l3*g*cos(th1+th2+th3);
    g3 = m3*l3*g*cos(th1+th2+th3);

    G = [g1;g2;g3];
    
    th_ddot = (M)\(tau-G-C*th_dot-fd*th_dot);
    th_dot_next = th_dot + th_ddot*dt;
    th_next = th + th_dot*dt + (1/2)*th_ddot*dt^2;
    

end