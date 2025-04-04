module Peripherals
    import RS5_pkg::*;
#(
    parameter i_cnt = 1,
    parameter int unsigned CLK_FREQUENCE = 100_000_000,
	parameter int unsigned BAUD_RATE 	 = 115_200
)
(
    input  logic            clk,
    input  logic            reset_n,
    
    input  logic            enable_i,
    input  logic [3:0]      write_enable_i,
    input  logic [31:0]     data_address_i,
    input  logic [31:0]     data_i,
    output logic [31:0]     data_o,
    output logic            UART_TX,
    input  logic            UART_RX,
    output logic            stall_o,
    output logic [i_cnt:1]  interrupt_req_o,
    input  logic [i_cnt:1]  interrupt_ack_i    
);
     
    logic           BUFFER_write, BUFFER_read, BUFFER_empty, BUFFER_full;
    logic [7:0]     BUFFER_data;
    logic           UART_TX_send;
    logic           UART_TX_ready;
    logic [7:0]     UART_TX_data;
    logic           UART_RX_ready;
    logic [7:0]     UART_RX_data;
    logic [7:0]     UART_RX_data_reg;
    logic           UART_RX_irq;
    

    

//////////////////////////////////////////////////////////////////////////////
// Writes in Peripherals
//////////////////////////////////////////////////////////////////////////////

    always @(posedge clk) begin
        if (enable_i && write_enable_i != '0) begin
            /// OUTPUT REG
            if ((data_address_i == 32'h80004000 || data_address_i == 32'h80001000) && BUFFER_full == '0) begin
                BUFFER_write <= 1;
                BUFFER_data <= data_i[7:0];
                $write("%c", data_i[7:0]);
            end
            // END REG
            else if (data_address_i == 32'h80000000) begin
                $display("\n#%0t END OF SIMULATION\n",$time);
                $finish;
            end
            // NOTHING
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

    assign interrupt_req_o[1]   = UART_RX_irq;
    assign UART_RX_ACK          = interrupt_ack_i[1];

//////////////////////////////////////////////////////////////////////////////
// STALL GENERATION
//////////////////////////////////////////////////////////////////////////////

    always_comb begin
        if (enable_i) begin
            // READS
 /*           if (write_enable_i == '0 && !stall_r) begin
                if (data_address_i == 32'h80006000) begin
                    stall_o = 1;
                end
                else begin
                    stall_o = 0;
                end
            end
            else */
            // WRITES
            if (write_enable_i != '0) begin
                if ((data_address_i == 32'h80004000 || data_address_i == 32'h80001000) && BUFFER_full) begin
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
                if(data_address_i == 32'h80005000) begin
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
        .i_Tx_DV     (UART_TX_send),            // enable send
        .i_Tx_Byte   (UART_TX_data),            // 8 bit 
        .o_Tx_Active (!UART_TX_ready),           // ready to serialize new data
        .o_Tx_Serial (UART_TX)                  // serialized data
    );
    
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

//////////////////////////////////////////////////////////////////////////////
// UART BUFFER
//////////////////////////////////////////////////////////////////////////////

    FIFO_BUFFER_UART FIFO_BUFFER_UART1 (
        .clk    (clk),                  // input wire clk
        .srst   (!reset_n),                // input wire srst
        .din    (BUFFER_data),          // input wire [7 : 0] din
        .wr_en  (BUFFER_write),         // input wire wr_en
        .rd_en  (BUFFER_read),          // input wire rd_en
        .dout   (UART_TX_data),            // output wire [7 : 0] dout
        .full   (BUFFER_full),          // output wire full
        .empty  (BUFFER_empty)          // output wire empty
    );

    assign BUFFER_read = UART_TX_ready & !BUFFER_empty & !UART_TX_send;

    always_ff @(posedge clk) begin
        UART_TX_send <= BUFFER_read;
    end

endmodule
