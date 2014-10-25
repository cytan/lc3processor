import lc3b_types::*;

module decoder_3to8 #(parameter width = 16)
(
	input lc3b_dec3sel sel,
	output logic [width-1:0] dec_out[7:0]
);	

always_comb
begin
	for (int i = 0; i < $size(dec_out); i++)
    begin
        dec_out[i] = 1'b0;
    end
	for (int i = 0; i < width; i++) begin
		dec_out[sel][i] = 1;
	end
end

endmodule: decoder_3to8
	