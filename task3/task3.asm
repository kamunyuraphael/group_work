default rel

section .data
    ; Task 3.1 & 3.4: Define an array of 10 marks (including boundary test cases)
    marks db 45, 23, 78, 88, 39, 92, 40, 65, 0, 100
    array_len equ $ - marks

    ; Classification threshold counters
    fail_count   db 0       ; Marks < 40 (e.g., 0, 23, 39)
    pass_count   db 0       ; Marks >= 40 (e.g., 40, 45, 65, 78, 88, 92, 100)

    ; Text output headers
    lbl_total    db "Total Sum: ", 0
    lbl_avg      db 10, "Average Mark: ", 0
    lbl_high     db 10, "Highest Mark: ", 0
    lbl_low      db 10, "Lowest Mark: ", 0
    lbl_pass     db 10, "Pass Count: ", 0
    lbl_fail     db 10, "Fail Count: ", 0
    lbl_nl       db 10, 0

section .bss
    ; Allocating memory buffers for calculated metrics
    total_sum    resw 1     ; 16-bit space to prevent summation overflow
    average      resb 1
    highest      resb 1
    lowest       resb 1
    char_buffer  resb 4     ; Buffer used to convert numbers to ASCII string for printing

section .text
    global _start

_start:
    ; --- Mode 1: Indirect Addressing ---
    mov rbx, marks        
    
    mov rcx, 0            ; Loop index counter (i = 0)
    mov ax, 0             ; Accumulator for Total Sum

    ; Initialize Highest with minimum (0) and Lowest with max (100)
    mov byte [highest], 0
    mov byte [lowest], 100

.loop_start:
    cmp rcx, array_len    ; Check if index reached 10
    je .loop_end

    ; --- Mode 2: Based-Indexed Addressing ---
    mov dl, [rbx + rcx]   

    ; 1. Accumulate Total Sum
    movzx si, dl          
    add ax, si

    ; 2. Track Highest Mark
    cmp dl, [highest]
    jle .check_lowest
    mov [highest], dl     

.check_lowest:
    ; 3. Track Lowest Mark
    cmp dl, [lowest]
    jge .check_classification
    mov [lowest], dl      

.check_classification:
    ; 4. Check Classification (Pass/Fail)
    cmp dl, 40            
    jl .increment_fail
    inc byte [pass_count]
    jmp .next_iteration

.increment_fail:
    inc byte [fail_count]

.next_iteration:
    inc rcx               ; Move pointer forward by 1 byte
    jmp .loop_start

.loop_end:
    ; --- Mode 3: Direct Addressing ---
    mov [total_sum], ax   

    ; 5. Compute Average (Total Sum / Array Length)
    mov dx, 0                 
    mov ax, [total_sum]
    mov si, array_len
    div si                ; AX / 10 -> Quotient stored in AL
    mov [average], al

    ; --- 6. Visual Output Display Executions ---
    ; Print Total
    mov rsi, lbl_total
    call print_string
    movzx rax, word [total_sum]
    call print_number

    ; Print Average
    mov rsi, lbl_avg
    call print_string
    movzx rax, byte [average]
    call print_number

    ; Print Highest
    mov rsi, lbl_high
    call print_string
    movzx rax, byte [highest]
    call print_number

    ; Print Lowest
    mov rsi, lbl_low
    call print_string
    movzx rax, byte [lowest]
    call print_number

    ; Print Pass Count
    mov rsi, lbl_pass
    call print_string
    movzx rax, byte [pass_count]
    call print_number

    ; Print Fail Count
    mov rsi, lbl_fail
    call print_string
    movzx rax, byte [fail_count]
    call print_number

    ; Print trailing newline
    mov rsi, lbl_nl
    call print_string

.exit_prog:
    mov rax, 60           ; sys_exit system call
    mov rdi, 0
    syscall

; =====================================================================
; HELPER UTILITIES FOR STRING RENDERING
; =====================================================================
print_string:
    push rax
    push rdi
    push rdx
    mov rdx, 0
.count_loop:
    cmp byte [rsi + rdx], 0
    je .write_out
    inc rdx
    jmp .count_loop
.write_out:
    mov rax, 1            ; sys_write
    mov rdi, 1            ; stdout
    syscall
    pop rdx
    pop rdi
    pop rax
    ret

print_number:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    
    mov rbx, 10           ; Base 10 divisor
    mov rcx, 0            ; Digit counter
    mov rsi, char_buffer + 3 ; Start filling buffer backwards
    mov byte [rsi], 0     ; Null terminator

.convert_loop:
    mov rdx, 0
    div rbx               ; RAX / 10. Remainder in RDX
    add dl, '0'           ; Convert remainder digit to ASCII character
    dec rsi
    mov [rsi], dl
    inc rcx
    cmp rax, 0
    jne .convert_loop

    ; Print string starting from updated RSI pointer location
    mov rax, 1            ; sys_write
    mov rdi, 1            ; stdout
    mov rdx, rcx          ; Length of digits
    syscall

    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret