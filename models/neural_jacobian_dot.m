function W_dot = neural_jacobian_dot(theta, theta_dot,forward_map_data)
    
    s = forward_map_data.map_in_weights*theta + forward_map_data.map_in_bias';
    s_dot = forward_map_data.map_in_weights;
    x_ddot = -diag(tanh(s).*sech(s).*(s_dot*theta_dot))*s_dot;
    
    x = tanh(s);
    x_dot = diag((sech(s)).^2)*s_dot;
    for i = 1:forward_map_data.map_hidden_depth
        s = forward_map_data.map_hidden_weights(:,:,i)*x+forward_map_data.map_hidden_bias(:,:,i)';
        s_dot = forward_map_data.map_hidden_weights(:,:,i)*x_dot;
        x = tanh(s);
        x_dot = diag((sech(s)).^2)*s_dot;
        x_ddot = -diag((tanh(s).*sech(s)).*(s_dot*theta_dot))*s_dot + x_dot.*x_ddot;
      
    end
    W_dot = forward_map_data.map_out_weights*x_ddot;
end    
