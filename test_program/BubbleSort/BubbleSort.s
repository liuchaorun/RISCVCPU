	.file	"BubbleSort.c"
	.option nopic
	.text
	.section	.rodata
	.align	2
.LC0:
	.word	10
	.word	5
	.word	7
	.word	3
	.word	4
	.word	2
	.word	1
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-64
	sw	s0,60(sp)
	addi	s0,sp,64
	li	a5,7
	sw	a5,-28(s0)
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	lw	a6,0(a5)
	lw	a0,4(a5)
	lw	a1,8(a5)
	lw	a2,12(a5)
	lw	a3,16(a5)
	lw	a4,20(a5)
	lw	a5,24(a5)
	sw	a6,-60(s0)
	sw	a0,-56(s0)
	sw	a1,-52(s0)
	sw	a2,-48(s0)
	sw	a3,-44(s0)
	sw	a4,-40(s0)
	sw	a5,-36(s0)
	sw	zero,-20(s0)
	j	.L2
.L6:
	lw	a5,-20(s0)
	sw	a5,-24(s0)
	j	.L3
.L5:
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-44(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-44(a5)
	bge	a4,a5,.L4
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-44(a5)
	sw	a5,-32(s0)
	lw	a5,-24(s0)
	addi	a3,a5,1
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-44(a5)
	slli	a5,a3,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-44(a5)
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-32(s0)
	sw	a4,-44(a5)
.L4:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L3:
	lw	a5,-28(s0)
	addi	a5,a5,-1
	lw	a4,-24(s0)
	blt	a4,a5,.L5
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L2:
	lw	a5,-28(s0)
	addi	a5,a5,-1
	lw	a4,-20(s0)
	blt	a4,a5,.L6
	li	a5,0
	mv	a0,a5
	lw	s0,60(sp)
	addi	sp,sp,64
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
	.section	.note.GNU-stack,"",@progbits
