	.file	"Fibonacci.c"
	.option nopic
	.text
	.align	2
	.globl	ReFib
	.type	ReFib, @function
ReFib:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	sw	s1,20(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a4,-20(s0)
	li	a5,1
	bne	a4,a5,.L2
	li	a5,0
	j	.L3
.L2:
	lw	a4,-20(s0)
	li	a5,2
	bne	a4,a5,.L4
	li	a5,1
	j	.L3
.L4:
	lw	a5,-20(s0)
	addi	a5,a5,-1
	mv	a0,a5
	call	ReFib
	mv	s1,a0
	lw	a5,-20(s0)
	addi	a5,a5,-2
	mv	a0,a5
	call	ReFib
	mv	a5,a0
	add	a5,s1,a5
.L3:
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	addi	sp,sp,32
	jr	ra
	.size	ReFib, .-ReFib
	.align	2
	.globl	ItFib
	.type	ItFib, @function
ItFib:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	lw	a4,-36(s0)
	li	a5,1
	bne	a4,a5,.L6
	li	a5,0
	j	.L7
.L6:
	lw	a4,-36(s0)
	li	a5,2
	bne	a4,a5,.L8
	li	a5,1
	j	.L7
.L8:
	sw	zero,-20(s0)
	li	a5,1
	sw	a5,-24(s0)
	li	a5,3
	sw	a5,-28(s0)
	j	.L9
.L10:
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	add	a5,a4,a5
	sw	a5,-32(s0)
	lw	a5,-24(s0)
	sw	a5,-20(s0)
	lw	a5,-32(s0)
	sw	a5,-24(s0)
	lw	a5,-28(s0)
	addi	a5,a5,1
	sw	a5,-28(s0)
.L9:
	lw	a4,-28(s0)
	lw	a5,-36(s0)
	ble	a4,a5,.L10
	lw	a5,-32(s0)
.L7:
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	ItFib, .-ItFib
	.section	.rodata
	.align	2
.LC0:
	.string	"\357\274\210\351\200\222\345\275\222\357\274\211\347\254\254%d\344\270\252\346\226\220\346\263\242\351\202\243\345\245\221\346\225\260\344\270\272\357\274\232%d\n"
	.align	2
.LC1:
	.string	"\357\274\210\350\277\255\344\273\243\357\274\211\347\254\254%d\344\270\252\346\226\220\346\263\242\351\202\243\345\245\221\346\225\260\344\270\272\357\274\232%d\n"
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a5,5
	sw	a5,-20(s0)
	lw	a0,-20(s0)
	call	ReFib
	sw	a0,-24(s0)
	lw	a0,-20(s0)
	call	ItFib
	sw	a0,-28(s0)
	lw	a2,-24(s0)
	lw	a1,-20(s0)
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	printf
	lw	a2,-28(s0)
	lw	a1,-20(s0)
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	printf
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
	.section	.note.GNU-stack,"",@progbits
