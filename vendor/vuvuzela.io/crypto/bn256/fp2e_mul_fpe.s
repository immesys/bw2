# File:   dclxvi-20130329/fp2e_mul_fpe.s
# Author: Ruben Niederhagen, Peter Schwabe
# Public Domain


# qhasm: enter fp2e_mul_fpe_qhasm
.text
.p2align 5
.globl _fp2e_mul_fpe_qhasm
.globl fp2e_mul_fpe_qhasm
_fp2e_mul_fpe_qhasm:
fp2e_mul_fpe_qhasm:
push %rbp
mov %rsp,%r11
and $31,%r11
add $768,%r11
sub %r11,%rsp

# qhasm: int64 rop

# qhasm: int64 op1

# qhasm: int64 op2

# qhasm: input rop

# qhasm: input op1

# qhasm: input op2

# qhasm: stack6144 0mys

# qhasm: int64 0mysp

# qhasm: 0mysp = &0mys
# asm 1: leaq <0mys=stack6144#1,>0mysp=int64#4
# asm 2: leaq <0mys=0(%rsp),>0mysp=%rcx
leaq 0(%rsp),%rcx

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

# qhasm: int6464 0t

# qhasm: int64 1mysp

# qhasm: int64 0arg1p

# qhasm: 1mysp = 0mysp
# asm 1: mov  <0mysp=int64#4,>1mysp=int64#4
# asm 2: mov  <0mysp=%rcx,>1mysp=%rcx
mov  %rcx,%rcx

# qhasm: 0arg1p = 1mysp+576
# asm 1: lea  576(<1mysp=int64#4),>0arg1p=int64#5
# asm 2: lea  576(<1mysp=%rcx),>0arg1p=%r8
lea  576(%rcx),%r8

# qhasm: float6464 0t[0] = 0t[1] = *(float64 *)(op2 + 0)
# asm 1: movddup 0(<op2=int64#3),>0t=int6464#1
# asm 2: movddup 0(<op2=%rdx),>0t=%xmm0
movddup 0(%rdx),%xmm0

# qhasm: *(int128 *)(0arg1p + 0) = 0t
# asm 1: movdqa <0t=int6464#1,0(<0arg1p=int64#5)
# asm 2: movdqa <0t=%xmm0,0(<0arg1p=%r8)
movdqa %xmm0,0(%r8)

# qhasm: float6464 0t[0] = 0t[1] = *(float64 *)(op2 + 8)
# asm 1: movddup 8(<op2=int64#3),>0t=int6464#1
# asm 2: movddup 8(<op2=%rdx),>0t=%xmm0
movddup 8(%rdx),%xmm0

# qhasm: *(int128 *)(0arg1p + 16) = 0t
# asm 1: movdqa <0t=int6464#1,16(<0arg1p=int64#5)
# asm 2: movdqa <0t=%xmm0,16(<0arg1p=%r8)
movdqa %xmm0,16(%r8)

# qhasm: float6464 0t[0] = 0t[1] = *(float64 *)(op2 + 16)
# asm 1: movddup 16(<op2=int64#3),>0t=int6464#1
# asm 2: movddup 16(<op2=%rdx),>0t=%xmm0
movddup 16(%rdx),%xmm0

# qhasm: *(int128 *)(0arg1p + 32) = 0t
# asm 1: movdqa <0t=int6464#1,32(<0arg1p=int64#5)
# asm 2: movdqa <0t=%xmm0,32(<0arg1p=%r8)
movdqa %xmm0,32(%r8)

# qhasm: float6464 0t[0] = 0t[1] = *(float64 *)(op2 + 24)
# asm 1: movddup 24(<op2=int64#3),>0t=int6464#1
# asm 2: movddup 24(<op2=%rdx),>0t=%xmm0
movddup 24(%rdx),%xmm0

# qhasm: *(int128 *)(0arg1p + 48) = 0t
# asm 1: movdqa <0t=int6464#1,48(<0arg1p=int64#5)
# asm 2: movdqa <0t=%xmm0,48(<0arg1p=%r8)
movdqa %xmm0,48(%r8)

# qhasm: float6464 0t[0] = 0t[1] = *(float64 *)(op2 + 32)
# asm 1: movddup 32(<op2=int64#3),>0t=int6464#1
# asm 2: movddup 32(<op2=%rdx),>0t=%xmm0
movddup 32(%rdx),%xmm0

# qhasm: *(int128 *)(0arg1p + 64) = 0t
# asm 1: movdqa <0t=int6464#1,64(<0arg1p=int64#5)
# asm 2: movdqa <0t=%xmm0,64(<0arg1p=%r8)
movdqa %xmm0,64(%r8)

# qhasm: float6464 0t[0] = 0t[1] = *(float64 *)(op2 + 40)
# asm 1: movddup 40(<op2=int64#3),>0t=int6464#1
# asm 2: movddup 40(<op2=%rdx),>0t=%xmm0
movddup 40(%rdx),%xmm0

# qhasm: *(int128 *)(0arg1p + 80) = 0t
# asm 1: movdqa <0t=int6464#1,80(<0arg1p=int64#5)
# asm 2: movdqa <0t=%xmm0,80(<0arg1p=%r8)
movdqa %xmm0,80(%r8)

# qhasm: float6464 0t[0] = 0t[1] = *(float64 *)(op2 + 48)
# asm 1: movddup 48(<op2=int64#3),>0t=int6464#1
# asm 2: movddup 48(<op2=%rdx),>0t=%xmm0
movddup 48(%rdx),%xmm0

# qhasm: *(int128 *)(0arg1p + 96) = 0t
# asm 1: movdqa <0t=int6464#1,96(<0arg1p=int64#5)
# asm 2: movdqa <0t=%xmm0,96(<0arg1p=%r8)
movdqa %xmm0,96(%r8)

# qhasm: float6464 0t[0] = 0t[1] = *(float64 *)(op2 + 56)
# asm 1: movddup 56(<op2=int64#3),>0t=int6464#1
# asm 2: movddup 56(<op2=%rdx),>0t=%xmm0
movddup 56(%rdx),%xmm0

# qhasm: *(int128 *)(0arg1p + 112) = 0t
# asm 1: movdqa <0t=int6464#1,112(<0arg1p=int64#5)
# asm 2: movdqa <0t=%xmm0,112(<0arg1p=%r8)
movdqa %xmm0,112(%r8)

# qhasm: float6464 0t[0] = 0t[1] = *(float64 *)(op2 + 64)
# asm 1: movddup 64(<op2=int64#3),>0t=int6464#1
# asm 2: movddup 64(<op2=%rdx),>0t=%xmm0
movddup 64(%rdx),%xmm0

# qhasm: *(int128 *)(0arg1p + 128) = 0t
# asm 1: movdqa <0t=int6464#1,128(<0arg1p=int64#5)
# asm 2: movdqa <0t=%xmm0,128(<0arg1p=%r8)
movdqa %xmm0,128(%r8)

# qhasm: float6464 0t[0] = 0t[1] = *(float64 *)(op2 + 72)
# asm 1: movddup 72(<op2=int64#3),>0t=int6464#1
# asm 2: movddup 72(<op2=%rdx),>0t=%xmm0
movddup 72(%rdx),%xmm0

# qhasm: *(int128 *)(0arg1p + 144) = 0t
# asm 1: movdqa <0t=int6464#1,144(<0arg1p=int64#5)
# asm 2: movdqa <0t=%xmm0,144(<0arg1p=%r8)
movdqa %xmm0,144(%r8)

# qhasm: float6464 0t[0] = 0t[1] = *(float64 *)(op2 + 80)
# asm 1: movddup 80(<op2=int64#3),>0t=int6464#1
# asm 2: movddup 80(<op2=%rdx),>0t=%xmm0
movddup 80(%rdx),%xmm0

# qhasm: *(int128 *)(0arg1p + 160) = 0t
# asm 1: movdqa <0t=int6464#1,160(<0arg1p=int64#5)
# asm 2: movdqa <0t=%xmm0,160(<0arg1p=%r8)
movdqa %xmm0,160(%r8)

# qhasm: float6464 0t[0] = 0t[1] = *(float64 *)(op2 + 88)
# asm 1: movddup 88(<op2=int64#3),>0t=int6464#1
# asm 2: movddup 88(<op2=%rdx),>0t=%xmm0
movddup 88(%rdx),%xmm0

# qhasm: *(int128 *)(0arg1p + 176) = 0t
# asm 1: movdqa <0t=int6464#1,176(<0arg1p=int64#5)
# asm 2: movdqa <0t=%xmm0,176(<0arg1p=%r8)
movdqa %xmm0,176(%r8)

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

# qhasm: int6464 1t12

# qhasm: int6464 1t13

# qhasm: int6464 1t14

# qhasm: int6464 1t15

# qhasm: int6464 1t16

# qhasm: int6464 1t17

# qhasm: int6464 1t18

# qhasm: int6464 1t19

# qhasm: int6464 1t20

# qhasm: int6464 1t21

# qhasm: int6464 1t22

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

# qhasm: 0ab0 = *(int128 *)(0arg1p + 0)
# asm 1: movdqa 0(<0arg1p=int64#5),>0ab0=int6464#1
# asm 2: movdqa 0(<0arg1p=%r8),>0ab0=%xmm0
movdqa 0(%r8),%xmm0

# qhasm: 0t0 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t0=int6464#2
# asm 2: movdqa <0ab0=%xmm0,>0t0=%xmm1
movdqa %xmm0,%xmm1

# qhasm: float6464 0t0 *= *(int128 *)(op1 + 0)
# asm 1: mulpd 0(<op1=int64#2),<0t0=int6464#2
# asm 2: mulpd 0(<op1=%rsi),<0t0=%xmm1
mulpd 0(%rsi),%xmm1

# qhasm: 0r0 =0t0
# asm 1: movdqa <0t0=int6464#2,>0r0=int6464#2
# asm 2: movdqa <0t0=%xmm1,>0r0=%xmm1
movdqa %xmm1,%xmm1

# qhasm: 0t1 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t1=int6464#3
# asm 2: movdqa <0ab0=%xmm0,>0t1=%xmm2
movdqa %xmm0,%xmm2

# qhasm: float6464 0t1 *= *(int128 *)(op1 + 16)
# asm 1: mulpd 16(<op1=int64#2),<0t1=int6464#3
# asm 2: mulpd 16(<op1=%rsi),<0t1=%xmm2
mulpd 16(%rsi),%xmm2

# qhasm: 0r1 =0t1
# asm 1: movdqa <0t1=int6464#3,>0r1=int6464#3
# asm 2: movdqa <0t1=%xmm2,>0r1=%xmm2
movdqa %xmm2,%xmm2

# qhasm: 0t2 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t2=int6464#4
# asm 2: movdqa <0ab0=%xmm0,>0t2=%xmm3
movdqa %xmm0,%xmm3

# qhasm: float6464 0t2 *= *(int128 *)(op1 + 32)
# asm 1: mulpd 32(<op1=int64#2),<0t2=int6464#4
# asm 2: mulpd 32(<op1=%rsi),<0t2=%xmm3
mulpd 32(%rsi),%xmm3

# qhasm: 0r2 =0t2
# asm 1: movdqa <0t2=int6464#4,>0r2=int6464#4
# asm 2: movdqa <0t2=%xmm3,>0r2=%xmm3
movdqa %xmm3,%xmm3

# qhasm: 0t3 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t3=int6464#5
# asm 2: movdqa <0ab0=%xmm0,>0t3=%xmm4
movdqa %xmm0,%xmm4

# qhasm: float6464 0t3 *= *(int128 *)(op1 + 48)
# asm 1: mulpd 48(<op1=int64#2),<0t3=int6464#5
# asm 2: mulpd 48(<op1=%rsi),<0t3=%xmm4
mulpd 48(%rsi),%xmm4

# qhasm: 0r3 =0t3
# asm 1: movdqa <0t3=int6464#5,>0r3=int6464#5
# asm 2: movdqa <0t3=%xmm4,>0r3=%xmm4
movdqa %xmm4,%xmm4

# qhasm: 0t4 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t4=int6464#6
# asm 2: movdqa <0ab0=%xmm0,>0t4=%xmm5
movdqa %xmm0,%xmm5

# qhasm: float6464 0t4 *= *(int128 *)(op1 + 64)
# asm 1: mulpd 64(<op1=int64#2),<0t4=int6464#6
# asm 2: mulpd 64(<op1=%rsi),<0t4=%xmm5
mulpd 64(%rsi),%xmm5

# qhasm: 0r4 =0t4
# asm 1: movdqa <0t4=int6464#6,>0r4=int6464#6
# asm 2: movdqa <0t4=%xmm5,>0r4=%xmm5
movdqa %xmm5,%xmm5

# qhasm: 0t5 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t5=int6464#7
# asm 2: movdqa <0ab0=%xmm0,>0t5=%xmm6
movdqa %xmm0,%xmm6

# qhasm: float6464 0t5 *= *(int128 *)(op1 + 80)
# asm 1: mulpd 80(<op1=int64#2),<0t5=int6464#7
# asm 2: mulpd 80(<op1=%rsi),<0t5=%xmm6
mulpd 80(%rsi),%xmm6

# qhasm: 0r5 =0t5
# asm 1: movdqa <0t5=int6464#7,>0r5=int6464#7
# asm 2: movdqa <0t5=%xmm6,>0r5=%xmm6
movdqa %xmm6,%xmm6

# qhasm: 0t6 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t6=int6464#8
# asm 2: movdqa <0ab0=%xmm0,>0t6=%xmm7
movdqa %xmm0,%xmm7

# qhasm: float6464 0t6 *= *(int128 *)(op1 + 96)
# asm 1: mulpd 96(<op1=int64#2),<0t6=int6464#8
# asm 2: mulpd 96(<op1=%rsi),<0t6=%xmm7
mulpd 96(%rsi),%xmm7

# qhasm: 0r6 =0t6
# asm 1: movdqa <0t6=int6464#8,>0r6=int6464#8
# asm 2: movdqa <0t6=%xmm7,>0r6=%xmm7
movdqa %xmm7,%xmm7

# qhasm: 0t7 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t7=int6464#9
# asm 2: movdqa <0ab0=%xmm0,>0t7=%xmm8
movdqa %xmm0,%xmm8

# qhasm: float6464 0t7 *= *(int128 *)(op1 + 112)
# asm 1: mulpd 112(<op1=int64#2),<0t7=int6464#9
# asm 2: mulpd 112(<op1=%rsi),<0t7=%xmm8
mulpd 112(%rsi),%xmm8

# qhasm: 0r7 =0t7
# asm 1: movdqa <0t7=int6464#9,>0r7=int6464#9
# asm 2: movdqa <0t7=%xmm8,>0r7=%xmm8
movdqa %xmm8,%xmm8

# qhasm: 0t8 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t8=int6464#10
# asm 2: movdqa <0ab0=%xmm0,>0t8=%xmm9
movdqa %xmm0,%xmm9

# qhasm: float6464 0t8 *= *(int128 *)(op1 + 128)
# asm 1: mulpd 128(<op1=int64#2),<0t8=int6464#10
# asm 2: mulpd 128(<op1=%rsi),<0t8=%xmm9
mulpd 128(%rsi),%xmm9

# qhasm: 0r8 =0t8
# asm 1: movdqa <0t8=int6464#10,>0r8=int6464#10
# asm 2: movdqa <0t8=%xmm9,>0r8=%xmm9
movdqa %xmm9,%xmm9

# qhasm: 0t9 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t9=int6464#11
# asm 2: movdqa <0ab0=%xmm0,>0t9=%xmm10
movdqa %xmm0,%xmm10

# qhasm: float6464 0t9 *= *(int128 *)(op1 + 144)
# asm 1: mulpd 144(<op1=int64#2),<0t9=int6464#11
# asm 2: mulpd 144(<op1=%rsi),<0t9=%xmm10
mulpd 144(%rsi),%xmm10

# qhasm: 0r9 =0t9
# asm 1: movdqa <0t9=int6464#11,>0r9=int6464#11
# asm 2: movdqa <0t9=%xmm10,>0r9=%xmm10
movdqa %xmm10,%xmm10

# qhasm: 0t10 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t10=int6464#12
# asm 2: movdqa <0ab0=%xmm0,>0t10=%xmm11
movdqa %xmm0,%xmm11

# qhasm: float6464 0t10 *= *(int128 *)(op1 + 160)
# asm 1: mulpd 160(<op1=int64#2),<0t10=int6464#12
# asm 2: mulpd 160(<op1=%rsi),<0t10=%xmm11
mulpd 160(%rsi),%xmm11

# qhasm: 0r10 =0t10
# asm 1: movdqa <0t10=int6464#12,>0r10=int6464#12
# asm 2: movdqa <0t10=%xmm11,>0r10=%xmm11
movdqa %xmm11,%xmm11

# qhasm: 0t11 = 0ab0
# asm 1: movdqa <0ab0=int6464#1,>0t11=int6464#1
# asm 2: movdqa <0ab0=%xmm0,>0t11=%xmm0
movdqa %xmm0,%xmm0

# qhasm: float6464 0t11 *= *(int128 *)(op1 + 176)
# asm 1: mulpd 176(<op1=int64#2),<0t11=int6464#1
# asm 2: mulpd 176(<op1=%rsi),<0t11=%xmm0
mulpd 176(%rsi),%xmm0

# qhasm: 0r11 =0t11
# asm 1: movdqa <0t11=int6464#1,>0r11=int6464#1
# asm 2: movdqa <0t11=%xmm0,>0r11=%xmm0
movdqa %xmm0,%xmm0

# qhasm: *(int128 *)(1mysp + 0) = 0r0
# asm 1: movdqa <0r0=int6464#2,0(<1mysp=int64#4)
# asm 2: movdqa <0r0=%xmm1,0(<1mysp=%rcx)
movdqa %xmm1,0(%rcx)

# qhasm: 0ab1 = *(int128 *)(0arg1p + 16)
# asm 1: movdqa 16(<0arg1p=int64#5),>0ab1=int6464#2
# asm 2: movdqa 16(<0arg1p=%r8),>0ab1=%xmm1
movdqa 16(%r8),%xmm1

# qhasm: 0ab1six = 0ab1
# asm 1: movdqa <0ab1=int6464#2,>0ab1six=int6464#13
# asm 2: movdqa <0ab1=%xmm1,>0ab1six=%xmm12
movdqa %xmm1,%xmm12

# qhasm: float6464 0ab1six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0ab1six=int6464#13
# asm 2: mulpd SIX_SIX,<0ab1six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: 0t1 = 0ab1
# asm 1: movdqa <0ab1=int6464#2,>0t1=int6464#14
# asm 2: movdqa <0ab1=%xmm1,>0t1=%xmm13
movdqa %xmm1,%xmm13

# qhasm: float6464 0t1 *= *(int128 *)(op1 + 0)
# asm 1: mulpd 0(<op1=int64#2),<0t1=int6464#14
# asm 2: mulpd 0(<op1=%rsi),<0t1=%xmm13
mulpd 0(%rsi),%xmm13

# qhasm: float6464 0r1 +=0t1
# asm 1: addpd <0t1=int6464#14,<0r1=int6464#3
# asm 2: addpd <0t1=%xmm13,<0r1=%xmm2
addpd %xmm13,%xmm2

# qhasm: 0t7 = 0ab1
# asm 1: movdqa <0ab1=int6464#2,>0t7=int6464#2
# asm 2: movdqa <0ab1=%xmm1,>0t7=%xmm1
movdqa %xmm1,%xmm1

# qhasm: float6464 0t7 *= *(int128 *)(op1 + 96)
# asm 1: mulpd 96(<op1=int64#2),<0t7=int6464#2
# asm 2: mulpd 96(<op1=%rsi),<0t7=%xmm1
mulpd 96(%rsi),%xmm1

# qhasm: float6464 0r7 +=0t7
# asm 1: addpd <0t7=int6464#2,<0r7=int6464#9
# asm 2: addpd <0t7=%xmm1,<0r7=%xmm8
addpd %xmm1,%xmm8

