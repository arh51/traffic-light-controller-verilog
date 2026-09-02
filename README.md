# Traffic Light Controller using Verilog RTL

## Overview

This project implements a synchronous, automatic traffic light controller for a four-way intersection using Verilog HDL.

The controller manages traffic in two directions:

- North-South (NS)
- East-West (EW)

A Finite State Machine (FSM) is used to control the traffic lights. The controller automatically cycles through green, yellow, and red states using a clock-driven timer.

The design was created from scratch and verified through simulation using Icarus Verilog and GTKWave.

---

## Objectives

The main objectives of this project were:

- Understand RTL design using Verilog
- Implement a Finite State Machine (FSM)
- Understand sequential and combinational logic
- Implement clock-based timing using a counter
- Design state transition logic
- Implement output decoding
- Create a Verilog testbench
- Simulate and debug the design using waveforms

---

## Traffic Light Operation

The intersection is divided into two traffic directions:

### North-South Traffic

The North-South direction receives:

- GREEN
- YELLOW
- RED

### East-West Traffic

The East-West direction receives:

- GREEN
- YELLOW
- RED

Only one direction is allowed to have a GREEN signal at a time.

An ALL RED period is included between the two directions before the next direction receives the GREEN signal.

The controller continuously follows this sequence:

```text
NS GREEN
    ↓
NS YELLOW
    ↓
ALL RED
    ↓
EW GREEN
    ↓
EW YELLOW
    ↓
ALL RED
    ↓
NS GREEN
```

---

## Finite State Machine

The controller is implemented using six FSM states.

| State | North-South | East-West | Description |
|-------|-------------|-----------|-------------|
| S0 | GREEN | RED | NS traffic allowed |
| S1 | YELLOW | RED | NS transition |
| S2 | RED | RED | Transition period |
| S3 | RED | GREEN | EW traffic allowed |
| S4 | RED | YELLOW | EW transition |
| S5 | RED | RED | Transition period |

The FSM follows the sequence:

```text
S0_NS_GREEN
      ↓
S1_NS_YELLOW
      ↓
S2_ALL_RED_1
      ↓
S3_EW_GREEN
      ↓
S4_EW_YELLOW
      ↓
S5_ALL_RED_2
      ↓
S0_NS_GREEN
```

After reaching `S5_ALL_RED_2`, the controller returns to `S0_NS_GREEN` and the cycle repeats continuously.

---

## Architecture

The design consists of several main hardware blocks:

```text
                    ┌───────────────────┐
                    │       Clock       │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │  Current State    │
                    │     Register      │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │   Next-State      │
                    │      Logic        │
                    └─────────┬─────────┘
                              │
                              ▼
                         Next State


                    ┌───────────────────┐
                    │    State Timer     │
                    │      Counter       │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │ Timing / Transition│
                    │       Logic        │
                    └───────────────────┘


                 Current State
                      │
                      ▼
               ┌───────────────┐
               │ Output Logic  │
               └───────┬───────┘
                       │
              ┌────────┴────────┐
              ▼                 ▼
        NS Traffic Lights   EW Traffic Lights
```

### Main Components

#### 1. Current State Register

The current state register stores the present FSM state.

It is updated synchronously with the clock and represents the sequential portion of the FSM.

#### 2. Next-State Logic

The next-state logic determines which state the FSM should enter next based on the current state and the state timer.

#### 3. State Timer

A counter keeps track of how long the controller has remained in the current state.

When the required timing value is reached, the FSM transitions to the next state.

#### 4. Output Logic

The output logic decodes the current FSM state and generates the appropriate North-South and East-West traffic light signals.

---

## Timing

The controller uses a clock-driven counter for timing.

Instead of using simulation-only delays such as `#delay` or `repeat`, the design uses a hardware counter so that the timing mechanism can be represented using synthesizable RTL.

The basic operation is:

```text
Clock
  │
  ▼
State Timer
  │
  ├── Required time not reached
  │          │
  │          ▼
  │     Stay in current state
  │
  └── Required time reached
             │
             ▼
       Transition to next state
```

The timing values are defined using Verilog constants and can be modified depending on the desired simulation or hardware timing.

For simulation, smaller timing values can be used so that the complete traffic light cycle can be observed quickly.

---

## RTL Design

The design uses separate sequential and combinational logic.

### Sequential Logic

The current state and timer are updated on the clock edge.

This represents storage elements such as flip-flops and counters in hardware.

### Combinational Logic

The next-state logic determines the next FSM state.

The output logic determines the traffic light outputs based on the current FSM state.

This separation makes the design easier to understand, simulate, debug, and maintain.

