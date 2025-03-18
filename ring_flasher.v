`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2025 09:49:20 AM
// Design Name: 
// Module Name: ring_flasher
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ring_flasher (
    input wire clk,
    input wire rst_n,
    input wire repeat_signal,
    output reg [15:0] led
);

    reg [3:0] count;
    reg [3:0] led_offset;
    reg [3:0] state;
    reg [2:0] cycle_count;
    
    parameter IDLE = 3'b000;
    parameter CLOCKWISE = 3'b001;
    parameter ANTICLOCKWISE = 3'b010;
    parameter TOGGLE_CLOCKWISE = 3'b011;
    parameter TOGGLE_ANTICLOCKWISE = 3'b100;
    parameter CHECK = 3'b101;

    always @(posedge clk or negedge rst_n) begin
        // if reset is active, then reset all the values and go to IDLE state
        if (!rst_n) begin
            led <= 16'b0;
            led_offset <= 4'b0;
            count <= 4'b0;
            state <= IDLE;
            cycle_count <= 3'b0;
    
        end else begin
            case (state)
                IDLE: begin
                    led <= 16'b0;
                    led_offset <= 0;
                    count <= 0;
                    cycle_count <= 0;
                    if (repeat_signal) begin
                        state <= CLOCKWISE;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                CLOCKWISE: begin
                    if (count < 8) begin
                        led[led_offset] <= 1'b1;
                        led_offset <= led_offset + 1;
                        count <= count + 1;
                    end else begin
                        count <= 4;
                        led_offset <= led_offset - 1;
                        state <= ANTICLOCKWISE;
                    end
                end
                ANTICLOCKWISE: begin
                    if (count > 0) begin
                        led[led_offset] <= 1'b0;
                        led_offset <= led_offset - 1;
                        count <= count - 1;
                    end else begin
                        led_offset <= led_offset + 1;
                        if (cycle_count < 2) begin
                            cycle_count <= cycle_count + 1;
                            count <= 0;
                            state <= CLOCKWISE;
                        end else begin
                            cycle_count <= 0;
                            count <= 0;
                            state <= TOGGLE_CLOCKWISE;
                        end
                    end
                end
                TOGGLE_CLOCKWISE: begin
                    if (count < 8) begin
                        led[led_offset] <= ~led[led_offset];
                        led_offset <= led_offset + 1;
                        count <= count + 1;
                    end else begin
                        count <= 4;
                        led_offset <= led_offset - 1;
                        state <= TOGGLE_ANTICLOCKWISE;
                    end
                end
                TOGGLE_ANTICLOCKWISE: begin
                    if (count > 0) begin
                        led[led_offset] <= ~led[led_offset];
                        led_offset <= led_offset - 1;
                        count <= count - 1;
                    end
                    else begin
                        led_offset <= led_offset + 1; 
                        // if all leds are off, then go to IDLE state
                        // if (led == 16'b0 ) begin
                        // // problems here
                        //     state <= IDLE;
                        // end else begin
                        //     count <= 0;
                        //     state <= TOGGLE_CLOCKWISE;
                        // end
                        state <= CHECK; 
                    end
                end
                CHECK: begin 
                    if (led == 16'b0) begin 
                        state <= IDLE;
                    end else begin 
                        count <= 0;
                        state <= TOGGLE_CLOCKWISE;
                    end
                end
            endcase
        end 
    end
endmodule

