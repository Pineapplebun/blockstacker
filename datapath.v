module datapath(
		input clk,
		input resetn,
		input count_x_enable,
		input [7:0] x,
		input [6:0] y,
		input [2:0] colour,
		output [7:0] x_out,
		output [6:0] y_out,
		output [2:0] colour_out,
		output reg done_plot,
		output reg out_block_start,
		output reg out_block_end
		);

		reg [1:0] count_x, count_y;

		wire enable_y;

		// counter for x
		always @(posedge clk) begin
			if (resetn)
				count_x <= 2'b00;
			else if (count_x_enable)
				count_x <= count_x + 1'b1;
		end

		// enable y to increase 1 after 4 increases in count_x
		assign enable_y = (count_x == 2'b11) ? 1 : 0;

		// counter for y
		always @(posedge clk) begin
			if (resetn)
				count_y <= 2'b00;
			else if (enable_y)
				count_y <= count_y + 1'b1;
		end

		// SET PLOT TO BE DONE AFTER COUNTING ALL
		// THE PIXELS OF THE SQUARE
		always @(*)
		begin
		if (count_x == 2'b11 && count_y == 2'b11)
			begin
			done_plot = 1'b1;
			out_block_start <= x;
			out_block_end <= x_out;
			end
		else
			done_plot = 1'b0;
		end

		assign x_out = x + count_x;
		assign y_out = y + count_y;
		assign colour_out = colour;

endmodule
