# ARM1-8-bit-Multicycle-Processor
🔧 8-bit ARM1-inspired multicycle processor implementation featuring:

Complete Logisim circuit design

SystemVerilog simulation testbenches

Finite State Machine (FSM) controller design

Detailed documentation and design report

Implements ARM1 instruction subset in 8-bit architecture

This educational project demonstrates multicycle processor architecture, control unit design, and hardware implementation from logic gates to functional CPU simulation.

## Overview
An 8-bit implementation of the ARM1 processor architecture using multicycle execution. This project includes complete digital design from logic gates to functional simulation.

## Project Structure
├── Logisim_Circuit/ # Complete Logisim design files
├── SystemVerilog_Sim/ # SV testbenches and modules
├── FSM_Design/ # State machine diagrams & documentation
├── Documentation/ # Project report & specifications
└── README.md # This file

## Features
- 8-bit data path with ARM1-inspired instruction set
- Multicycle execution with 5-stage pipeline
- Complete control unit with FSM implementation
- Logisim simulation-ready circuit
- SystemVerilog verification testbenches

## Getting Started
1. **Logisim**: Open `.circ` files in Logisim Evolution
2. **Simulation**: Run SV testbenches with ModelSim/Questa
3. **Documentation**: Review PDF report for design details

## Design Components
- ALU with arithmetic/logical operations
- Register file (8x8-bit registers)
- Control Unit FSM (8 states)
- Memory interface unit
- Instruction decoder

## License
Educational Use - See LICENSE for details
