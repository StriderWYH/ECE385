
module  cannonball1 ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [31:0] keycode,
					input logic [9:0] tank1_upleft_X, tank1_upleft_Y,
					input logic [1:0] tank1_direction,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input logic ball_hit,						// indicate whether the cannonbal has hit an object
               input logic game_start_flag,
					output logic  is_ball1,             // Whether current pixel belongs to ball or background
				   output logic  is_boom1,
					output logic 	[9:0] cannonball_X_Pos,
					output logic 	[9:0] cannonball_Y_Pos,
					// debug signal
					output logic is_fire,
					output logic ball1_air,
					output logic ball_rdy,
					// usage signal
					output logic ball1_boom
				  );
    

    parameter [9:0] cannonball_X_Min = 10'd79;       // central point on the X axis
    parameter [9:0] cannonball_X_Max = 10'd559;     // central point on the X axis
    parameter [9:0] cannonball_Y_Min = 10'd3;       // Topmost point on the Y axis
    parameter [9:0] cannonball_Y_Max = 10'd477;     // Bottommost point on the Y axis
    parameter [9:0] cannonball_X_Step = 10'd3;      // Step size on the X axis
    parameter [9:0] cannonball_Y_Step = 10'd3;      // Step size on the Y axis
    parameter [9:0] cannonball_Size = 10'd2;        // cannonball size 5x5, radius
	 parameter [9:0] boom_Size = 10'd7;
    
    logic [9:0]  cannonball_X_Motion, cannonball_Y_Motion;
    logic [9:0] cannonball_X_Pos_in, cannonball_Y_Pos_in;
	 logic [26:0] time_counter, boom_counter,time_counter_in, boom_counter_in;
	 
	 logic ball_in_air;
	 logic ball_to_boom;
	 logic ball_in_boom;	 
	 logic fire;
	 logic ball_ready;
	  
	 assign ball_rdy = ball_ready;
	 
	 assign ball1_air = ball_in_air;
	 
	 assign ball1_boom = ball_in_boom;
	 
	 always_comb
	 begin
			fire = ((keycode[7:0] == 8'h20 || keycode[15:8] == 8'h20 || keycode[23:16] == 8'h20 || keycode[31:24] == 8'h20) && game_start_flag == 1'b1 ); 
	 end
	 
	 assign is_fire = fire;
    //logic flag ;
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 
	 
	 
	 // State machine of fire
	 enum logic [2:0] {LOAD, READY, FIRE, AIR, BOOM} State, Next_State;
	 
	always_ff @ (posedge Clk) 
	begin
		if (Reset) 
		begin
			State <= LOAD;
			time_counter <= 27'b0;
			boom_counter <= 27'b0;
		end
		else
		begin
			State <= Next_State;
			time_counter <= time_counter_in;
			boom_counter <= boom_counter_in;
		end
	end
	

	always_comb
	begin
	Next_State = State;
	time_counter_in = time_counter;
	boom_counter_in = boom_counter;
	ball_in_air = 1'b0;
	ball_in_boom = 1'b0;
	ball_ready = 1'b0;
	unique case (State)
		LOAD:
			Next_State = READY;
		READY:
		begin
			if(fire == 1'b1)
			begin
				Next_State = FIRE;
			end
			else
			begin
				Next_State = READY;
			end
		end
		FIRE:
			Next_State = AIR;
		AIR:
		begin
			if(time_counter == 27'b100000000000000000000000000 || ball_to_boom == 1'b1)
			begin
				Next_State = BOOM;
			end
			else
			begin
				Next_State = AIR;
			end
		end	
		BOOM:
		begin
			if(boom_counter == 27'b100000000000000000000000000)
			begin
				Next_State = LOAD;
			end
			else
			begin
				Next_State = BOOM;
			end
		end
	endcase
	
	case(State)
		LOAD:
		begin
			time_counter_in = 27'b0;
			boom_counter_in  = 27'b0;
			ball_ready = 1'b1;
		end
		READY:
		begin
			time_counter_in = 27'b0;
			boom_counter_in  = 27'b0;
			ball_ready = 1'b1;
		end
		FIRE:
		begin
			time_counter_in = 27'b0;
			boom_counter_in  = 27'b0;
			ball_ready = 1'b0;
		end
		AIR:
		begin
			time_counter_in = time_counter + 1'b1;
			boom_counter_in  = 27'b0;
			ball_in_air = 1'b1;
			ball_ready = 1'b0;
		end
		BOOM:
		begin
			time_counter_in = 27'b0;
			boom_counter_in  = boom_counter + 1'b1;
			ball_in_boom = 1'b1;
			ball_ready = 1'b0;
		end
	endcase	
	 
	end 
     // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset || (ball_ready == 1'b1))
        begin
				case(tank1_direction)
					2'b00:  
						begin
						cannonball_X_Pos <= tank1_upleft_X + 7 ;       //up
						cannonball_Y_Pos <= tank1_upleft_Y - 3;
						cannonball_X_Motion <= 10'd0;
						cannonball_Y_Motion <= ((~cannonball_Y_Step) + 1'b1) ;
						end
					2'b01:  
						begin
						cannonball_X_Pos <= tank1_upleft_X - 3 ;		//left
						cannonball_Y_Pos <= tank1_upleft_Y + 7;
						cannonball_X_Motion <= ((~cannonball_X_Step) + 1'b1);
						cannonball_Y_Motion <= 10'd0 ;
						end
					2'b10:  
						begin
						cannonball_X_Pos <= tank1_upleft_X + 7 ;     //down
						cannonball_Y_Pos <= tank1_upleft_Y + 18;
						cannonball_X_Motion <= 10'd0;
						cannonball_Y_Motion <= cannonball_Y_Step ;
						end
					2'b11:  
						begin
						cannonball_X_Pos <= tank1_upleft_X + 18;       //right
						cannonball_Y_Pos <= tank1_upleft_Y + 7;
						cannonball_X_Motion <= cannonball_X_Step;
						cannonball_Y_Motion <= 10'd0 ;
						end
				endcase
             // note here we define the Ball_POS to be the upper left pixel of tank1
        end
        else
        begin
            cannonball_X_Pos <= cannonball_X_Pos_in;
            cannonball_Y_Pos <= cannonball_Y_Pos_in;
            cannonball_X_Motion <= cannonball_X_Motion;  // cannon ball's motion won't be redirected
            cannonball_Y_Motion <= cannonball_Y_Motion;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        cannonball_X_Pos_in = cannonball_X_Pos;
        cannonball_Y_Pos_in = cannonball_Y_Pos;
		  ball_to_boom = 1'b0;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
				if(ball_in_air == 1'b1)
					begin
						if( (cannonball_X_Pos + cannonball_Size) >= cannonball_X_Max 
						|| (cannonball_Y_Pos + cannonball_Size) >= cannonball_Y_Max 
						|| (cannonball_X_Pos  <= cannonball_X_Min + cannonball_Size) 
						|| (cannonball_Y_Pos  <= cannonball_Y_Min + cannonball_Size)
						|| ball_hit == 1'b1)
						begin
							ball_to_boom = 1'b1;
							
						end
						else
						begin
							cannonball_X_Pos_in = cannonball_X_Pos + cannonball_X_Motion;
							cannonball_Y_Pos_in = cannonball_Y_Pos + cannonball_Y_Motion;
						end
					
					end
					
				
            // Update the ball's position with its motion
            
        end
      
    end
    
  
    int Size;
    assign Size = cannonball_Size;
    always_comb 
	 begin
			is_ball1 = 1'b0;
			is_boom1 = 1'b0;
        if ( DrawX <= cannonball_X_Pos + Size && DrawX + Size >= cannonball_X_Pos
		  &&  DrawY <= cannonball_Y_Pos + Size && DrawY + Size >= cannonball_Y_Pos  && ball_in_air == 1'b1)
			begin
            is_ball1 = 1'b1;
			end
        else if  ( DrawX <= cannonball_X_Pos + boom_Size && DrawX + boom_Size  >= cannonball_X_Pos  
		  &&  DrawY <= cannonball_Y_Pos + boom_Size && DrawY + boom_Size >= cannonball_Y_Pos  && ball_in_boom == 1'b1) 
		  begin
				is_boom1 = 1'b1;
		  end
       
    end
    
endmodule
