section .data
    input_msg db 'Enter the first number: ', 0
    input_msg_len equ $ - input_msg

    input_msg2 db 'Enter the second number: ', 0
    input_msg2_len equ $ - input_msg2

    output_msg db 'Result: ', 0
    output_msg_len equ $ - output_msg

    format db "%d", 0

section .bss
    num1 resd 1      ; Reserve space for the first input (32-bit integer)
    num2 resd 1      ; Reserve space for the second input (32-bit integer)
    result resd 1    ; Reserve space for the result (32-bit integer)

section .text
    global _start

_start:
    ; Display the message to enter the first number
    mov eax, 4
    mov ebx, 1
    mov ecx, input_msg
    mov edx, input_msg_len
    int 0x80

    ; Read the first number from the user
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 4
    int 0x80

    ; Display the message to enter the second number
    mov eax, 4
    mov ebx, 1
    mov ecx, input_msg2
    mov edx, input_msg2_len
    int 0x80

    ; Read the second number from the user
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 4
    int 0x80

    ; Perform arithmetic operations
    mov eax, [num1]
    add eax, [num2]   ; Addition
    mov [result], eax ; Store the result

    mov eax, [num1]
    sub eax, [num2]   ; Subtraction
    mov [result], eax ; Store the result

    mov eax, [num1]
    imul eax, [num2]  ; Multiplication
    mov [result], eax ; Store the result

    mov eax, [num1]
    cdq               ; Clear EDX to prepare for division
    idiv dword [num2] ; Division
    mov [result], eax ; Store the quotient

    ; Display the result
    mov eax, 4
    mov ebx, 1
    mov ecx, output_msg
    mov edx, output_msg_len
    int 0x80

    mov eax, [result]
    mov ebx, 1
    mov ecx, eax
    mov edx, 4
    mov esi, format
    call print_int

    ; Terminate the program
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_int:
    ; Function to print an integer in decimal format
    ; Input: eax - The integer to be printed
    ;        ebx - File descriptor (1 for stdout)
    ;        ecx - Buffer to store the formatted integer
    ;        edx - Number of bytes to write
    ;        esi - Format string for printing
    ; Output: Prints the integer to the standard output
    pusha
    push ecx
    push edx
    push esi

    mov eax, 0x4
    mov edx, ecx
    add edx, edx ; Multiply the buffer address by 2 to get the correct offset for 'format' string
    mov ecx, esi
    add ecx, edx ; Move the offset to the correct position in the 'format' string

    call printf

    pop esi
    pop edx
    pop ecx
    popa
    ret

printf:
    ; Custom implementation of printf to print the integer
    ; Input: eax - The integer to be printed
    ;        ebx - File descriptor (1 for stdout)
    ;        ecx - Format string for printing
    ; Output: Prints the formatted string to the standard output
    pusha
    push ebx
    push ecx

    mov eax, 0x4
    mov edx, ecx
    add edx, edx ; Multiply the buffer address by 2 to get the correct offset for 'format' string
    mov ecx, ebx
    add ecx, edx ; Move the offset to the correct position in the 'format' string

    int 0x80

    pop ecx
    pop ebx
    popa
    ret
