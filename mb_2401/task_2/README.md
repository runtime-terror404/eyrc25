# MazeSolver Bot (MB) - Task 2: Sensing, Comms, & Navigation

Welcome to the Task 2 folder for Team 2401. Having successfully built our foundational hardware in Task 1 (our RISC-V CPU, PWM motor drivers, and Ultrasonic sensor), this task is where we develop the bot's core intelligence.

Here, we are designing the systems that allow our bot to sense its environment, communicate with the outside world, and autonomously navigate the maze. This task is divided into three key hardware modules, all built in Verilog.

## Task 2A: DHT11 Sensor Interface (Temperature & Humidity)

* **The Challenge:** To interface with the DHT11 sensor, which measures temperature and relative humidity.
* **Our Solution:** We are designing a robust Verilog module that implements the sensor's single-wire communication protocol. This involves creating a precise Finite State Machine (FSM) to handle the specific microsecond-level timing required to send a "start" signal, receive the 40-bit data stream, and validate the data using the provided checksum. 

## Task 2B: UART (Serial Communication)

* **The Challenge:** To enable reliable serial communication, a fundamental part of any complex robotic system.
* **Our Solution:** We are building both a UART Transmitter (Tx) and a UART Receiver (Rx) module from scratch in Verilog. These modules will manage parallel-to-serial and serial-to-parallel data conversion, handling the start, stop, and data bits. This hardware will be the foundation for our bot's wireless communication and debugging. 

## Task 2C: Maze Explorer (Navigation FSM)

* **The Challenge:** To create the autonomous navigation logic that allows our bot to intelligently solve the maze.
* **Our Solution:** We are designing a high-level FSM that acts as the bot's "pilot." This FSM will use inputs from our sensors (like the Ultrasonic sensor from Task 1) to detect walls (obstacles) and make decisions at intersections. This logic will implement our maze-solving algorithm, enabling the bot to explore and find its way through the maze.

## Directory Status

This directory contains the Verilog source code and corresponding Intel Quartus projects for each of these three sub-tasks.

## Team 2401

* Dibyendu Maity
* Ankit Dwibedi
* Sankalpa Basak
* Snehajit Paul
