function x = forward_map_3R(theta,params)
    map_in_weights = params("map_in_weights");
    map_in_bias = params("map_in_bias") ;
    
    map_hidden_weights_1 = params("map_hidden_weights_1");
    map_hidden_bias_1 = params("map_hidden_bias_1");
    
    map_hidden_weights_2 = params("map_hidden_weights_2");
    map_hidden_bias_2 = params("map_hidden_bias_2");
    
    map_hidden_weights_3 = params("map_hidden_weights_3");
    map_hidden_bias_3 = params("map_hidden_bias_3");
    
    map_out_weights = params("map_out_weights");
    map_out_bias = params("map_out_bias");

    x1 = tanh(map_in_weights*theta+map_in_bias');
    x2 = tanh(map_hidden_weights_1*x1+map_hidden_bias_1');
    x3 = tanh(map_hidden_weights_2*x2+map_hidden_bias_2');
    x4 = tanh(map_hidden_weights_3*x3+map_hidden_bias_3');
    x = (map_out_weights*x4+map_out_bias');
    
end
