function z = lifting(x, encoder)

    z = tanh(encoder.encoder_in_weights*x+encoder.encoder_in_bias');
    for i = 1:encoder.encoder_hidden_depth
        z = tanh(encoder.encoder_hidden_weights(:,:,i)*z+encoder.encoder_hidden_bias(:,:,i)');
    end
    z = (encoder.encoder_out_weights*z+encoder.encoder_out_bias');
    z = [1 x' z']';
end