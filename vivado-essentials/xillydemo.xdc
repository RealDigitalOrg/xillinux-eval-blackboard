# clk_100 is correct for Blackboard and is 100 MHz

create_clock -name gclk -period 10 [get_ports "clk_100"]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets "clk_100"]

# Vivado constraints unrelated clocks. So set false paths.
set_false_path -from [get_clocks clk_fpga_1] -to [get_clocks vga_clk_ins/*]
set_false_path -from [get_clocks vga_clk_ins/*] -to [get_clocks clk_fpga_1]

# The VGA outputs are turned into an analog voltage by virtue of a resistor
# network, so the flip flops driving these must sit in the IOBs to minimize
# timing skew. The RTL code should handle this, but the constraint below
# is there to fail if something goes wrong about this.
set_output_delay 5.5 [get_ports {vga*}]

# The VGA core's MMCM must be close to the HDMI I/O's pins, because it drives
# the OSERDES' clock directly

#set_property LOC MMCME2_ADV_X1Y2 [get_cells -match_style ucf */vga_clk_ins/vga_mmcm]  FIXME!
set_property LOC MMCME2_ADV_X0Y0 [get_cells -match_style ucf */vga_clk_ins/vga_mmcm]
#set_property LOC PLLE2_ADV_X1Y1 [get_cells -match_style ucf *audio*/plle2_adv_inst]

set_property -dict "PACKAGE_PIN H16 IOSTANDARD LVCMOS33" [get_ports "clk_100"]
set_property -dict "PACKAGE_PIN N20 IOSTANDARD LVCMOS33" [get_ports "GPIO_LED[0]"]
set_property -dict "PACKAGE_PIN P20 IOSTANDARD LVCMOS33" [get_ports "GPIO_LED[1]"]
set_property -dict "PACKAGE_PIN R19 IOSTANDARD LVCMOS33" [get_ports "GPIO_LED[2]"]
set_property -dict "PACKAGE_PIN T20 IOSTANDARD LVCMOS33" [get_ports "GPIO_LED[3]"]

set_property -dict "PACKAGE_PIN V15 IOSTANDARD LVCMOS33" [get_ports "vga4_red[0]"];    # R4
set_property -dict "PACKAGE_PIN W15 IOSTANDARD LVCMOS33" [get_ports "vga4_red[1]"];    # R5
set_property -dict "PACKAGE_PIN V16 IOSTANDARD LVCMOS33" [get_ports "vga4_red[2]"];    # R6
set_property -dict "PACKAGE_PIN T16 IOSTANDARD LVCMOS33" [get_ports "vga4_red[3]"];    # R7
set_property -dict "PACKAGE_PIN T15 IOSTANDARD LVCMOS33" [get_ports "vga4_green[0]"];  # G4
set_property -dict "PACKAGE_PIN V13 IOSTANDARD LVCMOS33" [get_ports "vga4_green[1]"];  # G5
set_property -dict "PACKAGE_PIN U14 IOSTANDARD LVCMOS33" [get_ports "vga4_green[2]"];  # G6
set_property -dict "PACKAGE_PIN U15 IOSTANDARD LVCMOS33" [get_ports "vga4_green[3]"];  # G7
set_property -dict "PACKAGE_PIN T11 IOSTANDARD LVCMOS33" [get_ports "vga4_blue[0]"];   # B4
set_property -dict "PACKAGE_PIN T14 IOSTANDARD LVCMOS33" [get_ports "vga4_blue[1]"];   # B5
set_property -dict "PACKAGE_PIN U12 IOSTANDARD LVCMOS33" [get_ports "vga4_blue[2]"];   # B6
set_property -dict "PACKAGE_PIN V12 IOSTANDARD LVCMOS33" [get_ports "vga4_blue[3]"];   # B7
set_property -dict "PACKAGE_PIN T12 IOSTANDARD LVCMOS33" [get_ports "vga_hsync"]
set_property -dict "PACKAGE_PIN T10 IOSTANDARD LVCMOS33" [get_ports "vga_vsync"]

# PS_GPIO pins:
# GPIO pins 3-0 four pushbuttons
# GPIO pins 11-4 eight slide switches
# GPIO pins 27-12 two PMOD connectors
# GPIO pins 39-28 four RGB LEDs
# GPIO pins 41-40 HDMO SDA and SCL signals

# On-board Slide Switches

set_property -dict "PACKAGE_PIN R17 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[4]"];  # SW0
set_property -dict "PACKAGE_PIN U20 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[5]"];  # SW1
set_property -dict "PACKAGE_PIN R16 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[6]"];  # SW2
set_property -dict "PACKAGE_PIN N16 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[7]"];  # SW3
set_property -dict "PACKAGE_PIN R14 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[8]"];  # SW4
set_property -dict "PACKAGE_PIN P14 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[9]"];  # SW5
set_property -dict "PACKAGE_PIN L15 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[10]"]; # SW6
set_property -dict "PACKAGE_PIN M15 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[11]"]; # SW7

# On-board Pushbuttons
set_property -dict "PACKAGE_PIN W14 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[0]"];  # BTN0
set_property -dict "PACKAGE_PIN W13 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[1]"];  # BTN1
set_property -dict "PACKAGE_PIN P15 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[2]"];  # BTN2
set_property -dict "PACKAGE_PIN M14 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[3]"];  # BTN3

# The PMODs have been assigned so that software that ran on the Zedboard sees
# the same A-B-C mapping w.r.t. the GPIO number assignments

## Pmod Header JA (XADC)
set_property -dict "PACKAGE_PIN F16 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[12]"]; # JA1_P
set_property -dict "PACKAGE_PIN F17 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[13]"]; # JA1_N
set_property -dict "PACKAGE_PIN G19 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[14]"]; # JA2_P
set_property -dict "PACKAGE_PIN G20 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[15]"]; # JA2_N
set_property -dict "PACKAGE_PIN E18 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[16]"]; # JA3_P
set_property -dict "PACKAGE_PIN E19 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[17]"]; # JA3_N
set_property -dict "PACKAGE_PIN E17 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[18]"]; # JA4_P
set_property -dict "PACKAGE_PIN D18 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[19]"]; # JA4_N

## Pmod Header JB
set_property -dict "PACKAGE_PIN D19 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[20]"]; # JB1_P
set_property -dict "PACKAGE_PIN D20 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[21]"]; # JB1_N
set_property -dict "PACKAGE_PIN F19 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[22]"]; # JB2_P
set_property -dict "PACKAGE_PIN F20 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[23]"]; # JB2_N
set_property -dict "PACKAGE_PIN C20 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[24]"]; # JB3_P
set_property -dict "PACKAGE_PIN B20 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[25]"]; # JB3_N
set_property -dict "PACKAGE_PIN B19 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[26]"]; # JB4_P
set_property -dict "PACKAGE_PIN A20 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[27]"]; # JB4_N

## RGB LED 4
set_property -dict "PACKAGE_PIN W20 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[28]"]; # B
set_property -dict "PACKAGE_PIN T19 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[29]"]; # G
set_property -dict "PACKAGE_PIN U13 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[30]"]; # R

## RGB LED 5
set_property -dict "PACKAGE_PIN W19 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[31]"]; # B
set_property -dict "PACKAGE_PIN V20 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[32]"]; # G
set_property -dict "PACKAGE_PIN Y19 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[33]"]; # R
 
## RGB LED 6
set_property -dict "PACKAGE_PIN Y18 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[34]"]; # B
set_property -dict "PACKAGE_PIN W16 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[35]"]; # G
set_property -dict "PACKAGE_PIN W18 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[36]"]; # R

## RGB LED 7
set_property -dict "PACKAGE_PIN Y17 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[37]"]; # B
set_property -dict "PACKAGE_PIN Y16 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[38]"]; # G
set_property -dict "PACKAGE_PIN Y14 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[39]"]; # R

# Pin for detecting USB OTG over-current condition
#set_property -dict "PACKAGE_PIN U13 IOSTANDARD LVCMOS33" [get_ports "otg_oc"]

# Ethernet PHY's reset and interrupt pin to GPIOs
#set_property -dict "PACKAGE_PIN F16 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[15]"]
#set_property -dict "PACKAGE_PIN E17 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[16]"]

# HDMI I2C pins are mapped to GPIO
set_property -dict "PACKAGE_PIN T17 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[40]"]
set_property -dict "PACKAGE_PIN R18 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[41]"]

# These GPIOs don't have any current use, but they must be connected to
# something, or build will fail. So they go to unused pins
#set_property -dict "PACKAGE_PIN J18 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[8]"]
#set_property -dict "PACKAGE_PIN H18 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[9]"]
#set_property -dict "PACKAGE_PIN F19 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[10]"]
#set_property -dict "PACKAGE_PIN F20 IOSTANDARD LVCMOS33" [get_ports "PS_GPIO[23]"]

# Pins to audio chip
#set_property -dict "PACKAGE_PIN R19 IOSTANDARD LVCMOS33" [get_ports "audio_bclk"]
#set_property -dict "PACKAGE_PIN R17 IOSTANDARD LVCMOS33" [get_ports "audio_mclk"]
#set_property -dict "PACKAGE_PIN P18 IOSTANDARD LVCMOS33" [get_ports "audio_mute"]
#set_property -dict "PACKAGE_PIN R18 IOSTANDARD LVCMOS33" [get_ports "audio_dac"]
#set_property -dict "PACKAGE_PIN T19 IOSTANDARD LVCMOS33" [get_ports "audio_dac_lrclk"]
#set_property -dict "PACKAGE_PIN R16 IOSTANDARD LVCMOS33" [get_ports "audio_adc"]
#set_property -dict "PACKAGE_PIN Y18 IOSTANDARD LVCMOS33" [get_ports "audio_adc_lrclk"]
#set_property -dict "PACKAGE_PIN N18 IOSTANDARD LVCMOS33" [get_ports "smb_sclk"]
#set_property -dict "PACKAGE_PIN N17 IOSTANDARD LVCMOS33" [get_ports "smb_sdata"]

# HDMI (DVI) outputs
set_property -dict "PACKAGE_PIN U19 IOSTANDARD TMDS_33" [get_ports "hdmi_clk_n"]
set_property -dict "PACKAGE_PIN U18 IOSTANDARD TMDS_33" [get_ports "hdmi_clk_p"]
set_property -dict "PACKAGE_PIN V18 IOSTANDARD TMDS_33" [get_ports "hdmi_d_n[0]"]
set_property -dict "PACKAGE_PIN V17 IOSTANDARD TMDS_33" [get_ports "hdmi_d_p[0]"]
set_property -dict "PACKAGE_PIN P18 IOSTANDARD TMDS_33" [get_ports "hdmi_d_n[1]"]
set_property -dict "PACKAGE_PIN N17 IOSTANDARD TMDS_33" [get_ports "hdmi_d_p[1]"]
set_property -dict "PACKAGE_PIN P19 IOSTANDARD TMDS_33" [get_ports "hdmi_d_n[2]"]
set_property -dict "PACKAGE_PIN N18 IOSTANDARD TMDS_33" [get_ports "hdmi_d_p[2]"]
set_property -dict "PACKAGE_PIN P16 IOSTANDARD LVCMOS33" [get_ports "hdmi_out_en"]
