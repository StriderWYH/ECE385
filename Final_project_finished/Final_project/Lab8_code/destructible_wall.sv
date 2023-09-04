
module  destructible_wall ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [31:0] keycode,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input logic [9:0] tank1_upleft_X, tank1_upleft_Y,
					input logic [9:0] tank2_upleft_X, tank2_upleft_Y,
					input logic [9:0] cannonball1_X_Pos,
					input logic [9:0] cannonball1_Y_Pos,
					input logic [9:0] cannonball2_X_Pos,
					input logic [9:0] cannonball2_Y_Pos,
					input logic ball1_boom,ball1_air,
					input logic ball2_boom,ball2_air,
					input logic [9:0] X_MAX, X_MIN, Y_MAX, Y_MIN,
					input logic game_start_flag,
					input logic before_game_flag,
               output logic  is_dewall,             // Whether current pixel belongs to ball or background
					output logic  ball1_hit_dwall,
					output logic  ball2_hit_dwall,
					output logic right_stop1, left_stop1, up_stop1, down_stop1,
					output logic right_stop2, left_stop2, up_stop2, down_stop2
				  );
				  
		
		logic [9:0] Base1_X_MAX,Base1_X_MIN,Base1_Y_MAX,Base1_Y_MIN;
		
		
		assign Base1_X_MAX = X_MAX;  // base position for the enemy of tank1， which is fixed
		assign Base1_X_MIN = X_MIN;  // left-up position on the Y axis		
		assign Base1_Y_MAX = Y_MAX;
		assign Base1_Y_MIN = Y_MIN;
		
		
		
		logic [26:0] time_counter, time_counter_in;
		logic dewall_ruin;
		
	 enum logic [4:0] {NEWBASE, BASERUIN1,BASERUIN2,BASEOVER} State, Next_State;
	 
	 
	 
	 always_ff @ (posedge Clk) 
	 begin
		if (Reset)
		begin
			State <= NEWBASE;                // When newgame started, the base should be refreshed
			
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
		 dewall_ruin = 1'b0;
		 ball1_hit_dwall = 1'b0;
		 ball2_hit_dwall = 1'b0;
		 time_counter_in = time_counter;

		 unique case (State)
			NEWBASE:
			begin

					if(cannonball1_X_Pos >= Base1_X_MIN && cannonball1_X_Pos <= Base1_X_MAX 
						&& cannonball1_Y_Pos >= Base1_Y_MIN &&  cannonball1_Y_Pos <= Base1_Y_MAX && ball1_air == 1'b1)
					begin
						Next_State = BASERUIN1;
						time_counter_in = 27'b0;
					
					end
					else if(cannonball2_X_Pos >= Base1_X_MIN && cannonball2_X_Pos <= Base1_X_MAX 
						&& cannonball2_Y_Pos >= Base1_Y_MIN &&  cannonball2_Y_Pos <= Base1_Y_MAX && ball2_air == 1'b1)
					begin
						Next_State = BASERUIN2;
						time_counter_in = 27'b0;
					
					end
					else 
					begin
						Next_State = NEWBASE;
					end
			end
		
			
			BASERUIN1:
			begin
			if(time_counter >= 27'b01000000000000000000000000 && ball1_boom == 1'b0)
				begin
					Next_State = BASEOVER;
					time_counter_in = 27'b0;
					//time_counter_in = 27'b0;
				end
				else
				begin
					Next_State = BASERUIN1;
					time_counter_in = time_counter + 1'b1;
				end
			end
			
			BASERUIN2:
			begin
			if(time_counter >= 27'b01000000000000000000000000 && ball2_boom == 1'b0)
				begin
					Next_State = BASEOVER;
					time_counter_in = 27'b0;
					//time_counter_in = 27'b0;
				end
				else
				begin
					Next_State = BASERUIN2;
					time_counter_in = time_counter + 1'b1;
				end
			end
			
			BASEOVER:
			begin
				if(before_game_flag == 1'b1)
				begin
					Next_State = NEWBASE;
				end
				else
				begin
					Next_State = BASEOVER;
				end
			end
			
			endcase
			
			
		 case (State)
			NEWBASE:
			begin
				time_counter_in = 27'b0;
				
			end
			BASERUIN1:
			begin
				dewall_ruin = 1'b1;
				ball1_hit_dwall = 1'b1;
				
			end
			BASERUIN2:
			begin
				dewall_ruin = 1'b1;
				ball2_hit_dwall = 1'b1;
				
			end
			BASEOVER:
			begin
				dewall_ruin = 1'b1;
				
			end	
		 endcase
	 end
	 
	
	 
	always_comb
	begin
		right_stop1 = 0;
		left_stop1 = 0;
		up_stop1 = 0; 
		down_stop1 = 0;
		if(dewall_ruin == 0)
		begin
			if ((tank1_upleft_X+1 >= Base1_X_MIN && tank1_upleft_X+1 <= Base1_X_MAX
			&& tank1_upleft_Y >= Base1_Y_MIN+3 && tank1_upleft_Y <= Base1_Y_MAX+3 )
			||(tank1_upleft_X+15-1 >= Base1_X_MIN && tank1_upleft_X+15-1 <= Base1_X_MAX
			&& tank1_upleft_Y >= Base1_Y_MIN+3 && tank1_upleft_Y <= Base1_Y_MAX+3 ))
			begin
				up_stop1 = 1;
				//tank_stop1 = 0;					//up
			end
			
			else if ((tank1_upleft_X+1 >= Base1_X_MIN && tank1_upleft_X+1 <= Base1_X_MAX
			&& tank1_upleft_Y+18 >= Base1_Y_MIN && tank1_upleft_Y+18 <= Base1_Y_MAX)
			||(tank1_upleft_X+15-1 >= Base1_X_MIN && tank1_upleft_X+15-1 <= Base1_X_MAX
			&& tank1_upleft_Y+18 >= Base1_Y_MIN && tank1_upleft_Y+18 <= Base1_Y_MAX))
			begin
				down_stop1 = 1;
				//tank_stop1 = 0;			//down
			end
		
			else if ((tank1_upleft_X >= Base1_X_MIN+3 && tank1_upleft_X <= Base1_X_MAX+3
			&& tank1_upleft_Y+1 >= Base1_Y_MIN && tank1_upleft_Y+1 <= Base1_Y_MAX)
			||(tank1_upleft_X >= Base1_X_MIN+3 && tank1_upleft_X <= Base1_X_MAX+3
			&& tank1_upleft_Y+15-1 >= Base1_Y_MIN && tank1_upleft_Y+15-1 <= Base1_Y_MAX))
			begin
				left_stop1 = 1;
				//tank_stop1 = 0;											//left
			end
		
			else if ((tank1_upleft_X+15+3 >= Base1_X_MIN && tank1_upleft_X+15+3 <= Base1_X_MAX
			&& tank1_upleft_Y+1 >= Base1_Y_MIN && tank1_upleft_Y+1 <= Base1_Y_MAX)
			||(tank1_upleft_X+15+3 >= Base1_X_MIN && tank1_upleft_X+15+3 <= Base1_X_MAX
			&& tank1_upleft_Y+15-1 >= Base1_Y_MIN && tank1_upleft_Y+15-1 <= Base1_Y_MAX))
			begin
				right_stop1 = 1;
				//tank_stop1 = 0;								//right
			end
			
			else
			begin
				right_stop1 = 0;
				left_stop1 = 0;
				up_stop1 = 0; 
				down_stop1 = 0;
			end 
		
		end
		
		else
		begin
			right_stop1 = 0;
			left_stop1 = 0;
			up_stop1 = 0; 
			down_stop1 = 0;
		end
	end
	
	
	always_comb
	begin
		right_stop2 = 0;
		left_stop2 = 0;
		up_stop2 = 0; 
		down_stop2 = 0;
		if(dewall_ruin == 0)
		begin
			if ((tank2_upleft_X+1 >= Base1_X_MIN && tank2_upleft_X+1 <= Base1_X_MAX
			&& tank2_upleft_Y >= Base1_Y_MIN+3 && tank2_upleft_Y <= Base1_Y_MAX+3 )
			||(tank2_upleft_X+15-1 >= Base1_X_MIN && tank2_upleft_X+15-1 <= Base1_X_MAX
			&& tank2_upleft_Y >= Base1_Y_MIN+3 && tank2_upleft_Y <= Base1_Y_MAX+3 ))
			begin
				up_stop2 = 1;
				//tank_stop1 = 0;					//up
			end
			
			else if ((tank2_upleft_X+1 >= Base1_X_MIN && tank2_upleft_X+1 <= Base1_X_MAX
			&& tank2_upleft_Y+18 >= Base1_Y_MIN && tank2_upleft_Y+18 <= Base1_Y_MAX)
			||(tank2_upleft_X+15-1 >= Base1_X_MIN && tank2_upleft_X+15-1 <= Base1_X_MAX
			&& tank2_upleft_Y+18 >= Base1_Y_MIN && tank2_upleft_Y+18 <= Base1_Y_MAX))
			begin
				down_stop2 = 1;
				//tank_stop1 = 0;			//down
			end
		
			else if ((tank2_upleft_X >= Base1_X_MIN+3 && tank2_upleft_X <= Base1_X_MAX+3
			&& tank2_upleft_Y+1 >= Base1_Y_MIN && tank2_upleft_Y+1 <= Base1_Y_MAX)
			||(tank2_upleft_X >= Base1_X_MIN+3 && tank2_upleft_X <= Base1_X_MAX+3
			&& tank2_upleft_Y+15-1 >= Base1_Y_MIN && tank2_upleft_Y+15-1 <= Base1_Y_MAX))
			begin
				left_stop2 = 1;
				//tank_stop1 = 0;											//left
			end
		
			else if ((tank2_upleft_X+15+3 >= Base1_X_MIN && tank2_upleft_X+15+3 <= Base1_X_MAX
			&& tank2_upleft_Y+1 >= Base1_Y_MIN && tank2_upleft_Y+1 <= Base1_Y_MAX)
			||(tank2_upleft_X+15+3 >= Base1_X_MIN && tank2_upleft_X+15+3 <= Base1_X_MAX
			&& tank2_upleft_Y+15-1 >= Base1_Y_MIN && tank2_upleft_Y+15-1 <= Base1_Y_MAX))
			begin
				right_stop2 = 1;
				//tank_stop1 = 0;								//right
			end
			
			else
			begin
				right_stop2 = 0;
				left_stop2 = 0;
				up_stop2 = 0; 
				down_stop2 = 0;
			end 
		
		end
		
		else
		begin
			right_stop2 = 0;
			left_stop2 = 0;
			up_stop2 = 0; 
			down_stop2 = 0;
		end
	end
	 
	always_comb begin
		  is_dewall = 1'b0;
        if (  DrawX <= Base1_X_MAX  && DrawX >= Base1_X_MIN 
		  && DrawY <= Base1_Y_MAX && DrawY >= Base1_Y_MIN && dewall_ruin == 1'b0) 
            is_dewall = 1'b1;
    
	 
	 
    end	
endmodule