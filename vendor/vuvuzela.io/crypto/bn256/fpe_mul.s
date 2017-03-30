# File:   dclxvi-20130329/fpe_mul.s
# Author: Ruben Niederhagen, Peter Schwabe
# Public Domain


# qhasm: enter fpe_mul_qhasm
.text
.p2align 5
.globl _fpe_mul_qhasm
.globl fpe_mul_qhasm
_fpe_mul_qhasm:
fpe_mul_qhasm:
push %rbp
mov %rsp,%r11
and $31,%r11
add $192,%r11
sub %r11,%rsp

# qhasm: int64 rop

# qhasm: int64 op1

# qhasm: int64 op2

# qhasm: input rop

# qhasm: input op1

# qhasm: input op2

# qhasm: stack1536 mystack

# qhasm: int64 c1

# qhasm: int64 c2

# qhasm: int64 c3

# qhasm: int64 c4

# qhasm: int64 c5

# qhasm: int64 c6

# qhasm: int64 c7

# qhasm: caller c1

# qhasm: caller c2

# qhasm: caller c3

# qhasm: caller c4

# qhasm: caller c5

# qhasm: caller c6

# qhasm: caller c7

# qhasm: stack64 c1_stack

# qhasm: stack64 c2_stack

# qhasm: stack64 c3_stack

# qhasm: stack64 c4_stack

# qhasm: stack64 c5_stack

# qhasm: stack64 c6_stack

# qhasm: stack64 c7_stack

# qhasm: int6464 r0

# qhasm: int6464 r1

# qhasm: int6464 r2

# qhasm: int6464 r3

# qhasm: int6464 r4

# qhasm: int6464 r5

# qhasm: int6464 r6

# qhasm: int6464 r7

# qhasm: int6464 r8

# qhasm: int6464 r9

# qhasm: int6464 r10

# qhasm: int6464 r11

# qhasm: int6464 0yoff

# qhasm: int6464 0r0

# qhasm: int6464 0r1

# qhasm: int6464 0r2

# qhasm: int6464 0r3

# qhasm: int6464 0r4

# qhasm: int6464 0r5

# qhasm: int6464 0r6

# qhasm: int6464 0r7

# qhasm: int6464 0r8

# qhasm: int6464 0r9

# qhasm: int6464 0r10

# qhasm: int6464 0r11

# qhasm: int6464 0r12

# qhasm: int6464 0r13

# qhasm: int6464 0r14

# qhasm: int6464 0r15

# qhasm: int6464 0r16

# qhasm: int6464 0r17

# qhasm: int6464 0r18

# qhasm: int6464 0r19

# qhasm: int6464 0r20

# qhasm: int6464 0r21

# qhasm: int6464 0r22

# qhasm: int6464 0t0

# qhasm: int6464 0t1

# qhasm: int6464 0t2

# qhasm: int6464 0t3

# qhasm: int6464 0t4

# qhasm: int6464 0t5

# qhasm: int6464 0t6

# qhasm: int6464 0t7

# qhasm: int6464 0t8

# qhasm: int6464 0t9

# qhasm: int6464 0t10

# qhasm: int6464 0t11

# qhasm: int6464 0t12

# qhasm: int6464 0t13

# qhasm: int6464 0t14

# qhasm: int6464 0t15

# qhasm: int6464 0t16

# qhasm: int6464 0t17

# qhasm: int6464 0t18

# qhasm: int6464 0t19

# qhasm: int6464 0t20

# qhasm: int6464 0t21

# qhasm: int6464 0t22

# qhasm: int6464 0ab0

# qhasm: int6464 0ab1

# qhasm: int6464 0ab2

# qhasm: int6464 0ab3

# qhasm: int6464 0ab4

# qhasm: int6464 0ab5

# qhasm: int6464 0ab6

# qhasm: int6464 0ab7

# qhasm: int6464 0ab8

# qhasm: int6464 0ab9

# qhasm: int6464 0ab10

# qhasm: int6464 0ab11

# qhasm: int6464 0ab0six

# qhasm: int6464 0ab1six

# qhasm: int6464 0ab2six

# qhasm: int6464 0ab3six

# qhasm: int6464 0ab4six

# qhasm: int6464 0ab5six

# qhasm: int6464 0ab6six

# qhasm: int6464 0ab7six

# qhasm: int6464 0ab8six

# qhasm: int6464 0ab9six

# qhasm: int6464 0ab10six

# qhasm: int6464 0ab11six

# qhasm: int64 0mysp

# qhasm: 0mysp = &mystack
# asm 1: leaq <mystack=stack1536#1,>0mysp=int64#4
# asm 2: leaq <mystack=0(%rsp),>0mysp=%rcx
leaq 0(%rsp),%rcx

# qhasm: 0ab0[0] = *(float64 *)(op1 + 0)
# asm 1: movlpd 0(<op1=int64#2),>0ab0=int6464#1
# asm 2: movlpd 0(<op1=%rsi),>0ab0=%xmm0
movlpd 0(%rsi),%xmm0

# qhasm: 0t0 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t0=int6464#2
# asm 2: movdqa <0ab0=%xmm0,>0t0=%xmm1
movdqa %xmm0,%xmm1

# qhasm: float6464 0t0[0] *= *(float64 *)(op2 + 0)
# asm 1: mulsd 0(<op2=int64#3),<0t0=int6464#2
# asm 2: mulsd 0(<op2=%rdx),<0t0=%xmm1
mulsd 0(%rdx),%xmm1

# qhasm: 0r0 =0t0
# asm 1: movdqa <0t0=int6464#2,>0r0=int6464#2
# asm 2: movdqa <0t0=%xmm1,>0r0=%xmm1
movdqa %xmm1,%xmm1

# qhasm: 0t1 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t1=int6464#3
# asm 2: movdqa <0ab0=%xmm0,>0t1=%xmm2
movdqa %xmm0,%xmm2

# qhasm: float6464 0t1[0] *= *(float64 *)(op2 + 8)
# asm 1: mulsd 8(<op2=int64#3),<0t1=int6464#3
# asm 2: mulsd 8(<op2=%rdx),<0t1=%xmm2
mulsd 8(%rdx),%xmm2

# qhasm: 0r1 =0t1
# asm 1: movdqa <0t1=int6464#3,>0r1=int6464#3
# asm 2: movdqa <0t1=%xmm2,>0r1=%xmm2
movdqa %xmm2,%xmm2

# qhasm: 0t2 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t2=int6464#4
# asm 2: movdqa <0ab0=%xmm0,>0t2=%xmm3
movdqa %xmm0,%xmm3

# qhasm: float6464 0t2[0] *= *(float64 *)(op2 + 16)
# asm 1: mulsd 16(<op2=int64#3),<0t2=int6464#4
# asm 2: mulsd 16(<op2=%rdx),<0t2=%xmm3
mulsd 16(%rdx),%xmm3

# qhasm: 0r2 =0t2
# asm 1: movdqa <0t2=int6464#4,>0r2=int6464#4
# asm 2: movdqa <0t2=%xmm3,>0r2=%xmm3
movdqa %xmm3,%xmm3

# qhasm: 0t3 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t3=int6464#5
# asm 2: movdqa <0ab0=%xmm0,>0t3=%xmm4
movdqa %xmm0,%xmm4

# qhasm: float6464 0t3[0] *= *(float64  *)(op2 + 24)
# asm 1: mulsd 24(<op2=int64#3),<0t3=int6464#5
# asm 2: mulsd 24(<op2=%rdx),<0t3=%xmm4
mulsd 24(%rdx),%xmm4

# qhasm: 0r3 =0t3
# asm 1: movdqa <0t3=int6464#5,>0r3=int6464#5
# asm 2: movdqa <0t3=%xmm4,>0r3=%xmm4
movdqa %xmm4,%xmm4

# qhasm: 0t4 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t4=int6464#6
# asm 2: movdqa <0ab0=%xmm0,>0t4=%xmm5
movdqa %xmm0,%xmm5

# qhasm: float6464 0t4[0] *= *(float64  *)(op2 + 32)
# asm 1: mulsd 32(<op2=int64#3),<0t4=int6464#6
# asm 2: mulsd 32(<op2=%rdx),<0t4=%xmm5
mulsd 32(%rdx),%xmm5

# qhasm: 0r4 =0t4
# asm 1: movdqa <0t4=int6464#6,>0r4=int6464#6
# asm 2: movdqa <0t4=%xmm5,>0r4=%xmm5
movdqa %xmm5,%xmm5

# qhasm: 0t5 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t5=int6464#7
# asm 2: movdqa <0ab0=%xmm0,>0t5=%xmm6
movdqa %xmm0,%xmm6

# qhasm: float6464 0t5[0] *= *(float64 *)(op2 + 40)
# asm 1: mulsd 40(<op2=int64#3),<0t5=int6464#7
# asm 2: mulsd 40(<op2=%rdx),<0t5=%xmm6
mulsd 40(%rdx),%xmm6

# qhasm: 0r5 =0t5
# asm 1: movdqa <0t5=int6464#7,>0r5=int6464#7
# asm 2: movdqa <0t5=%xmm6,>0r5=%xmm6
movdqa %xmm6,%xmm6

# qhasm: 0t6 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t6=int6464#8
# asm 2: movdqa <0ab0=%xmm0,>0t6=%xmm7
movdqa %xmm0,%xmm7

# qhasm: float6464 0t6[0] *= *(float64 *)(op2 + 48)
# asm 1: mulsd 48(<op2=int64#3),<0t6=int6464#8
# asm 2: mulsd 48(<op2=%rdx),<0t6=%xmm7
mulsd 48(%rdx),%xmm7

# qhasm: 0r6 =0t6
# asm 1: movdqa <0t6=int6464#8,>0r6=int6464#8
# asm 2: movdqa <0t6=%xmm7,>0r6=%xmm7
movdqa %xmm7,%xmm7

# qhasm: 0t7 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t7=int6464#9
# asm 2: movdqa <0ab0=%xmm0,>0t7=%xmm8
movdqa %xmm0,%xmm8

# qhasm: float6464 0t7[0] *= *(float64 *)(op2 + 56)
# asm 1: mulsd 56(<op2=int64#3),<0t7=int6464#9
# asm 2: mulsd 56(<op2=%rdx),<0t7=%xmm8
mulsd 56(%rdx),%xmm8

# qhasm: 0r7 =0t7
# asm 1: movdqa <0t7=int6464#9,>0r7=int6464#9
# asm 2: movdqa <0t7=%xmm8,>0r7=%xmm8
movdqa %xmm8,%xmm8

# qhasm: 0t8 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t8=int6464#10
# asm 2: movdqa <0ab0=%xmm0,>0t8=%xmm9
movdqa %xmm0,%xmm9

# qhasm: float6464 0t8[0] *= *(float64 *)(op2 + 64)
# asm 1: mulsd 64(<op2=int64#3),<0t8=int6464#10
# asm 2: mulsd 64(<op2=%rdx),<0t8=%xmm9
mulsd 64(%rdx),%xmm9

# qhasm: 0r8 =0t8
# asm 1: movdqa <0t8=int6464#10,>0r8=int6464#10
# asm 2: movdqa <0t8=%xmm9,>0r8=%xmm9
movdqa %xmm9,%xmm9

# qhasm: 0t9 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t9=int6464#11
# asm 2: movdqa <0ab0=%xmm0,>0t9=%xmm10
movdqa %xmm0,%xmm10

# qhasm: float6464 0t9[0] *= *(float64 *)(op2 + 72)
# asm 1: mulsd 72(<op2=int64#3),<0t9=int6464#11
# asm 2: mulsd 72(<op2=%rdx),<0t9=%xmm10
mulsd 72(%rdx),%xmm10

# qhasm: 0r9 =0t9
# asm 1: movdqa <0t9=int6464#11,>0r9=int6464#11
# asm 2: movdqa <0t9=%xmm10,>0r9=%xmm10
movdqa %xmm10,%xmm10

# qhasm: 0t10 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t10=int6464#12
# asm 2: movdqa <0ab0=%xmm0,>0t10=%xmm11
movdqa %xmm0,%xmm11

# qhasm: float6464 0t10[0] *= *(float64 *)(op2 + 80)
# asm 1: mulsd 80(<op2=int64#3),<0t10=int6464#12
# asm 2: mulsd 80(<op2=%rdx),<0t10=%xmm11
mulsd 80(%rdx),%xmm11

# qhasm: 0r10 =0t10
# asm 1: movdqa <0t10=int6464#12,>0r10=int6464#12
# asm 2: movdqa <0t10=%xmm11,>0r10=%xmm11
movdqa %xmm11,%xmm11

# qhasm: 0t11 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t11=int6464#1
# asm 2: movdqa <0ab0=%xmm0,>0t11=%xmm0
movdqa %xmm0,%xmm0

# qhasm: float6464 0t11[0] *= *(float64 *)(op2 + 88)
# asm 1: mulsd 88(<op2=int64#3),<0t11=int6464#1
# asm 2: mulsd 88(<op2=%rdx),<0t11=%xmm0
mulsd 88(%rdx),%xmm0

# qhasm: 0r11 =0t11
# asm 1: movdqa <0t11=int6464#1,>0r11=int6464#1
# asm 2: movdqa <0t11=%xmm0,>0r11=%xmm0
movdqa %xmm0,%xmm0

# qhasm: *(float64 *)(0mysp + 0) = 0r0[0]
# asm 1: movlpd <0r0=int6464#2,0(<0mysp=int64#4)
# asm 2: movlpd <0r0=%xmm1,0(<0mysp=%rcx)
movlpd %xmm1,0(%rcx)

# qhasm: 0ab1[0] = *(float64 *)(op1 + 8)
# asm 1: movlpd 8(<op1=int64#2),>0ab1=int6464#2
# asm 2: movlpd 8(<op1=%rsi),>0ab1=%xmm1
movlpd 8(%rsi),%xmm1

# qhasm: 0ab1six = 0ab1
# asm 1: movdqa <0ab1=int6464#2,>0ab1six=int6464#13
# asm 2: movdqa <0ab1=%xmm1,>0ab1six=%xmm12
movdqa %xmm1,%xmm12

# qhasm: float6464 0ab1six[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0ab1six=int6464#13
# asm 2: mulsd SIX_SIX,<0ab1six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: 0t1 = 0ab1
# asm 1: movdqa <0ab1=int6464#2,>0t1=int6464#14
# asm 2: movdqa <0ab1=%xmm1,>0t1=%xmm13
movdqa %xmm1,%xmm13

# qhasm: float6464 0t1[0] *= *(float64 *)(op2 + 0)
# asm 1: mulsd 0(<op2=int64#3),<0t1=int6464#14
# asm 2: mulsd 0(<op2=%rdx),<0t1=%xmm13
mulsd 0(%rdx),%xmm13

# qhasm: float6464 0r1[0] +=0t1[0]
# asm 1: addsd <0t1=int6464#14,<0r1=int6464#3
# asm 2: addsd <0t1=%xmm13,<0r1=%xmm2
addsd %xmm13,%xmm2

# qhasm: 0t7 = 0ab1
# asm 1: movdqa <0ab1=int6464#2,>0t7=int6464#2
# asm 2: movdqa <0ab1=%xmm1,>0t7=%xmm1
movdqa %xmm1,%xmm1

# qhasm: float6464 0t7[0] *= *(float64 *)(op2 + 48)
# asm 1: mulsd 48(<op2=int64#3),<0t7=int6464#2
# asm 2: mulsd 48(<op2=%rdx),<0t7=%xmm1
mulsd 48(%rdx),%xmm1

# qhasm: float6464 0r7[0] +=0t7[0]
# asm 1: addsd <0t7=int6464#2,<0r7=int6464#9
# asm 2: addsd <0t7=%xmm1,<0r7=%xmm8
addsd %xmm1,%xmm8

# qhasm: 0t2 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t2=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t2=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t2[0] *= *(float64 *)(op2 + 8)
# asm 1: mulsd 8(<op2=int64#3),<0t2=int6464#2
# asm 2: mulsd 8(<op2=%rdx),<0t2=%xmm1
mulsd 8(%rdx),%xmm1

# qhasm: float6464 0r2[0] +=0t2[0]
# asm 1: addsd <0t2=int6464#2,<0r2=int6464#4
# asm 2: addsd <0t2=%xmm1,<0r2=%xmm3
addsd %xmm1,%xmm3

# qhasm: 0t3 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t3=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t3=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t3[0] *= *(float64 *)(op2 + 16)
# asm 1: mulsd 16(<op2=int64#3),<0t3=int6464#2
# asm 2: mulsd 16(<op2=%rdx),<0t3=%xmm1
mulsd 16(%rdx),%xmm1

# qhasm: float6464 0r3[0] +=0t3[0]
# asm 1: addsd <0t3=int6464#2,<0r3=int6464#5
# asm 2: addsd <0t3=%xmm1,<0r3=%xmm4
addsd %xmm1,%xmm4

# qhasm: 0t4 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t4=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t4=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t4[0] *= *(float64 *)(op2 + 24)
# asm 1: mulsd 24(<op2=int64#3),<0t4=int6464#2
# asm 2: mulsd 24(<op2=%rdx),<0t4=%xmm1
mulsd 24(%rdx),%xmm1

# qhasm: float6464 0r4[0] +=0t4[0]
# asm 1: addsd <0t4=int6464#2,<0r4=int6464#6
# asm 2: addsd <0t4=%xmm1,<0r4=%xmm5
addsd %xmm1,%xmm5

# qhasm: 0t5 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t5=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t5=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t5[0] *= *(float64 *)(op2 + 32)
# asm 1: mulsd 32(<op2=int64#3),<0t5=int6464#2
# asm 2: mulsd 32(<op2=%rdx),<0t5=%xmm1
mulsd 32(%rdx),%xmm1

# qhasm: float6464 0r5[0] +=0t5[0]
# asm 1: addsd <0t5=int6464#2,<0r5=int6464#7
# asm 2: addsd <0t5=%xmm1,<0r5=%xmm6
addsd %xmm1,%xmm6

# qhasm: 0t6 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t6=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t6=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t6[0] *= *(float64 *)(op2 + 40)
# asm 1: mulsd 40(<op2=int64#3),<0t6=int6464#2
# asm 2: mulsd 40(<op2=%rdx),<0t6=%xmm1
mulsd 40(%rdx),%xmm1

# qhasm: float6464 0r6[0] +=0t6[0]
# asm 1: addsd <0t6=int6464#2,<0r6=int6464#8
# asm 2: addsd <0t6=%xmm1,<0r6=%xmm7
addsd %xmm1,%xmm7

# qhasm: 0t8 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t8=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t8=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t8[0] *= *(float64 *)(op2 + 56)
# asm 1: mulsd 56(<op2=int64#3),<0t8=int6464#2
# asm 2: mulsd 56(<op2=%rdx),<0t8=%xmm1
mulsd 56(%rdx),%xmm1

# qhasm: float6464 0r8[0] +=0t8[0]
# asm 1: addsd <0t8=int6464#2,<0r8=int6464#10
# asm 2: addsd <0t8=%xmm1,<0r8=%xmm9
addsd %xmm1,%xmm9

# qhasm: 0t9 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t9=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t9=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t9[0] *= *(float64 *)(op2 + 64)
# asm 1: mulsd 64(<op2=int64#3),<0t9=int6464#2
# asm 2: mulsd 64(<op2=%rdx),<0t9=%xmm1
mulsd 64(%rdx),%xmm1

# qhasm: float6464 0r9[0] +=0t9[0]
# asm 1: addsd <0t9=int6464#2,<0r9=int6464#11
# asm 2: addsd <0t9=%xmm1,<0r9=%xmm10
addsd %xmm1,%xmm10

# qhasm: 0t10 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t10=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t10=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t10[0] *= *(float64 *)(op2 + 72)
# asm 1: mulsd 72(<op2=int64#3),<0t10=int6464#2
# asm 2: mulsd 72(<op2=%rdx),<0t10=%xmm1
mulsd 72(%rdx),%xmm1

# qhasm: float6464 0r10[0] +=0t10[0]
# asm 1: addsd <0t10=int6464#2,<0r10=int6464#12
# asm 2: addsd <0t10=%xmm1,<0r10=%xmm11
addsd %xmm1,%xmm11

