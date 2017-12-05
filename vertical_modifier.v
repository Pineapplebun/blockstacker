module vertical_modifier(
    input clk,
	 input go,
    input resetn,
    input next_signal,
	 output reg [10:0] speed_count,
	 output reg [3:0] num_blocks,
	 output reg [5:0] curr_level
    );

    reg [4:0] current_state, next_state;

    localparam
	   LEVEL1_WAIT = 5'd0,
		LEVEL1 = 5'd1,
		LEVEL2_WAIT = 5'd2,
		LEVEL2 = 5'd3,
		LEVEL3_WAIT = 5'd4,
		LEVEL3 = 5'd5,
		LEVEL4_WAIT = 5'd6,
		LEVEL4 = 5'd7,
		LEVEL5_WAIT = 5'd8,
		LEVEL5 = 5'd9,
		LEVEL6_WAIT = 5'd10,
		LEVEL6 = 5'd11,
		LEVEL7_WAIT = 5'd12,
		LEVEL7 = 5'd13,
		LEVEL8_WAIT = 5'd14,
		 LEVEL8 = 5'd15,
		 LEVEL9_WAIT = 5'd16,
		 LEVEL9 = 5'd17,
		 LEVEL10_WAIT = 5'd18,
		 LEVEL10 = 5'd19,
		 LEVEL11_WAIT = 5'd20,
		 LEVEL11 = 5'd21,
		 LEVEL12_WAIT = 5'd22,
		 LEVEL12 = 5'd23,
		 LEVEL13_WAIT = 5'd24,
		 LEVEL13 = 5'd25,
		 LEVEL14_WAIT = 5'D26,
		 LEVEL14 = 5'd27,
		 LEVEL15_WAIT = 5'd28,
		 LEVEL15 = 5'd29;

    always@(*)
    begin: level_table
        case (current_state)
		  LEVEL1_WAIT: next_state = go ? LEVEL1 : LEVEL1_WAIT;
        LEVEL1: next_state = next_signal ? LEVEL2_WAIT : LEVEL1_WAIT;

		  LEVEL2_WAIT: next_state = go ? LEVEL2 : LEVEL2_WAIT;
        LEVEL2: next_state = next_signal ? LEVEL3_WAIT : LEVEL1_WAIT;

		  LEVEL3_WAIT: next_state = go ? LEVEL4 : LEVEL3_WAIT;
        LEVEL3: next_state = next_signal ? LEVEL4_WAIT : LEVEL1_WAIT;

		  LEVEL4_WAIT: next_state = go ? LEVEL5 : LEVEL4_WAIT;
        LEVEL4: next_state = next_signal ? LEVEL5_WAIT : LEVEL1_WAIT;

		  LEVEL5_WAIT: next_state = go ? LEVEL6 : LEVEL5_WAIT;
        LEVEL5: next_state = next_signal ? LEVEL6_WAIT : LEVEL1_WAIT;

		  LEVEL6_WAIT: next_state = go ? LEVEL6 : LEVEL6_WAIT;
        LEVEL6: next_state = next_signal ? LEVEL7_WAIT : LEVEL1_WAIT;

		  LEVEL7_WAIT: next_state = go ? LEVEL7 : LEVEL7_WAIT;
        LEVEL7: next_state = next_signal ? LEVEL8_WAIT : LEVEL1_WAIT;

		  LEVEL8_WAIT: next_state = go ? LEVEL8 : LEVEL8_WAIT;
        LEVEL8: next_state = next_signal ? LEVEL9_WAIT : LEVEL1_WAIT;

		  LEVEL9_WAIT: next_state = go ? LEVEL9 : LEVEL9_WAIT;
        LEVEL9: next_state = next_signal ? LEVEL10_WAIT : LEVEL1_WAIT;

		  LEVEL10_WAIT: next_state = go ? LEVEL10 : LEVEL10_WAIT;
        LEVEL10: next_state = next_signal ? LEVEL11_WAIT : LEVEL1_WAIT;

		  LEVEL11_WAIT: next_state = go ? LEVEL11 : LEVEL11_WAIT;
        LEVEL11: next_state = next_signal ? LEVEL12_WAIT : LEVEL1_WAIT;

		  LEVEL12_WAIT: next_state = go ? LEVEL12 : LEVEL12_WAIT;
        LEVEL12: next_state = next_signal ? LEVEL13_WAIT : LEVEL1_WAIT;

		  LEVEL13_WAIT: next_state = go ? LEVEL13 : LEVEL13_WAIT;
        LEVEL13: next_state = next_signal ? LEVEL14_WAIT : LEVEL1_WAIT;

		  LEVEL14_WAIT: next_state = go ? LEVEL14 : LEVEL14_WAIT;
        LEVEL14: next_state = next_signal ? LEVEL15_WAIT : LEVEL1_WAIT;

		  LEVEL15_WAIT: next_state = go ? LEVEL15 : LEVEL15_WAIT;
        LEVEL15: next_state = LEVEL1_WAIT;//level15 is the max level. after that the game restarts
        default: next_state = LEVEL1_WAIT;
        endcase
    end // state_table

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 1
			speed_count = 11'd60;
			num_blocks = 4'b0001;
		   curr_level = 6'd1;
        case (current_state)
        LEVEL1_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd1; end// 1 FRAME PER SECOND
        LEVEL2_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd2;end// 2 FRAME PER SECOND
        LEVEL3_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd3;end//
        LEVEL4_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd4;end//
        LEVEL5_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd5;end//
        LEVEL6_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd6;end//
        LEVEL7_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd7;end//
        LEVEL8_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd8;end//
        LEVEL9_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd9;end//
        LEVEL10_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd10;end//
        LEVEL11_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd11;end//
        LEVEL12_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd12;end//
        LEVEL13_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd13;end//
        LEVEL14_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd14;end//
        LEVEL15_WAIT: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd15;end//

		  LEVEL1: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd1;end// 1 FRAME PER SECOND
        LEVEL2: begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd2;end// 2 FRAME PER SECOND
        LEVEL3 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd3;end//
        LEVEL4 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd4;end//
        LEVEL5 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd5;end//
        LEVEL6 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd6;end//
        LEVEL7 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd7;end//
        LEVEL8 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd8;end//
        LEVEL9 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd9;end//
        LEVEL10 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd10;end//
        LEVEL11 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd11;end//
        LEVEL12 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd12;end//
        LEVEL13 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd13;end//
        LEVEL14 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd14;end//
        LEVEL15 : begin speed_count = 11'd60; num_blocks = 4'b0001; curr_level = 6'd15;end//
        endcase
    end // enable_signals

    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(resetn)
            current_state <= LEVEL1_WAIT;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

