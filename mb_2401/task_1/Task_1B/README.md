# HC-SR04 Ultrasonic Sensor Controller

This directory contains the Verilog module for controlling an HC-SR04 ultrasonic distance sensor. Within the **MazeSolver Bot (MB)** project, this module is critical for obstacle detection, allowing the bot to perceive walls and navigate the maze.

**Team ID:** 2401

## Module Description

This module handles all the low-level timing and logic required to operate the HC-SR04 sensor. It generates the necessary trigger pulse to start a measurement, precisely measures the duration of the returning echo pulse, and calculates the distance to an object in millimeters. It also provides a simple binary `op` signal to indicate if an object is within a predefined threshold.

## File Structure

| Filename           | Description                                                                                          |
| :----------------- | :--------------------------------------------------------------------------------------------------- |
| `t1b_ultrasonic.v` | A self-contained module that implements the complete sensor controller using a Finite State Machine (FSM). |

## How It Works

The controller is designed as a Finite State Machine (FSM) that cycles through four main states to manage the measurement process. The entire cycle is designed to take approximately 12ms to ensure there is no interference between consecutive pings.



The states are:

1.  **`S_INIT_DELAY`:** A brief 1µs delay at the start of a cycle to allow the sensor's internal state to settle.

2.  **`S_TRIG_PULSE`:** The module drives the `trig` output pin HIGH for exactly 10µs. This pulse signals the HC-SR04 to emit an ultrasonic burst.

3.  **`S_MEASURE_ECHO`:** The module waits for the `echo_rx` pin to go HIGH.
    * Upon detecting a **rising edge** on `echo_rx`, it starts an internal counter (`echo_counter`).
    * The counter increments on every cycle of the 50MHz clock as long as `echo_rx` remains HIGH.
    * Upon detecting a **falling edge**, the counter stops. The final count represents the duration of the echo pulse.

4.  **`S_CYCLE_DELAY`:** A waiting state that ensures the total time for one measurement cycle is at least 12ms before looping back to `S_INIT_DELAY`. This also serves as a timeout period; if no echo is received, the module will eventually time out and restart.

### Distance Calculation

The distance is calculated in the `S_MEASURE_ECHO` state. The duration of the echo pulse (in clock cycles) is converted to millimeters using the speed of sound.

* **Time of flight** = `echo_counter` × `20ns` (the period of the 50MHz clock)
* **Distance to object** = (`Time of flight` × `Speed of Sound`) / 2
* **Formula in Verilog:** `distance_reg <= (echo_counter * 17) / 5000;`
    * This is a hardware-friendly integer approximation of the floating-point calculation `distance_mm = echo_counter * 0.0034`.

## Top-Level Interface (`t1b_ultrasonic`)

| Port           | Direction | Width   | Description                                                                                    |
| :------------- | :-------- | :------ | :--------------------------------------------------------------------------------------------- |
| `clk_50M`      | Input     | 1-bit   | The main 50MHz system clock.                                                                   |
| `reset`        | Input     | 1-bit   | Active-low asynchronous reset.                                                                 |
| `echo_rx`      | Input     | 1-bit   | Connects to the Echo pin of the HC-SR04 sensor.                                                |
| `trig`         | Output    | 1-bit   | Connects to the Trig pin of the HC-SR04 sensor.                                                |
| `op`           | Output    | 1-bit   | "Object Present" flag. HIGH if an object is detected within the `OBSTACLE_THRESHOLD` (70mm). |
| `distance_out` | Output    | 16-bit  | The calculated distance in millimeters.                                                        |

## Integration

To use this module, instantiate `t1b_ultrasonic`, provide the 50MHz clock and a reset signal. The `trig` and `echo_rx` ports should be connected to the corresponding physical pins on the FPGA that are wired to the sensor. The CPU can then read the `distance_out` and `op` registers to make navigational decisions.

## Authors

* Dibyendu Maity
* Ankit Dwibedi
* Sankalpa Basak
* Snehajit Paul
