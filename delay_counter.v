module delay_counter(enable, clk, resetn, enable_frame);
	  input enable, clk, resetn;
      output enable_frame;
	  reg [22:0] counter;

	  assign enable_frame = (counter == 0) ? 1 : 0;

	  always @(posedge clk)
	  begin
	       if (!resetn)
			      counter <= 833332;
			  else if (enable == 1'b1)
			  begin
					if (counter == 22'd0)
						counter <= 833332;
					else
						counter <= counter - 1'b1;
				end
	  end
endmodule

