function W = NMPC_neural_jacobian(z,u,C,forward_map_data)
    s = double(forward_map_data.map_in_weights)*C*z + double(forward_map_data.map_in_bias)';
    s_dot = double(forward_map_data.map_in_weights)*C;
    x = tanh(s);
    x_dot = diag((sech(s)).^2)*s_dot;
    for i = 1:forward_map_data.map_hidden_depth
        s = double(forward_map_data.map_hidden_weights(:,:,i))*x+double(forward_map_data.map_hidden_bias(:,:,i))';
        s_dot = double(forward_map_data.map_hidden_weights(:,:,i))*x_dot;
        x = tanh(s);
        x_dot = diag((sech(s)).^2)*s_dot;

        
    end
    W = double(forward_map_data.map_out_weights)*x_dot;
    

end    
