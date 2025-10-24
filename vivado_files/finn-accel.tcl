
################################################################
# This is a generated script based on design: finn_design
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source finn_design_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# StreamingDataWidthConverter_rtl_0, StreamingDataWidthConverter_rtl_1, StreamingFIFO_rtl_0, StreamingFIFO_rtl_1, StreamingFIFO_rtl_2, StreamingFIFO_rtl_3, StreamingFIFO_rtl_4, StreamingFIFO_rtl_5, StreamingFIFO_rtl_6, StreamingFIFO_rtl_7, StreamingFIFO_rtl_8, Thresholding_rtl_0_axi_wrapper

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name finn_design

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:hls:LabelSelect_hls_0:1.0\
xilinx.com:hls:MVAU_hls_0:1.0\
amd.com:finn:memstream:1.0\
xilinx.com:hls:MVAU_hls_1:1.0\
xilinx.com:hls:MVAU_hls_2:1.0\
xilinx.com:hls:MVAU_hls_3:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
StreamingDataWidthConverter_rtl_0\
StreamingDataWidthConverter_rtl_1\
StreamingFIFO_rtl_0\
StreamingFIFO_rtl_1\
StreamingFIFO_rtl_2\
StreamingFIFO_rtl_3\
StreamingFIFO_rtl_4\
StreamingFIFO_rtl_5\
StreamingFIFO_rtl_6\
StreamingFIFO_rtl_7\
StreamingFIFO_rtl_8\
Thresholding_rtl_0_axi_wrapper\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: MVAU_hls_3
proc create_hier_cell_MVAU_hls_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_MVAU_hls_3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 in0_V

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 out_V


  # Create pins
  create_bd_pin -dir I -type clk ap_clk
  create_bd_pin -dir I -type rst ap_rst_n

  # Create instance: MVAU_hls_3, and set properties
  set MVAU_hls_3 [ create_bd_cell -type ip -vlnv xilinx.com:hls:MVAU_hls_3:1.0 MVAU_hls_3 ]

  # Create instance: MVAU_hls_3_wstrm, and set properties
  set MVAU_hls_3_wstrm [ create_bd_cell -type ip -vlnv amd.com:finn:memstream:1.0 MVAU_hls_3_wstrm ]
  set_property -dict [list \
    CONFIG.DEPTH {640} \
    CONFIG.INIT_FILE {/tmp/finn_dev_squowedri/code_gen_ipgen_MVAU_hls_3_7frhiuob/memblock.dat} \
    CONFIG.RAM_STYLE {auto} \
    CONFIG.WIDTH {8} \
  ] $MVAU_hls_3_wstrm


  # Create interface connections
  connect_bd_intf_net -intf_net MVAU_hls_3_out_V [get_bd_intf_pins out_V] [get_bd_intf_pins MVAU_hls_3/out_V]
  connect_bd_intf_net -intf_net MVAU_hls_3_wstrm_m_axis_0 [get_bd_intf_pins MVAU_hls_3/weights_V] [get_bd_intf_pins MVAU_hls_3_wstrm/m_axis_0]
  connect_bd_intf_net -intf_net in0_V_1 [get_bd_intf_pins in0_V] [get_bd_intf_pins MVAU_hls_3/in0_V]

  # Create port connections
  connect_bd_net -net ap_clk_1 [get_bd_pins ap_clk] [get_bd_pins MVAU_hls_3/ap_clk] [get_bd_pins MVAU_hls_3_wstrm/ap_clk]
  connect_bd_net -net ap_rst_n_1 [get_bd_pins ap_rst_n] [get_bd_pins MVAU_hls_3/ap_rst_n] [get_bd_pins MVAU_hls_3_wstrm/ap_rst_n]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: MVAU_hls_2
