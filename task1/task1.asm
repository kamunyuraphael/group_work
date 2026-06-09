section .data 
	; Task 1: Hello World string layout
	msg db "BIT 4220: Low-Level Demo Toolkit", 10 
	msg_len equ $ - msg

	; Task 1: Endianness $ Data Size Variables
	var_byte db 0x41 	; 1 Byte (ASCII "A")
	var_word dw 0x3132 	; 2 Byte (Word) -> IN memory: 32 31 (ASCII '2', '1')
	var_dword dd 0x34353637 ; 4 Byte (Doubleword) -> In memory: 37 36 35 34

section .text
	global _start

_start: 
	; --- Print Message ---
	mov rax, 1 ; sys_write system call 
	mov rdi, 1 ; file descriptor stdout
	mov rsi, msg ; pointer to buffer
	mov rdx, msg_len ; byte count
	syscall
	
	; ---  Exit cleanly ---
	mov rax, 60 ; sys_exit system call
	mov rdi, 0 ; exit code 0
	syscall

