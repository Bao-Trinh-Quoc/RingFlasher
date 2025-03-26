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
// Tool Versions: `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2025 09:49:20 AM
// Design Name: Ring LED Flasher
// Module Name: ring_flasher
// Description: 
//  LED controller with clockwise, anticlockwise, and toggle modes.
// Revision:
// Revision 0.01 - File Created
// Revision 1.00 - Code style improvements, added comments, fixed state machine
//////////////////////////////////////////////////////////////////////////////////

module ring_flasher (
    input  wire       clk,           // System clock (posedge triggered)
    input  wire       rst_n,         // Active-low asynchronous reset
    input  wire       repeat_signal, // Signal to start/restart LED sequence
    output reg [15:0] led            // LED output (active-high)
);

    //------------------------------------------
    // State Encoding Parameters
    //------------------------------------------
    localparam [2:0] IDLE               = 3'b000;
    localparam [2:0] CLOCKWISE          = 3'b001;
    localparam [2:0] ANTICLOCKWISE      = 3'b010;
    localparam [2:0] TOGGLE_CLOCKWISE   = 3'b011;
    localparam [2:0] TOGGLE_ANTICLOCKWISE = 3'b100;
    localparam [2:0] CHECK              = 3'b101;

    //------------------------------------------
    // Internal Registers (FF)
    //------------------------------------------
    reg [3:0] count;           // Counter for LED steps
    reg [3:0] led_offset;      // Current LED position
    reg [2:0] state;           // Current state
    reg [2:0] cycle_count;     // Tracks number of cycles

    //------------------------------------------
    // State Machine and LED Control
    //------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset (active-low)
            led         <= 16'b0000_0000_0000_0000;
            led_offset  <= 4'b0000;
            count       <= 4'b0000;
            state       <= IDLE;
            cycle_count <= 3'b000;
        end
        else begin
            case (state)
                IDLE: begin
                    led <= 16'b0000_0000_0000_0000;
                    led_offset  <= 0;
                    count       <= 0;
                    cycle_count <= 0;
                    state       <= (repeat_signal) ? CLOCKWISE : IDLE;
                end

                CLOCKWISE: begin
                    if (count < 8) begin
                        led[led_offset] <= 1'b1;
                        led_offset      <= led_offset + 1;
                        count           <= count + 1;
                    end
                    else begin
                        count       <= 4;
                        led_offset  <= led_offset - 1;
                        state       <= ANTICLOCKWISE;
                    end
                end

                ANTICLOCKWISE: begin
                    if (count > 0) begin
                        led[led_offset] <= 1'b0;
                        led_offset      <= led_offset - 1;
                        count           <= count - 1;
                    end
                    else begin
                        led_offset <= led_offset + 1;
                        if (cycle_count < 2) begin
                            cycle_count <= cycle_count + 1;
                            count       <= 0;
                            state       <= CLOCKWISE;
                        end
                        else begin
                            cycle_count <= 0;
                            count       <= 0;
                            state       <= TOGGLE_CLOCKWISE;
                        end
                    end
                end

                TOGGLE_CLOCKWISE: begin
                    if (count < 8) begin
                        led[led_offset] <= ~led[led_offset];
                        led_offset      <= led_offset + 1;
                        count           <= count + 1;
                    end
                    else begin
                        count       <= 4;
                        led_offset  <= led_offset - 1;
                        state       <= TOGGLE_ANTICLOCKWISE;
                    end
                end

                TOGGLE_ANTICLOCKWISE: begin
                    if (count > 0) begin
                        led[led_offset] <= ~led[led_offset];
                        led_offset      <= led_offset - 1;
                        count           <= count - 1;
                    end
                    else begin
                        led_offset <= led_offset + 1;
                        state      <= CHECK;
                    end
                end

                CHECK: begin
                    state <= (led == 16'b0) ? IDLE : TOGGLE_CLOCKWISE;
                end

                default: begin
                    state <= IDLE; // Handle unexpected states
                end
            endcase
        end
    end

endmodule
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

