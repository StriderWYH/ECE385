
module address_lookup(input logic is_tank1, is_tank2,is_ball1,is_ball2, is_boom1,is_boom2,is_base2,is_base1,base2_ruin,base1_ruin,is_dewall,
							input logic is_indestructiblewall,
							input logic[1:0] tank1_direction,tank2_direction,
							input [9:0] DrawX, DrawY, 
							input logic [9:0] tank1_upleft_X, tank1_upleft_Y,tank2_upleft_X, tank2_upleft_Y,
							input logic [9:0] cannonball_X_Pos, cannonball_Y_Pos,cannonball2_X_Pos, cannonball2_Y_Pos,
							input logic is_interface, is_gameover_1win, is_gameover_2win,
							output logic[18:0] address
);
always_comb
begin
	
	address = 19'b0;
	
	
	
	
	if(is_boom1 == 1)
	begin
		address = 2048 + 16*(DrawY - cannonball_Y_Pos + 7) + DrawX - cannonball_X_Pos + 7;
	end
	else if(is_boom2 == 1)
	begin
		address = 2048 + 16*(DrawY - cannonball2_Y_Pos + 7) + DrawX - cannonball2_X_Pos + 7;
	end
	
	else if(is_dewall)
	begin
		address = 256 + 16*(DrawY - ((DrawY>>4)*16)) + DrawX - (DrawX>>4)*16;
		//address = 256 + 16*(DrawY - ((DrawY<<4)*16)) + DrawX - (DrawX<<4)*16;
	end
	
	
	else if(is_indestructiblewall)
	begin
		address = 512 + 16*(DrawY - ((DrawY>>4)*16)) + DrawX - (DrawX>>4)*16;
	end
	
	
	else if(is_ball1 == 1 )
	begin
		
		address = 2304 + 16*(DrawY - cannonball_Y_Pos + 2) + DrawX - cannonball_X_Pos + 2;
		//address = 2382;
	end
	
	
	else if(is_ball2 == 1 )
	begin
		
		address = 2304 + 16*(DrawY - cannonball2_Y_Pos + 2) + DrawX - cannonball2_X_Pos + 2;
		//address = 2382;
	end
	
	
	else if(is_tank1 == 1'b1 )
	begin
		address = 16*(DrawY-tank1_upleft_Y) + DrawX-tank1_upleft_X;
		if(tank1_direction == 2'b00 ) // 'W' up
			begin
				address = address + 19'b0;
			end
			else if(tank1_direction == 2'b01) // 'A' left
			begin
				address = address + 256;
			end
			else if(tank1_direction == 2'b10) // 'S' down
			begin
				address = address + 512;
			end
			else if(tank1_direction == 2'b11) // 'D' right
			begin
				address = address + 768;
			end
	end
	
	
	else if(is_tank2 == 1'b1)
	begin
			address = 1024+ 16*(DrawY-tank2_upleft_Y) + DrawX-tank2_upleft_X;
		if(tank2_direction == 2'b00 ) // 'I' up
			begin
				address = address + 19'b0;
			end
			else if(tank2_direction == 2'b01) // 'J' left
			begin
				address = address + 256;
			end
			else if(tank2_direction == 2'b10) // 'K' down
			begin
				address = address + 512;
			end
			else if(tank2_direction == 2'b11) // 'L' right
			begin
				address = address + 768;
			end
	end
	
	
	else if(is_base2)
	begin
		address = 16*(DrawY - 240) + DrawX - 544;
	end
	
	
	else if(is_base1)
	begin
		address = 16*(DrawY - 240) + DrawX - 80;
	end
	
	
	else if(is_interface)
	begin
		address = 196*(DrawY - 194) + DrawX - 222;
	end
	
	
	else if(is_gameover_1win)
	begin
		address = 196*(DrawY - 198) + DrawX - 222;
	end
	
	else if (is_gameover_2win)
	begin
		address = 196*99 + 196*(DrawY - 198) + DrawX - 222;
	end
	
	
	
	
end
	
//	else if(is_fire == 1'b1)
//	begin
//		address = 2382;
//	end
 
	


endmodule