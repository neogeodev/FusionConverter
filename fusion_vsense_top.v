// Fusion converter
// For CHA8 (rev. H) and up with UnderVoltage Detection

module fusion_vsense(
	input clk,	// 12M
	input nUVD,
	input even,
	input load,
	input h,
	input [31:0] c,
	output reg [3:0] bd, ad,
	output reg dotb, dota,
	input clk24M,
	output reg clk8M,
	output LED
);

reg [3:0] timer;
reg [2:0] por_delay = 0;
reg [31:0] sr;
reg [1:0] cntpos;
reg [1:0] cntneg;
reg evenr;

defparam I1.TIMER_DIV = "1048576";	// 5Hz
OSCTIMER I1 (.DYNOSCDIS(1'b0), .TIMERRES(1'b0), .OSCOUT(oscout), .TIMEROUT(blink));

// nUVD low: Undervoltage warning, LED blinks for ~6 seconds
// nUVD high: Voltage ok, LED stays on
assign LED = ~&{|{timer}, blink};

// T B LED
// 0 0 1   Ok, always on
// 0 1 1   Ok, always on
// 1 0 1   Blink
// 1 1 0   Blink

always @(posedge blink or negedge nUVD) begin
	if (!nUVD) begin
		if (por_delay == 3'd7)
			timer <= 4'd15;		// Reset 3-second timer
	end else begin
		if (timer)
			timer <= timer - 1'b1;
	end
end

// Only enable UVD 7/5=1.4s after power-up
always @(posedge blink) begin
	if (por_delay != 3'd7)
		por_delay <= por_delay + 1'b1;
end

always @(negedge clk) begin
	if (load)
		sr <= c;
	else if (h)
		sr <= {sr[29:24], 2'b00, sr[21:16], 2'b00, sr[13:8], 2'b00, sr[5:0], 2'b00};
	else
		sr <= {2'b00, sr[31:26], 2'b00, sr[23:18], 2'b00, sr[15:10], 2'b00, sr[7:2]};

	evenr <= even;
end

always @(*) begin
	case ({evenr, h})
		3: {bd, ad} <= {sr[31], sr[23], sr[15], sr[7], sr[30], sr[22], sr[14], sr[6]};
		2: {bd, ad} <= {sr[24], sr[16],  sr[8], sr[0], sr[25], sr[17],  sr[9], sr[1]};
		1: {bd, ad} <= {sr[30], sr[22], sr[14], sr[6], sr[31], sr[23], sr[15], sr[7]};
		0: {bd, ad} <= {sr[25], sr[17],  sr[9], sr[1], sr[24], sr[16],  sr[8], sr[0]};
	endcase
	
	{dotb, dota} <= {|bd, |ad};
	
	clk8M <= ((cntpos != 2) && (cntneg != 2));
end

always @ (posedge clk24M) begin
	cntpos <= (cntpos == 2) ? 0 : cntpos + 1;
end

always @ (negedge clk24M) begin
	cntneg <= (cntneg == 2) ? 0 : cntneg + 1;
end

endmodule

