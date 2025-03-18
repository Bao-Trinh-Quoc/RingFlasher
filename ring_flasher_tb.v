//`timescale 1ns / 1ps

//module ring_flasher_tb;

//    reg clk;
//    reg rst_n;
//    reg repeat_signal;
//    wire [15:0] led;

//    // Instantiate the ring flasher module
//    ring_flasher uut (
//        .clk(clk),
//        .rst_n(rst_n),
//        .repeat_signal(repeat_signal),
//        .led(led)
//    );

//    // Clock generation
//    always #1 clk = ~clk;  // 10ns clock period (50MHz)

//    initial begin
//        // Initialize signals
//        clk = 0;
//        rst_n = 0;
//        repeat_signal = 0;

//        // Apply reset
//        #20 rst_n = 1; // Release reset after 20ns
        
//        // Start the ring flasher
//        #200 repeat_signal = 1;
        
//        // Run for a while to observe behavior
//        #400 repeat_signal = 0;
        
//        // Run for a while to observe behavior
//        #700;
        
//        // Observe final state for a longer time
//        #1000 $finish;  // Increased duration to capture full LED transition
//    end

//    // Monitor changes
//    initial begin
//        $monitor("Time: %0t | LED State: %b | State: %d | repeat_signal = %b", $time, led, uut.state, repeat_signal);
    
////        forever begin
////            #10 $display("Time: %0t | LED State: %b | State: %d | repeat_signal = %b", $time, led, uut.state, repeat_signal);
////        end
//    end
    
//endmodule
`timescale 1ns / 1ps

module ring_flasher_tb;

    reg clk;
    reg rst_n;
    reg repeat_signal;
    wire [15:0] led;

    // Instantiate the ring flasher module
    ring_flasher uut (
        .clk(clk),
        .rst_n(rst_n),
        .repeat_signal(repeat_signal),
        .led(led)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10ns clock period (50MHz), corrected from comment

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        repeat_signal = 0;

        // Apply reset
        #20 rst_n = 1;  // Release reset after 20ns
        
        // Start the ring flasher
        #100 repeat_signal = 1;  // Wait 100ns, then activate
        
        // Run with repeat_signal HIGH to observe full sequence
        #1000 repeat_signal = 0;  // Deactivate after 1000ns (100 cycles at 10ns)
        
        // Observe behavior after repeat_signal goes LOW
        #1000;
        
        // Test restart with repeat_signal HIGH again
        #100 repeat_signal = 1;
        #1000 repeat_signal = 0;
        
        // Final observation
        #2000 $finish;  // Total time increased to capture full behavior
    end

    // Monitor changes (state removed unless exposed in design)
    initial begin
        $monitor("Time: %0t | LED State: %b | repeat_signal = %b", $time, led, repeat_signal);
    end

//    // Dump waveform for debugging
//    initial begin
//        $dumpfile("ring_flasher_tb.vcd");
//        $dumpvars(0, ring_flasher_tb);
//    end
    
endmodule