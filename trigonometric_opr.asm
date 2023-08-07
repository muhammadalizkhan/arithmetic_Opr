section .data
    input_msg db 'Enter the angle in degrees: ', 0
    output_msg db 'SIN: %lf', 0

section .bss
    angle resq 1   ; Reserve space for the angle (double-precision floating-point)

section .text
    global _start

_start:
    ; Display the message to enter the angle
    mov eax, 4
    mov ebx, 1
    mov ecx, input_msg
    mov edx, input_msg_len
    int 0x80

    ; Read the angle from the user
    mov eax, 3
    mov ebx, 0
    mov ecx, angle
    mov edx, 8   ; Double-precision floating-point takes 8 bytes
    int 0x80

    ; Calculate the SIN value
    fld qword [angle]   ; Load the angle (in radians) to the top of the FPU stack
    fsin                ; Calculate the SIN value

    ; Display the SIN value
    fstp qword [angle]  ; Store the SIN value back in 'angle' and pop it from the stack

    mov eax, 4
    mov ebx, 1
    mov ecx, output_msg
    mov edx, output_msg_len
    int 0x80

    mov eax, 1          ; Exit syscall
    xor ebx, ebx        ; Return 0 status (no error)
    int 0x80

section .data
    input_msg_len equ $ - input_msg
    output_msg_len equ $ - output_msg
