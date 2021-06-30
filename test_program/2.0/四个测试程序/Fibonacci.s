	.file	"Fibonacci.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0_f2p0_d2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	2
.LC0:
	.string	"The %d of fobonacci is\357\274\232%d.\n"
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	li	a5,5
	sw	a5,-36(s0)
	sw	zero,-20(s0)
	lw	a4,-36(s0)
	li	a5,1
	bne	a4,a5,.L2
	sw	zero,-20(s0)
	j	.L3
.L2:
	lw	a4,-36(s0)
	li	a5,2
	bne	a4,a5,.L4
	li	a5,1
	sw	a5,-20(s0)
	j	.L3
.L4:
	sw	zero,-24(s0)
	li	a5,1
	sw	a5,-28(s0)
	li	a5,3
	sw	a5,-32(s0)
	j	.L5
.L6:
	lw	a4,-24(s0)
	lw	a5,-28(s0)
	add	a5,a4,a5
	sw	a5,-20(s0)
	lw	a5,-28(s0)
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	sw	a5,-28(s0)
	lw	a5,-32(s0)
	addi	a5,a5,1
	sw	a5,-32(s0)
.L5:
	lw	a4,-32(s0)
	lw	a5,-36(s0)
	ble	a4,a5,.L6
.L3:
	lw	a2,-20(s0)
	lw	a1,-36(s0)
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	printf
	li	a5,0
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
