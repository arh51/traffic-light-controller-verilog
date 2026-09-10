// Vehicle Light Encoding
`define RED     2'd0
`define YELLOW  2'd1
`define GREEN   2'd2

// Pedestrian Signal Encoding
`define DONT_WALK 2'd0
`define WALK      2'd1
`define BLINK     2'd2

// FSM State Encoding
`define S0_NS_GREEN   3'd0
`define S1_NS_YELLOW  3'd1
`define S2_ALL_RED_1  3'd2
`define S3_EW_GREEN   3'd3
`define S4_EW_YELLOW  3'd4
`define S5_ALL_RED_2  3'd5

// Timing Parameters
`define T_GREEN    5
`define T_YELLOW   2
`define T_WALK     5
`define T_BLINK     2
`define T_ALL_RED   1

module traffic_light_controller(

    input clk,
    input rst_n,


    output reg [1:0] veh_NS,
    output reg [1:0] veh_EW,

    output reg [1:0] ped_NS,
    output reg [1:0] ped_EW

);

// Registers
reg [2:0] current_state;
reg [2:0] next_state;

integer state_timer;

// Initial Block
initial
begin
    current_state = `S0_NS_GREEN;
    next_state    = `S0_NS_GREEN;

    state_timer = 0;

    veh_NS = `GREEN;
    veh_EW = `RED;

    ped_NS = `DONT_WALK;
    ped_EW = `DONT_WALK;
end

// Current State Register
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        current_state <= `S0_NS_GREEN;
    else
        current_state <= next_state;
end

// Output Logic
always @(current_state)
begin

    case(current_state)

        `S0_NS_GREEN:
        begin
            veh_NS = `GREEN;
            veh_EW = `RED;

            
            ped_EW = `WALK;
           
            ped_NS = `DONT_WALK;
        end

        `S1_NS_YELLOW:
        begin
            veh_NS = `YELLOW;
            veh_EW = `RED;

          
            ped_EW = `BLINK;
            
            ped_NS = `DONT_WALK;
        end

        `S2_ALL_RED_1:
        begin
            veh_NS = `RED;
            veh_EW = `RED;
            
            ped_EW = `DONT_WALK;
            ped_NS = `DONT_WALK;
        end

        `S3_EW_GREEN:
        begin
            veh_NS = `RED;
            veh_EW = `GREEN;

            ped_NS = `WALK;
         
            ped_EW = `DONT_WALK;
        end

        `S4_EW_YELLOW:
        begin
            veh_NS = `RED;
            veh_EW = `YELLOW;

            ped_NS = `BLINK;
            ped_EW = `DONT_WALK;
        end

        `S5_ALL_RED_2:
        begin
            veh_NS = `RED;
            veh_EW = `RED;
 
           ped_NS = `DONT_WALK;
           ped_EW = `DONT_WALK;
        end

        default:
        begin
            veh_NS = `GREEN;
            veh_EW = `RED;

            ped_NS = `DONT_WALK;
            ped_EW = `DONT_WALK;
        end

    endcase

end
always @(*)
begin

    next_state = current_state;

    case(current_state)

        `S0_NS_GREEN:
        begin
            if(state_timer >= `T_GREEN)
                next_state = `S1_NS_YELLOW;
        end

        `S1_NS_YELLOW:
        begin
            if(state_timer >= `T_YELLOW)
                next_state = `S2_ALL_RED_1;
        end

        `S2_ALL_RED_1:
        begin
            if(state_timer >= `T_ALL_RED)
                next_state = `S3_EW_GREEN;
        end

        `S3_EW_GREEN:
        begin
            if(state_timer >= `T_GREEN)
                next_state = `S4_EW_YELLOW;
        end

        `S4_EW_YELLOW:
        begin
            if(state_timer >= `T_YELLOW)
                next_state = `S5_ALL_RED_2;
        end

        `S5_ALL_RED_2:
        begin
            if(state_timer >= `T_ALL_RED)
                next_state = `S0_NS_GREEN;
        end

        default:
            next_state = `S0_NS_GREEN;

    endcase

end

// State Timer
always @(posedge clk or negedge rst_n)
begin

    if(!rst_n)
        state_timer <= 0;

    else if(current_state != next_state)
        state_timer <= 0;

    else
        state_timer <= state_timer + 1;

end

endmodule
