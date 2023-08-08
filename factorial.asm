section .data
    prompt db "Enter a number: ", 0
    result_format db "Factorial of %d is %d.", 0

section .bss
    num resb 10

section .text
    global _start

_start:
    ; Display prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 18
    int 0x80

    ; Read user input
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 10
    int 0x80

    ; Convert string to integer
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    mov edi, num
.next_digit:
    movzx eax, byte [edi + ecx]
    cmp eax, 0
    je .end_conversion
    sub eax, '0'
    imul ebx, ebx, 10
    add ebx, eax
    inc ecx
    jmp .next_digit
.end_conversion:

    ; Calculate factorial
    mov eax, ebx         ; Copy the number to eax (n)
    mov ecx, ebx         ; Copy the number to ecx (loop counter)
    dec ecx              ; Decrement the loop counter by 1

    mov edx, 1           ; Initialize the result (factorial) to 1

.loop:
    imul edx, edx, ecx   ; Multiply result by loop counter
    loop .loop

    ; Display result
    push ebx             ; Push the original number onto the stack
    push edx             ; Push the calculated factorial onto the stack
    push result_format
    call printf

    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

; printf function (same as previous code)
printf:
    ; ... (same as before)
