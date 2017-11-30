
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
		
		
		// We want to change the x,y at the negedge because we want the black box to be drawn
		// at the current x,y first before changing it.
		always @ (negedge clk) // clk is enable_erase, which occurs 1 every speed_count frames
		begin
	      if (!reset)
				begin
				x <= 8'd0;
				horizontal <= 1'b1; // right
	        	end
	      else
				// NOTE THAT LD_X AND LD_Y IS NOT ON WHEN WE ARE IN THE ERASE STATE
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

				y <= 7'd116 - 4*curr_level;
				
					
			end
		
		// ONLY NEED TO CHANGE COLOUR SINCE X,Y ALREADY IN RIGHT SPOT
		// WHEN COLOUR_ERASE_ENABLE IS ON AT THE POSEDGE OF ENABLE_ERASE
		always @(*) 
		begin
				if (colour_erase_enable) // need to add ~stop_true this so that it doesn't erase the current position
					colour <= 3'b000;
				else
					colour <= colour_in;
		end
		
endmodule