# qhasm: 0t11 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t11=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t11=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t11[0] *= *(float64 *)(op2 + 80)
# asm 1: mulsd 80(<op2=int64#3),<0t11=int6464#2
# asm 2: mulsd 80(<op2=%rdx),<0t11=%xmm1
mulsd 80(%rdx),%xmm1

# qhasm: float6464 0r11[0] +=0t11[0]
# asm 1: addsd <0t11=int6464#2,<0r11=int6464#1
# asm 2: addsd <0t11=%xmm1,<0r11=%xmm0
addsd %xmm1,%xmm0

# qhasm: 0t12 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t12=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t12=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t12[0] *= *(float64 *)(op2 + 88)
# asm 1: mulsd 88(<op2=int64#3),<0t12=int6464#2
# asm 2: mulsd 88(<op2=%rdx),<0t12=%xmm1
mulsd 88(%rdx),%xmm1

# qhasm: 0r12 =0t12
# asm 1: movdqa <0t12=int6464#2,>0r12=int6464#2
# asm 2: movdqa <0t12=%xmm1,>0r12=%xmm1
movdqa %xmm1,%xmm1

# qhasm: *(float64 *)(0mysp + 8) = 0r1[0]
# asm 1: movlpd <0r1=int6464#3,8(<0mysp=int64#4)
# asm 2: movlpd <0r1=%xmm2,8(<0mysp=%rcx)
movlpd %xmm2,8(%rcx)

# qhasm: 0ab2[0] = *(float64 *)(op1 + 16)
# asm 1: movlpd 16(<op1=int64#2),>0ab2=int6464#3
# asm 2: movlpd 16(<op1=%rsi),>0ab2=%xmm2
movlpd 16(%rsi),%xmm2

# qhasm: 0ab2six = 0ab2
# asm 1: movdqa <0ab2=int6464#3,>0ab2six=int6464#13
# asm 2: movdqa <0ab2=%xmm2,>0ab2six=%xmm12
movdqa %xmm2,%xmm12

# qhasm: float6464 0ab2six[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0ab2six=int6464#13
# asm 2: mulsd SIX_SIX,<0ab2six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: 0t2 = 0ab2
# asm 1: movdqa <0ab2=int6464#3,>0t2=int6464#14
# asm 2: movdqa <0ab2=%xmm2,>0t2=%xmm13
movdqa %xmm2,%xmm13

# qhasm: float6464 0t2[0] *= *(float64 *)(op2 + 0)
# asm 1: mulsd 0(<op2=int64#3),<0t2=int6464#14
# asm 2: mulsd 0(<op2=%rdx),<0t2=%xmm13
mulsd 0(%rdx),%xmm13

# qhasm: float6464 0r2[0] +=0t2[0]
# asm 1: addsd <0t2=int6464#14,<0r2=int6464#4
# asm 2: addsd <0t2=%xmm13,<0r2=%xmm3
addsd %xmm13,%xmm3

# qhasm: 0t7 = 0ab2
# asm 1: movdqa <0ab2=int6464#3,>0t7=int6464#14
# asm 2: movdqa <0ab2=%xmm2,>0t7=%xmm13
movdqa %xmm2,%xmm13

# qhasm: float6464 0t7[0] *= *(float64 *)(op2 + 40)
# asm 1: mulsd 40(<op2=int64#3),<0t7=int6464#14
# asm 2: mulsd 40(<op2=%rdx),<0t7=%xmm13
mulsd 40(%rdx),%xmm13

# qhasm: float6464 0r7[0] +=0t7[0]
# asm 1: addsd <0t7=int6464#14,<0r7=int6464#9
# asm 2: addsd <0t7=%xmm13,<0r7=%xmm8
addsd %xmm13,%xmm8

# qhasm: 0t8 = 0ab2
# asm 1: movdqa <0ab2=int6464#3,>0t8=int6464#14
# asm 2: movdqa <0ab2=%xmm2,>0t8=%xmm13
movdqa %xmm2,%xmm13

# qhasm: float6464 0t8[0] *= *(float64 *)(op2 + 48)
# asm 1: mulsd 48(<op2=int64#3),<0t8=int6464#14
# asm 2: mulsd 48(<op2=%rdx),<0t8=%xmm13
mulsd 48(%rdx),%xmm13

# qhasm: float6464 0r8[0] +=0t8[0]
# asm 1: addsd <0t8=int6464#14,<0r8=int6464#10
# asm 2: addsd <0t8=%xmm13,<0r8=%xmm9
addsd %xmm13,%xmm9

# qhasm: 0t13 = 0ab2
# asm 1: movdqa <0ab2=int6464#3,>0t13=int6464#3
# asm 2: movdqa <0ab2=%xmm2,>0t13=%xmm2
movdqa %xmm2,%xmm2

# qhasm: float6464 0t13[0] *= *(float64 *)(op2 + 88)
# asm 1: mulsd 88(<op2=int64#3),<0t13=int6464#3
# asm 2: mulsd 88(<op2=%rdx),<0t13=%xmm2
mulsd 88(%rdx),%xmm2

# qhasm: 0r13 =0t13
# asm 1: movdqa <0t13=int6464#3,>0r13=int6464#3
# asm 2: movdqa <0t13=%xmm2,>0r13=%xmm2
movdqa %xmm2,%xmm2

# qhasm: 0t3 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t3=int6464#14
# asm 2: movdqa <0ab2six=%xmm12,>0t3=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t3[0] *= *(float64 *)(op2 + 8)
# asm 1: mulsd 8(<op2=int64#3),<0t3=int6464#14
# asm 2: mulsd 8(<op2=%rdx),<0t3=%xmm13
mulsd 8(%rdx),%xmm13

# qhasm: float6464 0r3[0] +=0t3[0]
# asm 1: addsd <0t3=int6464#14,<0r3=int6464#5
# asm 2: addsd <0t3=%xmm13,<0r3=%xmm4
addsd %xmm13,%xmm4

# qhasm: 0t4 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t4=int6464#14
# asm 2: movdqa <0ab2six=%xmm12,>0t4=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t4[0] *= *(float64 *)(op2 + 16)
# asm 1: mulsd 16(<op2=int64#3),<0t4=int6464#14
# asm 2: mulsd 16(<op2=%rdx),<0t4=%xmm13
mulsd 16(%rdx),%xmm13

# qhasm: float6464 0r4[0] +=0t4[0]
# asm 1: addsd <0t4=int6464#14,<0r4=int6464#6
# asm 2: addsd <0t4=%xmm13,<0r4=%xmm5
addsd %xmm13,%xmm5

# qhasm: 0t5 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t5=int6464#14
# asm 2: movdqa <0ab2six=%xmm12,>0t5=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t5[0] *= *(float64 *)(op2 + 24)
# asm 1: mulsd 24(<op2=int64#3),<0t5=int6464#14
# asm 2: mulsd 24(<op2=%rdx),<0t5=%xmm13
mulsd 24(%rdx),%xmm13

# qhasm: float6464 0r5[0] +=0t5[0]
# asm 1: addsd <0t5=int6464#14,<0r5=int6464#7
# asm 2: addsd <0t5=%xmm13,<0r5=%xmm6
addsd %xmm13,%xmm6

# qhasm: 0t6 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t6=int6464#14
# asm 2: movdqa <0ab2six=%xmm12,>0t6=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t6[0] *= *(float64 *)(op2 + 32)
# asm 1: mulsd 32(<op2=int64#3),<0t6=int6464#14
# asm 2: mulsd 32(<op2=%rdx),<0t6=%xmm13
mulsd 32(%rdx),%xmm13

# qhasm: float6464 0r6[0] +=0t6[0]
# asm 1: addsd <0t6=int6464#14,<0r6=int6464#8
# asm 2: addsd <0t6=%xmm13,<0r6=%xmm7
addsd %xmm13,%xmm7

# qhasm: 0t9 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t9=int6464#14
# asm 2: movdqa <0ab2six=%xmm12,>0t9=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t9[0] *= *(float64 *)(op2 + 56)
# asm 1: mulsd 56(<op2=int64#3),<0t9=int6464#14
# asm 2: mulsd 56(<op2=%rdx),<0t9=%xmm13
mulsd 56(%rdx),%xmm13

# qhasm: float6464 0r9[0] +=0t9[0]
# asm 1: addsd <0t9=int6464#14,<0r9=int6464#11
# asm 2: addsd <0t9=%xmm13,<0r9=%xmm10
addsd %xmm13,%xmm10

# qhasm: 0t10 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t10=int6464#14
# asm 2: movdqa <0ab2six=%xmm12,>0t10=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t10[0] *= *(float64 *)(op2 + 64)
# asm 1: mulsd 64(<op2=int64#3),<0t10=int6464#14
# asm 2: mulsd 64(<op2=%rdx),<0t10=%xmm13
mulsd 64(%rdx),%xmm13

# qhasm: float6464 0r10[0] +=0t10[0]
# asm 1: addsd <0t10=int6464#14,<0r10=int6464#12
# asm 2: addsd <0t10=%xmm13,<0r10=%xmm11
addsd %xmm13,%xmm11

# qhasm: 0t11 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t11=int6464#14
# asm 2: movdqa <0ab2six=%xmm12,>0t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t11[0] *= *(float64 *)(op2 + 72)
# asm 1: mulsd 72(<op2=int64#3),<0t11=int6464#14
# asm 2: mulsd 72(<op2=%rdx),<0t11=%xmm13
mulsd 72(%rdx),%xmm13

# qhasm: float6464 0r11[0] +=0t11[0]
# asm 1: addsd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addsd <0t11=%xmm13,<0r11=%xmm0
addsd %xmm13,%xmm0

# qhasm: 0t12 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t12=int6464#13
# asm 2: movdqa <0ab2six=%xmm12,>0t12=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 0t12[0] *= *(float64 *)(op2 + 80)
# asm 1: mulsd 80(<op2=int64#3),<0t12=int6464#13
# asm 2: mulsd 80(<op2=%rdx),<0t12=%xmm12
mulsd 80(%rdx),%xmm12

# qhasm: float6464 0r12[0] += 0t12[0]
# asm 1: addsd <0t12=int6464#13,<0r12=int6464#2
# asm 2: addsd <0t12=%xmm12,<0r12=%xmm1
addsd %xmm12,%xmm1

# qhasm: *(float64 *)(0mysp + 16) = 0r2[0]
# asm 1: movlpd <0r2=int6464#4,16(<0mysp=int64#4)
# asm 2: movlpd <0r2=%xmm3,16(<0mysp=%rcx)
movlpd %xmm3,16(%rcx)

# qhasm: 0ab3[0] = *(float64 *)(op1 + 24)
# asm 1: movlpd 24(<op1=int64#2),>0ab3=int6464#4
# asm 2: movlpd 24(<op1=%rsi),>0ab3=%xmm3
movlpd 24(%rsi),%xmm3

# qhasm: 0ab3six = 0ab3
# asm 1: movdqa <0ab3=int6464#4,>0ab3six=int6464#13
# asm 2: movdqa <0ab3=%xmm3,>0ab3six=%xmm12
movdqa %xmm3,%xmm12

# qhasm: float6464 0ab3six[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0ab3six=int6464#13
# asm 2: mulsd SIX_SIX,<0ab3six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: 0t3 = 0ab3
# asm 1: movdqa <0ab3=int6464#4,>0t3=int6464#14
# asm 2: movdqa <0ab3=%xmm3,>0t3=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 0t3[0] *= *(float64 *)(op2 + 0)
# asm 1: mulsd 0(<op2=int64#3),<0t3=int6464#14
# asm 2: mulsd 0(<op2=%rdx),<0t3=%xmm13
mulsd 0(%rdx),%xmm13

# qhasm: float6464 0r3[0] +=0t3[0]
# asm 1: addsd <0t3=int6464#14,<0r3=int6464#5
# asm 2: addsd <0t3=%xmm13,<0r3=%xmm4
addsd %xmm13,%xmm4

# qhasm: 0t7 = 0ab3
# asm 1: movdqa <0ab3=int6464#4,>0t7=int6464#14
# asm 2: movdqa <0ab3=%xmm3,>0t7=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 0t7[0] *= *(float64 *)(op2 + 32)
# asm 1: mulsd 32(<op2=int64#3),<0t7=int6464#14
# asm 2: mulsd 32(<op2=%rdx),<0t7=%xmm13
mulsd 32(%rdx),%xmm13

# qhasm: float6464 0r7[0] +=0t7[0]
# asm 1: addsd <0t7=int6464#14,<0r7=int6464#9
# asm 2: addsd <0t7=%xmm13,<0r7=%xmm8
addsd %xmm13,%xmm8

# qhasm: 0t8 = 0ab3
# asm 1: movdqa <0ab3=int6464#4,>0t8=int6464#14
# asm 2: movdqa <0ab3=%xmm3,>0t8=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 0t8[0] *= *(float64 *)(op2 + 40)
# asm 1: mulsd 40(<op2=int64#3),<0t8=int6464#14
# asm 2: mulsd 40(<op2=%rdx),<0t8=%xmm13
mulsd 40(%rdx),%xmm13

# qhasm: float6464 0r8[0] +=0t8[0]
# asm 1: addsd <0t8=int6464#14,<0r8=int6464#10
# asm 2: addsd <0t8=%xmm13,<0r8=%xmm9
addsd %xmm13,%xmm9

# qhasm: 0t9 = 0ab3
# asm 1: movdqa <0ab3=int6464#4,>0t9=int6464#14
# asm 2: movdqa <0ab3=%xmm3,>0t9=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 0t9[0] *= *(float64 *)(op2 + 48)
# asm 1: mulsd 48(<op2=int64#3),<0t9=int6464#14
# asm 2: mulsd 48(<op2=%rdx),<0t9=%xmm13
mulsd 48(%rdx),%xmm13

# qhasm: float6464 0r9[0] +=0t9[0]
# asm 1: addsd <0t9=int6464#14,<0r9=int6464#11
# asm 2: addsd <0t9=%xmm13,<0r9=%xmm10
addsd %xmm13,%xmm10

# qhasm: 0t13 = 0ab3
# asm 1: movdqa <0ab3=int6464#4,>0t13=int6464#14
# asm 2: movdqa <0ab3=%xmm3,>0t13=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 0t13[0] *= *(float64 *)(op2 + 80)
# asm 1: mulsd 80(<op2=int64#3),<0t13=int6464#14
# asm 2: mulsd 80(<op2=%rdx),<0t13=%xmm13
mulsd 80(%rdx),%xmm13

# qhasm: float6464 0r13[0] +=0t13[0]
# asm 1: addsd <0t13=int6464#14,<0r13=int6464#3
# asm 2: addsd <0t13=%xmm13,<0r13=%xmm2
addsd %xmm13,%xmm2

# qhasm: 0t14 = 0ab3
# asm 1: movdqa <0ab3=int6464#4,>0t14=int6464#4
# asm 2: movdqa <0ab3=%xmm3,>0t14=%xmm3
movdqa %xmm3,%xmm3

# qhasm: float6464 0t14[0] *= *(float64 *)(op2 + 88)
# asm 1: mulsd 88(<op2=int64#3),<0t14=int6464#4
# asm 2: mulsd 88(<op2=%rdx),<0t14=%xmm3
mulsd 88(%rdx),%xmm3

# qhasm: 0r14 =0t14
# asm 1: movdqa <0t14=int6464#4,>0r14=int6464#4
# asm 2: movdqa <0t14=%xmm3,>0r14=%xmm3
movdqa %xmm3,%xmm3

# qhasm: 0t4 = 0ab3six
# asm 1: movdqa <0ab3six=int6464#13,>0t4=int6464#14
# asm 2: movdqa <0ab3six=%xmm12,>0t4=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t4[0] *= *(float64 *)(op2 + 8)
# asm 1: mulsd 8(<op2=int64#3),<0t4=int6464#14
# asm 2: mulsd 8(<op2=%rdx),<0t4=%xmm13
mulsd 8(%rdx),%xmm13

# qhasm: float6464 0r4[0] +=0t4[0]
# asm 1: addsd <0t4=int6464#14,<0r4=int6464#6
# asm 2: addsd <0t4=%xmm13,<0r4=%xmm5
addsd %xmm13,%xmm5

# qhasm: 0t5 = 0ab3six
# asm 1: movdqa <0ab3six=int6464#13,>0t5=int6464#14
# asm 2: movdqa <0ab3six=%xmm12,>0t5=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t5[0] *= *(float64 *)(op2 + 16)
# asm 1: mulsd 16(<op2=int64#3),<0t5=int6464#14
# asm 2: mulsd 16(<op2=%rdx),<0t5=%xmm13
mulsd 16(%rdx),%xmm13

# qhasm: float6464 0r5[0] +=0t5[0]
# asm 1: addsd <0t5=int6464#14,<0r5=int6464#7
# asm 2: addsd <0t5=%xmm13,<0r5=%xmm6
addsd %xmm13,%xmm6

# qhasm: 0t6 = 0ab3six
# asm 1: movdqa <0ab3six=int6464#13,>0t6=int6464#14
# asm 2: movdqa <0ab3six=%xmm12,>0t6=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t6[0] *= *(float64 *)(op2 + 24)
# asm 1: mulsd 24(<op2=int64#3),<0t6=int6464#14
# asm 2: mulsd 24(<op2=%rdx),<0t6=%xmm13
mulsd 24(%rdx),%xmm13

# qhasm: float6464 0r6[0] +=0t6[0]
# asm 1: addsd <0t6=int6464#14,<0r6=int6464#8
# asm 2: addsd <0t6=%xmm13,<0r6=%xmm7
addsd %xmm13,%xmm7

# qhasm: 0t10 = 0ab3six
# asm 1: movdqa <0ab3six=int6464#13,>0t10=int6464#14
# asm 2: movdqa <0ab3six=%xmm12,>0t10=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t10[0] *= *(float64 *)(op2 + 56)
# asm 1: mulsd 56(<op2=int64#3),<0t10=int6464#14
# asm 2: mulsd 56(<op2=%rdx),<0t10=%xmm13
mulsd 56(%rdx),%xmm13

# qhasm: float6464 0r10[0] +=0t10[0]
# asm 1: addsd <0t10=int6464#14,<0r10=int6464#12
# asm 2: addsd <0t10=%xmm13,<0r10=%xmm11
addsd %xmm13,%xmm11

# qhasm: 0t11 = 0ab3six
# asm 1: movdqa <0ab3six=int6464#13,>0t11=int6464#14
# asm 2: movdqa <0ab3six=%xmm12,>0t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t11[0] *= *(float64 *)(op2 + 64)
# asm 1: mulsd 64(<op2=int64#3),<0t11=int6464#14
# asm 2: mulsd 64(<op2=%rdx),<0t11=%xmm13
mulsd 64(%rdx),%xmm13

# qhasm: float6464 0r11[0] +=0t11[0]
# asm 1: addsd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addsd <0t11=%xmm13,<0r11=%xmm0
addsd %xmm13,%xmm0

# qhasm: 0t12 = 0ab3six
# asm 1: movdqa <0ab3six=int6464#13,>0t12=int6464#13
# asm 2: movdqa <0ab3six=%xmm12,>0t12=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 0t12[0] *= *(float64 *)(op2 + 72)
# asm 1: mulsd 72(<op2=int64#3),<0t12=int6464#13
# asm 2: mulsd 72(<op2=%rdx),<0t12=%xmm12
mulsd 72(%rdx),%xmm12

# qhasm: float6464 0r12[0] +=0t12[0]
# asm 1: addsd <0t12=int6464#13,<0r12=int6464#2
# asm 2: addsd <0t12=%xmm12,<0r12=%xmm1
addsd %xmm12,%xmm1

# qhasm: *(float64 *)(0mysp + 24) = 0r3[0]
# asm 1: movlpd <0r3=int6464#5,24(<0mysp=int64#4)
# asm 2: movlpd <0r3=%xmm4,24(<0mysp=%rcx)
movlpd %xmm4,24(%rcx)

