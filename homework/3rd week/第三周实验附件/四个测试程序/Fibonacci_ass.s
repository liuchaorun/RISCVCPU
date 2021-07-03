main:
	addi 	a2,x0,6
	addi	a3,x0,0
	addi	a4,x0,1
	addi	a5,x0,2
	addi	a6,a2,0
	beq	a2,a4,.L1
	addi	a6,a4,0
	beq	a2,a5,.L1
.L0:
	add	a6,a3,a4
	bge	a2,a5,.L1
	addi	a5,a5,1
	addi	a3,a4,0
	addi	a4,a5,0
	j	.L0
.L1:
	sw	a6,0(x0)
	jr  ra
