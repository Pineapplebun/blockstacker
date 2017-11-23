module find_intersection(
		input resetn,
		input stop_true,
		input [8:0] prev_block_start,
		input [8:0] prev_block_end,
		input [8:0] curr_block_start,
		input [8:0] curr_block_end,
		input [3:0] prev_block_size,
		input [3:0] curr_block_size,
		output intersect_true,
		);

		always @(*)
		// defaults
		
		begin
		if (stop_true)
			begin
			if (prev_block_start== 0 && prev_block_end == 0)
				begin
				if (curr_block_start>= prev_block_start && curr_block_start <= prev_block_end)
					intersect_true = 1'b1;
				else
					intersect_true = 1'b0;
				end
			else
				intersect_true = 1'b1;
			end
		end

endmodule
