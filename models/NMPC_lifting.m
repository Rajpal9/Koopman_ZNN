function z = NMPC_lifting(x, encoder)

    z = tanh(double(encoder.encoder_in_weights)*x+double(encoder.encoder_in_bias)');
    for i = 1:encoder.encoder_hidden_depth
        z = tanh(double(encoder.encoder_hidden_weights(:,:,i))*z+double(encoder.encoder_hidden_bias(:,:,i))');
    end
    z = (double(encoder.encoder_out_weights)*z+double(encoder.encoder_out_bias)');
    z = [1 x' z']';
end