section .data
    prompt_base db "Enter the base of the triangle: ", 0
    prompt_height db "Enter the height of the triangle: ", 0
    area_format db "The area of the triangle is: %f", 10, 0

section .bss
    base resq 1
    height resq 1
    area resq 1

section .text
    global _start

_start:
    ; Display prompt for base
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_base
    mov edx, 30
    int 0x80

    ; Read base from user input
    mov eax, 3
    mov ebx, 0
    mov ecx, base
    mov edx, 10
    int 0x80

    ; Convert string to floating-point number
    fild qword [base]

    ; Display prompt for height
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_height
    mov edx, 32
    int 0x80

    ; Read height from user input
    mov eax, 3
    mov ebx, 0
    mov ecx, height
    mov edx, 10
    int 0x80

    ; Convert string to floating-point number
    fild qword [height]

    ; Calculate area: 0.5 * base * height
    fdiv    ; ST(0) = height
    fild qword [base]
    fmul    ; ST(0) = base * height
    fld1    ; Push 1.0 onto the FPU stack
    fdiv    ; ST(0) = (base * height) / 2.0
    fstp qword [area] ; Store the result in the 'area' variable

    ; Display the area of the triangle
    push area
    push area_format
    call printf

    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

; printf function (same as previous code)
printf:
    ; ... (same as before)
