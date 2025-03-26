`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2025 10:00:00 AM
// Module Name: ring_flasher_tb
// Description: 
//  Testbench for ring_flasher module with parameterized delays.
// Revision:
// Revision 0.01 - File Created
// Revision 1.00 - Code style improvements, parameterized delays
//////////////////////////////////////////////////////////////////////////////////

module ring_flasher_tb;

    //------------------------------------------
    // Parameters
    //------------------------------------------
    localparam CLK_HALF_PERIOD = 5; // 10ns clock period (50MHz)
    localparam RST_DELAY       = 20;
    localparam TEST_DELAY      = 1000;

    //------------------------------------------
    // Signals
    //------------------------------------------
    reg        clk;
    reg        rst_n;
    reg        repeat_signal;
    wire [15:0] led;

    //------------------------------------------
    // Instantiate DUT
    //------------------------------------------
    ring_flasher uut (
        .clk           (clk),
        .rst_n         (rst_n),
        .repeat_signal (repeat_signal),
        .led           (led)
    );

    //------------------------------------------
    // Clock Generation
    //------------------------------------------
    always #CLK_HALF_PERIOD clk = ~clk;

    //------------------------------------------
    // Test Sequence
    //------------------------------------------
    initial begin
        clk           = 0;
        rst_n         = 0;
        repeat_signal = 0;

        // Release reset
        #RST_DELAY rst_n = 1;

        // Activate repeat_signal
        #TEST_DELAY repeat_signal = 1;
        #TEST_DELAY repeat_signal = 0;

        // Restart test
        #TEST_DELAY repeat_signal = 1;
        #TEST_DELAY repeat_signal = 0;

        // Finish simulation
        #(2*TEST_DELAY) $finish;
    end

    //------------------------------------------
    // Monitoring
    //------------------------------------------
    initial begin
        $monitor("Time: %0t | LED State: %b | repeat_signal = %b", 
                 $time, led, repeat_signal);
    end

endmodule
