# DHT11 Temperature & Humidity Sensor Controller

This directory contains the Verilog module used to interface with the **DHT11 temperature and humidity sensor**. Within the MazeSolver Bot (MB) project, this module is responsible for acquiring environmental data (temperature & humidity) which can be used for logging, monitoring, or adaptive decision-making.

**Team ID:** 2401

---

## Module Description

This module implements the complete communication protocol required to read data from the DHT11 sensor. It generates the start signal, waits for the sensor’s response, receives the 40-bit data frame, validates its checksum, and provides the parsed temperature and humidity values.

The design uses a **Finite State Machine (FSM)** and carefully tuned timing logic to meet the DHT11’s strict communication requirements at a **50MHz system clock**.

---

## File Structure

| Filename      | Description |
|---------------|-------------|
| `t2a_dht.v`   | Implements the full DHT11 controller using an optimized FSM and time-critical signal sequencing. |

---

## How It Works

The controller operates as a **9-state FSM**, following the DHT11 protocol exactly:

### State Overview

- **S_IDLE**  
  Begins the transaction by pulling the data line LOW.

- **S_REQ_LOW**  
  Holds the sensor line LOW for **18ms**, signaling the DHT11 to start a measurement.

- **S_REQ_HIGH**  
  Drives the line HIGH for **40μs** before releasing control.

- **S_RELEASE**  
  Waits for the DHT11 to pull the line LOW (sensor response).

- **S_RESP_LOW**  
  Waits for the line to go HIGH (80μs).

- **S_RESP_HIGH**  
  Waits for the line to fall again, indicating the start of data bits.

- **S_BIT_LOW**  
  Waits for the rising edge of each data bit.

- **S_BIT_HIGH**  
  Measures the **duration of the HIGH pulse**:
  - ~26μs → logic 0  
  - ~70μs → logic 1  
  The bit value is stored in a 40-bit buffer.

- **S_FINISH**  
  Validates checksum and updates the output registers.

The module reads **40 bits** in the format:

```
RH_int | RH_dec | T_int | T_dec | Checksum
```

---

## Timing & Decoding

### Start Signal Timing
- 18ms LOW  
- 40μs HIGH  
- Line released (high-Z)

### Data Bit Timing
Each bit consists of:
- 50μs LOW  
- Variable HIGH:  
  - ~26μs → **0**  
  - ~70μs → **1**

The module uses a high-resolution 12-bit counter to measure the HIGH width and classify the bit.

### Checksum
```
Checksum = RH_int + RH_dec + T_int + T_dec
```
Only if the received checksum matches, the output registers are updated and `data_valid` goes HIGH for one clock cycle.

---

## Top-Level Interface (`t2a_dht`)

| Port | Dir | Width | Description |
|------|-----|--------|-------------|
| **clk_50M** | Input | 1 | 50MHz system clock |
| **reset** | Input | 1 | Active-low asynchronous reset |
| **sensor** | Inout | 1 | Bidirectional DHT11 data line |
| **T_integral** | Output | 8 | Integer temperature value |
| **T_decimal** | Output | 8 | Decimal temperature value |
| **RH_integral** | Output | 8 | Integer humidity value |
| **RH_decimal** | Output | 8 | Decimal humidity value |
| **Checksum** | Output | 8 | Received checksum |
| **data_valid** | Output | 1 | Pulses HIGH when data is valid |

---

## Integration

To use this module:

1. Instantiate `t2a_dht`.
2. Connect `sensor` to a bidirectional pin tied to the DHT11.
3. Provide the 50MHz clock and a reset signal.
4. Monitor:
   - `T_integral`, `T_decimal`
   - `RH_integral`, `RH_decimal`
   - `data_valid` (valid data pulse)

The FSM handles all DHT11 timing automatically—no external timing is required.

---

## Authors

- Dibyendu Maity  
- Ankit Dwibedi  
- Sankalpa Basak  
- Snehajit Paul