proc create_hier_cell_MVAU_hls_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_MVAU_hls_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 in0_V

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 out_V


  # Create pins
  create_bd_pin -dir I -type clk ap_clk
  create_bd_pin -dir I -type rst ap_rst_n

  # Create instance: MVAU_hls_2, and set properties
  set MVAU_hls_2 [ create_bd_cell -type ip -vlnv xilinx.com:hls:MVAU_hls_2:1.0 MVAU_hls_2 ]

  # Create instance: MVAU_hls_2_wstrm, and set properties
  set MVAU_hls_2_wstrm [ create_bd_cell -type ip -vlnv amd.com:finn:memstream:1.0 MVAU_hls_2_wstrm ]
  set_property -dict [list \
    CONFIG.DEPTH {64} \
    CONFIG.INIT_FILE {/tmp/finn_dev_squowedri/code_gen_ipgen_MVAU_hls_2_hhl8jz1y/memblock.dat} \
    CONFIG.RAM_STYLE {auto} \
    CONFIG.WIDTH {64} \
  ] $MVAU_hls_2_wstrm


  # Create interface connections
  connect_bd_intf_net -intf_net MVAU_hls_2_out_V [get_bd_intf_pins out_V] [get_bd_intf_pins MVAU_hls_2/out_V]
  connect_bd_intf_net -intf_net MVAU_hls_2_wstrm_m_axis_0 [get_bd_intf_pins MVAU_hls_2/weights_V] [get_bd_intf_pins MVAU_hls_2_wstrm/m_axis_0]
  connect_bd_intf_net -intf_net in0_V_1 [get_bd_intf_pins in0_V] [get_bd_intf_pins MVAU_hls_2/in0_V]

  # Create port connections
  connect_bd_net -net ap_clk_1 [get_bd_pins ap_clk] [get_bd_pins MVAU_hls_2/ap_clk] [get_bd_pins MVAU_hls_2_wstrm/ap_clk]
  connect_bd_net -net ap_rst_n_1 [get_bd_pins ap_rst_n] [get_bd_pins MVAU_hls_2/ap_rst_n] [get_bd_pins MVAU_hls_2_wstrm/ap_rst_n]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: MVAU_hls_1
proc create_hier_cell_MVAU_hls_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_MVAU_hls_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 in0_V

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 out_V


  # Create pins
  create_bd_pin -dir I -type clk ap_clk
  create_bd_pin -dir I -type rst ap_rst_n

  # Create instance: MVAU_hls_1, and set properties
  set MVAU_hls_1 [ create_bd_cell -type ip -vlnv xilinx.com:hls:MVAU_hls_1:1.0 MVAU_hls_1 ]

  # Create instance: MVAU_hls_1_wstrm, and set properties
  set MVAU_hls_1_wstrm [ create_bd_cell -type ip -vlnv amd.com:finn:memstream:1.0 MVAU_hls_1_wstrm ]
  set_property -dict [list \
    CONFIG.DEPTH {64} \
    CONFIG.INIT_FILE {/tmp/finn_dev_squowedri/code_gen_ipgen_MVAU_hls_1_hy6k6gnk/memblock.dat} \
    CONFIG.RAM_STYLE {auto} \
    CONFIG.WIDTH {64} \
  ] $MVAU_hls_1_wstrm


  # Create interface connections
  connect_bd_intf_net -intf_net MVAU_hls_1_out_V [get_bd_intf_pins out_V] [get_bd_intf_pins MVAU_hls_1/out_V]
  connect_bd_intf_net -intf_net MVAU_hls_1_wstrm_m_axis_0 [get_bd_intf_pins MVAU_hls_1/weights_V] [get_bd_intf_pins MVAU_hls_1_wstrm/m_axis_0]
  connect_bd_intf_net -intf_net in0_V_1 [get_bd_intf_pins in0_V] [get_bd_intf_pins MVAU_hls_1/in0_V]

  # Create port connections
  connect_bd_net -net ap_clk_1 [get_bd_pins ap_clk] [get_bd_pins MVAU_hls_1/ap_clk] [get_bd_pins MVAU_hls_1_wstrm/ap_clk]
  connect_bd_net -net ap_rst_n_1 [get_bd_pins ap_rst_n] [get_bd_pins MVAU_hls_1/ap_rst_n] [get_bd_pins MVAU_hls_1_wstrm/ap_rst_n]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: MVAU_hls_0
