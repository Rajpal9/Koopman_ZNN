function xo = output_fcn(z,u,C,params)

    map_in_weights = params("map_in_weights");
    map_in_bias = params("map_in_bias");

    map_hidden_weights_1 = params("map_hidden_weights_1");
    map_hidden_bias_1 = params("map_hidden_bias_1");

    map_hidden_weights_2 = params("map_hidden_weights_2");
    map_hidden_bias_2 = params("map_hidden_bias_2");

    map_hidden_weights_3 = params("map_hidden_weights_3");
    map_hidden_bias_3 = params("map_hidden_bias_3");

    map_out_weights = params("map_out_weights");
    map_out_bias = params("map_out_bias");
    
    s1 = map_in_weights*C*z+map_in_bias';
    x1 = tanh(s1);
    s2 = map_hidden_weights_1*x1+map_hidden_bias_1';
    x2 = tanh(s2);
    s3 = map_hidden_weights_2*x2+map_hidden_bias_2';
    x3 = tanh(s3);
    s4 = map_hidden_weights_3*x3+map_hidden_bias_3';
    x4 = tanh(s4);
    xo = map_out_weights*x4 + map_out_bias';
end