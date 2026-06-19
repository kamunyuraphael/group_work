; =====================================================================
; File: hello.asm
; Purpose: Task 1 - Low-level Demonstration Toolkit Hello World
; Target OS: Linux x86_64
; Assembler: NASM
; =====================================================================

section .data
    ; Define standard greeting string and calculate its length dynamically
    msg db "Hello, Assembly World! Welcome to the Low-Level Toolkit.", 10
    MSG_LEN equ $ - msg

section .text
    global _start

_start:
    ; 1. System Call: sys_write (rax = 1)
    mov rax, 1          ; syscall number for sys_write
    mov rdi, 1          ; file descriptor 1: stdout
    mov rsi, msg        ; pointer to the string in memory
    mov rdx, MSG_LEN    ; length of the string
    syscall             ; invoke the Linux kernel

    ; 2. System Call: sys_exit (rax = 60)
    mov rax, 60         ; syscall number for sys_exit
    mov rdi, 0          ; exit code 0 (success)
    syscall             ; invoke the Linux kernel