# BIT 4220: Assembly Programming — Group Work Session 1

* **Course:** BIT 4220 Assembly Programming
* **Submission Date:** 21st June 2026
* **Group Size:** 5–8 Students
* **Platform Target:** Linux x86_64 (WSL2 / Ubuntu)
* **Assembler & Linker:** NASM (Netwide Assembler) & GNU Linker (`ld`)

---

## 📂 Project Directory Architecture
```text
group_work/
├── README.md                 <- This master documentation file
├── task1/
│   ├── task1.asm             <- Data representation toolkit source code
│   └── Makefile              <- Automated compilation script for Task 1
├── task2/
│   └── task2.asm             <- Prepaid utility meter ALU simulator source code
└── task3/
    └── task3.asm             <- Department marks processor source code

```

---

## 🛠️ Phase 1: System Environment Setup & Verification

To configure and verify the low-level build pipeline inside an Ubuntu/WSL2 terminal, execute the following configuration command:

```bash
sudo apt update && sudo apt install -y build-essential nasm gdb

```

This ensures that `nasm`, the standard GNU Linker (`ld`), and the GNU Debugger (`gdb`) are fully installed and configured on the host architecture.

---

## 📘 Task 1: Data Representation Toolkit

### 1. Conceptual Design Overview

This program serves as a low-level demonstration utility illustrating the three basic assembly sections (`.data`, `.bss`, and `.text`), memory storage boundaries (`db`, `dw`, `dd`), and **Little-Endian memory alignment** (where the least significant byte is stored at the lowest physical memory address).

### 2. Compilation & Build Execution

Navigate into the `task1` folder and invoke the automation `Makefile`:

```bash
cd task1
make
./task1

```

*(Expected Output: `BIT 4220: Assembly Toolkit Ready`)*

### 3. Little-Endian Memory Verification in GDB

To verify how multi-byte values are structurally organized across memory addresses, execute the binary within GDB:

```bash
gdb ./task1
(gdb) break _start
(gdb) run
(gdb) x/10xb &var_byte

```

**Physical Memory Layout Diagram (Observed in GDB Terminal):**

```text
Address           Label            Hex Byte Alignment            ASCII Representation
-------------------------------------------------------------------------------------
0x402000          <var_byte>       0x41                          'A'
0x402001          <var_word>       0x32  0x31                    '2', '1' (Stored as 0x3132)
0x402003          <var_dword>      0x37  0x36  0x35  0x34        '7', '6', '5', '4' (Stored as 0x34353637)

```

*Note: The byte sequence flips symmetrically in memory due to the processor's native Little-Endian hardware execution mapping.*

---

## 📟 Task 2: Prepaid Utility Meter ALU Simulator

### 1. Architectural Logic Flow

The utility meter ALU simulator acts as a menu-driven automation script. It reads keyboard inputs via Linux 64-bit software interrupts (`sys_read`), normalizes incoming ASCII inputs into mathematical values (subtracting `0x30`), executes specific ALU register flags mutations, and shifts integers back into ASCII format (adding `0x30`) prior to printing.

### 2. Compilation Commands

```bash
nasm -f elf64 task2/task2.asm -o task2/task2.o
ld task2/task2.o -o task2/task2
./task2/task2

```

### 3. CPU Flag Analysis Matrix

By observing flag changes under specific conditions using GDB (`info registers eflags`), we can document the following behavioral outcomes:

| # | Checked Operation | Input 1 | Input 2 | Computed Value | Zero Flag (ZF) | Sign Flag (SF) | Carry Flag (CF) | Real-world System Relevance |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `ADD` (Normal) | 5 | 3 | `0x08` (8) | 0 | 0 | 0 | **Top-up transaction:** Valid electricity credits updated. |
| 2 | `SUB` (Normal) | 8 | 2 | `0x06` (6) | 0 | 0 | 0 | **Deduct usage:** Normal grid consumption drop. |
| 3 | `SUB` (Zero State) | 4 | 4 | `0x00` (0) | **1** | 0 | 0 | **Zero Balance:** Balance empty; hardware trips breaker. |
| 4 | `SUB` (Underflow) | 3 | 7 | `0xFC` (-4) | 0 | **1** | **1** | **Negative Credit:** Emergency overdraft safety alarm tripped. |
| 5 | `AND` (Bitmask) | 5 | 4 | `0x04` | 0 | 0 | 0 | **Status Check:** Pinpoints if breaker status bit is live. |
| 6 | `XOR` (Toggle) | 1 | 1 | `0x00` | **1** | 0 | 0 | **Switch Actuator:** Changes state from open to closed. |

