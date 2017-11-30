module delay_counter(enable, clk, resetn, enable_frame, speed_count);
	  input enable, clk, resetn;
      output reg enable_frame;
	  reg [22:0] counter;
	  input [31:0] speed_count;
		
	  always @(posedge clk)
	  begin
	       if (!resetn)
					// 3333333 IS 15 FRAMES PER SECOND
					// 5000000 IS 10 FRAMES PER SECOND
					// 50000000 IS 1 FRAMES PER SECOND
			      counter <= speed_count;//833332;
			  else if (enable == 1'b1)
			  begin
					if (counter == 22'd0)
						begin
						counter <= speed_count;//833332;
						enable_frame <= 1;
						end
					else
						begin
						counter <= counter - 1'b1;
						enable_frame <= 0;
						end
				end
	  end
endmodule

