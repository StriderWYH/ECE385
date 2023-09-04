module DE_WALL ( input         Clk,                // 50 MHz clock
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
					input logic game_start_flag,
					input logic before_game_flag,
               output logic  is_dewall,
					output logic  ball1_hit_dewall,
					output logic  ball2_hit_dewall,
					output logic right_stop1, left_stop1, up_stop1, down_stop1,
					output logic right_stop2, left_stop2, up_stop2, down_stop2
				  );
				  
				  /**************************** 1 ********************************/
				  
				  logic is_dewalltop1,is_dewalltop2,is_dewalltop3,is_dewallmd1,is_dewallmd2,is_dewallmd3,is_dewallmd4;
				  logic is_dewallmd5,is_dewallmd6,is_dewallmd7,is_dewallmd8;
				  logic is_dewallbt1,is_dewallbt2,is_dewallbt3,is_dewallbt4;
				  
				  logic is_dewall_tp, is_dewall_m1, is_dewall_m2, is_dewall_bt;
				 
				  
				  assign is_dewall_tp = is_dewalltop1 | is_dewalltop2 | is_dewalltop3; 
				  assign is_dewall_m1 = is_dewallmd1 | is_dewallmd2  | is_dewallmd3 | is_dewallmd4;
				  assign is_dewall_m2 = is_dewallmd5 | is_dewallmd6  | is_dewallmd7 | is_dewallmd8;
				  assign is_dewall_bt = is_dewallbt1 | is_dewallbt2  | is_dewallbt3 | is_dewallbt4;
				  
				  assign is_dewall = (is_dewall_tp| is_dewall_m1|is_dewall_m2 | is_dewall_bt) & game_start_flag;
				  
				  /*************************** 2 *******************************/
				  logic ball1_hit_top1,ball2_hit_top1;
				  
				  logic right_stop1_tp1, left_stop1_tp1, up_stop1_tp1, down_stop1_tp1;
				  
				  logic right_stop2_tp1, left_stop2_tp1, up_stop2_tp1, down_stop2_tp1;
				  
				  logic ball1_hit_top2,ball2_hit_top2;
				  
				  logic right_stop1_tp2, left_stop1_tp2, up_stop1_tp2, down_stop1_tp2;
				  
				  logic right_stop2_tp2, left_stop2_tp2, up_stop2_tp2, down_stop2_tp2;
				  
				  logic ball1_hit_top3,ball2_hit_top3;
				  
				  logic right_stop1_tp3, left_stop1_tp3, up_stop1_tp3, down_stop1_tp3;
				  
				  logic right_stop2_tp3, left_stop2_tp3, up_stop2_tp3, down_stop2_tp3;
				  
				  
				  logic ball1_hit_md1,ball2_hit_md1;
				  
				  logic right_stop1_md1, left_stop1_md1, up_stop1_md1, down_stop1_md1;
				  
				  logic right_stop2_md1, left_stop2_md1, up_stop2_md1, down_stop2_md1;
				  
				  logic ball1_hit_md2,ball2_hit_md2;
				  
				  logic right_stop1_md2, left_stop1_md2, up_stop1_md2, down_stop1_md2;
				  
				  logic right_stop2_md2, left_stop2_md2, up_stop2_md2, down_stop2_md2;
				  
				  logic ball1_hit_md3,ball2_hit_md3;
				  
				  logic right_stop1_md3, left_stop1_md3, up_stop1_md3, down_stop1_md3;
				  
				  logic right_stop2_md3, left_stop2_md3, up_stop2_md3, down_stop2_md3;
				  
				  logic ball1_hit_md4,ball2_hit_md4;
				  
				  logic right_stop1_md4, left_stop1_md4, up_stop1_md4, down_stop1_md4;
				  
				  logic right_stop2_md4, left_stop2_md4, up_stop2_md4, down_stop2_md4;
				  
				  
				  
				  
				  
				  logic ball1_hit_md5,ball2_hit_md5;
				  
				  logic right_stop1_md5, left_stop1_md5, up_stop1_md5, down_stop1_md5;
				  
				  logic right_stop2_md5, left_stop2_md5, up_stop2_md5, down_stop2_md5;
				  
				  logic ball1_hit_md6,ball2_hit_md6;
				  
				  logic right_stop1_md6, left_stop1_md6, up_stop1_md6, down_stop1_md6;
				  
				  logic right_stop2_md6, left_stop2_md6, up_stop2_md6, down_stop2_md6;
				  
				  logic ball1_hit_md7,ball2_hit_md7;
				  
				  logic right_stop1_md7, left_stop1_md7, up_stop1_md7, down_stop1_md7;
				  
				  logic right_stop2_md7, left_stop2_md7, up_stop2_md7, down_stop2_md7;
				  
				  logic ball1_hit_md8,ball2_hit_md8;
				  
				  logic right_stop1_md8, left_stop1_md8, up_stop1_md8, down_stop1_md8;
				  
				  logic right_stop2_md8, left_stop2_md8, up_stop2_md8, down_stop2_md8;
				  
				  
				  
				  logic ball1_hit_bt1,ball2_hit_bt1;
				  
				  logic right_stop1_bt1, left_stop1_bt1, up_stop1_bt1, down_stop1_bt1;
				  
				  logic right_stop2_bt1, left_stop2_bt1, up_stop2_bt1, down_stop2_bt1;
				  
				  logic ball1_hit_bt2,ball2_hit_bt2;
				  
				  logic right_stop1_bt2, left_stop1_bt2, up_stop1_bt2, down_stop1_bt2;
				  
				  logic right_stop2_bt2, left_stop2_bt2, up_stop2_bt2, down_stop2_bt2;
				  
				  logic ball1_hit_bt3,ball2_hit_bt3;
				  
				  logic right_stop1_bt3, left_stop1_bt3, up_stop1_bt3, down_stop1_bt3;
				  
				  logic right_stop2_bt3, left_stop2_bt3, up_stop2_bt3, down_stop2_bt3;
				  
				  logic ball1_hit_bt4,ball2_hit_bt4;
				  
				  logic right_stop1_bt4, left_stop1_bt4, up_stop1_bt4, down_stop1_bt4;
				  
				  logic right_stop2_bt4, left_stop2_bt4, up_stop2_bt4, down_stop2_bt4;
				  
				 
				 /******************************** 3 ******************************/ 
				  logic right_stop1_tp, right_stop1_m1, right_stop1_m2 ,right_stop1_bt;
				  logic right_stop2_tp, right_stop2_m1, right_stop2_m2 ,right_stop2_bt;
				
				  assign right_stop1_tp = right_stop1_tp1 | right_stop1_tp2 | right_stop1_tp3 ;
				  assign right_stop1_m1 = right_stop1_md1 | right_stop1_md2 | right_stop1_md3 | right_stop1_md4;
				  assign right_stop1_m2 = right_stop1_md5 | right_stop1_md6 | right_stop1_md7 | right_stop1_md8;
				  assign right_stop1_bt = right_stop1_bt1 | right_stop1_bt2 | right_stop1_bt3 | right_stop1_bt4;
				  
				  assign right_stop2_tp = right_stop2_tp1 | right_stop2_tp2 | right_stop2_tp3; 
				  assign right_stop2_m1 = right_stop2_md1 | right_stop2_md2 | right_stop2_md3 | right_stop2_md4;
				  assign right_stop2_m2 = right_stop2_md5 | right_stop2_md6 | right_stop2_md7 | right_stop2_md8;
				  assign right_stop2_bt = right_stop2_bt1 | right_stop2_bt2 | right_stop2_bt3 | right_stop2_bt4;
				  
				  assign right_stop1 = right_stop1_tp| right_stop1_m1| right_stop1_m2 | right_stop1_bt;
				  assign right_stop2 = right_stop2_tp| right_stop2_m1| right_stop2_m2 | right_stop2_bt;
				  
				  
				  /******************************** 4 ******************************/
				  
				  logic left_stop1_tp, left_stop1_m1, left_stop1_m2 ,left_stop1_bt;
				  logic left_stop2_tp, left_stop2_m1, left_stop2_m2 ,left_stop2_bt;
				  
				  assign left_stop1_tp = left_stop1_tp1 | left_stop1_tp2 | left_stop1_tp3 ;
				  assign	left_stop1_m1 =  left_stop1_md1 | left_stop1_md2 | left_stop1_md3 | left_stop1_md4;
				  assign left_stop1_m2 = left_stop1_md5 | left_stop1_md6 | left_stop1_md7 | left_stop1_md8;
				  assign	left_stop1_bt =  left_stop1_bt1 | left_stop1_bt2 | left_stop1_bt3 | left_stop1_bt4;
				  
				  assign left_stop2_tp = left_stop2_tp1 | left_stop2_tp2 | left_stop2_tp3 ;
				  assign	left_stop2_m1 =  left_stop2_md1 | left_stop2_md2 | left_stop2_md3 | left_stop2_md4;
				  assign left_stop2_m2 = left_stop2_md5 | left_stop2_md6 | left_stop2_md7 | left_stop2_md8;
				  assign	left_stop2_bt =  left_stop2_bt1 | left_stop2_bt2 | left_stop2_bt3 | left_stop2_bt4;
				  
				  assign left_stop1 = left_stop1_tp| left_stop1_m1| left_stop1_m2 | left_stop1_bt;
				  assign left_stop2 = left_stop2_tp| left_stop2_m1| left_stop2_m2 | left_stop2_bt;
				  
				  
				  /******************************** 5 ******************************/
				  logic up_stop1_tp, up_stop1_m1, up_stop1_m2 ,up_stop1_bt;
				  logic up_stop2_tp, up_stop2_m1, up_stop2_m2 ,up_stop2_bt;
				  
				  
				  assign up_stop1_tp = up_stop1_tp1 | up_stop1_tp2 | up_stop1_tp3; 
				  assign up_stop1_m1 = up_stop1_md1 | up_stop1_md2 | up_stop1_md3 | up_stop1_md4;
				  assign up_stop1_m2 = up_stop1_md5 | up_stop1_md6 | up_stop1_md7 | up_stop1_md8;
				  assign up_stop1_bt = up_stop1_bt1 | up_stop1_bt2 | up_stop1_bt3 | up_stop1_bt4; 
				  
				  
				  assign up_stop2_tp = up_stop2_tp1 | up_stop2_tp2 | up_stop2_tp3 ;
				  assign up_stop2_m1 = up_stop2_md1 | up_stop2_md2 | up_stop2_md3 | up_stop2_md4;
				  assign up_stop2_m2 = up_stop2_md5 | up_stop2_md6 | up_stop2_md7 | up_stop2_md8;
				  assign up_stop2_bt = up_stop2_bt1 | up_stop2_bt2 | up_stop2_bt3 | up_stop2_bt4;
				  
				  assign up_stop1 = up_stop1_tp| up_stop1_m1| up_stop1_m2 | up_stop1_bt;
				  assign up_stop2 = up_stop2_tp| up_stop2_m1| up_stop2_m2 | up_stop2_bt;
				  
				  
				  /******************************** 6 ******************************/
				  logic down_stop1_tp, down_stop1_m1, down_stop1_m2 ,down_stop1_bt;
				  logic down_stop2_tp, down_stop2_m1, down_stop2_m2 ,down_stop2_bt;
				  
				  
				  
				  assign down_stop1_tp 	= down_stop1_tp1 | down_stop1_tp2 | down_stop1_tp3 ;
				  assign down_stop1_m1 = down_stop1_md1 | down_stop1_md2| down_stop1_md3 | down_stop1_md4;
				  assign down_stop1_m2 = down_stop1_md5 | down_stop1_md6| down_stop1_md7 | down_stop1_md8;
				  assign down_stop1_bt = down_stop1_bt1 | down_stop1_bt2| down_stop1_bt3 | down_stop1_bt4;
				  
				  assign down_stop2_tp = down_stop2_tp1| down_stop2_tp2 | down_stop2_tp3 ;
				  assign down_stop2_m1 = down_stop2_md1 | down_stop2_md2| down_stop2_md3 | down_stop2_md4;
				  assign down_stop2_m2 = down_stop2_md5 | down_stop2_md6| down_stop2_md7 | down_stop2_md8;
				  assign down_stop2_bt = down_stop2_bt1 | down_stop2_bt2| down_stop2_bt3 | down_stop2_bt4;
				
				
				 assign down_stop1 = down_stop1_tp| down_stop1_m1| down_stop1_m2 | down_stop1_bt;
				 assign down_stop2 = down_stop2_tp| down_stop2_m1| down_stop2_m2 | down_stop2_bt;
				
				/******************************* 4 *********************************/
				
				logic ball1_tp, ball1_m1, ball1_m2, ball1_bt;
				logic ball2_tp, ball2_m1, ball2_m2, ball2_bt;
				 
			   assign ball1_tp = ball1_hit_top1 | ball1_hit_top2 | ball1_hit_top3 ;
			   assign ball1_m1 = ball1_hit_md1 | ball1_hit_md2 | ball1_hit_md3 | ball1_hit_md4;
				assign ball1_m2 = ball1_hit_md5 | ball1_hit_md6 | ball1_hit_md7 | ball1_hit_md8;
				assign ball1_bt = ball1_hit_bt1 | ball1_hit_bt2 | ball1_hit_bt3 | ball1_hit_bt4;
			 
				assign ball2_tp = ball2_hit_top1 | ball2_hit_top2 | ball2_hit_top3 ;
				assign ball2_m1 = ball2_hit_md1 | ball2_hit_md2 | ball2_hit_md3 | ball2_hit_md4;
				assign ball2_m2 = ball2_hit_md5 | ball2_hit_md6 | ball2_hit_md7 | ball2_hit_md8;
				assign ball2_bt = ball2_hit_bt1 | ball2_hit_bt2 | ball2_hit_bt3 | ball2_hit_bt4;
				
				assign ball1_hit_dewall = ball1_tp | ball1_m1 | ball1_m2 | ball1_bt ;
				assign ball2_hit_dewall = ball2_tp | ball2_m1 | ball2_m2 | ball2_bt ;
		
				/********************** Three Desturctible block  at the top****************/	
				 parameter [9:0] Top1_X_MAX = 10'd303;  
				 parameter [9:0] Top1_X_MIN = 10'd288;  	
				 parameter [9:0] Top1_Y_MAX = 10'd79;
				 parameter [9:0] Top1_Y_MIN = 10'd64;
				 
				 parameter [9:0] Top2_X_MAX = 10'd303;  
				 parameter [9:0] Top2_X_MIN = 10'd288;  	
				 parameter [9:0] Top2_Y_MAX = 10'd95;
				 parameter [9:0] Top2_Y_MIN = 10'd80;
				 
				 parameter [9:0] Top3_X_MAX = 10'd303;  
				 parameter [9:0] Top3_X_MIN = 10'd288;  	
				 parameter [9:0] Top3_Y_MAX = 10'd111;
				 parameter [9:0] Top3_Y_MIN = 10'd96;
				 
				 
		/********************** Four Desturctible block  at the middle left ****************/			 
				 parameter [9:0] Md1_X_MAX = 10'd255;  
				 parameter [9:0] Md1_X_MIN = 10'd240;  	
				 parameter [9:0] Md1_Y_MAX = 10'd239;
				 parameter [9:0] Md1_Y_MIN = 10'd224;
				 
				 parameter [9:0] Md2_X_MAX = 10'd255;  
				 parameter [9:0] Md2_X_MIN = 10'd240;  	
				 parameter [9:0] Md2_Y_MAX = 10'd255;
				 parameter [9:0] Md2_Y_MIN = 10'd240;
				 
				 parameter [9:0] Md3_X_MAX = 10'd255;  
				 parameter [9:0] Md3_X_MIN = 10'd240;  	
				 parameter [9:0] Md3_Y_MAX = 10'd271;
				 parameter [9:0] Md3_Y_MIN = 10'd256;
				 
				 parameter [9:0] Md4_X_MAX = 10'd255;  
				 parameter [9:0] Md4_X_MIN = 10'd240;  	
				 parameter [9:0] Md4_Y_MAX = 10'd287;
				 parameter [9:0] Md4_Y_MIN = 10'd272;
				 
				 
		/********************** Three Desturctible block  at the middle right ****************/			 
				
				 parameter [9:0] Md5_X_MAX = 10'd351;  
				 parameter [9:0] Md5_X_MIN = 10'd336;  	
				 parameter [9:0] Md5_Y_MAX = 10'd239;
				 parameter [9:0] Md5_Y_MIN = 10'd224;
				 
				 parameter [9:0] Md6_X_MAX = 10'd351;  
				 parameter [9:0] Md6_X_MIN = 10'd336;  	
				 parameter [9:0] Md6_Y_MAX = 10'd255;
				 parameter [9:0] Md6_Y_MIN = 10'd240;
				 
		
				 parameter [9:0] Md7_X_MAX = 10'd351;  
				 parameter [9:0] Md7_X_MIN = 10'd336;  	
				 parameter [9:0] Md7_Y_MAX = 10'd271;
				 parameter [9:0] Md7_Y_MIN = 10'd256;
				 
				 parameter [9:0] Md8_X_MAX = 10'd351;  
				 parameter [9:0] Md8_X_MIN = 10'd336;  	
				 parameter [9:0] Md8_Y_MAX = 10'd287;
				 parameter [9:0] Md8_Y_MIN = 10'd272;
				 
				 
		/********************** Four Desturctible block  at the bottom ****************/			 
				
				 parameter [9:0] Bt1_X_MAX = 10'd223;  
				 parameter [9:0] Bt1_X_MIN = 10'd208;  	
				 parameter [9:0] Bt1_Y_MAX = 10'd319;
				 parameter [9:0] Bt1_Y_MIN = 10'd304;
				 
				 parameter [9:0] Bt2_X_MAX = 10'd223;  
				 parameter [9:0] Bt2_X_MIN = 10'd208;  	
				 parameter [9:0] Bt2_Y_MAX = 10'd335;
				 parameter [9:0] Bt2_Y_MIN = 10'd320;
				 
		
				 parameter [9:0] Bt3_X_MAX = 10'd415;  
				 parameter [9:0] Bt3_X_MIN = 10'd400;  	
				 parameter [9:0] Bt3_Y_MAX = 10'd367;
				 parameter [9:0] Bt3_Y_MIN = 10'd352;
				 
				 parameter [9:0] Bt4_X_MAX = 10'd415;  
				 parameter [9:0] Bt4_X_MIN = 10'd400;  	
				 parameter [9:0] Bt4_Y_MAX = 10'd383;
				 parameter [9:0] Bt4_Y_MIN = 10'd368;		 
				 
	/***************************** Create instance ******************************************/	
	
				 destructible_wall top1( .*,
												.X_MAX(Top1_X_MAX), 
												.X_MIN(Top1_X_MIN), 
												.Y_MAX(Top1_Y_MAX), 
												.Y_MIN(Top1_Y_MIN), 
												.game_start_flag,
												.before_game_flag,
												.is_dewall(is_dewalltop1),           
												.ball1_hit_dwall(ball1_hit_top1),
												.ball2_hit_dwall(ball2_hit_top1),
												.right_stop1(right_stop1_tp1), 
												.left_stop1(left_stop1_tp1), 
												.up_stop1(up_stop1_tp1), 
												.down_stop1(down_stop1_tp1),
												.right_stop2(right_stop2_tp1), 
												.left_stop2(left_stop2_tp1), 
												.up_stop2(up_stop2_tp1), 
												.down_stop2(down_stop2_tp1) 
											); 
				  
				destructible_wall top2( .*,
												.X_MAX(Top2_X_MAX), 
												.X_MIN(Top2_X_MIN), 
												.Y_MAX(Top2_Y_MAX), 
												.Y_MIN(Top2_Y_MIN), 
												.game_start_flag,
												.before_game_flag,
												.is_dewall(is_dewalltop2),           
												.ball1_hit_dwall(ball1_hit_top2),
												.ball2_hit_dwall(ball2_hit_top2),
												.right_stop1(right_stop1_tp2), 
												.left_stop1(left_stop1_tp2), 
												.up_stop1(up_stop1_tp2), 
												.down_stop1(down_stop1_tp2),
												.right_stop2(right_stop2_tp2), 
												.left_stop2(left_stop2_tp2), 
												.up_stop2(up_stop2_tp2), 
												.down_stop2(down_stop2_tp2) 
											); 
											
				destructible_wall top3( .*,
												.X_MAX(Top3_X_MAX), 
												.X_MIN(Top3_X_MIN), 
												.Y_MAX(Top3_Y_MAX), 
												.Y_MIN(Top3_Y_MIN), 
												.game_start_flag,
												.before_game_flag,
												.is_dewall(is_dewalltop3),           
												.ball1_hit_dwall(ball1_hit_top3),
												.ball2_hit_dwall(ball2_hit_top3),
												.right_stop1(right_stop1_tp3), 
												.left_stop1(left_stop1_tp3), 
												.up_stop1(up_stop1_tp3), 
												.down_stop1(down_stop1_tp3),
												.right_stop2(right_stop2_tp3), 
												.left_stop2(left_stop2_tp3), 
												.up_stop2(up_stop2_tp3), 
												.down_stop2(down_stop2_tp3) 
											); 
				    
			destructible_wall mid1( .*,
												.X_MAX(Md1_X_MAX), 
												.X_MIN(Md1_X_MIN), 
												.Y_MAX(Md1_Y_MAX), 
												.Y_MIN(Md1_Y_MIN), 
												.game_start_flag,
												.before_game_flag,
												.is_dewall(is_dewallmd1),           
												.ball1_hit_dwall(ball1_hit_md1),
												.ball2_hit_dwall(ball2_hit_md1),
												.right_stop1(right_stop1_md1), 
												.left_stop1(left_stop1_md1), 
												.up_stop1(up_stop1_md1), 
												.down_stop1(down_stop1_md1),
												.right_stop2(right_stop2_md1), 
												.left_stop2(left_stop2_md1), 
												.up_stop2(up_stop2_md1), 
												.down_stop2(down_stop2_md1) 
											); 
				    
			
			destructible_wall mid2( .*,
												.X_MAX(Md2_X_MAX), 
												.X_MIN(Md2_X_MIN), 
												.Y_MAX(Md2_Y_MAX), 
												.Y_MIN(Md2_Y_MIN),
												.game_start_flag,
												.before_game_flag,	
												.is_dewall(is_dewallmd2),           
												.ball1_hit_dwall(ball1_hit_md2),
												.ball2_hit_dwall(ball2_hit_md2),
												.right_stop1(right_stop1_md2), 
												.left_stop1(left_stop1_md2), 
												.up_stop1(up_stop1_md2), 
												.down_stop1(down_stop1_md2),
												.right_stop2(right_stop2_md2), 
												.left_stop2(left_stop2_md2), 
												.up_stop2(up_stop2_md2), 
												.down_stop2(down_stop2_md2) 
											); 
											
											
			destructible_wall mid3( .*,
												.X_MAX(Md3_X_MAX), 
												.X_MIN(Md3_X_MIN), 
												.Y_MAX(Md3_Y_MAX), 
												.Y_MIN(Md3_Y_MIN), 
												.game_start_flag,
												.before_game_flag,
												.is_dewall(is_dewallmd3),           
												.ball1_hit_dwall(ball1_hit_md3),
												.ball2_hit_dwall(ball2_hit_md3),
												.right_stop1(right_stop1_md3), 
												.left_stop1(left_stop1_md3), 
												.up_stop1(up_stop1_md3), 
												.down_stop1(down_stop1_md3),
												.right_stop2(right_stop2_md3), 
												.left_stop2(left_stop2_md3), 
												.up_stop2(up_stop2_md3), 
												.down_stop2(down_stop2_md3) 
											); 
											
											
											
		destructible_wall mid4( .*,
												.X_MAX(Md4_X_MAX), 
												.X_MIN(Md4_X_MIN), 
												.Y_MAX(Md4_Y_MAX), 
												.Y_MIN(Md4_Y_MIN), 
												.game_start_flag,
												.before_game_flag,
												.is_dewall(is_dewallmd4),           
												.ball1_hit_dwall(ball1_hit_md4),
												.ball2_hit_dwall(ball2_hit_md4),
												.right_stop1(right_stop1_md4), 
												.left_stop1(left_stop1_md4), 
												.up_stop1(up_stop1_md4), 
												.down_stop1(down_stop1_md4),
												.right_stop2(right_stop2_md4), 
												.left_stop2(left_stop2_md4), 
												.up_stop2(up_stop2_md4), 
												.down_stop2(down_stop2_md4) 
											); 

	destructible_wall mid5( 			.*,
												.X_MAX(Md5_X_MAX), 
												.X_MIN(Md5_X_MIN), 
												.Y_MAX(Md5_Y_MAX), 
												.Y_MIN(Md5_Y_MIN), 
												.game_start_flag,
												.before_game_flag,
												.is_dewall(is_dewallmd5),           
												.ball1_hit_dwall(ball1_hit_md5),
												.ball2_hit_dwall(ball2_hit_md5),
												.right_stop1(right_stop1_md5), 
												.left_stop1(left_stop1_md5), 
												.up_stop1(up_stop1_md5), 
												.down_stop1(down_stop1_md5),
												.right_stop2(right_stop2_md5), 
												.left_stop2(left_stop2_md5), 
												.up_stop2(up_stop2_md5), 
												.down_stop2(down_stop2_md5) 
											); 
	destructible_wall mid6( 			.*,
												.X_MAX(Md6_X_MAX), 
												.X_MIN(Md6_X_MIN), 
												.Y_MAX(Md6_Y_MAX), 
												.Y_MIN(Md6_Y_MIN), 
												.game_start_flag,
												.before_game_flag,
												.is_dewall(is_dewallmd6),           
												.ball1_hit_dwall(ball1_hit_md6),
												.ball2_hit_dwall(ball2_hit_md6),
												.right_stop1(right_stop1_md6), 
												.left_stop1(left_stop1_md6), 
												.up_stop1(up_stop1_md6), 
												.down_stop1(down_stop1_md6),
												.right_stop2(right_stop2_md6), 
												.left_stop2(left_stop2_md6), 
												.up_stop2(up_stop2_md6), 
												.down_stop2(down_stop2_md6) 
											); 
											
	destructible_wall mid7( 			.*,
												.X_MAX(Md7_X_MAX), 
												.X_MIN(Md7_X_MIN), 
												.Y_MAX(Md7_Y_MAX), 
												.Y_MIN(Md7_Y_MIN),
												.game_start_flag,
												.before_game_flag,	
												.is_dewall(is_dewallmd7),           
												.ball1_hit_dwall(ball1_hit_md7),
												.ball2_hit_dwall(ball2_hit_md7),
												.right_stop1(right_stop1_md7), 
												.left_stop1(left_stop1_md7), 
												.up_stop1(up_stop1_md7), 
												.down_stop1(down_stop1_md7),
												.right_stop2(right_stop2_md7), 
												.left_stop2(left_stop2_md7), 
												.up_stop2(up_stop2_md7), 
												.down_stop2(down_stop2_md7) 
											); 
											
	destructible_wall mid8( 			.*,
												.X_MAX(Md8_X_MAX), 
												.X_MIN(Md8_X_MIN), 
												.Y_MAX(Md8_Y_MAX), 
												.Y_MIN(Md8_Y_MIN), 
												.game_start_flag,
												.before_game_flag,
												.is_dewall(is_dewallmd8),           
												.ball1_hit_dwall(ball1_hit_md8),
												.ball2_hit_dwall(ball2_hit_md8),
												.right_stop1(right_stop1_md8), 
												.left_stop1(left_stop1_md8), 
												.up_stop1(up_stop1_md8), 
												.down_stop1(down_stop1_md8),
												.right_stop2(right_stop2_md8), 
												.left_stop2(left_stop2_md8), 
												.up_stop2(up_stop2_md8), 
												.down_stop2(down_stop2_md8) 
											); 

	destructible_wall bt1( 			.*,
												.X_MAX(Bt1_X_MAX), 
												.X_MIN(Bt1_X_MIN), 
												.Y_MAX(Bt1_Y_MAX), 
												.Y_MIN(Bt1_Y_MIN), 
												.game_start_flag,
												.before_game_flag,
												.is_dewall(is_dewallbt1),           
												.ball1_hit_dwall(ball1_hit_bt1),
												.ball2_hit_dwall(ball2_hit_bt1),
												.right_stop1(right_stop1_bt1), 
												.left_stop1(left_stop1_bt1), 
												.up_stop1(up_stop1_bt1), 
												.down_stop1(down_stop1_bt1),
												.right_stop2(right_stop2_bt1), 
												.left_stop2(left_stop2_bt1), 
												.up_stop2(up_stop2_bt1), 
												.down_stop2(down_stop2_bt1) 
											); 

	destructible_wall bt2( 			.*,
												.X_MAX(Bt2_X_MAX), 
												.X_MIN(Bt2_X_MIN), 
												.Y_MAX(Bt2_Y_MAX), 
												.Y_MIN(Bt2_Y_MIN), 
												.game_start_flag,
												.before_game_flag,
												.is_dewall(is_dewallbt2),           
												.ball1_hit_dwall(ball1_hit_bt2),
												.ball2_hit_dwall(ball2_hit_bt2),
												.right_stop1(right_stop1_bt2), 
												.left_stop1(left_stop1_bt2), 
												.up_stop1(up_stop1_bt2), 
												.down_stop1(down_stop1_bt2),
												.right_stop2(right_stop2_bt2), 
												.left_stop2(left_stop2_bt2), 
												.up_stop2(up_stop2_bt2), 
												.down_stop2(down_stop2_bt2) 
											); 
											
	destructible_wall bt3( 			.*,
												.X_MAX(Bt3_X_MAX), 
												.X_MIN(Bt3_X_MIN), 
												.Y_MAX(Bt3_Y_MAX), 
												.Y_MIN(Bt3_Y_MIN), 
												.game_start_flag,
												.before_game_flag,
												.is_dewall(is_dewallbt3),           
												.ball1_hit_dwall(ball1_hit_bt3),
												.ball2_hit_dwall(ball2_hit_bt3),
												.right_stop1(right_stop1_bt3), 
												.left_stop1(left_stop1_bt3), 
												.up_stop1(up_stop1_bt3), 
												.down_stop1(down_stop1_bt3),
												.right_stop2(right_stop2_bt3), 
												.left_stop2(left_stop2_bt3), 
												.up_stop2(up_stop2_bt3), 
												.down_stop2(down_stop2_bt3) 
											); 
			
	destructible_wall bt4( 			.*,
												.X_MAX(Bt4_X_MAX), 
												.X_MIN(Bt4_X_MIN), 
												.Y_MAX(Bt4_Y_MAX), 
												.Y_MIN(Bt4_Y_MIN), 
												.game_start_flag,
												.before_game_flag,
												.is_dewall(is_dewallbt4),           
												.ball1_hit_dwall(ball1_hit_bt4),
												.ball2_hit_dwall(ball2_hit_bt4),
												.right_stop1(right_stop1_bt4), 
												.left_stop1(left_stop1_bt4), 
												.up_stop1(up_stop1_bt4), 
												.down_stop1(down_stop1_bt4),
												.right_stop2(right_stop2_bt4), 
												.left_stop2(left_stop2_bt4), 
												.up_stop2(up_stop2_bt4), 
												.down_stop2(down_stop2_bt4) 
											); 
			
endmodule