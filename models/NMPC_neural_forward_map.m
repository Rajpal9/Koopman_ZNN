function x = NMPC_neural_forward_map(z,u,C,forward_map_data)
    
    x = tanh(double(forward_map_data.map_in_weights)*C*z+double(forward_map_data.map_in_bias)');
    for i = 1:forward_map_data.map_hidden_depth    
        x = tanh(double(forward_map_data.map_hidden_weights(:,:,i))*x+ double(forward_map_data.map_hidden_bias(:,:,i))');
    end
    x = (double(forward_map_data.map_out_weights)*x+double(forward_map_data.map_out_bias)');
    
end