# qhasm: 0t2 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t2=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t2=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t2 *= *(int128 *)(op1 + 16)
# asm 1: mulpd 16(<op1=int64#2),<0t2=int6464#2
# asm 2: mulpd 16(<op1=%rsi),<0t2=%xmm1
mulpd 16(%rsi),%xmm1

# qhasm: float6464 0r2 +=0t2
# asm 1: addpd <0t2=int6464#2,<0r2=int6464#4
# asm 2: addpd <0t2=%xmm1,<0r2=%xmm3
addpd %xmm1,%xmm3

# qhasm: 0t3 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t3=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t3=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t3 *= *(int128 *)(op1 + 32)
# asm 1: mulpd 32(<op1=int64#2),<0t3=int6464#2
# asm 2: mulpd 32(<op1=%rsi),<0t3=%xmm1
mulpd 32(%rsi),%xmm1

# qhasm: float6464 0r3 +=0t3
# asm 1: addpd <0t3=int6464#2,<0r3=int6464#5
# asm 2: addpd <0t3=%xmm1,<0r3=%xmm4
addpd %xmm1,%xmm4

# qhasm: 0t4 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t4=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t4=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t4 *= *(int128 *)(op1 + 48)
# asm 1: mulpd 48(<op1=int64#2),<0t4=int6464#2
# asm 2: mulpd 48(<op1=%rsi),<0t4=%xmm1
mulpd 48(%rsi),%xmm1

# qhasm: float6464 0r4 +=0t4
# asm 1: addpd <0t4=int6464#2,<0r4=int6464#6
# asm 2: addpd <0t4=%xmm1,<0r4=%xmm5
addpd %xmm1,%xmm5

# qhasm: 0t5 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t5=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t5=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t5 *= *(int128 *)(op1 + 64)
# asm 1: mulpd 64(<op1=int64#2),<0t5=int6464#2
# asm 2: mulpd 64(<op1=%rsi),<0t5=%xmm1
mulpd 64(%rsi),%xmm1

# qhasm: float6464 0r5 +=0t5
# asm 1: addpd <0t5=int6464#2,<0r5=int6464#7
# asm 2: addpd <0t5=%xmm1,<0r5=%xmm6
addpd %xmm1,%xmm6

# qhasm: 0t6 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t6=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t6=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t6 *= *(int128 *)(op1 + 80)
# asm 1: mulpd 80(<op1=int64#2),<0t6=int6464#2
# asm 2: mulpd 80(<op1=%rsi),<0t6=%xmm1
mulpd 80(%rsi),%xmm1

# qhasm: float6464 0r6 +=0t6
# asm 1: addpd <0t6=int6464#2,<0r6=int6464#8
# asm 2: addpd <0t6=%xmm1,<0r6=%xmm7
addpd %xmm1,%xmm7

# qhasm: 0t8 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t8=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t8=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t8 *= *(int128 *)(op1 + 112)
# asm 1: mulpd 112(<op1=int64#2),<0t8=int6464#2
# asm 2: mulpd 112(<op1=%rsi),<0t8=%xmm1
mulpd 112(%rsi),%xmm1

# qhasm: float6464 0r8 +=0t8
# asm 1: addpd <0t8=int6464#2,<0r8=int6464#10
# asm 2: addpd <0t8=%xmm1,<0r8=%xmm9
addpd %xmm1,%xmm9

# qhasm: 0t9 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t9=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t9=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t9 *= *(int128 *)(op1 + 128)
# asm 1: mulpd 128(<op1=int64#2),<0t9=int6464#2
# asm 2: mulpd 128(<op1=%rsi),<0t9=%xmm1
mulpd 128(%rsi),%xmm1

# qhasm: float6464 0r9 +=0t9
# asm 1: addpd <0t9=int6464#2,<0r9=int6464#11
# asm 2: addpd <0t9=%xmm1,<0r9=%xmm10
addpd %xmm1,%xmm10

# qhasm: 0t10 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t10=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t10=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t10 *= *(int128 *)(op1 + 144)
# asm 1: mulpd 144(<op1=int64#2),<0t10=int6464#2
# asm 2: mulpd 144(<op1=%rsi),<0t10=%xmm1
mulpd 144(%rsi),%xmm1

# qhasm: float6464 0r10 +=0t10
# asm 1: addpd <0t10=int6464#2,<0r10=int6464#12
# asm 2: addpd <0t10=%xmm1,<0r10=%xmm11
addpd %xmm1,%xmm11

# qhasm: 0t11 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>0t11=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>0t11=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t11 *= *(int128 *)(op1 + 160)
# asm 1: mulpd 160(<op1=int64#2),<0t11=int6464#2
# asm 2: mulpd 160(<op1=%rsi),<0t11=%xmm1
mulpd 160(%rsi),%xmm1

# qhasm: float6464 0r11 +=0t11
# asm 1: addpd <0t11=int6464#2,<0r11=int6464#1
# asm 2: addpd <0t11=%xmm1,<0r11=%xmm0
addpd %xmm1,%xmm0

# qhasm: 1t12 = 0ab1six
# asm 1: movdqa <0ab1six=int6464#13,>1t12=int6464#2
# asm 2: movdqa <0ab1six=%xmm12,>1t12=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 1t12 *= *(int128 *)(op1 + 176)
# asm 1: mulpd 176(<op1=int64#2),<1t12=int6464#2
# asm 2: mulpd 176(<op1=%rsi),<1t12=%xmm1
mulpd 176(%rsi),%xmm1

# qhasm: 0t12 =1t12
# asm 1: movdqa <1t12=int6464#2,>0t12=int6464#2
# asm 2: movdqa <1t12=%xmm1,>0t12=%xmm1
movdqa %xmm1,%xmm1

# qhasm: *(int128 *)(1mysp + 16) = 0r1
# asm 1: movdqa <0r1=int6464#3,16(<1mysp=int64#4)
# asm 2: movdqa <0r1=%xmm2,16(<1mysp=%rcx)
movdqa %xmm2,16(%rcx)

# qhasm: 0ab2 = *(int128 *)(0arg1p + 32)
# asm 1: movdqa 32(<0arg1p=int64#5),>0ab2=int6464#3
# asm 2: movdqa 32(<0arg1p=%r8),>0ab2=%xmm2
movdqa 32(%r8),%xmm2

# qhasm: 0ab2six = 0ab2
# asm 1: movdqa <0ab2=int6464#3,>0ab2six=int6464#13
# asm 2: movdqa <0ab2=%xmm2,>0ab2six=%xmm12
movdqa %xmm2,%xmm12

# qhasm: float6464 0ab2six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0ab2six=int6464#13
# asm 2: mulpd SIX_SIX,<0ab2six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: 0t2 = 0ab2
# asm 1: movdqa <0ab2=int6464#3,>0t2=int6464#14
# asm 2: movdqa <0ab2=%xmm2,>0t2=%xmm13
movdqa %xmm2,%xmm13

# qhasm: float6464 0t2 *= *(int128 *)(op1 + 0)
# asm 1: mulpd 0(<op1=int64#2),<0t2=int6464#14
# asm 2: mulpd 0(<op1=%rsi),<0t2=%xmm13
mulpd 0(%rsi),%xmm13

# qhasm: float6464 0r2 +=0t2
# asm 1: addpd <0t2=int6464#14,<0r2=int6464#4
# asm 2: addpd <0t2=%xmm13,<0r2=%xmm3
addpd %xmm13,%xmm3

# qhasm: 0t7 = 0ab2
# asm 1: movdqa <0ab2=int6464#3,>0t7=int6464#14
# asm 2: movdqa <0ab2=%xmm2,>0t7=%xmm13
movdqa %xmm2,%xmm13

# qhasm: float6464 0t7 *= *(int128 *)(op1 + 80)
# asm 1: mulpd 80(<op1=int64#2),<0t7=int6464#14
# asm 2: mulpd 80(<op1=%rsi),<0t7=%xmm13
mulpd 80(%rsi),%xmm13

# qhasm: float6464 0r7 +=0t7
# asm 1: addpd <0t7=int6464#14,<0r7=int6464#9
# asm 2: addpd <0t7=%xmm13,<0r7=%xmm8
addpd %xmm13,%xmm8

# qhasm: 0t8 = 0ab2
# asm 1: movdqa <0ab2=int6464#3,>0t8=int6464#14
# asm 2: movdqa <0ab2=%xmm2,>0t8=%xmm13
movdqa %xmm2,%xmm13

# qhasm: float6464 0t8 *= *(int128 *)(op1 + 96)
# asm 1: mulpd 96(<op1=int64#2),<0t8=int6464#14
# asm 2: mulpd 96(<op1=%rsi),<0t8=%xmm13
mulpd 96(%rsi),%xmm13

# qhasm: float6464 0r8 +=0t8
# asm 1: addpd <0t8=int6464#14,<0r8=int6464#10
# asm 2: addpd <0t8=%xmm13,<0r8=%xmm9
addpd %xmm13,%xmm9

# qhasm: 1t13 = 0ab2
# asm 1: movdqa <0ab2=int6464#3,>1t13=int6464#3
# asm 2: movdqa <0ab2=%xmm2,>1t13=%xmm2
movdqa %xmm2,%xmm2

# qhasm: float6464 1t13 *= *(int128 *)(op1 + 176)
# asm 1: mulpd 176(<op1=int64#2),<1t13=int6464#3
# asm 2: mulpd 176(<op1=%rsi),<1t13=%xmm2
mulpd 176(%rsi),%xmm2

# qhasm: 0t13 =1t13
# asm 1: movdqa <1t13=int6464#3,>0t13=int6464#3
# asm 2: movdqa <1t13=%xmm2,>0t13=%xmm2
movdqa %xmm2,%xmm2

# qhasm: 0t3 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t3=int6464#14
# asm 2: movdqa <0ab2six=%xmm12,>0t3=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t3 *= *(int128 *)(op1 + 16)
# asm 1: mulpd 16(<op1=int64#2),<0t3=int6464#14
# asm 2: mulpd 16(<op1=%rsi),<0t3=%xmm13
mulpd 16(%rsi),%xmm13

# qhasm: float6464 0r3 +=0t3
# asm 1: addpd <0t3=int6464#14,<0r3=int6464#5
# asm 2: addpd <0t3=%xmm13,<0r3=%xmm4
addpd %xmm13,%xmm4

# qhasm: 0t4 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t4=int6464#14
# asm 2: movdqa <0ab2six=%xmm12,>0t4=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t4 *= *(int128 *)(op1 + 32)
# asm 1: mulpd 32(<op1=int64#2),<0t4=int6464#14
# asm 2: mulpd 32(<op1=%rsi),<0t4=%xmm13
mulpd 32(%rsi),%xmm13

# qhasm: float6464 0r4 +=0t4
# asm 1: addpd <0t4=int6464#14,<0r4=int6464#6
# asm 2: addpd <0t4=%xmm13,<0r4=%xmm5
addpd %xmm13,%xmm5

# qhasm: 0t5 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t5=int6464#14
# asm 2: movdqa <0ab2six=%xmm12,>0t5=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t5 *= *(int128 *)(op1 + 48)
# asm 1: mulpd 48(<op1=int64#2),<0t5=int6464#14
# asm 2: mulpd 48(<op1=%rsi),<0t5=%xmm13
mulpd 48(%rsi),%xmm13

# qhasm: float6464 0r5 +=0t5
# asm 1: addpd <0t5=int6464#14,<0r5=int6464#7
# asm 2: addpd <0t5=%xmm13,<0r5=%xmm6
addpd %xmm13,%xmm6

# qhasm: 0t6 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t6=int6464#14
# asm 2: movdqa <0ab2six=%xmm12,>0t6=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t6 *= *(int128 *)(op1 + 64)
# asm 1: mulpd 64(<op1=int64#2),<0t6=int6464#14
# asm 2: mulpd 64(<op1=%rsi),<0t6=%xmm13
mulpd 64(%rsi),%xmm13

# qhasm: float6464 0r6 +=0t6
# asm 1: addpd <0t6=int6464#14,<0r6=int6464#8
# asm 2: addpd <0t6=%xmm13,<0r6=%xmm7
addpd %xmm13,%xmm7

# qhasm: 0t9 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t9=int6464#14
# asm 2: movdqa <0ab2six=%xmm12,>0t9=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t9 *= *(int128 *)(op1 + 112)
# asm 1: mulpd 112(<op1=int64#2),<0t9=int6464#14
# asm 2: mulpd 112(<op1=%rsi),<0t9=%xmm13
mulpd 112(%rsi),%xmm13

# qhasm: float6464 0r9 +=0t9
# asm 1: addpd <0t9=int6464#14,<0r9=int6464#11
# asm 2: addpd <0t9=%xmm13,<0r9=%xmm10
addpd %xmm13,%xmm10

# qhasm: 0t10 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t10=int6464#14
# asm 2: movdqa <0ab2six=%xmm12,>0t10=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t10 *= *(int128 *)(op1 + 128)
# asm 1: mulpd 128(<op1=int64#2),<0t10=int6464#14
# asm 2: mulpd 128(<op1=%rsi),<0t10=%xmm13
mulpd 128(%rsi),%xmm13

# qhasm: float6464 0r10 +=0t10
# asm 1: addpd <0t10=int6464#14,<0r10=int6464#12
# asm 2: addpd <0t10=%xmm13,<0r10=%xmm11
addpd %xmm13,%xmm11

# qhasm: 0t11 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>0t11=int6464#14
# asm 2: movdqa <0ab2six=%xmm12,>0t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t11 *= *(int128 *)(op1 + 144)
# asm 1: mulpd 144(<op1=int64#2),<0t11=int6464#14
# asm 2: mulpd 144(<op1=%rsi),<0t11=%xmm13
mulpd 144(%rsi),%xmm13

# qhasm: float6464 0r11 +=0t11
# asm 1: addpd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addpd <0t11=%xmm13,<0r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: 1t12 = 0ab2six
# asm 1: movdqa <0ab2six=int6464#13,>1t12=int6464#13
# asm 2: movdqa <0ab2six=%xmm12,>1t12=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 1t12 *= *(int128 *)(op1 + 160)
# asm 1: mulpd 160(<op1=int64#2),<1t12=int6464#13
# asm 2: mulpd 160(<op1=%rsi),<1t12=%xmm12
mulpd 160(%rsi),%xmm12

# qhasm: float6464 0t12 +=1t12
# asm 1: addpd <1t12=int6464#13,<0t12=int6464#2
# asm 2: addpd <1t12=%xmm12,<0t12=%xmm1
addpd %xmm12,%xmm1

# qhasm: *(int128 *)(1mysp + 32) = 0r2
# asm 1: movdqa <0r2=int6464#4,32(<1mysp=int64#4)
# asm 2: movdqa <0r2=%xmm3,32(<1mysp=%rcx)
movdqa %xmm3,32(%rcx)

# qhasm: 0ab3 = *(int128 *)(0arg1p + 48)
# asm 1: movdqa 48(<0arg1p=int64#5),>0ab3=int6464#4
# asm 2: movdqa 48(<0arg1p=%r8),>0ab3=%xmm3
movdqa 48(%r8),%xmm3

# qhasm: 0ab3six = 0ab3
# asm 1: movdqa <0ab3=int6464#4,>0ab3six=int6464#13
# asm 2: movdqa <0ab3=%xmm3,>0ab3six=%xmm12
movdqa %xmm3,%xmm12

# qhasm: float6464 0ab3six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0ab3six=int6464#13
# asm 2: mulpd SIX_SIX,<0ab3six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: 0t3 = 0ab3
# asm 1: movdqa <0ab3=int6464#4,>0t3=int6464#14
# asm 2: movdqa <0ab3=%xmm3,>0t3=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 0t3 *= *(int128 *)(op1 + 0)
# asm 1: mulpd 0(<op1=int64#2),<0t3=int6464#14
# asm 2: mulpd 0(<op1=%rsi),<0t3=%xmm13
mulpd 0(%rsi),%xmm13

# qhasm: float6464 0r3 +=0t3
# asm 1: addpd <0t3=int6464#14,<0r3=int6464#5
# asm 2: addpd <0t3=%xmm13,<0r3=%xmm4
addpd %xmm13,%xmm4

# qhasm: 0t7 = 0ab3
# asm 1: movdqa <0ab3=int6464#4,>0t7=int6464#14
# asm 2: movdqa <0ab3=%xmm3,>0t7=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 0t7 *= *(int128 *)(op1 + 64)
# asm 1: mulpd 64(<op1=int64#2),<0t7=int6464#14
# asm 2: mulpd 64(<op1=%rsi),<0t7=%xmm13
mulpd 64(%rsi),%xmm13

# qhasm: float6464 0r7 +=0t7
# asm 1: addpd <0t7=int6464#14,<0r7=int6464#9
# asm 2: addpd <0t7=%xmm13,<0r7=%xmm8
addpd %xmm13,%xmm8

# qhasm: 0t8 = 0ab3
# asm 1: movdqa <0ab3=int6464#4,>0t8=int6464#14
# asm 2: movdqa <0ab3=%xmm3,>0t8=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 0t8 *= *(int128 *)(op1 + 80)
# asm 1: mulpd 80(<op1=int64#2),<0t8=int6464#14
# asm 2: mulpd 80(<op1=%rsi),<0t8=%xmm13
mulpd 80(%rsi),%xmm13

# qhasm: float6464 0r8 +=0t8
# asm 1: addpd <0t8=int6464#14,<0r8=int6464#10
# asm 2: addpd <0t8=%xmm13,<0r8=%xmm9
addpd %xmm13,%xmm9

# qhasm: 0t9 = 0ab3
# asm 1: movdqa <0ab3=int6464#4,>0t9=int6464#14
# asm 2: movdqa <0ab3=%xmm3,>0t9=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 0t9 *= *(int128 *)(op1 + 96)
# asm 1: mulpd 96(<op1=int64#2),<0t9=int6464#14
# asm 2: mulpd 96(<op1=%rsi),<0t9=%xmm13
mulpd 96(%rsi),%xmm13

# qhasm: float6464 0r9 +=0t9
# asm 1: addpd <0t9=int6464#14,<0r9=int6464#11
# asm 2: addpd <0t9=%xmm13,<0r9=%xmm10
addpd %xmm13,%xmm10

# qhasm: 1t13 = 0ab3
# asm 1: movdqa <0ab3=int6464#4,>1t13=int6464#14
# asm 2: movdqa <0ab3=%xmm3,>1t13=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 1t13 *= *(int128 *)(op1 + 160)
# asm 1: mulpd 160(<op1=int64#2),<1t13=int6464#14
# asm 2: mulpd 160(<op1=%rsi),<1t13=%xmm13
mulpd 160(%rsi),%xmm13

# qhasm: float6464 0t13 +=1t13
# asm 1: addpd <1t13=int6464#14,<0t13=int6464#3
# asm 2: addpd <1t13=%xmm13,<0t13=%xmm2
addpd %xmm13,%xmm2

# qhasm: 1t14 = 0ab3
# asm 1: movdqa <0ab3=int6464#4,>1t14=int6464#4
# asm 2: movdqa <0ab3=%xmm3,>1t14=%xmm3
movdqa %xmm3,%xmm3

# qhasm: float6464 1t14 *= *(int128 *)(op1 + 176)
# asm 1: mulpd 176(<op1=int64#2),<1t14=int6464#4
# asm 2: mulpd 176(<op1=%rsi),<1t14=%xmm3
mulpd 176(%rsi),%xmm3

# qhasm: 0t14 =1t14
# asm 1: movdqa <1t14=int6464#4,>0t14=int6464#4
# asm 2: movdqa <1t14=%xmm3,>0t14=%xmm3
movdqa %xmm3,%xmm3

# qhasm: 0t4 = 0ab3six
# asm 1: movdqa <0ab3six=int6464#13,>0t4=int6464#14
# asm 2: movdqa <0ab3six=%xmm12,>0t4=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t4 *= *(int128 *)(op1 + 16)
# asm 1: mulpd 16(<op1=int64#2),<0t4=int6464#14
# asm 2: mulpd 16(<op1=%rsi),<0t4=%xmm13
mulpd 16(%rsi),%xmm13

