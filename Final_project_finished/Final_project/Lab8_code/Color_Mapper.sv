//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input              is_tank1,           
								input					is_tank2,
								input 				is_ball1,
								input					is_ball2,
								input 				is_boom1,
								input					is_boom2,
								input 				is_base2,
								input					is_base1,
								input 				is_bloodvolume,
								input 				is_indestructiblewall,
								input 				is_interface,
								input					is_gameover_1win,
								input 				is_gameover_2win,
								input 				is_dewall,
								// debug signal
								input 				is_fire,
								
								
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
							  input 			[23:0] color, wallbaserom_dout,bloodvolrom_dout,beforestartrom_dout,gameoverrom_dout,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Assign color based on is_ball signal
    always_comb
    begin
		 if (is_boom1 == 1'b1 ||is_boom2 == 1'b1 )
		  begin
            // tank, cannonball, explosion
            Red = color[23:16];
            Green = color[15:8];
            Blue = color[7:0];
        end
	 
	 
	 
		  else if (is_base2 == 1'b1 || is_base1 == 1'b1 || is_indestructiblewall==1'b1 || is_dewall==1'b1)
		  begin
				Red = wallbaserom_dout[23:16];
            Green = wallbaserom_dout[15:8];
            Blue = wallbaserom_dout[7:0];
		  end
		  
        else if (is_tank1 == 1'b1 ||  is_ball1 == 1'b1 || is_tank2 == 1'b1 || is_ball2 == 1'b1) 
        begin
            // tank, cannonball, explosion
            Red = color[23:16];
            Green = color[15:8];
            Blue = color[7:0];
        end
		  
		  else if(is_bloodvolume == 1'b1 )
		  begin
				Red = bloodvolrom_dout[23:16];
            Green = bloodvolrom_dout[15:8];
            Blue = bloodvolrom_dout[7:0];
		  end
		  else if(is_interface == 1'b1)
		  begin
				Red = beforestartrom_dout[23:16]; 
            Green = beforestartrom_dout[15:8];
            Blue = beforestartrom_dout[7:0];
		  end
		  else if(is_gameover_1win == 1'b1 || is_gameover_2win == 1'b1)
		  begin
				Red = gameoverrom_dout[23:16]; 
            Green = gameoverrom_dout[15:8];
            Blue = gameoverrom_dout[7:0];
		  end
        else 
        begin
            // Background with nice color gradient
//            Red = 8'h3f; 
//            Green = 8'h00;
//            Blue = 8'h7f - {1'b0, DrawX[9:3]};
				Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00;
        end
    end 
    
endmodule
