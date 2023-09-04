

module  tank2 ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [31:0] keycode,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input logic [9:0] cannonball1_X_Pos,
					input logic [9:0] cannonball1_Y_Pos,
					input logic ball_boom, game_start_flag,
					input right_stop2, left_stop2, up_stop2, down_stop2,
					input logic base_ruin,
					input logic tank1_ruin,
					input logic ball_air,
					output logic [9:0] tank2_upleft_X, tank2_upleft_Y,
               output logic  is_tank2,             // Whether current pixel belongs to ball or background
					output logic [1:0] tank2_direction,   // 00 up, 01 left, 10 down, 11 right
					output logic ball1_hit_tank2,
					output logic tank2_ruin
				  );
    
    parameter [9:0] tank2_X_lup = 10'd544;  // left-up position on the X axis
    parameter [9:0] tank2_Y_lup = 10'd0;  // left-up position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd80;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd559;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd2;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd477;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd15;        // tank size 16x16, radius
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
	 logic [1:0] tank2_dir, tank2_dir_in;
	 logic [26:0] time_counter, time_counter_in;
	 
	 
	 assign tank2_direction = tank2_dir;
	 assign tank2_upleft_X = Ball_X_Pos; 
	 assign tank2_upleft_Y = Ball_Y_Pos;
	 
	 logic tank_create,tank_ruin;
	 
	 assign tank2_ruin = tank_ruin;

	enum logic [2:0] {PRESSTWO, WAIT, TANKBOOM,REBORN} State, Next_State;
	 
	 always_ff @ (posedge Clk) 
	 begin
		if (Reset)
		begin
			State <= PRESSTWO;
			time_counter <= 27'b0;
		end
		else 
		begin
			State <= Next_State;
			time_counter <= time_counter_in;
		end
	 end
	 
	 always_comb 
	 begin
	 Next_State = State;
	 ball1_hit_tank2 = 1'b0;
	 time_counter_in = time_counter;
	 tank_ruin = 1'b0;
	 unique case (State)
		PRESSTWO:
		begin
			if(game_start_flag == 1'b1)
			begin
				Next_State = WAIT;
			end
			else
			begin
				Next_State = PRESSTWO;
			end	
		end
		WAIT:
		begin
			if(base_ruin == 1'b1)
			begin
				Next_State = PRESSTWO;
			end
			else if(cannonball1_X_Pos >= Ball_X_Pos && cannonball1_X_Pos <= Ball_X_Pos + Ball_Size 
				&& cannonball1_Y_Pos >= Ball_Y_Pos &&  cannonball1_Y_Pos <= Ball_Y_Pos + Ball_Size && ball_boom == 1'b0 && (ball_air == 1'b1 || tank1_ruin == 1'b0))
					begin
						Next_State = TANKBOOM;
					
					end
			else
			begin
				Next_State = WAIT;
			end
		end
		TANKBOOM:
		begin
					 // the counter need elaborated designed(exactly 1 at the 18th bit)  so that the siganl could be processed by the cannonbal.sv
					if(time_counter >= 27'b01000000000000000000000000 && ball_boom == 1'b0)
					begin
						
						Next_State = REBORN;
						time_counter_in = 27'b0;
					end
					else
					begin
						Next_State = TANKBOOM;
						time_counter_in = time_counter + 1'b1;
					end
						
		end
		REBORN:
		begin
					 // the counter need elaborated designed(exactly 1 at the 18th bit)  so that the siganl could be processed by the cannonbal.sv
					if(time_counter >= 27'b0101111101011110000100000000) // 2s for 50MHZ
					begin
						
						Next_State = PRESSTWO;
						time_counter_in = 27'b0;
					end
					else
					begin
						Next_State = REBORN;
						time_counter_in = time_counter + 1'b1;
					end
						
		end
	endcase
		
	 case (State)
		PRESSTWO:
			if(game_start_flag == 1'b1)
			begin
				tank_create = 1'b1;
			end
			else
			begin
				tank_create = 1'b0;
			end
		WAIT: 
			tank_create = 1'b0;
		TANKBOOM:
		begin
			ball1_hit_tank2 = 1'b1;
			tank_create = 1'b0;
			tank_ruin = 1'b1;
		end
		REBORN:
		begin
			tank_create = 1'b0;
			tank_ruin = 1'b1;
		end
	 endcase
	 end
	 
	 
    //logic flag ;
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
     // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset || tank_create)
        begin
            Ball_X_Pos <= tank2_X_lup; // note here we define the Ball_POS to be the upper left pixel of tank1
            Ball_Y_Pos <= tank2_Y_lup;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= 10'd0;
				tank2_dir <= 2'b01;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
				tank2_dir <= tank2_dir_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
        tank2_dir_in = tank2_dir;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
		  
		  
				
				if( keycode[7:0] == 8'h50 || keycode[15:8] == 8'h50 || keycode[23:16] == 8'h50 || keycode[31:24] == 8'h50 ) // 'J' left
					begin
					tank2_dir_in = 2'b01;
					if ( Ball_X_Pos  <= Ball_X_Min  || left_stop2)  // Ball is at the left edge, BOUNCE!
						begin
						 //flag = 1'b1;
						 Ball_Y_Motion_in = 10'd0;
						 Ball_X_Motion_in = 10'd0;
						end
					else
						begin
						Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
						Ball_Y_Motion_in = 10'd0;
						end
					end
				else if( keycode[7:0] == 8'h4F || keycode[15:8] == 8'h4F || keycode[23:16] == 8'h4F || keycode[31:24] == 8'h4F ) // 'L' right
					begin
					tank2_dir_in = 2'b11;
					if( Ball_X_Pos + Ball_Size >= Ball_X_Max || right_stop2)  // Ball is at the right edge, BOUNCE!
						begin
						 //flag = 1'b1;
						 Ball_Y_Motion_in = 10'd0;
						 Ball_X_Motion_in = 10'd0;  // 2's complement.  
						end
					else
						begin
						Ball_X_Motion_in = Ball_X_Step;
						Ball_Y_Motion_in = 10'd0;
						end
					end
				else if( keycode[7:0] == 8'h51 || keycode[15:8] == 8'h51 || keycode[23:16] == 8'h51 || keycode[31:24] == 8'h51 ) // 'K' down
					begin
					tank2_dir_in = 2'b10;
					if( Ball_Y_Pos + Ball_Size >= Ball_Y_Max || down_stop2)  // Ball is at the bottom edge, BOUNCE!
						 begin
						 //flag = 1'b1;
						 Ball_X_Motion_in = 10'd0;
						 Ball_Y_Motion_in = 10'd0;  // 2's complement.  
						 end
					 else
						 begin
							Ball_X_Motion_in = 10'd0;
							Ball_Y_Motion_in = Ball_Y_Step;
						 end
					end
				else if( keycode[7:0] == 8'h52 || keycode[15:8] == 8'h52 || keycode[23:16] == 8'h52 || keycode[31:24] == 8'h52 ) // 'I' up 
					begin
					tank2_dir_in = 2'b00;
					if ( Ball_Y_Pos <= Ball_Y_Min  || up_stop2)  // Ball is at the top edge, BOUNCE!
						begin
						 //flag = 1'b1;
						 Ball_Y_Motion_in = 10'd0;
						 Ball_X_Motion_in = 10'd0;
						end
					else
						begin
						Ball_X_Motion_in = 10'd0;
						Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);
						end
					end
				else
					begin
					Ball_X_Motion_in = 10'd0;
					Ball_Y_Motion_in = 10'd0;
					end
		  
					
				
            // Update the ball's position with its motion
            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
        end
    
    end
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;
    always_comb begin
        if (  tank_ruin == 1'b0 && DistX*DistX <= Size*Size  && DistY*DistY <= Size*Size && DrawX >= Ball_X_Pos && DrawY >= Ball_Y_Pos && game_start_flag == 1'b1) 
            is_tank2 = 1'b1;
        else
            is_tank2 = 1'b0;
       
    end
    
endmodule
