module frame_counter(enable, clk, reset_frame_counter, enable_out, speed_count);
		input enable, clk, reset_frame_counter;
		output reg enable_out;
		input [3:0] speed_count;

		reg [3:0] frames;

		// When 1 frames reached, set enable_out to be 1
		// So that we start erasing the box on the next
		// frame

		always @ (posedge clk)
				begin
						if (!reset_frame_counter)
							frames <= 4'b0000;
						else if (enable == 1'b1)
						begin
							if (frames == speed_count)
								begin
								frames <= 4'b0000;
								enable_out <= 1;
								end
							else
							begin
							frames <= frames + 4'b0001;
							enable_out <= 0;
							end
						end
				end
endmodule
