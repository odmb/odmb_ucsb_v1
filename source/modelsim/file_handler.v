`timescale 1ns / 1ps
module file_handler(clk, start, vme_cmd_reg, vme_dat_reg_in, vme_dat_reg_out, vme_cmd_rd, vme_dat_wr);

input wire clk;
input wire vme_cmd_rd;
input wire vme_dat_wr;
output reg start; 
output reg [31:0] vme_cmd_reg;
output reg [31:0] vme_dat_reg_in;
input wire [31:0] vme_dat_reg_out;
reg [511:0] command; 
reg [255:0] parameters; 
reg read_cmd;

integer infile, outfile, r;

initial
  begin
    start = 1'b0;
    vme_cmd_reg = 32'b00000000111110000000000000000000;
    vme_dat_reg_in = 32'b00000000000000000000000000000000;
  end

initial
  begin
// Test of CFEBJTAG
//    infile=$fopen("C:\\ModelSim_Guido\\ODMB_FF_EMU\\test_dcfebjtag_v1b.txt","r");
//    outfile=$fopen("C:\\ModelSim_Guido\\ODMB_FF_EMU\\test_dcfebjtag_v1b_out.txt","w");
// Test of CFEBJTAG
//    infile=$fopen("C:\\ModelSim_Guido\\ODMB_FF_EMU\\test_lvmbmon_v1b.txt","r");
//    outfile=$fopen("C:\\ModelSim_Guido\\ODMB_FF_EMU\\test_lvmbmon_v1b_out.txt","w");
// Test of MBCJTAG
//    infile=$fopen("C:\\ModelSim_Guido\\ODMB_FF_EMU\\test_mbcjtag.txt","r");
//    outfile=$fopen("C:\\ModelSim_Guido\\ODMB_FF_EMU\\test_mbcjtag_out.txt","w");
// Test of DCFEBJTAG
//    infile=$fopen("${ODMB_FOLDER}\\commands\\test_dcfebjtag_v1b.txt","r");
//    outfile=$fopen("${ODMB_FOLDER}\\commands\\test_dcfebjtag_v1b_out.txt","w");
// Test of CONFREGS
//    infile=$fopen("commands\\test_lct_l1a_conf.txt","r");
//    outfile=$fopen("commands\\test_lct_l1a_conf_out.txt","w");
// Test of TESTCTRL
    infile=$fopen("commands\\test_lct_l1a_run.txt","r");
    outfile=$fopen("commands\\test_lct_l1a_run_out.txt","w");
    while (!$feof(infile))
      begin
        @(posedge clk) #10
          if (vme_cmd_rd) 
            begin
              r = $fscanf(infile,"%s\n",command);
              $display("%s",command);
              r = $fscanf(infile,"%b %b %b\n",start,vme_cmd_reg,vme_dat_reg_in);
              if (vme_cmd_reg[25]) 
                read_cmd = 1'b1;
              else
                read_cmd = 1'b0;
//            r = $fscanf(infile,"%b %b %b\n",start,vme_cmd_reg,vme_dat_reg_in);
//            $fwrite(outfile, "%s\n", command);
//            $fwrite(outfile, "%b\n", vme_dat_reg_out);
            end
          else
            begin
              start = 1'b0;
              vme_cmd_reg = 32'b00000000111110000000000000000000;
              vme_dat_reg_in = 32'b00000000000000000000000000000000;
            end   

          if (vme_dat_wr) 
            begin
//              $fwrite(outfile, "%s %s\n", command, parameters);
              $fwrite(outfile, "%s\n", command);
              if (read_cmd)
                $fwrite(outfile, "%b %h\n", read_cmd, vme_dat_reg_out);
              else
                $fwrite(outfile, "%b %s\n", read_cmd, "XXXXXXXX");
           end
  end    

    $fclose(outfile);
    $fclose(infile);
//    $stop;
 end
endmodule