proc create_hier_cell_MVAU_hls_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_MVAU_hls_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 in0_V

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 out_V


  # Create pins
  create_bd_pin -dir I -type clk ap_clk
  create_bd_pin -dir I -type rst ap_rst_n

  # Create instance: MVAU_hls_0, and set properties
  set MVAU_hls_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:MVAU_hls_0:1.0 MVAU_hls_0 ]

  # Create instance: MVAU_hls_0_wstrm, and set properties
  set MVAU_hls_0_wstrm [ create_bd_cell -type ip -vlnv amd.com:finn:memstream:1.0 MVAU_hls_0_wstrm ]
  set_property -dict [list \
    CONFIG.DEPTH {64} \
    CONFIG.INIT_FILE {/tmp/finn_dev_squowedri/code_gen_ipgen_MVAU_hls_0_l6f2w7hx/memblock.dat} \
    CONFIG.RAM_STYLE {block} \
    CONFIG.WIDTH {784} \
  ] $MVAU_hls_0_wstrm


  # Create interface connections
  connect_bd_intf_net -intf_net MVAU_hls_0_out_V [get_bd_intf_pins out_V] [get_bd_intf_pins MVAU_hls_0/out_V]
  connect_bd_intf_net -intf_net MVAU_hls_0_wstrm_m_axis_0 [get_bd_intf_pins MVAU_hls_0/weights_V] [get_bd_intf_pins MVAU_hls_0_wstrm/m_axis_0]
  connect_bd_intf_net -intf_net in0_V_1 [get_bd_intf_pins in0_V] [get_bd_intf_pins MVAU_hls_0/in0_V]

  # Create port connections
  connect_bd_net -net ap_clk_1 [get_bd_pins ap_clk] [get_bd_pins MVAU_hls_0/ap_clk] [get_bd_pins MVAU_hls_0_wstrm/ap_clk]
  connect_bd_net -net ap_rst_n_1 [get_bd_pins ap_rst_n] [get_bd_pins MVAU_hls_0/ap_rst_n] [get_bd_pins MVAU_hls_0_wstrm/ap_rst_n]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set m_axis_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_0 ]

  set s_axis_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_0 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {49} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $s_axis_0


  # Create ports
  set ap_clk [ create_bd_port -dir I -type clk -freq_hz 100000000 ap_clk ]
  set ap_rst_n [ create_bd_port -dir I -type rst ap_rst_n ]

  # Create instance: LabelSelect_hls_0, and set properties
  set LabelSelect_hls_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:LabelSelect_hls_0:1.0 LabelSelect_hls_0 ]

  # Create instance: MVAU_hls_0
  create_hier_cell_MVAU_hls_0 [current_bd_instance .] MVAU_hls_0

  # Create instance: MVAU_hls_1
  create_hier_cell_MVAU_hls_1 [current_bd_instance .] MVAU_hls_1

  # Create instance: MVAU_hls_2
  create_hier_cell_MVAU_hls_2 [current_bd_instance .] MVAU_hls_2

  # Create instance: MVAU_hls_3
  create_hier_cell_MVAU_hls_3 [current_bd_instance .] MVAU_hls_3

  # Create instance: StreamingDataWidthConverter_rtl_0, and set properties
  set block_name StreamingDataWidthConverter_rtl_0
  set block_cell_name StreamingDataWidthConverter_rtl_0
  if { [catch {set StreamingDataWidthConverter_rtl_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $StreamingDataWidthConverter_rtl_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: StreamingDataWidthConverter_rtl_1, and set properties
  set block_name StreamingDataWidthConverter_rtl_1
  set block_cell_name StreamingDataWidthConverter_rtl_1
  if { [catch {set StreamingDataWidthConverter_rtl_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $StreamingDataWidthConverter_rtl_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: StreamingFIFO_rtl_0, and set properties
  set block_name StreamingFIFO_rtl_0
  set block_cell_name StreamingFIFO_rtl_0
  if { [catch {set StreamingFIFO_rtl_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $StreamingFIFO_rtl_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: StreamingFIFO_rtl_1, and set properties
  set block_name StreamingFIFO_rtl_1
  set block_cell_name StreamingFIFO_rtl_1
  if { [catch {set StreamingFIFO_rtl_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $StreamingFIFO_rtl_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: StreamingFIFO_rtl_2, and set properties
  set block_name StreamingFIFO_rtl_2
  set block_cell_name StreamingFIFO_rtl_2
  if { [catch {set StreamingFIFO_rtl_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $StreamingFIFO_rtl_2 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: StreamingFIFO_rtl_3, and set properties
  set block_name StreamingFIFO_rtl_3
  set block_cell_name StreamingFIFO_rtl_3
  if { [catch {set StreamingFIFO_rtl_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $StreamingFIFO_rtl_3 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: StreamingFIFO_rtl_4, and set properties
  set block_name StreamingFIFO_rtl_4
  set block_cell_name StreamingFIFO_rtl_4
  if { [catch {set StreamingFIFO_rtl_4 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $StreamingFIFO_rtl_4 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: StreamingFIFO_rtl_5, and set properties
  set block_name StreamingFIFO_rtl_5
  set block_cell_name StreamingFIFO_rtl_5
  if { [catch {set StreamingFIFO_rtl_5 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $StreamingFIFO_rtl_5 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: StreamingFIFO_rtl_6, and set properties
  set block_name StreamingFIFO_rtl_6
  set block_cell_name StreamingFIFO_rtl_6
  if { [catch {set StreamingFIFO_rtl_6 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $StreamingFIFO_rtl_6 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: StreamingFIFO_rtl_7, and set properties
  set block_name StreamingFIFO_rtl_7
  set block_cell_name StreamingFIFO_rtl_7
  if { [catch {set StreamingFIFO_rtl_7 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $StreamingFIFO_rtl_7 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: StreamingFIFO_rtl_8, and set properties
  set block_name StreamingFIFO_rtl_8
  set block_cell_name StreamingFIFO_rtl_8
  if { [catch {set StreamingFIFO_rtl_8 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $StreamingFIFO_rtl_8 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: Thresholding_rtl_0, and set properties
  set block_name Thresholding_rtl_0_axi_wrapper
  set block_cell_name Thresholding_rtl_0
  if { [catch {set Thresholding_rtl_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Thresholding_rtl_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create interface connections
  connect_bd_intf_net -intf_net LabelSelect_hls_0_out_V [get_bd_intf_pins LabelSelect_hls_0/out_V] [get_bd_intf_pins StreamingFIFO_rtl_8/in0_V]
  connect_bd_intf_net -intf_net MVAU_hls_0_out_V [get_bd_intf_pins MVAU_hls_0/out_V] [get_bd_intf_pins StreamingFIFO_rtl_2/in0_V]
  connect_bd_intf_net -intf_net MVAU_hls_1_out_V [get_bd_intf_pins MVAU_hls_1/out_V] [get_bd_intf_pins StreamingFIFO_rtl_4/in0_V]
  connect_bd_intf_net -intf_net MVAU_hls_2_out_V [get_bd_intf_pins MVAU_hls_2/out_V] [get_bd_intf_pins StreamingFIFO_rtl_5/in0_V]
  connect_bd_intf_net -intf_net MVAU_hls_3_out_V [get_bd_intf_pins MVAU_hls_3/out_V] [get_bd_intf_pins StreamingFIFO_rtl_7/in0_V]
  connect_bd_intf_net -intf_net StreamingDataWidthConverter_rtl_0_out_V [get_bd_intf_pins StreamingDataWidthConverter_rtl_0/out_V] [get_bd_intf_pins StreamingFIFO_rtl_3/in0_V]
  connect_bd_intf_net -intf_net StreamingDataWidthConverter_rtl_1_out_V [get_bd_intf_pins StreamingDataWidthConverter_rtl_1/out_V] [get_bd_intf_pins StreamingFIFO_rtl_6/in0_V]
  connect_bd_intf_net -intf_net StreamingFIFO_rtl_0_out_V [get_bd_intf_pins StreamingFIFO_rtl_0/out_V] [get_bd_intf_pins Thresholding_rtl_0/in0_V]
  connect_bd_intf_net -intf_net StreamingFIFO_rtl_1_out_V [get_bd_intf_pins MVAU_hls_0/in0_V] [get_bd_intf_pins StreamingFIFO_rtl_1/out_V]
  connect_bd_intf_net -intf_net StreamingFIFO_rtl_2_out_V [get_bd_intf_pins StreamingDataWidthConverter_rtl_0/in0_V] [get_bd_intf_pins StreamingFIFO_rtl_2/out_V]
  connect_bd_intf_net -intf_net StreamingFIFO_rtl_3_out_V [get_bd_intf_pins MVAU_hls_1/in0_V] [get_bd_intf_pins StreamingFIFO_rtl_3/out_V]
  connect_bd_intf_net -intf_net StreamingFIFO_rtl_4_out_V [get_bd_intf_pins MVAU_hls_2/in0_V] [get_bd_intf_pins StreamingFIFO_rtl_4/out_V]
  connect_bd_intf_net -intf_net StreamingFIFO_rtl_5_out_V [get_bd_intf_pins StreamingDataWidthConverter_rtl_1/in0_V] [get_bd_intf_pins StreamingFIFO_rtl_5/out_V]
  connect_bd_intf_net -intf_net StreamingFIFO_rtl_6_out_V [get_bd_intf_pins MVAU_hls_3/in0_V] [get_bd_intf_pins StreamingFIFO_rtl_6/out_V]
  connect_bd_intf_net -intf_net StreamingFIFO_rtl_7_out_V [get_bd_intf_pins LabelSelect_hls_0/in0_V] [get_bd_intf_pins StreamingFIFO_rtl_7/out_V]
  connect_bd_intf_net -intf_net StreamingFIFO_rtl_8_out_V [get_bd_intf_ports m_axis_0] [get_bd_intf_pins StreamingFIFO_rtl_8/out_V]
  connect_bd_intf_net -intf_net Thresholding_rtl_0_out_V [get_bd_intf_pins StreamingFIFO_rtl_1/in0_V] [get_bd_intf_pins Thresholding_rtl_0/out_V]
  connect_bd_intf_net -intf_net in0_V_0_1 [get_bd_intf_ports s_axis_0] [get_bd_intf_pins StreamingFIFO_rtl_0/in0_V]

  # Create port connections
  connect_bd_net -net ap_clk_0_1 [get_bd_ports ap_clk] [get_bd_pins LabelSelect_hls_0/ap_clk] [get_bd_pins MVAU_hls_0/ap_clk] [get_bd_pins MVAU_hls_1/ap_clk] [get_bd_pins MVAU_hls_2/ap_clk] [get_bd_pins MVAU_hls_3/ap_clk] [get_bd_pins StreamingDataWidthConverter_rtl_0/ap_clk] [get_bd_pins StreamingDataWidthConverter_rtl_1/ap_clk] [get_bd_pins StreamingFIFO_rtl_0/ap_clk] [get_bd_pins StreamingFIFO_rtl_1/ap_clk] [get_bd_pins StreamingFIFO_rtl_2/ap_clk] [get_bd_pins StreamingFIFO_rtl_3/ap_clk] [get_bd_pins StreamingFIFO_rtl_4/ap_clk] [get_bd_pins StreamingFIFO_rtl_5/ap_clk] [get_bd_pins StreamingFIFO_rtl_6/ap_clk] [get_bd_pins StreamingFIFO_rtl_7/ap_clk] [get_bd_pins StreamingFIFO_rtl_8/ap_clk] [get_bd_pins Thresholding_rtl_0/ap_clk]
  connect_bd_net -net ap_rst_n_0_1 [get_bd_ports ap_rst_n] [get_bd_pins LabelSelect_hls_0/ap_rst_n] [get_bd_pins MVAU_hls_0/ap_rst_n] [get_bd_pins MVAU_hls_1/ap_rst_n] [get_bd_pins MVAU_hls_2/ap_rst_n] [get_bd_pins MVAU_hls_3/ap_rst_n] [get_bd_pins StreamingDataWidthConverter_rtl_0/ap_rst_n] [get_bd_pins StreamingDataWidthConverter_rtl_1/ap_rst_n] [get_bd_pins StreamingFIFO_rtl_0/ap_rst_n] [get_bd_pins StreamingFIFO_rtl_1/ap_rst_n] [get_bd_pins StreamingFIFO_rtl_2/ap_rst_n] [get_bd_pins StreamingFIFO_rtl_3/ap_rst_n] [get_bd_pins StreamingFIFO_rtl_4/ap_rst_n] [get_bd_pins StreamingFIFO_rtl_5/ap_rst_n] [get_bd_pins StreamingFIFO_rtl_6/ap_rst_n] [get_bd_pins StreamingFIFO_rtl_7/ap_rst_n] [get_bd_pins StreamingFIFO_rtl_8/ap_rst_n] [get_bd_pins Thresholding_rtl_0/ap_rst_n]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


