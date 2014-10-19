import lc3b_types::*;

module cccomp
(
	input lc3b_reg NZP,
	input lc3b_nzp nzp,
	output logic out
);

always_comb
begin
	if ( |(NZP & nzp) )
		out = 1'b1;
	else
		out = 1'b0;
end

endmodule : cccomp