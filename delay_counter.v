module delay_counter(enable, clk, resetn, enable_frame);
	  input enable, clk, resetn;
      output reg enable_frame;
	  reg [22:0] counter;
		
	  always @(posedge clk)
	  begin
	       if (!resetn)
			      counter <= 3333333;//833332;
			  else if (enable == 1'b1)
			  begin
					if (counter == 22'd0)
						begin
						counter <= 3333333;//833332;
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

