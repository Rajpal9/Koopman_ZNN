function z = lifting_3R(x,encode_in_weights,encode_in_bias,encode_hidden_weights_1,encode_hidden_bias_1,encode_hidden_weights_2,encode_hidden_bias_2,encode_out_weights,encode_out_bias)

    z1 = tanh(encode_in_weights*x+encode_in_bias');
    z2 = tanh(encode_hidden_weights_1*z1+encode_hidden_bias_1');
    z3 = tanh(encode_hidden_weights_2*z2+encode_hidden_bias_2');
    z = (encode_out_weights*z3+encode_out_bias');
    z = [1 x' z']';
end

