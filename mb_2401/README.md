# MazeSolver Bot (MB) - Team 2401

For the MazeSolver Bot (MB) challenge, our team is designing an intelligent, autonomous robot for smart agriculture. The goal is to build a bot from the ground up that can navigate a dynamic, warehouse-like maze while collecting crucial environmental data using an FPGA as its core.



Our bot will navigate a complex environment where paths can change, mimicking shifting stacks of produce in a real-world warehouse. As it solves the maze, it will gather data on temperature, humidity, and moisture. The entire system, from the processor to the peripheral controllers, is being designed by us in Verilog HDL.

## Our Solution: A Custom CPU-Powered System

Our solution is a complete System on a Chip (SoC) centered around our own **custom 32-bit RISC-V (RV32I) CPU**.

This CPU acts as the bot's "brain," running the firmware that executes our maze-solving algorithms and processes sensor data. We are developing a suite of custom hardware peripherals (for motors, sensors, etc.) that will interface directly with our CPU, allowing for high-performance, real-time operation.

## Project Status & Repository Structure

This repository is a work in progress, organized into the major functional blocks of our project.

* **`mazesolver_cpu/`**
    * **Status:** ✅ Complete and Tested
    * **Description:** Contains the full Intel Quartus project for our custom RISC-V CPU. This is the core of the bot and can be synthesized and simulated independently.

* **`peripherals/`**
    * **Status:** 🚧 In Progress
    * **Description:** Contains individual Verilog modules for the hardware our bot needs to function.
        * **Completed:** `pwm_generator/` for motor control and `ultrasonic_sensor/` for obstacle detection.
        * **Planned:** Interfaces for other sensors and wireless communication.

* **`firmware/`**
    * **Status:** 📝 Planned
    * **Description:** This directory will hold the RISC-V assembly code (our software) that the CPU will run to perform tasks like maze-solving and data collection.

* **`bot_top_level/`**
    * **Status:** 📝 Planned
    * **Description:** This will be the final Intel Quartus project that integrates the CPU, all peripherals, and firmware into a single system ready to be programmed onto the FPGA.

## The Heart of the Bot: Our Custom RV32I CPU

The most critical component of our design is the single-cycle RISC-V processor.

* **Architecture:** Single-Cycle, 32-bit
* **ISA:** RISC-V (RV32I)
* **Features:** Implements all base integer instructions (R, I, S, B, U, J types), including loads, stores, branches, and jumps.
* **Project:** Contained entirely within the `mazesolver_cpu/` directory.

> **For full design and implementation details, please see the [CPU's README file](eyrc25/blob/main/mb_2401/task_1/Task_1C/README.md).**

## Development Workflow

Our development process follows these steps:
1.  **Component Design:** Design and test each hardware module (CPU, peripherals) in its own Quartus project.
2.  **Firmware Development:** Write and assemble the RISC-V code that will control the bot.
3.  **System Integration:** Combine the tested CPU and peripherals into the final `bot_top_level` project, program it onto the FPGA, and test the complete system.

## Team Members

* Dibyendu Maity
* Ankit Dwibedi
* Sankalpa Basak
* Snehajit Paul
