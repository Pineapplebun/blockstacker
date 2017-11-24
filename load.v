
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
		input level_up_true;
		
		always @ (posedge clk)
			begin
	      if (!reset)
				begin
				x <= 8'd0;
				horizontal <= 1'b1; // right
	        	end
	      else
				begin
	        	if (ld_x)
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
				
	  		end
		end
		y <= 116;
		always @(*)
				begin
						if (colour_erase_enable)
							colour = 3'b000;
						else
							colour = colour_in;
						
						if (ld_y)
							begin
							if (level_up_true) begin
									y <= y - 4;
									end
							end
					
				end
endmodule
