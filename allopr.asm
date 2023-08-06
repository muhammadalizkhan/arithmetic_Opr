section .data
    prompt db "Enter first number: ", 0
    prompt2 db "Enter second number: ", 0
    result_msg db "The results are: ", 0
    newline db 10, 0
    error_msg db "Error: Division by zero!", 0

section .bss
    num1 resb 5    ; space to store the first number (up to 5 digits)
    num2 resb 5    ; space to store the second number (up to 5 digits)
    sum resb 11    ; space to store the sum (up to 10 digits, including a possible sign and null terminator)
    diff resb 11   ; space to store the difference
    product resb 11 ; space to store the product
    quotient resb 11 ; space to store the quotient

section .text
    global _start

_start:
    ; Display prompt to enter the first number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 18
    int 0x80

    ; Read the first number from the user
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 5
    int 0x80

    ; Display prompt to enter the second number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, 19
    int 0x80

    ; Read the second number from the user
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 5
    int 0x80

    ; Convert the strings to integers
    call convert_to_integer   ; converts num1 to integer in EAX
    mov ebx, eax              ; store num1 in EBX
    call convert_to_integer   ; converts num2 to integer in EAX

    ; Perform addition
    add ebx, eax
    mov eax, ebx
    call convert_to_string
    ; Display the result
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 15
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, sum
    mov edx, 11
    int 0x80

    ; Perform subtraction
    mov ebx, eax    ; Save the result of addition in EBX for subtraction
    sub ebx, eax
    mov eax, ebx
    call convert_to_string
    ; Display the result
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 15
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, diff
    mov edx, 11
    int 0x80

    ; Perform multiplication
    imul ebx
    mov eax, ebx
    call convert_to_string
    ; Display the result
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 15
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, product
    mov edx, 11
    int 0x80

    ; Perform division
    cmp eax, 0      ; Check if the second number (divisor) is zero
    je division_by_zero

    xor edx, edx    ; Clear EDX for division
    div ebx         ; EDX:EAX / EBX, result in EAX, remainder in EDX
    mov eax, edx    ; Store the quotient in EAX

    call convert_to_string
    ; Display the result
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 15
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, quotient
    mov edx, 11
    int 0x80

    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80

division_by_zero:
    ; Display error message for division by zero
    mov eax, 4
    mov ebx, 1
    mov ecx, error_msg
    mov edx, 24
    int 0x80

    ; Exit the program with an error code
    mov eax, 1
    mov ebx, 1
    int 0x80

convert_to_integer:
    ; Input: ECX points to the string with the number to convert
    ; Output: EAX contains the integer value
    xor eax, eax       ; Clear EAX (accumulator)

.next_digit:
    movzx edx, byte [ecx] ; Load the next character from the string
    cmp dl, 0            ; Check if it's the null terminator
    je .done_conversion  ; If yes, conversion is done

    sub dl, '0'          ; Convert ASCII character to numeric value
    imul eax, eax, 10    ; Multiply the current value by 10
    add eax, edx         ; Add the new digit to the result
    inc ecx              ; Move to the next character in the string
    jmp .next_digit      ; Process the next digit

.done_conversion:
    ret

convert_to_string:
    ; Input: EAX contains the integer value
    ; Output: The corresponding result buffer (sum, diff, product, or quotient) contains the string representation of the number
    mov edi, eax        ; Point EDI to the integer value (in EAX)
    mov ebx, 10         ; Store 10 in EBX (used for division)
    mov ecx, 11         ; Set ECX to the maximum number of digits (including a sign and null terminator)
    add edi, 10         ; Move EDI to the end of the buffer

    mov byte [edi], 0   ; Null terminator at the end of the string

    ; Handle negative numbers
    test eax, eax
    jns .positive

    ; Negative number, add the minus sign
    mov byte [edi], '-'
    inc edi             ; Move EDI to the next position in the buffer
    neg eax             ; Negate the number to make it positive for processing

.positive:
.next_digit_string:
    dec edi             ; Move EDI to the next position in the buffer
    xor edx, edx        ; Clear EDX for division
    div ebx             ; Divide EAX by 10, result in EAX, remainder in EDX
    add dl, '0'         ; Convert remainder to ASCII
    mov [edi], dl       ; Store ASCII digit in the buffer
    loop .next_digit_string ; Repeat until all digits are processed

    ret
