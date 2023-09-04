/****

This is a read-only On-chip memory module, including the sprite of two tanks, and 4 directions for each.

**/
module  spriteallROM
(
		input [18:0] read_address,
		input Clk,
		output logic [23:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [23:0] mem [0:2383];

initial
begin
	 $readmemh("sprite_bytes/spriteall.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule