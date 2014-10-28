import lc3b_types::*;

module hlbyte
(
	input lc3b_word in,
	input hl,
	output lc3b_word out
);

always_comb
begin
	if (hl == 1)
		out = $unsigned(in[15:8]);
	else
		out = $unsigned(in[7:0]);
end

endmodule: hlbyte