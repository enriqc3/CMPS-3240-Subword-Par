# Enrique Tapia
# CS3240 lab 7
# Dr. Albert Cruz
# Advanced subword parallelism with x86 assembly 
# language and the SSE instruction set

	.file	"myblas.c"
	.text
	.globl	faxpy
	.type	faxpy, @function
faxpy:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)		# n
	movss	%xmm0, -24(%rbp)	# a
	movq	%rsi, -32(%rbp)		# x
	movq	%rdx, -40(%rbp)		# y
	movq	%rcx, -48(%rbp)		# result
	movl	$0, -4(%rbp)		# i
	jmp	.L2
.L3:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	movups	%xmm0, %xmm1
	vbroadcastss	-24(%rbp), %xmm1 #broadcast a to xmm1

	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movups	(%rax), %xmm0
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	addss	%xmm1, %xmm0
	movups	%xmm0, (%rax)
	addl	$4, -4(%rbp)	# i = i + 4
.L2:
	movl	-4(%rbp), %eax	#i
	cmpl	-20(%rbp), %eax	#if i is less than a
	jl	.L3
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	faxpy, .-faxpy
	.ident	"GCC: (Debian 8.3.0-6) 8.3.0"
	.section	.note.GNU-stack,"",@progbits