# qhasm: 0ab4[0] = *(float64 *)(op1 + 32)
# asm 1: movlpd 32(<op1=int64#2),>0ab4=int6464#5
# asm 2: movlpd 32(<op1=%rsi),>0ab4=%xmm4
movlpd 32(%rsi),%xmm4

# qhasm: 0ab4six = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0ab4six=int6464#13
# asm 2: movdqa <0ab4=%xmm4,>0ab4six=%xmm12
movdqa %xmm4,%xmm12

# qhasm: float6464 0ab4six[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0ab4six=int6464#13
# asm 2: mulsd SIX_SIX,<0ab4six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: 0t4 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0t4=int6464#14
# asm 2: movdqa <0ab4=%xmm4,>0t4=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0t4[0] *= *(float64 *)(op2 + 0)
# asm 1: mulsd 0(<op2=int64#3),<0t4=int6464#14
# asm 2: mulsd 0(<op2=%rdx),<0t4=%xmm13
mulsd 0(%rdx),%xmm13

# qhasm: float6464 0r4[0] +=0t4[0]
# asm 1: addsd <0t4=int6464#14,<0r4=int6464#6
# asm 2: addsd <0t4=%xmm13,<0r4=%xmm5
addsd %xmm13,%xmm5

# qhasm: 0t7 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0t7=int6464#14
# asm 2: movdqa <0ab4=%xmm4,>0t7=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0t7[0] *= *(float64 *)(op2 + 24)
# asm 1: mulsd 24(<op2=int64#3),<0t7=int6464#14
# asm 2: mulsd 24(<op2=%rdx),<0t7=%xmm13
mulsd 24(%rdx),%xmm13

# qhasm: float6464 0r7[0] +=0t7[0]
# asm 1: addsd <0t7=int6464#14,<0r7=int6464#9
# asm 2: addsd <0t7=%xmm13,<0r7=%xmm8
addsd %xmm13,%xmm8

# qhasm: 0t8 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0t8=int6464#14
# asm 2: movdqa <0ab4=%xmm4,>0t8=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0t8[0] *= *(float64 *)(op2 + 32)
# asm 1: mulsd 32(<op2=int64#3),<0t8=int6464#14
# asm 2: mulsd 32(<op2=%rdx),<0t8=%xmm13
mulsd 32(%rdx),%xmm13

# qhasm: float6464 0r8[0] +=0t8[0]
# asm 1: addsd <0t8=int6464#14,<0r8=int6464#10
# asm 2: addsd <0t8=%xmm13,<0r8=%xmm9
addsd %xmm13,%xmm9

# qhasm: 0t9 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0t9=int6464#14
# asm 2: movdqa <0ab4=%xmm4,>0t9=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0t9[0] *= *(float64 *)(op2 + 40)
# asm 1: mulsd 40(<op2=int64#3),<0t9=int6464#14
# asm 2: mulsd 40(<op2=%rdx),<0t9=%xmm13
mulsd 40(%rdx),%xmm13

# qhasm: float6464 0r9[0] +=0t9[0]
# asm 1: addsd <0t9=int6464#14,<0r9=int6464#11
# asm 2: addsd <0t9=%xmm13,<0r9=%xmm10
addsd %xmm13,%xmm10

# qhasm: 0t10 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0t10=int6464#14
# asm 2: movdqa <0ab4=%xmm4,>0t10=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0t10[0] *= *(float64 *)(op2 + 48)
# asm 1: mulsd 48(<op2=int64#3),<0t10=int6464#14
# asm 2: mulsd 48(<op2=%rdx),<0t10=%xmm13
mulsd 48(%rdx),%xmm13

# qhasm: float6464 0r10[0] +=0t10[0]
# asm 1: addsd <0t10=int6464#14,<0r10=int6464#12
# asm 2: addsd <0t10=%xmm13,<0r10=%xmm11
addsd %xmm13,%xmm11

# qhasm: 0t13 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0t13=int6464#14
# asm 2: movdqa <0ab4=%xmm4,>0t13=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0t13[0] *= *(float64 *)(op2 + 72)
# asm 1: mulsd 72(<op2=int64#3),<0t13=int6464#14
# asm 2: mulsd 72(<op2=%rdx),<0t13=%xmm13
mulsd 72(%rdx),%xmm13

# qhasm: float6464 0r13[0] +=0t13[0]
# asm 1: addsd <0t13=int6464#14,<0r13=int6464#3
# asm 2: addsd <0t13=%xmm13,<0r13=%xmm2
addsd %xmm13,%xmm2

# qhasm: 0t14 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0t14=int6464#14
# asm 2: movdqa <0ab4=%xmm4,>0t14=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0t14[0] *= *(float64 *)(op2 + 80)
# asm 1: mulsd 80(<op2=int64#3),<0t14=int6464#14
# asm 2: mulsd 80(<op2=%rdx),<0t14=%xmm13
mulsd 80(%rdx),%xmm13

# qhasm: float6464 0r14[0] +=0t14[0]
# asm 1: addsd <0t14=int6464#14,<0r14=int6464#4
# asm 2: addsd <0t14=%xmm13,<0r14=%xmm3
addsd %xmm13,%xmm3

# qhasm: 0t15 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0t15=int6464#5
# asm 2: movdqa <0ab4=%xmm4,>0t15=%xmm4
movdqa %xmm4,%xmm4

# qhasm: float6464 0t15[0] *= *(float64 *)(op2 + 88)
# asm 1: mulsd 88(<op2=int64#3),<0t15=int6464#5
# asm 2: mulsd 88(<op2=%rdx),<0t15=%xmm4
mulsd 88(%rdx),%xmm4

# qhasm: 0r15 =0t15
# asm 1: movdqa <0t15=int6464#5,>0r15=int6464#5
# asm 2: movdqa <0t15=%xmm4,>0r15=%xmm4
movdqa %xmm4,%xmm4

# qhasm: 0t5 = 0ab4six
# asm 1: movdqa <0ab4six=int6464#13,>0t5=int6464#14
# asm 2: movdqa <0ab4six=%xmm12,>0t5=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t5[0] *= *(float64 *)(op2 + 8)
# asm 1: mulsd 8(<op2=int64#3),<0t5=int6464#14
# asm 2: mulsd 8(<op2=%rdx),<0t5=%xmm13
mulsd 8(%rdx),%xmm13

# qhasm: float6464 0r5[0] +=0t5[0]
# asm 1: addsd <0t5=int6464#14,<0r5=int6464#7
# asm 2: addsd <0t5=%xmm13,<0r5=%xmm6
addsd %xmm13,%xmm6

# qhasm: 0t6 = 0ab4six
# asm 1: movdqa <0ab4six=int6464#13,>0t6=int6464#14
# asm 2: movdqa <0ab4six=%xmm12,>0t6=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t6[0] *= *(float64 *)(op2 + 16)
# asm 1: mulsd 16(<op2=int64#3),<0t6=int6464#14
# asm 2: mulsd 16(<op2=%rdx),<0t6=%xmm13
mulsd 16(%rdx),%xmm13

# qhasm: float6464 0r6[0] +=0t6[0]
# asm 1: addsd <0t6=int6464#14,<0r6=int6464#8
# asm 2: addsd <0t6=%xmm13,<0r6=%xmm7
addsd %xmm13,%xmm7

# qhasm: 0t11 = 0ab4six
# asm 1: movdqa <0ab4six=int6464#13,>0t11=int6464#14
# asm 2: movdqa <0ab4six=%xmm12,>0t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t11[0] *= *(float64 *)(op2 + 56)
# asm 1: mulsd 56(<op2=int64#3),<0t11=int6464#14
# asm 2: mulsd 56(<op2=%rdx),<0t11=%xmm13
mulsd 56(%rdx),%xmm13

# qhasm: float6464 0r11[0] +=0t11[0]
# asm 1: addsd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addsd <0t11=%xmm13,<0r11=%xmm0
addsd %xmm13,%xmm0

# qhasm: 0t12 = 0ab4six
# asm 1: movdqa <0ab4six=int6464#13,>0t12=int6464#13
# asm 2: movdqa <0ab4six=%xmm12,>0t12=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 0t12[0] *= *(float64 *)(op2 + 64)
# asm 1: mulsd 64(<op2=int64#3),<0t12=int6464#13
# asm 2: mulsd 64(<op2=%rdx),<0t12=%xmm12
mulsd 64(%rdx),%xmm12

# qhasm: float6464 0r12[0] +=0t12[0]
# asm 1: addsd <0t12=int6464#13,<0r12=int6464#2
# asm 2: addsd <0t12=%xmm12,<0r12=%xmm1
addsd %xmm12,%xmm1

# qhasm: *(float64 *)(0mysp + 32) = 0r4[0]
# asm 1: movlpd <0r4=int6464#6,32(<0mysp=int64#4)
# asm 2: movlpd <0r4=%xmm5,32(<0mysp=%rcx)
movlpd %xmm5,32(%rcx)

# qhasm: 0ab5[0] = *(float64 *)(op1 + 40)
# asm 1: movlpd 40(<op1=int64#2),>0ab5=int6464#6
# asm 2: movlpd 40(<op1=%rsi),>0ab5=%xmm5
movlpd 40(%rsi),%xmm5

# qhasm: 0ab5six = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0ab5six=int6464#13
# asm 2: movdqa <0ab5=%xmm5,>0ab5six=%xmm12
movdqa %xmm5,%xmm12

# qhasm: float6464 0ab5six[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0ab5six=int6464#13
# asm 2: mulsd SIX_SIX,<0ab5six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: 0t5 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t5=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t5=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t5[0] *= *(float64 *)(op2 + 0)
# asm 1: mulsd 0(<op2=int64#3),<0t5=int6464#14
# asm 2: mulsd 0(<op2=%rdx),<0t5=%xmm13
mulsd 0(%rdx),%xmm13

# qhasm: float6464 0r5[0] +=0t5[0]
# asm 1: addsd <0t5=int6464#14,<0r5=int6464#7
# asm 2: addsd <0t5=%xmm13,<0r5=%xmm6
addsd %xmm13,%xmm6

# qhasm: 0t7 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t7=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t7=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t7[0] *= *(float64 *)(op2 + 16)
# asm 1: mulsd 16(<op2=int64#3),<0t7=int6464#14
# asm 2: mulsd 16(<op2=%rdx),<0t7=%xmm13
mulsd 16(%rdx),%xmm13

# qhasm: float6464 0r7[0] +=0t7[0]
# asm 1: addsd <0t7=int6464#14,<0r7=int6464#9
# asm 2: addsd <0t7=%xmm13,<0r7=%xmm8
addsd %xmm13,%xmm8

# qhasm: 0t8 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t8=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t8=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t8[0] *= *(float64 *)(op2 + 24)
# asm 1: mulsd 24(<op2=int64#3),<0t8=int6464#14
# asm 2: mulsd 24(<op2=%rdx),<0t8=%xmm13
mulsd 24(%rdx),%xmm13

# qhasm: float6464 0r8[0] +=0t8[0]
# asm 1: addsd <0t8=int6464#14,<0r8=int6464#10
# asm 2: addsd <0t8=%xmm13,<0r8=%xmm9
addsd %xmm13,%xmm9

# qhasm: 0t9 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t9=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t9=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t9[0] *= *(float64 *)(op2 + 32)
# asm 1: mulsd 32(<op2=int64#3),<0t9=int6464#14
# asm 2: mulsd 32(<op2=%rdx),<0t9=%xmm13
mulsd 32(%rdx),%xmm13

# qhasm: float6464 0r9[0] +=0t9[0]
# asm 1: addsd <0t9=int6464#14,<0r9=int6464#11
# asm 2: addsd <0t9=%xmm13,<0r9=%xmm10
addsd %xmm13,%xmm10

# qhasm: 0t10 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t10=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t10=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t10[0] *= *(float64 *)(op2 + 40)
# asm 1: mulsd 40(<op2=int64#3),<0t10=int6464#14
# asm 2: mulsd 40(<op2=%rdx),<0t10=%xmm13
mulsd 40(%rdx),%xmm13

# qhasm: float6464 0r10[0] +=0t10[0]
# asm 1: addsd <0t10=int6464#14,<0r10=int6464#12
# asm 2: addsd <0t10=%xmm13,<0r10=%xmm11
addsd %xmm13,%xmm11

# qhasm: 0t11 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t11=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t11=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t11[0] *= *(float64 *)(op2 + 48)
# asm 1: mulsd 48(<op2=int64#3),<0t11=int6464#14
# asm 2: mulsd 48(<op2=%rdx),<0t11=%xmm13
mulsd 48(%rdx),%xmm13

# qhasm: float6464 0r11[0] +=0t11[0]
# asm 1: addsd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addsd <0t11=%xmm13,<0r11=%xmm0
addsd %xmm13,%xmm0

# qhasm: 0t13 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t13=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t13=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t13[0] *= *(float64 *)(op2 + 64)
# asm 1: mulsd 64(<op2=int64#3),<0t13=int6464#14
# asm 2: mulsd 64(<op2=%rdx),<0t13=%xmm13
mulsd 64(%rdx),%xmm13

# qhasm: float6464 0r13[0] +=0t13[0]
# asm 1: addsd <0t13=int6464#14,<0r13=int6464#3
# asm 2: addsd <0t13=%xmm13,<0r13=%xmm2
addsd %xmm13,%xmm2

# qhasm: 0t14 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t14=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t14=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t14[0] *= *(float64 *)(op2 + 72)
# asm 1: mulsd 72(<op2=int64#3),<0t14=int6464#14
# asm 2: mulsd 72(<op2=%rdx),<0t14=%xmm13
mulsd 72(%rdx),%xmm13

# qhasm: float6464 0r14[0] +=0t14[0]
# asm 1: addsd <0t14=int6464#14,<0r14=int6464#4
# asm 2: addsd <0t14=%xmm13,<0r14=%xmm3
addsd %xmm13,%xmm3

# qhasm: 0t15 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t15=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t15=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t15[0] *= *(float64 *)(op2 + 80)
# asm 1: mulsd 80(<op2=int64#3),<0t15=int6464#14
# asm 2: mulsd 80(<op2=%rdx),<0t15=%xmm13
mulsd 80(%rdx),%xmm13

# qhasm: float6464 0r15[0] +=0t15[0]
# asm 1: addsd <0t15=int6464#14,<0r15=int6464#5
# asm 2: addsd <0t15=%xmm13,<0r15=%xmm4
addsd %xmm13,%xmm4

# qhasm: 0t16 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t16=int6464#6
# asm 2: movdqa <0ab5=%xmm5,>0t16=%xmm5
movdqa %xmm5,%xmm5

# qhasm: float6464 0t16[0] *= *(float64 *)(op2 + 88)
# asm 1: mulsd 88(<op2=int64#3),<0t16=int6464#6
# asm 2: mulsd 88(<op2=%rdx),<0t16=%xmm5
mulsd 88(%rdx),%xmm5

# qhasm: 0r16 =0t16
# asm 1: movdqa <0t16=int6464#6,>0r16=int6464#6
# asm 2: movdqa <0t16=%xmm5,>0r16=%xmm5
movdqa %xmm5,%xmm5

# qhasm: 0t6 = 0ab5six
# asm 1: movdqa <0ab5six=int6464#13,>0t6=int6464#14
# asm 2: movdqa <0ab5six=%xmm12,>0t6=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t6[0] *= *(float64 *)(op2 + 8)
# asm 1: mulsd 8(<op2=int64#3),<0t6=int6464#14
# asm 2: mulsd 8(<op2=%rdx),<0t6=%xmm13
mulsd 8(%rdx),%xmm13

# qhasm: float6464 0r6[0] +=0t6[0]
# asm 1: addsd <0t6=int6464#14,<0r6=int6464#8
# asm 2: addsd <0t6=%xmm13,<0r6=%xmm7
addsd %xmm13,%xmm7

# qhasm: 0t12 = 0ab5six
# asm 1: movdqa <0ab5six=int6464#13,>0t12=int6464#13
# asm 2: movdqa <0ab5six=%xmm12,>0t12=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 0t12[0] *= *(float64 *)(op2 + 56)
# asm 1: mulsd 56(<op2=int64#3),<0t12=int6464#13
# asm 2: mulsd 56(<op2=%rdx),<0t12=%xmm12
mulsd 56(%rdx),%xmm12

# qhasm: float6464 0r12[0] +=0t12[0]
# asm 1: addsd <0t12=int6464#13,<0r12=int6464#2
# asm 2: addsd <0t12=%xmm12,<0r12=%xmm1
addsd %xmm12,%xmm1

# qhasm: *(float64 *)(0mysp + 40) = 0r5[0]
# asm 1: movlpd <0r5=int6464#7,40(<0mysp=int64#4)
# asm 2: movlpd <0r5=%xmm6,40(<0mysp=%rcx)
movlpd %xmm6,40(%rcx)

# qhasm: 0ab6[0] = *(float64 *)(op1 + 48)
# asm 1: movlpd 48(<op1=int64#2),>0ab6=int6464#7
# asm 2: movlpd 48(<op1=%rsi),>0ab6=%xmm6
movlpd 48(%rsi),%xmm6

# qhasm: 0t6 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t6=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t6=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t6[0] *= *(float64 *)(op2 + 0)
# asm 1: mulsd 0(<op2=int64#3),<0t6=int6464#13
# asm 2: mulsd 0(<op2=%rdx),<0t6=%xmm12
mulsd 0(%rdx),%xmm12

# qhasm: float6464 0r6[0] +=0t6[0]
# asm 1: addsd <0t6=int6464#13,<0r6=int6464#8
# asm 2: addsd <0t6=%xmm12,<0r6=%xmm7
addsd %xmm12,%xmm7

# qhasm: 0t7 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t7=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t7=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t7[0] *= *(float64 *)(op2 + 8)
# asm 1: mulsd 8(<op2=int64#3),<0t7=int6464#13
# asm 2: mulsd 8(<op2=%rdx),<0t7=%xmm12
mulsd 8(%rdx),%xmm12

# qhasm: float6464 0r7[0] +=0t7[0]
# asm 1: addsd <0t7=int6464#13,<0r7=int6464#9
# asm 2: addsd <0t7=%xmm12,<0r7=%xmm8
addsd %xmm12,%xmm8

# qhasm: 0t8 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t8=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t8=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t8[0] *= *(float64 *)(op2 + 16)
# asm 1: mulsd 16(<op2=int64#3),<0t8=int6464#13
# asm 2: mulsd 16(<op2=%rdx),<0t8=%xmm12
mulsd 16(%rdx),%xmm12

# qhasm: float6464 0r8[0] +=0t8[0]
# asm 1: addsd <0t8=int6464#13,<0r8=int6464#10
# asm 2: addsd <0t8=%xmm12,<0r8=%xmm9
addsd %xmm12,%xmm9

# qhasm: 0t9 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t9=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t9=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t9[0] *= *(float64 *)(op2 + 24)
# asm 1: mulsd 24(<op2=int64#3),<0t9=int6464#13
# asm 2: mulsd 24(<op2=%rdx),<0t9=%xmm12
mulsd 24(%rdx),%xmm12

# qhasm: float6464 0r9[0] +=0t9[0]
# asm 1: addsd <0t9=int6464#13,<0r9=int6464#11
# asm 2: addsd <0t9=%xmm12,<0r9=%xmm10
addsd %xmm12,%xmm10

# qhasm: 0t10 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t10=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t10=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t10[0] *= *(float64 *)(op2 + 32)
# asm 1: mulsd 32(<op2=int64#3),<0t10=int6464#13
# asm 2: mulsd 32(<op2=%rdx),<0t10=%xmm12
mulsd 32(%rdx),%xmm12

# qhasm: float6464 0r10[0] +=0t10[0]
# asm 1: addsd <0t10=int6464#13,<0r10=int6464#12
# asm 2: addsd <0t10=%xmm12,<0r10=%xmm11
addsd %xmm12,%xmm11

# qhasm: 0t11 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t11=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t11=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t11[0] *= *(float64 *)(op2 + 40)
# asm 1: mulsd 40(<op2=int64#3),<0t11=int6464#13
# asm 2: mulsd 40(<op2=%rdx),<0t11=%xmm12
mulsd 40(%rdx),%xmm12

