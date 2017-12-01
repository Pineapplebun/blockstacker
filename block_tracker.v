module block_tracker(
		input clk,
		input resetn,
		input stop_true,
		output reg [8:0] prev_block_start,
		output reg [8:0] prev_block_end,
		input [8:0] curr_block_start,
		input [8:0] curr_block_end,
		output reg [3:0] prev_block_size,
		input [3:0] curr_block_size,
		input intersect_true
		);

		always @(*)
		// defaults
			begin
			if (resetn || (stop_true && ~intersect_true))
				begin
				prev_block_start = 0;
				prev_block_end = 0;
				prev_block_size = 0;
				end
			else if (stop_true && intersect_true)
				begin
				prev_block_start = curr_block_start;
				prev_block_end = curr_block_end;
				prev_block_size = curr_block_size;
				end
			end
		
endmodule
