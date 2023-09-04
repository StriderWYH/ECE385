module medicinepackage ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input logic [9:0] tank1_upleft_X, tank1_upleft_Y,
					input logic [9:0] tank2_upleft_X, tank2_upleft_Y,
					input logic game_start_flag,
					input logic before_game_flag,
               output logic  is_mp1,
					output logic  add_base1_hp, add_base2_hp

);

//				 parameter [9:0] mp1_X_MAX = 10'd143;  
//				 parameter [9:0] mp1_X_MIN = 10'd128;  	
//				 parameter [9:0] mp1_Y_MAX = 10'd447;
//				 parameter [9:0] mp1_Y_MIN = 10'd432;
				 
				 parameter [9:0] mp1_X_MAX = 10'd319;  
				 parameter [9:0] mp1_X_MIN = 10'd304;  	
				 parameter [9:0] mp1_Y_MAX = 10'd447;
				 parameter [9:0] mp1_Y_MIN = 10'd432;
				 parameter [9:0] tank_size = 10'd7;
				 
				 
				 
//				 parameter [9:0] mp2_X_MAX = 10'd495;  
//				 parameter [9:0] mp2_X_MIN = 10'd480;  	
//				 parameter [9:0] mp2_Y_MAX = 10'd447;
//				 parameter [9:0] mp2_Y_MIN = 10'd432;
				 
					
				logic [26:0] time_counter, time_counter_in;
					
				 logic mp1_ruin;
				 logic [9:0] tank1_center_X, tank1_center_Y,tank2_center_X, tank2_center_Y ;
				 logic add_base1_hp_in, add_base2_hp_in;
				 
	  assign tank1_center_X = tank1_upleft_X + tank_size;
	  assign tank1_center_Y = tank1_upleft_Y + tank_size;
	  assign tank2_center_X = tank2_upleft_X + tank_size;
	  assign tank2_center_Y = tank2_upleft_Y + tank_size;
	  
	  
	  
	  
		
	 enum logic [4:0] {NEWBASE, MP1RUIN_1,MP1RUIN_2, OVER} State, Next_State;
	 
	 
	 
	 always_ff @ (posedge Clk) 
	 begin
		if (Reset | before_game_flag)
		begin
			State <= NEWBASE;               
			add_base1_hp <= 1'b0;
			add_base2_hp <= 1'b0;
			time_counter <= 27'b0;
		end
		else 
		begin
			State <= Next_State;
			add_base1_hp <= add_base1_hp_in;
			add_base2_hp <= add_base2_hp_in;
			time_counter <= time_counter_in;
		end
	 end
	 
	 
	 
	 always_comb begin
	 time_counter_in = time_counter + 1'b1;
	 if(time_counter == 27'b0101111101011110000100000000) // 2s for 50MHZ
		begin
			time_counter_in = 27'b0;
		end
	 end
	 
	 
	 
	 always_comb 
	 begin
		 Next_State = State;
		 mp1_ruin = 1'b0;
		 add_base1_hp_in = add_base1_hp;
		 add_base2_hp_in = add_base2_hp;
		 unique case (State)
			NEWBASE:
			begin

					if(   tank1_center_X >= mp1_X_MIN && tank1_center_X <= mp1_X_MAX 
							&& tank1_center_Y >= mp1_Y_MIN && tank1_center_Y <= mp1_Y_MAX  )
					begin
						Next_State = MP1RUIN_1;
						add_base1_hp_in = 1'b1;
					
					end
					else if(tank2_center_X >= mp1_X_MIN && tank2_center_X <= mp1_X_MAX 
							&& tank2_center_Y >= mp1_Y_MIN && tank2_center_Y <= mp1_Y_MAX)
					begin
						Next_State = MP1RUIN_2;
						add_base2_hp_in = 1'b1;
					
					end
					else 
					begin
						Next_State = NEWBASE;
						add_base1_hp_in = 1'b0;
						add_base2_hp_in = 1'b0;
					end
			end
		
			
			MP1RUIN_1:
				begin
					mp1_ruin = 1'b1;
					add_base1_hp_in = 1'b1;
					Next_State = MP1RUIN_1;
					
					

//					if(before_game_flag == 1'b1)
//					begin
//						Next_State = NEWBASE;
//					end
//					else
//					begin
//						Next_State = MP1RUIN_1;
//					end	
//					end
				end
			
			MP1RUIN_2:
				begin
					mp1_ruin = 1'b1;
					add_base2_hp_in = 1'b1;
					Next_State = MP1RUIN_2;
					
//					if(before_game_flag == 1'b1)
//					begin
//						Next_State = NEWBASE;
//					end
//					else
//					begin
//						Next_State = MP1RUIN_2;
//					end	
				end
			
			
		 endcase
	 end
	 
				 
			
				 
				 


	always_comb begin
		  is_mp1 = 1'b0;
		  
        if (  DrawX <= mp1_X_MAX  && DrawX >= mp1_X_MIN 
		  && DrawY <= mp1_Y_MAX && DrawY >= mp1_Y_MIN && mp1_ruin == 1'b0 && game_start_flag == 1'b1
		  && time_counter <= 27'b0100011110000110100011000000 ) 
            is_mp1 = 1'b1;
		 
	 
	 
    end	


endmodule