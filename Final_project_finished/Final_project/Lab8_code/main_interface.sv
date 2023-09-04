module main_interface(input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
							input [31:0] keycode,
							input [9:0]   DrawX, DrawY,       // Current pixel coordinates
							input logic game_over_flag,
							input logic base1_ruin,
							input logic base2_ruin,
							output logic is_interface,
							output logic is_gameover_1win,
							output logic is_gameover_2win,
							output logic before_game_flag,
							output logic game_start_flag
							);
							

		enum logic [1:0] {before_start, game_start, game_over1, game_over2} State, Next_State;
		
		always_ff @ (posedge Clk)
		begin
			if(Reset)
			begin
				State <= before_start;
			end
			else
			begin
				State <= Next_State;
			end
		end
		
		always_comb
		begin					
			Next_State = State;
		
			before_game_flag = 0;
			game_start_flag = 0;
			
			unique case(State)
				before_start:
				begin
					if(keycode[7:0] == 8'h2C || keycode[15:8] == 8'h2C || keycode[23:16] == 8'h2C || keycode[31:24] == 8'h2C)
					begin
						Next_State = game_start;			//press "space" to start game
					end
					else
					begin
						Next_State = before_start;
					end
				end
				game_start:
				begin
					if(base2_ruin == 1'b1)
					begin
						Next_State = game_over1;
					end
					else if (base1_ruin == 1'b1)
					begin
						Next_State = game_over2;
					end
					else
					begin
						Next_State = game_start;
					end
				end	
				game_over1:
				begin
					if(keycode[7:0] == 8'h28 || keycode[15:8] == 8'h28 || keycode[23:16] == 8'h28 || keycode[31:24] == 8'h28)
					begin
						Next_State = before_start;			//press "enter" to go back to the main interface
					end
					else
					begin
						Next_State = game_over1;
					end
				end
				game_over2:
				begin
					if(keycode[7:0] == 8'h28 || keycode[15:8] == 8'h28 || keycode[23:16] == 8'h28 || keycode[31:24] == 8'h28)
					begin
						Next_State = before_start;			//press "enter" to go back to the main interface
					end
					else
					begin
						Next_State = game_over2;
					end
				end			
			endcase			
			
			case(State)
				before_start:
				begin
					before_game_flag = 1'b1;
					game_start_flag = 1'b0;
				end
				game_start:
				begin
					before_game_flag = 1'b0;
					game_start_flag = 1'b1;
				end
				game_over1:
				begin
					before_game_flag = 1'b0;
					game_start_flag = 1'b0;
				end
				game_over2:
				begin
					before_game_flag = 1'b0;
					game_start_flag = 1'b0;
				end	
			endcase	
		end
	
						
							
		always_comb
		begin
			is_interface = 1'b0;
			is_gameover_1win = 1'b0;
			is_gameover_2win = 1'b0;
			
			if(DrawX >= 222 && DrawX <= 417 && DrawY >= 194 && DrawY <= 285 && before_game_flag == 1'b1)
			begin
				is_interface = 1'b1;
			end
			else
			begin
				is_interface = 1'b0;
			end
		
			if(DrawX >= 222 && DrawX <= 417 && DrawY >= 198 && DrawY <= 296 && game_over_flag == 1'b1 && base2_ruin == 1'b1)
			begin
				is_gameover_1win = 1'b1;
			end
			else
			begin
				is_gameover_1win = 1'b0;
			end
			
			if(DrawX >= 222 && DrawX <= 417 && DrawY >= 198 && DrawY <= 296 && game_over_flag == 1'b1 && base1_ruin == 1'b1)
			begin
				is_gameover_2win = 1'b1;
			end
			else
			begin
				is_gameover_2win = 1'b0;
			end
			
			
		end
endmodule