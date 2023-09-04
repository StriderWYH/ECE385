//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk;
    logic [31:0] keycode;
	 
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    logic[9:0] drawxsig,drawysig;
	 
/************************************************************************************/	 
	logic [23:0] spriterom_dout,wallbaserom_dout,bloodvolrom_dout, gameoverrom_dout, beforestartrom_dout;
	logic [1:0] tank1_direction,tank2_direction;
	logic [9:0] tank1_upleft_X, tank1_upleft_Y,tank2_upleft_X, tank2_upleft_Y;
	logic [9:0] cannonball_X_Pos,cannonball_Y_Pos,cannonball2_X_Pos,cannonball2_Y_Pos;
	logic[18:0] ROM_address,bloodv_addr;
	
	logic is_tank1,is_tank2;
	logic is_ball1,is_ball2;
	logic is_boom1,is_boom2;
	logic is_base2,is_base1;
	logic is_bloodvolume;
	logic [2:0] base2_HP,base1_HP;
	logic base2_ruin,base1_ruin;
	logic ball1_hit_base2,ball2_hit_base1;
	
	logic ball1_boom,ball2_boom;
	logic ball2_hit_tank1,ball1_hit_tank2;
	
	logic hit_indes_wall;
	logic hit_indes_wall2;
	logic hit_des_wall;
	logic tank_stop1;
	logic is_indestructiblewall;
	logic is_destructiblewall;
	logic right_stop1_indes1, left_stop1_indes1, up_stop1_indes1, down_stop1_indes1;
	logic right_stop1_indes2, left_stop1_indes2, up_stop1_indes2, down_stop1_indes2;
	logic right_stop1_des, left_stop1_des, up_stop1_des, down_stop1_des;
	logic right_stop1_base21, left_stop1_base21, up_stop1_base21, down_stop1_base21;
	logic right_stop1_base22, left_stop1_base22, up_stop1_base22, down_stop1_base22;
	logic right_stop1_base11, left_stop1_base11, up_stop1_base11, down_stop1_base11;
	logic right_stop1_base12, left_stop1_base12, up_stop1_base12, down_stop1_base12;
	
	logic is_interface;
	logic is_gameover_1win;
	logic is_gameover_2win;
	logic before_game_flag;
	logic game_start_flag;
	
	logic is_mp1;
	logic add_base1_hp;
	logic add_base2_hp;
	logic tank1_ruin,tank2_ruin;
	
	logic is_dewall;            
	logic ball1_hit_dewall,ball2_hit_dewall;
	logic right_stop1_dewall,left_stop1_dewall, up_stop1_dewall, down_stop1_dewall;
	logic right_stop2_dewall,left_stop2_dewall, up_stop2_dewall, down_stop2_dewall;
	
	//debug signal
	logic is_fire;
	logic ball1_air,ball2_air;
	logic ball_rdy;
	
	
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance( .Clk(ClK), 
								 .Reset(Reset_h), 
								 .VGA_HS(VGA_HS),
								 .VGA_VS(VGA_VS), 
								 .VGA_CLK(VGA_CLK),
								 .VGA_BLANK_N(VGA_BLANK_N),
								 .VGA_SYNC_N(VGA_SYNC_N),
								 .DrawX(drawxsig),
								 .DrawY(drawysig));
  /*********************************************************************************/  
    // Which signal should be frame_clk?
    tank1 tank1_instance( .Clk,
							.Reset(Reset_h),
						 .frame_clk(VGA_VS),
						 .keycode(keycode),
						 .DrawX(drawxsig),
						 .DrawY(drawysig),
						 .cannonball2_X_Pos(cannonball2_X_Pos),
						 .cannonball2_Y_Pos(cannonball2_Y_Pos),
						 .ball_boom(ball2_boom),
						 .game_start_flag,
						 .right_stop1(right_stop1_indes1|right_stop1_base21|right_stop1_base11|right_stop1_dewall),
						 .left_stop1(left_stop1_indes1|left_stop1_base21|left_stop1_base11|left_stop1_dewall),
						 .up_stop1(up_stop1_indes1|up_stop1_base21|up_stop1_base11|up_stop1_dewall),
						 .down_stop1(down_stop1_indes1|down_stop1_base21|down_stop1_base11|down_stop1_dewall),
						 .tank2_ruin,
						 .ball_air(ball2_air),
						 .base_ruin(base1_ruin | base2_ruin),
						 .tank1_upleft_X, 
						 .tank1_upleft_Y,
						 .is_tank1(is_tank1),
						 .tank1_direction(tank1_direction),
						 .ball2_hit_tank1,
						 .tank1_ruin
						);
						 
	 tank2 tank2_instance( .Clk,
							.Reset(Reset_h),
						 .frame_clk(VGA_VS),
						 .keycode(keycode),
						 .DrawX(drawxsig),
						 .DrawY(drawysig),
						 .cannonball1_X_Pos(cannonball_X_Pos),
						 .cannonball1_Y_Pos(cannonball_Y_Pos),
						 .ball_boom(ball1_boom),
						 .game_start_flag,
						 .right_stop2(right_stop1_indes2|right_stop1_base22|right_stop1_base12|right_stop2_dewall),
						 .left_stop2(left_stop1_indes2|left_stop1_base22|left_stop1_base12|left_stop2_dewall),
						 .up_stop2(up_stop1_indes2|up_stop1_base22|up_stop1_base12|up_stop2_dewall),
						 .down_stop2(down_stop1_indes2|down_stop1_base22|down_stop1_base12|down_stop2_dewall),
						 .tank1_ruin,
						 .ball_air(ball1_air),
						 .base_ruin(base1_ruin | base2_ruin),
						 .tank2_upleft_X, 
						 .tank2_upleft_Y,
						 .is_tank2(is_tank2),
						 .tank2_direction(tank2_direction),
						 .ball1_hit_tank2,
						 .tank2_ruin
						);
    
    color_mapper color_instance( .*,
											.color(spriterom_dout), // add the color code
											.wallbaserom_dout,
											.bloodvolrom_dout,
											.beforestartrom_dout,
											.gameoverrom_dout,
											.DrawX(drawxsig),
											.DrawY(drawysig));
    
    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
	 HexDriver hex_inst_2 (keycode[11:8], HEX2);
	 HexDriver hex_inst_3 (keycode[15:12], HEX3);
	 HexDriver hex_inst_4 (keycode[19:16], HEX4);
	 HexDriver hex_inst_5 (keycode[23:20], HEX5);
	 HexDriver hex_inst_6 (keycode[27:24], HEX6);
	 HexDriver hex_inst_7 (keycode[31:28], HEX7);
/**************************************************************************************/
	

	spriteallROM spriteallrom( .read_address(ROM_address), .Clk, .data_Out(spriterom_dout));
	
	wallbaseROM  wallbaserom(	.read_address(ROM_address), .Clk, .data_Out(wallbaserom_dout));
	
	bloodvolROM	bloodvolrom(   .read_address(bloodv_addr), .Clk, .data_Out(bloodvolrom_dout));
	
	gameoverROM gameoverrom(	.read_address(ROM_address), .Clk, .data_Out(gameoverrom_dout));
	
	beforestartROM beforestartrom(	.read_address(ROM_address), .Clk, .data_Out(beforestartrom_dout));
	
	
	address_lookup address_lkup( .is_tank1,
							.is_tank2,
							.is_ball1,
							.is_ball2,
							.is_boom1,
							.is_boom2,
							.is_base2,
							.is_base1,
							.base2_ruin,
							.base1_ruin,
							.is_indestructiblewall,
							.is_dewall,
							.tank1_direction,
							.tank2_direction,
							.DrawX(drawxsig), 
							.DrawY(drawysig), 
							.tank1_upleft_X, 
							.tank1_upleft_Y,
							.tank2_upleft_X, 
							.tank2_upleft_Y,
							.cannonball_X_Pos,
							.cannonball_Y_Pos,
							.cannonball2_X_Pos,
							.cannonball2_Y_Pos,
							.is_interface, 
							.is_gameover_1win,
							.is_gameover_2win,
							.address(ROM_address)); 

	 
	 cannonball1 cannonball_instance1( .Clk, 
                           .Reset(Reset_h),              // Active-high reset signal
                           .frame_clk(VGA_VS),          // The clock indicating a new frame (~60Hz)
									.keycode,
									.tank1_upleft_X, 
									.tank1_upleft_Y,
									.tank1_direction,
									.DrawX(drawxsig), 
									.DrawY(drawysig),       // Current pixel coordinates
									.ball_hit(ball1_hit_base2|ball1_hit_tank2|hit_indes_wall|ball1_hit_dewall),   // need to be modified in the future
									.game_start_flag,
									.is_ball1,             // Whether current pixel belongs to ball or background
									.is_boom1,
									.cannonball_X_Pos,
									.cannonball_Y_Pos,
									.is_fire,
									.ball1_air,
									.ball_rdy,
									.ball1_boom
				  );
		
	 cannonball2 cannonball_instance2( .Clk, 
								.Reset(Reset_h),              // Active-high reset signal
								.frame_clk(VGA_VS),          // The clock indicating a new frame (~60Hz)
								.keycode,
								.tank2_upleft_X, 
								.tank2_upleft_Y,
								.tank2_direction,
								.DrawX(drawxsig), 
								.DrawY(drawysig),       // Current pixel coordinates
								.ball_hit(ball2_hit_base1|ball2_hit_tank1|hit_indes_wall2|ball2_hit_dewall),   // need to be modified in the future
								.game_start_flag,
								.is_ball2,             // Whether current pixel belongs to ball or background
								.is_boom2,
								.cannonball_X_Pos(cannonball2_X_Pos),
								.cannonball_Y_Pos(cannonball2_Y_Pos),
								.ball2_boom,
								.ball2_air
			  );
			  
		Base1 (					.Clk,                // 50 MHz clock
                           .Reset(Reset_h),              // Active-high reset signal
                           .frame_clk(VGA_VS),          // The clock indicating a new frame (~60Hz)
									.keycode,
									.DrawX(drawxsig), 
									.DrawY(drawysig),       // Current pixel coordinates
									.tank1_upleft_X, 
									.tank1_upleft_Y,
									.tank2_upleft_X, 
									.tank2_upleft_Y,
									.cannonball_X_Pos(cannonball2_X_Pos),
									.cannonball_Y_Pos(cannonball2_Y_Pos),
									.ball_boom(ball2_boom),
									.ball2_air,
									.game_start_flag,
									.before_game_flag,
									.add_base1_hp,
									.is_base1,             // Whether current pixel belongs to base
									.ball2_hit_base1,
									.base1_HP, 
									.base1_ruin,
									.right_stop1(right_stop1_base11), 
									.left_stop1(left_stop1_base11), 
									.up_stop1(up_stop1_base11), 
									.down_stop1(down_stop1_base11),
									.right_stop2(right_stop1_base12), 
									.left_stop2(left_stop1_base12), 
									.up_stop2(up_stop1_base12), 
									.down_stop2(down_stop1_base12)
				  );

		
		Base2 (					.Clk,                // 50 MHz clock
                           .Reset(Reset_h),              // Active-high reset signal
                           .frame_clk(VGA_VS),          // The clock indicating a new frame (~60Hz)
									.keycode,
									.DrawX(drawxsig), 
									.DrawY(drawysig),       // Current pixel coordinates
									.tank1_upleft_X, 
									.tank1_upleft_Y,
									.tank2_upleft_X,
									.tank2_upleft_Y,
									.cannonball_X_Pos,
									.cannonball_Y_Pos,
									.ball_boom(ball1_boom),
									.ball1_air,
									.game_start_flag,
									.before_game_flag,
									.add_base2_hp,
									.is_base2,             // Whether current pixel belongs to base
									.ball1_hit_base2,
									.base2_HP, 
									.base2_ruin,
									.right_stop1(right_stop1_base21), 
									.left_stop1(left_stop1_base21), 
									.up_stop1(up_stop1_base21), 
									.down_stop1(down_stop1_base21),
									.right_stop2(right_stop1_base22), 
									.left_stop2(left_stop1_base22), 
									.up_stop2(up_stop1_base22), 
									.down_stop2(down_stop1_base22)
				  );
				  
				  
				  
					  
    indestructible_wall indestructible_wall_instance(
									.Clk,                // 50 MHz clock
                           .Reset(Reset_h),              // Active-high reset signal
                           .frame_clk(VGA_VS),          // The clock indicating a new frame (~60Hz)
									.DrawX(drawxsig), 
									.DrawY(drawysig),
									.tank1_upleft_X, 
									.tank1_upleft_Y,		
									.tank2_upleft_X, 
									.tank2_upleft_Y,	
									.cannonball_X_Pos1(cannonball_X_Pos),
									.cannonball_Y_Pos1(cannonball_Y_Pos),	
									.cannonball_X_Pos2(cannonball2_X_Pos),
									.cannonball_Y_Pos2(cannonball2_Y_Pos),
									.game_start_flag,
									.is_indestructiblewall,								
									.ball_hit1(hit_indes_wall),
									.ball_hit2(hit_indes_wall2),							
									.right_stop1(right_stop1_indes1), 
									.left_stop1(left_stop1_indes1), 
									.up_stop1(up_stop1_indes1), 
									.down_stop1(down_stop1_indes1),
									.right_stop2(right_stop1_indes2), 
									.left_stop2(left_stop1_indes2), 
									.up_stop2(up_stop1_indes2), 
									.down_stop2(down_stop1_indes2)
									);
	
	main_interface main_interface(.Clk,                // 50 MHz clock
											.Reset(Reset_h),              // Active-high reset signal
											.frame_clk(VGA_VS),          // The clock indicating a new frame (~60Hz)
											.keycode,
											.DrawX(drawxsig),
											.DrawY(drawysig),       // Current pixel coordinates
											.game_over_flag(base1_ruin | base2_ruin),
											.base1_ruin,
											.base2_ruin,
											.is_interface,
											.is_gameover_1win,
											.is_gameover_2win,
											.before_game_flag,
											.game_start_flag
							);
		
	DE_WALL de_wall( 			.Clk,                // 50 MHz clock
                           .Reset(Reset_h),              // Active-high reset signal
                           .frame_clk(VGA_VS),          // The clock indicating a new frame (~60Hz)
									.keycode,
									.DrawX(drawxsig), 
									.DrawY(drawysig),       // Current pixel coordinates
									.tank1_upleft_X, 
									.tank1_upleft_Y,
									.tank2_upleft_X, 
									.tank2_upleft_Y,
									.cannonball1_X_Pos(cannonball_X_Pos),
									.cannonball1_Y_Pos(cannonball_Y_Pos),	
									.cannonball2_X_Pos(cannonball2_X_Pos),
									.cannonball2_Y_Pos(cannonball2_Y_Pos),
									.ball1_boom,
									.ball1_air,
									.ball2_boom,
									.ball2_air,
									.game_start_flag,
									.before_game_flag,
									.is_dewall,
									.ball1_hit_dewall,
									.ball2_hit_dewall,
									.right_stop1(right_stop1_dewall), 
									.left_stop1(left_stop1_dewall), 
									.up_stop1(up_stop1_dewall), 
									.down_stop1(down_stop1_dewall),
									.right_stop2(right_stop2_dewall), 
									.left_stop2(left_stop2_dewall), 
									.up_stop2(up_stop2_dewall), 
									.down_stop2(down_stop2_dewall)
				  );
				  
    bloodvolume bloodvol( .DrawX(drawxsig), 
									 .DrawY(drawysig),  
									 .base2_HP,
									 .base1_HP,
									 .game_start_flag,
									 .is_mp1,
									 .address(bloodv_addr),
									 .is_bloodvolume
									 
					);
					
	 medicinepackage medipackage( 		.Clk,                // 50 MHz clock
                           .Reset(Reset_h),              // Active-high reset signal
                           .frame_clk(VGA_VS), 
									.DrawX(drawxsig), 
									.DrawY(drawysig),
									.tank1_upleft_X, 
									.tank1_upleft_Y,
									.tank2_upleft_X, 
									.tank2_upleft_Y,
									.game_start_flag,
									.before_game_flag,
									.is_mp1,
									.add_base1_hp, 
									.add_base2_hp
									);

endmodule