# qhasm: float6464 0r4 +=0t4
# asm 1: addpd <0t4=int6464#14,<0r4=int6464#6
# asm 2: addpd <0t4=%xmm13,<0r4=%xmm5
addpd %xmm13,%xmm5

# qhasm: 0t5 = 0ab3six
# asm 1: movdqa <0ab3six=int6464#13,>0t5=int6464#14
# asm 2: movdqa <0ab3six=%xmm12,>0t5=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t5 *= *(int128 *)(op1 + 32)
# asm 1: mulpd 32(<op1=int64#2),<0t5=int6464#14
# asm 2: mulpd 32(<op1=%rsi),<0t5=%xmm13
mulpd 32(%rsi),%xmm13

# qhasm: float6464 0r5 +=0t5
# asm 1: addpd <0t5=int6464#14,<0r5=int6464#7
# asm 2: addpd <0t5=%xmm13,<0r5=%xmm6
addpd %xmm13,%xmm6

# qhasm: 0t6 = 0ab3six
# asm 1: movdqa <0ab3six=int6464#13,>0t6=int6464#14
# asm 2: movdqa <0ab3six=%xmm12,>0t6=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t6 *= *(int128 *)(op1 + 48)
# asm 1: mulpd 48(<op1=int64#2),<0t6=int6464#14
# asm 2: mulpd 48(<op1=%rsi),<0t6=%xmm13
mulpd 48(%rsi),%xmm13

# qhasm: float6464 0r6 +=0t6
# asm 1: addpd <0t6=int6464#14,<0r6=int6464#8
# asm 2: addpd <0t6=%xmm13,<0r6=%xmm7
addpd %xmm13,%xmm7

# qhasm: 0t10 = 0ab3six
# asm 1: movdqa <0ab3six=int6464#13,>0t10=int6464#14
# asm 2: movdqa <0ab3six=%xmm12,>0t10=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t10 *= *(int128 *)(op1 + 112)
# asm 1: mulpd 112(<op1=int64#2),<0t10=int6464#14
# asm 2: mulpd 112(<op1=%rsi),<0t10=%xmm13
mulpd 112(%rsi),%xmm13

# qhasm: float6464 0r10 +=0t10
# asm 1: addpd <0t10=int6464#14,<0r10=int6464#12
# asm 2: addpd <0t10=%xmm13,<0r10=%xmm11
addpd %xmm13,%xmm11

# qhasm: 0t11 = 0ab3six
# asm 1: movdqa <0ab3six=int6464#13,>0t11=int6464#14
# asm 2: movdqa <0ab3six=%xmm12,>0t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t11 *= *(int128 *)(op1 + 128)
# asm 1: mulpd 128(<op1=int64#2),<0t11=int6464#14
# asm 2: mulpd 128(<op1=%rsi),<0t11=%xmm13
mulpd 128(%rsi),%xmm13

# qhasm: float6464 0r11 +=0t11
# asm 1: addpd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addpd <0t11=%xmm13,<0r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: 1t12 = 0ab3six
# asm 1: movdqa <0ab3six=int6464#13,>1t12=int6464#13
# asm 2: movdqa <0ab3six=%xmm12,>1t12=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 1t12 *= *(int128 *)(op1 + 144)
# asm 1: mulpd 144(<op1=int64#2),<1t12=int6464#13
# asm 2: mulpd 144(<op1=%rsi),<1t12=%xmm12
mulpd 144(%rsi),%xmm12

# qhasm: float6464 0t12 +=1t12
# asm 1: addpd <1t12=int6464#13,<0t12=int6464#2
# asm 2: addpd <1t12=%xmm12,<0t12=%xmm1
addpd %xmm12,%xmm1

# qhasm: *(int128 *)(1mysp + 48) = 0r3
# asm 1: movdqa <0r3=int6464#5,48(<1mysp=int64#4)
# asm 2: movdqa <0r3=%xmm4,48(<1mysp=%rcx)
movdqa %xmm4,48(%rcx)

# qhasm: 0ab4 = *(int128 *)(0arg1p + 64)
# asm 1: movdqa 64(<0arg1p=int64#5),>0ab4=int6464#5
# asm 2: movdqa 64(<0arg1p=%r8),>0ab4=%xmm4
movdqa 64(%r8),%xmm4

# qhasm: 0ab4six = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0ab4six=int6464#13
# asm 2: movdqa <0ab4=%xmm4,>0ab4six=%xmm12
movdqa %xmm4,%xmm12

# qhasm: float6464 0ab4six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0ab4six=int6464#13
# asm 2: mulpd SIX_SIX,<0ab4six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: 0t4 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0t4=int6464#14
# asm 2: movdqa <0ab4=%xmm4,>0t4=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0t4 *= *(int128 *)(op1 + 0)
# asm 1: mulpd 0(<op1=int64#2),<0t4=int6464#14
# asm 2: mulpd 0(<op1=%rsi),<0t4=%xmm13
mulpd 0(%rsi),%xmm13

# qhasm: float6464 0r4 +=0t4
# asm 1: addpd <0t4=int6464#14,<0r4=int6464#6
# asm 2: addpd <0t4=%xmm13,<0r4=%xmm5
addpd %xmm13,%xmm5

# qhasm: 0t7 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0t7=int6464#14
# asm 2: movdqa <0ab4=%xmm4,>0t7=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0t7 *= *(int128 *)(op1 + 48)
# asm 1: mulpd 48(<op1=int64#2),<0t7=int6464#14
# asm 2: mulpd 48(<op1=%rsi),<0t7=%xmm13
mulpd 48(%rsi),%xmm13

# qhasm: float6464 0r7 +=0t7
# asm 1: addpd <0t7=int6464#14,<0r7=int6464#9
# asm 2: addpd <0t7=%xmm13,<0r7=%xmm8
addpd %xmm13,%xmm8

# qhasm: 0t8 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0t8=int6464#14
# asm 2: movdqa <0ab4=%xmm4,>0t8=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0t8 *= *(int128 *)(op1 + 64)
# asm 1: mulpd 64(<op1=int64#2),<0t8=int6464#14
# asm 2: mulpd 64(<op1=%rsi),<0t8=%xmm13
mulpd 64(%rsi),%xmm13

# qhasm: float6464 0r8 +=0t8
# asm 1: addpd <0t8=int6464#14,<0r8=int6464#10
# asm 2: addpd <0t8=%xmm13,<0r8=%xmm9
addpd %xmm13,%xmm9

# qhasm: 0t9 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0t9=int6464#14
# asm 2: movdqa <0ab4=%xmm4,>0t9=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0t9 *= *(int128 *)(op1 + 80)
# asm 1: mulpd 80(<op1=int64#2),<0t9=int6464#14
# asm 2: mulpd 80(<op1=%rsi),<0t9=%xmm13
mulpd 80(%rsi),%xmm13

# qhasm: float6464 0r9 +=0t9
# asm 1: addpd <0t9=int6464#14,<0r9=int6464#11
# asm 2: addpd <0t9=%xmm13,<0r9=%xmm10
addpd %xmm13,%xmm10

# qhasm: 0t10 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>0t10=int6464#14
# asm 2: movdqa <0ab4=%xmm4,>0t10=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0t10 *= *(int128 *)(op1 + 96)
# asm 1: mulpd 96(<op1=int64#2),<0t10=int6464#14
# asm 2: mulpd 96(<op1=%rsi),<0t10=%xmm13
mulpd 96(%rsi),%xmm13

# qhasm: float6464 0r10 +=0t10
# asm 1: addpd <0t10=int6464#14,<0r10=int6464#12
# asm 2: addpd <0t10=%xmm13,<0r10=%xmm11
addpd %xmm13,%xmm11

# qhasm: 1t13 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>1t13=int6464#14
# asm 2: movdqa <0ab4=%xmm4,>1t13=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 1t13 *= *(int128 *)(op1 + 144)
# asm 1: mulpd 144(<op1=int64#2),<1t13=int6464#14
# asm 2: mulpd 144(<op1=%rsi),<1t13=%xmm13
mulpd 144(%rsi),%xmm13

# qhasm: float6464 0t13 +=1t13
# asm 1: addpd <1t13=int6464#14,<0t13=int6464#3
# asm 2: addpd <1t13=%xmm13,<0t13=%xmm2
addpd %xmm13,%xmm2

# qhasm: 1t14 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>1t14=int6464#14
# asm 2: movdqa <0ab4=%xmm4,>1t14=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 1t14 *= *(int128 *)(op1 + 160)
# asm 1: mulpd 160(<op1=int64#2),<1t14=int6464#14
# asm 2: mulpd 160(<op1=%rsi),<1t14=%xmm13
mulpd 160(%rsi),%xmm13

# qhasm: float6464 0t14 +=1t14
# asm 1: addpd <1t14=int6464#14,<0t14=int6464#4
# asm 2: addpd <1t14=%xmm13,<0t14=%xmm3
addpd %xmm13,%xmm3

# qhasm: 1t15 = 0ab4
# asm 1: movdqa <0ab4=int6464#5,>1t15=int6464#5
# asm 2: movdqa <0ab4=%xmm4,>1t15=%xmm4
movdqa %xmm4,%xmm4

# qhasm: float6464 1t15 *= *(int128 *)(op1 + 176)
# asm 1: mulpd 176(<op1=int64#2),<1t15=int6464#5
# asm 2: mulpd 176(<op1=%rsi),<1t15=%xmm4
mulpd 176(%rsi),%xmm4

# qhasm: 0t15 =1t15
# asm 1: movdqa <1t15=int6464#5,>0t15=int6464#5
# asm 2: movdqa <1t15=%xmm4,>0t15=%xmm4
movdqa %xmm4,%xmm4

# qhasm: 0t5 = 0ab4six
# asm 1: movdqa <0ab4six=int6464#13,>0t5=int6464#14
# asm 2: movdqa <0ab4six=%xmm12,>0t5=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t5 *= *(int128 *)(op1 + 16)
# asm 1: mulpd 16(<op1=int64#2),<0t5=int6464#14
# asm 2: mulpd 16(<op1=%rsi),<0t5=%xmm13
mulpd 16(%rsi),%xmm13

# qhasm: float6464 0r5 +=0t5
# asm 1: addpd <0t5=int6464#14,<0r5=int6464#7
# asm 2: addpd <0t5=%xmm13,<0r5=%xmm6
addpd %xmm13,%xmm6

# qhasm: 0t6 = 0ab4six
# asm 1: movdqa <0ab4six=int6464#13,>0t6=int6464#14
# asm 2: movdqa <0ab4six=%xmm12,>0t6=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t6 *= *(int128 *)(op1 + 32)
# asm 1: mulpd 32(<op1=int64#2),<0t6=int6464#14
# asm 2: mulpd 32(<op1=%rsi),<0t6=%xmm13
mulpd 32(%rsi),%xmm13

# qhasm: float6464 0r6 +=0t6
# asm 1: addpd <0t6=int6464#14,<0r6=int6464#8
# asm 2: addpd <0t6=%xmm13,<0r6=%xmm7
addpd %xmm13,%xmm7

# qhasm: 0t11 = 0ab4six
# asm 1: movdqa <0ab4six=int6464#13,>0t11=int6464#14
# asm 2: movdqa <0ab4six=%xmm12,>0t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t11 *= *(int128 *)(op1 + 112)
# asm 1: mulpd 112(<op1=int64#2),<0t11=int6464#14
# asm 2: mulpd 112(<op1=%rsi),<0t11=%xmm13
mulpd 112(%rsi),%xmm13

# qhasm: float6464 0r11 +=0t11
# asm 1: addpd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addpd <0t11=%xmm13,<0r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: 1t12 = 0ab4six
# asm 1: movdqa <0ab4six=int6464#13,>1t12=int6464#13
# asm 2: movdqa <0ab4six=%xmm12,>1t12=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 1t12 *= *(int128 *)(op1 + 128)
# asm 1: mulpd 128(<op1=int64#2),<1t12=int6464#13
# asm 2: mulpd 128(<op1=%rsi),<1t12=%xmm12
mulpd 128(%rsi),%xmm12

# qhasm: float6464 0t12 +=1t12
# asm 1: addpd <1t12=int6464#13,<0t12=int6464#2
# asm 2: addpd <1t12=%xmm12,<0t12=%xmm1
addpd %xmm12,%xmm1

# qhasm: *(int128 *)(1mysp + 64) = 0r4
# asm 1: movdqa <0r4=int6464#6,64(<1mysp=int64#4)
# asm 2: movdqa <0r4=%xmm5,64(<1mysp=%rcx)
movdqa %xmm5,64(%rcx)

# qhasm: 0ab5 = *(int128 *)(0arg1p + 80)
# asm 1: movdqa 80(<0arg1p=int64#5),>0ab5=int6464#6
# asm 2: movdqa 80(<0arg1p=%r8),>0ab5=%xmm5
movdqa 80(%r8),%xmm5

# qhasm: 0ab5six = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0ab5six=int6464#13
# asm 2: movdqa <0ab5=%xmm5,>0ab5six=%xmm12
movdqa %xmm5,%xmm12

# qhasm: float6464 0ab5six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0ab5six=int6464#13
# asm 2: mulpd SIX_SIX,<0ab5six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: 0t5 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t5=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t5=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t5 *= *(int128 *)(op1 + 0)
# asm 1: mulpd 0(<op1=int64#2),<0t5=int6464#14
# asm 2: mulpd 0(<op1=%rsi),<0t5=%xmm13
mulpd 0(%rsi),%xmm13

# qhasm: float6464 0r5 +=0t5
# asm 1: addpd <0t5=int6464#14,<0r5=int6464#7
# asm 2: addpd <0t5=%xmm13,<0r5=%xmm6
addpd %xmm13,%xmm6

# qhasm: 0t7 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t7=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t7=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t7 *= *(int128 *)(op1 + 32)
# asm 1: mulpd 32(<op1=int64#2),<0t7=int6464#14
# asm 2: mulpd 32(<op1=%rsi),<0t7=%xmm13
mulpd 32(%rsi),%xmm13

# qhasm: float6464 0r7 +=0t7
# asm 1: addpd <0t7=int6464#14,<0r7=int6464#9
# asm 2: addpd <0t7=%xmm13,<0r7=%xmm8
addpd %xmm13,%xmm8

# qhasm: 0t8 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t8=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t8=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t8 *= *(int128 *)(op1 + 48)
# asm 1: mulpd 48(<op1=int64#2),<0t8=int6464#14
# asm 2: mulpd 48(<op1=%rsi),<0t8=%xmm13
mulpd 48(%rsi),%xmm13

# qhasm: float6464 0r8 +=0t8
# asm 1: addpd <0t8=int6464#14,<0r8=int6464#10
# asm 2: addpd <0t8=%xmm13,<0r8=%xmm9
addpd %xmm13,%xmm9

# qhasm: 0t9 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t9=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t9=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t9 *= *(int128 *)(op1 + 64)
# asm 1: mulpd 64(<op1=int64#2),<0t9=int6464#14
# asm 2: mulpd 64(<op1=%rsi),<0t9=%xmm13
mulpd 64(%rsi),%xmm13

# qhasm: float6464 0r9 +=0t9
# asm 1: addpd <0t9=int6464#14,<0r9=int6464#11
# asm 2: addpd <0t9=%xmm13,<0r9=%xmm10
addpd %xmm13,%xmm10

# qhasm: 0t10 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t10=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t10=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t10 *= *(int128 *)(op1 + 80)
# asm 1: mulpd 80(<op1=int64#2),<0t10=int6464#14
# asm 2: mulpd 80(<op1=%rsi),<0t10=%xmm13
mulpd 80(%rsi),%xmm13

# qhasm: float6464 0r10 +=0t10
# asm 1: addpd <0t10=int6464#14,<0r10=int6464#12
# asm 2: addpd <0t10=%xmm13,<0r10=%xmm11
addpd %xmm13,%xmm11

# qhasm: 0t11 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>0t11=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>0t11=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0t11 *= *(int128 *)(op1 + 96)
# asm 1: mulpd 96(<op1=int64#2),<0t11=int6464#14
# asm 2: mulpd 96(<op1=%rsi),<0t11=%xmm13
mulpd 96(%rsi),%xmm13

# qhasm: float6464 0r11 +=0t11
# asm 1: addpd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addpd <0t11=%xmm13,<0r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: 1t13 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>1t13=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>1t13=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 1t13 *= *(int128 *)(op1 + 128)
# asm 1: mulpd 128(<op1=int64#2),<1t13=int6464#14
# asm 2: mulpd 128(<op1=%rsi),<1t13=%xmm13
mulpd 128(%rsi),%xmm13

# qhasm: float6464 0t13 +=1t13
# asm 1: addpd <1t13=int6464#14,<0t13=int6464#3
# asm 2: addpd <1t13=%xmm13,<0t13=%xmm2
addpd %xmm13,%xmm2

# qhasm: 1t14 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>1t14=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>1t14=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 1t14 *= *(int128 *)(op1 + 144)
# asm 1: mulpd 144(<op1=int64#2),<1t14=int6464#14
# asm 2: mulpd 144(<op1=%rsi),<1t14=%xmm13
mulpd 144(%rsi),%xmm13

# qhasm: float6464 0t14 +=1t14
# asm 1: addpd <1t14=int6464#14,<0t14=int6464#4
# asm 2: addpd <1t14=%xmm13,<0t14=%xmm3
addpd %xmm13,%xmm3

# qhasm: 1t15 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>1t15=int6464#14
# asm 2: movdqa <0ab5=%xmm5,>1t15=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 1t15 *= *(int128 *)(op1 + 160)
# asm 1: mulpd 160(<op1=int64#2),<1t15=int6464#14
# asm 2: mulpd 160(<op1=%rsi),<1t15=%xmm13
mulpd 160(%rsi),%xmm13

# qhasm: float6464 0t15 +=1t15
# asm 1: addpd <1t15=int6464#14,<0t15=int6464#5
# asm 2: addpd <1t15=%xmm13,<0t15=%xmm4
addpd %xmm13,%xmm4

# qhasm: 1t16 = 0ab5
# asm 1: movdqa <0ab5=int6464#6,>1t16=int6464#6
# asm 2: movdqa <0ab5=%xmm5,>1t16=%xmm5
movdqa %xmm5,%xmm5

# qhasm: float6464 1t16 *= *(int128 *)(op1 + 176)
# asm 1: mulpd 176(<op1=int64#2),<1t16=int6464#6
# asm 2: mulpd 176(<op1=%rsi),<1t16=%xmm5
mulpd 176(%rsi),%xmm5

# qhasm: 0t16 =1t16
# asm 1: movdqa <1t16=int6464#6,>0t16=int6464#6
# asm 2: movdqa <1t16=%xmm5,>0t16=%xmm5
movdqa %xmm5,%xmm5

# qhasm: 0t6 = 0ab5six
# asm 1: movdqa <0ab5six=int6464#13,>0t6=int6464#14
# asm 2: movdqa <0ab5six=%xmm12,>0t6=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t6 *= *(int128 *)(op1 + 16)
# asm 1: mulpd 16(<op1=int64#2),<0t6=int6464#14
# asm 2: mulpd 16(<op1=%rsi),<0t6=%xmm13
mulpd 16(%rsi),%xmm13

# qhasm: float6464 0r6 +=0t6
# asm 1: addpd <0t6=int6464#14,<0r6=int6464#8
# asm 2: addpd <0t6=%xmm13,<0r6=%xmm7
addpd %xmm13,%xmm7

# qhasm: 1t12 = 0ab5six
# asm 1: movdqa <0ab5six=int6464#13,>1t12=int6464#13
# asm 2: movdqa <0ab5six=%xmm12,>1t12=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 1t12 *= *(int128 *)(op1 + 112)
# asm 1: mulpd 112(<op1=int64#2),<1t12=int6464#13
# asm 2: mulpd 112(<op1=%rsi),<1t12=%xmm12
mulpd 112(%rsi),%xmm12

# qhasm: float6464 0t12 +=1t12
# asm 1: addpd <1t12=int6464#13,<0t12=int6464#2
# asm 2: addpd <1t12=%xmm12,<0t12=%xmm1
addpd %xmm12,%xmm1

