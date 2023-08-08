section .data
    prompt db "Enter a number: ", 0
    prime_format db "%d is a prime number.", 0
    not_prime_format db "%d is not a prime number.", 0

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

    ; Check if the number is prime
    mov eax, ebx        ; Load the number into eax
    mov ecx, 2          ; Start dividing by 2

.check_prime:
    cmp ecx, eax        ; Compare the divisor with the number
    jae .is_prime        ; If the divisor is greater than or equal to the number, it's prime

    mov edx, 0          ; Clear edx for division
    div ecx             ; Divide eax by ecx
    test edx, edx       ; Check if there's a remainder
    jz .not_prime       ; If remainder is zero, the number is not prime

    inc ecx             ; Increment the divisor
    jmp .check_prime    ; Repeat the loop

.is_prime:
    push ebx            ; Push the number onto the stack
    push prime_format
    call printf

    jmp .exit

.not_prime:
    push ebx            ; Push the number onto the stack
    push not_prime_format
    call printf

.exit:
    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

; printf function (same as previous code)
printf:
    ; ... (same as before)
