`include "../cpu/RS5_pkg.sv"
module Peripherals
    import RS5_pkg::*;
#(
    parameter i_cnt = 2,
    parameter int unsigned CLK_FREQUENCE    = 100_000_000,
	parameter int unsigned BAUD_RATE 	    = 115_200,
    parameter int unsigned BYTE_SIZE        = 8,
    parameter int unsigned BUFFER_SIZE_UART = 32 
)
(
    input  logic            clk,
    input  logic            reset_n,
    
    input  logic            enable_i,
    input  logic [3:0]      write_enable_i,
    input  logic [31:0]     data_address_i,
    /* verilator lint_off UNUSEDSIGNAL */
    input  logic [31:0]     data_i,
    /* verilator lint_on UNUSEDSIGNAL */
    output logic [31:0]     data_o,
    output logic            UART_TX,
    input  logic            UART_RX,
    output logic            stall_o,
    /* verilator lint_off UNDRIVEN */
    output logic [i_cnt:1]  interrupt_req_o,
    /* verilator lint_on UNDRIVEN */
    /* verilator lint_off UNUSEDSIGNAL */
    input  logic [i_cnt:1]  interrupt_ack_i    
    /* verilator lint_on UNUSEDSIGNAL */
);
     
    logic           BUFFER_write, BUFFER_read, BUFFER_read_avail,  BUFFER_write_avail;
    logic [7:0]     BUFFER_data;
    logic           UART_TX_busy;
    logic [7:0]     UART_TX_data;
    logic           UART_RX_ready;
    logic [7:0]     UART_RX_data;
    logic [7:0]     UART_RX_data_reg;
    logic           UART_RX_irq;
    localparam      UART_ADDRESS = 32'h80001000;

    

//////////////////////////////////////////////////////////////////////////////
// Writes in Peripherals
//////////////////////////////////////////////////////////////////////////////

    always @(posedge clk) begin
        if (enable_i && write_enable_i != '0) begin
            if ((data_address_i == UART_ADDRESS) && BUFFER_write_avail) begin
                BUFFER_write <= 1;
                BUFFER_data <= data_i[7:0];
            end
            else begin
                BUFFER_write <= '0;
            end

        end else begin
            BUFFER_write <= '0;
        end
    end

//////////////////////////////////////////////////////////////////////////////
// INTERRUPT CONTROL
//////////////////////////////////////////////////////////////////////////////

    logic UART_RX_ACK;
    /* verilator lint_off UNDRIVEN */
    logic UART_TX_irq;
    /* verilator lint_on UNDRIVEN */
    assign interrupt_req_o[1]   = UART_RX_irq;
    assign interrupt_req_o[2]   = UART_TX_irq;
    assign UART_RX_ACK          = interrupt_ack_i[1];

//////////////////////////////////////////////////////////////////////////////
// STALL GENERATION
//////////////////////////////////////////////////////////////////////////////

    always_comb begin
        if (enable_i) begin
            if (write_enable_i != '0) begin
                if ((data_address_i == UART_ADDRESS) && !BUFFER_write_avail) begin
                    stall_o = 1;
                end
                else begin
                    stall_o = 0;
                end
            end
            else begin
                stall_o = 0;
            end
        end 
        else begin
            stall_o = 0;
        end
    end

    always_ff @(posedge clk or negedge reset_n) begin
        if(!reset_n)begin
            data_o <= '0;
        end
        else begin
            if(write_enable_i == '0 && enable_i) begin
                if(data_address_i == 32'h80001000) begin
                    data_o <= {{24{1'b0}}, UART_RX_data_reg };
                end
            end
        end
    end
//////////////////////////////////////////////////////////////////////////////
// UART INSTANTIATION
//////////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////////
    // UART TX
    //////////////////////////////////////////////////////////////////////////////
    UART_TX_CTRL #(
        .CLK_FREQUENCE(CLK_FREQUENCE),
        .BAUD_RATE(BAUD_RATE) 
    ) UART_TX_CTRL (
        .i_Clock     (clk),
        .reset_n     (reset_n),
        .i_Tx_DV     (BUFFER_read),            // enable send
        .i_Tx_Byte   (UART_TX_data),            // 8 bit 
        .o_Tx_Active (UART_TX_busy),           // ready to serialize new data
        .o_Tx_Serial (UART_TX)                  // serialized data
    );

    RingBuffer #(
        .DATA_SIZE(BYTE_SIZE),
        .BUFFER_SIZE(BUFFER_SIZE_UART)
    ) ring_buf (
        .clk_i(clk),
        .rst_ni(reset_n),
        .buf_rst_i(1'b0),

        .rx_i(BUFFER_write),
        .rx_ack_o(BUFFER_write_avail),
        .data_i(BUFFER_data),
        
        .tx_o(BUFFER_read_avail),
        .tx_ack_i(BUFFER_read),
        .data_o(UART_TX_data)
    );

    always_ff @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            BUFFER_read <= 1'b0;
        end
        else begin
            if(BUFFER_read_avail && !UART_TX_busy && !BUFFER_read) begin
                BUFFER_read <= 1'b1;
            end
            else begin
                BUFFER_read <= 1'b0;
            end
        end
    end

    
    //////////////////////////////////////////////////////////////////////////////
    // UART RX
    //////////////////////////////////////////////////////////////////////////////

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            UART_RX_irq <= 0;
        end
        else if (UART_RX_ready == 1'b1) begin
            UART_RX_irq <= 1;
        end
        else if (UART_RX_ACK == 1'b1) begin
            UART_RX_irq <= 0;
        end
    end
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            UART_RX_data_reg <= '0;
        end 
        else begin
            if(UART_RX_ready)begin
                UART_RX_data_reg <= UART_RX_data;
            end
        end
    end

    UART_RX_CTRL #(
        .CLK_FREQUENCE(CLK_FREQUENCE),
        .BAUD_RATE(BAUD_RATE) 
    ) UART_RX_CTRL (
        .clk              (clk),
        .reset_n          (reset_n),
        .uart_rx_serial_i (UART_RX),
        .uart_dv_o        (UART_RX_ready),
        .uart_data_o      (UART_RX_data)
    ); 



endmodule