---

## Reset

The controller uses an active-low reset signal.

When reset is asserted:

```text
rst_n = 0
```

the controller is initialized to the starting state:

```text
S0_NS_GREEN
```

When reset is released:

```text
rst_n = 1
```

the controller begins its normal traffic light sequence.

---

## Verification

The design was verified using a dedicated Verilog testbench.

The testbench provides:

- Clock generation
- Reset control
- Simulation control
- Waveform dumping

The design was simulated using:

- Icarus Verilog
- GTKWave

The waveform was inspected to verify the correct operation of the FSM and traffic light outputs.

### Verification Checks

The following behavior was verified:

1. The FSM starts in the correct state after reset.
2. North-South traffic receives GREEN during the NS phase.
3. North-South traffic changes from GREEN to YELLOW.
4. The controller enters an ALL RED state.
5. East-West traffic receives GREEN.
6. East-West traffic changes from GREEN to YELLOW.
7. The controller enters the second ALL RED state.
8. The controller returns to NS GREEN.
9. The cycle repeats continuously.
10. State transitions occur according to the timer.

---

## Simulation

The RTL and testbench were compiled using Icarus Verilog.

Example compilation command:

```text
iverilog -o traffic_sim traffic_light_controller.v traffic_light_tb.v
```

The compiled simulation was executed using:

```text
vvp traffic_sim
```

The simulation generates a VCD waveform file which can be opened using GTKWave:

```text
gtkwave traffic.vcd
```

---

## Waveform

The GTKWave simulation was used to observe:

- Clock
- Reset
- FSM state
- State timer
- North-South traffic output
- East-West traffic output

### Simulation Waveform

Add the GTKWave screenshot here.

Example:

```text
![Traffic Light Controller Waveform](docs/waveform.png)
```

---

## Project Structure

```text
traffic-light-controller-verilog/
│
├── rtl/
│   └── traffic_light_controller.v
│
├── tb/
│   └── traffic_light_tb.v
│
├── docs/
│   ├── waveform.png
│   └── block_diagram.png
│
└── README.md
```

### `rtl/`

Contains the synthesizable Verilog RTL design.

### `tb/`

Contains the Verilog testbench used for simulation and verification.

### `docs/`

Contains documentation such as the block diagram and GTKWave waveform screenshot.

### `README.md`

Contains the project documentation.

---

## Key RTL Concepts Demonstrated

This project provided practical experience with:

- Finite State Machines
- State registers
- Next-state logic
- Sequential logic
- Combinational logic
- Clock-driven counters
- Output decoding
- Active-low reset
- Synthesizable Verilog
- Verilog `case` statements
- Testbench development
- Simulation
- Waveform analysis
- RTL debugging
- Hardware-oriented design thinking

---

## Challenges and Lessons Learned

One of the main challenges during this project was understanding the difference between software programming and hardware description.

Unlike software such as C, Verilog is used to describe hardware. Different RTL blocks can operate concurrently rather than executing as a sequence of software instructions.

The traffic light controller helped demonstrate how different hardware blocks work together:

```text
             ┌─────────────────┐
             │  State Register │
             └────────┬────────┘
                      │
                      ▼
             ┌─────────────────┐
             │ Next-State Logic│
             └────────┬────────┘
                      │
                      ▼
                  Next State


State Timer ───────────────► Transition Logic

Current State ────────────► Output Logic
```

Another important lesson was understanding why hardware timing should be implemented using clock cycles and counters rather than simulation delays.

The project also provided practical experience in debugging RTL by observing signals in GTKWave and identifying incorrect state transitions and timing behavior.

---

## Future Improvements

The current design is an automatic traffic light controller.

Possible future improvements include:

- Pedestrian crossing requests
- Vehicle detection sensors
- Emergency vehicle priority
- Configurable traffic timings
- Night mode
- Flashing warning mode
- More advanced pedestrian signal control
- FPGA implementation

These features can be added as future versions while keeping the basic FSM architecture.

---

## Tools Used

| Tool | Purpose |
|------|---------|
| Verilog HDL | RTL design |
| Icarus Verilog | Compilation and simulation |
| GTKWave | Waveform analysis |
| Git | Version control |
| GitHub | Project hosting and documentation |

---

## Conclusion

This project was my first major RTL design project and provided practical experience in designing and verifying a synchronous digital system using Verilog.

The Traffic Light Controller demonstrates how an FSM, state register, timer, next-state logic, and output logic can work together to create an automatically operating hardware system.

The project helped build a foundation in RTL design, simulation, debugging, and hardware-oriented thinking, which will be used in future projects involving more complex digital systems.
