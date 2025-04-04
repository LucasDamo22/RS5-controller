module UART_RX_CTRL 
  //import RS5_pkg::*;
#(
	parameter int unsigned CLK_FREQUENCE = 100_000_000,
	parameter int unsigned BAUD_RATE 	 = 115_200
)(
	input  logic        clk,
	input  logic        reset_n,
	input  logic     	  uart_rx_serial_i,
	output logic        uart_dv_o,
	output logic [7:0]  uart_data_o
);

	localparam int unsigned CLKS_PER_BIT = (CLK_FREQUENCE / BAUD_RATE);
	localparam int unsigned SIZE = $clog2(CLKS_PER_BIT+1);

	typedef enum logic[7:0] { 
		IDLE            = 8'b00000001,
		RX_START_BIT    = 8'b00000010,
		RX_DATA_BITS    = 8'b00000100,
		RX_INDEX_INC    = 8'b00001000,
		RX_ZERO_COUNT   = 8'b00010000,
		RX_ZERO_COUNT_2 = 8'b00100000,
		RX_STOP_BIT     = 8'b01000000,
		CLEANUP         = 8'b10000000
	} state_e;

	logic r_rx_serial;
	logic rr_rx_serial;
	logic rrr_rx_serial;

	// Purpose: Double-logicister the incoming data.
	// This allows it to be used in the UART RX Clock Domain.
	// (It removes problems caused by metastability)
	always_ff @(posedge clk or negedge reset_n) begin
		if(!reset_n) begin
			r_rx_serial 	<= 1'b1;
			rr_rx_serial 	<= 1'b1;
			rrr_rx_serial 	<= 1'b1;
		end else begin
			rrr_rx_serial <= uart_rx_serial_i;
			rr_rx_serial  <= rrr_rx_serial;
			r_rx_serial   <= rr_rx_serial;
		end
	end

	state_e current_state, next_state;

	always_ff @(posedge clk or negedge reset_n) begin 
		if (!reset_n) begin
			current_state <= IDLE;
		end 
		else begin
			current_state <= next_state;
		end
	end

	logic [SIZE-1:0]    r_Clock_Count;
	logic [2:0]     	r_Bit_Index;
	logic [7:0]     	r_Rx_Byte;
	logic           	r_Rx_DV;
	
	always_comb begin
		next_state = IDLE;
		unique case(current_state)
			IDLE:		  next_state = !r_rx_serial ? RX_START_BIT : IDLE;
			RX_START_BIT: begin
				if (r_Clock_Count < SIZE'(CLKS_PER_BIT/2))
					next_state = RX_START_BIT;
				else
					next_state = RX_ZERO_COUNT;
			end
			RX_ZERO_COUNT: begin
				next_state = RX_DATA_BITS;
			end
			RX_DATA_BITS: begin 
				if(r_Clock_Count < SIZE'(CLKS_PER_BIT))
					next_state = RX_DATA_BITS;
				else begin
					if(r_Bit_Index < 3'd7)
						next_state = RX_INDEX_INC;
					else
						next_state = RX_ZERO_COUNT_2;
				end
			end
			RX_INDEX_INC: begin 
				next_state = RX_DATA_BITS;
			end
			RX_ZERO_COUNT_2: begin
				next_state = RX_STOP_BIT;
			end
			RX_STOP_BIT: begin 
				if (r_Clock_Count < SIZE'(CLKS_PER_BIT))
					next_state = RX_STOP_BIT;
				else
					next_state = CLEANUP;
			end
			CLEANUP: begin 
				next_state = IDLE;
			end
		endcase
	end

	always_ff @(posedge clk or negedge reset_n) begin: r_Rx_Byte_fsm
		if (!reset_n) begin
			r_Rx_Byte <= '0;
		end 
		else begin
			case(current_state)
				RX_DATA_BITS: r_Rx_Byte[r_Bit_Index] <= r_rx_serial;
				default: 	  ;
			endcase
		end
	end

	always_ff @(posedge clk or negedge reset_n) begin: r_Clock_Count_fsm
		if (!reset_n) begin
			r_Clock_Count <= 0;
		end 
		else begin
			case(current_state)
				RX_START_BIT,
				RX_DATA_BITS,
				RX_STOP_BIT:	r_Clock_Count <= r_Clock_Count + 1'b1;
				default:		r_Clock_Count <= '0;
			endcase
		end
	end

	always_ff @(posedge clk or negedge reset_n) begin: r_Bit_Index_fsm
		if (!reset_n) begin
			r_Bit_Index <= '0;
		end 
		else begin
			case(current_state)
				RX_INDEX_INC: r_Bit_Index <= r_Bit_Index + 1'b1;
				CLEANUP:      r_Bit_Index <= '0;
				default:	  ;
			endcase
		end
	end

	always_ff @(posedge clk or negedge reset_n) begin: r_Rx_DV_fsm
		if (!reset_n) begin
			r_Rx_DV <= 1'b0;
		end else begin
			case(current_state)
				CLEANUP: 	r_Rx_DV <= 1'b1;
				default:	r_Rx_DV <= 1'b0;
			endcase
		end
	end

	assign uart_dv_o = r_Rx_DV;
	assign uart_data_o 		 = r_Rx_Byte;
	
endmodule