# qhasm: float6464 0r11[0] +=0t11[0]
# asm 1: addsd <0t11=int6464#13,<0r11=int6464#1
# asm 2: addsd <0t11=%xmm12,<0r11=%xmm0
addsd %xmm12,%xmm0

# qhasm: 0t12 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t12=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t12=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t12[0] *= *(float64 *)(op2 + 48)
# asm 1: mulsd 48(<op2=int64#3),<0t12=int6464#13
# asm 2: mulsd 48(<op2=%rdx),<0t12=%xmm12
mulsd 48(%rdx),%xmm12

# qhasm: float6464 0r12[0] +=0t12[0]
# asm 1: addsd <0t12=int6464#13,<0r12=int6464#2
# asm 2: addsd <0t12=%xmm12,<0r12=%xmm1
addsd %xmm12,%xmm1

# qhasm: 0t13 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t13=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t13=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t13[0] *= *(float64 *)(op2 + 56)
# asm 1: mulsd 56(<op2=int64#3),<0t13=int6464#13
# asm 2: mulsd 56(<op2=%rdx),<0t13=%xmm12
mulsd 56(%rdx),%xmm12

# qhasm: float6464 0r13[0] +=0t13[0]
# asm 1: addsd <0t13=int6464#13,<0r13=int6464#3
# asm 2: addsd <0t13=%xmm12,<0r13=%xmm2
addsd %xmm12,%xmm2

# qhasm: 0t14 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t14=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t14=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t14[0] *= *(float64 *)(op2 + 64)
# asm 1: mulsd 64(<op2=int64#3),<0t14=int6464#13
# asm 2: mulsd 64(<op2=%rdx),<0t14=%xmm12
mulsd 64(%rdx),%xmm12

# qhasm: float6464 0r14[0] +=0t14[0]
# asm 1: addsd <0t14=int6464#13,<0r14=int6464#4
# asm 2: addsd <0t14=%xmm12,<0r14=%xmm3
addsd %xmm12,%xmm3

# qhasm: 0t15 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t15=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t15=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t15[0] *= *(float64 *)(op2 + 72)
# asm 1: mulsd 72(<op2=int64#3),<0t15=int6464#13
# asm 2: mulsd 72(<op2=%rdx),<0t15=%xmm12
mulsd 72(%rdx),%xmm12

# qhasm: float6464 0r15[0] +=0t15[0]
# asm 1: addsd <0t15=int6464#13,<0r15=int6464#5
# asm 2: addsd <0t15=%xmm12,<0r15=%xmm4
addsd %xmm12,%xmm4

# qhasm: 0t16 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t16=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t16=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t16[0] *= *(float64 *)(op2 + 80)
# asm 1: mulsd 80(<op2=int64#3),<0t16=int6464#13
# asm 2: mulsd 80(<op2=%rdx),<0t16=%xmm12
mulsd 80(%rdx),%xmm12

# qhasm: float6464 0r16[0] +=0t16[0]
# asm 1: addsd <0t16=int6464#13,<0r16=int6464#6
# asm 2: addsd <0t16=%xmm12,<0r16=%xmm5
addsd %xmm12,%xmm5

# qhasm: 0t17 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t17=int6464#7
# asm 2: movdqa <0ab6=%xmm6,>0t17=%xmm6
movdqa %xmm6,%xmm6

# qhasm: float6464 0t17[0] *= *(float64 *)(op2 + 88)
# asm 1: mulsd 88(<op2=int64#3),<0t17=int6464#7
# asm 2: mulsd 88(<op2=%rdx),<0t17=%xmm6
mulsd 88(%rdx),%xmm6

# qhasm: 0r17 =0t17
# asm 1: movdqa <0t17=int6464#7,>0r17=int6464#7
# asm 2: movdqa <0t17=%xmm6,>0r17=%xmm6
movdqa %xmm6,%xmm6

# qhasm: *(float64 *)(0mysp + 48) = 0r6[0]
# asm 1: movlpd <0r6=int6464#8,48(<0mysp=int64#4)
# asm 2: movlpd <0r6=%xmm7,48(<0mysp=%rcx)
movlpd %xmm7,48(%rcx)

# qhasm: 0ab7[0] = *(float64 *)(op1 + 56)
# asm 1: movlpd 56(<op1=int64#2),>0ab7=int6464#8
# asm 2: movlpd 56(<op1=%rsi),>0ab7=%xmm7
movlpd 56(%rsi),%xmm7

# qhasm: 0ab7six = 0ab7
# asm 1: movdqa <0ab7=int6464#8,>0ab7six=int6464#13
# asm 2: movdqa <0ab7=%xmm7,>0ab7six=%xmm12
movdqa %xmm7,%xmm12

# qhasm: float6464 0ab7six[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0ab7six=int6464#13
# asm 2: mulsd SIX_SIX,<0ab7six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: 0t7 = 0ab7
# asm 1: movdqa <0ab7=int6464#8,>0t7=int6464#14
# asm 2: movdqa <0ab7=%xmm7,>0t7=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 0t7[0] *= *(float64 *)(op2 + 0)
# asm 1: mulsd 0(<op2=int64#3),<0t7=int6464#14
# asm 2: mulsd 0(<op2=%rdx),<0t7=%xmm13
mulsd 0(%rdx),%xmm13

# qhasm: float6464 0r7[0] +=0t7[0]
# asm 1: addsd <0t7=int6464#14,<0r7=int6464#9
# asm 2: addsd <0t7=%xmm13,<0r7=%xmm8
addsd %xmm13,%xmm8

# qhasm: 0t13 = 0ab7
# asm 1: movdqa <0ab7=int6464#8,>0t13=int6464#8
# asm 2: movdqa <0ab7=%xmm7,>0t13=%xmm7
movdqa %xmm7,%xmm7

# qhasm: float6464 0t13[0] *= *(float64 *)(op2 + 48)
# asm 1: mulsd 48(<op2=int64#3),<0t13=int6464#8
# asm 2: mulsd 48(<op2=%rdx),<0t13=%xmm7
mulsd 48(%rdx),%xmm7

# qhasm: float6464 0r13[0] +=0t13[0]
# asm 1: addsd <0t13=int6464#8,<0r13=int6464#3
# asm 2: addsd <0t13=%xmm7,<0r13=%xmm2
addsd %xmm7,%xmm2

# qhasm: 0t8 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>0t8=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>0t8=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 0t8[0] *= *(float64 *)(op2 + 8)
# asm 1: mulsd 8(<op2=int64#3),<0t8=int6464#8
# asm 2: mulsd 8(<op2=%rdx),<0t8=%xmm7
mulsd 8(%rdx),%xmm7

# qhasm: float6464 0r8[0] +=0t8[0]
# asm 1: addsd <0t8=int6464#8,<0r8=int6464#10
# asm 2: addsd <0t8=%xmm7,<0r8=%xmm9
addsd %xmm7,%xmm9

# qhasm: 0t9 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>0t9=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>0t9=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 0t9[0] *= *(float64 *)(op2 + 16)
# asm 1: mulsd 16(<op2=int64#3),<0t9=int6464#8
# asm 2: mulsd 16(<op2=%rdx),<0t9=%xmm7
mulsd 16(%rdx),%xmm7

# qhasm: float6464 0r9[0] +=0t9[0]
# asm 1: addsd <0t9=int6464#8,<0r9=int6464#11
# asm 2: addsd <0t9=%xmm7,<0r9=%xmm10
addsd %xmm7,%xmm10

# qhasm: 0t10 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>0t10=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>0t10=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 0t10[0] *= *(float64 *)(op2 + 24)
# asm 1: mulsd 24(<op2=int64#3),<0t10=int6464#8
# asm 2: mulsd 24(<op2=%rdx),<0t10=%xmm7
mulsd 24(%rdx),%xmm7

# qhasm: float6464 0r10[0] +=0t10[0]
# asm 1: addsd <0t10=int6464#8,<0r10=int6464#12
# asm 2: addsd <0t10=%xmm7,<0r10=%xmm11
addsd %xmm7,%xmm11

# qhasm: 0t11 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>0t11=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>0t11=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 0t11[0] *= *(float64 *)(op2 + 32)
# asm 1: mulsd 32(<op2=int64#3),<0t11=int6464#8
# asm 2: mulsd 32(<op2=%rdx),<0t11=%xmm7
mulsd 32(%rdx),%xmm7

# qhasm: float6464 0r11[0] +=0t11[0]
# asm 1: addsd <0t11=int6464#8,<0r11=int6464#1
# asm 2: addsd <0t11=%xmm7,<0r11=%xmm0
addsd %xmm7,%xmm0

# qhasm: 0t12 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>0t12=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>0t12=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 0t12[0] *= *(float64 *)(op2 + 40)
# asm 1: mulsd 40(<op2=int64#3),<0t12=int6464#8
# asm 2: mulsd 40(<op2=%rdx),<0t12=%xmm7
mulsd 40(%rdx),%xmm7

# qhasm: float6464 0r12[0] +=0t12[0]
# asm 1: addsd <0t12=int6464#8,<0r12=int6464#2
# asm 2: addsd <0t12=%xmm7,<0r12=%xmm1
addsd %xmm7,%xmm1

# qhasm: 0t14 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>0t14=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>0t14=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 0t14[0] *= *(float64 *)(op2 + 56)
# asm 1: mulsd 56(<op2=int64#3),<0t14=int6464#8
# asm 2: mulsd 56(<op2=%rdx),<0t14=%xmm7
mulsd 56(%rdx),%xmm7

# qhasm: float6464 0r14[0] +=0t14[0]
# asm 1: addsd <0t14=int6464#8,<0r14=int6464#4
# asm 2: addsd <0t14=%xmm7,<0r14=%xmm3
addsd %xmm7,%xmm3

# qhasm: 0t15 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>0t15=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>0t15=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 0t15[0] *= *(float64 *)(op2 + 64)
# asm 1: mulsd 64(<op2=int64#3),<0t15=int6464#8
# asm 2: mulsd 64(<op2=%rdx),<0t15=%xmm7
mulsd 64(%rdx),%xmm7

# qhasm: float6464 0r15[0] +=0t15[0]
# asm 1: addsd <0t15=int6464#8,<0r15=int6464#5
# asm 2: addsd <0t15=%xmm7,<0r15=%xmm4
addsd %xmm7,%xmm4

# qhasm: 0t16 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>0t16=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>0t16=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 0t16[0] *= *(float64 *)(op2 + 72)
# asm 1: mulsd 72(<op2=int64#3),<0t16=int6464#8
# asm 2: mulsd 72(<op2=%rdx),<0t16=%xmm7
mulsd 72(%rdx),%xmm7

# qhasm: float6464 0r16[0] +=0t16[0]
# asm 1: addsd <0t16=int6464#8,<0r16=int6464#6
# asm 2: addsd <0t16=%xmm7,<0r16=%xmm5
addsd %xmm7,%xmm5

# qhasm: 0t17 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>0t17=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>0t17=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 0t17[0] *= *(float64 *)(op2 + 80)
# asm 1: mulsd 80(<op2=int64#3),<0t17=int6464#8
# asm 2: mulsd 80(<op2=%rdx),<0t17=%xmm7
mulsd 80(%rdx),%xmm7

# qhasm: float6464 0r17[0] +=0t17[0]
# asm 1: addsd <0t17=int6464#8,<0r17=int6464#7
# asm 2: addsd <0t17=%xmm7,<0r17=%xmm6
addsd %xmm7,%xmm6

# qhasm: 0t18 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>0t18=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>0t18=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 0t18[0] *= *(float64 *)(op2 + 88)
# asm 1: mulsd 88(<op2=int64#3),<0t18=int6464#8
# asm 2: mulsd 88(<op2=%rdx),<0t18=%xmm7
mulsd 88(%rdx),%xmm7

# qhasm: 0r18 =0t18
# asm 1: movdqa <0t18=int6464#8,>0r18=int6464#8
# asm 2: movdqa <0t18=%xmm7,>0r18=%xmm7
movdqa %xmm7,%xmm7

# qhasm: *(float64 *)(0mysp + 56) = 0r7[0]
# asm 1: movlpd <0r7=int6464#9,56(<0mysp=int64#4)
# asm 2: movlpd <0r7=%xmm8,56(<0mysp=%rcx)
movlpd %xmm8,56(%rcx)

# qhasm: 0ab8[0] = *(float64 *)(op1 + 64)
# asm 1: movlpd 64(<op1=int64#2),>0ab8=int6464#9
# asm 2: movlpd 64(<op1=%rsi),>0ab8=%xmm8
movlpd 64(%rsi),%xmm8

# qhasm: 0ab8six = 0ab8
# asm 1: movdqa <0ab8=int6464#9,>0ab8six=int6464#13
# asm 2: movdqa <0ab8=%xmm8,>0ab8six=%xmm12
movdqa %xmm8,%xmm12

# qhasm: float6464 0ab8six[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0ab8six=int6464#13
# asm 2: mulsd SIX_SIX,<0ab8six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: 0t8 = 0ab8
# asm 1: movdqa <0ab8=int6464#9,>0t8=int6464#14
# asm 2: movdqa <0ab8=%xmm8,>0t8=%xmm13
movdqa %xmm8,%xmm13

# qhasm: float6464 0t8[0] *= *(float64 *)(op2 + 0)
# asm 1: mulsd 0(<op2=int64#3),<0t8=int6464#14
# asm 2: mulsd 0(<op2=%rdx),<0t8=%xmm13
mulsd 0(%rdx),%xmm13

# qhasm: float6464 0r8[0] +=0t8[0]
# asm 1: addsd <0t8=int6464#14,<0r8=int6464#10
# asm 2: addsd <0t8=%xmm13,<0r8=%xmm9
addsd %xmm13,%xmm9

# qhasm: 0t13 = 0ab8
# asm 1: movdqa <0ab8=int6464#9,>0t13=int6464#14
# asm 2: movdqa <0ab8=%xmm8,>0t13=%xmm13
movdqa %xmm8,%xmm13

# qhasm: float6464 0t13[0] *= *(float64 *)(op2 + 40)
# asm 1: mulsd 40(<op2=int64#3),<0t13=int6464#14
# asm 2: mulsd 40(<op2=%rdx),<0t13=%xmm13
mulsd 40(%rdx),%xmm13

# qhasm: float6464 0r13[0] +=0t13[0]
# asm 1: addsd <0t13=int6464#14,<0r13=int6464#3
# asm 2: addsd <0t13=%xmm13,<0r13=%xmm2
addsd %xmm13,%xmm2

# qhasm: 0t14 = 0ab8
# asm 1: movdqa <0ab8=int6464#9,>0t14=int6464#14
# asm 2: movdqa <0ab8=%xmm8,>0t14=%xmm13
movdqa %xmm8,%xmm13

# qhasm: float6464 0t14[0] *= *(float64 *)(op2 + 48)
# asm 1: mulsd 48(<op2=int64#3),<0t14=int6464#14
# asm 2: mulsd 48(<op2=%rdx),<0t14=%xmm13
mulsd 48(%rdx),%xmm13

# qhasm: float6464 0r14[0] +=0t14[0]
# asm 1: addsd <0t14=int6464#14,<0r14=int6464#4
# asm 2: addsd <0t14=%xmm13,<0r14=%xmm3
addsd %xmm13,%xmm3

# qhasm: 0t19 = 0ab8
# asm 1: movdqa <0ab8=int6464#9,>0t19=int6464#9
# asm 2: movdqa <0ab8=%xmm8,>0t19=%xmm8
movdqa %xmm8,%xmm8

# qhasm: float6464 0t19[0] *= *(float64 *)(op2 + 88)
# asm 1: mulsd 88(<op2=int64#3),<0t19=int6464#9
# asm 2: mulsd 88(<op2=%rdx),<0t19=%xmm8
mulsd 88(%rdx),%xmm8

# qhasm: 0r19 =0t19
# asm 1: movdqa <0t19=int6464#9,>0r19=int6464#9
# asm 2: movdqa <0t19=%xmm8,>0r19=%xmm8
movdqa %xmm8,%xmm8

# qhasm: 0t9 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>0t9=int6464#14
# asm 2: movdqa <0ab8six=%xmm12,>0t9=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t9[0] *= *(float64 *)(op2 + 8)
# asm 1: mulsd 8(<op2=int64#3),<0t9=int6464#14
# asm 2: mulsd 8(<op2=%rdx),<0t9=%xmm13
mulsd 8(%rdx),%xmm13

# qhasm: float6464 0r9[0] +=0t9[0]
# asm 1: addsd <0t9=int6464#14,<0r9=int6464#11
# asm 2: addsd <0t9=%xmm13,<0r9=%xmm10
addsd %xmm13,%xmm10

# qhasm: 0t10 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>0t10=int6464#14
# asm 2: movdqa <0ab8six=%xmm12,>0t10=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t10[0] *= *(float64 *)(op2 + 16)
# asm 1: mulsd 16(<op2=int64#3),<0t10=int6464#14
# asm 2: mulsd 16(<op2=%rdx),<0t10=%xmm13
mulsd 16(%rdx),%xmm13

# qhasm: float6464 0r10[0] +=0t10[0]
# asm 1: addsd <0t10=int6464#14,<0r10=int6464#12
# asm 2: addsd <0t10=%xmm13,<0r10=%xmm11
addsd %xmm13,%xmm11

# qhasm: 0t11 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>0t11=int6464#14
# asm 2: movdqa <0ab8six=%xmm12,>0t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t11[0] *= *(float64 *)(op2 + 24)
# asm 1: mulsd 24(<op2=int64#3),<0t11=int6464#14
# asm 2: mulsd 24(<op2=%rdx),<0t11=%xmm13
mulsd 24(%rdx),%xmm13

# qhasm: float6464 0r11[0] +=0t11[0]
# asm 1: addsd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addsd <0t11=%xmm13,<0r11=%xmm0
addsd %xmm13,%xmm0

# qhasm: 0t12 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>0t12=int6464#14
# asm 2: movdqa <0ab8six=%xmm12,>0t12=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t12[0] *= *(float64 *)(op2 + 32)
# asm 1: mulsd 32(<op2=int64#3),<0t12=int6464#14
# asm 2: mulsd 32(<op2=%rdx),<0t12=%xmm13
mulsd 32(%rdx),%xmm13

# qhasm: float6464 0r12[0] +=0t12[0]
# asm 1: addsd <0t12=int6464#14,<0r12=int6464#2
# asm 2: addsd <0t12=%xmm13,<0r12=%xmm1
addsd %xmm13,%xmm1

# qhasm: 0t15 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>0t15=int6464#14
# asm 2: movdqa <0ab8six=%xmm12,>0t15=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t15[0] *= *(float64 *)(op2 + 56)
# asm 1: mulsd 56(<op2=int64#3),<0t15=int6464#14
# asm 2: mulsd 56(<op2=%rdx),<0t15=%xmm13
mulsd 56(%rdx),%xmm13

# qhasm: float6464 0r15[0] +=0t15[0]
# asm 1: addsd <0t15=int6464#14,<0r15=int6464#5
# asm 2: addsd <0t15=%xmm13,<0r15=%xmm4
addsd %xmm13,%xmm4

# qhasm: 0t16 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>0t16=int6464#14
# asm 2: movdqa <0ab8six=%xmm12,>0t16=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t16[0] *= *(float64 *)(op2 + 64)
# asm 1: mulsd 64(<op2=int64#3),<0t16=int6464#14
# asm 2: mulsd 64(<op2=%rdx),<0t16=%xmm13
mulsd 64(%rdx),%xmm13

# qhasm: float6464 0r16[0] +=0t16[0]
# asm 1: addsd <0t16=int6464#14,<0r16=int6464#6
# asm 2: addsd <0t16=%xmm13,<0r16=%xmm5
addsd %xmm13,%xmm5

# qhasm: 0t17 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>0t17=int6464#14
# asm 2: movdqa <0ab8six=%xmm12,>0t17=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t17[0] *= *(float64 *)(op2 + 72)
# asm 1: mulsd 72(<op2=int64#3),<0t17=int6464#14
# asm 2: mulsd 72(<op2=%rdx),<0t17=%xmm13
mulsd 72(%rdx),%xmm13

