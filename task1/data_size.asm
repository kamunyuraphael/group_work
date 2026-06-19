; =====================================================================
; File: data_size.asm
; Purpose: Demonstrate Byte, Word, and Doubleword storage layouts
; =====================================================================

section .data
    ; Allocate precise sizes
    char_val   db 'A'                  ; 1 Byte (8-bit) - ASCII 65
    word_val   dw 0x4243               ; 1 Word (16-bit) -> Little-Endian: 43 42 ('CB')
    dword_val  dd 0x44454647           ; 1 Doubleword (32-bit) -> Little-Endian: 47 46 45 44 ('GFED')
    
    newline    db 10

section .text
    global _start

_start:
    ; Print Byte value ('A')
    mov rax, 1
    mov rdi, 1
    mov rsi, char_val
    mov rdx, 1
    syscall

    ; Print Word value interpreted directly from memory as character bytes ('CB')
    mov rax, 1
    mov rdi, 1
    mov rsi, word_val
    mov rdx, 2
    syscall

    ; Print Doubleword value interpreted from memory ('GFED')
    mov rax, 1
    mov rdi, 1
    mov rsi, dword_val
    mov rdx, 4
    syscall

    ; Print trailing newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Exit
    mov rax, 60
    mov rdi, 0
    syscall