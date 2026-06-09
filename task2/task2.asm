section .data
	default rel
	; Visual Menu & Prompts
	menu db 10, "--- PEPAID METER ALU SIMULATOR ---", 10
	     db "1. ADD Units (Electricity Top-up)", 10
    	     db "2. SUB Usage (Deduct Consumption)", 10
	     db "3. AND Bitmask Status (Check Device Status Register)", 10
	     db "4. XOR Bitmask (Toggle Relay Swithces)", 10
  	     db "Enter choice: (1-4)", 0
	menu_len equ $ -menu

	prompt1 db "Enter First Digit (0-9): ", 0
	p1_len equ $ -prompt1
	prompt2 db "Enter Second Digit (0-9): ", 0
	p2_len equ $ -prompt2
	res_msg db "Operational Result: ", 0
	res_len equ $ -res_msg

section .bss
	; Allocating memory buffers for keyboard inputs
	num1 resb 2 ; Buffer for first char + newline
	num2 resb 2 ; Buffer for second char + newline
	choice resb 2
	result resb 2

section .text
	global _start

_start: 
	; --- 1. Display Menu ---
	mov rax, 1	; sys_write system call
	mov rdi, 1	; file descriptor stdout
	mov rsi, menu	; pointer to string memory
	mov rdx, menu_len	; size of string
	syscall

	; --- Read Choice ---
	mov rax, 0 ; sys_read sytem call
	mov rdi, 0 ; file descriptor stdin (keyboard)
	mov rsi, choice	; store input into buffer
	mov rdx, 2	; accept up to 2 bytes
	syscall

	; --- Prompt & Read Num1 ---
	mov rax, 1
	mov rdi, 1
	mov rsi, prompt1
	mov rdx, p1_len
	syscall

	mov rax, 0
	mov rdi, 0
	mov rsi, num1
	mov rdx, 2
	syscall
	
	; --- Prompt & Read Num2 ---
	mov rax, 1
	mov rdi, 1
	mov rsi, prompt2
	mov rdx, p2_len
	syscall

	mov rax, 0
	mov rdi, 0
	mov rsi, num2
	mov rdx, 2
	syscall

	; --- Data Normalization - Convert ASCII inputs to Integers ---
	mov al, [num1]
	sub al, '0'	; Convert ASCII char to raw mathematical number
	mov bl, [num2]
	sub bl, '0'	; Convert ASCII char to raw mathematical number
	
	; --- Evaluate Menu Selection ---
	mov cl, [choice]
	cmp cl, '1'
	je .do_add
	cmp cl, '2'
	je .do_sub
	cmp cl, '3'
	je .do_and
	cmp cl, '4'
	je .do_xor
	jmp .exit	; Safeguard validation fallback for invalid choices

.do_add: 
	add al, bl	; Perform arithmetic ADD
	jmp .print_res

.do_sub:
	sub al, bl	; Perform arithmetic SUB
	jmp .print_res

.do_and:
	and al, bl	; Perform logical bitwise AND
	jmp .print_res

.do_xor:
	xor al, bl
	jmp .print_res

.print_res:
	; --- Convert raw numerical value back to prinable ASCII ---
	add al, '0'	; Convert raw computation integer back to human-readable ASCII
	mov [result], al

	; Print text prefix
	mov rax, 1
	mov rdi, 1
	mov rsi, res_msg
	mov rdx, res_len
	syscall

	; Print calculated digit character
	mov rax, 1
	mov rdi, 1
	mov rsi, result
	mov rdx, 1
	syscall

.exit:
	; Terminate the process cleanly via sys_exit
	mov rax, 60
	mov rdi, 0
	syscall