# qhasm: float6464 0r17[0] +=0t17[0]
# asm 1: addsd <0t17=int6464#14,<0r17=int6464#7
# asm 2: addsd <0t17=%xmm13,<0r17=%xmm6
addsd %xmm13,%xmm6

# qhasm: 0t18 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>0t18=int6464#13
# asm 2: movdqa <0ab8six=%xmm12,>0t18=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 0t18[0] *= *(float64 *)(op2 + 80)
# asm 1: mulsd 80(<op2=int64#3),<0t18=int6464#13
# asm 2: mulsd 80(<op2=%rdx),<0t18=%xmm12
mulsd 80(%rdx),%xmm12

# qhasm: float6464 0r18[0] +=0t18[0]
# asm 1: addsd <0t18=int6464#13,<0r18=int6464#8
# asm 2: addsd <0t18=%xmm12,<0r18=%xmm7
addsd %xmm12,%xmm7

# qhasm: *(float64 *)(0mysp + 64) = 0r8[0]
# asm 1: movlpd <0r8=int6464#10,64(<0mysp=int64#4)
# asm 2: movlpd <0r8=%xmm9,64(<0mysp=%rcx)
movlpd %xmm9,64(%rcx)

# qhasm: 0ab9[0] = *(float64 *)(op1 + 72)
# asm 1: movlpd 72(<op1=int64#2),>0ab9=int6464#10
# asm 2: movlpd 72(<op1=%rsi),>0ab9=%xmm9
movlpd 72(%rsi),%xmm9

# qhasm: 0ab9six = 0ab9
# asm 1: movdqa <0ab9=int6464#10,>0ab9six=int6464#13
# asm 2: movdqa <0ab9=%xmm9,>0ab9six=%xmm12
movdqa %xmm9,%xmm12

# qhasm: float6464 0ab9six[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0ab9six=int6464#13
# asm 2: mulsd SIX_SIX,<0ab9six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: 0t9 = 0ab9
# asm 1: movdqa <0ab9=int6464#10,>0t9=int6464#14
# asm 2: movdqa <0ab9=%xmm9,>0t9=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 0t9[0] *= *(float64 *)(op2 + 0)
# asm 1: mulsd 0(<op2=int64#3),<0t9=int6464#14
# asm 2: mulsd 0(<op2=%rdx),<0t9=%xmm13
mulsd 0(%rdx),%xmm13

# qhasm: float6464 0r9[0] +=0t9[0]
# asm 1: addsd <0t9=int6464#14,<0r9=int6464#11
# asm 2: addsd <0t9=%xmm13,<0r9=%xmm10
addsd %xmm13,%xmm10

# qhasm: 0t13 = 0ab9
# asm 1: movdqa <0ab9=int6464#10,>0t13=int6464#14
# asm 2: movdqa <0ab9=%xmm9,>0t13=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 0t13[0] *= *(float64 *)(op2 + 32)
# asm 1: mulsd 32(<op2=int64#3),<0t13=int6464#14
# asm 2: mulsd 32(<op2=%rdx),<0t13=%xmm13
mulsd 32(%rdx),%xmm13

# qhasm: float6464 0r13[0] +=0t13[0]
# asm 1: addsd <0t13=int6464#14,<0r13=int6464#3
# asm 2: addsd <0t13=%xmm13,<0r13=%xmm2
addsd %xmm13,%xmm2

# qhasm: 0t14 = 0ab9
# asm 1: movdqa <0ab9=int6464#10,>0t14=int6464#14
# asm 2: movdqa <0ab9=%xmm9,>0t14=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 0t14[0] *= *(float64 *)(op2 + 40)
# asm 1: mulsd 40(<op2=int64#3),<0t14=int6464#14
# asm 2: mulsd 40(<op2=%rdx),<0t14=%xmm13
mulsd 40(%rdx),%xmm13

# qhasm: float6464 0r14[0] +=0t14[0]
# asm 1: addsd <0t14=int6464#14,<0r14=int6464#4
# asm 2: addsd <0t14=%xmm13,<0r14=%xmm3
addsd %xmm13,%xmm3

# qhasm: 0t15 = 0ab9
# asm 1: movdqa <0ab9=int6464#10,>0t15=int6464#14
# asm 2: movdqa <0ab9=%xmm9,>0t15=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 0t15[0] *= *(float64 *)(op2 + 48)
# asm 1: mulsd 48(<op2=int64#3),<0t15=int6464#14
# asm 2: mulsd 48(<op2=%rdx),<0t15=%xmm13
mulsd 48(%rdx),%xmm13

# qhasm: float6464 0r15[0] +=0t15[0]
# asm 1: addsd <0t15=int6464#14,<0r15=int6464#5
# asm 2: addsd <0t15=%xmm13,<0r15=%xmm4
addsd %xmm13,%xmm4

# qhasm: 0t19 = 0ab9
# asm 1: movdqa <0ab9=int6464#10,>0t19=int6464#14
# asm 2: movdqa <0ab9=%xmm9,>0t19=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 0t19[0] *= *(float64 *)(op2 + 80)
# asm 1: mulsd 80(<op2=int64#3),<0t19=int6464#14
# asm 2: mulsd 80(<op2=%rdx),<0t19=%xmm13
mulsd 80(%rdx),%xmm13

# qhasm: float6464 0r19[0] +=0t19[0]
# asm 1: addsd <0t19=int6464#14,<0r19=int6464#9
# asm 2: addsd <0t19=%xmm13,<0r19=%xmm8
addsd %xmm13,%xmm8

# qhasm: 0t20 = 0ab9
# asm 1: movdqa <0ab9=int6464#10,>0t20=int6464#10
# asm 2: movdqa <0ab9=%xmm9,>0t20=%xmm9
movdqa %xmm9,%xmm9

# qhasm: float6464 0t20[0] *= *(float64 *)(op2 + 88)
# asm 1: mulsd 88(<op2=int64#3),<0t20=int6464#10
# asm 2: mulsd 88(<op2=%rdx),<0t20=%xmm9
mulsd 88(%rdx),%xmm9

# qhasm: 0r20 =0t20
# asm 1: movdqa <0t20=int6464#10,>0r20=int6464#10
# asm 2: movdqa <0t20=%xmm9,>0r20=%xmm9
movdqa %xmm9,%xmm9

# qhasm: 0t10 = 0ab9six
# asm 1: movdqa <0ab9six=int6464#13,>0t10=int6464#14
# asm 2: movdqa <0ab9six=%xmm12,>0t10=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t10[0] *= *(float64 *)(op2 + 8)
# asm 1: mulsd 8(<op2=int64#3),<0t10=int6464#14
# asm 2: mulsd 8(<op2=%rdx),<0t10=%xmm13
mulsd 8(%rdx),%xmm13

# qhasm: float6464 0r10[0] +=0t10[0]
# asm 1: addsd <0t10=int6464#14,<0r10=int6464#12
# asm 2: addsd <0t10=%xmm13,<0r10=%xmm11
addsd %xmm13,%xmm11

# qhasm: 0t11 = 0ab9six
# asm 1: movdqa <0ab9six=int6464#13,>0t11=int6464#14
# asm 2: movdqa <0ab9six=%xmm12,>0t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t11[0] *= *(float64 *)(op2 + 16)
# asm 1: mulsd 16(<op2=int64#3),<0t11=int6464#14
# asm 2: mulsd 16(<op2=%rdx),<0t11=%xmm13
mulsd 16(%rdx),%xmm13

# qhasm: float6464 0r11[0] +=0t11[0]
# asm 1: addsd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addsd <0t11=%xmm13,<0r11=%xmm0
addsd %xmm13,%xmm0

# qhasm: 0t12 = 0ab9six
# asm 1: movdqa <0ab9six=int6464#13,>0t12=int6464#14
# asm 2: movdqa <0ab9six=%xmm12,>0t12=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t12[0] *= *(float64 *)(op2 + 24)
# asm 1: mulsd 24(<op2=int64#3),<0t12=int6464#14
# asm 2: mulsd 24(<op2=%rdx),<0t12=%xmm13
mulsd 24(%rdx),%xmm13

# qhasm: float6464 0r12[0] +=0t12[0]
# asm 1: addsd <0t12=int6464#14,<0r12=int6464#2
# asm 2: addsd <0t12=%xmm13,<0r12=%xmm1
addsd %xmm13,%xmm1

# qhasm: 0t16 = 0ab9six
# asm 1: movdqa <0ab9six=int6464#13,>0t16=int6464#14
# asm 2: movdqa <0ab9six=%xmm12,>0t16=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t16[0] *= *(float64 *)(op2 + 56)
# asm 1: mulsd 56(<op2=int64#3),<0t16=int6464#14
# asm 2: mulsd 56(<op2=%rdx),<0t16=%xmm13
mulsd 56(%rdx),%xmm13

# qhasm: float6464 0r16[0] +=0t16[0]
# asm 1: addsd <0t16=int6464#14,<0r16=int6464#6
# asm 2: addsd <0t16=%xmm13,<0r16=%xmm5
addsd %xmm13,%xmm5

# qhasm: 0t17 = 0ab9six
# asm 1: movdqa <0ab9six=int6464#13,>0t17=int6464#14
# asm 2: movdqa <0ab9six=%xmm12,>0t17=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t17[0] *= *(float64 *)(op2 + 64)
# asm 1: mulsd 64(<op2=int64#3),<0t17=int6464#14
# asm 2: mulsd 64(<op2=%rdx),<0t17=%xmm13
mulsd 64(%rdx),%xmm13

# qhasm: float6464 0r17[0] +=0t17[0]
# asm 1: addsd <0t17=int6464#14,<0r17=int6464#7
# asm 2: addsd <0t17=%xmm13,<0r17=%xmm6
addsd %xmm13,%xmm6

# qhasm: 0t18 = 0ab9six
# asm 1: movdqa <0ab9six=int6464#13,>0t18=int6464#13
# asm 2: movdqa <0ab9six=%xmm12,>0t18=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 0t18[0] *= *(float64 *)(op2 + 72)
# asm 1: mulsd 72(<op2=int64#3),<0t18=int6464#13
# asm 2: mulsd 72(<op2=%rdx),<0t18=%xmm12
mulsd 72(%rdx),%xmm12

# qhasm: float6464 0r18[0] +=0t18[0]
# asm 1: addsd <0t18=int6464#13,<0r18=int6464#8
# asm 2: addsd <0t18=%xmm12,<0r18=%xmm7
addsd %xmm12,%xmm7

# qhasm: *(float64 *)(0mysp + 72) = 0r9[0]
# asm 1: movlpd <0r9=int6464#11,72(<0mysp=int64#4)
# asm 2: movlpd <0r9=%xmm10,72(<0mysp=%rcx)
movlpd %xmm10,72(%rcx)

# qhasm: 0ab10[0] = *(float64 *)(op1 + 80)
# asm 1: movlpd 80(<op1=int64#2),>0ab10=int6464#11
# asm 2: movlpd 80(<op1=%rsi),>0ab10=%xmm10
movlpd 80(%rsi),%xmm10

# qhasm: 0ab10six = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>0ab10six=int6464#13
# asm 2: movdqa <0ab10=%xmm10,>0ab10six=%xmm12
movdqa %xmm10,%xmm12

# qhasm: float6464 0ab10six[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0ab10six=int6464#13
# asm 2: mulsd SIX_SIX,<0ab10six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: 0t10 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>0t10=int6464#14
# asm 2: movdqa <0ab10=%xmm10,>0t10=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 0t10[0] *= *(float64 *)(op2 + 0)
# asm 1: mulsd 0(<op2=int64#3),<0t10=int6464#14
# asm 2: mulsd 0(<op2=%rdx),<0t10=%xmm13
mulsd 0(%rdx),%xmm13

# qhasm: float6464 0r10[0] +=0t10[0]
# asm 1: addsd <0t10=int6464#14,<0r10=int6464#12
# asm 2: addsd <0t10=%xmm13,<0r10=%xmm11
addsd %xmm13,%xmm11

# qhasm: 0t13 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>0t13=int6464#14
# asm 2: movdqa <0ab10=%xmm10,>0t13=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 0t13[0] *= *(float64 *)(op2 + 24)
# asm 1: mulsd 24(<op2=int64#3),<0t13=int6464#14
# asm 2: mulsd 24(<op2=%rdx),<0t13=%xmm13
mulsd 24(%rdx),%xmm13

# qhasm: float6464 0r13[0] +=0t13[0]
# asm 1: addsd <0t13=int6464#14,<0r13=int6464#3
# asm 2: addsd <0t13=%xmm13,<0r13=%xmm2
addsd %xmm13,%xmm2

# qhasm: 0t14 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>0t14=int6464#14
# asm 2: movdqa <0ab10=%xmm10,>0t14=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 0t14[0] *= *(float64 *)(op2 + 32)
# asm 1: mulsd 32(<op2=int64#3),<0t14=int6464#14
# asm 2: mulsd 32(<op2=%rdx),<0t14=%xmm13
mulsd 32(%rdx),%xmm13

# qhasm: float6464 0r14[0] +=0t14[0]
# asm 1: addsd <0t14=int6464#14,<0r14=int6464#4
# asm 2: addsd <0t14=%xmm13,<0r14=%xmm3
addsd %xmm13,%xmm3

# qhasm: 0t16 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>0t16=int6464#14
# asm 2: movdqa <0ab10=%xmm10,>0t16=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 0t16[0] *= *(float64 *)(op2 + 48)
# asm 1: mulsd 48(<op2=int64#3),<0t16=int6464#14
# asm 2: mulsd 48(<op2=%rdx),<0t16=%xmm13
mulsd 48(%rdx),%xmm13

# qhasm: float6464 0r16[0] +=0t16[0]
# asm 1: addsd <0t16=int6464#14,<0r16=int6464#6
# asm 2: addsd <0t16=%xmm13,<0r16=%xmm5
addsd %xmm13,%xmm5

# qhasm: 0t15 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>0t15=int6464#14
# asm 2: movdqa <0ab10=%xmm10,>0t15=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 0t15[0] *= *(float64 *)(op2 + 40)
# asm 1: mulsd 40(<op2=int64#3),<0t15=int6464#14
# asm 2: mulsd 40(<op2=%rdx),<0t15=%xmm13
mulsd 40(%rdx),%xmm13

# qhasm: float6464 0r15[0] +=0t15[0]
# asm 1: addsd <0t15=int6464#14,<0r15=int6464#5
# asm 2: addsd <0t15=%xmm13,<0r15=%xmm4
addsd %xmm13,%xmm4

# qhasm: 0t19 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>0t19=int6464#14
# asm 2: movdqa <0ab10=%xmm10,>0t19=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 0t19[0] *= *(float64 *)(op2 + 72)
# asm 1: mulsd 72(<op2=int64#3),<0t19=int6464#14
# asm 2: mulsd 72(<op2=%rdx),<0t19=%xmm13
mulsd 72(%rdx),%xmm13

# qhasm: float6464 0r19[0] +=0t19[0]
# asm 1: addsd <0t19=int6464#14,<0r19=int6464#9
# asm 2: addsd <0t19=%xmm13,<0r19=%xmm8
addsd %xmm13,%xmm8

# qhasm: 0t20 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>0t20=int6464#14
# asm 2: movdqa <0ab10=%xmm10,>0t20=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 0t20[0] *= *(float64 *)(op2 + 80)
# asm 1: mulsd 80(<op2=int64#3),<0t20=int6464#14
# asm 2: mulsd 80(<op2=%rdx),<0t20=%xmm13
mulsd 80(%rdx),%xmm13

# qhasm: float6464 0r20[0] +=0t20[0]
# asm 1: addsd <0t20=int6464#14,<0r20=int6464#10
# asm 2: addsd <0t20=%xmm13,<0r20=%xmm9
addsd %xmm13,%xmm9

# qhasm: 0t21 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>0t21=int6464#11
# asm 2: movdqa <0ab10=%xmm10,>0t21=%xmm10
movdqa %xmm10,%xmm10

# qhasm: float6464 0t21[0] *= *(float64 *)(op2 + 88)
# asm 1: mulsd 88(<op2=int64#3),<0t21=int6464#11
# asm 2: mulsd 88(<op2=%rdx),<0t21=%xmm10
mulsd 88(%rdx),%xmm10

# qhasm: 0r21 =0t21
# asm 1: movdqa <0t21=int6464#11,>0r21=int6464#11
# asm 2: movdqa <0t21=%xmm10,>0r21=%xmm10
movdqa %xmm10,%xmm10

# qhasm: 0t11 = 0ab10six
# asm 1: movdqa <0ab10six=int6464#13,>0t11=int6464#14
# asm 2: movdqa <0ab10six=%xmm12,>0t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t11[0] *= *(float64 *)(op2 + 8)
# asm 1: mulsd 8(<op2=int64#3),<0t11=int6464#14
# asm 2: mulsd 8(<op2=%rdx),<0t11=%xmm13
mulsd 8(%rdx),%xmm13

# qhasm: float6464 0r11[0] +=0t11[0]
# asm 1: addsd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addsd <0t11=%xmm13,<0r11=%xmm0
addsd %xmm13,%xmm0

# qhasm: 0t12 = 0ab10six
# asm 1: movdqa <0ab10six=int6464#13,>0t12=int6464#14
# asm 2: movdqa <0ab10six=%xmm12,>0t12=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t12[0] *= *(float64 *)(op2 + 16)
# asm 1: mulsd 16(<op2=int64#3),<0t12=int6464#14
# asm 2: mulsd 16(<op2=%rdx),<0t12=%xmm13
mulsd 16(%rdx),%xmm13

# qhasm: float6464 0r12[0] +=0t12[0]
# asm 1: addsd <0t12=int6464#14,<0r12=int6464#2
# asm 2: addsd <0t12=%xmm13,<0r12=%xmm1
addsd %xmm13,%xmm1

# qhasm: 0t17 = 0ab10six
# asm 1: movdqa <0ab10six=int6464#13,>0t17=int6464#14
# asm 2: movdqa <0ab10six=%xmm12,>0t17=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t17[0] *= *(float64 *)(op2 + 56)
# asm 1: mulsd 56(<op2=int64#3),<0t17=int6464#14
# asm 2: mulsd 56(<op2=%rdx),<0t17=%xmm13
mulsd 56(%rdx),%xmm13

# qhasm: float6464 0r17[0] +=0t17[0]
# asm 1: addsd <0t17=int6464#14,<0r17=int6464#7
# asm 2: addsd <0t17=%xmm13,<0r17=%xmm6
addsd %xmm13,%xmm6

# qhasm: 0t18 = 0ab10six
# asm 1: movdqa <0ab10six=int6464#13,>0t18=int6464#13
# asm 2: movdqa <0ab10six=%xmm12,>0t18=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 0t18[0] *= *(float64 *)(op2 + 64)
# asm 1: mulsd 64(<op2=int64#3),<0t18=int6464#13
# asm 2: mulsd 64(<op2=%rdx),<0t18=%xmm12
mulsd 64(%rdx),%xmm12

# qhasm: float6464 0r18[0] +=0t18[0]
# asm 1: addsd <0t18=int6464#13,<0r18=int6464#8
# asm 2: addsd <0t18=%xmm12,<0r18=%xmm7
addsd %xmm12,%xmm7

# qhasm: *(float64 *)(0mysp + 80) = 0r10[0]
# asm 1: movlpd <0r10=int6464#12,80(<0mysp=int64#4)
# asm 2: movlpd <0r10=%xmm11,80(<0mysp=%rcx)
movlpd %xmm11,80(%rcx)

# qhasm: 0ab11[0] = *(float64 *)(op1 + 88)
# asm 1: movlpd 88(<op1=int64#2),>0ab11=int6464#12
# asm 2: movlpd 88(<op1=%rsi),>0ab11=%xmm11
movlpd 88(%rsi),%xmm11

# qhasm: 0ab11six = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>0ab11six=int6464#13
# asm 2: movdqa <0ab11=%xmm11,>0ab11six=%xmm12
movdqa %xmm11,%xmm12