### 4. Technical Analysis: Why Register Overflow Matters

In embedded grid software components, unmonitored mathematical overflow or underflow poses severe operational and security risks.

If subtraction routines deduct consumption from a user balance without asserting the **Carry Flag (CF)** or **Sign Flag (SF)**, a negative transaction balance wraps directly around to the maximum capacity of the storage register (e.g., `-1` becoming `255` in an 8-bit space). This enables an exploitation vulnerability where users can secure infinite utility credits via malicious meter underflows. Validating hardware flags directly secures low-level architecture against memory exploitation and financial discrepancies.

---

## 📊 Task 3: Department Marks Processor

### 1. Addressing Modes Breakdown

This routine processes a sequential array of ten student assessment marks directly within the memory boundary layer using three specific addressing variations:

1. **Indirect Addressing (`mov rbx, marks`):** Loads the base absolute starting memory location pointer into a core register (`rbx`) to anchor array data operations.
2. **Based-Indexed Addressing (`mov dl, [rbx + rcx]`):** Iterates through data elements on the fly by combining the base pointer location (`rbx`) with a dynamic offset counter loop index (`rcx`).
3. **Direct Addressing (`mov [total_sum], ax`):** Instantly deposits fully calculated evaluation parameters from individual CPU accumulator registers into fixed, labeled global variables.

### 2. Compilation Commands

```bash
nasm -f elf64 task3/task3.asm -o task3/task3.o
ld task3/task3.o -o task3/task3
./task3/task3

```

### 3. Physical Array Memory Mapping Diagram

Below is the live structural map extracted using the GDB terminal inspect command `x/10xb &marks`:

```text
Memory Reference | Index Displacement | Hex Memory Offset | Raw Contents (Hex) | Stored Score (Base-10)
--------------------------------------------------------------------------------------------------------
marks + 0        | rbx + 0            | + 0x00            | 0x2D               | 45 (Pass)
marks + 1        | rbx + 1            | + 0x01            | 0x17               | 23 (Fail)
marks + 2        | rbx + 2            | + 0x02            | 0x4E               | 78 (Credit)
marks + 3        | rbx + 3            | + 0x03            | 0x58               | 88 (Distinction)
marks + 4        | rbx + 4            | + 0x04            | 0x27               | 39 (Fail Limit)
marks + 5        | rbx + 5            | + 0x05            | 0x5C               | 92 (Distinction)
marks + 6        | rbx + 6            | + 0x06            | 0x28               | 40 (Pass Limit)
marks + 7        | rbx + 7            | + 0x07            | 0x41               | 65 (Pass)
marks + 8        | rbx + 8            | + 0x08            | 0x00               | 0  (Absolute Min)
marks + 9        | rbx + 9            | + 0x09            | 0x64               | 100(Absolute Max)

```

### 4. Boundary Testing Evaluations

* **`0` & `39` (Failing Criteria):** Evaluated against the threshold parameter value `40` via `cmp dl, 40`. Both integers prompt a Less Than conditional jump condition (`jl`), incrementing `count_fail`.
* **`40` & `69` (Passing Criteria):** Match equal-to or greater-than boundaries for passing metrics, failing the `< 40` loop trigger and successfully dropping into the `count_pass` counter tracking slot.
* **`70` & `100` (Credit & Distinction Boundaries):** Safely pass lower comparative parameters, routing to the highest terminal accumulation blocks based on strict evaluation checks.

**Final Expected Computational Results Layout:**

```text
Total Sum:          570
Average Mark:       57
Highest Mark:       100
Lowest Mark:        0
Fail Count (<40):   3
Pass Count (40-69): 3
Credit Count(70-87):2
Distinction (>=88): 2

```

---

## 📅 Maintenance & Verification Logs

* All source programs have been structurally verified inside individual execution branches.
* Version histories and screenshot assets are stored directly within the root repository.
* **Reminder:** Every student within this work unit must retrieve a copy of this repository package and individually perform an upload verification steps check onto the personal VIMS portal system layout before the official submission window closes!