# qhasm: *(int128 *)(1mysp + 80) = 0r5
# asm 1: movdqa <0r5=int6464#7,80(<1mysp=int64#4)
# asm 2: movdqa <0r5=%xmm6,80(<1mysp=%rcx)
movdqa %xmm6,80(%rcx)

# qhasm: 0ab6 = *(int128 *)(0arg1p + 96)
# asm 1: movdqa 96(<0arg1p=int64#5),>0ab6=int6464#7
# asm 2: movdqa 96(<0arg1p=%r8),>0ab6=%xmm6
movdqa 96(%r8),%xmm6

# qhasm: 0t6 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t6=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t6=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t6 *= *(int128 *)(op1 + 0)
# asm 1: mulpd 0(<op1=int64#2),<0t6=int6464#13
# asm 2: mulpd 0(<op1=%rsi),<0t6=%xmm12
mulpd 0(%rsi),%xmm12

# qhasm: float6464 0r6 +=0t6
# asm 1: addpd <0t6=int6464#13,<0r6=int6464#8
# asm 2: addpd <0t6=%xmm12,<0r6=%xmm7
addpd %xmm12,%xmm7

# qhasm: 0t7 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t7=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t7=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t7 *= *(int128 *)(op1 + 16)
# asm 1: mulpd 16(<op1=int64#2),<0t7=int6464#13
# asm 2: mulpd 16(<op1=%rsi),<0t7=%xmm12
mulpd 16(%rsi),%xmm12

# qhasm: float6464 0r7 +=0t7
# asm 1: addpd <0t7=int6464#13,<0r7=int6464#9
# asm 2: addpd <0t7=%xmm12,<0r7=%xmm8
addpd %xmm12,%xmm8

# qhasm: 0t8 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t8=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t8=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t8 *= *(int128 *)(op1 + 32)
# asm 1: mulpd 32(<op1=int64#2),<0t8=int6464#13
# asm 2: mulpd 32(<op1=%rsi),<0t8=%xmm12
mulpd 32(%rsi),%xmm12

# qhasm: float6464 0r8 +=0t8
# asm 1: addpd <0t8=int6464#13,<0r8=int6464#10
# asm 2: addpd <0t8=%xmm12,<0r8=%xmm9
addpd %xmm12,%xmm9

# qhasm: 0t9 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t9=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t9=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t9 *= *(int128 *)(op1 + 48)
# asm 1: mulpd 48(<op1=int64#2),<0t9=int6464#13
# asm 2: mulpd 48(<op1=%rsi),<0t9=%xmm12
mulpd 48(%rsi),%xmm12

# qhasm: float6464 0r9 +=0t9
# asm 1: addpd <0t9=int6464#13,<0r9=int6464#11
# asm 2: addpd <0t9=%xmm12,<0r9=%xmm10
addpd %xmm12,%xmm10

# qhasm: 0t10 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t10=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t10=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t10 *= *(int128 *)(op1 + 64)
# asm 1: mulpd 64(<op1=int64#2),<0t10=int6464#13
# asm 2: mulpd 64(<op1=%rsi),<0t10=%xmm12
mulpd 64(%rsi),%xmm12

# qhasm: float6464 0r10 +=0t10
# asm 1: addpd <0t10=int6464#13,<0r10=int6464#12
# asm 2: addpd <0t10=%xmm12,<0r10=%xmm11
addpd %xmm12,%xmm11

# qhasm: 0t11 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>0t11=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>0t11=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0t11 *= *(int128 *)(op1 + 80)
# asm 1: mulpd 80(<op1=int64#2),<0t11=int6464#13
# asm 2: mulpd 80(<op1=%rsi),<0t11=%xmm12
mulpd 80(%rsi),%xmm12

# qhasm: float6464 0r11 +=0t11
# asm 1: addpd <0t11=int6464#13,<0r11=int6464#1
# asm 2: addpd <0t11=%xmm12,<0r11=%xmm0
addpd %xmm12,%xmm0

# qhasm: 1t12 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>1t12=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>1t12=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 1t12 *= *(int128 *)(op1 + 96)
# asm 1: mulpd 96(<op1=int64#2),<1t12=int6464#13
# asm 2: mulpd 96(<op1=%rsi),<1t12=%xmm12
mulpd 96(%rsi),%xmm12

# qhasm: float6464 0t12 +=1t12
# asm 1: addpd <1t12=int6464#13,<0t12=int6464#2
# asm 2: addpd <1t12=%xmm12,<0t12=%xmm1
addpd %xmm12,%xmm1

# qhasm: 1t13 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>1t13=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>1t13=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 1t13 *= *(int128 *)(op1 + 112)
# asm 1: mulpd 112(<op1=int64#2),<1t13=int6464#13
# asm 2: mulpd 112(<op1=%rsi),<1t13=%xmm12
mulpd 112(%rsi),%xmm12

# qhasm: float6464 0t13 +=1t13
# asm 1: addpd <1t13=int6464#13,<0t13=int6464#3
# asm 2: addpd <1t13=%xmm12,<0t13=%xmm2
addpd %xmm12,%xmm2

# qhasm: 1t14 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>1t14=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>1t14=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 1t14 *= *(int128 *)(op1 + 128)
# asm 1: mulpd 128(<op1=int64#2),<1t14=int6464#13
# asm 2: mulpd 128(<op1=%rsi),<1t14=%xmm12
mulpd 128(%rsi),%xmm12

# qhasm: float6464 0t14 +=1t14
# asm 1: addpd <1t14=int6464#13,<0t14=int6464#4
# asm 2: addpd <1t14=%xmm12,<0t14=%xmm3
addpd %xmm12,%xmm3

# qhasm: 1t15 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>1t15=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>1t15=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 1t15 *= *(int128 *)(op1 + 144)
# asm 1: mulpd 144(<op1=int64#2),<1t15=int6464#13
# asm 2: mulpd 144(<op1=%rsi),<1t15=%xmm12
mulpd 144(%rsi),%xmm12

# qhasm: float6464 0t15 +=1t15
# asm 1: addpd <1t15=int6464#13,<0t15=int6464#5
# asm 2: addpd <1t15=%xmm12,<0t15=%xmm4
addpd %xmm12,%xmm4

# qhasm: 1t16 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>1t16=int6464#13
# asm 2: movdqa <0ab6=%xmm6,>1t16=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 1t16 *= *(int128 *)(op1 + 160)
# asm 1: mulpd 160(<op1=int64#2),<1t16=int6464#13
# asm 2: mulpd 160(<op1=%rsi),<1t16=%xmm12
mulpd 160(%rsi),%xmm12

# qhasm: float6464 0t16 +=1t16
# asm 1: addpd <1t16=int6464#13,<0t16=int6464#6
# asm 2: addpd <1t16=%xmm12,<0t16=%xmm5
addpd %xmm12,%xmm5

# qhasm: 1t17 = 0ab6
# asm 1: movdqa <0ab6=int6464#7,>1t17=int6464#7
# asm 2: movdqa <0ab6=%xmm6,>1t17=%xmm6
movdqa %xmm6,%xmm6

# qhasm: float6464 1t17 *= *(int128 *)(op1 + 176)
# asm 1: mulpd 176(<op1=int64#2),<1t17=int6464#7
# asm 2: mulpd 176(<op1=%rsi),<1t17=%xmm6
mulpd 176(%rsi),%xmm6

# qhasm: 0t17 =1t17
# asm 1: movdqa <1t17=int6464#7,>0t17=int6464#7
# asm 2: movdqa <1t17=%xmm6,>0t17=%xmm6
movdqa %xmm6,%xmm6

# qhasm: *(int128 *)(1mysp + 96) = 0r6
# asm 1: movdqa <0r6=int6464#8,96(<1mysp=int64#4)
# asm 2: movdqa <0r6=%xmm7,96(<1mysp=%rcx)
movdqa %xmm7,96(%rcx)

# qhasm: 0ab7 = *(int128 *)(0arg1p + 112)
# asm 1: movdqa 112(<0arg1p=int64#5),>0ab7=int6464#8
# asm 2: movdqa 112(<0arg1p=%r8),>0ab7=%xmm7
movdqa 112(%r8),%xmm7

# qhasm: 0ab7six = 0ab7
# asm 1: movdqa <0ab7=int6464#8,>0ab7six=int6464#13
# asm 2: movdqa <0ab7=%xmm7,>0ab7six=%xmm12
movdqa %xmm7,%xmm12

# qhasm: float6464 0ab7six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0ab7six=int6464#13
# asm 2: mulpd SIX_SIX,<0ab7six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: 0t7 = 0ab7
# asm 1: movdqa <0ab7=int6464#8,>0t7=int6464#14
# asm 2: movdqa <0ab7=%xmm7,>0t7=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 0t7 *= *(int128 *)(op1 + 0)
# asm 1: mulpd 0(<op1=int64#2),<0t7=int6464#14
# asm 2: mulpd 0(<op1=%rsi),<0t7=%xmm13
mulpd 0(%rsi),%xmm13

# qhasm: float6464 0r7 +=0t7
# asm 1: addpd <0t7=int6464#14,<0r7=int6464#9
# asm 2: addpd <0t7=%xmm13,<0r7=%xmm8
addpd %xmm13,%xmm8

# qhasm: 1t13 = 0ab7
# asm 1: movdqa <0ab7=int6464#8,>1t13=int6464#8
# asm 2: movdqa <0ab7=%xmm7,>1t13=%xmm7
movdqa %xmm7,%xmm7

# qhasm: float6464 1t13 *= *(int128 *)(op1 + 96)
# asm 1: mulpd 96(<op1=int64#2),<1t13=int6464#8
# asm 2: mulpd 96(<op1=%rsi),<1t13=%xmm7
mulpd 96(%rsi),%xmm7

# qhasm: float6464 0t13 +=1t13
# asm 1: addpd <1t13=int6464#8,<0t13=int6464#3
# asm 2: addpd <1t13=%xmm7,<0t13=%xmm2
addpd %xmm7,%xmm2

# qhasm: 0t8 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>0t8=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>0t8=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 0t8 *= *(int128 *)(op1 + 16)
# asm 1: mulpd 16(<op1=int64#2),<0t8=int6464#8
# asm 2: mulpd 16(<op1=%rsi),<0t8=%xmm7
mulpd 16(%rsi),%xmm7

# qhasm: float6464 0r8 +=0t8
# asm 1: addpd <0t8=int6464#8,<0r8=int6464#10
# asm 2: addpd <0t8=%xmm7,<0r8=%xmm9
addpd %xmm7,%xmm9

# qhasm: 0t9 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>0t9=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>0t9=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 0t9 *= *(int128 *)(op1 + 32)
# asm 1: mulpd 32(<op1=int64#2),<0t9=int6464#8
# asm 2: mulpd 32(<op1=%rsi),<0t9=%xmm7
mulpd 32(%rsi),%xmm7

# qhasm: float6464 0r9 +=0t9
# asm 1: addpd <0t9=int6464#8,<0r9=int6464#11
# asm 2: addpd <0t9=%xmm7,<0r9=%xmm10
addpd %xmm7,%xmm10

# qhasm: 0t10 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>0t10=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>0t10=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 0t10 *= *(int128 *)(op1 + 48)
# asm 1: mulpd 48(<op1=int64#2),<0t10=int6464#8
# asm 2: mulpd 48(<op1=%rsi),<0t10=%xmm7
mulpd 48(%rsi),%xmm7

# qhasm: float6464 0r10 +=0t10
# asm 1: addpd <0t10=int6464#8,<0r10=int6464#12
# asm 2: addpd <0t10=%xmm7,<0r10=%xmm11
addpd %xmm7,%xmm11

# qhasm: 0t11 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>0t11=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>0t11=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 0t11 *= *(int128 *)(op1 + 64)
# asm 1: mulpd 64(<op1=int64#2),<0t11=int6464#8
# asm 2: mulpd 64(<op1=%rsi),<0t11=%xmm7
mulpd 64(%rsi),%xmm7

# qhasm: float6464 0r11 +=0t11
# asm 1: addpd <0t11=int6464#8,<0r11=int6464#1
# asm 2: addpd <0t11=%xmm7,<0r11=%xmm0
addpd %xmm7,%xmm0

# qhasm: 1t12 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>1t12=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>1t12=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 1t12 *= *(int128 *)(op1 + 80)
# asm 1: mulpd 80(<op1=int64#2),<1t12=int6464#8
# asm 2: mulpd 80(<op1=%rsi),<1t12=%xmm7
mulpd 80(%rsi),%xmm7

# qhasm: float6464 0t12 +=1t12
# asm 1: addpd <1t12=int6464#8,<0t12=int6464#2
# asm 2: addpd <1t12=%xmm7,<0t12=%xmm1
addpd %xmm7,%xmm1

# qhasm: 1t14 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>1t14=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>1t14=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 1t14 *= *(int128 *)(op1 + 112)
# asm 1: mulpd 112(<op1=int64#2),<1t14=int6464#8
# asm 2: mulpd 112(<op1=%rsi),<1t14=%xmm7
mulpd 112(%rsi),%xmm7

# qhasm: float6464 0t14 +=1t14
# asm 1: addpd <1t14=int6464#8,<0t14=int6464#4
# asm 2: addpd <1t14=%xmm7,<0t14=%xmm3
addpd %xmm7,%xmm3

# qhasm: 1t15 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>1t15=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>1t15=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 1t15 *= *(int128 *)(op1 + 128)
# asm 1: mulpd 128(<op1=int64#2),<1t15=int6464#8
# asm 2: mulpd 128(<op1=%rsi),<1t15=%xmm7
mulpd 128(%rsi),%xmm7

# qhasm: float6464 0t15 +=1t15
# asm 1: addpd <1t15=int6464#8,<0t15=int6464#5
# asm 2: addpd <1t15=%xmm7,<0t15=%xmm4
addpd %xmm7,%xmm4

# qhasm: 1t16 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>1t16=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>1t16=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 1t16 *= *(int128 *)(op1 + 144)
# asm 1: mulpd 144(<op1=int64#2),<1t16=int6464#8
# asm 2: mulpd 144(<op1=%rsi),<1t16=%xmm7
mulpd 144(%rsi),%xmm7

# qhasm: float6464 0t16 +=1t16
# asm 1: addpd <1t16=int6464#8,<0t16=int6464#6
# asm 2: addpd <1t16=%xmm7,<0t16=%xmm5
addpd %xmm7,%xmm5

# qhasm: 1t17 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>1t17=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>1t17=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 1t17 *= *(int128 *)(op1 + 160)
# asm 1: mulpd 160(<op1=int64#2),<1t17=int6464#8
# asm 2: mulpd 160(<op1=%rsi),<1t17=%xmm7
mulpd 160(%rsi),%xmm7

# qhasm: float6464 0t17 +=1t17
# asm 1: addpd <1t17=int6464#8,<0t17=int6464#7
# asm 2: addpd <1t17=%xmm7,<0t17=%xmm6
addpd %xmm7,%xmm6

# qhasm: 1t18 = 0ab7six
# asm 1: movdqa <0ab7six=int6464#13,>1t18=int6464#8
# asm 2: movdqa <0ab7six=%xmm12,>1t18=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 1t18 *= *(int128 *)(op1 + 176)
# asm 1: mulpd 176(<op1=int64#2),<1t18=int6464#8
# asm 2: mulpd 176(<op1=%rsi),<1t18=%xmm7
mulpd 176(%rsi),%xmm7

# qhasm: 0t18 =1t18
# asm 1: movdqa <1t18=int6464#8,>0t18=int6464#8
# asm 2: movdqa <1t18=%xmm7,>0t18=%xmm7
movdqa %xmm7,%xmm7

# qhasm: *(int128 *)(1mysp + 112) = 0r7
# asm 1: movdqa <0r7=int6464#9,112(<1mysp=int64#4)
# asm 2: movdqa <0r7=%xmm8,112(<1mysp=%rcx)
movdqa %xmm8,112(%rcx)

# qhasm: 0ab8 = *(int128 *)(0arg1p + 128)
# asm 1: movdqa 128(<0arg1p=int64#5),>0ab8=int6464#9
# asm 2: movdqa 128(<0arg1p=%r8),>0ab8=%xmm8
movdqa 128(%r8),%xmm8

# qhasm: 0ab8six = 0ab8
# asm 1: movdqa <0ab8=int6464#9,>0ab8six=int6464#13
# asm 2: movdqa <0ab8=%xmm8,>0ab8six=%xmm12
movdqa %xmm8,%xmm12

# qhasm: float6464 0ab8six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0ab8six=int6464#13
# asm 2: mulpd SIX_SIX,<0ab8six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: 0t8 = 0ab8
# asm 1: movdqa <0ab8=int6464#9,>0t8=int6464#14
# asm 2: movdqa <0ab8=%xmm8,>0t8=%xmm13
movdqa %xmm8,%xmm13

# qhasm: float6464 0t8 *= *(int128 *)(op1 + 0)
# asm 1: mulpd 0(<op1=int64#2),<0t8=int6464#14
# asm 2: mulpd 0(<op1=%rsi),<0t8=%xmm13
mulpd 0(%rsi),%xmm13

# qhasm: float6464 0r8 +=0t8
# asm 1: addpd <0t8=int6464#14,<0r8=int6464#10
# asm 2: addpd <0t8=%xmm13,<0r8=%xmm9
addpd %xmm13,%xmm9

# qhasm: 1t13 = 0ab8
# asm 1: movdqa <0ab8=int6464#9,>1t13=int6464#14
# asm 2: movdqa <0ab8=%xmm8,>1t13=%xmm13
movdqa %xmm8,%xmm13

# qhasm: float6464 1t13 *= *(int128 *)(op1 + 80)
# asm 1: mulpd 80(<op1=int64#2),<1t13=int6464#14
# asm 2: mulpd 80(<op1=%rsi),<1t13=%xmm13
mulpd 80(%rsi),%xmm13

# qhasm: float6464 0t13 +=1t13
# asm 1: addpd <1t13=int6464#14,<0t13=int6464#3
# asm 2: addpd <1t13=%xmm13,<0t13=%xmm2
addpd %xmm13,%xmm2

# qhasm: 1t14 = 0ab8
# asm 1: movdqa <0ab8=int6464#9,>1t14=int6464#14
# asm 2: movdqa <0ab8=%xmm8,>1t14=%xmm13
movdqa %xmm8,%xmm13

# qhasm: float6464 1t14 *= *(int128 *)(op1 + 96)
# asm 1: mulpd 96(<op1=int64#2),<1t14=int6464#14
# asm 2: mulpd 96(<op1=%rsi),<1t14=%xmm13
mulpd 96(%rsi),%xmm13

# qhasm: float6464 0t14 +=1t14
# asm 1: addpd <1t14=int6464#14,<0t14=int6464#4
# asm 2: addpd <1t14=%xmm13,<0t14=%xmm3
addpd %xmm13,%xmm3

# qhasm: 1t19 = 0ab8
# asm 1: movdqa <0ab8=int6464#9,>1t19=int6464#9
# asm 2: movdqa <0ab8=%xmm8,>1t19=%xmm8
movdqa %xmm8,%xmm8

# qhasm: float6464 1t19 *= *(int128 *)(op1 + 176)
# asm 1: mulpd 176(<op1=int64#2),<1t19=int6464#9
# asm 2: mulpd 176(<op1=%rsi),<1t19=%xmm8
mulpd 176(%rsi),%xmm8

# qhasm: 0t19 =1t19
# asm 1: movdqa <1t19=int6464#9,>0t19=int6464#9
# asm 2: movdqa <1t19=%xmm8,>0t19=%xmm8
movdqa %xmm8,%xmm8

# qhasm: 0t9 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>0t9=int6464#14
# asm 2: movdqa <0ab8six=%xmm12,>0t9=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t9 *= *(int128 *)(op1 + 16)
# asm 1: mulpd 16(<op1=int64#2),<0t9=int6464#14
# asm 2: mulpd 16(<op1=%rsi),<0t9=%xmm13
mulpd 16(%rsi),%xmm13

# qhasm: float6464 0r9 +=0t9
# asm 1: addpd <0t9=int6464#14,<0r9=int6464#11
# asm 2: addpd <0t9=%xmm13,<0r9=%xmm10
addpd %xmm13,%xmm10

