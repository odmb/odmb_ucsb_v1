module file_handler_event(clk, en, l1a, lct);

input wire clk;
input wire en;
output reg l1a;
output reg [7:0] lct;

reg [31:0] ts_cnt;
reg [31:0] ts_in;
reg l1a_in;
reg [7:0] lct_in;

reg event_rd;

integer infile, r;

initial
  begin
    ts_cnt = 32'h00000000;
    l1a = 1'b0;
    lct = 8'b00000000;
  end

always @(posedge clk) #1
    if (en)
        ts_cnt = ts_cnt + 1'b1;

always #1
  if (ts_cnt == ts_in) 
    event_rd = 1'b1;
  else
    event_rd = 1'b0;

always @(posedge clk) #1
  if (event_rd)
    begin
      l1a = l1a_in;
      lct = lct_in;
    end
  else
    begin
      l1a = 1'b0;
      lct = 8'b00000000;
    end
  

initial #1
  begin
    infile=$fopen("${ODMB_FOLDER}\\commands\\test_l1a_lct.txt","r");
    r = $fscanf(infile,"%h %b %b\n",ts_in,l1a_in,lct_in);
    while (!$feof(infile))
      begin
        @(posedge clk) #1
          if (event_rd)
            r = $fscanf(infile,"%h %b %b\n",ts_in,l1a_in,lct_in);
          end
    $fclose(infile);
    $stop;
 end
endmodule
