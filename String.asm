section .data
    my_string dw 0x1234, 0xABCD, 0x5678, 0x9ABC
    str_len equ ($ - my_string) / 2 ; Calculate the length of the string in words (16 bits)

section .text
    global _start

_start:
    mov ecx, str_len    ; Set the loop counter to the string length
    mov esi, my_string  ; Load the address of the string into the source index (SI) register

show_loop:
    mov ax, [esi]       ; Load the next 16-bit word from the memory location pointed by SI into AX
    ; Now, you can use AX to do whatever you want with the 16-bit data, such as printing it, processing it, etc.
    
    ; Example: Printing the 16-bit word in AX (assuming we have a function to print a 16-bit value)
    ; Replace this with the appropriate code for your platform.
    call print_16bit_value ; Call a function to print the 16-bit value in AX
    
    add esi, 2          ; Move to the next 16-bit word (increment SI by 2 bytes)
    loop show_loop      ; Repeat the loop until the counter (ECX) becomes zero
    
    ; Add code to terminate the program here or perform other operations as needed.
    ; For example, you can call an exit system call to terminate the program.
    
    ; Example: Terminate the program (assuming we have a function to exit the program)
    ; Replace this with the appropriate code for your platform.
    ; call exit_program ; Call a function to exit the program

; Add other functions (if any) here, such as a function to print a 16-bit value or exit the program.
