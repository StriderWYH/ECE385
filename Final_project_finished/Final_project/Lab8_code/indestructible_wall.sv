
module  indestructible_wall ( 
					input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input logic [9:0] tank1_upleft_X, tank1_upleft_Y,
					input logic [9:0] tank2_upleft_X, tank2_upleft_Y,
					input logic [9:0] cannonball_X_Pos1, cannonball_Y_Pos1,
					input logic [9:0] cannonball_X_Pos2, cannonball_Y_Pos2,
					input logic game_start_flag,
               output logic  is_indestructiblewall,             // Whether current pixel belongs to ball or background	
					output logic ball_hit1, ball_hit2, right_stop1, left_stop1, up_stop1, down_stop1,
					output logic right_stop2, left_stop2, up_stop2, down_stop2
					//output [9:0] indes_wall_X, indes_wall_Y
				  );
	int indestructible [0:12][0:3]= '{'{288, 0, 288, 48},
												'{192, 112, 400, 112},
												'{240, 128, 240, 208},
												'{336, 128, 336, 208},
												'{176, 288, 432, 288},
												'{80, 384, 224, 384},
												'{384, 384, 544, 384},
												'{208, 336, 208, 368},
												'{400, 304, 400, 336},
												'{128, 112, 128, 288},
												'{480, 112, 480, 288},
												'{64, 0, 64, 464},
												'{560, 0, 560, 464}};	//{start_x,start_y,end_x,end_y};			  	 
	
	logic is_indestructible_array [0:12][0:0]= '{'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0}};
	logic is_ballhit1_array [0:12][0:0]= '{'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0}};
	logic is_ballhit2_array [0:12][0:0]= '{'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0}};
	logic right_stop1_array [0:12][0:0]= '{'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0}};
	logic left_stop1_array [0:12][0:0]= '{'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0}};
	logic up_stop1_array [0:12][0:0]= '{'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0}};
	logic down_stop1_array [0:12][0:0]= '{'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0}};
	logic right_stop2_array [0:12][0:0]= '{'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0}};
	logic left_stop2_array [0:12][0:0]= '{'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0}};
	logic up_stop2_array [0:12][0:0]= '{'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0}};
	logic down_stop2_array [0:12][0:0]= '{'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0},'{0}};
	int temp1,temp2;
	 always_comb 
	 begin
		/********************************is_indestructiblewall*******************************************/
		is_indestructiblewall = 0;
		for(int i=0; i<13; i++)
		begin
			if (DrawX >= indestructible[i][0] && DrawX <= indestructible[i][2] + 15
			&& DrawY >= indestructible[i][1] && DrawY <= indestructible[i][3] + 15 && game_start_flag == 1'b1)
			begin
				is_indestructible_array[i][0] = 1;
				//is_indestructiblewall = 1;
			end
			
			else
			begin
				is_indestructible_array[i][0] = 0;
				//is_indestructiblewall = 0;
			end
			is_indestructiblewall = is_indestructiblewall | is_indestructible_array[i][0];
		end
		/***************************************ball_hit1*******************************************/
		ball_hit1 = 0;
		temp1 = 0;
		for(int j=0; j<13; j++)
		begin
			if ((cannonball_X_Pos1 >= indestructible[j][0] && cannonball_X_Pos1 <= indestructible[j][2] + 15
			&& cannonball_Y_Pos1 >= indestructible[j][1] && cannonball_Y_Pos1 <= indestructible[j][3] + 15))
			begin
				is_ballhit1_array[j][0] = 1;
				temp1 = j;
			end
			else
			begin
				is_ballhit1_array[j][0] = 0;
			end
			//ball_hit1 = ball_hit1 | is_ballhit1_array[j][0];
		end
		ball_hit1 = is_ballhit1_array[temp1][0];
		
		
		ball_hit2 = 0;
		temp2 = 0;
		for(int j=0; j<13; j++)
		begin
			if ((cannonball_X_Pos2 >= indestructible[j][0] && cannonball_X_Pos2 <= indestructible[j][2] + 15
			&& cannonball_Y_Pos2 >= indestructible[j][1] && cannonball_Y_Pos2 <= indestructible[j][3] + 15))
			begin
				is_ballhit2_array[j][0] = 1;
				temp2 = j;
			end
			else
			begin
				is_ballhit2_array[j][0] = 0;
			end
			//ball_hit1 = ball_hit1 | is_ballhit1_array[j][0];
		end
		ball_hit2 = is_ballhit2_array[temp2][0];
		/****************************************tank_stop1*******************************************/
		up_stop1 = 0;
		down_stop1 = 0;
		left_stop1 = 0;
		right_stop1 = 0;
		for(int k=0; k<13; k++)
		begin
			if ((tank1_upleft_X+1 >= indestructible[k][0] && tank1_upleft_X+1 <= indestructible[k][2] + 15
			&& tank1_upleft_Y >= indestructible[k][1]+3 && tank1_upleft_Y <= indestructible[k][3]+3 + 15)
			||(tank1_upleft_X+15-1 >= indestructible[k][0] && tank1_upleft_X+15-1 <= indestructible[k][2] + 15
			&& tank1_upleft_Y >= indestructible[k][1]+3 && tank1_upleft_Y <= indestructible[k][3]+3 + 15 ))
			begin
				up_stop1_array[k][0] = 1;
				//tank_stop1 = 0;					//up
			end
			else
			begin
				up_stop1_array[k][0] = 0;
				//tank_stop1 = 1;
			end
			
			
			if ((tank1_upleft_X+1 >= indestructible[k][0] && tank1_upleft_X+1 <= indestructible[k][2] + 15
			&& tank1_upleft_Y+18 >= indestructible[k][1] && tank1_upleft_Y+18 <= indestructible[k][3] + 15)
			||(tank1_upleft_X+15-1 >= indestructible[k][0] && tank1_upleft_X+15-1 <= indestructible[k][2] + 15
			&& tank1_upleft_Y+18 >= indestructible[k][1] && tank1_upleft_Y+18 <= indestructible[k][3] + 15))
			begin
				down_stop1_array[k][0] = 1;
				//tank_stop1 = 0;			//down
			end
			else
			begin
				down_stop1_array[k][0] = 0;
				//tank_stop1 = 1;
			end
			
			
			
			if ((tank1_upleft_X >= indestructible[k][0]+3 && tank1_upleft_X <= indestructible[k][2]+ 15+3
			&& tank1_upleft_Y+1 >= indestructible[k][1] && tank1_upleft_Y+1 <= indestructible[k][3] + 15)
			||(tank1_upleft_X >= indestructible[k][0]+3 && tank1_upleft_X <= indestructible[k][2]+ 15+3
			&& tank1_upleft_Y+15-1 >= indestructible[k][1] && tank1_upleft_Y+15-1 <= indestructible[k][3] + 15))
			begin
				left_stop1_array[k][0] = 1;
				//tank_stop1 = 0;											//left
			end
			else
			begin
				left_stop1_array[k][0] = 0;
				//tank_stop1 = 1;
			end
			
			
			if ((tank1_upleft_X+15+3 >= indestructible[k][0] && tank1_upleft_X+15+3 <= indestructible[k][2] + 15
			&& tank1_upleft_Y+1 >= indestructible[k][1] && tank1_upleft_Y+1 <= indestructible[k][3] + 15)
			||(tank1_upleft_X+15+3 >= indestructible[k][0] && tank1_upleft_X+15+3 <= indestructible[k][2] + 15
			&& tank1_upleft_Y+15-1 >= indestructible[k][1] && tank1_upleft_Y+15-1 <= indestructible[k][3] + 15))
			begin
				right_stop1_array[k][0] = 1;
				//tank_stop1 = 0;								//right
			end
			else
			begin
				right_stop1_array[k][0] = 0;
				//tank_stop1 = 1;
			end
			
			up_stop1 = up_stop1 | up_stop1_array[k][0];
			down_stop1 = down_stop1 | down_stop1_array[k][0];
			left_stop1 = left_stop1 | left_stop1_array[k][0];
			right_stop1 = right_stop1 | right_stop1_array[k][0];
		end
		
		
		
		
		
		up_stop2 = 0;
		down_stop2 = 0;
		left_stop2 = 0;
		right_stop2 = 0;
		for(int k=0; k<13; k++)
		begin
			if ((tank2_upleft_X+1 >= indestructible[k][0] && tank2_upleft_X+1 <= indestructible[k][2] + 15
			&& tank2_upleft_Y >= indestructible[k][1]+3 && tank2_upleft_Y <= indestructible[k][3]+3 + 15)
			||(tank2_upleft_X+15-1 >= indestructible[k][0] && tank2_upleft_X+15-1 <= indestructible[k][2] + 15
			&& tank2_upleft_Y >= indestructible[k][1]+3 && tank2_upleft_Y <= indestructible[k][3]+3 + 15 ))
			begin
				up_stop2_array[k][0] = 1;
				//tank_stop1 = 0;					//up
			end
			else
			begin
				up_stop2_array[k][0] = 0;
				//tank_stop1 = 1;
			end
			
			if ((tank2_upleft_X+1 >= indestructible[k][0] && tank2_upleft_X+1<= indestructible[k][2] + 15
			&& tank2_upleft_Y+18 >= indestructible[k][1] && tank2_upleft_Y+18 <= indestructible[k][3] + 15)
			||(tank2_upleft_X+15-1 >= indestructible[k][0] && tank2_upleft_X+15-1 <= indestructible[k][2] + 15
			&& tank2_upleft_Y+18 >= indestructible[k][1] && tank2_upleft_Y+18 <= indestructible[k][3] + 15))
			begin
				down_stop2_array[k][0] = 1;
				//tank_stop1 = 0;			//down
			end
			else
			begin
				down_stop2_array[k][0] = 0;
				//tank_stop1 = 1;
			end
			
			if ((tank2_upleft_X >= indestructible[k][0]+3 && tank2_upleft_X <= indestructible[k][2] + 15+3
			&& tank2_upleft_Y+1 >= indestructible[k][1] && tank2_upleft_Y+1 <= indestructible[k][3] + 15)
			||(tank2_upleft_X >= indestructible[k][0]+3 && tank2_upleft_X <= indestructible[k][2] + 15+3
			&& tank2_upleft_Y+15-1 >= indestructible[k][1] && tank2_upleft_Y+15-1 <= indestructible[k][3] + 15))
			begin
				left_stop2_array[k][0] = 1;
				//tank_stop1 = 0;											//left
			end
			else
			begin
				left_stop2_array[k][0] = 0;
				//tank_stop1 = 1;
			end
			
			if ((tank2_upleft_X+15 +3>= indestructible[k][0] && tank2_upleft_X+15+3 <= indestructible[k][2] + 15
			&& tank2_upleft_Y+1 >= indestructible[k][1] && tank2_upleft_Y+1 <= indestructible[k][3] + 15)
			||(tank2_upleft_X+15+3 >= indestructible[k][0] && tank2_upleft_X+15+3 <= indestructible[k][2] + 15
			&& tank2_upleft_Y+15-1 >= indestructible[k][1] && tank2_upleft_Y+15-1 <= indestructible[k][3] + 15))
			begin
				right_stop2_array[k][0] = 1;
				//tank_stop1 = 0;								//right
			end
			else
			begin
				right_stop2_array[k][0] = 0;
				//tank_stop1 = 1;
			end
			
			up_stop2 = up_stop2 | up_stop2_array[k][0];
			down_stop2 = down_stop2 | down_stop2_array[k][0];
			left_stop2 = left_stop2 | left_stop2_array[k][0];
			right_stop2 = right_stop2 | right_stop2_array[k][0];
		end
		
	 end
endmodule
