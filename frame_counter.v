module frame_counter(enable, clk, resetn, enable_out, speed_count);
		input enable, clk, resetn;
		output reg enable_out;
		input [3:0] speed_count;

		reg [3:0] frames;

		// When 1 frames reached, set enable_out to be 1
		// So that we start erasing the box on the next
		// frame

		always @ (posedge clk)
				begin
						if (!resetn)
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
