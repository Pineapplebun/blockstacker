
// LOADS THE NEW X,Y COORDINATES TO THE DATAPATH
module load(clk, reset_load, colour_in, colour_erase_enable, ld_x, ld_y, x, y, colour, curr_level, done_load);
		input clk, reset_load;
		input [2:0] colour_in;
		input colour_erase_enable;
		input ld_x, ld_y;
		output reg [7:0] x;
		output reg [6:0] y;
		output reg [2:0] colour;
		output reg done_load;

		reg horizontal;
		input [5:0] curr_level;

		always @ (*)
		begin
	      if (!reset_load)

				begin
				x = 8'd0;
				y = 7'd116;
				horizontal = 1'b1; // right
				done_load = 0;
	        	end

	      else
				begin
				if (ld_x)
					begin
					done_load = 0;
					if (horizontal)
							begin
							if (x == 156)
									begin
									horizontal = 1'b0;
									x = x - 4;
									end
							else
									x = x + 4;
							end
					else
							begin
							if (x == 0)
									begin
									horizontal = 1'b1;
									x = x + 4;
									end
							else
									x = x - 4;
							end
					y = 7'd120 - 4*curr_level;
					done_load = 1;
					end
			 end
		end

		// ONLY NEED TO CHANGE COLOUR SINCE X,Y ALREADY IN RIGHT SPOT
		// WHEN COLOUR_ERASE_ENABLE IS ON AT THE POSEDGE OF ENABLE_ERASE
		always @(*)
		begin
				if (colour_erase_enable)
					colour <= 3'b000;
				else
					colour <= colour_in;
		end

endmodule
