module frame_counter(enable, clk, resetn, enable_out);
		input enable, clk, resetn;
		output enable_out;

		reg [3:0] frames;

		// When 15 frames reached, set enable_out to be 1
		// So that we start erasing
		assign enable_out= (frames == 4'b1111) ? 1 : 0;

		always @ (posedge clk)
				begin
						if (!resetn)
							frames <= 0;
						else if (enable == 1'b1)
						begin
							if (frames == 4'b1111)
								frames <= 0;
							else
							frames <= frames + 1;
						end
				end
endmodule