# qhasm: float6464 0ab11six[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0ab11six=int6464#13
# asm 2: mulsd SIX_SIX,<0ab11six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: 0t11 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>0t11=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>0t11=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 0t11[0] *= *(float64 *)(op2 + 0)
# asm 1: mulsd 0(<op2=int64#3),<0t11=int6464#14
# asm 2: mulsd 0(<op2=%rdx),<0t11=%xmm13
mulsd 0(%rdx),%xmm13

# qhasm: float6464 0r11[0] +=0t11[0]
# asm 1: addsd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addsd <0t11=%xmm13,<0r11=%xmm0
addsd %xmm13,%xmm0

# qhasm: 0t13 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>0t13=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>0t13=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 0t13[0] *= *(float64 *)(op2 + 16)
# asm 1: mulsd 16(<op2=int64#3),<0t13=int6464#14
# asm 2: mulsd 16(<op2=%rdx),<0t13=%xmm13
mulsd 16(%rdx),%xmm13

# qhasm: float6464 0r13[0] +=0t13[0]
# asm 1: addsd <0t13=int6464#14,<0r13=int6464#3
# asm 2: addsd <0t13=%xmm13,<0r13=%xmm2
addsd %xmm13,%xmm2

# qhasm: 0t14 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>0t14=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>0t14=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 0t14[0] *= *(float64 *)(op2 + 24)
# asm 1: mulsd 24(<op2=int64#3),<0t14=int6464#14
# asm 2: mulsd 24(<op2=%rdx),<0t14=%xmm13
mulsd 24(%rdx),%xmm13

# qhasm: float6464 0r14[0] +=0t14[0]
# asm 1: addsd <0t14=int6464#14,<0r14=int6464#4
# asm 2: addsd <0t14=%xmm13,<0r14=%xmm3
addsd %xmm13,%xmm3

# qhasm: 0t15 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>0t15=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>0t15=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 0t15[0] *= *(float64 *)(op2 + 32)
# asm 1: mulsd 32(<op2=int64#3),<0t15=int6464#14
# asm 2: mulsd 32(<op2=%rdx),<0t15=%xmm13
mulsd 32(%rdx),%xmm13

# qhasm: float6464 0r15[0] +=0t15[0]
# asm 1: addsd <0t15=int6464#14,<0r15=int6464#5
# asm 2: addsd <0t15=%xmm13,<0r15=%xmm4
addsd %xmm13,%xmm4

# qhasm: 0t16 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>0t16=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>0t16=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 0t16[0] *= *(float64 *)(op2 + 40)
# asm 1: mulsd 40(<op2=int64#3),<0t16=int6464#14
# asm 2: mulsd 40(<op2=%rdx),<0t16=%xmm13
mulsd 40(%rdx),%xmm13

# qhasm: float6464 0r16[0] +=0t16[0]
# asm 1: addsd <0t16=int6464#14,<0r16=int6464#6
# asm 2: addsd <0t16=%xmm13,<0r16=%xmm5
addsd %xmm13,%xmm5

# qhasm: 0t17 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>0t17=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>0t17=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 0t17[0] *= *(float64 *)(op2 + 48)
# asm 1: mulsd 48(<op2=int64#3),<0t17=int6464#14
# asm 2: mulsd 48(<op2=%rdx),<0t17=%xmm13
mulsd 48(%rdx),%xmm13

# qhasm: float6464 0r17[0] +=0t17[0]
# asm 1: addsd <0t17=int6464#14,<0r17=int6464#7
# asm 2: addsd <0t17=%xmm13,<0r17=%xmm6
addsd %xmm13,%xmm6

# qhasm: 0t19 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>0t19=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>0t19=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 0t19[0] *= *(float64 *)(op2 + 64)
# asm 1: mulsd 64(<op2=int64#3),<0t19=int6464#14
# asm 2: mulsd 64(<op2=%rdx),<0t19=%xmm13
mulsd 64(%rdx),%xmm13

# qhasm: float6464 0r19[0] +=0t19[0]
# asm 1: addsd <0t19=int6464#14,<0r19=int6464#9
# asm 2: addsd <0t19=%xmm13,<0r19=%xmm8
addsd %xmm13,%xmm8

# qhasm: 0t20 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>0t20=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>0t20=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 0t20[0] *= *(float64 *)(op2 + 72)
# asm 1: mulsd 72(<op2=int64#3),<0t20=int6464#14
# asm 2: mulsd 72(<op2=%rdx),<0t20=%xmm13
mulsd 72(%rdx),%xmm13

# qhasm: float6464 0r20[0] +=0t20[0]
# asm 1: addsd <0t20=int6464#14,<0r20=int6464#10
# asm 2: addsd <0t20=%xmm13,<0r20=%xmm9
addsd %xmm13,%xmm9

# qhasm: 0t21 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>0t21=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>0t21=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 0t21[0] *= *(float64 *)(op2 + 80)
# asm 1: mulsd 80(<op2=int64#3),<0t21=int6464#14
# asm 2: mulsd 80(<op2=%rdx),<0t21=%xmm13
mulsd 80(%rdx),%xmm13

# qhasm: float6464 0r21[0] +=0t21[0]
# asm 1: addsd <0t21=int6464#14,<0r21=int6464#11
# asm 2: addsd <0t21=%xmm13,<0r21=%xmm10
addsd %xmm13,%xmm10

# qhasm: 0t22 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>0t22=int6464#12
# asm 2: movdqa <0ab11=%xmm11,>0t22=%xmm11
movdqa %xmm11,%xmm11

# qhasm: float6464 0t22[0] *= *(float64 *)(op2 + 88)
# asm 1: mulsd 88(<op2=int64#3),<0t22=int6464#12
# asm 2: mulsd 88(<op2=%rdx),<0t22=%xmm11
mulsd 88(%rdx),%xmm11

# qhasm: 0r22 =0t22
# asm 1: movdqa <0t22=int6464#12,>0r22=int6464#12
# asm 2: movdqa <0t22=%xmm11,>0r22=%xmm11
movdqa %xmm11,%xmm11

# qhasm: 0t12 = 0ab11six
# asm 1: movdqa <0ab11six=int6464#13,>0t12=int6464#14
# asm 2: movdqa <0ab11six=%xmm12,>0t12=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t12[0] *= *(float64 *)(op2 + 8)
# asm 1: mulsd 8(<op2=int64#3),<0t12=int6464#14
# asm 2: mulsd 8(<op2=%rdx),<0t12=%xmm13
mulsd 8(%rdx),%xmm13

# qhasm: float6464 0r12[0] +=0t12[0]
# asm 1: addsd <0t12=int6464#14,<0r12=int6464#2
# asm 2: addsd <0t12=%xmm13,<0r12=%xmm1
addsd %xmm13,%xmm1

# qhasm: 0t18 = 0ab11six
# asm 1: movdqa <0ab11six=int6464#13,>0t18=int6464#13
# asm 2: movdqa <0ab11six=%xmm12,>0t18=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 0t18[0] *= *(float64 *)(op2 + 56)
# asm 1: mulsd 56(<op2=int64#3),<0t18=int6464#13
# asm 2: mulsd 56(<op2=%rdx),<0t18=%xmm12
mulsd 56(%rdx),%xmm12

# qhasm: float6464 0r18[0] +=0t18[0]
# asm 1: addsd <0t18=int6464#13,<0r18=int6464#8
# asm 2: addsd <0t18=%xmm12,<0r18=%xmm7
addsd %xmm12,%xmm7

# qhasm: *(float64 *)(0mysp + 88) = 0r11[0]
# asm 1: movlpd <0r11=int6464#1,88(<0mysp=int64#4)
# asm 2: movlpd <0r11=%xmm0,88(<0mysp=%rcx)
movlpd %xmm0,88(%rcx)

# qhasm: 0r0[0] = *(float64 *)(0mysp + 0)
# asm 1: movlpd 0(<0mysp=int64#4),>0r0=int6464#1
# asm 2: movlpd 0(<0mysp=%rcx),>0r0=%xmm0
movlpd 0(%rcx),%xmm0

# qhasm: float6464 0r0[0] -= 0r12[0]
# asm 1: subsd <0r12=int6464#2,<0r0=int6464#1
# asm 2: subsd <0r12=%xmm1,<0r0=%xmm0
subsd %xmm1,%xmm0

# qhasm: 0t15 = 0r15
# asm 1: movdqa <0r15=int6464#5,>0t15=int6464#13
# asm 2: movdqa <0r15=%xmm4,>0t15=%xmm12
movdqa %xmm4,%xmm12

# qhasm: float6464 0t15[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0t15=int6464#13
# asm 2: mulsd SIX_SIX,<0t15=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: float6464 0r0[0] += 0t15[0]
# asm 1: addsd <0t15=int6464#13,<0r0=int6464#1
# asm 2: addsd <0t15=%xmm12,<0r0=%xmm0
addsd %xmm12,%xmm0

# qhasm: 0t18 = 0r18
# asm 1: movdqa <0r18=int6464#8,>0t18=int6464#13
# asm 2: movdqa <0r18=%xmm7,>0t18=%xmm12
movdqa %xmm7,%xmm12

# qhasm: float6464 0t18[0] *= TWO_TWO
# asm 1: mulsd TWO_TWO,<0t18=int6464#13
# asm 2: mulsd TWO_TWO,<0t18=%xmm12
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: float6464 0r0[0] -= 0t18[0]
# asm 1: subsd <0t18=int6464#13,<0r0=int6464#1
# asm 2: subsd <0t18=%xmm12,<0r0=%xmm0
subsd %xmm12,%xmm0

# qhasm: 0t21 = 0r21
# asm 1: movdqa <0r21=int6464#11,>0t21=int6464#13
# asm 2: movdqa <0r21=%xmm10,>0t21=%xmm12
movdqa %xmm10,%xmm12

# qhasm: float6464 0t21[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0t21=int6464#13
# asm 2: mulsd SIX_SIX,<0t21=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: float6464 0r0[0] -= 0t21[0]
# asm 1: subsd <0t21=int6464#13,<0r0=int6464#1
# asm 2: subsd <0t21=%xmm12,<0r0=%xmm0
subsd %xmm12,%xmm0

# qhasm: *(float64 *)(0mysp + 0) = 0r0[0]
# asm 1: movlpd <0r0=int6464#1,0(<0mysp=int64#4)
# asm 2: movlpd <0r0=%xmm0,0(<0mysp=%rcx)
movlpd %xmm0,0(%rcx)

# qhasm: 0r3[0] = *(float64 *)(0mysp + 24)
# asm 1: movlpd 24(<0mysp=int64#4),>0r3=int6464#1
# asm 2: movlpd 24(<0mysp=%rcx),>0r3=%xmm0
movlpd 24(%rcx),%xmm0

# qhasm: float6464 0r3[0] -= 0r12[0]
# asm 1: subsd <0r12=int6464#2,<0r3=int6464#1
# asm 2: subsd <0r12=%xmm1,<0r3=%xmm0
subsd %xmm1,%xmm0

# qhasm: 0t15 = 0r15
# asm 1: movdqa <0r15=int6464#5,>0t15=int6464#13
# asm 2: movdqa <0r15=%xmm4,>0t15=%xmm12
movdqa %xmm4,%xmm12

# qhasm: float6464 0t15[0] *= FIVE_FIVE
# asm 1: mulsd FIVE_FIVE,<0t15=int6464#13
# asm 2: mulsd FIVE_FIVE,<0t15=%xmm12
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: float6464 0r3[0] += 0t15[0]
# asm 1: addsd <0t15=int6464#13,<0r3=int6464#1
# asm 2: addsd <0t15=%xmm12,<0r3=%xmm0
addsd %xmm12,%xmm0

# qhasm: float6464 0r3[0] -= 0r18[0]
# asm 1: subsd <0r18=int6464#8,<0r3=int6464#1
# asm 2: subsd <0r18=%xmm7,<0r3=%xmm0
subsd %xmm7,%xmm0

# qhasm: 0t21 = 0r21
# asm 1: movdqa <0r21=int6464#11,>0t21=int6464#13
# asm 2: movdqa <0r21=%xmm10,>0t21=%xmm12
movdqa %xmm10,%xmm12

# qhasm: float6464 0t21[0] *= EIGHT_EIGHT
# asm 1: mulsd EIGHT_EIGHT,<0t21=int6464#13
# asm 2: mulsd EIGHT_EIGHT,<0t21=%xmm12
mov EIGHT_EIGHT@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: float6464 0r3[0] -= 0t21[0]
# asm 1: subsd <0t21=int6464#13,<0r3=int6464#1
# asm 2: subsd <0t21=%xmm12,<0r3=%xmm0
subsd %xmm12,%xmm0

# qhasm: *(float64 *)(0mysp + 24) = 0r3[0]
# asm 1: movlpd <0r3=int6464#1,24(<0mysp=int64#4)
# asm 2: movlpd <0r3=%xmm0,24(<0mysp=%rcx)
movlpd %xmm0,24(%rcx)

# qhasm: 0r6[0] = *(float64 *)(0mysp + 48)
# asm 1: movlpd 48(<0mysp=int64#4),>0r6=int6464#1
# asm 2: movlpd 48(<0mysp=%rcx),>0r6=%xmm0
movlpd 48(%rcx),%xmm0

# qhasm: 0t12 = 0r12
# asm 1: movdqa <0r12=int6464#2,>0t12=int6464#13
# asm 2: movdqa <0r12=%xmm1,>0t12=%xmm12
movdqa %xmm1,%xmm12

# qhasm: float6464 0t12[0] *= FOUR_FOUR
# asm 1: mulsd FOUR_FOUR,<0t12=int6464#13
# asm 2: mulsd FOUR_FOUR,<0t12=%xmm12
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: float6464 0r6[0] -= 0t12[0]
# asm 1: subsd <0t12=int6464#13,<0r6=int6464#1
# asm 2: subsd <0t12=%xmm12,<0r6=%xmm0
subsd %xmm12,%xmm0

# qhasm: 0t15 = 0r15
# asm 1: movdqa <0r15=int6464#5,>0t15=int6464#13
# asm 2: movdqa <0r15=%xmm4,>0t15=%xmm12
movdqa %xmm4,%xmm12

# qhasm: float6464 0t15[0] *= EIGHTEEN_EIGHTEEN
# asm 1: mulsd EIGHTEEN_EIGHTEEN,<0t15=int6464#13
# asm 2: mulsd EIGHTEEN_EIGHTEEN,<0t15=%xmm12
mov EIGHTEEN_EIGHTEEN@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: float6464 0r6[0] += 0t15[0]
# asm 1: addsd <0t15=int6464#13,<0r6=int6464#1
# asm 2: addsd <0t15=%xmm12,<0r6=%xmm0
addsd %xmm12,%xmm0

# qhasm: 0t18 = 0r18
# asm 1: movdqa <0r18=int6464#8,>0t18=int6464#13
# asm 2: movdqa <0r18=%xmm7,>0t18=%xmm12
movdqa %xmm7,%xmm12

# qhasm: float6464 0t18[0] *= THREE_THREE
# asm 1: mulsd THREE_THREE,<0t18=int6464#13
# asm 2: mulsd THREE_THREE,<0t18=%xmm12
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: float6464 0r6[0] -= 0t18[0]
# asm 1: subsd <0t18=int6464#13,<0r6=int6464#1
# asm 2: subsd <0t18=%xmm12,<0r6=%xmm0
subsd %xmm12,%xmm0

# qhasm: 0t21 = 0r21
# asm 1: movdqa <0r21=int6464#11,>0t21=int6464#13
# asm 2: movdqa <0r21=%xmm10,>0t21=%xmm12
movdqa %xmm10,%xmm12

# qhasm: float6464 0t21[0] *= THIRTY_THIRTY
# asm 1: mulsd THIRTY_THIRTY,<0t21=int6464#13
# asm 2: mulsd THIRTY_THIRTY,<0t21=%xmm12
mov THIRTY_THIRTY@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm12

# qhasm: float6464 0r6[0] -= 0t21[0]
# asm 1: subsd <0t21=int6464#13,<0r6=int6464#1
# asm 2: subsd <0t21=%xmm12,<0r6=%xmm0
subsd %xmm12,%xmm0

# qhasm: *(float64 *)(0mysp + 48) = 0r6[0]
# asm 1: movlpd <0r6=int6464#1,48(<0mysp=int64#4)
# asm 2: movlpd <0r6=%xmm0,48(<0mysp=%rcx)
movlpd %xmm0,48(%rcx)

# qhasm: 0r9[0] = *(float64 *)(0mysp + 72)
# asm 1: movlpd 72(<0mysp=int64#4),>0r9=int6464#1
# asm 2: movlpd 72(<0mysp=%rcx),>0r9=%xmm0
movlpd 72(%rcx),%xmm0

# qhasm: float6464 0r9[0] -= 0r12[0]
# asm 1: subsd <0r12=int6464#2,<0r9=int6464#1
# asm 2: subsd <0r12=%xmm1,<0r9=%xmm0
subsd %xmm1,%xmm0

# qhasm: 0t15 = 0r15
# asm 1: movdqa <0r15=int6464#5,>0t15=int6464#2
# asm 2: movdqa <0r15=%xmm4,>0t15=%xmm1
movdqa %xmm4,%xmm1

# qhasm: float6464 0t15[0] *= TWO_TWO
# asm 1: mulsd TWO_TWO,<0t15=int6464#2
# asm 2: mulsd TWO_TWO,<0t15=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r9[0] += 0t15[0]
# asm 1: addsd <0t15=int6464#2,<0r9=int6464#1
# asm 2: addsd <0t15=%xmm1,<0r9=%xmm0
addsd %xmm1,%xmm0

# qhasm: float6464 0r9[0] += 0r18[0]
# asm 1: addsd <0r18=int6464#8,<0r9=int6464#1
# asm 2: addsd <0r18=%xmm7,<0r9=%xmm0
addsd %xmm7,%xmm0

# qhasm: 0t21 = 0r21
# asm 1: movdqa <0r21=int6464#11,>0t21=int6464#2
# asm 2: movdqa <0r21=%xmm10,>0t21=%xmm1
movdqa %xmm10,%xmm1

# qhasm: float6464 0t21[0] *= NINE_NINE
# asm 1: mulsd NINE_NINE,<0t21=int6464#2
# asm 2: mulsd NINE_NINE,<0t21=%xmm1
mov NINE_NINE@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r9[0] -= 0t21[0]
# asm 1: subsd <0t21=int6464#2,<0r9=int6464#1
# asm 2: subsd <0t21=%xmm1,<0r9=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(float64 *)(0mysp + 72) = 0r9[0]
# asm 1: movlpd <0r9=int6464#1,72(<0mysp=int64#4)
# asm 2: movlpd <0r9=%xmm0,72(<0mysp=%rcx)
movlpd %xmm0,72(%rcx)

# qhasm: 0r1[0] = *(float64 *)(0mysp + 8)
# asm 1: movlpd 8(<0mysp=int64#4),>0r1=int6464#1
# asm 2: movlpd 8(<0mysp=%rcx),>0r1=%xmm0
movlpd 8(%rcx),%xmm0

# qhasm: float6464 0r1[0] -= 0r13[0]
# asm 1: subsd <0r13=int6464#3,<0r1=int6464#1
# asm 2: subsd <0r13=%xmm2,<0r1=%xmm0
subsd %xmm2,%xmm0

# qhasm: float6464 0r1[0] += 0r16[0]
# asm 1: addsd <0r16=int6464#6,<0r1=int6464#1
# asm 2: addsd <0r16=%xmm5,<0r1=%xmm0
addsd %xmm5,%xmm0

# qhasm: 0t19 = 0r19
# asm 1: movdqa <0r19=int6464#9,>0t19=int6464#2
# asm 2: movdqa <0r19=%xmm8,>0t19=%xmm1
movdqa %xmm8,%xmm1

# qhasm: float6464 0t19[0] *= TWO_TWO
# asm 1: mulsd TWO_TWO,<0t19=int6464#2
# asm 2: mulsd TWO_TWO,<0t19=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r1[0] -= 0t19[0]
# asm 1: subsd <0t19=int6464#2,<0r1=int6464#1
# asm 2: subsd <0t19=%xmm1,<0r1=%xmm0
subsd %xmm1,%xmm0

