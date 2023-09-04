
module  Base2 ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [31:0] keycode,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input logic [9:0] tank1_upleft_X, tank1_upleft_Y,
					input logic [9:0] tank2_upleft_X, tank2_upleft_Y,
					input logic [9:0] cannonball_X_Pos,
					input logic [9:0] cannonball_Y_Pos,
					
					input logic ball_boom,ball1_air,
               input logic game_start_flag,
					input logic before_game_flag,
					input logic add_base2_hp,
					output logic  is_base2,             // Whether current pixel belongs to ball or background
					output logic  ball1_hit_base2,
					output logic [2:0] base2_HP, 
					output logic base2_ruin,
					output logic right_stop1, left_stop1, up_stop1, down_stop1,
					output logic right_stop2, left_stop2, up_stop2, down_stop2
				  );
				  
		parameter [9:0] Base2_X_MAX = 10'd559;  // base position for the enemy of tank1， which is fixed
		parameter [9:0] Base2_X_MIN = 10'd544;  // left-up position on the Y axis		
		parameter [9:0] Base2_Y_MAX = 10'd255;
		parameter [9:0] Base2_Y_MIN = 10'd240;
		parameter [9:0] Base2_HP_MAX = 10'd5;
		
		logic[2:0] Base2_HP, Base2_HP_in;
		logic [26:0] time_counter, time_counter_in;
		assign base2_HP = Base2_HP;
		
		logic has_added, has_added_in;
		
	 enum logic [4:0] {NEWBASE, BASEHURT4,BASE4, BASEHURT3, BASE3,BASEHURT2,BASE2,BASEHURT1,BASE1,BASERUIN,BASEOVER,BASESIX, BASEHURTSIX} State, Next_State;
	 
	 
	 
	 always_ff @ (posedge Clk) 
	 begin
		if (Reset | before_game_flag)
		begin
			State <= NEWBASE;                // When newgame started, the base should be refreshed
			Base2_HP <= Base2_HP_MAX;
			time_counter <= 27'b0;
			has_added <= 1'b0;
		end
		else 
		begin
			State <= Next_State;
			Base2_HP <= Base2_HP_in;
			time_counter <= time_counter_in;
			has_added <= has_added_in;
		end
	 end
	 
	 always_comb 
	 begin
		 Next_State = State;
		 base2_ruin = 1'b0;
		 Base2_HP_in = Base2_HP;
		 ball1_hit_base2 = 1'b0;
		 time_counter_in = time_counter;
		 has_added_in = has_added;
		 unique case (State)
			BASESIX:
			begin
					if( ball_boom == 1'b1)
					begin
						Next_State = BASESIX;
						time_counter_in = time_counter + 1'b1;
					end
					else if(cannonball_X_Pos >= Base2_X_MIN && cannonball_X_Pos <= Base2_X_MAX 
						&& cannonball_Y_Pos >= Base2_Y_MIN &&  cannonball_Y_Pos <= Base2_Y_MAX && ball_boom == 1'b0 && ball1_air == 1'b1)
					begin
						Next_State = BASEHURTSIX;
						time_counter_in = 27'b0;
						Base2_HP_in = Base2_HP - 1'b1;
					end
					else
					begin
						Next_State = BASESIX;
					end
			end
			BASEHURTSIX:
			begin
					 // the counter need elaborated designed(exactly 1 at the 18th bit)  so that the siganl could be processed by the cannonbal.sv
					if(time_counter >= 27'b01000000000000000000000000 && ball_boom == 1'b0)
					begin
						
						Next_State = NEWBASE;
						time_counter_in = 27'b0;
					end
					else
					begin
						Next_State = BASEHURTSIX;
						time_counter_in = time_counter + 1'b1;
					end
						
			end
			NEWBASE:
			begin
					if( ball_boom == 1'b1)
					begin
						Next_State = NEWBASE;
						time_counter_in = time_counter + 1'b1;
					end
					else if(cannonball_X_Pos >= Base2_X_MIN && cannonball_X_Pos <= Base2_X_MAX 
						&& cannonball_Y_Pos >= Base2_Y_MIN &&  cannonball_Y_Pos <= Base2_Y_MAX && ball_boom == 1'b0 && ball1_air == 1'b1)
					begin
						Next_State = BASEHURT4;
						time_counter_in = 27'b0;
						Base2_HP_in = Base2_HP - 1'b1;
					end
					else if(add_base2_hp == 1'b1 && has_added == 1'b0)
					begin
						Next_State = BASESIX;
						has_added_in = 1'b1;
						Base2_HP_in = Base2_HP + 1'b1;
					end
					else
					begin
						Next_State = NEWBASE;
					end
			end
			BASEHURT4:
			begin
					 // the counter need elaborated designed(exactly 1 at the 18th bit)  so that the siganl could be processed by the cannonbal.sv
					if(time_counter >= 27'b01000000000000000000000000 && ball_boom == 1'b0)
					begin
						
						Next_State = BASE4;
						time_counter_in = 27'b0;
					end
					else
					begin
						Next_State = BASEHURT4;
						time_counter_in = time_counter + 1'b1;
					end
						
			end
			BASE4:
			begin
					if( ball_boom == 1'b1)
					begin
						Next_State = BASE4;
						time_counter_in = time_counter + 1'b1;
					end
					else if(cannonball_X_Pos >= Base2_X_MIN && cannonball_X_Pos <= Base2_X_MAX 
						&& cannonball_Y_Pos >= Base2_Y_MIN &&  cannonball_Y_Pos <= Base2_Y_MAX && ball_boom == 1'b0 && ball1_air == 1'b1)
					begin
						//Next_State = BASERUIN;
						Next_State = BASEHURT3;
						time_counter_in = 27'b0;
						Base2_HP_in = Base2_HP - 1'b1;
					end
					else if(add_base2_hp == 1'b1 && has_added == 1'b0)
					begin
						Next_State = NEWBASE;
						has_added_in = 1'b1;
						Base2_HP_in = Base2_HP + 1'b1;
					end
					else
					begin
						Next_State = BASE4;
						
					end
			end
			
			BASEHURT3:
			begin
					if(time_counter >= 27'b01000000000000000000000000 && ball_boom == 1'b0)
					begin
						Next_State = BASE3;
						time_counter_in = 27'b0;
					end
					else
					begin
						Next_State = BASEHURT3;
						time_counter_in = time_counter + 1'b1;
					end
						
			end
			
			BASE3:
			begin
					if( ball_boom == 1'b1)
					begin
						Next_State = BASE3;
						time_counter_in = time_counter + 1'b1;
					end
					else 
					if(cannonball_X_Pos >= Base2_X_MIN && cannonball_X_Pos <= Base2_X_MAX 
						&& cannonball_Y_Pos >= Base2_Y_MIN &&  cannonball_Y_Pos <= Base2_Y_MAX&& ball_boom == 1'b0 && ball1_air == 1'b1)
					begin
						Next_State = BASEHURT2;
						time_counter_in = 27'b0;
						Base2_HP_in = Base2_HP - 1'b1;
					end
					else if(add_base2_hp == 1'b1 && has_added == 1'b0)
					begin
						Next_State = BASE4;
						has_added_in = 1'b1;
						Base2_HP_in = Base2_HP + 1'b1;
					end
					else
					begin
						Next_State = BASE3;
						
					end
			end
			
			BASEHURT2:
			begin
					if(time_counter >= 27'b01000000000000000000000000 && ball_boom == 1'b0)
					begin
						Next_State = BASE2;
						time_counter_in = 27'b0;
						//time_counter_in = 27'b0;
					end
					else
					begin
						Next_State = BASEHURT2;
						time_counter_in = time_counter + 1'b1;
					end
						
			end
			
			BASE2:
			begin
					if( ball_boom == 1'b1)
					begin
						Next_State = BASE2;
						time_counter_in = time_counter + 1'b1;
					end
					else 
					if(cannonball_X_Pos >= Base2_X_MIN && cannonball_X_Pos <= Base2_X_MAX 
						&& cannonball_Y_Pos >= Base2_Y_MIN &&  cannonball_Y_Pos <= Base2_Y_MAX&& ball_boom == 1'b0&& ball1_air == 1'b1)
					begin
						Next_State = BASEHURT1;
						time_counter_in = 27'b0;
						Base2_HP_in = Base2_HP - 1'b1;
					end
					else if(add_base2_hp == 1'b1 && has_added == 1'b0)
					begin
						Next_State = BASE3;
						has_added_in = 1'b1;
						Base2_HP_in = Base2_HP + 1'b1;
					end
					else
					begin
						Next_State = BASE2;
					end
			end
			
			BASEHURT1:
			begin
					if(time_counter >= 27'b01000000000000000000000000 && ball_boom == 1'b0)
					begin
						Next_State = BASE1;
						time_counter_in = 27'b0;
						//time_counter_in = 27'b0;
					end
					else
					begin
						Next_State = BASEHURT1;
						time_counter_in = time_counter + 1'b1;
					end
						
			end
			BASE1:
			begin
					if( ball_boom == 1'b1)
					begin
						Next_State = BASE1;
						time_counter_in = time_counter + 1'b1;
					end
					else 
					if(cannonball_X_Pos >= Base2_X_MIN && cannonball_X_Pos <= Base2_X_MAX 
						&& cannonball_Y_Pos >= Base2_Y_MIN &&  cannonball_Y_Pos <= Base2_Y_MAX&& ball_boom == 1'b0&& ball1_air == 1'b1)
					begin
						Next_State = BASERUIN;
						time_counter_in = 27'b0;
						Base2_HP_in = Base2_HP - 1'b1;
					end
					else if(add_base2_hp == 1'b1 && has_added == 1'b0)
					begin
						Next_State = BASE2;
						has_added_in = 1'b1;
						Base2_HP_in = Base2_HP + 1'b1;
					end
					else
					begin
						Next_State = BASE1;
					end
			end
			BASERUIN:
			begin
			if(time_counter >= 27'b01000000000000000000000000 && ball_boom == 1'b0)
				begin
					Next_State = BASEOVER;
					time_counter_in = 27'b0;
					//time_counter_in = 27'b0;
				end
				else
				begin
					Next_State = BASERUIN;
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
			BASESIX:
			begin
				time_counter_in = 27'b0;
				//Base1_HP_in = 3'b101;
			end
			BASEHURTSIX :
			begin
				ball1_hit_base2 = 1'b1;
			end
			NEWBASE:
			begin
				time_counter_in = 27'b0;
				//Base1_HP_in = 3'b101;
			end
			BASEHURT4:
			begin
				//time_counter_in = time_counter + 1'b1;
				ball1_hit_base2 = 1'b1;
				//Base1_HP_in = 3'b100;
			end
			BASE4:
			begin
				//time_counter_in = time_counter + 1'b1;
				//Base1_HP_in = 3'b100;
			end
			BASEHURT3:
			begin
				//time_counter_in = time_counter + 1'b1;
				ball1_hit_base2 = 1'b1;
				//Base1_HP_in = 3'b011;
			end
			BASE3:
			begin
				//time_counter_in = time_counter + 1'b1;
				//Base1_HP_in = 3'b011;
			end
			BASEHURT2:
			begin
				//time_counter_in = time_counter + 1'b1;
				ball1_hit_base2 = 1'b1;
				//Base1_HP_in = 3'b010;
			end
			BASE2:
			begin
				//time_counter_in = time_counter + 1'b1;
				//Base1_HP_in = 3'b010;
			end
			BASEHURT1:
			begin
				//time_counter_in = time_counter + 1'b1;
				ball1_hit_base2 = 1'b1;
				//Base1_HP_in = 3'b001;
			end
			BASE1:
			begin
				//time_counter_in = time_counter + 1'b1;
				//Base1_HP_in = 3'b001;
			end
			BASERUIN:
			begin
				base2_ruin = 1'b1;
				ball1_hit_base2 = 1'b1;
				//Base1_HP_in = 3'b000;
			end
			BASEOVER:
			begin
				base2_ruin = 1'b1;
				//Base1_HP_in = 3'b000;
			end	
		 endcase
	 end
	 
	 
	always_comb
	begin
		right_stop1 = 0;
		left_stop1 = 0;
		up_stop1 = 0; 
		down_stop1 = 0;
		if(base2_ruin == 0)
		begin
			if ((tank1_upleft_X >= 544 && tank1_upleft_X <= 559
			&& tank1_upleft_Y >= 240+3 && tank1_upleft_Y <= 255+3 )
			||(tank1_upleft_X+15 >= 544 && tank1_upleft_X+15 <= 559
			&& tank1_upleft_Y >= 240+3 && tank1_upleft_Y <= 255+3 ))
			begin
				up_stop1 = 1;
				//tank_stop1 = 0;					//up
			end
			
			else if ((tank1_upleft_X >= 544 && tank1_upleft_X <= 559
			&& tank1_upleft_Y+18 >= 240 && tank1_upleft_Y+18 <= 255)
			||(tank1_upleft_X+15 >= 544 && tank1_upleft_X+15 <= 559
			&& tank1_upleft_Y+18 >= 240 && tank1_upleft_Y+18 <= 255))
			begin
				down_stop1 = 1;
				//tank_stop1 = 0;			//down
			end
		
			else if ((tank1_upleft_X >= 544+3 && tank1_upleft_X <= 559+3
			&& tank1_upleft_Y >= 240 && tank1_upleft_Y <= 255)
			||(tank1_upleft_X >= 544 && tank1_upleft_X <= 559+3
			&& tank1_upleft_Y+15 >= 240 && tank1_upleft_Y+15 <= 255))
			begin
				left_stop1 = 1;
				//tank_stop1 = 0;											//left
			end
		
			else if ((tank1_upleft_X+18 >= 544 && tank1_upleft_X+18 <= 559
			&& tank1_upleft_Y >= 240 && tank1_upleft_Y <= 255)
			||(tank1_upleft_X+18 >= 544 && tank1_upleft_X+18 <= 559
			&& tank1_upleft_Y+15 >= 240 && tank1_upleft_Y+15 <= 255))
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
		if(base2_ruin == 0)
		begin
			if ((tank2_upleft_X >= 544 && tank2_upleft_X <= 559
			&& tank2_upleft_Y >= 240+3 && tank2_upleft_Y <= 255+3 )
			||(tank2_upleft_X+15 >= 544 && tank2_upleft_X+15 <= 559
			&& tank2_upleft_Y >= 240+3 && tank2_upleft_Y <= 255+3 ))
			begin
				up_stop2 = 1;
				//tank_stop1 = 0;					//up
			end
			
			else if ((tank2_upleft_X >= 544 && tank2_upleft_X <= 559
			&& tank2_upleft_Y+18 >= 240 && tank2_upleft_Y+18 <= 255)
			||(tank2_upleft_X+15 >= 544 && tank2_upleft_X+15 <= 559
			&& tank2_upleft_Y+18 >= 240 && tank2_upleft_Y+18 <= 255))
			begin
				down_stop2 = 1;
				//tank_stop1 = 0;			//down
			end
		
			else if ((tank2_upleft_X >= 544+3 && tank2_upleft_X <= 559+3
			&& tank2_upleft_Y >= 240 && tank2_upleft_Y <= 255)
			||(tank2_upleft_X >= 544 && tank2_upleft_X <= 559+3
			&& tank2_upleft_Y+15 >= 240 && tank2_upleft_Y+15 <= 255))
			begin
				left_stop2 = 1;
				//tank_stop1 = 0;											//left
			end
		
			else if ((tank2_upleft_X+18 >= 544 && tank2_upleft_X+18 <= 559
			&& tank2_upleft_Y >= 240 && tank2_upleft_Y <= 255)
			||(tank2_upleft_X+18 >= 544 && tank2_upleft_X+18 <= 559
			&& tank2_upleft_Y+15 >= 240 && tank2_upleft_Y+15 <= 255))
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
		  is_base2 = 1'b0;
        if (  DrawX <= Base2_X_MAX  && DrawX >= Base2_X_MIN 
		  && DrawY <= Base2_Y_MAX && DrawY >= Base2_Y_MIN && base2_ruin == 1'b0 && game_start_flag==1'b1) 
            is_base2 = 1'b1;
    
	 
	 
    end	
		
endmodule