# Traffic Light Controller — Verilog RTL

A synchronous four-way traffic light controller designed using
synthesizable Verilog RTL.

## Overview

This project implements an automatic traffic light controller for a
four-way intersection.

The controller uses a Finite State Machine (FSM) to control the
North-South and East-West traffic signals through timed states.

## Features

- FSM-based traffic light control
- North-South and East-West traffic control
- Automatic timed state transitions
- Synchronous state updates
- Clock-based timing using a counter
- Synthesizable Verilog RTL
- Simulation and verification using Icarus Verilog and GTKWave

## FSM Sequence

The controller follows this sequence:

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