# qhasm: float6464 0r1[0] -= 0r22[0]
# asm 1: subsd <0r22=int6464#12,<0r1=int6464#1
# asm 2: subsd <0r22=%xmm11,<0r1=%xmm0
subsd %xmm11,%xmm0

# qhasm: *(float64 *)(0mysp + 8) = 0r1[0]
# asm 1: movlpd <0r1=int6464#1,8(<0mysp=int64#4)
# asm 2: movlpd <0r1=%xmm0,8(<0mysp=%rcx)
movlpd %xmm0,8(%rcx)

# qhasm: 0r4[0] = *(float64 *)(0mysp + 32)
# asm 1: movlpd 32(<0mysp=int64#4),>0r4=int6464#1
# asm 2: movlpd 32(<0mysp=%rcx),>0r4=%xmm0
movlpd 32(%rcx),%xmm0

# qhasm: 0t13 = 0r13
# asm 1: movdqa <0r13=int6464#3,>0t13=int6464#2
# asm 2: movdqa <0r13=%xmm2,>0t13=%xmm1
movdqa %xmm2,%xmm1

# qhasm: float6464 0t13[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0t13=int6464#2
# asm 2: mulsd SIX_SIX,<0t13=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r4[0] -= 0t13[0]
# asm 1: subsd <0t13=int6464#2,<0r4=int6464#1
# asm 2: subsd <0t13=%xmm1,<0r4=%xmm0
subsd %xmm1,%xmm0

# qhasm: 0t16 = 0r16
# asm 1: movdqa <0r16=int6464#6,>0t16=int6464#2
# asm 2: movdqa <0r16=%xmm5,>0t16=%xmm1
movdqa %xmm5,%xmm1

# qhasm: float6464 0t16[0] *= FIVE_FIVE
# asm 1: mulsd FIVE_FIVE,<0t16=int6464#2
# asm 2: mulsd FIVE_FIVE,<0t16=%xmm1
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r4[0] += 0t16[0]
# asm 1: addsd <0t16=int6464#2,<0r4=int6464#1
# asm 2: addsd <0t16=%xmm1,<0r4=%xmm0
addsd %xmm1,%xmm0

# qhasm: 0t19 = 0r19
# asm 1: movdqa <0r19=int6464#9,>0t19=int6464#2
# asm 2: movdqa <0r19=%xmm8,>0t19=%xmm1
movdqa %xmm8,%xmm1

# qhasm: float6464 0t19 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0t19=int6464#2
# asm 2: mulpd SIX_SIX,<0t19=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r4[0] -= 0t19[0]
# asm 1: subsd <0t19=int6464#2,<0r4=int6464#1
# asm 2: subsd <0t19=%xmm1,<0r4=%xmm0
subsd %xmm1,%xmm0

# qhasm: 0t22 = 0r22
# asm 1: movdqa <0r22=int6464#12,>0t22=int6464#2
# asm 2: movdqa <0r22=%xmm11,>0t22=%xmm1
movdqa %xmm11,%xmm1

# qhasm: float6464 0t22[0] *= EIGHT_EIGHT
# asm 1: mulsd EIGHT_EIGHT,<0t22=int6464#2
# asm 2: mulsd EIGHT_EIGHT,<0t22=%xmm1
mov EIGHT_EIGHT@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r4[0] -= 0t22[0]
# asm 1: subsd <0t22=int6464#2,<0r4=int6464#1
# asm 2: subsd <0t22=%xmm1,<0r4=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(float64 *)(0mysp + 32) = 0r4[0]
# asm 1: movlpd <0r4=int6464#1,32(<0mysp=int64#4)
# asm 2: movlpd <0r4=%xmm0,32(<0mysp=%rcx)
movlpd %xmm0,32(%rcx)

# qhasm: 0r7[0] = *(float64 *)(0mysp + 56)
# asm 1: movlpd 56(<0mysp=int64#4),>0r7=int6464#1
# asm 2: movlpd 56(<0mysp=%rcx),>0r7=%xmm0
movlpd 56(%rcx),%xmm0

# qhasm: 0t13 = 0r13
# asm 1: movdqa <0r13=int6464#3,>0t13=int6464#2
# asm 2: movdqa <0r13=%xmm2,>0t13=%xmm1
movdqa %xmm2,%xmm1

# qhasm: float6464 0t13[0] *= FOUR_FOUR
# asm 1: mulsd FOUR_FOUR,<0t13=int6464#2
# asm 2: mulsd FOUR_FOUR,<0t13=%xmm1
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r7[0] -= 0t13[0]
# asm 1: subsd <0t13=int6464#2,<0r7=int6464#1
# asm 2: subsd <0t13=%xmm1,<0r7=%xmm0
subsd %xmm1,%xmm0

# qhasm: 0t16 = 0r16
# asm 1: movdqa <0r16=int6464#6,>0t16=int6464#2
# asm 2: movdqa <0r16=%xmm5,>0t16=%xmm1
movdqa %xmm5,%xmm1

# qhasm: float6464 0t16[0] *= THREE_THREE
# asm 1: mulsd THREE_THREE,<0t16=int6464#2
# asm 2: mulsd THREE_THREE,<0t16=%xmm1
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r7[0] += 0t16[0]
# asm 1: addsd <0t16=int6464#2,<0r7=int6464#1
# asm 2: addsd <0t16=%xmm1,<0r7=%xmm0
addsd %xmm1,%xmm0

# qhasm: 0t19 = 0r19
# asm 1: movdqa <0r19=int6464#9,>0t19=int6464#2
# asm 2: movdqa <0r19=%xmm8,>0t19=%xmm1
movdqa %xmm8,%xmm1

# qhasm: float6464 0t19[0] *= THREE_THREE
# asm 1: mulsd THREE_THREE,<0t19=int6464#2
# asm 2: mulsd THREE_THREE,<0t19=%xmm1
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r7[0] -= 0t19[0]
# asm 1: subsd <0t19=int6464#2,<0r7=int6464#1
# asm 2: subsd <0t19=%xmm1,<0r7=%xmm0
subsd %xmm1,%xmm0

# qhasm: 0t22 = 0r22
# asm 1: movdqa <0r22=int6464#12,>0t22=int6464#2
# asm 2: movdqa <0r22=%xmm11,>0t22=%xmm1
movdqa %xmm11,%xmm1

# qhasm: float6464 0t22[0] *= FIVE_FIVE
# asm 1: mulsd FIVE_FIVE,<0t22=int6464#2
# asm 2: mulsd FIVE_FIVE,<0t22=%xmm1
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r7[0] -= 0t22[0]
# asm 1: subsd <0t22=int6464#2,<0r7=int6464#1
# asm 2: subsd <0t22=%xmm1,<0r7=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(float64 *)(0mysp + 56) = 0r7[0]
# asm 1: movlpd <0r7=int6464#1,56(<0mysp=int64#4)
# asm 2: movlpd <0r7=%xmm0,56(<0mysp=%rcx)
movlpd %xmm0,56(%rcx)

# qhasm: 0r10[0] = *(float64 *)(0mysp + 80)
# asm 1: movlpd 80(<0mysp=int64#4),>0r10=int6464#1
# asm 2: movlpd 80(<0mysp=%rcx),>0r10=%xmm0
movlpd 80(%rcx),%xmm0

# qhasm: 0t13 = 0r13
# asm 1: movdqa <0r13=int6464#3,>0t13=int6464#2
# asm 2: movdqa <0r13=%xmm2,>0t13=%xmm1
movdqa %xmm2,%xmm1

# qhasm: float6464 0t13[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0t13=int6464#2
# asm 2: mulsd SIX_SIX,<0t13=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r10[0] -= 0t13[0]
# asm 1: subsd <0t13=int6464#2,<0r10=int6464#1
# asm 2: subsd <0t13=%xmm1,<0r10=%xmm0
subsd %xmm1,%xmm0

# qhasm: 0t16 = 0r16
# asm 1: movdqa <0r16=int6464#6,>0t16=int6464#2
# asm 2: movdqa <0r16=%xmm5,>0t16=%xmm1
movdqa %xmm5,%xmm1

# qhasm: float6464 0t16[0] *= TWO_TWO
# asm 1: mulsd TWO_TWO,<0t16=int6464#2
# asm 2: mulsd TWO_TWO,<0t16=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r10[0] += 0t16[0]
# asm 1: addsd <0t16=int6464#2,<0r10=int6464#1
# asm 2: addsd <0t16=%xmm1,<0r10=%xmm0
addsd %xmm1,%xmm0

# qhasm: 0t19 = 0r19
# asm 1: movdqa <0r19=int6464#9,>0t19=int6464#2
# asm 2: movdqa <0r19=%xmm8,>0t19=%xmm1
movdqa %xmm8,%xmm1

# qhasm: float6464 0t19[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0t19=int6464#2
# asm 2: mulsd SIX_SIX,<0t19=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r10[0] += 0t19[0]
# asm 1: addsd <0t19=int6464#2,<0r10=int6464#1
# asm 2: addsd <0t19=%xmm1,<0r10=%xmm0
addsd %xmm1,%xmm0

# qhasm: 0t22 = 0r22
# asm 1: movdqa <0r22=int6464#12,>0t22=int6464#2
# asm 2: movdqa <0r22=%xmm11,>0t22=%xmm1
movdqa %xmm11,%xmm1

# qhasm: float6464 0t22[0] *= NINE_NINE
# asm 1: mulsd NINE_NINE,<0t22=int6464#2
# asm 2: mulsd NINE_NINE,<0t22=%xmm1
mov NINE_NINE@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r10[0] -= 0t22[0]
# asm 1: subsd <0t22=int6464#2,<0r10=int6464#1
# asm 2: subsd <0t22=%xmm1,<0r10=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(float64 *)(0mysp + 80) = 0r10[0]
# asm 1: movlpd <0r10=int6464#1,80(<0mysp=int64#4)
# asm 2: movlpd <0r10=%xmm0,80(<0mysp=%rcx)
movlpd %xmm0,80(%rcx)

# qhasm: 0r2[0] = *(float64 *)(0mysp + 16)
# asm 1: movlpd 16(<0mysp=int64#4),>0r2=int6464#1
# asm 2: movlpd 16(<0mysp=%rcx),>0r2=%xmm0
movlpd 16(%rcx),%xmm0

# qhasm: float6464 0r2[0] -= 0r14[0]
# asm 1: subsd <0r14=int6464#4,<0r2=int6464#1
# asm 2: subsd <0r14=%xmm3,<0r2=%xmm0
subsd %xmm3,%xmm0

# qhasm: float6464 0r2[0] += 0r17[0]
# asm 1: addsd <0r17=int6464#7,<0r2=int6464#1
# asm 2: addsd <0r17=%xmm6,<0r2=%xmm0
addsd %xmm6,%xmm0

# qhasm: 0t20 = 0r20
# asm 1: movdqa <0r20=int6464#10,>0t20=int6464#2
# asm 2: movdqa <0r20=%xmm9,>0t20=%xmm1
movdqa %xmm9,%xmm1

# qhasm: float6464 0t20[0] *= TWO_TWO
# asm 1: mulsd TWO_TWO,<0t20=int6464#2
# asm 2: mulsd TWO_TWO,<0t20=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r2[0] -= 0t20[0]
# asm 1: subsd <0t20=int6464#2,<0r2=int6464#1
# asm 2: subsd <0t20=%xmm1,<0r2=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(float64 *)(0mysp + 16) = 0r2[0]
# asm 1: movlpd <0r2=int6464#1,16(<0mysp=int64#4)
# asm 2: movlpd <0r2=%xmm0,16(<0mysp=%rcx)
movlpd %xmm0,16(%rcx)

# qhasm: 0r5[0] = *(float64 *)(0mysp + 40)
# asm 1: movlpd 40(<0mysp=int64#4),>0r5=int6464#1
# asm 2: movlpd 40(<0mysp=%rcx),>0r5=%xmm0
movlpd 40(%rcx),%xmm0

# qhasm: 0t14 = 0r14
# asm 1: movdqa <0r14=int6464#4,>0t14=int6464#2
# asm 2: movdqa <0r14=%xmm3,>0t14=%xmm1
movdqa %xmm3,%xmm1

# qhasm: float6464 0t14[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0t14=int6464#2
# asm 2: mulsd SIX_SIX,<0t14=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r5[0] -= 0t14[0]
# asm 1: subsd <0t14=int6464#2,<0r5=int6464#1
# asm 2: subsd <0t14=%xmm1,<0r5=%xmm0
subsd %xmm1,%xmm0

# qhasm: 0t17 = 0r17
# asm 1: movdqa <0r17=int6464#7,>0t17=int6464#2
# asm 2: movdqa <0r17=%xmm6,>0t17=%xmm1
movdqa %xmm6,%xmm1

# qhasm: float6464 0t17[0] *= FIVE_FIVE
# asm 1: mulsd FIVE_FIVE,<0t17=int6464#2
# asm 2: mulsd FIVE_FIVE,<0t17=%xmm1
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r5[0] += 0t17[0]
# asm 1: addsd <0t17=int6464#2,<0r5=int6464#1
# asm 2: addsd <0t17=%xmm1,<0r5=%xmm0
addsd %xmm1,%xmm0

# qhasm: 0t20 = 0r20
# asm 1: movdqa <0r20=int6464#10,>0t20=int6464#2
# asm 2: movdqa <0r20=%xmm9,>0t20=%xmm1
movdqa %xmm9,%xmm1

# qhasm: float6464 0t20[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0t20=int6464#2
# asm 2: mulsd SIX_SIX,<0t20=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r5[0] -= 0t20[0]
# asm 1: subsd <0t20=int6464#2,<0r5=int6464#1
# asm 2: subsd <0t20=%xmm1,<0r5=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(float64 *)(0mysp + 40) = 0r5[0]
# asm 1: movlpd <0r5=int6464#1,40(<0mysp=int64#4)
# asm 2: movlpd <0r5=%xmm0,40(<0mysp=%rcx)
movlpd %xmm0,40(%rcx)

# qhasm: 0r8[0] = *(float64 *)(0mysp + 64)
# asm 1: movlpd 64(<0mysp=int64#4),>0r8=int6464#1
# asm 2: movlpd 64(<0mysp=%rcx),>0r8=%xmm0
movlpd 64(%rcx),%xmm0

# qhasm: 0t14 = 0r14
# asm 1: movdqa <0r14=int6464#4,>0t14=int6464#2
# asm 2: movdqa <0r14=%xmm3,>0t14=%xmm1
movdqa %xmm3,%xmm1

# qhasm: float6464 0t14[0] *= FOUR_FOUR
# asm 1: mulsd FOUR_FOUR,<0t14=int6464#2
# asm 2: mulsd FOUR_FOUR,<0t14=%xmm1
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r8[0] -= 0t14[0]
# asm 1: subsd <0t14=int6464#2,<0r8=int6464#1
# asm 2: subsd <0t14=%xmm1,<0r8=%xmm0
subsd %xmm1,%xmm0

# qhasm: 0t17 = 0r17
# asm 1: movdqa <0r17=int6464#7,>0t17=int6464#2
# asm 2: movdqa <0r17=%xmm6,>0t17=%xmm1
movdqa %xmm6,%xmm1

# qhasm: float6464 0t17[0] *= THREE_THREE
# asm 1: mulsd THREE_THREE,<0t17=int6464#2
# asm 2: mulsd THREE_THREE,<0t17=%xmm1
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r8[0] += 0t17[0]
# asm 1: addsd <0t17=int6464#2,<0r8=int6464#1
# asm 2: addsd <0t17=%xmm1,<0r8=%xmm0
addsd %xmm1,%xmm0

# qhasm: 0t20 = 0r20
# asm 1: movdqa <0r20=int6464#10,>0t20=int6464#2
# asm 2: movdqa <0r20=%xmm9,>0t20=%xmm1
movdqa %xmm9,%xmm1

# qhasm: float6464 0t20[0] *= THREE_THREE
# asm 1: mulsd THREE_THREE,<0t20=int6464#2
# asm 2: mulsd THREE_THREE,<0t20=%xmm1
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r8[0] -= 0t20[0]
# asm 1: subsd <0t20=int6464#2,<0r8=int6464#1
# asm 2: subsd <0t20=%xmm1,<0r8=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(float64 *)(0mysp + 64) = 0r8[0]
# asm 1: movlpd <0r8=int6464#1,64(<0mysp=int64#4)
# asm 2: movlpd <0r8=%xmm0,64(<0mysp=%rcx)
movlpd %xmm0,64(%rcx)

# qhasm: 0r11[0] = *(float64 *)(0mysp + 88)
# asm 1: movlpd 88(<0mysp=int64#4),>0r11=int6464#1
# asm 2: movlpd 88(<0mysp=%rcx),>0r11=%xmm0
movlpd 88(%rcx),%xmm0

# qhasm: 0t14 = 0r14
# asm 1: movdqa <0r14=int6464#4,>0t14=int6464#2
# asm 2: movdqa <0r14=%xmm3,>0t14=%xmm1
movdqa %xmm3,%xmm1

# qhasm: float6464 0t14[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0t14=int6464#2
# asm 2: mulsd SIX_SIX,<0t14=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r11[0] -= 0t14[0]
# asm 1: subsd <0t14=int6464#2,<0r11=int6464#1
# asm 2: subsd <0t14=%xmm1,<0r11=%xmm0
subsd %xmm1,%xmm0

# qhasm: 0t17 = 0r17
# asm 1: movdqa <0r17=int6464#7,>0t17=int6464#2
# asm 2: movdqa <0r17=%xmm6,>0t17=%xmm1
movdqa %xmm6,%xmm1

# qhasm: float6464 0t17[0] *= TWO_TWO
# asm 1: mulsd TWO_TWO,<0t17=int6464#2
# asm 2: mulsd TWO_TWO,<0t17=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r11[0] += 0t17[0]
# asm 1: addsd <0t17=int6464#2,<0r11=int6464#1
# asm 2: addsd <0t17=%xmm1,<0r11=%xmm0
addsd %xmm1,%xmm0

# qhasm: 0t20 = 0r20
# asm 1: movdqa <0r20=int6464#10,>0t20=int6464#2
# asm 2: movdqa <0r20=%xmm9,>0t20=%xmm1
movdqa %xmm9,%xmm1

# qhasm: float6464 0t20[0] *= SIX_SIX
# asm 1: mulsd SIX_SIX,<0t20=int6464#2
# asm 2: mulsd SIX_SIX,<0t20=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm1

# qhasm: float6464 0r11[0] += 0t20[0]
# asm 1: addsd <0t20=int6464#2,<0r11=int6464#1
# asm 2: addsd <0t20=%xmm1,<0r11=%xmm0
addsd %xmm1,%xmm0

# qhasm: *(float64 *)(0mysp + 88) = 0r11[0]
# asm 1: movlpd <0r11=int6464#1,88(<0mysp=int64#4)
# asm 2: movlpd <0r11=%xmm0,88(<0mysp=%rcx)
movlpd %xmm0,88(%rcx)

# qhasm: int6464 0round

# qhasm: int6464 0carry

# qhasm: int6464 1t6

# qhasm: r0[0] = *(float64 *)(0mysp + 0)
# asm 1: movlpd 0(<0mysp=int64#4),>r0=int6464#1
# asm 2: movlpd 0(<0mysp=%rcx),>r0=%xmm0
movlpd 0(%rcx),%xmm0

# qhasm: r1[0] = *(float64 *)(0mysp + 8)
# asm 1: movlpd 8(<0mysp=int64#4),>r1=int6464#2
# asm 2: movlpd 8(<0mysp=%rcx),>r1=%xmm1
movlpd 8(%rcx),%xmm1

# qhasm: r2[0] = *(float64 *)(0mysp + 16)
# asm 1: movlpd 16(<0mysp=int64#4),>r2=int6464#3
# asm 2: movlpd 16(<0mysp=%rcx),>r2=%xmm2
movlpd 16(%rcx),%xmm2

# qhasm: r3[0] = *(float64 *)(0mysp + 24)
# asm 1: movlpd 24(<0mysp=int64#4),>r3=int6464#4
# asm 2: movlpd 24(<0mysp=%rcx),>r3=%xmm3
movlpd 24(%rcx),%xmm3

