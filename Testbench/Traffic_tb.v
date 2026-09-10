`timescale 1ns/1ps

module traffic_light_tb;

    // Inputs
    reg clk;
    reg rst_n;

    reg ped_btn_N;
    reg ped_btn_S;
    reg ped_btn_E;
    reg ped_btn_W;
    reg [2:0] current_state;
    reg [2:0] next_state;


    // Outputs
    wire [1:0] veh_NS;
    wire [1:0] veh_EW;

    wire [1:0] ped_NS;
    wire [1:0] ped_EW;

    // Instantiate DUT
    traffic_light_controller uut(
        .clk(clk),
        .rst_n(rst_n),


        .veh_NS(veh_NS),
        .veh_EW(veh_EW),

        .ped_NS(ped_NS),
        .ped_EW(ped_EW)
    );

    // Clock Generation (10 ns Period)
    always #5 clk = ~clk;

    initial
    begin

        // Initialize
        clk = 0;
        rst_n = 0;

        ped_btn_N = 0;
        ped_btn_S = 0;
        ped_btn_E = 0;
        ped_btn_W = 0;

        // Generate waveform
        $dumpfile("traffic.vcd");
        $dumpvars(0, traffic_light_tb);

        rst_n=1;


        // East pedestrian requests crossing
        #30 ped_btn_E = 1;
        #40 ped_btn_E = 0;

        #300;

      

        $finish;

    end

endmodule
