module frame_counter(enable, clk, resetn, enable_out);
		input enable, clk, resetn;
		output reg enable_out;

		reg [3:0] frames;

		// When 15 frames reached, set enable_out to be 1
		// So that we start erasing

		always @ (posedge clk)
				begin
						if (!resetn)
							frames <= 4'b0000;
						else if (enable == 1'b1)
						begin
							if (frames == 4'b1111)
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