# qhasm: 0t10 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>0t10=int6464#14
# asm 2: movdqa <0ab8six=%xmm12,>0t10=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t10 *= *(int128 *)(op1 + 32)
# asm 1: mulpd 32(<op1=int64#2),<0t10=int6464#14
# asm 2: mulpd 32(<op1=%rsi),<0t10=%xmm13
mulpd 32(%rsi),%xmm13

# qhasm: float6464 0r10 +=0t10
# asm 1: addpd <0t10=int6464#14,<0r10=int6464#12
# asm 2: addpd <0t10=%xmm13,<0r10=%xmm11
addpd %xmm13,%xmm11

# qhasm: 0t11 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>0t11=int6464#14
# asm 2: movdqa <0ab8six=%xmm12,>0t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t11 *= *(int128 *)(op1 + 48)
# asm 1: mulpd 48(<op1=int64#2),<0t11=int6464#14
# asm 2: mulpd 48(<op1=%rsi),<0t11=%xmm13
mulpd 48(%rsi),%xmm13

# qhasm: float6464 0r11 +=0t11
# asm 1: addpd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addpd <0t11=%xmm13,<0r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: 1t12 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>1t12=int6464#14
# asm 2: movdqa <0ab8six=%xmm12,>1t12=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 1t12 *= *(int128 *)(op1 + 64)
# asm 1: mulpd 64(<op1=int64#2),<1t12=int6464#14
# asm 2: mulpd 64(<op1=%rsi),<1t12=%xmm13
mulpd 64(%rsi),%xmm13

# qhasm: float6464 0t12 +=1t12
# asm 1: addpd <1t12=int6464#14,<0t12=int6464#2
# asm 2: addpd <1t12=%xmm13,<0t12=%xmm1
addpd %xmm13,%xmm1

# qhasm: 1t15 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>1t15=int6464#14
# asm 2: movdqa <0ab8six=%xmm12,>1t15=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 1t15 *= *(int128 *)(op1 + 112)
# asm 1: mulpd 112(<op1=int64#2),<1t15=int6464#14
# asm 2: mulpd 112(<op1=%rsi),<1t15=%xmm13
mulpd 112(%rsi),%xmm13

# qhasm: float6464 0t15 +=1t15
# asm 1: addpd <1t15=int6464#14,<0t15=int6464#5
# asm 2: addpd <1t15=%xmm13,<0t15=%xmm4
addpd %xmm13,%xmm4

# qhasm: 1t16 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>1t16=int6464#14
# asm 2: movdqa <0ab8six=%xmm12,>1t16=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 1t16 *= *(int128 *)(op1 + 128)
# asm 1: mulpd 128(<op1=int64#2),<1t16=int6464#14
# asm 2: mulpd 128(<op1=%rsi),<1t16=%xmm13
mulpd 128(%rsi),%xmm13

# qhasm: float6464 0t16 +=1t16
# asm 1: addpd <1t16=int6464#14,<0t16=int6464#6
# asm 2: addpd <1t16=%xmm13,<0t16=%xmm5
addpd %xmm13,%xmm5

# qhasm: 1t17 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>1t17=int6464#14
# asm 2: movdqa <0ab8six=%xmm12,>1t17=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 1t17 *= *(int128 *)(op1 + 144)
# asm 1: mulpd 144(<op1=int64#2),<1t17=int6464#14
# asm 2: mulpd 144(<op1=%rsi),<1t17=%xmm13
mulpd 144(%rsi),%xmm13

# qhasm: float6464 0t17 +=1t17
# asm 1: addpd <1t17=int6464#14,<0t17=int6464#7
# asm 2: addpd <1t17=%xmm13,<0t17=%xmm6
addpd %xmm13,%xmm6

# qhasm: 1t18 = 0ab8six
# asm 1: movdqa <0ab8six=int6464#13,>1t18=int6464#13
# asm 2: movdqa <0ab8six=%xmm12,>1t18=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 1t18 *= *(int128 *)(op1 + 160)
# asm 1: mulpd 160(<op1=int64#2),<1t18=int6464#13
# asm 2: mulpd 160(<op1=%rsi),<1t18=%xmm12
mulpd 160(%rsi),%xmm12

# qhasm: float6464 0t18 +=1t18
# asm 1: addpd <1t18=int6464#13,<0t18=int6464#8
# asm 2: addpd <1t18=%xmm12,<0t18=%xmm7
addpd %xmm12,%xmm7

# qhasm: *(int128 *)(1mysp + 128) = 0r8
# asm 1: movdqa <0r8=int6464#10,128(<1mysp=int64#4)
# asm 2: movdqa <0r8=%xmm9,128(<1mysp=%rcx)
movdqa %xmm9,128(%rcx)

# qhasm: 0ab9 = *(int128 *)(0arg1p + 144)
# asm 1: movdqa 144(<0arg1p=int64#5),>0ab9=int6464#10
# asm 2: movdqa 144(<0arg1p=%r8),>0ab9=%xmm9
movdqa 144(%r8),%xmm9

# qhasm: 0ab9six = 0ab9
# asm 1: movdqa <0ab9=int6464#10,>0ab9six=int6464#13
# asm 2: movdqa <0ab9=%xmm9,>0ab9six=%xmm12
movdqa %xmm9,%xmm12

# qhasm: float6464 0ab9six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0ab9six=int6464#13
# asm 2: mulpd SIX_SIX,<0ab9six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: 0t9 = 0ab9
# asm 1: movdqa <0ab9=int6464#10,>0t9=int6464#14
# asm 2: movdqa <0ab9=%xmm9,>0t9=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 0t9 *= *(int128 *)(op1 + 0)
# asm 1: mulpd 0(<op1=int64#2),<0t9=int6464#14
# asm 2: mulpd 0(<op1=%rsi),<0t9=%xmm13
mulpd 0(%rsi),%xmm13

# qhasm: float6464 0r9 +=0t9
# asm 1: addpd <0t9=int6464#14,<0r9=int6464#11
# asm 2: addpd <0t9=%xmm13,<0r9=%xmm10
addpd %xmm13,%xmm10

# qhasm: 1t13 = 0ab9
# asm 1: movdqa <0ab9=int6464#10,>1t13=int6464#14
# asm 2: movdqa <0ab9=%xmm9,>1t13=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 1t13 *= *(int128 *)(op1 + 64)
# asm 1: mulpd 64(<op1=int64#2),<1t13=int6464#14
# asm 2: mulpd 64(<op1=%rsi),<1t13=%xmm13
mulpd 64(%rsi),%xmm13

# qhasm: float6464 0t13 +=1t13
# asm 1: addpd <1t13=int6464#14,<0t13=int6464#3
# asm 2: addpd <1t13=%xmm13,<0t13=%xmm2
addpd %xmm13,%xmm2

# qhasm: 1t14 = 0ab9
# asm 1: movdqa <0ab9=int6464#10,>1t14=int6464#14
# asm 2: movdqa <0ab9=%xmm9,>1t14=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 1t14 *= *(int128 *)(op1 + 80)
# asm 1: mulpd 80(<op1=int64#2),<1t14=int6464#14
# asm 2: mulpd 80(<op1=%rsi),<1t14=%xmm13
mulpd 80(%rsi),%xmm13

# qhasm: float6464 0t14 +=1t14
# asm 1: addpd <1t14=int6464#14,<0t14=int6464#4
# asm 2: addpd <1t14=%xmm13,<0t14=%xmm3
addpd %xmm13,%xmm3

# qhasm: 1t15 = 0ab9
# asm 1: movdqa <0ab9=int6464#10,>1t15=int6464#14
# asm 2: movdqa <0ab9=%xmm9,>1t15=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 1t15 *= *(int128 *)(op1 + 96)
# asm 1: mulpd 96(<op1=int64#2),<1t15=int6464#14
# asm 2: mulpd 96(<op1=%rsi),<1t15=%xmm13
mulpd 96(%rsi),%xmm13

# qhasm: float6464 0t15 +=1t15
# asm 1: addpd <1t15=int6464#14,<0t15=int6464#5
# asm 2: addpd <1t15=%xmm13,<0t15=%xmm4
addpd %xmm13,%xmm4

# qhasm: 1t19 = 0ab9
# asm 1: movdqa <0ab9=int6464#10,>1t19=int6464#14
# asm 2: movdqa <0ab9=%xmm9,>1t19=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 1t19 *= *(int128 *)(op1 + 160)
# asm 1: mulpd 160(<op1=int64#2),<1t19=int6464#14
# asm 2: mulpd 160(<op1=%rsi),<1t19=%xmm13
mulpd 160(%rsi),%xmm13

# qhasm: float6464 0t19 +=1t19
# asm 1: addpd <1t19=int6464#14,<0t19=int6464#9
# asm 2: addpd <1t19=%xmm13,<0t19=%xmm8
addpd %xmm13,%xmm8

# qhasm: 1t20 = 0ab9
# asm 1: movdqa <0ab9=int6464#10,>1t20=int6464#10
# asm 2: movdqa <0ab9=%xmm9,>1t20=%xmm9
movdqa %xmm9,%xmm9

# qhasm: float6464 1t20 *= *(int128 *)(op1 + 176)
# asm 1: mulpd 176(<op1=int64#2),<1t20=int6464#10
# asm 2: mulpd 176(<op1=%rsi),<1t20=%xmm9
mulpd 176(%rsi),%xmm9

# qhasm: 0t20 =1t20
# asm 1: movdqa <1t20=int6464#10,>0t20=int6464#10
# asm 2: movdqa <1t20=%xmm9,>0t20=%xmm9
movdqa %xmm9,%xmm9

# qhasm: 0t10 = 0ab9six
# asm 1: movdqa <0ab9six=int6464#13,>0t10=int6464#14
# asm 2: movdqa <0ab9six=%xmm12,>0t10=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t10 *= *(int128 *)(op1 + 16)
# asm 1: mulpd 16(<op1=int64#2),<0t10=int6464#14
# asm 2: mulpd 16(<op1=%rsi),<0t10=%xmm13
mulpd 16(%rsi),%xmm13

# qhasm: float6464 0r10 +=0t10
# asm 1: addpd <0t10=int6464#14,<0r10=int6464#12
# asm 2: addpd <0t10=%xmm13,<0r10=%xmm11
addpd %xmm13,%xmm11

# qhasm: 0t11 = 0ab9six
# asm 1: movdqa <0ab9six=int6464#13,>0t11=int6464#14
# asm 2: movdqa <0ab9six=%xmm12,>0t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t11 *= *(int128 *)(op1 + 32)
# asm 1: mulpd 32(<op1=int64#2),<0t11=int6464#14
# asm 2: mulpd 32(<op1=%rsi),<0t11=%xmm13
mulpd 32(%rsi),%xmm13

# qhasm: float6464 0r11 +=0t11
# asm 1: addpd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addpd <0t11=%xmm13,<0r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: 1t12 = 0ab9six
# asm 1: movdqa <0ab9six=int6464#13,>1t12=int6464#14
# asm 2: movdqa <0ab9six=%xmm12,>1t12=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 1t12 *= *(int128 *)(op1 + 48)
# asm 1: mulpd 48(<op1=int64#2),<1t12=int6464#14
# asm 2: mulpd 48(<op1=%rsi),<1t12=%xmm13
mulpd 48(%rsi),%xmm13

# qhasm: float6464 0t12 +=1t12
# asm 1: addpd <1t12=int6464#14,<0t12=int6464#2
# asm 2: addpd <1t12=%xmm13,<0t12=%xmm1
addpd %xmm13,%xmm1

# qhasm: 1t16 = 0ab9six
# asm 1: movdqa <0ab9six=int6464#13,>1t16=int6464#14
# asm 2: movdqa <0ab9six=%xmm12,>1t16=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 1t16 *= *(int128 *)(op1 + 112)
# asm 1: mulpd 112(<op1=int64#2),<1t16=int6464#14
# asm 2: mulpd 112(<op1=%rsi),<1t16=%xmm13
mulpd 112(%rsi),%xmm13

# qhasm: float6464 0t16 +=1t16
# asm 1: addpd <1t16=int6464#14,<0t16=int6464#6
# asm 2: addpd <1t16=%xmm13,<0t16=%xmm5
addpd %xmm13,%xmm5

# qhasm: 1t17 = 0ab9six
# asm 1: movdqa <0ab9six=int6464#13,>1t17=int6464#14
# asm 2: movdqa <0ab9six=%xmm12,>1t17=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 1t17 *= *(int128 *)(op1 + 128)
# asm 1: mulpd 128(<op1=int64#2),<1t17=int6464#14
# asm 2: mulpd 128(<op1=%rsi),<1t17=%xmm13
mulpd 128(%rsi),%xmm13

# qhasm: float6464 0t17 +=1t17
# asm 1: addpd <1t17=int6464#14,<0t17=int6464#7
# asm 2: addpd <1t17=%xmm13,<0t17=%xmm6
addpd %xmm13,%xmm6

# qhasm: 1t18 = 0ab9six
# asm 1: movdqa <0ab9six=int6464#13,>1t18=int6464#13
# asm 2: movdqa <0ab9six=%xmm12,>1t18=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 1t18 *= *(int128 *)(op1 + 144)
# asm 1: mulpd 144(<op1=int64#2),<1t18=int6464#13
# asm 2: mulpd 144(<op1=%rsi),<1t18=%xmm12
mulpd 144(%rsi),%xmm12

# qhasm: float6464 0t18 +=1t18
# asm 1: addpd <1t18=int6464#13,<0t18=int6464#8
# asm 2: addpd <1t18=%xmm12,<0t18=%xmm7
addpd %xmm12,%xmm7

# qhasm: *(int128 *)(1mysp + 144) = 0r9
# asm 1: movdqa <0r9=int6464#11,144(<1mysp=int64#4)
# asm 2: movdqa <0r9=%xmm10,144(<1mysp=%rcx)
movdqa %xmm10,144(%rcx)

# qhasm: 0ab10 = *(int128 *)(0arg1p + 160)
# asm 1: movdqa 160(<0arg1p=int64#5),>0ab10=int6464#11
# asm 2: movdqa 160(<0arg1p=%r8),>0ab10=%xmm10
movdqa 160(%r8),%xmm10

# qhasm: 0ab10six = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>0ab10six=int6464#13
# asm 2: movdqa <0ab10=%xmm10,>0ab10six=%xmm12
movdqa %xmm10,%xmm12

# qhasm: float6464 0ab10six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0ab10six=int6464#13
# asm 2: mulpd SIX_SIX,<0ab10six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: 0t10 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>0t10=int6464#14
# asm 2: movdqa <0ab10=%xmm10,>0t10=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 0t10 *= *(int128 *)(op1 + 0)
# asm 1: mulpd 0(<op1=int64#2),<0t10=int6464#14
# asm 2: mulpd 0(<op1=%rsi),<0t10=%xmm13
mulpd 0(%rsi),%xmm13

# qhasm: float6464 0r10 +=0t10
# asm 1: addpd <0t10=int6464#14,<0r10=int6464#12
# asm 2: addpd <0t10=%xmm13,<0r10=%xmm11
addpd %xmm13,%xmm11

# qhasm: 1t13 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>1t13=int6464#14
# asm 2: movdqa <0ab10=%xmm10,>1t13=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 1t13 *= *(int128 *)(op1 + 48)
# asm 1: mulpd 48(<op1=int64#2),<1t13=int6464#14
# asm 2: mulpd 48(<op1=%rsi),<1t13=%xmm13
mulpd 48(%rsi),%xmm13

# qhasm: float6464 0t13 +=1t13
# asm 1: addpd <1t13=int6464#14,<0t13=int6464#3
# asm 2: addpd <1t13=%xmm13,<0t13=%xmm2
addpd %xmm13,%xmm2

# qhasm: 1t14 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>1t14=int6464#14
# asm 2: movdqa <0ab10=%xmm10,>1t14=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 1t14 *= *(int128 *)(op1 + 64)
# asm 1: mulpd 64(<op1=int64#2),<1t14=int6464#14
# asm 2: mulpd 64(<op1=%rsi),<1t14=%xmm13
mulpd 64(%rsi),%xmm13

# qhasm: float6464 0t14 +=1t14
# asm 1: addpd <1t14=int6464#14,<0t14=int6464#4
# asm 2: addpd <1t14=%xmm13,<0t14=%xmm3
addpd %xmm13,%xmm3

# qhasm: 1t16 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>1t16=int6464#14
# asm 2: movdqa <0ab10=%xmm10,>1t16=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 1t16 *= *(int128 *)(op1 + 96)
# asm 1: mulpd 96(<op1=int64#2),<1t16=int6464#14
# asm 2: mulpd 96(<op1=%rsi),<1t16=%xmm13
mulpd 96(%rsi),%xmm13

# qhasm: float6464 0t16 +=1t16
# asm 1: addpd <1t16=int6464#14,<0t16=int6464#6
# asm 2: addpd <1t16=%xmm13,<0t16=%xmm5
addpd %xmm13,%xmm5

# qhasm: 1t15 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>1t15=int6464#14
# asm 2: movdqa <0ab10=%xmm10,>1t15=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 1t15 *= *(int128 *)(op1 + 80)
# asm 1: mulpd 80(<op1=int64#2),<1t15=int6464#14
# asm 2: mulpd 80(<op1=%rsi),<1t15=%xmm13
mulpd 80(%rsi),%xmm13

# qhasm: float6464 0t15 +=1t15
# asm 1: addpd <1t15=int6464#14,<0t15=int6464#5
# asm 2: addpd <1t15=%xmm13,<0t15=%xmm4
addpd %xmm13,%xmm4

# qhasm: 1t19 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>1t19=int6464#14
# asm 2: movdqa <0ab10=%xmm10,>1t19=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 1t19 *= *(int128 *)(op1 + 144)
# asm 1: mulpd 144(<op1=int64#2),<1t19=int6464#14
# asm 2: mulpd 144(<op1=%rsi),<1t19=%xmm13
mulpd 144(%rsi),%xmm13

# qhasm: float6464 0t19 +=1t19
# asm 1: addpd <1t19=int6464#14,<0t19=int6464#9
# asm 2: addpd <1t19=%xmm13,<0t19=%xmm8
addpd %xmm13,%xmm8

# qhasm: 1t20 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>1t20=int6464#14
# asm 2: movdqa <0ab10=%xmm10,>1t20=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 1t20 *= *(int128 *)(op1 + 160)
# asm 1: mulpd 160(<op1=int64#2),<1t20=int6464#14
# asm 2: mulpd 160(<op1=%rsi),<1t20=%xmm13
mulpd 160(%rsi),%xmm13

# qhasm: float6464 0t20 +=1t20
# asm 1: addpd <1t20=int6464#14,<0t20=int6464#10
# asm 2: addpd <1t20=%xmm13,<0t20=%xmm9
addpd %xmm13,%xmm9

# qhasm: 1t21 = 0ab10
# asm 1: movdqa <0ab10=int6464#11,>1t21=int6464#11
# asm 2: movdqa <0ab10=%xmm10,>1t21=%xmm10
movdqa %xmm10,%xmm10

# qhasm: float6464 1t21 *= *(int128 *)(op1 + 176)
# asm 1: mulpd 176(<op1=int64#2),<1t21=int6464#11
# asm 2: mulpd 176(<op1=%rsi),<1t21=%xmm10
mulpd 176(%rsi),%xmm10

# qhasm: 0t21 =1t21
# asm 1: movdqa <1t21=int6464#11,>0t21=int6464#11
# asm 2: movdqa <1t21=%xmm10,>0t21=%xmm10
movdqa %xmm10,%xmm10

# qhasm: 0t11 = 0ab10six
# asm 1: movdqa <0ab10six=int6464#13,>0t11=int6464#14
# asm 2: movdqa <0ab10six=%xmm12,>0t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 0t11 *= *(int128 *)(op1 + 16)
# asm 1: mulpd 16(<op1=int64#2),<0t11=int6464#14
# asm 2: mulpd 16(<op1=%rsi),<0t11=%xmm13
mulpd 16(%rsi),%xmm13

