module tb_i2c_generic;

localparam CLK_FREQUENCE = 100_000_000;
localparam I2C_FREQ = 400_000;

localparam HALF_PERIOD = (((1ns/CLK_FREQUENCE)*1_000_000_000ns)/2ns);  


logic clk;

///////////////////////////////////////// Clock generator //////////////////////////////
always begin
    #(HALF_PERIOD) clk <= 0;
    #(HALF_PERIOD) clk <= 1;
end

logic reset_n;
initial begin
    reset_n = 0;
    #100ns reset_n = 1;
end
logic[23:0] command_reg;
logic we_en;

initial begin
    we_en = 0;
    command_reg = 24'h53_00_03;
    #199ns
    we_en = 1;
    #10ns 
    we_en = 0;
end



logic sda_o_master;
logic sda_i;
logic scl;
logic sda_tristate_en_slave;
logic data_v;
logic [7:0] data_o_master;

logic sda_line;
logic sda_tristate_en_master;
logic sda_o_slave;
logic sda_i_slave;

assign sda_i_slave = sda_line;
assign sda_line = sda_tristate_en_master ? sda_o_master : 1'b0;
assign sda_i_master = sda_line;

i2c_generic #(
    .CLK_FREQUENCE(CLK_FREQUENCE),
    .I2C_FREQ(I2C_FREQ)
) dut (
    .clk(clk),
    .reset_n(reset_n),
    .command_i(command_reg),
    .we_en_i(we_en),
    .sda_i(sda_i_master),
    .data_o(data_o_master),
    .data_valid_o(data_v),
    .sda_o(sda_o_master),
    .sda_tristate_en_o(sda_tristate_en_master),
    .scl_o(scl)
);

i2c_bno055_emulator dut_bno (
    .clk(clk),
    .reset_n(reset_n),
    .we_core_i('0),
    .core_data_o(),
    .core_data_i(),
    .core_addr_i(),
    .scl_i(scl),
    .sda_i(sda_i_slave),
    .sda_o(sda_o_slave),
    .sda_tristate_en_o(sda_tristate_en_slave)
);


endmodule
