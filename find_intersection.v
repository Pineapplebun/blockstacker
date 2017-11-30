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
        output reg [8:0] inter_block_start,
        output reg [8:0] inter_block_end,
        output reg [3:0] inter_block_size
        
		);

		always @(posedge clk)
		// defaults
		
		begin
		if (stop_true)
			begin
			if (!resetn)
				intersect_true <= 0;
			else if (curr_block_start == 0 && prev_block_end == 0)
				intersect_true <= 1'b1;
			else
				begin
				if (curr_block_start <= prev_block_start && curr_block_start >= prev_block_end)
                    begin
					intersect_true <= 1'b1;
                    inter_block_start <= curr_block_start;
                    inter_block_end <= prev_block_end;
                    inter_block_size = {(inter_block_start[8:0] - inter_block_end[8:0]) / 3'd4}
                    end
                else if (curr_block_end <= prev_block_start && curr_block_end >= prev_block_end)
                    begin
					intersect_true <= 1'b1;
                    inter_block_start <= prev_block_start;
                    inter_block_end <= curr_block_end;
                    inter_block_size = {(inter_block_start[8:0] - inter_block_end[8:0]) / 3'd4}
                    end
				else
					intersect_true <= 1'b0;
				end
			end
		else
			intersect_true <= 0;
		end

endmodule
