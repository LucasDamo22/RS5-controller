`include "i2c_bno055_emulator_pkg.sv"
module i2c_bno055_emulator_regs
    import i2c_bno055_emulator_pkg::*;
#(
    parameter int unsigned ADDR_SIZE = 8,
    parameter int unsigned DATA_SIZE = 8
)(
    input  logic clk,
    input  logic reset_n,
    
    input  logic we_core_i,
    input  logic [((ADDR_SIZE)-1):0] core_addr_i,
    input  logic [((DATA_SIZE)-1):0] core_data_i,
    output logic [((DATA_SIZE)-1):0] core_data_o,
    
    /* verilator lint_off UNUSEDSIGNAL */
    input  logic we_i2c_i,
    input  logic [((ADDR_SIZE)-1):0] i2c_addr_i,
    input  logic [((ADDR_SIZE)-1):0] i2c_data_i,
    /* verilator lint_on UNUSEDSIGNAL */
    output logic [((DATA_SIZE)-1):0]  i2c_data_o
);

logic [7:0] i2c_data;
logic [7:0] core_data;


/* TEMP REGS */
logic [7:0] BNO055_TEMP_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_TEMP_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_TEMP_ADDR) && we_core_i)
            BNO055_TEMP_reg <= core_data_i;
    end
end

//////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// ACCEL REGS /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

logic [7:0] BNO055_ACCEL_DATA_X_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_ACCEL_DATA_X_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_ACCEL_DATA_X_LSB_ADDR) && we_core_i)
            BNO055_ACCEL_DATA_X_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_ACCEL_DATA_X_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_ACCEL_DATA_X_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_ACCEL_DATA_X_MSB_ADDR) && we_core_i)
            BNO055_ACCEL_DATA_X_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_ACCEL_DATA_Y_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_ACCEL_DATA_Y_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_ACCEL_DATA_Y_LSB_ADDR) && we_core_i)
            BNO055_ACCEL_DATA_Y_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_ACCEL_DATA_Y_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_ACCEL_DATA_Y_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_ACCEL_DATA_Y_MSB_ADDR) && we_core_i)
            BNO055_ACCEL_DATA_Y_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_ACCEL_DATA_Z_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_ACCEL_DATA_Z_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_ACCEL_DATA_Z_LSB_ADDR) && we_core_i)
            BNO055_ACCEL_DATA_Z_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_ACCEL_DATA_Z_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_ACCEL_DATA_Z_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_ACCEL_DATA_Z_MSB_ADDR) && we_core_i)
            BNO055_ACCEL_DATA_Z_MSB_reg <= core_data_i;
    end
end
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// MAG REGS /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

logic [7:0] BNO055_MAG_DATA_X_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_MAG_DATA_X_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_MAG_DATA_X_LSB_ADDR) && we_core_i)
            BNO055_MAG_DATA_X_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_MAG_DATA_X_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_MAG_DATA_X_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_MAG_DATA_X_MSB_ADDR) && we_core_i)
            BNO055_MAG_DATA_X_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_MAG_DATA_Y_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_MAG_DATA_Y_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_MAG_DATA_Y_LSB_ADDR) && we_core_i)
            BNO055_MAG_DATA_Y_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_MAG_DATA_Y_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_MAG_DATA_Y_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_MAG_DATA_Y_MSB_ADDR) && we_core_i)
            BNO055_MAG_DATA_Y_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_MAG_DATA_Z_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_MAG_DATA_Z_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_MAG_DATA_Z_LSB_ADDR) && we_core_i)
            BNO055_MAG_DATA_Z_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_MAG_DATA_Z_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_MAG_DATA_Z_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_MAG_DATA_Z_MSB_ADDR) && we_core_i)
            BNO055_MAG_DATA_Z_MSB_reg <= core_data_i;
    end
end
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// GYRO REGS /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

logic [7:0] BNO055_GYRO_DATA_X_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_GYRO_DATA_X_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_GYRO_DATA_X_LSB_ADDR) && we_core_i)
            BNO055_GYRO_DATA_X_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_GYRO_DATA_X_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_GYRO_DATA_X_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_GYRO_DATA_X_MSB_ADDR) && we_core_i)
            BNO055_GYRO_DATA_X_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_GYRO_DATA_Y_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_GYRO_DATA_Y_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_GYRO_DATA_Y_LSB_ADDR) && we_core_i)
            BNO055_GYRO_DATA_Y_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_GYRO_DATA_Y_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_GYRO_DATA_Y_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_GYRO_DATA_Y_MSB_ADDR) && we_core_i)
            BNO055_GYRO_DATA_Y_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_GYRO_DATA_Z_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_GYRO_DATA_Z_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_GYRO_DATA_Z_LSB_ADDR) && we_core_i)
            BNO055_GYRO_DATA_Z_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_GYRO_DATA_Z_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_GYRO_DATA_Z_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_GYRO_DATA_Z_MSB_ADDR) && we_core_i)
            BNO055_GYRO_DATA_Z_MSB_reg <= core_data_i;
    end
end
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// EULER REGS ////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

logic [7:0] BNO055_EULER_H_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_EULER_H_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_EULER_H_LSB_ADDR) && we_core_i)
            BNO055_EULER_H_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_EULER_H_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_EULER_H_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_EULER_H_MSB_ADDR) && we_core_i)
            BNO055_EULER_H_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_EULER_R_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_EULER_R_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_EULER_R_LSB_ADDR) && we_core_i)
            BNO055_EULER_R_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_EULER_R_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_EULER_R_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_EULER_R_MSB_ADDR) && we_core_i)
            BNO055_EULER_R_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_EULER_P_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_EULER_P_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_EULER_P_LSB_ADDR) && we_core_i)
            BNO055_EULER_P_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_EULER_P_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_EULER_P_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_EULER_P_MSB_ADDR) && we_core_i)
            BNO055_EULER_P_MSB_reg <= core_data_i;
    end
end
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// QUATERNION REGS //////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

logic [7:0] BNO055_QUATERNION_DATA_W_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_QUATERNION_DATA_W_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_QUATERNION_DATA_W_LSB_ADDR) && we_core_i)
            BNO055_QUATERNION_DATA_W_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_QUATERNION_DATA_W_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_QUATERNION_DATA_W_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_QUATERNION_DATA_W_MSB_ADDR) && we_core_i)
            BNO055_QUATERNION_DATA_W_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_QUATERNION_DATA_X_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_QUATERNION_DATA_X_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_QUATERNION_DATA_X_LSB_ADDR) && we_core_i)
            BNO055_QUATERNION_DATA_X_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_QUATERNION_DATA_X_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_QUATERNION_DATA_X_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_QUATERNION_DATA_X_MSB_ADDR) && we_core_i)
            BNO055_QUATERNION_DATA_X_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_QUATERNION_DATA_Y_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_QUATERNION_DATA_Y_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_QUATERNION_DATA_Y_LSB_reg) && we_core_i)
            BNO055_QUATERNION_DATA_Y_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_QUATERNION_DATA_Y_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_QUATERNION_DATA_Y_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_QUATERNION_DATA_Y_MSB_ADDR) && we_core_i)
            BNO055_QUATERNION_DATA_Y_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_QUATERNION_DATA_Z_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_QUATERNION_DATA_Z_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_QUATERNION_DATA_Z_LSB_ADDR) && we_core_i)
            BNO055_QUATERNION_DATA_Z_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_QUATERNION_DATA_Z_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_QUATERNION_DATA_Z_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_QUATERNION_DATA_Z_MSB_ADDR) && we_core_i)
            BNO055_QUATERNION_DATA_Z_MSB_reg <= core_data_i;
    end
end
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
////////////////////////////// LINEAR ACCEL REGS /////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

logic [7:0] BNO055_LINEAR_ACCEL_DATA_X_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_LINEAR_ACCEL_DATA_X_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_LINEAR_ACCEL_DATA_X_LSB_ADDR) && we_core_i)
            BNO055_LINEAR_ACCEL_DATA_X_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_LINEAR_ACCEL_DATA_X_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_LINEAR_ACCEL_DATA_X_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_LINEAR_ACCEL_DATA_X_MSB_ADDR) && we_core_i)
            BNO055_LINEAR_ACCEL_DATA_X_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_LINEAR_ACCEL_DATA_Y_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_LINEAR_ACCEL_DATA_Y_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_LINEAR_ACCEL_DATA_Y_LSB_ADDR) && we_core_i)
            BNO055_LINEAR_ACCEL_DATA_Y_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_LINEAR_ACCEL_DATA_Y_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_LINEAR_ACCEL_DATA_Y_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_LINEAR_ACCEL_DATA_Y_MSB_ADDR) && we_core_i)
            BNO055_LINEAR_ACCEL_DATA_Y_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_LINEAR_ACCEL_DATA_Z_LSB_reg;;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_LINEAR_ACCEL_DATA_Z_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_LINEAR_ACCEL_DATA_Z_LSB_ADDR) && we_core_i)
            BNO055_LINEAR_ACCEL_DATA_Z_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_LINEAR_ACCEL_DATA_Z_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_LINEAR_ACCEL_DATA_Z_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_LINEAR_ACCEL_DATA_Z_MSB_ADDR) && we_core_i)
            BNO055_LINEAR_ACCEL_DATA_Z_MSB_reg <= core_data_i;
    end
end
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
////////////////////////////// GRAVITY DATA REGS /////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

logic [7:0] BNO055_GRAVITY_DATA_X_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_GRAVITY_DATA_X_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_GRAVITY_DATA_X_LSB_ADDR) && we_core_i)
            BNO055_GRAVITY_DATA_X_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_GRAVITY_DATA_X_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_GRAVITY_DATA_X_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_GRAVITY_DATA_X_MSB_ADDR) && we_core_i)
            BNO055_GRAVITY_DATA_X_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_GRAVITY_DATA_Y_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_GRAVITY_DATA_Y_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_GRAVITY_DATA_Y_LSB_ADDR) && we_core_i)
            BNO055_GRAVITY_DATA_Y_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_GRAVITY_DATA_Y_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_GRAVITY_DATA_Y_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_GRAVITY_DATA_Y_MSB_ADDR) && we_core_i)
            BNO055_GRAVITY_DATA_Y_MSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_GRAVITY_DATA_Z_LSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_GRAVITY_DATA_Z_LSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_GRAVITY_DATA_Z_LSB_ADDR) && we_core_i)
            BNO055_GRAVITY_DATA_Z_LSB_reg <= core_data_i;
    end
end

logic [7:0] BNO055_GRAVITY_DATA_Z_MSB_reg;
always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        BNO055_GRAVITY_DATA_Z_MSB_reg <= 8'b0;
    end
    else begin
        if((core_addr_i == BNO055_GRAVITY_DATA_Z_MSB_ADDR) && we_core_i)
            BNO055_GRAVITY_DATA_Z_MSB_reg <= core_data_i;
    end
end
//////////////////////////////////////////////////////////////////////////////////


always_ff @(posedge clk or negedge reset_n)begin
    if(!reset_n) begin
        i2c_data_o <= 8'b0;
    end else begin
        i2c_data_o <= i2c_data;
    end
end

always_comb begin
    unique case (i2c_addr_i)
        //temp
        BNO055_TEMP_ADDR:                    i2c_data = BNO055_TEMP_reg;
        //accel
        BNO055_ACCEL_DATA_X_LSB_ADDR:        i2c_data = BNO055_ACCEL_DATA_X_LSB_reg;
        BNO055_ACCEL_DATA_X_MSB_ADDR:        i2c_data = BNO055_ACCEL_DATA_X_MSB_reg;
        BNO055_ACCEL_DATA_Y_LSB_ADDR:        i2c_data = BNO055_ACCEL_DATA_Y_LSB_reg;
        BNO055_ACCEL_DATA_Y_MSB_ADDR:        i2c_data = BNO055_ACCEL_DATA_Y_MSB_reg;
        BNO055_ACCEL_DATA_Z_LSB_ADDR:        i2c_data = BNO055_ACCEL_DATA_Z_LSB_reg;
        BNO055_ACCEL_DATA_Z_MSB_ADDR:        i2c_data = BNO055_ACCEL_DATA_Z_MSB_reg;
        //MAG
        BNO055_MAG_DATA_X_LSB_ADDR:          i2c_data = BNO055_MAG_DATA_X_LSB_reg;
        BNO055_MAG_DATA_X_MSB_ADDR:          i2c_data = BNO055_MAG_DATA_X_MSB_reg;
        BNO055_MAG_DATA_Y_LSB_ADDR:          i2c_data = BNO055_MAG_DATA_Y_LSB_reg;
        BNO055_MAG_DATA_Y_MSB_ADDR:          i2c_data = BNO055_MAG_DATA_Y_MSB_reg;
        BNO055_MAG_DATA_Z_LSB_ADDR:          i2c_data = BNO055_MAG_DATA_Z_LSB_reg;
        BNO055_MAG_DATA_Z_MSB_ADDR:          i2c_data = BNO055_MAG_DATA_Z_MSB_reg;
        //gyro
        BNO055_GYRO_DATA_X_LSB_ADDR:         i2c_data = BNO055_GYRO_DATA_X_LSB_reg;
        BNO055_GYRO_DATA_X_MSB_ADDR:         i2c_data = BNO055_GYRO_DATA_X_MSB_reg;
        BNO055_GYRO_DATA_Y_LSB_ADDR:         i2c_data = BNO055_GYRO_DATA_Y_LSB_reg;
        BNO055_GYRO_DATA_Y_MSB_ADDR:         i2c_data = BNO055_GYRO_DATA_Y_MSB_reg;
        BNO055_GYRO_DATA_Z_LSB_ADDR:         i2c_data = BNO055_GYRO_DATA_Z_LSB_reg;
        BNO055_GYRO_DATA_Z_MSB_ADDR:         i2c_data = BNO055_GYRO_DATA_Z_MSB_reg;
        //euler
        BNO055_EULER_H_LSB_ADDR:             i2c_data = BNO055_EULER_H_LSB_reg;
        BNO055_EULER_H_MSB_ADDR:             i2c_data = BNO055_EULER_H_MSB_reg;
        BNO055_EULER_R_LSB_ADDR:             i2c_data = BNO055_EULER_R_LSB_reg;
        BNO055_EULER_R_MSB_ADDR:             i2c_data = BNO055_EULER_R_MSB_reg;
        BNO055_EULER_P_LSB_ADDR:             i2c_data = BNO055_EULER_P_LSB_reg;
        BNO055_EULER_P_MSB_ADDR:             i2c_data = BNO055_EULER_P_MSB_reg;
        //quaternion
        BNO055_QUATERNION_DATA_W_LSB_ADDR:   i2c_data = BNO055_QUATERNION_DATA_W_LSB_reg;
        BNO055_QUATERNION_DATA_W_MSB_ADDR:   i2c_data = BNO055_QUATERNION_DATA_W_MSB_reg;
        BNO055_QUATERNION_DATA_X_LSB_ADDR:   i2c_data = BNO055_QUATERNION_DATA_X_LSB_reg;
        BNO055_QUATERNION_DATA_X_MSB_ADDR:   i2c_data = BNO055_QUATERNION_DATA_X_MSB_reg;
        BNO055_QUATERNION_DATA_Y_LSB_ADDR:   i2c_data = BNO055_QUATERNION_DATA_Y_LSB_reg;
        BNO055_QUATERNION_DATA_Y_MSB_ADDR:   i2c_data = BNO055_QUATERNION_DATA_Y_MSB_reg;
        BNO055_QUATERNION_DATA_Z_LSB_ADDR:   i2c_data = BNO055_QUATERNION_DATA_Z_LSB_reg;
        BNO055_QUATERNION_DATA_Z_MSB_ADDR:   i2c_data = BNO055_QUATERNION_DATA_Z_MSB_reg;
        //linear accel
        BNO055_LINEAR_ACCEL_DATA_X_LSB_ADDR: i2c_data = BNO055_LINEAR_ACCEL_DATA_X_LSB_reg;
        BNO055_LINEAR_ACCEL_DATA_X_MSB_ADDR: i2c_data = BNO055_LINEAR_ACCEL_DATA_X_MSB_reg;
        BNO055_LINEAR_ACCEL_DATA_Y_LSB_ADDR: i2c_data = BNO055_LINEAR_ACCEL_DATA_Y_LSB_reg;
        BNO055_LINEAR_ACCEL_DATA_Y_MSB_ADDR: i2c_data = BNO055_LINEAR_ACCEL_DATA_Y_MSB_reg;
        BNO055_LINEAR_ACCEL_DATA_Z_LSB_ADDR: i2c_data = BNO055_LINEAR_ACCEL_DATA_Z_LSB_reg;
        BNO055_LINEAR_ACCEL_DATA_Z_MSB_ADDR: i2c_data = BNO055_LINEAR_ACCEL_DATA_Z_MSB_reg;
        //grav
        BNO055_GRAVITY_DATA_X_LSB_ADDR:      i2c_data = BNO055_GRAVITY_DATA_X_LSB_reg;
        BNO055_GRAVITY_DATA_X_MSB_ADDR:      i2c_data = BNO055_GRAVITY_DATA_X_MSB_reg;
        BNO055_GRAVITY_DATA_Y_LSB_ADDR:      i2c_data = BNO055_GRAVITY_DATA_Y_LSB_reg;
        BNO055_GRAVITY_DATA_Y_MSB_ADDR:      i2c_data = BNO055_GRAVITY_DATA_Y_MSB_reg;
        BNO055_GRAVITY_DATA_Z_LSB_ADDR:      i2c_data = BNO055_GRAVITY_DATA_Z_LSB_reg;
        BNO055_GRAVITY_DATA_Z_MSB_ADDR:      i2c_data = BNO055_GRAVITY_DATA_Z_MSB_reg;
        default: i2c_data = 8'b0;
    endcase
end

always_ff @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        core_data_o <= 8'b0;
    end else begin
        core_data_o <= core_data;
    end
end

always_comb begin
    unique case (core_addr_i)
        //temp
        BNO055_TEMP_ADDR:                    core_data = BNO055_TEMP_reg;
        //accel
        BNO055_ACCEL_DATA_X_LSB_ADDR:        core_data = BNO055_ACCEL_DATA_X_LSB_reg;
        BNO055_ACCEL_DATA_X_MSB_ADDR:        core_data = BNO055_ACCEL_DATA_X_MSB_reg;
        BNO055_ACCEL_DATA_Y_LSB_ADDR:        core_data = BNO055_ACCEL_DATA_Y_LSB_reg;
        BNO055_ACCEL_DATA_Y_MSB_ADDR:        core_data = BNO055_ACCEL_DATA_Y_MSB_reg;
        BNO055_ACCEL_DATA_Z_LSB_ADDR:        core_data = BNO055_ACCEL_DATA_Z_LSB_reg;
        BNO055_ACCEL_DATA_Z_MSB_ADDR:        core_data = BNO055_ACCEL_DATA_Z_MSB_reg;
        //MAG
        BNO055_MAG_DATA_X_LSB_ADDR:          core_data = BNO055_MAG_DATA_X_LSB_reg;
        BNO055_MAG_DATA_X_MSB_ADDR:          core_data = BNO055_MAG_DATA_X_MSB_reg;
        BNO055_MAG_DATA_Y_LSB_ADDR:          core_data = BNO055_MAG_DATA_Y_LSB_reg;
        BNO055_MAG_DATA_Y_MSB_ADDR:          core_data = BNO055_MAG_DATA_Y_MSB_reg;
        BNO055_MAG_DATA_Z_LSB_ADDR:          core_data = BNO055_MAG_DATA_Z_LSB_reg;
        BNO055_MAG_DATA_Z_MSB_ADDR:          core_data = BNO055_MAG_DATA_Z_MSB_reg;
        //gyro
        BNO055_GYRO_DATA_X_LSB_ADDR:         core_data = BNO055_GYRO_DATA_X_LSB_reg;
        BNO055_GYRO_DATA_X_MSB_ADDR:         core_data = BNO055_GYRO_DATA_X_MSB_reg;
        BNO055_GYRO_DATA_Y_LSB_ADDR:         core_data = BNO055_GYRO_DATA_Y_LSB_reg;
        BNO055_GYRO_DATA_Y_MSB_ADDR:         core_data = BNO055_GYRO_DATA_Y_MSB_reg;
        BNO055_GYRO_DATA_Z_LSB_ADDR:         core_data = BNO055_GYRO_DATA_Z_LSB_reg;
        BNO055_GYRO_DATA_Z_MSB_ADDR:         core_data = BNO055_GYRO_DATA_Z_MSB_reg;
        //euler
        BNO055_EULER_H_LSB_ADDR:             core_data = BNO055_EULER_H_LSB_reg;
        BNO055_EULER_H_MSB_ADDR:             core_data = BNO055_EULER_H_MSB_reg;
        BNO055_EULER_R_LSB_ADDR:             core_data = BNO055_EULER_R_LSB_reg;
        BNO055_EULER_R_MSB_ADDR:             core_data = BNO055_EULER_R_MSB_reg;
        BNO055_EULER_P_LSB_ADDR:             core_data = BNO055_EULER_P_LSB_reg;
        BNO055_EULER_P_MSB_ADDR:             core_data = BNO055_EULER_P_MSB_reg;
        //quaternion
        BNO055_QUATERNION_DATA_W_LSB_ADDR:   core_data = BNO055_QUATERNION_DATA_W_LSB_reg;
        BNO055_QUATERNION_DATA_W_MSB_ADDR:   core_data = BNO055_QUATERNION_DATA_W_MSB_reg;
        BNO055_QUATERNION_DATA_X_LSB_ADDR:   core_data = BNO055_QUATERNION_DATA_X_LSB_reg;
        BNO055_QUATERNION_DATA_X_MSB_ADDR:   core_data = BNO055_QUATERNION_DATA_X_MSB_reg;
        BNO055_QUATERNION_DATA_Y_LSB_ADDR:   core_data = BNO055_QUATERNION_DATA_Y_LSB_reg;
        BNO055_QUATERNION_DATA_Y_MSB_ADDR:   core_data = BNO055_QUATERNION_DATA_Y_MSB_reg;
        BNO055_QUATERNION_DATA_Z_LSB_ADDR:   core_data = BNO055_QUATERNION_DATA_Z_LSB_reg;
        BNO055_QUATERNION_DATA_Z_MSB_ADDR:   core_data = BNO055_QUATERNION_DATA_Z_MSB_reg;
        //linear accel
        BNO055_LINEAR_ACCEL_DATA_X_LSB_ADDR: core_data = BNO055_LINEAR_ACCEL_DATA_X_LSB_reg;
        BNO055_LINEAR_ACCEL_DATA_X_MSB_ADDR: core_data = BNO055_LINEAR_ACCEL_DATA_X_MSB_reg;
        BNO055_LINEAR_ACCEL_DATA_Y_LSB_ADDR: core_data = BNO055_LINEAR_ACCEL_DATA_Y_LSB_reg;
        BNO055_LINEAR_ACCEL_DATA_Y_MSB_ADDR: core_data = BNO055_LINEAR_ACCEL_DATA_Y_MSB_reg;
        BNO055_LINEAR_ACCEL_DATA_Z_LSB_ADDR: core_data = BNO055_LINEAR_ACCEL_DATA_Z_LSB_reg;
        BNO055_LINEAR_ACCEL_DATA_Z_MSB_ADDR: core_data = BNO055_LINEAR_ACCEL_DATA_Z_MSB_reg;
        //grav
        BNO055_GRAVITY_DATA_X_LSB_ADDR:      core_data = BNO055_GRAVITY_DATA_X_LSB_reg;
        BNO055_GRAVITY_DATA_X_MSB_ADDR:      core_data = BNO055_GRAVITY_DATA_X_MSB_reg;
        BNO055_GRAVITY_DATA_Y_LSB_ADDR:      core_data = BNO055_GRAVITY_DATA_Y_LSB_reg;
        BNO055_GRAVITY_DATA_Y_MSB_ADDR:      core_data = BNO055_GRAVITY_DATA_Y_MSB_reg;
        BNO055_GRAVITY_DATA_Z_LSB_ADDR:      core_data = BNO055_GRAVITY_DATA_Z_LSB_reg;
        BNO055_GRAVITY_DATA_Z_MSB_ADDR:      core_data = BNO055_GRAVITY_DATA_Z_MSB_reg;
        default: core_data = 8'b0;
    endcase
end
endmodule
