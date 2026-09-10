# Simulation & Waveforms

This directory contains the simulation results and waveform captures for the Traffic Light Controller.

## Simulation

The RTL was simulated using:

- **Icarus Verilog** — compilation and simulation
- **GTKWave** — waveform analysis

The testbench generates a VCD waveform file containing the clock, reset, FSM state, timer, and traffic light outputs.

## Waveform

The waveform was inspected to verify:

- Correct reset behavior
- FSM state transitions
- Traffic light sequencing
- State timing
- Repeated operation of the controller

### Expected Sequence

```text
NS GREEN → NS YELLOW → ALL RED
→ EW GREEN → EW YELLOW → ALL RED
→ NS GREEN
```

## Files

- `waveform.png` — GTKWave simulation screenshot
- `block_diagram.png` — RTL architecture diagram
