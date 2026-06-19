default rel

section .data
    ; Array of 10 student marks including all assignment boundary criteria
    marks db 45, 23, 78, 88, 39, 92, 40, 65, 0, 100
    array_len equ $ - marks

    ; Classification counters
    count_fail         db 0   ; Marks < 40 (0 to 39)
    count_pass         db 0   ; Marks 40 to 69
    count_credit       db 0   ; Marks 70 to 87
    count_distinction  db 0   ; Marks >= 88 (88 to 100)

    ; Text Labels
    lbl_total db "Total Sum:         ", 0
    lbl_avg   db 10, "Average Mark:      ", 0
    lbl_high  db 10, "Highest Mark:      ", 0
    lbl_low   db 10, "Lowest Mark:       ", 0
    lbl_fail  db 10, "Fail Count (<40):  ", 0
    lbl_pass  db 10, "Pass Count (40-69):", 0
    lbl_cred  db 10, "Credit Count(70-87):", 0
    lbl_dist  db 10, "Distinction (>=88):", 0
    lbl_nl    db 10, 0

section .bss
    total_sum    resw 1     
    average      resb 1
    highest      resb 1
    lowest       resb 1
    char_buffer  resb 4     

section .text
    global _start

_start:
    ; --- Addressing Mode 1: Indirect Addressing ---
    mov rbx, marks        ; Load base memory location address of array into RBX
    
    mov rcx, 0            ; Loop counter register (i = 0)
    mov ax, 0             ; Sum accumulator register

    mov byte [highest], 0
    mov byte [lowest], 100

.loop_start:
    cmp rcx, array_len    
    je .loop_end

    ; --- Addressing Mode 2: Based-Indexed Addressing ---
    mov dl, [rbx + rcx]   ; Base pointer (RBX) + Index Displacement (RCX)

    ; 1. Accumulate Sum
    movzx si, dl          
    add ax, si

    ; 2. Track Highest
    cmp dl, [highest]
    jle .check_lowest
    mov [highest], dl     

.check_lowest:
    ; 3. Track Lowest
    cmp dl, [lowest]
    jge .classify
    mov [lowest], dl      

.classify:
    ; 4. Dynamic Grading Classification
    cmp dl, 40            
    jl .is_fail
    cmp dl, 70            
    jl .is_pass
    cmp dl, 88            
    jl .is_credit
    jmp .is_distinction

.is_fail:
    inc byte [count_fail]
    jmp .next_iter
.is_pass:
    inc byte [count_pass]
    jmp .next_iter
.is_credit:
    inc byte [count_credit]
    jmp .next_iter
.is_distinction:
    inc byte [count_distinction]

.next_iter:
    inc rcx               
    jmp .loop_start

.loop_end:
    ; --- Addressing Mode 3: Direct Addressing ---
    mov [total_sum], ax   ; Save directly to fixed scalar variable address label

    ; Calculate Average
    mov dx, 0                 
    mov ax, [total_sum]
    mov si, array_len
    div si                
    mov [average], al

    ; --- Output Generation ---
    mov rsi, lbl_total
    call print_string
    movzx rax, word [total_sum]
    call print_number

    mov rsi, lbl_avg
    call print_string
    movzx rax, byte [average]
    call print_number

    mov rsi, lbl_high
    call print_string
    movzx rax, byte [highest]
    call print_number

    mov rsi, lbl_low
    call print_string
    movzx rax, byte [lowest]
    call print_number

    mov rsi, lbl_fail
    call print_string
    movzx rax, byte [count_fail]
    call print_number

    mov rsi, lbl_pass
    call print_string
    movzx rax, byte [count_pass]
    call print_number

    mov rsi, lbl_cred
    call print_string
    movzx rax, byte [count_credit]
    call print_number

    mov rsi, lbl_dist
    call print_string
    movzx rax, byte [count_distinction]
    call print_number

    mov rsi, lbl_nl
    call print_string

.exit_prog:
    mov rax, 60           
    mov rdi, 0
    syscall

; --- Helper String & Number Functions ---
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
    mov rax, 1            
    mov rdi, 1            
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
    mov rbx, 10           
    mov rcx, 0            
    mov rsi, char_buffer + 3 
    mov byte [rsi], 0     
.convert_loop:
    mov rdx, 0
    div rbx               
    add dl, '0'           
    dec rsi
    mov [rsi], dl
    inc rcx
    cmp rax, 0
    jne .convert_loop
    mov rax, 1            
    mov rdi, 1            
    mov rdx, rcx          
    syscall
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret