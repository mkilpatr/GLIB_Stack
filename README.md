# GLIB-Firmware

--This is a GLIB firmware project used to emulate the Pixel upgrade for the CMS detector. =================================================================================================--
--=================================================================================================--
-- Matt Added summary of changes to Strasbourg Pixel Emulation 
-- Evaldas Jruska made all of the TTC_decoder connections that were necessary for this project.
--====================================================================================================
--If you change the XPOINT1 configuration during runtime by writing to the control register, then the board will crash, 
--so what I did is just to modify the system_core.vhd and hardcode the xpoint1_s30 <= '1' and xpoint1_s31 <= '1'. 
--This is done so the simulated TTC signal from the AMC13 is routed to the correct ports on the GLIB.
--You can then pick up the clock signal from xpoint1_clk3_p and xpoint1_clk3_n in your user_logic_basic.vhd:
--    add or uncomment these lines in your port() section
--      xpoint1_clk3_p : in std_logic;
--      xpoint1_clk3_n : in std_logic;
--   uncomment and a bit modify a few lines in your user_fabric_clk.ucf file so they look like this:
--     NET "xpoint1_clk3_p"                                            LOC = A10;  IO_L1P_GC_34               
--     NET "xpoint1_clk3_n"                                            LOC = B10;  IO_L1N_GC_34                       
--     NET "xpoint1_clk3_p"                                            TNM_NET = "xpoint1_clk3_p";
--     NET "xpoint1_clk3_n"                                            TNM_NET = "xpoint1_clk3_n";
--     TIMESPEC TS_xpoint1_clk3_p =                    PERIOD "xpoint1_clk3_p" 24.95 ns HIGH 50 % INPUT_JITTER 100 ps;
--     TIMESPEC TS_xpoint1_clk3_n =                    PERIOD "xpoint1_clk3_n" TS_xpoint1_clk3_p PHASE 12.475 ns HIGH 50 %;
--
--For the data make sure you have these lines uncommented in the system.ucf (though I think they are available by default):
--  NET "amc_port_rx_p[*]" LOC = ####;
--  NET "amc_port_rx_n[*]" LOC = ####;
--also make sure you have them in your port() section of the user_logic_basic.vhd:
--   amc_port_rx_p               : in std_logic_vector(1 to 15);
--   amc_port_rx_n               : in std_logic_vector(1 to 15);
--
--At this point you can instantiate the TTC decoder module that we got I believe from HCAL (Jared knows the details) like --this: (attached TTC_decoder.vhd). Correct variable have been added to the user architecture and fed through the ipbut --link_tracking to be counted. If you look at link_tracking.vhd you will see three counters have been added to count L1As, --Orbits, and bunches and they can be read by reading registers 0x4004000 & (0,1,2). The signals from the TTC_decoder and --some bits from the counter have been sent to the fmc1_j2 HA00-HA07 and LA18 ports. I had to add the --user_fmc1_io_conf_package.vhd so that the pins could be changed to out. Also changed fmc1_j2_map: entity --work.fmc_io_buffers to fmc_la_io_settings => fmc1_la_io_settings_constants. These signals are easily viewed with an --oscilloscope.
