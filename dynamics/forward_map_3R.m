function x = forward_map_3R(theta)
    a1 = 0.33;
    a2 = 0.33;
    a3 = 0.33;
    
    x(1) = a1*cos(theta(1)) + a2*cos(theta(1)+theta(2)) + a3*cos(theta(1)+theta(2)+theta(3));
    x(2) = a1*sin(theta(1)) + a2*sin(theta(1)+theta(2)) + a3*sin(theta(1)+theta(2)+theta(3));
    
end