# qhasm: r4[0] = *(float64 *)(0mysp + 32)
# asm 1: movlpd 32(<0mysp=int64#4),>r4=int6464#5
# asm 2: movlpd 32(<0mysp=%rcx),>r4=%xmm4
movlpd 32(%rcx),%xmm4

# qhasm: r5[0] = *(float64 *)(0mysp + 40)
# asm 1: movlpd 40(<0mysp=int64#4),>r5=int6464#6
# asm 2: movlpd 40(<0mysp=%rcx),>r5=%xmm5
movlpd 40(%rcx),%xmm5

# qhasm: r6[0] = *(float64 *)(0mysp + 48)
# asm 1: movlpd 48(<0mysp=int64#4),>r6=int6464#7
# asm 2: movlpd 48(<0mysp=%rcx),>r6=%xmm6
movlpd 48(%rcx),%xmm6

# qhasm: r7[0] = *(float64 *)(0mysp + 56)
# asm 1: movlpd 56(<0mysp=int64#4),>r7=int6464#8
# asm 2: movlpd 56(<0mysp=%rcx),>r7=%xmm7
movlpd 56(%rcx),%xmm7

# qhasm: r8[0] = *(float64 *)(0mysp + 64)
# asm 1: movlpd 64(<0mysp=int64#4),>r8=int6464#9
# asm 2: movlpd 64(<0mysp=%rcx),>r8=%xmm8
movlpd 64(%rcx),%xmm8

# qhasm: r9[0] = *(float64 *)(0mysp + 72)
# asm 1: movlpd 72(<0mysp=int64#4),>r9=int6464#10
# asm 2: movlpd 72(<0mysp=%rcx),>r9=%xmm9
movlpd 72(%rcx),%xmm9

# qhasm: r10[0] = *(float64 *)(0mysp + 80)
# asm 1: movlpd 80(<0mysp=int64#4),>r10=int6464#11
# asm 2: movlpd 80(<0mysp=%rcx),>r10=%xmm10
movlpd 80(%rcx),%xmm10

# qhasm: r11[0] = *(float64 *)(0mysp + 88)
# asm 1: movlpd 88(<0mysp=int64#4),>r11=int6464#12
# asm 2: movlpd 88(<0mysp=%rcx),>r11=%xmm11
movlpd 88(%rcx),%xmm11

# qhasm: 0round = ROUND_ROUND
# asm 1: movdqa ROUND_ROUND,<0round=int6464#13
# asm 2: movdqa ROUND_ROUND,<0round=%xmm12
mov ROUND_ROUND@GOTPCREL(%rip), %rbp
movdqa (%rbp),%xmm12

# qhasm: 0carry = r1
# asm 1: movdqa <r1=int6464#2,>0carry=int6464#14
# asm 2: movdqa <r1=%xmm1,>0carry=%xmm13
movdqa %xmm1,%xmm13

# qhasm: float6464 0carry[0] *= VINV_VINV
# asm 1: mulsd VINV_VINV,<0carry=int6464#14
# asm 2: mulsd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r2[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r2=int6464#3
# asm 2: addsd <0carry=%xmm13,<r2=%xmm2
addsd %xmm13,%xmm2

# qhasm: float6464 0carry[0] *= V_V
# asm 1: mulsd V_V,<0carry=int6464#14
# asm 2: mulsd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r1[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r1=int6464#2
# asm 2: subsd <0carry=%xmm13,<r1=%xmm1
subsd %xmm13,%xmm1

# qhasm: 0carry = r4
# asm 1: movdqa <r4=int6464#5,>0carry=int6464#14
# asm 2: movdqa <r4=%xmm4,>0carry=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0carry[0] *= VINV_VINV
# asm 1: mulsd VINV_VINV,<0carry=int6464#14
# asm 2: mulsd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r5[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r5=int6464#6
# asm 2: addsd <0carry=%xmm13,<r5=%xmm5
addsd %xmm13,%xmm5

# qhasm: float6464 0carry[0] *= V_V
# asm 1: mulsd V_V,<0carry=int6464#14
# asm 2: mulsd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r4[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r4=int6464#5
# asm 2: subsd <0carry=%xmm13,<r4=%xmm4
subsd %xmm13,%xmm4

# qhasm: 0carry = r7
# asm 1: movdqa <r7=int6464#8,>0carry=int6464#14
# asm 2: movdqa <r7=%xmm7,>0carry=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 0carry[0] *= VINV_VINV
# asm 1: mulsd VINV_VINV,<0carry=int6464#14
# asm 2: mulsd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r8[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r8=int6464#9
# asm 2: addsd <0carry=%xmm13,<r8=%xmm8
addsd %xmm13,%xmm8

# qhasm: float6464 0carry[0] *= V_V
# asm 1: mulsd V_V,<0carry=int6464#14
# asm 2: mulsd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r7[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r7=int6464#8
# asm 2: subsd <0carry=%xmm13,<r7=%xmm7
subsd %xmm13,%xmm7

# qhasm: 0carry = r10
# asm 1: movdqa <r10=int6464#11,>0carry=int6464#14
# asm 2: movdqa <r10=%xmm10,>0carry=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 0carry[0] *= VINV_VINV
# asm 1: mulsd VINV_VINV,<0carry=int6464#14
# asm 2: mulsd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r11[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r11=int6464#12
# asm 2: addsd <0carry=%xmm13,<r11=%xmm11
addsd %xmm13,%xmm11

# qhasm: float6464 0carry[0] *= V_V
# asm 1: mulsd V_V,<0carry=int6464#14
# asm 2: mulsd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r10[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r10=int6464#11
# asm 2: subsd <0carry=%xmm13,<r10=%xmm10
subsd %xmm13,%xmm10

# qhasm: 0carry = r2
# asm 1: movdqa <r2=int6464#3,>0carry=int6464#14
# asm 2: movdqa <r2=%xmm2,>0carry=%xmm13
movdqa %xmm2,%xmm13

# qhasm: float6464 0carry[0] *= VINV_VINV
# asm 1: mulsd VINV_VINV,<0carry=int6464#14
# asm 2: mulsd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r3[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r3=int6464#4
# asm 2: addsd <0carry=%xmm13,<r3=%xmm3
addsd %xmm13,%xmm3

# qhasm: float6464 0carry[0] *= V_V
# asm 1: mulsd V_V,<0carry=int6464#14
# asm 2: mulsd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r2[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r2=int6464#3
# asm 2: subsd <0carry=%xmm13,<r2=%xmm2
subsd %xmm13,%xmm2

# qhasm: 0carry = r5
# asm 1: movdqa <r5=int6464#6,>0carry=int6464#14
# asm 2: movdqa <r5=%xmm5,>0carry=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0carry[0] *= VINV_VINV
# asm 1: mulsd VINV_VINV,<0carry=int6464#14
# asm 2: mulsd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r6[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r6=int6464#7
# asm 2: addsd <0carry=%xmm13,<r6=%xmm6
addsd %xmm13,%xmm6

# qhasm: float6464 0carry[0] *= V_V
# asm 1: mulsd V_V,<0carry=int6464#14
# asm 2: mulsd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r5[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r5=int6464#6
# asm 2: subsd <0carry=%xmm13,<r5=%xmm5
subsd %xmm13,%xmm5

# qhasm: 0carry = r8
# asm 1: movdqa <r8=int6464#9,>0carry=int6464#14
# asm 2: movdqa <r8=%xmm8,>0carry=%xmm13
movdqa %xmm8,%xmm13

# qhasm: float6464 0carry[0] *= VINV_VINV
# asm 1: mulsd VINV_VINV,<0carry=int6464#14
# asm 2: mulsd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r9[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r9=int6464#10
# asm 2: addsd <0carry=%xmm13,<r9=%xmm9
addsd %xmm13,%xmm9

# qhasm: float6464 0carry[0] *= V_V
# asm 1: mulsd V_V,<0carry=int6464#14
# asm 2: mulsd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r8[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r8=int6464#9
# asm 2: subsd <0carry=%xmm13,<r8=%xmm8
subsd %xmm13,%xmm8

# qhasm: 0carry = r11
# asm 1: movdqa <r11=int6464#12,>0carry=int6464#14
# asm 2: movdqa <r11=%xmm11,>0carry=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 0carry[0] *= VINV_VINV
# asm 1: mulsd VINV_VINV,<0carry=int6464#14
# asm 2: mulsd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r0[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r0=int6464#1
# asm 2: subsd <0carry=%xmm13,<r0=%xmm0
subsd %xmm13,%xmm0

# qhasm: float6464 r3[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r3=int6464#4
# asm 2: subsd <0carry=%xmm13,<r3=%xmm3
subsd %xmm13,%xmm3

# qhasm: 1t6 = 0carry
# asm 1: movdqa <0carry=int6464#14,>1t6=int6464#15
# asm 2: movdqa <0carry=%xmm13,>1t6=%xmm14
movdqa %xmm13,%xmm14

# qhasm: float6464 1t6[0] *= FOUR_FOUR
# asm 1: mulsd FOUR_FOUR,<1t6=int6464#15
# asm 2: mulsd FOUR_FOUR,<1t6=%xmm14
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm14

# qhasm: float6464 r6[0] -= 1t6[0]
# asm 1: subsd <1t6=int6464#15,<r6=int6464#7
# asm 2: subsd <1t6=%xmm14,<r6=%xmm6
subsd %xmm14,%xmm6

# qhasm: float6464 r9[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r9=int6464#10
# asm 2: subsd <0carry=%xmm13,<r9=%xmm9
subsd %xmm13,%xmm9

# qhasm: float6464 0carry[0] *= V_V
# asm 1: mulsd V_V,<0carry=int6464#14
# asm 2: mulsd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r11[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r11=int6464#12
# asm 2: subsd <0carry=%xmm13,<r11=%xmm11
subsd %xmm13,%xmm11

# qhasm: 0carry = r0
# asm 1: movdqa <r0=int6464#1,>0carry=int6464#14
# asm 2: movdqa <r0=%xmm0,>0carry=%xmm13
movdqa %xmm0,%xmm13

# qhasm: float6464 0carry[0] *= V6INV_V6INV
# asm 1: mulsd V6INV_V6INV,<0carry=int6464#14
# asm 2: mulsd V6INV_V6INV,<0carry=%xmm13
mov V6INV_V6INV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r1[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r1=int6464#2
# asm 2: addsd <0carry=%xmm13,<r1=%xmm1
addsd %xmm13,%xmm1

# qhasm: float6464 0carry[0] *= V6_V6
# asm 1: mulsd V6_V6,<0carry=int6464#14
# asm 2: mulsd V6_V6,<0carry=%xmm13
mov V6_V6@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r0[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r0=int6464#1
# asm 2: subsd <0carry=%xmm13,<r0=%xmm0
subsd %xmm13,%xmm0

# qhasm: 0carry = r3
# asm 1: movdqa <r3=int6464#4,>0carry=int6464#14
# asm 2: movdqa <r3=%xmm3,>0carry=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 0carry[0] *= VINV_VINV
# asm 1: mulsd VINV_VINV,<0carry=int6464#14
# asm 2: mulsd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r4[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r4=int6464#5
# asm 2: addsd <0carry=%xmm13,<r4=%xmm4
addsd %xmm13,%xmm4

# qhasm: float6464 0carry[0] *= V_V
# asm 1: mulsd V_V,<0carry=int6464#14
# asm 2: mulsd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r3[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r3=int6464#4
# asm 2: subsd <0carry=%xmm13,<r3=%xmm3
subsd %xmm13,%xmm3

# qhasm: 0carry = r6
# asm 1: movdqa <r6=int6464#7,>0carry=int6464#14
# asm 2: movdqa <r6=%xmm6,>0carry=%xmm13
movdqa %xmm6,%xmm13

# qhasm: float6464 0carry[0] *= V6INV_V6INV
# asm 1: mulsd V6INV_V6INV,<0carry=int6464#14
# asm 2: mulsd V6INV_V6INV,<0carry=%xmm13
mov V6INV_V6INV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r7[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r7=int6464#8
# asm 2: addsd <0carry=%xmm13,<r7=%xmm7
addsd %xmm13,%xmm7

# qhasm: float6464 0carry[0] *= V6_V6
# asm 1: mulsd V6_V6,<0carry=int6464#14
# asm 2: mulsd V6_V6,<0carry=%xmm13
mov V6_V6@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r6[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r6=int6464#7
# asm 2: subsd <0carry=%xmm13,<r6=%xmm6
subsd %xmm13,%xmm6

# qhasm: 0carry = r9
# asm 1: movdqa <r9=int6464#10,>0carry=int6464#14
# asm 2: movdqa <r9=%xmm9,>0carry=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 0carry[0] *= VINV_VINV
# asm 1: mulsd VINV_VINV,<0carry=int6464#14
# asm 2: mulsd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r10[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r10=int6464#11
# asm 2: addsd <0carry=%xmm13,<r10=%xmm10
addsd %xmm13,%xmm10

# qhasm: float6464 0carry[0] *= V_V
# asm 1: mulsd V_V,<0carry=int6464#14
# asm 2: mulsd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r9[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r9=int6464#10
# asm 2: subsd <0carry=%xmm13,<r9=%xmm9
subsd %xmm13,%xmm9

# qhasm: 0carry = r1
# asm 1: movdqa <r1=int6464#2,>0carry=int6464#14
# asm 2: movdqa <r1=%xmm1,>0carry=%xmm13
movdqa %xmm1,%xmm13

# qhasm: float6464 0carry[0] *= VINV_VINV
# asm 1: mulsd VINV_VINV,<0carry=int6464#14
# asm 2: mulsd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r2[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r2=int6464#3
# asm 2: addsd <0carry=%xmm13,<r2=%xmm2
addsd %xmm13,%xmm2

# qhasm: float6464 0carry[0] *= V_V
# asm 1: mulsd V_V,<0carry=int6464#14
# asm 2: mulsd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r1[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r1=int6464#2
# asm 2: subsd <0carry=%xmm13,<r1=%xmm1
subsd %xmm13,%xmm1

# qhasm: 0carry = r4
# asm 1: movdqa <r4=int6464#5,>0carry=int6464#14
# asm 2: movdqa <r4=%xmm4,>0carry=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0carry[0] *= VINV_VINV
# asm 1: mulsd VINV_VINV,<0carry=int6464#14
# asm 2: mulsd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r5[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r5=int6464#6
# asm 2: addsd <0carry=%xmm13,<r5=%xmm5
addsd %xmm13,%xmm5

# qhasm: float6464 0carry[0] *= V_V
# asm 1: mulsd V_V,<0carry=int6464#14
# asm 2: mulsd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r4[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r4=int6464#5
# asm 2: subsd <0carry=%xmm13,<r4=%xmm4
subsd %xmm13,%xmm4

# qhasm: 0carry = r7
# asm 1: movdqa <r7=int6464#8,>0carry=int6464#14
# asm 2: movdqa <r7=%xmm7,>0carry=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 0carry[0] *= VINV_VINV
# asm 1: mulsd VINV_VINV,<0carry=int6464#14
# asm 2: mulsd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r8[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r8=int6464#9
# asm 2: addsd <0carry=%xmm13,<r8=%xmm8
addsd %xmm13,%xmm8

# qhasm: float6464 0carry[0] *= V_V
# asm 1: mulsd V_V,<0carry=int6464#14
# asm 2: mulsd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r7[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r7=int6464#8
# asm 2: subsd <0carry=%xmm13,<r7=%xmm7
subsd %xmm13,%xmm7

# qhasm: 0carry = r10
# asm 1: movdqa <r10=int6464#11,>0carry=int6464#14
# asm 2: movdqa <r10=%xmm10,>0carry=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 0carry[0] *= VINV_VINV
# asm 1: mulsd VINV_VINV,<0carry=int6464#14
# asm 2: mulsd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 0carry[0] += 0round[0]
# asm 1: addsd <0round=int6464#13,<0carry=int6464#14
# asm 2: addsd <0round=%xmm12,<0carry=%xmm13
addsd %xmm12,%xmm13

# qhasm: float6464 0carry[0] -= 0round[0]
# asm 1: subsd <0round=int6464#13,<0carry=int6464#14
# asm 2: subsd <0round=%xmm12,<0carry=%xmm13
subsd %xmm12,%xmm13

# qhasm: float6464 r11[0] += 0carry[0]
# asm 1: addsd <0carry=int6464#14,<r11=int6464#12
# asm 2: addsd <0carry=%xmm13,<r11=%xmm11
addsd %xmm13,%xmm11

# qhasm: float6464 0carry[0] *= V_V
# asm 1: mulsd V_V,<0carry=int6464#14
# asm 2: mulsd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulsd (%rbp),%xmm13

# qhasm: float6464 r10[0] -= 0carry[0]
# asm 1: subsd <0carry=int6464#14,<r10=int6464#11
# asm 2: subsd <0carry=%xmm13,<r10=%xmm10
subsd %xmm13,%xmm10

# qhasm: *(float64 *)(rop +  0) = r0[0]
# asm 1: movlpd <r0=int6464#1,0(<rop=int64#1)
# asm 2: movlpd <r0=%xmm0,0(<rop=%rdi)
movlpd %xmm0,0(%rdi)

# qhasm: *(float64 *)(rop +  8) = r1[0]
# asm 1: movlpd <r1=int6464#2,8(<rop=int64#1)
# asm 2: movlpd <r1=%xmm1,8(<rop=%rdi)
movlpd %xmm1,8(%rdi)

# qhasm: *(float64 *)(rop + 16) = r2[0]
# asm 1: movlpd <r2=int6464#3,16(<rop=int64#1)
# asm 2: movlpd <r2=%xmm2,16(<rop=%rdi)
movlpd %xmm2,16(%rdi)

# qhasm: *(float64 *)(rop + 24) = r3[0]
# asm 1: movlpd <r3=int6464#4,24(<rop=int64#1)
# asm 2: movlpd <r3=%xmm3,24(<rop=%rdi)
movlpd %xmm3,24(%rdi)

# qhasm: *(float64 *)(rop + 32) = r4[0]
# asm 1: movlpd <r4=int6464#5,32(<rop=int64#1)
# asm 2: movlpd <r4=%xmm4,32(<rop=%rdi)
movlpd %xmm4,32(%rdi)

# qhasm: *(float64 *)(rop + 40) = r5[0]
# asm 1: movlpd <r5=int6464#6,40(<rop=int64#1)
# asm 2: movlpd <r5=%xmm5,40(<rop=%rdi)
movlpd %xmm5,40(%rdi)

# qhasm: *(float64 *)(rop + 48) = r6[0]
# asm 1: movlpd <r6=int6464#7,48(<rop=int64#1)
# asm 2: movlpd <r6=%xmm6,48(<rop=%rdi)
movlpd %xmm6,48(%rdi)

# qhasm: *(float64 *)(rop + 56) = r7[0]
# asm 1: movlpd <r7=int6464#8,56(<rop=int64#1)
# asm 2: movlpd <r7=%xmm7,56(<rop=%rdi)
movlpd %xmm7,56(%rdi)

# qhasm: *(float64 *)(rop + 64) = r8[0]
# asm 1: movlpd <r8=int6464#9,64(<rop=int64#1)
# asm 2: movlpd <r8=%xmm8,64(<rop=%rdi)
movlpd %xmm8,64(%rdi)

# qhasm: *(float64 *)(rop + 72) = r9[0]
# asm 1: movlpd <r9=int6464#10,72(<rop=int64#1)
# asm 2: movlpd <r9=%xmm9,72(<rop=%rdi)
movlpd %xmm9,72(%rdi)

# qhasm: *(float64 *)(rop + 80) = r10[0]
# asm 1: movlpd <r10=int6464#11,80(<rop=int64#1)
# asm 2: movlpd <r10=%xmm10,80(<rop=%rdi)
movlpd %xmm10,80(%rdi)

# qhasm: *(float64 *)(rop + 88) = r11[0]
# asm 1: movlpd <r11=int6464#12,88(<rop=int64#1)
# asm 2: movlpd <r11=%xmm11,88(<rop=%rdi)
movlpd %xmm11,88(%rdi)

# qhasm: leave
add %r11,%rsp
mov %rdi,%rax
mov %rsi,%rdx
pop %rbp
ret
