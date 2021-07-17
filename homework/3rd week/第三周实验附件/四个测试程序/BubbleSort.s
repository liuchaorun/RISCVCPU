	.file	"BubbleSort.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0_f2p0_d2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	2
.LC1:
	.string	"the first element is %d.\n"
	.align	2
.LC0:
	.word	10
	.word	9
	.word	8
	.word	7
	.word	6
	.word	1
	.word	2
	.word	3
	.word	4
	.word	5
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-80
	sw	ra,76(sp)
	sw	s0,72(sp)
	addi	s0,sp,80
	li	a5,10
	sw	a5,-28(s0)
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	lw	t3,0(a5)
	lw	t1,4(a5)
	lw	a7,8(a5)
	lw	a6,12(a5)
	lw	a0,16(a5)
	lw	a1,20(a5)
	lw	a2,24(a5)
	lw	a3,28(a5)
	lw	a4,32(a5)
	lw	a5,36(a5)
	sw	t3,-72(s0)
	sw	t1,-68(s0)
	sw	a7,-64(s0)
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
	lw	a4,-56(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-56(a5)
	blt	a4,a5,.L4
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-56(a5)
	sw	a5,-32(s0)
	lw	a5,-24(s0)
	addi	a3,a5,1
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-56(a5)
	slli	a5,a3,2
	addi	a3,s0,-16
	add	a5,a3,a5
	sw	a4,-56(a5)
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a4,-32(s0)
	sw	a4,-56(a5)
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
	lw	a5,-72(s0)
	mv	a1,a5
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1)
	call	printf
	li	a5,0
	mv	a0,a5
	lw	ra,76(sp)
	lw	s0,72(sp)
	addi	sp,sp,80
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
