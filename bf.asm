global _start

section .bss
buf resb 131072
stack resq 4096

section .data
name db "a.out",0

ehdr:
db 0x7f,"ELF",2,1,1,0
times 8 db 0
dw 2
dw 0x3e
dd 1
dq 0x400078
dq 64
dq 0
dd 0
dw 64
dw 56
dw 1
dw 0
dw 0
dw 0

phdr:
dd 1
dd 5
dq 0
dq 0x400000
dq 0x400000
dq 0
dq 0
dq 0x200000

section .text

_start:
mov rbx,rsp
mov rsi,[rbx+16]

mov eax,2
mov rdi,rsi
xor esi,esi
xor edx,edx
syscall
mov r12,rax

xor eax,eax
mov rdi,r12
mov rsi,buf
mov edx,131072
syscall
mov r13,rax

mov eax,3
mov rdi,r12
syscall

mov r14,buf
add r14,r13

mov byte [r14],0x48
mov byte [r14+1],0x89
mov byte [r14+2],0xe6
add r14,3

mov byte [r14],0xb8
mov dword [r14+1],1
add r14,5

mov byte [r14],0xbf
mov dword [r14+1],1
add r14,5

mov byte [r14],0xba
mov dword [r14+1],1
add r14,5

mov rbx,buf
lea r12,[buf+r13]
xor r11,r11

compile:
cmp rbx,r12
jge done
mov al,[rbx]

cmp al,'+'
je plus
cmp al,'-'
je minus
cmp al,'>'
je right
cmp al,'<'
je left
cmp al,'.'
je outc
cmp al,','
je inc
cmp al,'['
je lb
cmp al,']'
je rb

next:
inc rbx
jmp compile

plus:
mov byte [r14],0x80
mov byte [r14+1],0x06
mov byte [r14+2],1
add r14,3
jmp next

minus:
mov byte [r14],0x80
mov byte [r14+1],0x2e
mov byte [r14+2],1
add r14,3
jmp next

right:
mov byte [r14],0x48
mov byte [r14+1],0xff
mov byte [r14+2],0xc6
add r14,3
jmp next

left:
mov byte [r14],0x48
mov byte [r14+1],0xff
mov byte [r14+2],0xce
add r14,3
jmp next

outc:
mov byte [r14],0x0f
mov byte [r14+1],0x05
add r14,2
jmp next

inc:
xor eax,eax
xor edi,edi
mov byte [r14],0x0f
mov byte [r14+1],0x05
add r14,2
jmp next

lb:
mov byte [r14],0x80
mov byte [r14+1],0x3e
mov byte [r14+2],0
mov byte [r14+3],0x74
mov byte [r14+4],0
mov [stack+r11*8],r14
inc r11
add r14,5
jmp next

rb:
dec r11
mov rax,[stack+r11*8]

mov byte [r14],0x80
mov byte [r14+1],0x3e
mov byte [r14+2],0
mov byte [r14+3],0x75

mov rdx,rax
add rdx,5
sub rdx,r14
sub rdx,4
mov byte [r14+4],dl

add r14,5

mov rdx,r14
sub rdx,rax
sub rdx,5
mov byte [rax+4],dl
jmp next

done:

mov byte [r14],0xb8
mov dword [r14+1],60
mov byte [r14+5],0x31
mov byte [r14+6],0xff
mov byte [r14+7],0x0f
mov byte [r14+8],0x05
add r14,9

mov rbx,r14
sub rbx,buf
sub rbx,r13

mov rax,120
add rax,rbx
mov [phdr+32],rax
mov [phdr+40],rax

mov eax,2
mov rdi,name
mov esi,577
mov edx,0755
syscall
mov r12,rax

mov eax,1
mov rdi,r12
mov rsi,ehdr
mov edx,64
syscall

mov eax,1
mov rdi,r12
mov rsi,phdr
mov edx,56
syscall

mov eax,1
mov rdi,r12
mov rsi,buf
add rsi,r13
mov rdx,rbx
syscall

mov eax,3
mov rdi,r12
syscall

mov eax,60
xor edi,edi
syscall
