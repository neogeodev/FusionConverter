module ct0
(
	input clk,	//12M
	input even,
	input load,
	input h,
	output reg timeout,
	input timein,
	input [31:0] c,
	output reg [3:0] bd, ad,
	output reg dotb, dota,
	input clk24M,
	output reg clk8M
);

reg [31:0] sr;
reg [1:0] cntpos;
reg [1:0] cntneg;
reg evenr;

always @(negedge clk)
begin
	if (load) sr <= c;
	else if (h) sr <= {sr[29:24], 2'b00, sr[21:16], 2'b00, sr[13:8], 2'b00, sr[5:0], 2'b00};
	else sr <= {2'b00, sr[31:26], 2'b00, sr[23:18], 2'b00, sr[15:10], 2'b00, sr[7:2]};
	
	evenr <= even;
end

always @*
begin
	case ({evenr, h})
		3: {bd, ad} <= {sr[31], sr[23], sr[15], sr[7], sr[30], sr[22], sr[14], sr[6]};
		2: {bd, ad} <= {sr[24], sr[16],  sr[8], sr[0], sr[25], sr[17],  sr[9], sr[1]};
		1: {bd, ad} <= {sr[30], sr[22], sr[14], sr[6], sr[31], sr[23], sr[15], sr[7]};
		0: {bd, ad} <= {sr[25], sr[17],  sr[9], sr[1], sr[24], sr[16],  sr[8], sr[0]};
	endcase
	
	{dotb, dota} <= {|bd, |ad};
	
	clk8M <= ((cntpos != 2) && (cntneg != 2));
end

always @ (posedge clk24M)
begin
	cntpos <= (cntpos == 2) ? 0 : cntpos + 1;
end

always @ (negedge clk24M)
begin
	cntneg <= (cntneg == 2) ? 0 : cntneg + 1;
end

endmodule
