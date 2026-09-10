# RTL Design

This directory contains the synthesizable Verilog RTL implementation of
the Traffic Light Controller.

The RTL describes the hardware required to automatically control traffic
signals at a four-way intersection.

## Design Overview

The controller uses a Finite State Machine (FSM) to control two traffic
directions:

- North-South (NS)
- East-West (EW)

The FSM progresses through a predefined sequence of traffic light states.
A clock-driven counter determines how long the controller remains in each
state.

```text
                    ┌──────────────────┐
                    │      Clock       │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  State Register  │
                    │ current_state    │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  Next-State      │
                    │     Logic        │
                    └────────┬─────────┘
                             │
                             ▼
                         Next State


                    ┌──────────────────┐
                    │   State Timer    │
                    │     Counter      │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │ Timing / State   │
                    │   Transition     │
                    └──────────────────┘

                    Current State
                          │
                          ▼
                   ┌───────────────┐
                   │ Output Logic  │
                   └───────┬───────┘
                           │
                 ┌─────────┴─────────┐
                 ▼                   ▼
          NS Traffic Lights    EW Traffic Lights
```

## RTL Components

The design is divided conceptually into the following hardware
components.

### 1. State Register

The state register stores the current FSM state.

It is implemented using clocked sequential logic and changes state on
the active clock edge.

The state register provides the current state to the next-state and
output logic.

### 2. Next-State Logic

The next-state logic determines the state that the controller should
enter after the current state has completed its required duration.

The logic is based on:

- Current FSM state
- State timer

The FSM follows a fixed sequence and continuously repeats.

### 3. State Timer

A counter is used to measure the number of clock cycles spent in the
current state.

The counter allows traffic light timing to be implemented using
synthesizable hardware logic rather than simulation-only delays.

When the required count is reached, the controller proceeds to the
next
FSM state.

### 4. Output Logic

The output logic decodes the current FSM state and generates the
corresponding traffic light outputs.

Each FSM state has a predefined output combination for the
North-South and East-West directions.

## FSM State Sequence

The controller operates using the following sequence:

```text
S0
 │
 ▼
NS GREEN / EW RED
 │
 ▼
S1
 │
 ▼
NS YELLOW / EW RED
 │
 ▼
S2
 │
 ▼
NS RED / EW RED
 │
 ▼
S3
 │
 ▼
NS RED / EW GREEN
 │
 ▼
S4
 │
 ▼
NS RED / EW YELLOW
 │
 ▼
S5
 │
 ▼
NS RED / EW RED
 │
 └──────────────────► S0
```

The cycle repeats automatically as long as the controller is operating.

## Sequential and Combinational Logic

The RTL separates hardware that stores information from hardware that
produces immediate logic results.

### Sequential Logic

Sequential logic is used for:

- Current FSM state
- State timer/counter

These elements depend on the clock and retain their values between
clock cycles.

### Combinational Logic

Combinational logic is used for:

- Next-state determination
- Traffic light output generation

These outputs depend on the current inputs and/or current FSM state.

This separation makes the RTL easier to understand and debug and also
helps avoid unintended storage elements during synthesis.

## Reset Behavior

The controller includes an active-low reset signal.

When reset is asserted, the FSM is returned to its initial state.

```text
rst_n = 0
```

The controller starts from the North-South GREEN state.

After reset is released:

```text
rst_n = 1
```

the normal traffic light sequence begins.

## Timing Implementation

The design uses clock cycles rather than Verilog simulation delays.

The basic timing behavior is:

```text
Clock Edge
    │
    ▼
Increment Timer
    │
    ▼
Has Required Time Been Reached?
    │
    ├── No ──► Remain in Current State
    │
    └── Yes ─► Move to Next State
```

The timing constants can be adjusted for simulation or hardware
implementation.

Smaller values can be used during simulation to observe the complete
FSM cycle quickly.

## Synthesizability

The RTL is written with hardware implementation in mind.

The design avoids simulation-only constructs for its core functionality
and uses clocked logic, combinational logic, registers, and counters
that can be synthesized into digital hardware.

The intended hardware implementation consists primarily of:

- Flip-flops for state storage
- Counter/register logic for timing
- Combinational logic for state transitions
- Combinational logic for output decoding

## File

### `traffic_light_controller.v`

Contains the main synthesizable Verilog RTL for the traffic light
controller.

The module implements the FSM, timing logic, reset behavior, and traffic
light outputs.

## Verification

The RTL is verified using the testbench located in the `tb/` directory.

The design is simulated using:

- Icarus Verilog
- GTKWave

The testbench checks the expected state transitions and corresponding
traffic light outputs.

## RTL Design Concepts Demonstrated

This implementation demonstrates:

- Finite State Machine design
- Sequential logic
- Combinational logic
- State registers
- Next-state logic
- Counters
- Clock-driven timing
- Reset logic
- Output decoding
- Synthesizable Verilog
- Hardware-oriented design

## Future RTL Improvements

Possible future RTL extensions include:

- Pedestrian crossing control
- Sensor-based traffic detection
- Emergency vehicle priority
- Configurable timing
- Night-mode operation
- Flashing warning states
- FPGA implementation
