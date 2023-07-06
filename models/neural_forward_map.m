function x = neural_forward_map(theta,forward_map_data)
    
    x = tanh(forward_map_data.map_in_weights*theta+forward_map_data.map_in_bias');
    for i = 1:forward_map_data.map_hidden_depth    
        x = tanh(forward_map_data.map_hidden_weights(:,:,i)*x+ forward_map_data.map_hidden_bias(:,:,i)');
    end
    x = (forward_map_data.map_out_weights*x+forward_map_data.map_out_bias');
    
end
