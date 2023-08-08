section .data
    prompt db "Enter your age: ", 0
    output_format db "You have lived for %d years, %d days, and %d minutes.", 0

section .bss
    age resb 10

section .text
    global _start

_start:
    ; Display prompt
    mov eax, 4          ; syscall number for sys_write
    mov ebx, 1          ; file descriptor 1 (stdout)
    mov ecx, prompt    ; address of the prompt string
    mov edx, 18         ; length of the prompt
    int 0x80            ; interrupt to invoke syscall

    ; Read user input
    mov eax, 3          ; syscall number for sys_read
    mov ebx, 0          ; file descriptor 0 (stdin)
    mov ecx, age       ; buffer to store user input
    mov edx, 10         ; maximum number of bytes to read
    int 0x80            ; interrupt to invoke syscall

    ; Convert string to integer
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    mov edi, age
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

    ; Calculate total days, years, and minutes
    ; Assuming average of 365.25 days per year
    ; And 24 hours, 60 minutes per day
    mov eax, ebx        ; age in years
    imul eax, 365       ; years * days_per_year
    imul edx, ebx, 365  ; years * days_per_year (for subtraction)
    idiv dword 4        ; leap year adjustment
    add eax, edx        ; total days
    imul edx, eax, 24   ; total days * hours_per_day
    imul ecx, edx, 60   ; total hours * minutes_per_hour

    ; Display output
    push ecx            ; minutes
    push edx            ; days
    push ebx            ; years
    push output_format
    call printf

    ; Exit program
    mov eax, 1          ; syscall number for sys_exit
    xor ebx, ebx        ; exit status 0
    int 0x80            ; interrupt to invoke syscall

; printf function
printf:
    ; Arguments: format string in [esp+4], %d arguments on stack
    pusha

    mov eax, 4          ; syscall number for sys_write
    mov ebx, 1          ; file descriptor 1 (stdout)

.print_loop:
    mov edx, 0          ; clear edx for digit counting
    mov ecx, esp        ; pointer to current argument
    mov eax, [ecx]      ; load argument value
    cmp eax, 0          ; check if argument is zero
    jz .print_digit

    ; Count digits in the number
    mov ebx, 10
.count_digits:
    inc edx
    xor edx, edx
    div ebx
    test eax, eax
    jnz .count_digits

.print_digit:
    mov eax, [ecx]
    add eax, '0'
    mov [esp - 4], al   ; overwrite the format specifier in the stack
    mov eax, 4          ; syscall number for sys_write
    mov ecx, esp
    mov edx, 1
    int 0x80

    add esp, 4          ; move to the next argument
    cmp dword [esp], 0  ; check if we've printed all arguments
    jnz .print_loop

    popa
    ret
