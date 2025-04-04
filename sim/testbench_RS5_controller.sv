`include "../rtl/cpu/RS5_pkg.sv"

module testbench_RS5_controller
    import RS5_pkg::*;
(
);
    localparam mul_e         MULEXT          = MUL_M;
    localparam atomic_e      AMOEXT          = AMO_A;
    localparam bit           COMPRESSED      = 1'b1;
    localparam bit           USE_XOSVM       = 1'b0;
    localparam bit           USE_ZIHPM       = 1'b0;
    localparam bit           USE_ZKNE        = 1'b0;
    localparam bit           VEnable         = 1'b0;
    localparam int           VLEN            = 256;
    localparam bit           BRANCHPRED      = 1'b1;
    localparam int           CLK_FREQUENCE   = 100_000_000;
    localparam int           BAUD_RATE       = 115_200;

    localparam int           MEM_WIDTH       = 65_536;
    localparam string        BIN_FILE        = "../app/hello/hello.bin";
    
    logic        clk=1;

///////////////////////////////////////// Clock generator //////////////////////////////

    always begin
        #5.0 clk <= 0;
        #5.0 clk <= 1;
    end


////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////// RESET CPU ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

    logic reset_n;

    initial begin
        reset_n = 0;                                          // RESET for CPU initialization

        #100 reset_n = 1;                                     // Hold state for 100 ns
    end
////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////// CONTROLLER ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

    logic uart_rx, uart_tx;
    RS5_controller #(
        .Environment    (ASIC      ),
        .MULEXT         (MULEXT    ),
        .AMOEXT         (AMOEXT    ),
        .COMPRESSED     (COMPRESSED),
        .VEnable        (VEnable   ),
        .VLEN           (VLEN      ),
        .XOSVMEnable    (USE_XOSVM ),
        .ZIHPMEnable    (USE_ZIHPM ),
        .ZKNEEnable     (USE_ZKNE  ),
        .BRANCHPRED     (BRANCHPRED),
        .MEM_WIDTH      (MEM_WIDTH ),
        .BIN_FILE       (BIN_FILE  ),
        .CLK_FREQUENCE  (CLK_FREQUENCE),
        .BAUD_RATE      (BAUD_RATE)
    ) dut (
        .clk            (clk),
        .reset_n        (reset_n),
        .UART_RX_i      (uart_rx),
        .UART_TX_o      (uart_tx)
    );
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////// TB MODULES //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

    logic       UART_TX_send;
    logic       UART_TX_ready;
    logic       UART_RX_ready;
    logic [7:0] UART_TX_data;
    logic [7:0] UART_RX_data;

    UART_TX_CTRL #(
        .CLK_FREQUENCE(CLK_FREQUENCE),
        .BAUD_RATE(BAUD_RATE) 
    ) uart_tx_tb (
        .i_Clock     (clk),
        .reset_n     (reset_n),
        .i_Tx_DV     (UART_TX_send),            // enable send
        .i_Tx_Byte   (UART_TX_data),            // 8 bit 
        .o_Tx_Active (!UART_TX_ready),           // ready to serialize new data
        .o_Tx_Serial (uart_rx)                  // serialized data
    );

    UART_RX_CTRL #(
        .CLK_FREQUENCE(CLK_FREQUENCE),
        .BAUD_RATE(BAUD_RATE) 
    ) UART_RX_CTRL (
        .clk              (clk),
        .reset_n          (reset_n),
        .uart_rx_serial_i (uart_tx),
        .uart_dv_o        (UART_RX_ready),
        .uart_data_o      (UART_RX_data)
    ); 


    always@(posedge clk) begin
        if(UART_RX_ready) begin
            $write("%d",UART_RX_data);
        end
    end


endmodule
