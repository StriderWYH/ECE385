module bloodvolume ( input [9:0]   DrawX, DrawY,  
							input logic [2:0] base2_HP,base1_HP, 
							input logic game_start_flag,
							input logic is_mp1,
							output logic[18:0] address,
							output logic is_bloodvolume
);

 parameter [9:0] vol21_lu_X = 10'd570 + 10;  
 parameter [9:0] vol21_lu_Y = 10'd50;  
 parameter [9:0] vol22_lu_X = 10'd591 + 10;      
 parameter [9:0] vol22_lu_Y = 10'd50;     
 parameter [9:0] vol23_lu_X = 10'd612 + 10;      
 parameter [9:0] vol23_lu_Y = 10'd50;     
 parameter [9:0] vol24_lu_X = 10'd580 + 10;     
 parameter [9:0] vol24_lu_Y = 10'd70;      
 parameter [9:0] vol25_lu_X = 10'd601 + 10;        
 parameter [9:0] vol25_lu_Y = 10'd70; 
 parameter [9:0] vol26_lu_X = 10'd590 + 10;        
 parameter [9:0] vol26_lu_Y = 10'd90; 
 
 parameter [9:0] vol_size = 10'd15;
 
 parameter [9:0] vol1_lu_X = 10'd10 - 8;  
 parameter [9:0] vol1_lu_Y = 10'd50 ;  
 parameter [9:0] vol2_lu_X = 10'd31 - 8;      
 parameter [9:0] vol2_lu_Y = 10'd50;     
 parameter [9:0] vol3_lu_X = 10'd52 - 8;      
 parameter [9:0] vol3_lu_Y = 10'd50;     
 parameter [9:0] vol4_lu_X = 10'd20 - 8;     
 parameter [9:0] vol4_lu_Y = 10'd70;      
 parameter [9:0] vol5_lu_X = 10'd41 - 8;        
 parameter [9:0] vol5_lu_Y = 10'd70; 
 parameter [9:0] vol6_lu_X = 10'd30 - 8;        
 parameter [9:0] vol6_lu_Y = 10'd90; 
 
 parameter [9:0] mp1_X_MAX = 10'd319;  
 parameter [9:0] mp1_X_MIN = 10'd304;  	
 parameter [9:0] mp1_Y_MAX = 10'd447;
 parameter [9:0] mp1_Y_MIN = 10'd432;
 
 
 /**************************** For base2 ****************************/
 
 
 int  Size;
 
 assign Size = vol_size;
 
