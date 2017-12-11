module find_intersection(
		input clk,
		input resetn,
		input stop_true,
		input [8:0] prev_block_start,
		input [8:0] prev_block_end,
		input [8:0] curr_block_start,
		input [8:0] curr_block_end,
		input [3:0] prev_block_size,
		input [3:0] curr_block_size,
		output reg intersect_true,
		input reset_intersect_true,
		output reg done_finding
		);

		always @(*)
		// defaults
		begin
		if (resetn)
				begin
				intersect_true = 0;
				done_finding = 0;
				end
		else if (reset_intersect_true)
				begin
				intersect_true = 0;
				done_finding = 0;
				end
		else if (stop_true)
			begin
			if (prev_block_start == 0 && prev_block_end == 0)
				begin
				intersect_true = 1;
				done_finding = 1;
				end
			else
				begin
				if (curr_block_start == prev_block_start && curr_block_end == prev_block_end)
					begin
					intersect_true = 1;
					done_finding = 1;
					end
				else
					begin
					intersect_true = 0;
					done_finding = 1;
					end
				end
			end
		end
		

endmodule
