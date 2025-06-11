
module tb_i2c_generic
    import i2c_bno055_emulator_pkg::*;
#()();


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
logic[24:0] command_reg;
logic we_en;
logic master_done;
initial begin
    we_en = 0;
    //command_reg = 25'h052_0A_03; //selecionando addr do registrador do bno a ser lido
    command_reg = {9'h052, BNO055_OPR_MODE_ADDR, 8'h07}; //selecionando addr do registrador do bno a ser lido
    #199ns
    we_en = 1;
    #10ns 
    we_en = 0;
end
int done_counter;
task send_new_command(input logic [24:0] command);
    begin
        command_reg = command;
        #50us 
        we_en = 1;
        #10ns 
        we_en = 0;
    end
endtask

always_ff@(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        done_counter <= 0;
    end
    if(master_done) begin
        done_counter <= done_counter + 1;
        if(done_counter == 0)
            send_new_command({9'h053, 8'h00, 8'h01}); //lendo registrador do modo de operação
        if(done_counter == 1)
            send_new_command({9'h152, BNO055_ACCEL_DATA_X_LSB_ADDR, 8'h06}); //escolhendo o registrador para leitura de aceleração
        if(done_counter == 2)
            send_new_command({9'h053, 8'h00, 8'h06}); //lendo registradores de aceleração
        if(done_counter == 3)
            send_new_command({9'h053, 8'h00, 8'h06}); //lendo registradores de aceleração novamente
    end
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
assign sda_line = sda_tristate_en_master ? sda_o_master : sda_o_slave;
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
    .scl_o(scl),
    .done(master_done)
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
