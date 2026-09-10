# Testbench

This directory contains the Verilog testbench used to verify the
Traffic Light Controller RTL.

The testbench provides the required clock and reset signals, runs the
design through multiple traffic light cycles, and generates a waveform
for functional verification.

## Purpose

The purpose of the testbench is to verify that the RTL behaves as
expected before any potential hardware implementation.

The testbench checks:

- Reset behavior
- FSM state progression
- Traffic light transitions
- State timing
- Repeated operation of the traffic light cycle

## Device Under Test

The Device Under Test (DUT) is the main Traffic Light Controller
module located in the `rtl/` directory.

The testbench connects to the DUT and drives its input signals.

The outputs from the DUT are observed during simulation.

## Test Sequence

The testbench performs the following basic sequence:

1. Generate the system clock.
2. Assert reset.
3. Release reset.
4. Allow the FSM to begin normal operation.
5. Observe the North-South traffic sequence.
6. Observe the transition to East-West traffic.
7. Observe the East-West traffic sequence.
8. Observe the return to North-South traffic.
9. Continue simulation long enough to verify repeated cycles.
10. Generate a VCD waveform file for analysis.

## Reset Testing

The testbench initially asserts the reset signal to place the controller
into its known starting state.

After a short period, reset is released and normal operation begins.

This verifies that the controller starts from the expected FSM state.


## Testbench File

### `traffic_light_tb.v`

This file contains the complete simulation environment for the Traffic
Light Controller.

It is not part of the synthesizable hardware design.

The testbench is used only for simulation and verification.

## Verification Philosophy

The testbench is designed to verify the behavior of the RTL rather than
implement any hardware itself.

The RTL describes the hardware, while the testbench provides stimulus
and observes the resulting behavior.

```text
          Testbench
              │
              │ Stimulus
              ▼
       ┌───────────────┐
       │      DUT      │
       │ Traffic Light │
       │  Controller   │
       └───────┬───────┘
               │
               │ Outputs
               ▼
          Testbench
               │
               ▼
            GTKWave
```

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave


- Randomized input testing
- Coverage measurements
- Additional corner-case testing