always_comb begin
		address = 19'b0;
		is_bloodvolume = 1'b0;
		

		if(base2_HP >= 3'b001 	&& DrawX >= vol21_lu_X && DrawX <= vol21_lu_X + Size 
			&& game_start_flag == 1'b1 && DrawY >= vol21_lu_Y && DrawY <= vol21_lu_Y + Size)
		begin
			address = 16*(DrawY-vol21_lu_Y) + DrawX-vol21_lu_X;
			is_bloodvolume = 1'b1;
		end
		else if (base2_HP >= 3'b010 	&& DrawX >= vol22_lu_X && DrawX <= vol22_lu_X + Size 
					&& game_start_flag == 1'b1 && DrawY >= vol22_lu_Y && DrawY <= vol22_lu_Y + Size)
		begin
			address = 16*(DrawY-vol22_lu_Y) + DrawX-vol22_lu_X;
			is_bloodvolume = 1'b1;
		end
		else if (base2_HP >= 3'b011	&& DrawX >= vol23_lu_X && DrawX <= vol23_lu_X + Size 
					&& game_start_flag == 1'b1 && DrawY >= vol23_lu_Y && DrawY <= vol23_lu_Y + Size)
		begin
			address = 16*(DrawY-vol23_lu_Y) + DrawX-vol23_lu_X;
			is_bloodvolume = 1'b1;
		end
		else if (base2_HP >= 3'b100	&& DrawX >= vol24_lu_X && DrawX <= vol24_lu_X + Size 
					&& game_start_flag == 1'b1 && DrawY >= vol24_lu_Y && DrawY <= vol24_lu_Y + Size)
		begin
			address = 16*(DrawY-vol24_lu_Y) + DrawX-vol24_lu_X;
			is_bloodvolume = 1'b1;
		end
		else if (base2_HP >= 3'b101	&& DrawX >= vol25_lu_X && DrawX <= vol25_lu_X + Size 
					&& game_start_flag == 1'b1 && DrawY >= vol25_lu_Y && DrawY <= vol25_lu_Y + Size)
		begin
			address = 16*(DrawY-vol25_lu_Y) + DrawX-vol25_lu_X;
			is_bloodvolume = 1'b1;
		end
		else if (base2_HP >= 3'b110	&& DrawX >= vol26_lu_X && DrawX <= vol26_lu_X + Size 
					&& game_start_flag == 1'b1 && DrawY >= vol26_lu_Y && DrawY <= vol26_lu_Y + Size)
		begin
			address = 16*(DrawY-vol26_lu_Y) + DrawX-vol26_lu_X;
			is_bloodvolume = 1'b1;
		end
		
		
		
		if(base1_HP >= 3'b001 	&& DrawX >= vol1_lu_X && DrawX <= vol1_lu_X + Size 
			&& game_start_flag == 1'b1 && DrawY >= vol1_lu_Y && DrawY <= vol1_lu_Y + Size)
		begin
			address = 16*(DrawY-vol1_lu_Y) + DrawX-vol1_lu_X;
			is_bloodvolume = 1'b1;
		end
		else if (base1_HP >= 3'b010 	&& DrawX >= vol2_lu_X && DrawX <= vol2_lu_X + Size 
					&& game_start_flag == 1'b1 && DrawY >= vol2_lu_Y && DrawY <= vol2_lu_Y + Size)
		begin
			address = 16*(DrawY-vol2_lu_Y) + DrawX-vol2_lu_X;
			is_bloodvolume = 1'b1;
		end
		else if (base1_HP >= 3'b011	&& DrawX >= vol3_lu_X && DrawX <= vol3_lu_X + Size 
					&& game_start_flag == 1'b1 && DrawY >= vol3_lu_Y && DrawY <= vol3_lu_Y + Size)
		begin
			address = 16*(DrawY-vol3_lu_Y) + DrawX-vol3_lu_X;
			is_bloodvolume = 1'b1;
		end
		else if (base1_HP >= 3'b100 && DrawX >= vol4_lu_X && DrawX <= vol4_lu_X + Size 
					&& game_start_flag == 1'b1 && DrawY >= vol4_lu_Y && DrawY <= vol4_lu_Y + Size)
		begin
			address = 16*(DrawY-vol4_lu_Y) + DrawX-vol4_lu_X;
			is_bloodvolume = 1'b1;
		end
		else if (base1_HP >= 3'b101 && DrawX >= vol5_lu_X && DrawX <= vol5_lu_X + Size 
					&& game_start_flag == 1'b1 && DrawY >= vol5_lu_Y && DrawY <= vol5_lu_Y + Size)
		begin
			address = 16*(DrawY-vol5_lu_Y) + DrawX-vol5_lu_X;
			is_bloodvolume = 1'b1;
		end
		else if (base1_HP >= 3'b110 && DrawX >= vol6_lu_X && DrawX <= vol6_lu_X + Size 
					&& game_start_flag == 1'b1 && DrawY >= vol6_lu_Y && DrawY <= vol6_lu_Y + Size)
		begin
			address = 16*(DrawY-vol6_lu_Y) + DrawX-vol6_lu_X;
			is_bloodvolume = 1'b1;
		end
		
		
		
		
		if(is_mp1 == 1'b1 && DrawX >= mp1_X_MIN && DrawX <= mp1_X_MAX && DrawY >= mp1_Y_MIN && DrawY <= mp1_Y_MAX)
		begin
			address = 16*(DrawY-mp1_Y_MIN) + DrawX-mp1_X_MIN ;
			is_bloodvolume = 1'b1;
		end
 
 end	

 
	 

		
 
endmodule