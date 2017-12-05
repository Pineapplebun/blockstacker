module frame_counter(enable, clk, reset_frame_counter, enable_out, speed_count, frames);
		input enable, clk, reset_frame_counter;
		output reg enable_out;
		input [10:0] speed_count;
		

		output reg [7:0] frames;

		// When 1 frames reached, set enable_out to be 1
		// So that we start erasing the box on the next
		// frame

		always @ (posedge clk)
				begin
						if (!reset_frame_counter)
							begin
							frames <= 8'd0;
							enable_out <= 0;
							end
						else if (enable == 1'b1)
						begin
							if (frames == speed_count[7:0])
								begin
								frames <= 8'd0;
								enable_out <= 1;
								end
							else
								begin
								frames <= frames + 8'd1;
								enable_out <= 0;
								end
						end
				end
endmodule