# qhasm: float6464 0r11 +=0t11
# asm 1: addpd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addpd <0t11=%xmm13,<0r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: 1t12 = 0ab10six
# asm 1: movdqa <0ab10six=int6464#13,>1t12=int6464#14
# asm 2: movdqa <0ab10six=%xmm12,>1t12=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 1t12 *= *(int128 *)(op1 + 32)
# asm 1: mulpd 32(<op1=int64#2),<1t12=int6464#14
# asm 2: mulpd 32(<op1=%rsi),<1t12=%xmm13
mulpd 32(%rsi),%xmm13

# qhasm: float6464 0t12 +=1t12
# asm 1: addpd <1t12=int6464#14,<0t12=int6464#2
# asm 2: addpd <1t12=%xmm13,<0t12=%xmm1
addpd %xmm13,%xmm1

# qhasm: 1t17 = 0ab10six
# asm 1: movdqa <0ab10six=int6464#13,>1t17=int6464#14
# asm 2: movdqa <0ab10six=%xmm12,>1t17=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 1t17 *= *(int128 *)(op1 + 112)
# asm 1: mulpd 112(<op1=int64#2),<1t17=int6464#14
# asm 2: mulpd 112(<op1=%rsi),<1t17=%xmm13
mulpd 112(%rsi),%xmm13

# qhasm: float6464 0t17 +=1t17
# asm 1: addpd <1t17=int6464#14,<0t17=int6464#7
# asm 2: addpd <1t17=%xmm13,<0t17=%xmm6
addpd %xmm13,%xmm6

# qhasm: 1t18 = 0ab10six
# asm 1: movdqa <0ab10six=int6464#13,>1t18=int6464#13
# asm 2: movdqa <0ab10six=%xmm12,>1t18=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 1t18 *= *(int128 *)(op1 + 128)
# asm 1: mulpd 128(<op1=int64#2),<1t18=int6464#13
# asm 2: mulpd 128(<op1=%rsi),<1t18=%xmm12
mulpd 128(%rsi),%xmm12

# qhasm: float6464 0t18 +=1t18
# asm 1: addpd <1t18=int6464#13,<0t18=int6464#8
# asm 2: addpd <1t18=%xmm12,<0t18=%xmm7
addpd %xmm12,%xmm7

# qhasm: *(int128 *)(1mysp + 160) = 0r10
# asm 1: movdqa <0r10=int6464#12,160(<1mysp=int64#4)
# asm 2: movdqa <0r10=%xmm11,160(<1mysp=%rcx)
movdqa %xmm11,160(%rcx)

# qhasm: 0ab11 = *(int128 *)(0arg1p + 176)
# asm 1: movdqa 176(<0arg1p=int64#5),>0ab11=int6464#12
# asm 2: movdqa 176(<0arg1p=%r8),>0ab11=%xmm11
movdqa 176(%r8),%xmm11

# qhasm: 0ab11six = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>0ab11six=int6464#13
# asm 2: movdqa <0ab11=%xmm11,>0ab11six=%xmm12
movdqa %xmm11,%xmm12

# qhasm: float6464 0ab11six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0ab11six=int6464#13
# asm 2: mulpd SIX_SIX,<0ab11six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: 0t11 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>0t11=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>0t11=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 0t11 *= *(int128 *)(op1 + 0)
# asm 1: mulpd 0(<op1=int64#2),<0t11=int6464#14
# asm 2: mulpd 0(<op1=%rsi),<0t11=%xmm13
mulpd 0(%rsi),%xmm13

# qhasm: float6464 0r11 +=0t11
# asm 1: addpd <0t11=int6464#14,<0r11=int6464#1
# asm 2: addpd <0t11=%xmm13,<0r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: 1t13 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>1t13=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>1t13=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 1t13 *= *(int128 *)(op1 + 32)
# asm 1: mulpd 32(<op1=int64#2),<1t13=int6464#14
# asm 2: mulpd 32(<op1=%rsi),<1t13=%xmm13
mulpd 32(%rsi),%xmm13

# qhasm: float6464 0t13 +=1t13
# asm 1: addpd <1t13=int6464#14,<0t13=int6464#3
# asm 2: addpd <1t13=%xmm13,<0t13=%xmm2
addpd %xmm13,%xmm2

# qhasm: 1t14 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>1t14=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>1t14=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 1t14 *= *(int128 *)(op1 + 48)
# asm 1: mulpd 48(<op1=int64#2),<1t14=int6464#14
# asm 2: mulpd 48(<op1=%rsi),<1t14=%xmm13
mulpd 48(%rsi),%xmm13

# qhasm: float6464 0t14 +=1t14
# asm 1: addpd <1t14=int6464#14,<0t14=int6464#4
# asm 2: addpd <1t14=%xmm13,<0t14=%xmm3
addpd %xmm13,%xmm3

# qhasm: 1t15 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>1t15=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>1t15=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 1t15 *= *(int128 *)(op1 + 64)
# asm 1: mulpd 64(<op1=int64#2),<1t15=int6464#14
# asm 2: mulpd 64(<op1=%rsi),<1t15=%xmm13
mulpd 64(%rsi),%xmm13

# qhasm: float6464 0t15 +=1t15
# asm 1: addpd <1t15=int6464#14,<0t15=int6464#5
# asm 2: addpd <1t15=%xmm13,<0t15=%xmm4
addpd %xmm13,%xmm4

# qhasm: 1t16 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>1t16=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>1t16=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 1t16 *= *(int128 *)(op1 + 80)
# asm 1: mulpd 80(<op1=int64#2),<1t16=int6464#14
# asm 2: mulpd 80(<op1=%rsi),<1t16=%xmm13
mulpd 80(%rsi),%xmm13

# qhasm: float6464 0t16 +=1t16
# asm 1: addpd <1t16=int6464#14,<0t16=int6464#6
# asm 2: addpd <1t16=%xmm13,<0t16=%xmm5
addpd %xmm13,%xmm5

# qhasm: 1t17 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>1t17=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>1t17=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 1t17 *= *(int128 *)(op1 + 96)
# asm 1: mulpd 96(<op1=int64#2),<1t17=int6464#14
# asm 2: mulpd 96(<op1=%rsi),<1t17=%xmm13
mulpd 96(%rsi),%xmm13

# qhasm: float6464 0t17 +=1t17
# asm 1: addpd <1t17=int6464#14,<0t17=int6464#7
# asm 2: addpd <1t17=%xmm13,<0t17=%xmm6
addpd %xmm13,%xmm6

# qhasm: 1t19 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>1t19=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>1t19=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 1t19 *= *(int128 *)(op1 + 128)
# asm 1: mulpd 128(<op1=int64#2),<1t19=int6464#14
# asm 2: mulpd 128(<op1=%rsi),<1t19=%xmm13
mulpd 128(%rsi),%xmm13

# qhasm: float6464 0t19 +=1t19
# asm 1: addpd <1t19=int6464#14,<0t19=int6464#9
# asm 2: addpd <1t19=%xmm13,<0t19=%xmm8
addpd %xmm13,%xmm8

# qhasm: 1t20 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>1t20=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>1t20=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 1t20 *= *(int128 *)(op1 + 144)
# asm 1: mulpd 144(<op1=int64#2),<1t20=int6464#14
# asm 2: mulpd 144(<op1=%rsi),<1t20=%xmm13
mulpd 144(%rsi),%xmm13

# qhasm: float6464 0t20 +=1t20
# asm 1: addpd <1t20=int6464#14,<0t20=int6464#10
# asm 2: addpd <1t20=%xmm13,<0t20=%xmm9
addpd %xmm13,%xmm9

# qhasm: 1t21 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>1t21=int6464#14
# asm 2: movdqa <0ab11=%xmm11,>1t21=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 1t21 *= *(int128 *)(op1 + 160)
# asm 1: mulpd 160(<op1=int64#2),<1t21=int6464#14
# asm 2: mulpd 160(<op1=%rsi),<1t21=%xmm13
mulpd 160(%rsi),%xmm13

# qhasm: float6464 0t21 +=1t21
# asm 1: addpd <1t21=int6464#14,<0t21=int6464#11
# asm 2: addpd <1t21=%xmm13,<0t21=%xmm10
addpd %xmm13,%xmm10

# qhasm: 1t22 = 0ab11
# asm 1: movdqa <0ab11=int6464#12,>1t22=int6464#12
# asm 2: movdqa <0ab11=%xmm11,>1t22=%xmm11
movdqa %xmm11,%xmm11

# qhasm: float6464 1t22 *= *(int128 *)(op1 + 176)
# asm 1: mulpd 176(<op1=int64#2),<1t22=int6464#12
# asm 2: mulpd 176(<op1=%rsi),<1t22=%xmm11
mulpd 176(%rsi),%xmm11

# qhasm: 0t22 =1t22
# asm 1: movdqa <1t22=int6464#12,>0t22=int6464#12
# asm 2: movdqa <1t22=%xmm11,>0t22=%xmm11
movdqa %xmm11,%xmm11

# qhasm: 1t12 = 0ab11six
# asm 1: movdqa <0ab11six=int6464#13,>1t12=int6464#14
# asm 2: movdqa <0ab11six=%xmm12,>1t12=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 1t12 *= *(int128 *)(op1 + 16)
# asm 1: mulpd 16(<op1=int64#2),<1t12=int6464#14
# asm 2: mulpd 16(<op1=%rsi),<1t12=%xmm13
mulpd 16(%rsi),%xmm13

# qhasm: float6464 0t12 +=1t12
# asm 1: addpd <1t12=int6464#14,<0t12=int6464#2
# asm 2: addpd <1t12=%xmm13,<0t12=%xmm1
addpd %xmm13,%xmm1

# qhasm: 1t18 = 0ab11six
# asm 1: movdqa <0ab11six=int6464#13,>1t18=int6464#13
# asm 2: movdqa <0ab11six=%xmm12,>1t18=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 1t18 *= *(int128 *)(op1 + 112)
# asm 1: mulpd 112(<op1=int64#2),<1t18=int6464#13
# asm 2: mulpd 112(<op1=%rsi),<1t18=%xmm12
mulpd 112(%rsi),%xmm12

# qhasm: float6464 0t18 +=1t18
# asm 1: addpd <1t18=int6464#13,<0t18=int6464#8
# asm 2: addpd <1t18=%xmm12,<0t18=%xmm7
addpd %xmm12,%xmm7

# qhasm: *(int128 *)(1mysp + 176) = 0r11
# asm 1: movdqa <0r11=int6464#1,176(<1mysp=int64#4)
# asm 2: movdqa <0r11=%xmm0,176(<1mysp=%rcx)
movdqa %xmm0,176(%rcx)

# qhasm: int6464 1r0

# qhasm: int6464 1r1

# qhasm: int6464 1r2

# qhasm: int6464 1r3

# qhasm: int6464 1r4

# qhasm: int6464 1r5

# qhasm: int6464 1r6

# qhasm: int6464 1r7

# qhasm: int6464 1r8

# qhasm: int6464 1r9

# qhasm: int6464 1r10

# qhasm: int6464 1r11

# qhasm: int6464 1t0

# qhasm: int6464 1t1

# qhasm: int6464 1t2

# qhasm: int6464 1t3

# qhasm: int6464 1t4

# qhasm: int6464 1t5

# qhasm: int6464 1t6

# qhasm: int6464 1t7

# qhasm: int6464 1t8

# qhasm: int6464 1t9

# qhasm: int6464 1t10

# qhasm: int6464 1t11

# qhasm: int6464 2t12

# qhasm: int6464 2t13

# qhasm: int6464 2t14

# qhasm: int6464 2t15

# qhasm: int6464 2t16

# qhasm: int6464 2t17

# qhasm: int6464 2t18

# qhasm: int6464 2t19

# qhasm: int6464 2t20

# qhasm: int6464 2t21

# qhasm: int6464 2t22

# qhasm: 1r0 = *(int128 *)(1mysp + 0)
# asm 1: movdqa 0(<1mysp=int64#4),>1r0=int6464#1
# asm 2: movdqa 0(<1mysp=%rcx),>1r0=%xmm0
movdqa 0(%rcx),%xmm0

# qhasm: float6464 1r0 -= 0t12
# asm 1: subpd <0t12=int6464#2,<1r0=int6464#1
# asm 2: subpd <0t12=%xmm1,<1r0=%xmm0
subpd %xmm1,%xmm0

# qhasm: 2t15 = 0t15
# asm 1: movdqa <0t15=int6464#5,>2t15=int6464#13
# asm 2: movdqa <0t15=%xmm4,>2t15=%xmm12
movdqa %xmm4,%xmm12

# qhasm: float6464 2t15 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<2t15=int6464#13
# asm 2: mulpd SIX_SIX,<2t15=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 1r0 += 2t15
# asm 1: addpd <2t15=int6464#13,<1r0=int6464#1
# asm 2: addpd <2t15=%xmm12,<1r0=%xmm0
addpd %xmm12,%xmm0

# qhasm: 2t18 = 0t18
# asm 1: movdqa <0t18=int6464#8,>2t18=int6464#13
# asm 2: movdqa <0t18=%xmm7,>2t18=%xmm12
movdqa %xmm7,%xmm12

# qhasm: float6464 2t18 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<2t18=int6464#13
# asm 2: mulpd TWO_TWO,<2t18=%xmm12
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 1r0 -= 2t18
# asm 1: subpd <2t18=int6464#13,<1r0=int6464#1
# asm 2: subpd <2t18=%xmm12,<1r0=%xmm0
subpd %xmm12,%xmm0

# qhasm: 2t21 = 0t21
# asm 1: movdqa <0t21=int6464#11,>2t21=int6464#13
# asm 2: movdqa <0t21=%xmm10,>2t21=%xmm12
movdqa %xmm10,%xmm12

# qhasm: float6464 2t21 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<2t21=int6464#13
# asm 2: mulpd SIX_SIX,<2t21=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 1r0 -= 2t21
# asm 1: subpd <2t21=int6464#13,<1r0=int6464#1
# asm 2: subpd <2t21=%xmm12,<1r0=%xmm0
subpd %xmm12,%xmm0

# qhasm: *(int128 *)(1mysp + 0) = 1r0
# asm 1: movdqa <1r0=int6464#1,0(<1mysp=int64#4)
# asm 2: movdqa <1r0=%xmm0,0(<1mysp=%rcx)
movdqa %xmm0,0(%rcx)

# qhasm: 1r3 = *(int128 *)(1mysp + 48)
# asm 1: movdqa 48(<1mysp=int64#4),>1r3=int6464#1
# asm 2: movdqa 48(<1mysp=%rcx),>1r3=%xmm0
movdqa 48(%rcx),%xmm0

# qhasm: float6464 1r3 -= 0t12
# asm 1: subpd <0t12=int6464#2,<1r3=int6464#1
# asm 2: subpd <0t12=%xmm1,<1r3=%xmm0
subpd %xmm1,%xmm0

# qhasm: 2t15 = 0t15
# asm 1: movdqa <0t15=int6464#5,>2t15=int6464#13
# asm 2: movdqa <0t15=%xmm4,>2t15=%xmm12
movdqa %xmm4,%xmm12

# qhasm: float6464 2t15 *= FIVE_FIVE
# asm 1: mulpd FIVE_FIVE,<2t15=int6464#13
# asm 2: mulpd FIVE_FIVE,<2t15=%xmm12
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 1r3 += 2t15
# asm 1: addpd <2t15=int6464#13,<1r3=int6464#1
# asm 2: addpd <2t15=%xmm12,<1r3=%xmm0
addpd %xmm12,%xmm0

# qhasm: float6464 1r3 -= 0t18
# asm 1: subpd <0t18=int6464#8,<1r3=int6464#1
# asm 2: subpd <0t18=%xmm7,<1r3=%xmm0
subpd %xmm7,%xmm0

# qhasm: 2t21 = 0t21
# asm 1: movdqa <0t21=int6464#11,>2t21=int6464#13
# asm 2: movdqa <0t21=%xmm10,>2t21=%xmm12
movdqa %xmm10,%xmm12

# qhasm: float6464 2t21 *= EIGHT_EIGHT
# asm 1: mulpd EIGHT_EIGHT,<2t21=int6464#13
# asm 2: mulpd EIGHT_EIGHT,<2t21=%xmm12
mov EIGHT_EIGHT@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 1r3 -= 2t21
# asm 1: subpd <2t21=int6464#13,<1r3=int6464#1
# asm 2: subpd <2t21=%xmm12,<1r3=%xmm0
subpd %xmm12,%xmm0

# qhasm: *(int128 *)(1mysp + 48) = 1r3
# asm 1: movdqa <1r3=int6464#1,48(<1mysp=int64#4)
# asm 2: movdqa <1r3=%xmm0,48(<1mysp=%rcx)
movdqa %xmm0,48(%rcx)

# qhasm: 1r6 = *(int128 *)(1mysp + 96)
# asm 1: movdqa 96(<1mysp=int64#4),>1r6=int6464#1
# asm 2: movdqa 96(<1mysp=%rcx),>1r6=%xmm0
movdqa 96(%rcx),%xmm0

# qhasm: 2t12 = 0t12
# asm 1: movdqa <0t12=int6464#2,>2t12=int6464#13
# asm 2: movdqa <0t12=%xmm1,>2t12=%xmm12
movdqa %xmm1,%xmm12

# qhasm: float6464 2t12 *= FOUR_FOUR
# asm 1: mulpd FOUR_FOUR,<2t12=int6464#13
# asm 2: mulpd FOUR_FOUR,<2t12=%xmm12
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 1r6 -= 2t12
# asm 1: subpd <2t12=int6464#13,<1r6=int6464#1
# asm 2: subpd <2t12=%xmm12,<1r6=%xmm0
subpd %xmm12,%xmm0

# qhasm: 2t15 = 0t15
# asm 1: movdqa <0t15=int6464#5,>2t15=int6464#13
# asm 2: movdqa <0t15=%xmm4,>2t15=%xmm12
movdqa %xmm4,%xmm12

# qhasm: float6464 2t15 *= EIGHTEEN_EIGHTEEN
# asm 1: mulpd EIGHTEEN_EIGHTEEN,<2t15=int6464#13
# asm 2: mulpd EIGHTEEN_EIGHTEEN,<2t15=%xmm12
mov EIGHTEEN_EIGHTEEN@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 1r6 += 2t15
# asm 1: addpd <2t15=int6464#13,<1r6=int6464#1
# asm 2: addpd <2t15=%xmm12,<1r6=%xmm0
addpd %xmm12,%xmm0

# qhasm: 2t18 = 0t18
# asm 1: movdqa <0t18=int6464#8,>2t18=int6464#13
# asm 2: movdqa <0t18=%xmm7,>2t18=%xmm12
movdqa %xmm7,%xmm12

# qhasm: float6464 2t18 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<2t18=int6464#13
# asm 2: mulpd THREE_THREE,<2t18=%xmm12
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 1r6 -= 2t18
# asm 1: subpd <2t18=int6464#13,<1r6=int6464#1
# asm 2: subpd <2t18=%xmm12,<1r6=%xmm0
subpd %xmm12,%xmm0

# qhasm: 2t21 = 0t21
# asm 1: movdqa <0t21=int6464#11,>2t21=int6464#13
# asm 2: movdqa <0t21=%xmm10,>2t21=%xmm12
movdqa %xmm10,%xmm12

# qhasm: float6464 2t21 *= THIRTY_THIRTY
# asm 1: mulpd THIRTY_THIRTY,<2t21=int6464#13
# asm 2: mulpd THIRTY_THIRTY,<2t21=%xmm12
mov THIRTY_THIRTY@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 1r6 -= 2t21
# asm 1: subpd <2t21=int6464#13,<1r6=int6464#1
# asm 2: subpd <2t21=%xmm12,<1r6=%xmm0
subpd %xmm12,%xmm0

# qhasm: *(int128 *)(1mysp + 96) = 1r6
# asm 1: movdqa <1r6=int6464#1,96(<1mysp=int64#4)
# asm 2: movdqa <1r6=%xmm0,96(<1mysp=%rcx)
movdqa %xmm0,96(%rcx)

# qhasm: 1r9 = *(int128 *)(1mysp + 144)
# asm 1: movdqa 144(<1mysp=int64#4),>1r9=int6464#1
# asm 2: movdqa 144(<1mysp=%rcx),>1r9=%xmm0
movdqa 144(%rcx),%xmm0

