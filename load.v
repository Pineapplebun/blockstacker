
// LOADS THE NEW X,Y COORDINATES TO THE DATAPATH
module load(clk, reset, colour_in, colour_erase_enable, ld_x, ld_y, level_up_true, x, y, colour);
		input clk, reset;
		input [2:0] colour_in;
		input colour_erase_enable;
		input ld_x, ld_y;
		output reg [7:0] x;
		output reg [6:0] y;
		output reg [2:0] colour;

		reg horizontal;
		input [5:0] curr_level;

		always @ (posedge clk)
			begin
	      if (!reset)
				begin
				x <= 8'd0;
				horizontal <= 1'b1; // right
	        	end
	      else
				begin
	        	if (ld_x && ~colour_erase_enable) // WE WANT IT TO NOT CHANGE X,Y WHEN COLOUR ERASE IS ON
						begin
						if (horizontal)
								begin
								if (x == 156)
										begin
										horizontal <= 1'b0;
										x <= x - 4;
										end
								else
										x <= x + 4;
								end
						else
								begin
								if (x == 0)
										begin
										horizontal <= 1'b1;
										x <= x + 4;
										end
								else
										x <= x - 4;
								end
						end
				if (ld_y && ~colour_erase_enable)
					y <= 7'd116 - 4*curr_level;
					
			end
		
		// ONLY NEED TO CHANGE COLOUR SINCE X,Y ALREADY IN RIGHT SPOT
		// WHEN COLOUR_ERASE_ENABLE IS ON
		always @(*)
		begin
				if (colour_erase_enable)
					colour = 3'b000;
				else
					colour = colour_in;
		end
		
endmodule
