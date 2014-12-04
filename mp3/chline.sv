import lc3b_types::*;

module chline
(
	input 	offset,
	input [255:0]	a,
	input [127:0]	b,
	output logic [255:0]	f
);

always_comb
begin
	if (offset)
		f = {b, a[127:0]};
	else
		f = {a[255:128], b};
end

endmodule : chline