# qhasm: float6464 1r9 -= 0t12
# asm 1: subpd <0t12=int6464#2,<1r9=int6464#1
# asm 2: subpd <0t12=%xmm1,<1r9=%xmm0
subpd %xmm1,%xmm0

# qhasm: 2t15 = 0t15
# asm 1: movdqa <0t15=int6464#5,>2t15=int6464#2
# asm 2: movdqa <0t15=%xmm4,>2t15=%xmm1
movdqa %xmm4,%xmm1

# qhasm: float6464 2t15 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<2t15=int6464#2
# asm 2: mulpd TWO_TWO,<2t15=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r9 += 2t15
# asm 1: addpd <2t15=int6464#2,<1r9=int6464#1
# asm 2: addpd <2t15=%xmm1,<1r9=%xmm0
addpd %xmm1,%xmm0

# qhasm: float6464 1r9 += 0t18
# asm 1: addpd <0t18=int6464#8,<1r9=int6464#1
# asm 2: addpd <0t18=%xmm7,<1r9=%xmm0
addpd %xmm7,%xmm0

# qhasm: 2t21 = 0t21
# asm 1: movdqa <0t21=int6464#11,>2t21=int6464#2
# asm 2: movdqa <0t21=%xmm10,>2t21=%xmm1
movdqa %xmm10,%xmm1

# qhasm: float6464 2t21 *= NINE_NINE
# asm 1: mulpd NINE_NINE,<2t21=int6464#2
# asm 2: mulpd NINE_NINE,<2t21=%xmm1
mov NINE_NINE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r9 -= 2t21
# asm 1: subpd <2t21=int6464#2,<1r9=int6464#1
# asm 2: subpd <2t21=%xmm1,<1r9=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(1mysp + 144) = 1r9
# asm 1: movdqa <1r9=int6464#1,144(<1mysp=int64#4)
# asm 2: movdqa <1r9=%xmm0,144(<1mysp=%rcx)
movdqa %xmm0,144(%rcx)

# qhasm: 1r1 = *(int128 *)(1mysp + 16)
# asm 1: movdqa 16(<1mysp=int64#4),>1r1=int6464#1
# asm 2: movdqa 16(<1mysp=%rcx),>1r1=%xmm0
movdqa 16(%rcx),%xmm0

# qhasm: float6464 1r1 -= 0t13
# asm 1: subpd <0t13=int6464#3,<1r1=int6464#1
# asm 2: subpd <0t13=%xmm2,<1r1=%xmm0
subpd %xmm2,%xmm0

# qhasm: float6464 1r1 += 0t16
# asm 1: addpd <0t16=int6464#6,<1r1=int6464#1
# asm 2: addpd <0t16=%xmm5,<1r1=%xmm0
addpd %xmm5,%xmm0

# qhasm: 2t19 = 0t19
# asm 1: movdqa <0t19=int6464#9,>2t19=int6464#2
# asm 2: movdqa <0t19=%xmm8,>2t19=%xmm1
movdqa %xmm8,%xmm1

# qhasm: float6464 2t19 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<2t19=int6464#2
# asm 2: mulpd TWO_TWO,<2t19=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r1 -= 2t19
# asm 1: subpd <2t19=int6464#2,<1r1=int6464#1
# asm 2: subpd <2t19=%xmm1,<1r1=%xmm0
subpd %xmm1,%xmm0

# qhasm: float6464 1r1 -= 0t22
# asm 1: subpd <0t22=int6464#12,<1r1=int6464#1
# asm 2: subpd <0t22=%xmm11,<1r1=%xmm0
subpd %xmm11,%xmm0

# qhasm: *(int128 *)(1mysp + 16) = 1r1
# asm 1: movdqa <1r1=int6464#1,16(<1mysp=int64#4)
# asm 2: movdqa <1r1=%xmm0,16(<1mysp=%rcx)
movdqa %xmm0,16(%rcx)

# qhasm: 1r4 = *(int128 *)(1mysp + 64)
# asm 1: movdqa 64(<1mysp=int64#4),>1r4=int6464#1
# asm 2: movdqa 64(<1mysp=%rcx),>1r4=%xmm0
movdqa 64(%rcx),%xmm0

# qhasm: 2t13 = 0t13
# asm 1: movdqa <0t13=int6464#3,>2t13=int6464#2
# asm 2: movdqa <0t13=%xmm2,>2t13=%xmm1
movdqa %xmm2,%xmm1

# qhasm: float6464 2t13 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<2t13=int6464#2
# asm 2: mulpd SIX_SIX,<2t13=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r4 -= 2t13
# asm 1: subpd <2t13=int6464#2,<1r4=int6464#1
# asm 2: subpd <2t13=%xmm1,<1r4=%xmm0
subpd %xmm1,%xmm0

# qhasm: 2t16 = 0t16
# asm 1: movdqa <0t16=int6464#6,>2t16=int6464#2
# asm 2: movdqa <0t16=%xmm5,>2t16=%xmm1
movdqa %xmm5,%xmm1

# qhasm: float6464 2t16 *= FIVE_FIVE
# asm 1: mulpd FIVE_FIVE,<2t16=int6464#2
# asm 2: mulpd FIVE_FIVE,<2t16=%xmm1
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r4 += 2t16
# asm 1: addpd <2t16=int6464#2,<1r4=int6464#1
# asm 2: addpd <2t16=%xmm1,<1r4=%xmm0
addpd %xmm1,%xmm0

# qhasm: 2t19 = 0t19
# asm 1: movdqa <0t19=int6464#9,>2t19=int6464#2
# asm 2: movdqa <0t19=%xmm8,>2t19=%xmm1
movdqa %xmm8,%xmm1

# qhasm: float6464 2t19 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<2t19=int6464#2
# asm 2: mulpd SIX_SIX,<2t19=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r4 -= 2t19
# asm 1: subpd <2t19=int6464#2,<1r4=int6464#1
# asm 2: subpd <2t19=%xmm1,<1r4=%xmm0
subpd %xmm1,%xmm0

# qhasm: 2t22 = 0t22
# asm 1: movdqa <0t22=int6464#12,>2t22=int6464#2
# asm 2: movdqa <0t22=%xmm11,>2t22=%xmm1
movdqa %xmm11,%xmm1

# qhasm: float6464 2t22 *= EIGHT_EIGHT
# asm 1: mulpd EIGHT_EIGHT,<2t22=int6464#2
# asm 2: mulpd EIGHT_EIGHT,<2t22=%xmm1
mov EIGHT_EIGHT@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r4 -= 2t22
# asm 1: subpd <2t22=int6464#2,<1r4=int6464#1
# asm 2: subpd <2t22=%xmm1,<1r4=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(1mysp + 64) = 1r4
# asm 1: movdqa <1r4=int6464#1,64(<1mysp=int64#4)
# asm 2: movdqa <1r4=%xmm0,64(<1mysp=%rcx)
movdqa %xmm0,64(%rcx)

# qhasm: 1r7 = *(int128 *)(1mysp + 112)
# asm 1: movdqa 112(<1mysp=int64#4),>1r7=int6464#1
# asm 2: movdqa 112(<1mysp=%rcx),>1r7=%xmm0
movdqa 112(%rcx),%xmm0

# qhasm: 2t13 = 0t13
# asm 1: movdqa <0t13=int6464#3,>2t13=int6464#2
# asm 2: movdqa <0t13=%xmm2,>2t13=%xmm1
movdqa %xmm2,%xmm1

# qhasm: float6464 2t13 *= FOUR_FOUR
# asm 1: mulpd FOUR_FOUR,<2t13=int6464#2
# asm 2: mulpd FOUR_FOUR,<2t13=%xmm1
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r7 -= 2t13
# asm 1: subpd <2t13=int6464#2,<1r7=int6464#1
# asm 2: subpd <2t13=%xmm1,<1r7=%xmm0
subpd %xmm1,%xmm0

# qhasm: 2t16 = 0t16
# asm 1: movdqa <0t16=int6464#6,>2t16=int6464#2
# asm 2: movdqa <0t16=%xmm5,>2t16=%xmm1
movdqa %xmm5,%xmm1

# qhasm: float6464 2t16 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<2t16=int6464#2
# asm 2: mulpd THREE_THREE,<2t16=%xmm1
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r7 += 2t16
# asm 1: addpd <2t16=int6464#2,<1r7=int6464#1
# asm 2: addpd <2t16=%xmm1,<1r7=%xmm0
addpd %xmm1,%xmm0

# qhasm: 2t19 = 0t19
# asm 1: movdqa <0t19=int6464#9,>2t19=int6464#2
# asm 2: movdqa <0t19=%xmm8,>2t19=%xmm1
movdqa %xmm8,%xmm1

# qhasm: float6464 2t19 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<2t19=int6464#2
# asm 2: mulpd THREE_THREE,<2t19=%xmm1
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r7 -= 2t19
# asm 1: subpd <2t19=int6464#2,<1r7=int6464#1
# asm 2: subpd <2t19=%xmm1,<1r7=%xmm0
subpd %xmm1,%xmm0

# qhasm: 2t22 = 0t22
# asm 1: movdqa <0t22=int6464#12,>2t22=int6464#2
# asm 2: movdqa <0t22=%xmm11,>2t22=%xmm1
movdqa %xmm11,%xmm1

# qhasm: float6464 2t22 *= FIVE_FIVE
# asm 1: mulpd FIVE_FIVE,<2t22=int6464#2
# asm 2: mulpd FIVE_FIVE,<2t22=%xmm1
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r7 -= 2t22
# asm 1: subpd <2t22=int6464#2,<1r7=int6464#1
# asm 2: subpd <2t22=%xmm1,<1r7=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(1mysp + 112) = 1r7
# asm 1: movdqa <1r7=int6464#1,112(<1mysp=int64#4)
# asm 2: movdqa <1r7=%xmm0,112(<1mysp=%rcx)
movdqa %xmm0,112(%rcx)

# qhasm: 1r10 = *(int128 *)(1mysp + 160)
# asm 1: movdqa 160(<1mysp=int64#4),>1r10=int6464#1
# asm 2: movdqa 160(<1mysp=%rcx),>1r10=%xmm0
movdqa 160(%rcx),%xmm0

# qhasm: 2t13 = 0t13
# asm 1: movdqa <0t13=int6464#3,>2t13=int6464#2
# asm 2: movdqa <0t13=%xmm2,>2t13=%xmm1
movdqa %xmm2,%xmm1

# qhasm: float6464 2t13 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<2t13=int6464#2
# asm 2: mulpd SIX_SIX,<2t13=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r10 -= 2t13
# asm 1: subpd <2t13=int6464#2,<1r10=int6464#1
# asm 2: subpd <2t13=%xmm1,<1r10=%xmm0
subpd %xmm1,%xmm0

# qhasm: 2t16 = 0t16
# asm 1: movdqa <0t16=int6464#6,>2t16=int6464#2
# asm 2: movdqa <0t16=%xmm5,>2t16=%xmm1
movdqa %xmm5,%xmm1

# qhasm: float6464 2t16 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<2t16=int6464#2
# asm 2: mulpd TWO_TWO,<2t16=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r10 += 2t16
# asm 1: addpd <2t16=int6464#2,<1r10=int6464#1
# asm 2: addpd <2t16=%xmm1,<1r10=%xmm0
addpd %xmm1,%xmm0

# qhasm: 2t19 = 0t19
# asm 1: movdqa <0t19=int6464#9,>2t19=int6464#2
# asm 2: movdqa <0t19=%xmm8,>2t19=%xmm1
movdqa %xmm8,%xmm1

# qhasm: float6464 2t19 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<2t19=int6464#2
# asm 2: mulpd SIX_SIX,<2t19=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r10 += 2t19
# asm 1: addpd <2t19=int6464#2,<1r10=int6464#1
# asm 2: addpd <2t19=%xmm1,<1r10=%xmm0
addpd %xmm1,%xmm0

# qhasm: 2t22 = 0t22
# asm 1: movdqa <0t22=int6464#12,>2t22=int6464#2
# asm 2: movdqa <0t22=%xmm11,>2t22=%xmm1
movdqa %xmm11,%xmm1

# qhasm: float6464 2t22 *= NINE_NINE
# asm 1: mulpd NINE_NINE,<2t22=int6464#2
# asm 2: mulpd NINE_NINE,<2t22=%xmm1
mov NINE_NINE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r10 -= 2t22
# asm 1: subpd <2t22=int6464#2,<1r10=int6464#1
# asm 2: subpd <2t22=%xmm1,<1r10=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(1mysp + 160) = 1r10
# asm 1: movdqa <1r10=int6464#1,160(<1mysp=int64#4)
# asm 2: movdqa <1r10=%xmm0,160(<1mysp=%rcx)
movdqa %xmm0,160(%rcx)

# qhasm: 1r2 = *(int128 *)(1mysp + 32)
# asm 1: movdqa 32(<1mysp=int64#4),>1r2=int6464#1
# asm 2: movdqa 32(<1mysp=%rcx),>1r2=%xmm0
movdqa 32(%rcx),%xmm0

# qhasm: float6464 1r2 -= 0t14
# asm 1: subpd <0t14=int6464#4,<1r2=int6464#1
# asm 2: subpd <0t14=%xmm3,<1r2=%xmm0
subpd %xmm3,%xmm0

# qhasm: float6464 1r2 += 0t17
# asm 1: addpd <0t17=int6464#7,<1r2=int6464#1
# asm 2: addpd <0t17=%xmm6,<1r2=%xmm0
addpd %xmm6,%xmm0

# qhasm: 2t20 = 0t20
# asm 1: movdqa <0t20=int6464#10,>2t20=int6464#2
# asm 2: movdqa <0t20=%xmm9,>2t20=%xmm1
movdqa %xmm9,%xmm1

# qhasm: float6464 2t20 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<2t20=int6464#2
# asm 2: mulpd TWO_TWO,<2t20=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r2 -= 2t20
# asm 1: subpd <2t20=int6464#2,<1r2=int6464#1
# asm 2: subpd <2t20=%xmm1,<1r2=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(1mysp + 32) = 1r2
# asm 1: movdqa <1r2=int6464#1,32(<1mysp=int64#4)
# asm 2: movdqa <1r2=%xmm0,32(<1mysp=%rcx)
movdqa %xmm0,32(%rcx)

# qhasm: 1r5 = *(int128 *)(1mysp + 80)
# asm 1: movdqa 80(<1mysp=int64#4),>1r5=int6464#1
# asm 2: movdqa 80(<1mysp=%rcx),>1r5=%xmm0
movdqa 80(%rcx),%xmm0

# qhasm: 2t14 = 0t14
# asm 1: movdqa <0t14=int6464#4,>2t14=int6464#2
# asm 2: movdqa <0t14=%xmm3,>2t14=%xmm1
movdqa %xmm3,%xmm1

# qhasm: float6464 2t14 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<2t14=int6464#2
# asm 2: mulpd SIX_SIX,<2t14=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r5 -= 2t14
# asm 1: subpd <2t14=int6464#2,<1r5=int6464#1
# asm 2: subpd <2t14=%xmm1,<1r5=%xmm0
subpd %xmm1,%xmm0

# qhasm: 2t17 = 0t17
# asm 1: movdqa <0t17=int6464#7,>2t17=int6464#2
# asm 2: movdqa <0t17=%xmm6,>2t17=%xmm1
movdqa %xmm6,%xmm1

# qhasm: float6464 2t17 *= FIVE_FIVE
# asm 1: mulpd FIVE_FIVE,<2t17=int6464#2
# asm 2: mulpd FIVE_FIVE,<2t17=%xmm1
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r5 += 2t17
# asm 1: addpd <2t17=int6464#2,<1r5=int6464#1
# asm 2: addpd <2t17=%xmm1,<1r5=%xmm0
addpd %xmm1,%xmm0

# qhasm: 2t20 = 0t20
# asm 1: movdqa <0t20=int6464#10,>2t20=int6464#2
# asm 2: movdqa <0t20=%xmm9,>2t20=%xmm1
movdqa %xmm9,%xmm1

# qhasm: float6464 2t20 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<2t20=int6464#2
# asm 2: mulpd SIX_SIX,<2t20=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r5 -= 2t20
# asm 1: subpd <2t20=int6464#2,<1r5=int6464#1
# asm 2: subpd <2t20=%xmm1,<1r5=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(1mysp + 80) = 1r5
# asm 1: movdqa <1r5=int6464#1,80(<1mysp=int64#4)
# asm 2: movdqa <1r5=%xmm0,80(<1mysp=%rcx)
movdqa %xmm0,80(%rcx)

# qhasm: 1r8 = *(int128 *)(1mysp + 128)
# asm 1: movdqa 128(<1mysp=int64#4),>1r8=int6464#1
# asm 2: movdqa 128(<1mysp=%rcx),>1r8=%xmm0
movdqa 128(%rcx),%xmm0

# qhasm: 2t14 = 0t14
# asm 1: movdqa <0t14=int6464#4,>2t14=int6464#2
# asm 2: movdqa <0t14=%xmm3,>2t14=%xmm1
movdqa %xmm3,%xmm1

# qhasm: float6464 2t14 *= FOUR_FOUR
# asm 1: mulpd FOUR_FOUR,<2t14=int6464#2
# asm 2: mulpd FOUR_FOUR,<2t14=%xmm1
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r8 -= 2t14
# asm 1: subpd <2t14=int6464#2,<1r8=int6464#1
# asm 2: subpd <2t14=%xmm1,<1r8=%xmm0
subpd %xmm1,%xmm0

# qhasm: 2t17 = 0t17
# asm 1: movdqa <0t17=int6464#7,>2t17=int6464#2
# asm 2: movdqa <0t17=%xmm6,>2t17=%xmm1
movdqa %xmm6,%xmm1

# qhasm: float6464 2t17 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<2t17=int6464#2
# asm 2: mulpd THREE_THREE,<2t17=%xmm1
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r8 += 2t17
# asm 1: addpd <2t17=int6464#2,<1r8=int6464#1
# asm 2: addpd <2t17=%xmm1,<1r8=%xmm0
addpd %xmm1,%xmm0

# qhasm: 2t20 = 0t20
# asm 1: movdqa <0t20=int6464#10,>2t20=int6464#2
# asm 2: movdqa <0t20=%xmm9,>2t20=%xmm1
movdqa %xmm9,%xmm1

# qhasm: float6464 2t20 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<2t20=int6464#2
# asm 2: mulpd THREE_THREE,<2t20=%xmm1
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r8 -= 2t20
# asm 1: subpd <2t20=int6464#2,<1r8=int6464#1
# asm 2: subpd <2t20=%xmm1,<1r8=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(1mysp + 128) = 1r8
# asm 1: movdqa <1r8=int6464#1,128(<1mysp=int64#4)
# asm 2: movdqa <1r8=%xmm0,128(<1mysp=%rcx)
movdqa %xmm0,128(%rcx)

# qhasm: 1r11 = *(int128 *)(1mysp + 176)
# asm 1: movdqa 176(<1mysp=int64#4),>1r11=int6464#1
# asm 2: movdqa 176(<1mysp=%rcx),>1r11=%xmm0
movdqa 176(%rcx),%xmm0

# qhasm: 2t14 = 0t14
# asm 1: movdqa <0t14=int6464#4,>2t14=int6464#2
# asm 2: movdqa <0t14=%xmm3,>2t14=%xmm1
movdqa %xmm3,%xmm1

# qhasm: float6464 2t14 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<2t14=int6464#2
# asm 2: mulpd SIX_SIX,<2t14=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r11 -= 2t14
# asm 1: subpd <2t14=int6464#2,<1r11=int6464#1
# asm 2: subpd <2t14=%xmm1,<1r11=%xmm0
subpd %xmm1,%xmm0

# qhasm: 2t17 = 0t17
# asm 1: movdqa <0t17=int6464#7,>2t17=int6464#2
# asm 2: movdqa <0t17=%xmm6,>2t17=%xmm1
movdqa %xmm6,%xmm1

# qhasm: float6464 2t17 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<2t17=int6464#2
# asm 2: mulpd TWO_TWO,<2t17=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r11 += 2t17
# asm 1: addpd <2t17=int6464#2,<1r11=int6464#1
# asm 2: addpd <2t17=%xmm1,<1r11=%xmm0
addpd %xmm1,%xmm0

# qhasm: 2t20 = 0t20
# asm 1: movdqa <0t20=int6464#10,>2t20=int6464#2
# asm 2: movdqa <0t20=%xmm9,>2t20=%xmm1
movdqa %xmm9,%xmm1

# qhasm: float6464 2t20 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<2t20=int6464#2
# asm 2: mulpd SIX_SIX,<2t20=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1r11 += 2t20
# asm 1: addpd <2t20=int6464#2,<1r11=int6464#1
# asm 2: addpd <2t20=%xmm1,<1r11=%xmm0
addpd %xmm1,%xmm0

# qhasm: *(int128 *)(1mysp + 176) = 1r11
# asm 1: movdqa <1r11=int6464#1,176(<1mysp=int64#4)
# asm 2: movdqa <1r11=%xmm0,176(<1mysp=%rcx)
movdqa %xmm0,176(%rcx)

# qhasm: int6464 0round

# qhasm: int6464 0carry

# qhasm: int6464 2t6

# qhasm: r0 = *(int128 *)(1mysp + 0)
# asm 1: movdqa 0(<1mysp=int64#4),>r0=int6464#1
# asm 2: movdqa 0(<1mysp=%rcx),>r0=%xmm0
movdqa 0(%rcx),%xmm0

# qhasm: r1 = *(int128 *)(1mysp + 16)
# asm 1: movdqa 16(<1mysp=int64#4),>r1=int6464#2
# asm 2: movdqa 16(<1mysp=%rcx),>r1=%xmm1
movdqa 16(%rcx),%xmm1

# qhasm: r2 = *(int128 *)(1mysp + 32)
# asm 1: movdqa 32(<1mysp=int64#4),>r2=int6464#3
# asm 2: movdqa 32(<1mysp=%rcx),>r2=%xmm2
movdqa 32(%rcx),%xmm2

# qhasm: r3 = *(int128 *)(1mysp + 48)
# asm 1: movdqa 48(<1mysp=int64#4),>r3=int6464#4
# asm 2: movdqa 48(<1mysp=%rcx),>r3=%xmm3
movdqa 48(%rcx),%xmm3

# qhasm: r4 = *(int128 *)(1mysp + 64)
# asm 1: movdqa 64(<1mysp=int64#4),>r4=int6464#5
# asm 2: movdqa 64(<1mysp=%rcx),>r4=%xmm4
movdqa 64(%rcx),%xmm4

# qhasm: r5 = *(int128 *)(1mysp + 80)
# asm 1: movdqa 80(<1mysp=int64#4),>r5=int6464#6
# asm 2: movdqa 80(<1mysp=%rcx),>r5=%xmm5
movdqa 80(%rcx),%xmm5

# qhasm: r6 = *(int128 *)(1mysp + 96)
# asm 1: movdqa 96(<1mysp=int64#4),>r6=int6464#7
# asm 2: movdqa 96(<1mysp=%rcx),>r6=%xmm6
movdqa 96(%rcx),%xmm6

# qhasm: r7 = *(int128 *)(1mysp + 112)
# asm 1: movdqa 112(<1mysp=int64#4),>r7=int6464#8
# asm 2: movdqa 112(<1mysp=%rcx),>r7=%xmm7
movdqa 112(%rcx),%xmm7

# qhasm: r8 = *(int128 *)(1mysp + 128)
# asm 1: movdqa 128(<1mysp=int64#4),>r8=int6464#9
# asm 2: movdqa 128(<1mysp=%rcx),>r8=%xmm8
movdqa 128(%rcx),%xmm8

# qhasm: r9 = *(int128 *)(1mysp + 144)
# asm 1: movdqa 144(<1mysp=int64#4),>r9=int6464#10
# asm 2: movdqa 144(<1mysp=%rcx),>r9=%xmm9
movdqa 144(%rcx),%xmm9

# qhasm: r10 = *(int128 *)(1mysp + 160)
# asm 1: movdqa 160(<1mysp=int64#4),>r10=int6464#11
# asm 2: movdqa 160(<1mysp=%rcx),>r10=%xmm10
movdqa 160(%rcx),%xmm10

# qhasm: r11 = *(int128 *)(1mysp + 176)
# asm 1: movdqa 176(<1mysp=int64#4),>r11=int6464#12
# asm 2: movdqa 176(<1mysp=%rcx),>r11=%xmm11
movdqa 176(%rcx),%xmm11

# qhasm: 0round = ROUND_ROUND
# asm 1: movdqa ROUND_ROUND,<0round=int6464#13
# asm 2: movdqa ROUND_ROUND,<0round=%xmm12
mov ROUND_ROUND@GOTPCREL(%rip), %rbp
movdqa (%rbp),%xmm12

# qhasm: 0carry = r1
# asm 1: movdqa <r1=int6464#2,>0carry=int6464#14
# asm 2: movdqa <r1=%xmm1,>0carry=%xmm13
movdqa %xmm1,%xmm13

# qhasm: float6464 0carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<0carry=int6464#14
# asm 2: mulpd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r2 += 0carry
# asm 1: addpd <0carry=int6464#14,<r2=int6464#3
# asm 2: addpd <0carry=%xmm13,<r2=%xmm2
addpd %xmm13,%xmm2

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r1 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r1=int6464#2
# asm 2: subpd <0carry=%xmm13,<r1=%xmm1
subpd %xmm13,%xmm1

# qhasm: 0carry = r4
# asm 1: movdqa <r4=int6464#5,>0carry=int6464#14
# asm 2: movdqa <r4=%xmm4,>0carry=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<0carry=int6464#14
# asm 2: mulpd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r5 += 0carry
# asm 1: addpd <0carry=int6464#14,<r5=int6464#6
# asm 2: addpd <0carry=%xmm13,<r5=%xmm5
addpd %xmm13,%xmm5

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r4 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r4=int6464#5
# asm 2: subpd <0carry=%xmm13,<r4=%xmm4
subpd %xmm13,%xmm4

# qhasm: 0carry = r7
# asm 1: movdqa <r7=int6464#8,>0carry=int6464#14
# asm 2: movdqa <r7=%xmm7,>0carry=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 0carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<0carry=int6464#14
# asm 2: mulpd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r8 += 0carry
# asm 1: addpd <0carry=int6464#14,<r8=int6464#9
# asm 2: addpd <0carry=%xmm13,<r8=%xmm8
addpd %xmm13,%xmm8

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r7 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r7=int6464#8
# asm 2: subpd <0carry=%xmm13,<r7=%xmm7
subpd %xmm13,%xmm7

# qhasm: 0carry = r10
# asm 1: movdqa <r10=int6464#11,>0carry=int6464#14
# asm 2: movdqa <r10=%xmm10,>0carry=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 0carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<0carry=int6464#14
# asm 2: mulpd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r11 += 0carry
# asm 1: addpd <0carry=int6464#14,<r11=int6464#12
# asm 2: addpd <0carry=%xmm13,<r11=%xmm11
addpd %xmm13,%xmm11

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r10 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r10=int6464#11
# asm 2: subpd <0carry=%xmm13,<r10=%xmm10
subpd %xmm13,%xmm10

# qhasm: 0carry = r2
# asm 1: movdqa <r2=int6464#3,>0carry=int6464#14
# asm 2: movdqa <r2=%xmm2,>0carry=%xmm13
movdqa %xmm2,%xmm13

# qhasm: float6464 0carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<0carry=int6464#14
# asm 2: mulpd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r3 += 0carry
# asm 1: addpd <0carry=int6464#14,<r3=int6464#4
# asm 2: addpd <0carry=%xmm13,<r3=%xmm3
addpd %xmm13,%xmm3

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r2 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r2=int6464#3
# asm 2: subpd <0carry=%xmm13,<r2=%xmm2
subpd %xmm13,%xmm2

# qhasm: 0carry = r5
# asm 1: movdqa <r5=int6464#6,>0carry=int6464#14
# asm 2: movdqa <r5=%xmm5,>0carry=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 0carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<0carry=int6464#14
# asm 2: mulpd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r6 += 0carry
# asm 1: addpd <0carry=int6464#14,<r6=int6464#7
# asm 2: addpd <0carry=%xmm13,<r6=%xmm6
addpd %xmm13,%xmm6

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r5 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r5=int6464#6
# asm 2: subpd <0carry=%xmm13,<r5=%xmm5
subpd %xmm13,%xmm5

# qhasm: 0carry = r8
# asm 1: movdqa <r8=int6464#9,>0carry=int6464#14
# asm 2: movdqa <r8=%xmm8,>0carry=%xmm13
movdqa %xmm8,%xmm13

# qhasm: float6464 0carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<0carry=int6464#14
# asm 2: mulpd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r9 += 0carry
# asm 1: addpd <0carry=int6464#14,<r9=int6464#10
# asm 2: addpd <0carry=%xmm13,<r9=%xmm9
addpd %xmm13,%xmm9

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r8 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r8=int6464#9
# asm 2: subpd <0carry=%xmm13,<r8=%xmm8
subpd %xmm13,%xmm8

# qhasm: 0carry = r11
# asm 1: movdqa <r11=int6464#12,>0carry=int6464#14
# asm 2: movdqa <r11=%xmm11,>0carry=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 0carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<0carry=int6464#14
# asm 2: mulpd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r0 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r0=int6464#1
# asm 2: subpd <0carry=%xmm13,<r0=%xmm0
subpd %xmm13,%xmm0

# qhasm: float6464 r3 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r3=int6464#4
# asm 2: subpd <0carry=%xmm13,<r3=%xmm3
subpd %xmm13,%xmm3

# qhasm: 2t6 = 0carry
# asm 1: movdqa <0carry=int6464#14,>2t6=int6464#15
# asm 2: movdqa <0carry=%xmm13,>2t6=%xmm14
movdqa %xmm13,%xmm14

# qhasm: float6464 2t6 *= FOUR_FOUR
# asm 1: mulpd FOUR_FOUR,<2t6=int6464#15
# asm 2: mulpd FOUR_FOUR,<2t6=%xmm14
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: float6464 r6 -= 2t6
# asm 1: subpd <2t6=int6464#15,<r6=int6464#7
# asm 2: subpd <2t6=%xmm14,<r6=%xmm6
subpd %xmm14,%xmm6

# qhasm: float6464 r9 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r9=int6464#10
# asm 2: subpd <0carry=%xmm13,<r9=%xmm9
subpd %xmm13,%xmm9

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r11 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r11=int6464#12
# asm 2: subpd <0carry=%xmm13,<r11=%xmm11
subpd %xmm13,%xmm11

# qhasm: 0carry = r0
# asm 1: movdqa <r0=int6464#1,>0carry=int6464#14
# asm 2: movdqa <r0=%xmm0,>0carry=%xmm13
movdqa %xmm0,%xmm13

# qhasm: float6464 0carry *= V6INV_V6INV
# asm 1: mulpd V6INV_V6INV,<0carry=int6464#14
# asm 2: mulpd V6INV_V6INV,<0carry=%xmm13
mov V6INV_V6INV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r1 += 0carry
# asm 1: addpd <0carry=int6464#14,<r1=int6464#2
# asm 2: addpd <0carry=%xmm13,<r1=%xmm1
addpd %xmm13,%xmm1

# qhasm: float6464 0carry *= V6_V6
# asm 1: mulpd V6_V6,<0carry=int6464#14
# asm 2: mulpd V6_V6,<0carry=%xmm13
mov V6_V6@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r0 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r0=int6464#1
# asm 2: subpd <0carry=%xmm13,<r0=%xmm0
subpd %xmm13,%xmm0

# qhasm: 0carry = r3
# asm 1: movdqa <r3=int6464#4,>0carry=int6464#14
# asm 2: movdqa <r3=%xmm3,>0carry=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 0carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<0carry=int6464#14
# asm 2: mulpd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r4 += 0carry
# asm 1: addpd <0carry=int6464#14,<r4=int6464#5
# asm 2: addpd <0carry=%xmm13,<r4=%xmm4
addpd %xmm13,%xmm4

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r3 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r3=int6464#4
# asm 2: subpd <0carry=%xmm13,<r3=%xmm3
subpd %xmm13,%xmm3

# qhasm: 0carry = r6
# asm 1: movdqa <r6=int6464#7,>0carry=int6464#14
# asm 2: movdqa <r6=%xmm6,>0carry=%xmm13
movdqa %xmm6,%xmm13

# qhasm: float6464 0carry *= V6INV_V6INV
# asm 1: mulpd V6INV_V6INV,<0carry=int6464#14
# asm 2: mulpd V6INV_V6INV,<0carry=%xmm13
mov V6INV_V6INV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r7 += 0carry
# asm 1: addpd <0carry=int6464#14,<r7=int6464#8
# asm 2: addpd <0carry=%xmm13,<r7=%xmm7
addpd %xmm13,%xmm7

# qhasm: float6464 0carry *= V6_V6
# asm 1: mulpd V6_V6,<0carry=int6464#14
# asm 2: mulpd V6_V6,<0carry=%xmm13
mov V6_V6@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r6 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r6=int6464#7
# asm 2: subpd <0carry=%xmm13,<r6=%xmm6
subpd %xmm13,%xmm6

# qhasm: 0carry = r9
# asm 1: movdqa <r9=int6464#10,>0carry=int6464#14
# asm 2: movdqa <r9=%xmm9,>0carry=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 0carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<0carry=int6464#14
# asm 2: mulpd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r10 += 0carry
# asm 1: addpd <0carry=int6464#14,<r10=int6464#11
# asm 2: addpd <0carry=%xmm13,<r10=%xmm10
addpd %xmm13,%xmm10

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r9 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r9=int6464#10
# asm 2: subpd <0carry=%xmm13,<r9=%xmm9
subpd %xmm13,%xmm9

# qhasm: 0carry = r1
# asm 1: movdqa <r1=int6464#2,>0carry=int6464#14
# asm 2: movdqa <r1=%xmm1,>0carry=%xmm13
movdqa %xmm1,%xmm13

# qhasm: float6464 0carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<0carry=int6464#14
# asm 2: mulpd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r2 += 0carry
# asm 1: addpd <0carry=int6464#14,<r2=int6464#3
# asm 2: addpd <0carry=%xmm13,<r2=%xmm2
addpd %xmm13,%xmm2

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r1 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r1=int6464#2
# asm 2: subpd <0carry=%xmm13,<r1=%xmm1
subpd %xmm13,%xmm1

# qhasm: 0carry = r4
# asm 1: movdqa <r4=int6464#5,>0carry=int6464#14
# asm 2: movdqa <r4=%xmm4,>0carry=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 0carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<0carry=int6464#14
# asm 2: mulpd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r5 += 0carry
# asm 1: addpd <0carry=int6464#14,<r5=int6464#6
# asm 2: addpd <0carry=%xmm13,<r5=%xmm5
addpd %xmm13,%xmm5

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r4 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r4=int6464#5
# asm 2: subpd <0carry=%xmm13,<r4=%xmm4
subpd %xmm13,%xmm4

# qhasm: 0carry = r7
# asm 1: movdqa <r7=int6464#8,>0carry=int6464#14
# asm 2: movdqa <r7=%xmm7,>0carry=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 0carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<0carry=int6464#14
# asm 2: mulpd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r8 += 0carry
# asm 1: addpd <0carry=int6464#14,<r8=int6464#9
# asm 2: addpd <0carry=%xmm13,<r8=%xmm8
addpd %xmm13,%xmm8

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r7 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r7=int6464#8
# asm 2: subpd <0carry=%xmm13,<r7=%xmm7
subpd %xmm13,%xmm7

# qhasm: 0carry = r10
# asm 1: movdqa <r10=int6464#11,>0carry=int6464#14
# asm 2: movdqa <r10=%xmm10,>0carry=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 0carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<0carry=int6464#14
# asm 2: mulpd VINV_VINV,<0carry=%xmm13
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0carry += 0round
# asm 1: addpd <0round=int6464#13,<0carry=int6464#14
# asm 2: addpd <0round=%xmm12,<0carry=%xmm13
addpd %xmm12,%xmm13

# qhasm: float6464 0carry -= 0round
# asm 1: subpd <0round=int6464#13,<0carry=int6464#14
# asm 2: subpd <0round=%xmm12,<0carry=%xmm13
subpd %xmm12,%xmm13

# qhasm: float6464 r11 += 0carry
# asm 1: addpd <0carry=int6464#14,<r11=int6464#12
# asm 2: addpd <0carry=%xmm13,<r11=%xmm11
addpd %xmm13,%xmm11

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r10 -= 0carry
# asm 1: subpd <0carry=int6464#14,<r10=int6464#11
# asm 2: subpd <0carry=%xmm13,<r10=%xmm10
subpd %xmm13,%xmm10

# qhasm: *(int128 *)(rop +   0) =  r0
# asm 1: movdqa <r0=int6464#1,0(<rop=int64#1)
# asm 2: movdqa <r0=%xmm0,0(<rop=%rdi)
movdqa %xmm0,0(%rdi)

# qhasm: *(int128 *)(rop +  16) =  r1
# asm 1: movdqa <r1=int6464#2,16(<rop=int64#1)
# asm 2: movdqa <r1=%xmm1,16(<rop=%rdi)
movdqa %xmm1,16(%rdi)

# qhasm: *(int128 *)(rop +  32) =  r2
# asm 1: movdqa <r2=int6464#3,32(<rop=int64#1)
# asm 2: movdqa <r2=%xmm2,32(<rop=%rdi)
movdqa %xmm2,32(%rdi)

# qhasm: *(int128 *)(rop +  48) =  r3
# asm 1: movdqa <r3=int6464#4,48(<rop=int64#1)
# asm 2: movdqa <r3=%xmm3,48(<rop=%rdi)
movdqa %xmm3,48(%rdi)

# qhasm: *(int128 *)(rop +  64) =  r4
# asm 1: movdqa <r4=int6464#5,64(<rop=int64#1)
# asm 2: movdqa <r4=%xmm4,64(<rop=%rdi)
movdqa %xmm4,64(%rdi)

# qhasm: *(int128 *)(rop +  80) =  r5
# asm 1: movdqa <r5=int6464#6,80(<rop=int64#1)
# asm 2: movdqa <r5=%xmm5,80(<rop=%rdi)
movdqa %xmm5,80(%rdi)

# qhasm: *(int128 *)(rop +  96) =  r6
# asm 1: movdqa <r6=int6464#7,96(<rop=int64#1)
# asm 2: movdqa <r6=%xmm6,96(<rop=%rdi)
movdqa %xmm6,96(%rdi)

# qhasm: *(int128 *)(rop + 112) =  r7
# asm 1: movdqa <r7=int6464#8,112(<rop=int64#1)
# asm 2: movdqa <r7=%xmm7,112(<rop=%rdi)
movdqa %xmm7,112(%rdi)

# qhasm: *(int128 *)(rop + 128) =  r8
# asm 1: movdqa <r8=int6464#9,128(<rop=int64#1)
# asm 2: movdqa <r8=%xmm8,128(<rop=%rdi)
movdqa %xmm8,128(%rdi)

# qhasm: *(int128 *)(rop + 144) =  r9
# asm 1: movdqa <r9=int6464#10,144(<rop=int64#1)
# asm 2: movdqa <r9=%xmm9,144(<rop=%rdi)
movdqa %xmm9,144(%rdi)

# qhasm: *(int128 *)(rop + 160) = r10
# asm 1: movdqa <r10=int6464#11,160(<rop=int64#1)
# asm 2: movdqa <r10=%xmm10,160(<rop=%rdi)
movdqa %xmm10,160(%rdi)

# qhasm: *(int128 *)(rop + 176) = r11
# asm 1: movdqa <r11=int6464#12,176(<rop=int64#1)
# asm 2: movdqa <r11=%xmm11,176(<rop=%rdi)
movdqa %xmm11,176(%rdi)

# qhasm: leave
add %r11,%rsp
mov %rdi,%rax
mov %rsi,%rdx
pop %rbp
ret
