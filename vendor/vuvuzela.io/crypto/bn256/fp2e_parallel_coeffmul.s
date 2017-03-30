# File:   dclxvi-20130329/fp2e_parallel_coeffmul.s
# Author: Ruben Niederhagen, Peter Schwabe
# Public Domain


# qhasm: enter fp2e_parallel_coeffmul_qhasm
.text
.p2align 5
.globl _fp2e_parallel_coeffmul_qhasm
.globl fp2e_parallel_coeffmul_qhasm
_fp2e_parallel_coeffmul_qhasm:
fp2e_parallel_coeffmul_qhasm:
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

# qhasm: stack6144 playground

# qhasm: int64 rp

# qhasm: rp = &playground
# asm 1: leaq <playground=stack6144#1,>rp=int64#4
# asm 2: leaq <playground=0(%rsp),>rp=%rcx
leaq 0(%rsp),%rcx

# qhasm: int64 c0

# qhasm: caller c0

# qhasm: stack64 stack_c0

# qhasm: int64 c1

# qhasm: caller c1

# qhasm: stack64 stack_c1

# qhasm: int64 c2

# qhasm: caller c2

# qhasm: stack64 stack_c2

# qhasm: int64 c3

# qhasm: caller c3

# qhasm: stack64 stack_c3

# qhasm: int64 c4

# qhasm: caller c4

# qhasm: stack64 stack_c4

# qhasm: int64 c5

# qhasm: caller c5

# qhasm: stack64 stack_c5

# qhasm: int64 c6

# qhasm: caller c6

# qhasm: stack64 stack_c6

# qhasm: int64 c7

# qhasm: caller c7

# qhasm: stack64 stack_c7

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

# qhasm: int6464 r12

# qhasm: int6464 r13

# qhasm: int6464 r14

# qhasm: int6464 r15

# qhasm: int6464 r16

# qhasm: int6464 r17

# qhasm: int6464 r18

# qhasm: int6464 r19

# qhasm: int6464 r20

# qhasm: int6464 r21

# qhasm: int6464 r22

# qhasm: int6464 yoff

# qhasm: int6464 t0

# qhasm: int6464 t1

# qhasm: int6464 t2

# qhasm: int6464 t3

# qhasm: int6464 t4

# qhasm: int6464 t5

# qhasm: int6464 t6

# qhasm: int6464 t7

# qhasm: int6464 t8

# qhasm: int6464 t9

# qhasm: int6464 t10

# qhasm: int6464 t11

# qhasm: int6464 t12

# qhasm: int6464 t13

# qhasm: int6464 t14

# qhasm: int6464 t15

# qhasm: int6464 t16

# qhasm: int6464 t17

# qhasm: int6464 t18

# qhasm: int6464 t19

# qhasm: int6464 t20

# qhasm: int6464 t21

# qhasm: int6464 t22

# qhasm: int6464 ab1

# qhasm: int6464 ab7

# qhasm: int6464 ab1six

# qhasm: int6464 ab2six

# qhasm: int6464 ab3six

# qhasm: int6464 ab4six

# qhasm: int6464 ab5six

# qhasm: int6464 ab6six

# qhasm: int6464 ab7six

# qhasm: int6464 ab8six

# qhasm: int6464 ab9six

# qhasm: int6464 ab10six

# qhasm: int6464 ab11six

# qhasm: int6464 sixsix

# qhasm: int6464 b11

# qhasm: sixsix = SIX_SIX
# asm 1: movdqa SIX_SIX,<sixsix=int6464#1
# asm 2: movdqa SIX_SIX,<sixsix=%xmm0
mov SIX_SIX@GOTPCREL(%rip), %rbp
movdqa (%rbp),%xmm0

# qhasm: b11 = *(int128 *)(op2 + 176)
# asm 1: movdqa 176(<op2=int64#3),>b11=int6464#2
# asm 2: movdqa 176(<op2=%rdx),>b11=%xmm1
movdqa 176(%rdx),%xmm1

# qhasm: r11 = *(int128 *)(op1 + 0)
# asm 1: movdqa 0(<op1=int64#2),>r11=int6464#3
# asm 2: movdqa 0(<op1=%rsi),>r11=%xmm2
movdqa 0(%rsi),%xmm2

# qhasm: r0 = r11
# asm 1: movdqa <r11=int6464#3,>r0=int6464#4
# asm 2: movdqa <r11=%xmm2,>r0=%xmm3
movdqa %xmm2,%xmm3

# qhasm: float6464 r0 *= *(int128 *)(op2 + 0)
# asm 1: mulpd 0(<op2=int64#3),<r0=int6464#4
# asm 2: mulpd 0(<op2=%rdx),<r0=%xmm3
mulpd 0(%rdx),%xmm3

# qhasm: r1 = r11
# asm 1: movdqa <r11=int6464#3,>r1=int6464#5
# asm 2: movdqa <r11=%xmm2,>r1=%xmm4
movdqa %xmm2,%xmm4

# qhasm: float6464 r1 *= *(int128 *)(op2 + 16)
# asm 1: mulpd 16(<op2=int64#3),<r1=int6464#5
# asm 2: mulpd 16(<op2=%rdx),<r1=%xmm4
mulpd 16(%rdx),%xmm4

# qhasm: r2 = r11
# asm 1: movdqa <r11=int6464#3,>r2=int6464#6
# asm 2: movdqa <r11=%xmm2,>r2=%xmm5
movdqa %xmm2,%xmm5

# qhasm: float6464 r2 *= *(int128 *)(op2 + 32)
# asm 1: mulpd 32(<op2=int64#3),<r2=int6464#6
# asm 2: mulpd 32(<op2=%rdx),<r2=%xmm5
mulpd 32(%rdx),%xmm5

# qhasm: r3 = r11
# asm 1: movdqa <r11=int6464#3,>r3=int6464#7
# asm 2: movdqa <r11=%xmm2,>r3=%xmm6
movdqa %xmm2,%xmm6

# qhasm: float6464 r3 *= *(int128 *)(op2 + 48)
# asm 1: mulpd 48(<op2=int64#3),<r3=int6464#7
# asm 2: mulpd 48(<op2=%rdx),<r3=%xmm6
mulpd 48(%rdx),%xmm6

# qhasm: r4 = r11
# asm 1: movdqa <r11=int6464#3,>r4=int6464#8
# asm 2: movdqa <r11=%xmm2,>r4=%xmm7
movdqa %xmm2,%xmm7

# qhasm: float6464 r4 *= *(int128 *)(op2 + 64)
# asm 1: mulpd 64(<op2=int64#3),<r4=int6464#8
# asm 2: mulpd 64(<op2=%rdx),<r4=%xmm7
mulpd 64(%rdx),%xmm7

# qhasm: r5 = r11
# asm 1: movdqa <r11=int6464#3,>r5=int6464#9
# asm 2: movdqa <r11=%xmm2,>r5=%xmm8
movdqa %xmm2,%xmm8

# qhasm: float6464 r5 *= *(int128 *)(op2 + 80)
# asm 1: mulpd 80(<op2=int64#3),<r5=int6464#9
# asm 2: mulpd 80(<op2=%rdx),<r5=%xmm8
mulpd 80(%rdx),%xmm8

# qhasm: r6 = r11
# asm 1: movdqa <r11=int6464#3,>r6=int6464#10
# asm 2: movdqa <r11=%xmm2,>r6=%xmm9
movdqa %xmm2,%xmm9

# qhasm: float6464 r6 *= *(int128 *)(op2 + 96)
# asm 1: mulpd 96(<op2=int64#3),<r6=int6464#10
# asm 2: mulpd 96(<op2=%rdx),<r6=%xmm9
mulpd 96(%rdx),%xmm9

# qhasm: r7 = r11
# asm 1: movdqa <r11=int6464#3,>r7=int6464#11
# asm 2: movdqa <r11=%xmm2,>r7=%xmm10
movdqa %xmm2,%xmm10

# qhasm: float6464 r7 *= *(int128 *)(op2 + 112)
# asm 1: mulpd 112(<op2=int64#3),<r7=int6464#11
# asm 2: mulpd 112(<op2=%rdx),<r7=%xmm10
mulpd 112(%rdx),%xmm10

# qhasm: r8 = r11
# asm 1: movdqa <r11=int6464#3,>r8=int6464#12
# asm 2: movdqa <r11=%xmm2,>r8=%xmm11
movdqa %xmm2,%xmm11

# qhasm: float6464 r8 *= *(int128 *)(op2 + 128)
# asm 1: mulpd 128(<op2=int64#3),<r8=int6464#12
# asm 2: mulpd 128(<op2=%rdx),<r8=%xmm11
mulpd 128(%rdx),%xmm11

# qhasm: r9 = r11
# asm 1: movdqa <r11=int6464#3,>r9=int6464#13
# asm 2: movdqa <r11=%xmm2,>r9=%xmm12
movdqa %xmm2,%xmm12

# qhasm: float6464 r9 *= *(int128 *)(op2 + 144)
# asm 1: mulpd 144(<op2=int64#3),<r9=int6464#13
# asm 2: mulpd 144(<op2=%rdx),<r9=%xmm12
mulpd 144(%rdx),%xmm12

# qhasm: r10 = r11
# asm 1: movdqa <r11=int6464#3,>r10=int6464#14
# asm 2: movdqa <r11=%xmm2,>r10=%xmm13
movdqa %xmm2,%xmm13

# qhasm: float6464 r10 *= *(int128 *)(op2 + 160)
# asm 1: mulpd 160(<op2=int64#3),<r10=int6464#14
# asm 2: mulpd 160(<op2=%rdx),<r10=%xmm13
mulpd 160(%rdx),%xmm13

# qhasm: float6464 r11 *= b11
# asm 1: mulpd <b11=int6464#2,<r11=int6464#3
# asm 2: mulpd <b11=%xmm1,<r11=%xmm2
mulpd %xmm1,%xmm2

# qhasm: *(int128 *)(rp + 0) = r0
# asm 1: movdqa <r0=int6464#4,0(<rp=int64#4)
# asm 2: movdqa <r0=%xmm3,0(<rp=%rcx)
movdqa %xmm3,0(%rcx)

# qhasm: ab1 = *(int128 *)(op1 + 16)
# asm 1: movdqa 16(<op1=int64#2),>ab1=int6464#4
# asm 2: movdqa 16(<op1=%rsi),>ab1=%xmm3
movdqa 16(%rsi),%xmm3

# qhasm: r12 = ab1
# asm 1: movdqa <ab1=int6464#4,>r12=int6464#15
# asm 2: movdqa <ab1=%xmm3,>r12=%xmm14
movdqa %xmm3,%xmm14

# qhasm: float6464 r12 *= sixsix
# asm 1: mulpd <sixsix=int6464#1,<r12=int6464#15
# asm 2: mulpd <sixsix=%xmm0,<r12=%xmm14
mulpd %xmm0,%xmm14

# qhasm: t1 = ab1
# asm 1: movdqa <ab1=int6464#4,>t1=int6464#16
# asm 2: movdqa <ab1=%xmm3,>t1=%xmm15
movdqa %xmm3,%xmm15

# qhasm: float6464 t1 *= *(int128 *)(op2 + 0)
# asm 1: mulpd 0(<op2=int64#3),<t1=int6464#16
# asm 2: mulpd 0(<op2=%rdx),<t1=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r1 +=t1
# asm 1: addpd <t1=int6464#16,<r1=int6464#5
# asm 2: addpd <t1=%xmm15,<r1=%xmm4
addpd %xmm15,%xmm4

# qhasm: float6464 ab1 *= *(int128 *)(op2 + 96)
# asm 1: mulpd 96(<op2=int64#3),<ab1=int6464#4
# asm 2: mulpd 96(<op2=%rdx),<ab1=%xmm3
mulpd 96(%rdx),%xmm3

# qhasm: float6464 r7 +=ab1
# asm 1: addpd <ab1=int6464#4,<r7=int6464#11
# asm 2: addpd <ab1=%xmm3,<r7=%xmm10
addpd %xmm3,%xmm10

# qhasm: t2 = r12
# asm 1: movdqa <r12=int6464#15,>t2=int6464#4
# asm 2: movdqa <r12=%xmm14,>t2=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 t2 *= *(int128 *)(op2 + 16)
# asm 1: mulpd 16(<op2=int64#3),<t2=int6464#4
# asm 2: mulpd 16(<op2=%rdx),<t2=%xmm3
mulpd 16(%rdx),%xmm3

# qhasm: float6464 r2 +=t2
# asm 1: addpd <t2=int6464#4,<r2=int6464#6
# asm 2: addpd <t2=%xmm3,<r2=%xmm5
addpd %xmm3,%xmm5

# qhasm: t3 = r12
# asm 1: movdqa <r12=int6464#15,>t3=int6464#4
# asm 2: movdqa <r12=%xmm14,>t3=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 t3 *= *(int128 *)(op2 + 32)
# asm 1: mulpd 32(<op2=int64#3),<t3=int6464#4
# asm 2: mulpd 32(<op2=%rdx),<t3=%xmm3
mulpd 32(%rdx),%xmm3

# qhasm: float6464 r3 +=t3
# asm 1: addpd <t3=int6464#4,<r3=int6464#7
# asm 2: addpd <t3=%xmm3,<r3=%xmm6
addpd %xmm3,%xmm6

# qhasm: t4 = r12
# asm 1: movdqa <r12=int6464#15,>t4=int6464#4
# asm 2: movdqa <r12=%xmm14,>t4=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 t4 *= *(int128 *)(op2 + 48)
# asm 1: mulpd 48(<op2=int64#3),<t4=int6464#4
# asm 2: mulpd 48(<op2=%rdx),<t4=%xmm3
mulpd 48(%rdx),%xmm3

# qhasm: float6464 r4 +=t4
# asm 1: addpd <t4=int6464#4,<r4=int6464#8
# asm 2: addpd <t4=%xmm3,<r4=%xmm7
addpd %xmm3,%xmm7

# qhasm: t5 = r12
# asm 1: movdqa <r12=int6464#15,>t5=int6464#4
# asm 2: movdqa <r12=%xmm14,>t5=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 t5 *= *(int128 *)(op2 + 64)
# asm 1: mulpd 64(<op2=int64#3),<t5=int6464#4
# asm 2: mulpd 64(<op2=%rdx),<t5=%xmm3
mulpd 64(%rdx),%xmm3

# qhasm: float6464 r5 +=t5
# asm 1: addpd <t5=int6464#4,<r5=int6464#9
# asm 2: addpd <t5=%xmm3,<r5=%xmm8
addpd %xmm3,%xmm8

# qhasm: t6 = r12
# asm 1: movdqa <r12=int6464#15,>t6=int6464#4
# asm 2: movdqa <r12=%xmm14,>t6=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 t6 *= *(int128 *)(op2 + 80)
# asm 1: mulpd 80(<op2=int64#3),<t6=int6464#4
# asm 2: mulpd 80(<op2=%rdx),<t6=%xmm3
mulpd 80(%rdx),%xmm3

# qhasm: float6464 r6 +=t6
# asm 1: addpd <t6=int6464#4,<r6=int6464#10
# asm 2: addpd <t6=%xmm3,<r6=%xmm9
addpd %xmm3,%xmm9

# qhasm: t8 = r12
# asm 1: movdqa <r12=int6464#15,>t8=int6464#4
# asm 2: movdqa <r12=%xmm14,>t8=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 t8 *= *(int128 *)(op2 + 112)
# asm 1: mulpd 112(<op2=int64#3),<t8=int6464#4
# asm 2: mulpd 112(<op2=%rdx),<t8=%xmm3
mulpd 112(%rdx),%xmm3

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#4,<r8=int6464#12
# asm 2: addpd <t8=%xmm3,<r8=%xmm11
addpd %xmm3,%xmm11

# qhasm: t9 = r12
# asm 1: movdqa <r12=int6464#15,>t9=int6464#4
# asm 2: movdqa <r12=%xmm14,>t9=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 t9 *= *(int128 *)(op2 + 128)
# asm 1: mulpd 128(<op2=int64#3),<t9=int6464#4
# asm 2: mulpd 128(<op2=%rdx),<t9=%xmm3
mulpd 128(%rdx),%xmm3

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#4,<r9=int6464#13
# asm 2: addpd <t9=%xmm3,<r9=%xmm12
addpd %xmm3,%xmm12

# qhasm: t10 = r12
# asm 1: movdqa <r12=int6464#15,>t10=int6464#4
# asm 2: movdqa <r12=%xmm14,>t10=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 t10 *= *(int128 *)(op2 + 144)
# asm 1: mulpd 144(<op2=int64#3),<t10=int6464#4
# asm 2: mulpd 144(<op2=%rdx),<t10=%xmm3
mulpd 144(%rdx),%xmm3

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#4,<r10=int6464#14
# asm 2: addpd <t10=%xmm3,<r10=%xmm13
addpd %xmm3,%xmm13

# qhasm: t11 = r12
# asm 1: movdqa <r12=int6464#15,>t11=int6464#4
# asm 2: movdqa <r12=%xmm14,>t11=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 t11 *= *(int128 *)(op2 + 160)
# asm 1: mulpd 160(<op2=int64#3),<t11=int6464#4
# asm 2: mulpd 160(<op2=%rdx),<t11=%xmm3
mulpd 160(%rdx),%xmm3

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#4,<r11=int6464#3
# asm 2: addpd <t11=%xmm3,<r11=%xmm2
addpd %xmm3,%xmm2

# qhasm: float6464 r12 *= b11
# asm 1: mulpd <b11=int6464#2,<r12=int6464#15
# asm 2: mulpd <b11=%xmm1,<r12=%xmm14
mulpd %xmm1,%xmm14

# qhasm: *(int128 *)(rp + 16) = r1
# asm 1: movdqa <r1=int6464#5,16(<rp=int64#4)
# asm 2: movdqa <r1=%xmm4,16(<rp=%rcx)
movdqa %xmm4,16(%rcx)

# qhasm: r13 = *(int128 *)(op1 + 32)
# asm 1: movdqa 32(<op1=int64#2),>r13=int6464#4
# asm 2: movdqa 32(<op1=%rsi),>r13=%xmm3
movdqa 32(%rsi),%xmm3

# qhasm: ab2six = r13
# asm 1: movdqa <r13=int6464#4,>ab2six=int6464#5
# asm 2: movdqa <r13=%xmm3,>ab2six=%xmm4
movdqa %xmm3,%xmm4

# qhasm: float6464 ab2six *= sixsix
# asm 1: mulpd <sixsix=int6464#1,<ab2six=int6464#5
# asm 2: mulpd <sixsix=%xmm0,<ab2six=%xmm4
mulpd %xmm0,%xmm4

# qhasm: t2 = r13
# asm 1: movdqa <r13=int6464#4,>t2=int6464#16
# asm 2: movdqa <r13=%xmm3,>t2=%xmm15
movdqa %xmm3,%xmm15

# qhasm: float6464 t2 *= *(int128 *)(op2 + 0)
# asm 1: mulpd 0(<op2=int64#3),<t2=int6464#16
# asm 2: mulpd 0(<op2=%rdx),<t2=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r2 +=t2
# asm 1: addpd <t2=int6464#16,<r2=int6464#6
# asm 2: addpd <t2=%xmm15,<r2=%xmm5
addpd %xmm15,%xmm5

# qhasm: t7 = r13
# asm 1: movdqa <r13=int6464#4,>t7=int6464#16
# asm 2: movdqa <r13=%xmm3,>t7=%xmm15
movdqa %xmm3,%xmm15

# qhasm: float6464 t7 *= *(int128 *)(op2 + 80)
# asm 1: mulpd 80(<op2=int64#3),<t7=int6464#16
# asm 2: mulpd 80(<op2=%rdx),<t7=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r7 +=t7
# asm 1: addpd <t7=int6464#16,<r7=int6464#11
# asm 2: addpd <t7=%xmm15,<r7=%xmm10
addpd %xmm15,%xmm10

# qhasm: t8 = r13
# asm 1: movdqa <r13=int6464#4,>t8=int6464#16
# asm 2: movdqa <r13=%xmm3,>t8=%xmm15
movdqa %xmm3,%xmm15

# qhasm: float6464 t8 *= *(int128 *)(op2 + 96)
# asm 1: mulpd 96(<op2=int64#3),<t8=int6464#16
# asm 2: mulpd 96(<op2=%rdx),<t8=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#16,<r8=int6464#12
# asm 2: addpd <t8=%xmm15,<r8=%xmm11
addpd %xmm15,%xmm11

# qhasm: float6464 r13 *= b11
# asm 1: mulpd <b11=int6464#2,<r13=int6464#4
# asm 2: mulpd <b11=%xmm1,<r13=%xmm3
mulpd %xmm1,%xmm3

# qhasm: t3 = ab2six
# asm 1: movdqa <ab2six=int6464#5,>t3=int6464#16
# asm 2: movdqa <ab2six=%xmm4,>t3=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t3 *= *(int128 *)(op2 + 16)
# asm 1: mulpd 16(<op2=int64#3),<t3=int6464#16
# asm 2: mulpd 16(<op2=%rdx),<t3=%xmm15
mulpd 16(%rdx),%xmm15

# qhasm: float6464 r3 +=t3
# asm 1: addpd <t3=int6464#16,<r3=int6464#7
# asm 2: addpd <t3=%xmm15,<r3=%xmm6
addpd %xmm15,%xmm6

# qhasm: t4 = ab2six
# asm 1: movdqa <ab2six=int6464#5,>t4=int6464#16
# asm 2: movdqa <ab2six=%xmm4,>t4=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t4 *= *(int128 *)(op2 + 32)
# asm 1: mulpd 32(<op2=int64#3),<t4=int6464#16
# asm 2: mulpd 32(<op2=%rdx),<t4=%xmm15
mulpd 32(%rdx),%xmm15

# qhasm: float6464 r4 +=t4
# asm 1: addpd <t4=int6464#16,<r4=int6464#8
# asm 2: addpd <t4=%xmm15,<r4=%xmm7
addpd %xmm15,%xmm7

# qhasm: t5 = ab2six
# asm 1: movdqa <ab2six=int6464#5,>t5=int6464#16
# asm 2: movdqa <ab2six=%xmm4,>t5=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t5 *= *(int128 *)(op2 + 48)
# asm 1: mulpd 48(<op2=int64#3),<t5=int6464#16
# asm 2: mulpd 48(<op2=%rdx),<t5=%xmm15
mulpd 48(%rdx),%xmm15

# qhasm: float6464 r5 +=t5
# asm 1: addpd <t5=int6464#16,<r5=int6464#9
# asm 2: addpd <t5=%xmm15,<r5=%xmm8
addpd %xmm15,%xmm8

# qhasm: t6 = ab2six
# asm 1: movdqa <ab2six=int6464#5,>t6=int6464#16
# asm 2: movdqa <ab2six=%xmm4,>t6=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t6 *= *(int128 *)(op2 + 64)
# asm 1: mulpd 64(<op2=int64#3),<t6=int6464#16
# asm 2: mulpd 64(<op2=%rdx),<t6=%xmm15
mulpd 64(%rdx),%xmm15

# qhasm: float6464 r6 +=t6
# asm 1: addpd <t6=int6464#16,<r6=int6464#10
# asm 2: addpd <t6=%xmm15,<r6=%xmm9
addpd %xmm15,%xmm9

# qhasm: t9 = ab2six
# asm 1: movdqa <ab2six=int6464#5,>t9=int6464#16
# asm 2: movdqa <ab2six=%xmm4,>t9=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t9 *= *(int128 *)(op2 + 112)
# asm 1: mulpd 112(<op2=int64#3),<t9=int6464#16
# asm 2: mulpd 112(<op2=%rdx),<t9=%xmm15
mulpd 112(%rdx),%xmm15

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#16,<r9=int6464#13
# asm 2: addpd <t9=%xmm15,<r9=%xmm12
addpd %xmm15,%xmm12

# qhasm: t10 = ab2six
# asm 1: movdqa <ab2six=int6464#5,>t10=int6464#16
# asm 2: movdqa <ab2six=%xmm4,>t10=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t10 *= *(int128 *)(op2 + 128)
# asm 1: mulpd 128(<op2=int64#3),<t10=int6464#16
# asm 2: mulpd 128(<op2=%rdx),<t10=%xmm15
mulpd 128(%rdx),%xmm15

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#16,<r10=int6464#14
# asm 2: addpd <t10=%xmm15,<r10=%xmm13
addpd %xmm15,%xmm13

# qhasm: t11 = ab2six
# asm 1: movdqa <ab2six=int6464#5,>t11=int6464#16
# asm 2: movdqa <ab2six=%xmm4,>t11=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t11 *= *(int128 *)(op2 + 144)
# asm 1: mulpd 144(<op2=int64#3),<t11=int6464#16
# asm 2: mulpd 144(<op2=%rdx),<t11=%xmm15
mulpd 144(%rdx),%xmm15

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#16,<r11=int6464#3
# asm 2: addpd <t11=%xmm15,<r11=%xmm2
addpd %xmm15,%xmm2

# qhasm: float6464 ab2six *= *(int128 *)(op2 + 160)
# asm 1: mulpd 160(<op2=int64#3),<ab2six=int6464#5
# asm 2: mulpd 160(<op2=%rdx),<ab2six=%xmm4
mulpd 160(%rdx),%xmm4

# qhasm: float6464 r12 += ab2six
# asm 1: addpd <ab2six=int6464#5,<r12=int6464#15
# asm 2: addpd <ab2six=%xmm4,<r12=%xmm14
addpd %xmm4,%xmm14

# qhasm: *(int128 *)(rp + 32) = r2
# asm 1: movdqa <r2=int6464#6,32(<rp=int64#4)
# asm 2: movdqa <r2=%xmm5,32(<rp=%rcx)
movdqa %xmm5,32(%rcx)

# qhasm: r14 = *(int128 *)(op1 + 48)
# asm 1: movdqa 48(<op1=int64#2),>r14=int6464#5
# asm 2: movdqa 48(<op1=%rsi),>r14=%xmm4
movdqa 48(%rsi),%xmm4

# qhasm: ab3six = r14
# asm 1: movdqa <r14=int6464#5,>ab3six=int6464#6
# asm 2: movdqa <r14=%xmm4,>ab3six=%xmm5
movdqa %xmm4,%xmm5

# qhasm: float6464 ab3six *= sixsix
# asm 1: mulpd <sixsix=int6464#1,<ab3six=int6464#6
# asm 2: mulpd <sixsix=%xmm0,<ab3six=%xmm5
mulpd %xmm0,%xmm5

# qhasm: t3 = r14
# asm 1: movdqa <r14=int6464#5,>t3=int6464#16
# asm 2: movdqa <r14=%xmm4,>t3=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t3 *= *(int128 *)(op2 + 0)
# asm 1: mulpd 0(<op2=int64#3),<t3=int6464#16
# asm 2: mulpd 0(<op2=%rdx),<t3=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r3 +=t3
# asm 1: addpd <t3=int6464#16,<r3=int6464#7
# asm 2: addpd <t3=%xmm15,<r3=%xmm6
addpd %xmm15,%xmm6

# qhasm: t7 = r14
# asm 1: movdqa <r14=int6464#5,>t7=int6464#16
# asm 2: movdqa <r14=%xmm4,>t7=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t7 *= *(int128 *)(op2 + 64)
# asm 1: mulpd 64(<op2=int64#3),<t7=int6464#16
# asm 2: mulpd 64(<op2=%rdx),<t7=%xmm15
mulpd 64(%rdx),%xmm15

# qhasm: float6464 r7 +=t7
# asm 1: addpd <t7=int6464#16,<r7=int6464#11
# asm 2: addpd <t7=%xmm15,<r7=%xmm10
addpd %xmm15,%xmm10

# qhasm: t8 = r14
# asm 1: movdqa <r14=int6464#5,>t8=int6464#16
# asm 2: movdqa <r14=%xmm4,>t8=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t8 *= *(int128 *)(op2 + 80)
# asm 1: mulpd 80(<op2=int64#3),<t8=int6464#16
# asm 2: mulpd 80(<op2=%rdx),<t8=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#16,<r8=int6464#12
# asm 2: addpd <t8=%xmm15,<r8=%xmm11
addpd %xmm15,%xmm11

# qhasm: t9 = r14
# asm 1: movdqa <r14=int6464#5,>t9=int6464#16
# asm 2: movdqa <r14=%xmm4,>t9=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t9 *= *(int128 *)(op2 + 96)
# asm 1: mulpd 96(<op2=int64#3),<t9=int6464#16
# asm 2: mulpd 96(<op2=%rdx),<t9=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#16,<r9=int6464#13
# asm 2: addpd <t9=%xmm15,<r9=%xmm12
addpd %xmm15,%xmm12

# qhasm: t13 = r14
# asm 1: movdqa <r14=int6464#5,>t13=int6464#16
# asm 2: movdqa <r14=%xmm4,>t13=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t13 *= *(int128 *)(op2 + 160)
# asm 1: mulpd 160(<op2=int64#3),<t13=int6464#16
# asm 2: mulpd 160(<op2=%rdx),<t13=%xmm15
mulpd 160(%rdx),%xmm15

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#16,<r13=int6464#4
# asm 2: addpd <t13=%xmm15,<r13=%xmm3
addpd %xmm15,%xmm3

# qhasm: float6464 r14 *= b11
# asm 1: mulpd <b11=int6464#2,<r14=int6464#5
# asm 2: mulpd <b11=%xmm1,<r14=%xmm4
mulpd %xmm1,%xmm4

# qhasm: t4 = ab3six
# asm 1: movdqa <ab3six=int6464#6,>t4=int6464#16
# asm 2: movdqa <ab3six=%xmm5,>t4=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t4 *= *(int128 *)(op2 + 16)
# asm 1: mulpd 16(<op2=int64#3),<t4=int6464#16
# asm 2: mulpd 16(<op2=%rdx),<t4=%xmm15
mulpd 16(%rdx),%xmm15

# qhasm: float6464 r4 +=t4
# asm 1: addpd <t4=int6464#16,<r4=int6464#8
# asm 2: addpd <t4=%xmm15,<r4=%xmm7
addpd %xmm15,%xmm7

# qhasm: t5 = ab3six
# asm 1: movdqa <ab3six=int6464#6,>t5=int6464#16
# asm 2: movdqa <ab3six=%xmm5,>t5=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t5 *= *(int128 *)(op2 + 32)
# asm 1: mulpd 32(<op2=int64#3),<t5=int6464#16
# asm 2: mulpd 32(<op2=%rdx),<t5=%xmm15
mulpd 32(%rdx),%xmm15

# qhasm: float6464 r5 +=t5
# asm 1: addpd <t5=int6464#16,<r5=int6464#9
# asm 2: addpd <t5=%xmm15,<r5=%xmm8
addpd %xmm15,%xmm8

# qhasm: t6 = ab3six
# asm 1: movdqa <ab3six=int6464#6,>t6=int6464#16
# asm 2: movdqa <ab3six=%xmm5,>t6=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t6 *= *(int128 *)(op2 + 48)
# asm 1: mulpd 48(<op2=int64#3),<t6=int6464#16
# asm 2: mulpd 48(<op2=%rdx),<t6=%xmm15
mulpd 48(%rdx),%xmm15

# qhasm: float6464 r6 +=t6
# asm 1: addpd <t6=int6464#16,<r6=int6464#10
# asm 2: addpd <t6=%xmm15,<r6=%xmm9
addpd %xmm15,%xmm9

# qhasm: t10 = ab3six
# asm 1: movdqa <ab3six=int6464#6,>t10=int6464#16
# asm 2: movdqa <ab3six=%xmm5,>t10=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t10 *= *(int128 *)(op2 + 112)
# asm 1: mulpd 112(<op2=int64#3),<t10=int6464#16
# asm 2: mulpd 112(<op2=%rdx),<t10=%xmm15
mulpd 112(%rdx),%xmm15

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#16,<r10=int6464#14
# asm 2: addpd <t10=%xmm15,<r10=%xmm13
addpd %xmm15,%xmm13

# qhasm: t11 = ab3six
# asm 1: movdqa <ab3six=int6464#6,>t11=int6464#16
# asm 2: movdqa <ab3six=%xmm5,>t11=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t11 *= *(int128 *)(op2 + 128)
# asm 1: mulpd 128(<op2=int64#3),<t11=int6464#16
# asm 2: mulpd 128(<op2=%rdx),<t11=%xmm15
mulpd 128(%rdx),%xmm15

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#16,<r11=int6464#3
# asm 2: addpd <t11=%xmm15,<r11=%xmm2
addpd %xmm15,%xmm2

# qhasm: float6464 ab3six *= *(int128 *)(op2 + 144)
# asm 1: mulpd 144(<op2=int64#3),<ab3six=int6464#6
# asm 2: mulpd 144(<op2=%rdx),<ab3six=%xmm5
mulpd 144(%rdx),%xmm5

# qhasm: float6464 r12 += ab3six
# asm 1: addpd <ab3six=int6464#6,<r12=int6464#15
# asm 2: addpd <ab3six=%xmm5,<r12=%xmm14
addpd %xmm5,%xmm14

# qhasm: *(int128 *)(rp + 48) = r3
# asm 1: movdqa <r3=int6464#7,48(<rp=int64#4)
# asm 2: movdqa <r3=%xmm6,48(<rp=%rcx)
movdqa %xmm6,48(%rcx)

# qhasm: r15 = *(int128 *)(op1 + 64)
# asm 1: movdqa 64(<op1=int64#2),>r15=int6464#6
# asm 2: movdqa 64(<op1=%rsi),>r15=%xmm5
movdqa 64(%rsi),%xmm5

# qhasm: ab4six = r15
# asm 1: movdqa <r15=int6464#6,>ab4six=int6464#7
# asm 2: movdqa <r15=%xmm5,>ab4six=%xmm6
movdqa %xmm5,%xmm6

# qhasm: float6464 ab4six *= sixsix
# asm 1: mulpd <sixsix=int6464#1,<ab4six=int6464#7
# asm 2: mulpd <sixsix=%xmm0,<ab4six=%xmm6
mulpd %xmm0,%xmm6

# qhasm: t4 = r15
# asm 1: movdqa <r15=int6464#6,>t4=int6464#16
# asm 2: movdqa <r15=%xmm5,>t4=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t4 *= *(int128 *)(op2 + 0)
# asm 1: mulpd 0(<op2=int64#3),<t4=int6464#16
# asm 2: mulpd 0(<op2=%rdx),<t4=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r4 +=t4
# asm 1: addpd <t4=int6464#16,<r4=int6464#8
# asm 2: addpd <t4=%xmm15,<r4=%xmm7
addpd %xmm15,%xmm7

# qhasm: t7 = r15
# asm 1: movdqa <r15=int6464#6,>t7=int6464#16
# asm 2: movdqa <r15=%xmm5,>t7=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t7 *= *(int128 *)(op2 + 48)
# asm 1: mulpd 48(<op2=int64#3),<t7=int6464#16
# asm 2: mulpd 48(<op2=%rdx),<t7=%xmm15
mulpd 48(%rdx),%xmm15

# qhasm: float6464 r7 +=t7
# asm 1: addpd <t7=int6464#16,<r7=int6464#11
# asm 2: addpd <t7=%xmm15,<r7=%xmm10
addpd %xmm15,%xmm10

# qhasm: t8 = r15
# asm 1: movdqa <r15=int6464#6,>t8=int6464#16
# asm 2: movdqa <r15=%xmm5,>t8=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t8 *= *(int128 *)(op2 + 64)
# asm 1: mulpd 64(<op2=int64#3),<t8=int6464#16
# asm 2: mulpd 64(<op2=%rdx),<t8=%xmm15
mulpd 64(%rdx),%xmm15

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#16,<r8=int6464#12
# asm 2: addpd <t8=%xmm15,<r8=%xmm11
addpd %xmm15,%xmm11

# qhasm: t9 = r15
# asm 1: movdqa <r15=int6464#6,>t9=int6464#16
# asm 2: movdqa <r15=%xmm5,>t9=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t9 *= *(int128 *)(op2 + 80)
# asm 1: mulpd 80(<op2=int64#3),<t9=int6464#16
# asm 2: mulpd 80(<op2=%rdx),<t9=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#16,<r9=int6464#13
# asm 2: addpd <t9=%xmm15,<r9=%xmm12
addpd %xmm15,%xmm12

# qhasm: t10 = r15
# asm 1: movdqa <r15=int6464#6,>t10=int6464#16
# asm 2: movdqa <r15=%xmm5,>t10=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t10 *= *(int128 *)(op2 + 96)
# asm 1: mulpd 96(<op2=int64#3),<t10=int6464#16
# asm 2: mulpd 96(<op2=%rdx),<t10=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#16,<r10=int6464#14
# asm 2: addpd <t10=%xmm15,<r10=%xmm13
addpd %xmm15,%xmm13

# qhasm: t13 = r15
# asm 1: movdqa <r15=int6464#6,>t13=int6464#16
# asm 2: movdqa <r15=%xmm5,>t13=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t13 *= *(int128 *)(op2 + 144)
# asm 1: mulpd 144(<op2=int64#3),<t13=int6464#16
# asm 2: mulpd 144(<op2=%rdx),<t13=%xmm15
mulpd 144(%rdx),%xmm15

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#16,<r13=int6464#4
# asm 2: addpd <t13=%xmm15,<r13=%xmm3
addpd %xmm15,%xmm3

# qhasm: t14 = r15
# asm 1: movdqa <r15=int6464#6,>t14=int6464#16
# asm 2: movdqa <r15=%xmm5,>t14=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t14 *= *(int128 *)(op2 + 160)
# asm 1: mulpd 160(<op2=int64#3),<t14=int6464#16
# asm 2: mulpd 160(<op2=%rdx),<t14=%xmm15
mulpd 160(%rdx),%xmm15

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#16,<r14=int6464#5
# asm 2: addpd <t14=%xmm15,<r14=%xmm4
addpd %xmm15,%xmm4

# qhasm: float6464 r15 *= b11
# asm 1: mulpd <b11=int6464#2,<r15=int6464#6
# asm 2: mulpd <b11=%xmm1,<r15=%xmm5
mulpd %xmm1,%xmm5

# qhasm: t5 = ab4six
# asm 1: movdqa <ab4six=int6464#7,>t5=int6464#16
# asm 2: movdqa <ab4six=%xmm6,>t5=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 t5 *= *(int128 *)(op2 + 16)
# asm 1: mulpd 16(<op2=int64#3),<t5=int6464#16
# asm 2: mulpd 16(<op2=%rdx),<t5=%xmm15
mulpd 16(%rdx),%xmm15

# qhasm: float6464 r5 +=t5
# asm 1: addpd <t5=int6464#16,<r5=int6464#9
# asm 2: addpd <t5=%xmm15,<r5=%xmm8
addpd %xmm15,%xmm8

# qhasm: t6 = ab4six
# asm 1: movdqa <ab4six=int6464#7,>t6=int6464#16
# asm 2: movdqa <ab4six=%xmm6,>t6=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 t6 *= *(int128 *)(op2 + 32)
# asm 1: mulpd 32(<op2=int64#3),<t6=int6464#16
# asm 2: mulpd 32(<op2=%rdx),<t6=%xmm15
mulpd 32(%rdx),%xmm15

# qhasm: float6464 r6 +=t6
# asm 1: addpd <t6=int6464#16,<r6=int6464#10
# asm 2: addpd <t6=%xmm15,<r6=%xmm9
addpd %xmm15,%xmm9

# qhasm: t11 = ab4six
# asm 1: movdqa <ab4six=int6464#7,>t11=int6464#16
# asm 2: movdqa <ab4six=%xmm6,>t11=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 t11 *= *(int128 *)(op2 + 112)
# asm 1: mulpd 112(<op2=int64#3),<t11=int6464#16
# asm 2: mulpd 112(<op2=%rdx),<t11=%xmm15
mulpd 112(%rdx),%xmm15

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#16,<r11=int6464#3
# asm 2: addpd <t11=%xmm15,<r11=%xmm2
addpd %xmm15,%xmm2

# qhasm: float6464 ab4six *= *(int128 *)(op2 + 128)
# asm 1: mulpd 128(<op2=int64#3),<ab4six=int6464#7
# asm 2: mulpd 128(<op2=%rdx),<ab4six=%xmm6
mulpd 128(%rdx),%xmm6

# qhasm: float6464 r12 += ab4six
# asm 1: addpd <ab4six=int6464#7,<r12=int6464#15
# asm 2: addpd <ab4six=%xmm6,<r12=%xmm14
addpd %xmm6,%xmm14

# qhasm: *(int128 *)(rp + 64) = r4
# asm 1: movdqa <r4=int6464#8,64(<rp=int64#4)
# asm 2: movdqa <r4=%xmm7,64(<rp=%rcx)
movdqa %xmm7,64(%rcx)

# qhasm: r16 = *(int128 *)(op1 + 80)
# asm 1: movdqa 80(<op1=int64#2),>r16=int6464#7
# asm 2: movdqa 80(<op1=%rsi),>r16=%xmm6
movdqa 80(%rsi),%xmm6

# qhasm: ab5six = r16
# asm 1: movdqa <r16=int6464#7,>ab5six=int6464#8
# asm 2: movdqa <r16=%xmm6,>ab5six=%xmm7
movdqa %xmm6,%xmm7

# qhasm: float6464 ab5six *= sixsix
# asm 1: mulpd <sixsix=int6464#1,<ab5six=int6464#8
# asm 2: mulpd <sixsix=%xmm0,<ab5six=%xmm7
mulpd %xmm0,%xmm7

# qhasm: t5 = r16
# asm 1: movdqa <r16=int6464#7,>t5=int6464#16
# asm 2: movdqa <r16=%xmm6,>t5=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 t5 *= *(int128 *)(op2 + 0)
# asm 1: mulpd 0(<op2=int64#3),<t5=int6464#16
# asm 2: mulpd 0(<op2=%rdx),<t5=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r5 +=t5
# asm 1: addpd <t5=int6464#16,<r5=int6464#9
# asm 2: addpd <t5=%xmm15,<r5=%xmm8
addpd %xmm15,%xmm8

# qhasm: t7 = r16
# asm 1: movdqa <r16=int6464#7,>t7=int6464#16
# asm 2: movdqa <r16=%xmm6,>t7=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 t7 *= *(int128 *)(op2 + 32)
# asm 1: mulpd 32(<op2=int64#3),<t7=int6464#16
# asm 2: mulpd 32(<op2=%rdx),<t7=%xmm15
mulpd 32(%rdx),%xmm15

# qhasm: float6464 r7 +=t7
# asm 1: addpd <t7=int6464#16,<r7=int6464#11
# asm 2: addpd <t7=%xmm15,<r7=%xmm10
addpd %xmm15,%xmm10

# qhasm: t8 = r16
# asm 1: movdqa <r16=int6464#7,>t8=int6464#16
# asm 2: movdqa <r16=%xmm6,>t8=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 t8 *= *(int128 *)(op2 + 48)
# asm 1: mulpd 48(<op2=int64#3),<t8=int6464#16
# asm 2: mulpd 48(<op2=%rdx),<t8=%xmm15
mulpd 48(%rdx),%xmm15

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#16,<r8=int6464#12
# asm 2: addpd <t8=%xmm15,<r8=%xmm11
addpd %xmm15,%xmm11

# qhasm: t9 = r16
# asm 1: movdqa <r16=int6464#7,>t9=int6464#16
# asm 2: movdqa <r16=%xmm6,>t9=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 t9 *= *(int128 *)(op2 + 64)
# asm 1: mulpd 64(<op2=int64#3),<t9=int6464#16
# asm 2: mulpd 64(<op2=%rdx),<t9=%xmm15
mulpd 64(%rdx),%xmm15

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#16,<r9=int6464#13
# asm 2: addpd <t9=%xmm15,<r9=%xmm12
addpd %xmm15,%xmm12

# qhasm: t10 = r16
# asm 1: movdqa <r16=int6464#7,>t10=int6464#16
# asm 2: movdqa <r16=%xmm6,>t10=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 t10 *= *(int128 *)(op2 + 80)
# asm 1: mulpd 80(<op2=int64#3),<t10=int6464#16
# asm 2: mulpd 80(<op2=%rdx),<t10=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#16,<r10=int6464#14
# asm 2: addpd <t10=%xmm15,<r10=%xmm13
addpd %xmm15,%xmm13

# qhasm: t11 = r16
# asm 1: movdqa <r16=int6464#7,>t11=int6464#16
# asm 2: movdqa <r16=%xmm6,>t11=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 t11 *= *(int128 *)(op2 + 96)
# asm 1: mulpd 96(<op2=int64#3),<t11=int6464#16
# asm 2: mulpd 96(<op2=%rdx),<t11=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#16,<r11=int6464#3
# asm 2: addpd <t11=%xmm15,<r11=%xmm2
addpd %xmm15,%xmm2

# qhasm: t13 = r16
# asm 1: movdqa <r16=int6464#7,>t13=int6464#16
# asm 2: movdqa <r16=%xmm6,>t13=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 t13 *= *(int128 *)(op2 + 128)
# asm 1: mulpd 128(<op2=int64#3),<t13=int6464#16
# asm 2: mulpd 128(<op2=%rdx),<t13=%xmm15
mulpd 128(%rdx),%xmm15

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#16,<r13=int6464#4
# asm 2: addpd <t13=%xmm15,<r13=%xmm3
addpd %xmm15,%xmm3

# qhasm: t14 = r16
# asm 1: movdqa <r16=int6464#7,>t14=int6464#16
# asm 2: movdqa <r16=%xmm6,>t14=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 t14 *= *(int128 *)(op2 + 144)
# asm 1: mulpd 144(<op2=int64#3),<t14=int6464#16
# asm 2: mulpd 144(<op2=%rdx),<t14=%xmm15
mulpd 144(%rdx),%xmm15

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#16,<r14=int6464#5
# asm 2: addpd <t14=%xmm15,<r14=%xmm4
addpd %xmm15,%xmm4

# qhasm: t15 = r16
# asm 1: movdqa <r16=int6464#7,>t15=int6464#16
# asm 2: movdqa <r16=%xmm6,>t15=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 t15 *= *(int128 *)(op2 + 160)
# asm 1: mulpd 160(<op2=int64#3),<t15=int6464#16
# asm 2: mulpd 160(<op2=%rdx),<t15=%xmm15
mulpd 160(%rdx),%xmm15

# qhasm: float6464 r15 +=t15
# asm 1: addpd <t15=int6464#16,<r15=int6464#6
# asm 2: addpd <t15=%xmm15,<r15=%xmm5
addpd %xmm15,%xmm5

# qhasm: float6464 r16 *= b11
# asm 1: mulpd <b11=int6464#2,<r16=int6464#7
# asm 2: mulpd <b11=%xmm1,<r16=%xmm6
mulpd %xmm1,%xmm6

# qhasm: t6 = ab5six
# asm 1: movdqa <ab5six=int6464#8,>t6=int6464#16
# asm 2: movdqa <ab5six=%xmm7,>t6=%xmm15
movdqa %xmm7,%xmm15

# qhasm: float6464 t6 *= *(int128 *)(op2 + 16)
# asm 1: mulpd 16(<op2=int64#3),<t6=int6464#16
# asm 2: mulpd 16(<op2=%rdx),<t6=%xmm15
mulpd 16(%rdx),%xmm15

# qhasm: float6464 r6 +=t6
# asm 1: addpd <t6=int6464#16,<r6=int6464#10
# asm 2: addpd <t6=%xmm15,<r6=%xmm9
addpd %xmm15,%xmm9

# qhasm: float6464 ab5six *= *(int128 *)(op2 + 112)
# asm 1: mulpd 112(<op2=int64#3),<ab5six=int6464#8
# asm 2: mulpd 112(<op2=%rdx),<ab5six=%xmm7
mulpd 112(%rdx),%xmm7

# qhasm: float6464 r12 += ab5six
# asm 1: addpd <ab5six=int6464#8,<r12=int6464#15
# asm 2: addpd <ab5six=%xmm7,<r12=%xmm14
addpd %xmm7,%xmm14

# qhasm: *(int128 *)(rp + 80) = r5
# asm 1: movdqa <r5=int6464#9,80(<rp=int64#4)
# asm 2: movdqa <r5=%xmm8,80(<rp=%rcx)
movdqa %xmm8,80(%rcx)

# qhasm: r17 = *(int128 *)(op1 + 96)
# asm 1: movdqa 96(<op1=int64#2),>r17=int6464#8
# asm 2: movdqa 96(<op1=%rsi),>r17=%xmm7
movdqa 96(%rsi),%xmm7

# qhasm: t6 = r17
# asm 1: movdqa <r17=int6464#8,>t6=int6464#9
# asm 2: movdqa <r17=%xmm7,>t6=%xmm8
movdqa %xmm7,%xmm8

# qhasm: float6464 t6 *= *(int128 *)(op2 + 0)
# asm 1: mulpd 0(<op2=int64#3),<t6=int6464#9
# asm 2: mulpd 0(<op2=%rdx),<t6=%xmm8
mulpd 0(%rdx),%xmm8

# qhasm: float6464 r6 +=t6
# asm 1: addpd <t6=int6464#9,<r6=int6464#10
# asm 2: addpd <t6=%xmm8,<r6=%xmm9
addpd %xmm8,%xmm9

# qhasm: t7 = r17
# asm 1: movdqa <r17=int6464#8,>t7=int6464#9
# asm 2: movdqa <r17=%xmm7,>t7=%xmm8
movdqa %xmm7,%xmm8

# qhasm: float6464 t7 *= *(int128 *)(op2 + 16)
# asm 1: mulpd 16(<op2=int64#3),<t7=int6464#9
# asm 2: mulpd 16(<op2=%rdx),<t7=%xmm8
mulpd 16(%rdx),%xmm8

# qhasm: float6464 r7 +=t7
# asm 1: addpd <t7=int6464#9,<r7=int6464#11
# asm 2: addpd <t7=%xmm8,<r7=%xmm10
addpd %xmm8,%xmm10

# qhasm: t8 = r17
# asm 1: movdqa <r17=int6464#8,>t8=int6464#9
# asm 2: movdqa <r17=%xmm7,>t8=%xmm8
movdqa %xmm7,%xmm8

# qhasm: float6464 t8 *= *(int128 *)(op2 + 32)
# asm 1: mulpd 32(<op2=int64#3),<t8=int6464#9
# asm 2: mulpd 32(<op2=%rdx),<t8=%xmm8
mulpd 32(%rdx),%xmm8

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#9,<r8=int6464#12
# asm 2: addpd <t8=%xmm8,<r8=%xmm11
addpd %xmm8,%xmm11

# qhasm: t9 = r17
# asm 1: movdqa <r17=int6464#8,>t9=int6464#9
# asm 2: movdqa <r17=%xmm7,>t9=%xmm8
movdqa %xmm7,%xmm8

# qhasm: float6464 t9 *= *(int128 *)(op2 + 48)
# asm 1: mulpd 48(<op2=int64#3),<t9=int6464#9
# asm 2: mulpd 48(<op2=%rdx),<t9=%xmm8
mulpd 48(%rdx),%xmm8

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#9,<r9=int6464#13
# asm 2: addpd <t9=%xmm8,<r9=%xmm12
addpd %xmm8,%xmm12

# qhasm: t10 = r17
# asm 1: movdqa <r17=int6464#8,>t10=int6464#9
# asm 2: movdqa <r17=%xmm7,>t10=%xmm8
movdqa %xmm7,%xmm8

# qhasm: float6464 t10 *= *(int128 *)(op2 + 64)
# asm 1: mulpd 64(<op2=int64#3),<t10=int6464#9
# asm 2: mulpd 64(<op2=%rdx),<t10=%xmm8
mulpd 64(%rdx),%xmm8

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#9,<r10=int6464#14
# asm 2: addpd <t10=%xmm8,<r10=%xmm13
addpd %xmm8,%xmm13

# qhasm: t11 = r17
# asm 1: movdqa <r17=int6464#8,>t11=int6464#9
# asm 2: movdqa <r17=%xmm7,>t11=%xmm8
movdqa %xmm7,%xmm8

# qhasm: float6464 t11 *= *(int128 *)(op2 + 80)
# asm 1: mulpd 80(<op2=int64#3),<t11=int6464#9
# asm 2: mulpd 80(<op2=%rdx),<t11=%xmm8
mulpd 80(%rdx),%xmm8

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#9,<r11=int6464#3
# asm 2: addpd <t11=%xmm8,<r11=%xmm2
addpd %xmm8,%xmm2

# qhasm: t12 = r17
# asm 1: movdqa <r17=int6464#8,>t12=int6464#9
# asm 2: movdqa <r17=%xmm7,>t12=%xmm8
movdqa %xmm7,%xmm8

# qhasm: float6464 t12 *= *(int128 *)(op2 + 96)
# asm 1: mulpd 96(<op2=int64#3),<t12=int6464#9
# asm 2: mulpd 96(<op2=%rdx),<t12=%xmm8
mulpd 96(%rdx),%xmm8

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#9,<r12=int6464#15
# asm 2: addpd <t12=%xmm8,<r12=%xmm14
addpd %xmm8,%xmm14

# qhasm: t13 = r17
# asm 1: movdqa <r17=int6464#8,>t13=int6464#9
# asm 2: movdqa <r17=%xmm7,>t13=%xmm8
movdqa %xmm7,%xmm8

# qhasm: float6464 t13 *= *(int128 *)(op2 + 112)
# asm 1: mulpd 112(<op2=int64#3),<t13=int6464#9
# asm 2: mulpd 112(<op2=%rdx),<t13=%xmm8
mulpd 112(%rdx),%xmm8

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#9,<r13=int6464#4
# asm 2: addpd <t13=%xmm8,<r13=%xmm3
addpd %xmm8,%xmm3

# qhasm: t14 = r17
# asm 1: movdqa <r17=int6464#8,>t14=int6464#9
# asm 2: movdqa <r17=%xmm7,>t14=%xmm8
movdqa %xmm7,%xmm8

# qhasm: float6464 t14 *= *(int128 *)(op2 + 128)
# asm 1: mulpd 128(<op2=int64#3),<t14=int6464#9
# asm 2: mulpd 128(<op2=%rdx),<t14=%xmm8
mulpd 128(%rdx),%xmm8

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#9,<r14=int6464#5
# asm 2: addpd <t14=%xmm8,<r14=%xmm4
addpd %xmm8,%xmm4

# qhasm: t15 = r17
# asm 1: movdqa <r17=int6464#8,>t15=int6464#9
# asm 2: movdqa <r17=%xmm7,>t15=%xmm8
movdqa %xmm7,%xmm8

# qhasm: float6464 t15 *= *(int128 *)(op2 + 144)
# asm 1: mulpd 144(<op2=int64#3),<t15=int6464#9
# asm 2: mulpd 144(<op2=%rdx),<t15=%xmm8
mulpd 144(%rdx),%xmm8

# qhasm: float6464 r15 +=t15
# asm 1: addpd <t15=int6464#9,<r15=int6464#6
# asm 2: addpd <t15=%xmm8,<r15=%xmm5
addpd %xmm8,%xmm5

# qhasm: t16 = r17
# asm 1: movdqa <r17=int6464#8,>t16=int6464#9
# asm 2: movdqa <r17=%xmm7,>t16=%xmm8
movdqa %xmm7,%xmm8

# qhasm: float6464 t16 *= *(int128 *)(op2 + 160)
# asm 1: mulpd 160(<op2=int64#3),<t16=int6464#9
# asm 2: mulpd 160(<op2=%rdx),<t16=%xmm8
mulpd 160(%rdx),%xmm8

# qhasm: float6464 r16 +=t16
# asm 1: addpd <t16=int6464#9,<r16=int6464#7
# asm 2: addpd <t16=%xmm8,<r16=%xmm6
addpd %xmm8,%xmm6

# qhasm: float6464 r17 *= b11
# asm 1: mulpd <b11=int6464#2,<r17=int6464#8
# asm 2: mulpd <b11=%xmm1,<r17=%xmm7
mulpd %xmm1,%xmm7

# qhasm: *(int128 *)(rp + 96) = r6
# asm 1: movdqa <r6=int6464#10,96(<rp=int64#4)
# asm 2: movdqa <r6=%xmm9,96(<rp=%rcx)
movdqa %xmm9,96(%rcx)

# qhasm: ab7 = *(int128 *)(op1 + 112)
# asm 1: movdqa 112(<op1=int64#2),>ab7=int6464#9
# asm 2: movdqa 112(<op1=%rsi),>ab7=%xmm8
movdqa 112(%rsi),%xmm8

# qhasm: r18 = ab7
# asm 1: movdqa <ab7=int6464#9,>r18=int6464#10
# asm 2: movdqa <ab7=%xmm8,>r18=%xmm9
movdqa %xmm8,%xmm9

# qhasm: float6464 r18 *= sixsix
# asm 1: mulpd <sixsix=int6464#1,<r18=int6464#10
# asm 2: mulpd <sixsix=%xmm0,<r18=%xmm9
mulpd %xmm0,%xmm9

# qhasm: t7 = ab7
# asm 1: movdqa <ab7=int6464#9,>t7=int6464#16
# asm 2: movdqa <ab7=%xmm8,>t7=%xmm15
movdqa %xmm8,%xmm15

# qhasm: float6464 t7 *= *(int128 *)(op2 + 0)
# asm 1: mulpd 0(<op2=int64#3),<t7=int6464#16
# asm 2: mulpd 0(<op2=%rdx),<t7=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r7 +=t7
# asm 1: addpd <t7=int6464#16,<r7=int6464#11
# asm 2: addpd <t7=%xmm15,<r7=%xmm10
addpd %xmm15,%xmm10

# qhasm: float6464 ab7 *= *(int128 *)(op2 + 96)
# asm 1: mulpd 96(<op2=int64#3),<ab7=int6464#9
# asm 2: mulpd 96(<op2=%rdx),<ab7=%xmm8
mulpd 96(%rdx),%xmm8

# qhasm: float6464 r13 +=ab7
# asm 1: addpd <ab7=int6464#9,<r13=int6464#4
# asm 2: addpd <ab7=%xmm8,<r13=%xmm3
addpd %xmm8,%xmm3

# qhasm: t8 = r18
# asm 1: movdqa <r18=int6464#10,>t8=int6464#9
# asm 2: movdqa <r18=%xmm9,>t8=%xmm8
movdqa %xmm9,%xmm8

# qhasm: float6464 t8 *= *(int128 *)(op2 + 16)
# asm 1: mulpd 16(<op2=int64#3),<t8=int6464#9
# asm 2: mulpd 16(<op2=%rdx),<t8=%xmm8
mulpd 16(%rdx),%xmm8

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#9,<r8=int6464#12
# asm 2: addpd <t8=%xmm8,<r8=%xmm11
addpd %xmm8,%xmm11

# qhasm: t9 = r18
# asm 1: movdqa <r18=int6464#10,>t9=int6464#9
# asm 2: movdqa <r18=%xmm9,>t9=%xmm8
movdqa %xmm9,%xmm8

# qhasm: float6464 t9 *= *(int128 *)(op2 + 32)
# asm 1: mulpd 32(<op2=int64#3),<t9=int6464#9
# asm 2: mulpd 32(<op2=%rdx),<t9=%xmm8
mulpd 32(%rdx),%xmm8

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#9,<r9=int6464#13
# asm 2: addpd <t9=%xmm8,<r9=%xmm12
addpd %xmm8,%xmm12

# qhasm: t10 = r18
# asm 1: movdqa <r18=int6464#10,>t10=int6464#9
# asm 2: movdqa <r18=%xmm9,>t10=%xmm8
movdqa %xmm9,%xmm8

# qhasm: float6464 t10 *= *(int128 *)(op2 + 48)
# asm 1: mulpd 48(<op2=int64#3),<t10=int6464#9
# asm 2: mulpd 48(<op2=%rdx),<t10=%xmm8
mulpd 48(%rdx),%xmm8

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#9,<r10=int6464#14
# asm 2: addpd <t10=%xmm8,<r10=%xmm13
addpd %xmm8,%xmm13

# qhasm: t11 = r18
# asm 1: movdqa <r18=int6464#10,>t11=int6464#9
# asm 2: movdqa <r18=%xmm9,>t11=%xmm8
movdqa %xmm9,%xmm8

# qhasm: float6464 t11 *= *(int128 *)(op2 + 64)
# asm 1: mulpd 64(<op2=int64#3),<t11=int6464#9
# asm 2: mulpd 64(<op2=%rdx),<t11=%xmm8
mulpd 64(%rdx),%xmm8

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#9,<r11=int6464#3
# asm 2: addpd <t11=%xmm8,<r11=%xmm2
addpd %xmm8,%xmm2

# qhasm: t12 = r18
# asm 1: movdqa <r18=int6464#10,>t12=int6464#9
# asm 2: movdqa <r18=%xmm9,>t12=%xmm8
movdqa %xmm9,%xmm8

# qhasm: float6464 t12 *= *(int128 *)(op2 + 80)
# asm 1: mulpd 80(<op2=int64#3),<t12=int6464#9
# asm 2: mulpd 80(<op2=%rdx),<t12=%xmm8
mulpd 80(%rdx),%xmm8

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#9,<r12=int6464#15
# asm 2: addpd <t12=%xmm8,<r12=%xmm14
addpd %xmm8,%xmm14

# qhasm: t14 = r18
# asm 1: movdqa <r18=int6464#10,>t14=int6464#9
# asm 2: movdqa <r18=%xmm9,>t14=%xmm8
movdqa %xmm9,%xmm8

# qhasm: float6464 t14 *= *(int128 *)(op2 + 112)
# asm 1: mulpd 112(<op2=int64#3),<t14=int6464#9
# asm 2: mulpd 112(<op2=%rdx),<t14=%xmm8
mulpd 112(%rdx),%xmm8

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#9,<r14=int6464#5
# asm 2: addpd <t14=%xmm8,<r14=%xmm4
addpd %xmm8,%xmm4

# qhasm: t15 = r18
# asm 1: movdqa <r18=int6464#10,>t15=int6464#9
# asm 2: movdqa <r18=%xmm9,>t15=%xmm8
movdqa %xmm9,%xmm8

# qhasm: float6464 t15 *= *(int128 *)(op2 + 128)
# asm 1: mulpd 128(<op2=int64#3),<t15=int6464#9
# asm 2: mulpd 128(<op2=%rdx),<t15=%xmm8
mulpd 128(%rdx),%xmm8

# qhasm: float6464 r15 +=t15
# asm 1: addpd <t15=int6464#9,<r15=int6464#6
# asm 2: addpd <t15=%xmm8,<r15=%xmm5
addpd %xmm8,%xmm5

# qhasm: t16 = r18
# asm 1: movdqa <r18=int6464#10,>t16=int6464#9
# asm 2: movdqa <r18=%xmm9,>t16=%xmm8
movdqa %xmm9,%xmm8

# qhasm: float6464 t16 *= *(int128 *)(op2 + 144)
# asm 1: mulpd 144(<op2=int64#3),<t16=int6464#9
# asm 2: mulpd 144(<op2=%rdx),<t16=%xmm8
mulpd 144(%rdx),%xmm8

# qhasm: float6464 r16 +=t16
# asm 1: addpd <t16=int6464#9,<r16=int6464#7
# asm 2: addpd <t16=%xmm8,<r16=%xmm6
addpd %xmm8,%xmm6

# qhasm: t17 = r18
# asm 1: movdqa <r18=int6464#10,>t17=int6464#9
# asm 2: movdqa <r18=%xmm9,>t17=%xmm8
movdqa %xmm9,%xmm8

# qhasm: float6464 t17 *= *(int128 *)(op2 + 160)
# asm 1: mulpd 160(<op2=int64#3),<t17=int6464#9
# asm 2: mulpd 160(<op2=%rdx),<t17=%xmm8
mulpd 160(%rdx),%xmm8

# qhasm: float6464 r17 +=t17
# asm 1: addpd <t17=int6464#9,<r17=int6464#8
# asm 2: addpd <t17=%xmm8,<r17=%xmm7
addpd %xmm8,%xmm7

# qhasm: float6464 r18 *= b11
# asm 1: mulpd <b11=int6464#2,<r18=int6464#10
# asm 2: mulpd <b11=%xmm1,<r18=%xmm9
mulpd %xmm1,%xmm9

# qhasm: *(int128 *)(rp + 112) = r7
# asm 1: movdqa <r7=int6464#11,112(<rp=int64#4)
# asm 2: movdqa <r7=%xmm10,112(<rp=%rcx)
movdqa %xmm10,112(%rcx)

# qhasm: r19 = *(int128 *)(op1 + 128)
# asm 1: movdqa 128(<op1=int64#2),>r19=int6464#9
# asm 2: movdqa 128(<op1=%rsi),>r19=%xmm8
movdqa 128(%rsi),%xmm8

# qhasm: ab8six = r19
# asm 1: movdqa <r19=int6464#9,>ab8six=int6464#11
# asm 2: movdqa <r19=%xmm8,>ab8six=%xmm10
movdqa %xmm8,%xmm10

# qhasm: float6464 ab8six *= sixsix
# asm 1: mulpd <sixsix=int6464#1,<ab8six=int6464#11
# asm 2: mulpd <sixsix=%xmm0,<ab8six=%xmm10
mulpd %xmm0,%xmm10

# qhasm: t8 = r19
# asm 1: movdqa <r19=int6464#9,>t8=int6464#16
# asm 2: movdqa <r19=%xmm8,>t8=%xmm15
movdqa %xmm8,%xmm15

# qhasm: float6464 t8 *= *(int128 *)(op2 + 0)
# asm 1: mulpd 0(<op2=int64#3),<t8=int6464#16
# asm 2: mulpd 0(<op2=%rdx),<t8=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#16,<r8=int6464#12
# asm 2: addpd <t8=%xmm15,<r8=%xmm11
addpd %xmm15,%xmm11

# qhasm: t13 = r19
# asm 1: movdqa <r19=int6464#9,>t13=int6464#16
# asm 2: movdqa <r19=%xmm8,>t13=%xmm15
movdqa %xmm8,%xmm15

# qhasm: float6464 t13 *= *(int128 *)(op2 + 80)
# asm 1: mulpd 80(<op2=int64#3),<t13=int6464#16
# asm 2: mulpd 80(<op2=%rdx),<t13=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#16,<r13=int6464#4
# asm 2: addpd <t13=%xmm15,<r13=%xmm3
addpd %xmm15,%xmm3

# qhasm: t14 = r19
# asm 1: movdqa <r19=int6464#9,>t14=int6464#16
# asm 2: movdqa <r19=%xmm8,>t14=%xmm15
movdqa %xmm8,%xmm15

# qhasm: float6464 t14 *= *(int128 *)(op2 + 96)
# asm 1: mulpd 96(<op2=int64#3),<t14=int6464#16
# asm 2: mulpd 96(<op2=%rdx),<t14=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#16,<r14=int6464#5
# asm 2: addpd <t14=%xmm15,<r14=%xmm4
addpd %xmm15,%xmm4

# qhasm: float6464 r19 *= b11
# asm 1: mulpd <b11=int6464#2,<r19=int6464#9
# asm 2: mulpd <b11=%xmm1,<r19=%xmm8
mulpd %xmm1,%xmm8

# qhasm: t9 = ab8six
# asm 1: movdqa <ab8six=int6464#11,>t9=int6464#16
# asm 2: movdqa <ab8six=%xmm10,>t9=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t9 *= *(int128 *)(op2 + 16)
# asm 1: mulpd 16(<op2=int64#3),<t9=int6464#16
# asm 2: mulpd 16(<op2=%rdx),<t9=%xmm15
mulpd 16(%rdx),%xmm15

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#16,<r9=int6464#13
# asm 2: addpd <t9=%xmm15,<r9=%xmm12
addpd %xmm15,%xmm12

# qhasm: t10 = ab8six
# asm 1: movdqa <ab8six=int6464#11,>t10=int6464#16
# asm 2: movdqa <ab8six=%xmm10,>t10=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t10 *= *(int128 *)(op2 + 32)
# asm 1: mulpd 32(<op2=int64#3),<t10=int6464#16
# asm 2: mulpd 32(<op2=%rdx),<t10=%xmm15
mulpd 32(%rdx),%xmm15

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#16,<r10=int6464#14
# asm 2: addpd <t10=%xmm15,<r10=%xmm13
addpd %xmm15,%xmm13

# qhasm: t11 = ab8six
# asm 1: movdqa <ab8six=int6464#11,>t11=int6464#16
# asm 2: movdqa <ab8six=%xmm10,>t11=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t11 *= *(int128 *)(op2 + 48)
# asm 1: mulpd 48(<op2=int64#3),<t11=int6464#16
# asm 2: mulpd 48(<op2=%rdx),<t11=%xmm15
mulpd 48(%rdx),%xmm15

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#16,<r11=int6464#3
# asm 2: addpd <t11=%xmm15,<r11=%xmm2
addpd %xmm15,%xmm2

# qhasm: t12 = ab8six
# asm 1: movdqa <ab8six=int6464#11,>t12=int6464#16
# asm 2: movdqa <ab8six=%xmm10,>t12=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t12 *= *(int128 *)(op2 + 64)
# asm 1: mulpd 64(<op2=int64#3),<t12=int6464#16
# asm 2: mulpd 64(<op2=%rdx),<t12=%xmm15
mulpd 64(%rdx),%xmm15

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#16,<r12=int6464#15
# asm 2: addpd <t12=%xmm15,<r12=%xmm14
addpd %xmm15,%xmm14

# qhasm: t15 = ab8six
# asm 1: movdqa <ab8six=int6464#11,>t15=int6464#16
# asm 2: movdqa <ab8six=%xmm10,>t15=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t15 *= *(int128 *)(op2 + 112)
# asm 1: mulpd 112(<op2=int64#3),<t15=int6464#16
# asm 2: mulpd 112(<op2=%rdx),<t15=%xmm15
mulpd 112(%rdx),%xmm15

# qhasm: float6464 r15 +=t15
# asm 1: addpd <t15=int6464#16,<r15=int6464#6
# asm 2: addpd <t15=%xmm15,<r15=%xmm5
addpd %xmm15,%xmm5

# qhasm: t16 = ab8six
# asm 1: movdqa <ab8six=int6464#11,>t16=int6464#16
# asm 2: movdqa <ab8six=%xmm10,>t16=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t16 *= *(int128 *)(op2 + 128)
# asm 1: mulpd 128(<op2=int64#3),<t16=int6464#16
# asm 2: mulpd 128(<op2=%rdx),<t16=%xmm15
mulpd 128(%rdx),%xmm15

# qhasm: float6464 r16 +=t16
# asm 1: addpd <t16=int6464#16,<r16=int6464#7
# asm 2: addpd <t16=%xmm15,<r16=%xmm6
addpd %xmm15,%xmm6

# qhasm: t17 = ab8six
# asm 1: movdqa <ab8six=int6464#11,>t17=int6464#16
# asm 2: movdqa <ab8six=%xmm10,>t17=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t17 *= *(int128 *)(op2 + 144)
# asm 1: mulpd 144(<op2=int64#3),<t17=int6464#16
# asm 2: mulpd 144(<op2=%rdx),<t17=%xmm15
mulpd 144(%rdx),%xmm15

# qhasm: float6464 r17 +=t17
# asm 1: addpd <t17=int6464#16,<r17=int6464#8
# asm 2: addpd <t17=%xmm15,<r17=%xmm7
addpd %xmm15,%xmm7

# qhasm: float6464 ab8six *= *(int128 *)(op2 + 160)
# asm 1: mulpd 160(<op2=int64#3),<ab8six=int6464#11
# asm 2: mulpd 160(<op2=%rdx),<ab8six=%xmm10
mulpd 160(%rdx),%xmm10

# qhasm: float6464 r18 += ab8six
# asm 1: addpd <ab8six=int6464#11,<r18=int6464#10
# asm 2: addpd <ab8six=%xmm10,<r18=%xmm9
addpd %xmm10,%xmm9

# qhasm: *(int128 *)(rp + 128) = r8
# asm 1: movdqa <r8=int6464#12,128(<rp=int64#4)
# asm 2: movdqa <r8=%xmm11,128(<rp=%rcx)
movdqa %xmm11,128(%rcx)

# qhasm: r20 = *(int128 *)(op1 + 144)
# asm 1: movdqa 144(<op1=int64#2),>r20=int6464#11
# asm 2: movdqa 144(<op1=%rsi),>r20=%xmm10
movdqa 144(%rsi),%xmm10

# qhasm: ab9six = r20
# asm 1: movdqa <r20=int6464#11,>ab9six=int6464#12
# asm 2: movdqa <r20=%xmm10,>ab9six=%xmm11
movdqa %xmm10,%xmm11

# qhasm: float6464 ab9six *= sixsix
# asm 1: mulpd <sixsix=int6464#1,<ab9six=int6464#12
# asm 2: mulpd <sixsix=%xmm0,<ab9six=%xmm11
mulpd %xmm0,%xmm11

# qhasm: t9 = r20
# asm 1: movdqa <r20=int6464#11,>t9=int6464#16
# asm 2: movdqa <r20=%xmm10,>t9=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t9 *= *(int128 *)(op2 + 0)
# asm 1: mulpd 0(<op2=int64#3),<t9=int6464#16
# asm 2: mulpd 0(<op2=%rdx),<t9=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#16,<r9=int6464#13
# asm 2: addpd <t9=%xmm15,<r9=%xmm12
addpd %xmm15,%xmm12

# qhasm: t13 = r20
# asm 1: movdqa <r20=int6464#11,>t13=int6464#16
# asm 2: movdqa <r20=%xmm10,>t13=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t13 *= *(int128 *)(op2 + 64)
# asm 1: mulpd 64(<op2=int64#3),<t13=int6464#16
# asm 2: mulpd 64(<op2=%rdx),<t13=%xmm15
mulpd 64(%rdx),%xmm15

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#16,<r13=int6464#4
# asm 2: addpd <t13=%xmm15,<r13=%xmm3
addpd %xmm15,%xmm3

# qhasm: t14 = r20
# asm 1: movdqa <r20=int6464#11,>t14=int6464#16
# asm 2: movdqa <r20=%xmm10,>t14=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t14 *= *(int128 *)(op2 + 80)
# asm 1: mulpd 80(<op2=int64#3),<t14=int6464#16
# asm 2: mulpd 80(<op2=%rdx),<t14=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#16,<r14=int6464#5
# asm 2: addpd <t14=%xmm15,<r14=%xmm4
addpd %xmm15,%xmm4

# qhasm: t15 = r20
# asm 1: movdqa <r20=int6464#11,>t15=int6464#16
# asm 2: movdqa <r20=%xmm10,>t15=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t15 *= *(int128 *)(op2 + 96)
# asm 1: mulpd 96(<op2=int64#3),<t15=int6464#16
# asm 2: mulpd 96(<op2=%rdx),<t15=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r15 +=t15
# asm 1: addpd <t15=int6464#16,<r15=int6464#6
# asm 2: addpd <t15=%xmm15,<r15=%xmm5
addpd %xmm15,%xmm5

# qhasm: t19 = r20
# asm 1: movdqa <r20=int6464#11,>t19=int6464#16
# asm 2: movdqa <r20=%xmm10,>t19=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t19 *= *(int128 *)(op2 + 160)
# asm 1: mulpd 160(<op2=int64#3),<t19=int6464#16
# asm 2: mulpd 160(<op2=%rdx),<t19=%xmm15
mulpd 160(%rdx),%xmm15

# qhasm: float6464 r19 +=t19
# asm 1: addpd <t19=int6464#16,<r19=int6464#9
# asm 2: addpd <t19=%xmm15,<r19=%xmm8
addpd %xmm15,%xmm8

# qhasm: float6464 r20 *= b11
# asm 1: mulpd <b11=int6464#2,<r20=int6464#11
# asm 2: mulpd <b11=%xmm1,<r20=%xmm10
mulpd %xmm1,%xmm10

# qhasm: t10 = ab9six
# asm 1: movdqa <ab9six=int6464#12,>t10=int6464#16
# asm 2: movdqa <ab9six=%xmm11,>t10=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t10 *= *(int128 *)(op2 + 16)
# asm 1: mulpd 16(<op2=int64#3),<t10=int6464#16
# asm 2: mulpd 16(<op2=%rdx),<t10=%xmm15
mulpd 16(%rdx),%xmm15

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#16,<r10=int6464#14
# asm 2: addpd <t10=%xmm15,<r10=%xmm13
addpd %xmm15,%xmm13

# qhasm: t11 = ab9six
# asm 1: movdqa <ab9six=int6464#12,>t11=int6464#16
# asm 2: movdqa <ab9six=%xmm11,>t11=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t11 *= *(int128 *)(op2 + 32)
# asm 1: mulpd 32(<op2=int64#3),<t11=int6464#16
# asm 2: mulpd 32(<op2=%rdx),<t11=%xmm15
mulpd 32(%rdx),%xmm15

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#16,<r11=int6464#3
# asm 2: addpd <t11=%xmm15,<r11=%xmm2
addpd %xmm15,%xmm2

# qhasm: t12 = ab9six
# asm 1: movdqa <ab9six=int6464#12,>t12=int6464#16
# asm 2: movdqa <ab9six=%xmm11,>t12=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t12 *= *(int128 *)(op2 + 48)
# asm 1: mulpd 48(<op2=int64#3),<t12=int6464#16
# asm 2: mulpd 48(<op2=%rdx),<t12=%xmm15
mulpd 48(%rdx),%xmm15

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#16,<r12=int6464#15
# asm 2: addpd <t12=%xmm15,<r12=%xmm14
addpd %xmm15,%xmm14

# qhasm: t16 = ab9six
# asm 1: movdqa <ab9six=int6464#12,>t16=int6464#16
# asm 2: movdqa <ab9six=%xmm11,>t16=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t16 *= *(int128 *)(op2 + 112)
# asm 1: mulpd 112(<op2=int64#3),<t16=int6464#16
# asm 2: mulpd 112(<op2=%rdx),<t16=%xmm15
mulpd 112(%rdx),%xmm15

# qhasm: float6464 r16 +=t16
# asm 1: addpd <t16=int6464#16,<r16=int6464#7
# asm 2: addpd <t16=%xmm15,<r16=%xmm6
addpd %xmm15,%xmm6

# qhasm: t17 = ab9six
# asm 1: movdqa <ab9six=int6464#12,>t17=int6464#16
# asm 2: movdqa <ab9six=%xmm11,>t17=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t17 *= *(int128 *)(op2 + 128)
# asm 1: mulpd 128(<op2=int64#3),<t17=int6464#16
# asm 2: mulpd 128(<op2=%rdx),<t17=%xmm15
mulpd 128(%rdx),%xmm15

# qhasm: float6464 r17 +=t17
# asm 1: addpd <t17=int6464#16,<r17=int6464#8
# asm 2: addpd <t17=%xmm15,<r17=%xmm7
addpd %xmm15,%xmm7

# qhasm: float6464 ab9six *= *(int128 *)(op2 + 144)
# asm 1: mulpd 144(<op2=int64#3),<ab9six=int6464#12
# asm 2: mulpd 144(<op2=%rdx),<ab9six=%xmm11
mulpd 144(%rdx),%xmm11

# qhasm: float6464 r18 +=ab9six
# asm 1: addpd <ab9six=int6464#12,<r18=int6464#10
# asm 2: addpd <ab9six=%xmm11,<r18=%xmm9
addpd %xmm11,%xmm9

# qhasm: *(int128 *)(rp + 144) = r9
# asm 1: movdqa <r9=int6464#13,144(<rp=int64#4)
# asm 2: movdqa <r9=%xmm12,144(<rp=%rcx)
movdqa %xmm12,144(%rcx)

# qhasm: r21 = *(int128 *)(op1 + 160)
# asm 1: movdqa 160(<op1=int64#2),>r21=int6464#12
# asm 2: movdqa 160(<op1=%rsi),>r21=%xmm11
movdqa 160(%rsi),%xmm11

# qhasm: ab10six = r21
# asm 1: movdqa <r21=int6464#12,>ab10six=int6464#13
# asm 2: movdqa <r21=%xmm11,>ab10six=%xmm12
movdqa %xmm11,%xmm12

# qhasm: float6464 ab10six *= sixsix
# asm 1: mulpd <sixsix=int6464#1,<ab10six=int6464#13
# asm 2: mulpd <sixsix=%xmm0,<ab10six=%xmm12
mulpd %xmm0,%xmm12

# qhasm: t10 = r21
# asm 1: movdqa <r21=int6464#12,>t10=int6464#16
# asm 2: movdqa <r21=%xmm11,>t10=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t10 *= *(int128 *)(op2 + 0)
# asm 1: mulpd 0(<op2=int64#3),<t10=int6464#16
# asm 2: mulpd 0(<op2=%rdx),<t10=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#16,<r10=int6464#14
# asm 2: addpd <t10=%xmm15,<r10=%xmm13
addpd %xmm15,%xmm13

# qhasm: t13 = r21
# asm 1: movdqa <r21=int6464#12,>t13=int6464#16
# asm 2: movdqa <r21=%xmm11,>t13=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t13 *= *(int128 *)(op2 + 48)
# asm 1: mulpd 48(<op2=int64#3),<t13=int6464#16
# asm 2: mulpd 48(<op2=%rdx),<t13=%xmm15
mulpd 48(%rdx),%xmm15

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#16,<r13=int6464#4
# asm 2: addpd <t13=%xmm15,<r13=%xmm3
addpd %xmm15,%xmm3

# qhasm: t14 = r21
# asm 1: movdqa <r21=int6464#12,>t14=int6464#16
# asm 2: movdqa <r21=%xmm11,>t14=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t14 *= *(int128 *)(op2 + 64)
# asm 1: mulpd 64(<op2=int64#3),<t14=int6464#16
# asm 2: mulpd 64(<op2=%rdx),<t14=%xmm15
mulpd 64(%rdx),%xmm15

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#16,<r14=int6464#5
# asm 2: addpd <t14=%xmm15,<r14=%xmm4
addpd %xmm15,%xmm4

# qhasm: t16 = r21
# asm 1: movdqa <r21=int6464#12,>t16=int6464#16
# asm 2: movdqa <r21=%xmm11,>t16=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t16 *= *(int128 *)(op2 + 96)
# asm 1: mulpd 96(<op2=int64#3),<t16=int6464#16
# asm 2: mulpd 96(<op2=%rdx),<t16=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r16 +=t16
# asm 1: addpd <t16=int6464#16,<r16=int6464#7
# asm 2: addpd <t16=%xmm15,<r16=%xmm6
addpd %xmm15,%xmm6

# qhasm: t15 = r21
# asm 1: movdqa <r21=int6464#12,>t15=int6464#16
# asm 2: movdqa <r21=%xmm11,>t15=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t15 *= *(int128 *)(op2 + 80)
# asm 1: mulpd 80(<op2=int64#3),<t15=int6464#16
# asm 2: mulpd 80(<op2=%rdx),<t15=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r15 +=t15
# asm 1: addpd <t15=int6464#16,<r15=int6464#6
# asm 2: addpd <t15=%xmm15,<r15=%xmm5
addpd %xmm15,%xmm5

# qhasm: t19 = r21
# asm 1: movdqa <r21=int6464#12,>t19=int6464#16
# asm 2: movdqa <r21=%xmm11,>t19=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t19 *= *(int128 *)(op2 + 144)
# asm 1: mulpd 144(<op2=int64#3),<t19=int6464#16
# asm 2: mulpd 144(<op2=%rdx),<t19=%xmm15
mulpd 144(%rdx),%xmm15

# qhasm: float6464 r19 +=t19
# asm 1: addpd <t19=int6464#16,<r19=int6464#9
# asm 2: addpd <t19=%xmm15,<r19=%xmm8
addpd %xmm15,%xmm8

# qhasm: t20 = r21
# asm 1: movdqa <r21=int6464#12,>t20=int6464#16
# asm 2: movdqa <r21=%xmm11,>t20=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t20 *= *(int128 *)(op2 + 160)
# asm 1: mulpd 160(<op2=int64#3),<t20=int6464#16
# asm 2: mulpd 160(<op2=%rdx),<t20=%xmm15
mulpd 160(%rdx),%xmm15

# qhasm: float6464 r20 +=t20
# asm 1: addpd <t20=int6464#16,<r20=int6464#11
# asm 2: addpd <t20=%xmm15,<r20=%xmm10
addpd %xmm15,%xmm10

# qhasm: float6464 r21 *= b11
# asm 1: mulpd <b11=int6464#2,<r21=int6464#12
# asm 2: mulpd <b11=%xmm1,<r21=%xmm11
mulpd %xmm1,%xmm11

# qhasm: t11 = ab10six
# asm 1: movdqa <ab10six=int6464#13,>t11=int6464#16
# asm 2: movdqa <ab10six=%xmm12,>t11=%xmm15
movdqa %xmm12,%xmm15

# qhasm: float6464 t11 *= *(int128 *)(op2 + 16)
# asm 1: mulpd 16(<op2=int64#3),<t11=int6464#16
# asm 2: mulpd 16(<op2=%rdx),<t11=%xmm15
mulpd 16(%rdx),%xmm15

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#16,<r11=int6464#3
# asm 2: addpd <t11=%xmm15,<r11=%xmm2
addpd %xmm15,%xmm2

# qhasm: t12 = ab10six
# asm 1: movdqa <ab10six=int6464#13,>t12=int6464#16
# asm 2: movdqa <ab10six=%xmm12,>t12=%xmm15
movdqa %xmm12,%xmm15

# qhasm: float6464 t12 *= *(int128 *)(op2 + 32)
# asm 1: mulpd 32(<op2=int64#3),<t12=int6464#16
# asm 2: mulpd 32(<op2=%rdx),<t12=%xmm15
mulpd 32(%rdx),%xmm15

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#16,<r12=int6464#15
# asm 2: addpd <t12=%xmm15,<r12=%xmm14
addpd %xmm15,%xmm14

# qhasm: t17 = ab10six
# asm 1: movdqa <ab10six=int6464#13,>t17=int6464#16
# asm 2: movdqa <ab10six=%xmm12,>t17=%xmm15
movdqa %xmm12,%xmm15

# qhasm: float6464 t17 *= *(int128 *)(op2 + 112)
# asm 1: mulpd 112(<op2=int64#3),<t17=int6464#16
# asm 2: mulpd 112(<op2=%rdx),<t17=%xmm15
mulpd 112(%rdx),%xmm15

# qhasm: float6464 r17 +=t17
# asm 1: addpd <t17=int6464#16,<r17=int6464#8
# asm 2: addpd <t17=%xmm15,<r17=%xmm7
addpd %xmm15,%xmm7

# qhasm: float6464 ab10six *= *(int128 *)(op2 + 128)
# asm 1: mulpd 128(<op2=int64#3),<ab10six=int6464#13
# asm 2: mulpd 128(<op2=%rdx),<ab10six=%xmm12
mulpd 128(%rdx),%xmm12

# qhasm: float6464 r18 +=ab10six
# asm 1: addpd <ab10six=int6464#13,<r18=int6464#10
# asm 2: addpd <ab10six=%xmm12,<r18=%xmm9
addpd %xmm12,%xmm9

# qhasm: *(int128 *)(rp + 160) = r10
# asm 1: movdqa <r10=int6464#14,160(<rp=int64#4)
# asm 2: movdqa <r10=%xmm13,160(<rp=%rcx)
movdqa %xmm13,160(%rcx)

# qhasm: r22 = *(int128 *)(op1 + 176)
# asm 1: movdqa 176(<op1=int64#2),>r22=int6464#13
# asm 2: movdqa 176(<op1=%rsi),>r22=%xmm12
movdqa 176(%rsi),%xmm12

# qhasm: ab11six = r22
# asm 1: movdqa <r22=int6464#13,>ab11six=int6464#14
# asm 2: movdqa <r22=%xmm12,>ab11six=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 ab11six *= sixsix
# asm 1: mulpd <sixsix=int6464#1,<ab11six=int6464#14
# asm 2: mulpd <sixsix=%xmm0,<ab11six=%xmm13
mulpd %xmm0,%xmm13

# qhasm: t11 = r22
# asm 1: movdqa <r22=int6464#13,>t11=int6464#1
# asm 2: movdqa <r22=%xmm12,>t11=%xmm0
movdqa %xmm12,%xmm0

# qhasm: float6464 t11 *= *(int128 *)(op2 + 0)
# asm 1: mulpd 0(<op2=int64#3),<t11=int6464#1
# asm 2: mulpd 0(<op2=%rdx),<t11=%xmm0
mulpd 0(%rdx),%xmm0

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#1,<r11=int6464#3
# asm 2: addpd <t11=%xmm0,<r11=%xmm2
addpd %xmm0,%xmm2

# qhasm: t13 = r22
# asm 1: movdqa <r22=int6464#13,>t13=int6464#1
# asm 2: movdqa <r22=%xmm12,>t13=%xmm0
movdqa %xmm12,%xmm0

# qhasm: float6464 t13 *= *(int128 *)(op2 + 32)
# asm 1: mulpd 32(<op2=int64#3),<t13=int6464#1
# asm 2: mulpd 32(<op2=%rdx),<t13=%xmm0
mulpd 32(%rdx),%xmm0

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#1,<r13=int6464#4
# asm 2: addpd <t13=%xmm0,<r13=%xmm3
addpd %xmm0,%xmm3

# qhasm: t14 = r22
# asm 1: movdqa <r22=int6464#13,>t14=int6464#1
# asm 2: movdqa <r22=%xmm12,>t14=%xmm0
movdqa %xmm12,%xmm0

# qhasm: float6464 t14 *= *(int128 *)(op2 + 48)
# asm 1: mulpd 48(<op2=int64#3),<t14=int6464#1
# asm 2: mulpd 48(<op2=%rdx),<t14=%xmm0
mulpd 48(%rdx),%xmm0

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#1,<r14=int6464#5
# asm 2: addpd <t14=%xmm0,<r14=%xmm4
addpd %xmm0,%xmm4

# qhasm: t15 = r22
# asm 1: movdqa <r22=int6464#13,>t15=int6464#1
# asm 2: movdqa <r22=%xmm12,>t15=%xmm0
movdqa %xmm12,%xmm0

# qhasm: float6464 t15 *= *(int128 *)(op2 + 64)
# asm 1: mulpd 64(<op2=int64#3),<t15=int6464#1
# asm 2: mulpd 64(<op2=%rdx),<t15=%xmm0
mulpd 64(%rdx),%xmm0

# qhasm: float6464 r15 +=t15
# asm 1: addpd <t15=int6464#1,<r15=int6464#6
# asm 2: addpd <t15=%xmm0,<r15=%xmm5
addpd %xmm0,%xmm5

# qhasm: t16 = r22
# asm 1: movdqa <r22=int6464#13,>t16=int6464#1
# asm 2: movdqa <r22=%xmm12,>t16=%xmm0
movdqa %xmm12,%xmm0

# qhasm: float6464 t16 *= *(int128 *)(op2 + 80)
# asm 1: mulpd 80(<op2=int64#3),<t16=int6464#1
# asm 2: mulpd 80(<op2=%rdx),<t16=%xmm0
mulpd 80(%rdx),%xmm0

# qhasm: float6464 r16 +=t16
# asm 1: addpd <t16=int6464#1,<r16=int6464#7
# asm 2: addpd <t16=%xmm0,<r16=%xmm6
addpd %xmm0,%xmm6

# qhasm: t17 = r22
# asm 1: movdqa <r22=int6464#13,>t17=int6464#1
# asm 2: movdqa <r22=%xmm12,>t17=%xmm0
movdqa %xmm12,%xmm0

# qhasm: float6464 t17 *= *(int128 *)(op2 + 96)
# asm 1: mulpd 96(<op2=int64#3),<t17=int6464#1
# asm 2: mulpd 96(<op2=%rdx),<t17=%xmm0
mulpd 96(%rdx),%xmm0

# qhasm: float6464 r17 +=t17
# asm 1: addpd <t17=int6464#1,<r17=int6464#8
# asm 2: addpd <t17=%xmm0,<r17=%xmm7
addpd %xmm0,%xmm7

# qhasm: t19 = r22
# asm 1: movdqa <r22=int6464#13,>t19=int6464#1
# asm 2: movdqa <r22=%xmm12,>t19=%xmm0
movdqa %xmm12,%xmm0

# qhasm: float6464 t19 *= *(int128 *)(op2 + 128)
# asm 1: mulpd 128(<op2=int64#3),<t19=int6464#1
# asm 2: mulpd 128(<op2=%rdx),<t19=%xmm0
mulpd 128(%rdx),%xmm0

# qhasm: float6464 r19 +=t19
# asm 1: addpd <t19=int6464#1,<r19=int6464#9
# asm 2: addpd <t19=%xmm0,<r19=%xmm8
addpd %xmm0,%xmm8

# qhasm: t20 = r22
# asm 1: movdqa <r22=int6464#13,>t20=int6464#1
# asm 2: movdqa <r22=%xmm12,>t20=%xmm0
movdqa %xmm12,%xmm0

# qhasm: float6464 t20 *= *(int128 *)(op2 + 144)
# asm 1: mulpd 144(<op2=int64#3),<t20=int6464#1
# asm 2: mulpd 144(<op2=%rdx),<t20=%xmm0
mulpd 144(%rdx),%xmm0

# qhasm: float6464 r20 +=t20
# asm 1: addpd <t20=int6464#1,<r20=int6464#11
# asm 2: addpd <t20=%xmm0,<r20=%xmm10
addpd %xmm0,%xmm10

# qhasm: t21 = r22
# asm 1: movdqa <r22=int6464#13,>t21=int6464#1
# asm 2: movdqa <r22=%xmm12,>t21=%xmm0
movdqa %xmm12,%xmm0

# qhasm: float6464 t21 *= *(int128 *)(op2 + 160)
# asm 1: mulpd 160(<op2=int64#3),<t21=int6464#1
# asm 2: mulpd 160(<op2=%rdx),<t21=%xmm0
mulpd 160(%rdx),%xmm0

# qhasm: float6464 r21 +=t21
# asm 1: addpd <t21=int6464#1,<r21=int6464#12
# asm 2: addpd <t21=%xmm0,<r21=%xmm11
addpd %xmm0,%xmm11

# qhasm: float6464 r22 *= b11
# asm 1: mulpd <b11=int6464#2,<r22=int6464#13
# asm 2: mulpd <b11=%xmm1,<r22=%xmm12
mulpd %xmm1,%xmm12

# qhasm: t12 = ab11six
# asm 1: movdqa <ab11six=int6464#14,>t12=int6464#1
# asm 2: movdqa <ab11six=%xmm13,>t12=%xmm0
movdqa %xmm13,%xmm0

# qhasm: float6464 t12 *= *(int128 *)(op2 + 16)
# asm 1: mulpd 16(<op2=int64#3),<t12=int6464#1
# asm 2: mulpd 16(<op2=%rdx),<t12=%xmm0
mulpd 16(%rdx),%xmm0

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#1,<r12=int6464#15
# asm 2: addpd <t12=%xmm0,<r12=%xmm14
addpd %xmm0,%xmm14

# qhasm: float6464 ab11six *= *(int128 *)(op2 + 112)
# asm 1: mulpd 112(<op2=int64#3),<ab11six=int6464#14
# asm 2: mulpd 112(<op2=%rdx),<ab11six=%xmm13
mulpd 112(%rdx),%xmm13

# qhasm: float6464 r18 +=ab11six
# asm 1: addpd <ab11six=int6464#14,<r18=int6464#10
# asm 2: addpd <ab11six=%xmm13,<r18=%xmm9
addpd %xmm13,%xmm9

# qhasm: *(int128 *)(rp + 176) = r11
# asm 1: movdqa <r11=int6464#3,176(<rp=int64#4)
# asm 2: movdqa <r11=%xmm2,176(<rp=%rcx)
movdqa %xmm2,176(%rcx)

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

# qhasm: 0r0 = *(int128 *)(rp + 0)
# asm 1: movdqa 0(<rp=int64#4),>0r0=int6464#1
# asm 2: movdqa 0(<rp=%rcx),>0r0=%xmm0
movdqa 0(%rcx),%xmm0

# qhasm: float6464 0r0 -= r12
# asm 1: subpd <r12=int6464#15,<0r0=int6464#1
# asm 2: subpd <r12=%xmm14,<0r0=%xmm0
subpd %xmm14,%xmm0

# qhasm: 0t15 = r15
# asm 1: movdqa <r15=int6464#6,>0t15=int6464#2
# asm 2: movdqa <r15=%xmm5,>0t15=%xmm1
movdqa %xmm5,%xmm1

# qhasm: float6464 0t15 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0t15=int6464#2
# asm 2: mulpd SIX_SIX,<0t15=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r0 += 0t15
# asm 1: addpd <0t15=int6464#2,<0r0=int6464#1
# asm 2: addpd <0t15=%xmm1,<0r0=%xmm0
addpd %xmm1,%xmm0

# qhasm: 0t18 = r18
# asm 1: movdqa <r18=int6464#10,>0t18=int6464#2
# asm 2: movdqa <r18=%xmm9,>0t18=%xmm1
movdqa %xmm9,%xmm1

# qhasm: float6464 0t18 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<0t18=int6464#2
# asm 2: mulpd TWO_TWO,<0t18=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r0 -= 0t18
# asm 1: subpd <0t18=int6464#2,<0r0=int6464#1
# asm 2: subpd <0t18=%xmm1,<0r0=%xmm0
subpd %xmm1,%xmm0

# qhasm: 0t21 = r21
# asm 1: movdqa <r21=int6464#12,>0t21=int6464#2
# asm 2: movdqa <r21=%xmm11,>0t21=%xmm1
movdqa %xmm11,%xmm1

# qhasm: float6464 0t21 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0t21=int6464#2
# asm 2: mulpd SIX_SIX,<0t21=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r0 -= 0t21
# asm 1: subpd <0t21=int6464#2,<0r0=int6464#1
# asm 2: subpd <0t21=%xmm1,<0r0=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(rp + 0) = 0r0
# asm 1: movdqa <0r0=int6464#1,0(<rp=int64#4)
# asm 2: movdqa <0r0=%xmm0,0(<rp=%rcx)
movdqa %xmm0,0(%rcx)

# qhasm: 0r3 = *(int128 *)(rp + 48)
# asm 1: movdqa 48(<rp=int64#4),>0r3=int6464#1
# asm 2: movdqa 48(<rp=%rcx),>0r3=%xmm0
movdqa 48(%rcx),%xmm0

# qhasm: float6464 0r3 -= r12
# asm 1: subpd <r12=int6464#15,<0r3=int6464#1
# asm 2: subpd <r12=%xmm14,<0r3=%xmm0
subpd %xmm14,%xmm0

# qhasm: 0t15 = r15
# asm 1: movdqa <r15=int6464#6,>0t15=int6464#2
# asm 2: movdqa <r15=%xmm5,>0t15=%xmm1
movdqa %xmm5,%xmm1

# qhasm: float6464 0t15 *= FIVE_FIVE
# asm 1: mulpd FIVE_FIVE,<0t15=int6464#2
# asm 2: mulpd FIVE_FIVE,<0t15=%xmm1
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r3 += 0t15
# asm 1: addpd <0t15=int6464#2,<0r3=int6464#1
# asm 2: addpd <0t15=%xmm1,<0r3=%xmm0
addpd %xmm1,%xmm0

# qhasm: float6464 0r3 -= r18
# asm 1: subpd <r18=int6464#10,<0r3=int6464#1
# asm 2: subpd <r18=%xmm9,<0r3=%xmm0
subpd %xmm9,%xmm0

# qhasm: 0t21 = r21
# asm 1: movdqa <r21=int6464#12,>0t21=int6464#2
# asm 2: movdqa <r21=%xmm11,>0t21=%xmm1
movdqa %xmm11,%xmm1

# qhasm: float6464 0t21 *= EIGHT_EIGHT
# asm 1: mulpd EIGHT_EIGHT,<0t21=int6464#2
# asm 2: mulpd EIGHT_EIGHT,<0t21=%xmm1
mov EIGHT_EIGHT@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r3 -= 0t21
# asm 1: subpd <0t21=int6464#2,<0r3=int6464#1
# asm 2: subpd <0t21=%xmm1,<0r3=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(rp + 48) = 0r3
# asm 1: movdqa <0r3=int6464#1,48(<rp=int64#4)
# asm 2: movdqa <0r3=%xmm0,48(<rp=%rcx)
movdqa %xmm0,48(%rcx)

# qhasm: 0r6 = *(int128 *)(rp + 96)
# asm 1: movdqa 96(<rp=int64#4),>0r6=int6464#1
# asm 2: movdqa 96(<rp=%rcx),>0r6=%xmm0
movdqa 96(%rcx),%xmm0

# qhasm: 0t12 = r12
# asm 1: movdqa <r12=int6464#15,>0t12=int6464#2
# asm 2: movdqa <r12=%xmm14,>0t12=%xmm1
movdqa %xmm14,%xmm1

# qhasm: float6464 0t12 *= FOUR_FOUR
# asm 1: mulpd FOUR_FOUR,<0t12=int6464#2
# asm 2: mulpd FOUR_FOUR,<0t12=%xmm1
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r6 -= 0t12
# asm 1: subpd <0t12=int6464#2,<0r6=int6464#1
# asm 2: subpd <0t12=%xmm1,<0r6=%xmm0
subpd %xmm1,%xmm0

# qhasm: 0t15 = r15
# asm 1: movdqa <r15=int6464#6,>0t15=int6464#2
# asm 2: movdqa <r15=%xmm5,>0t15=%xmm1
movdqa %xmm5,%xmm1

# qhasm: float6464 0t15 *= EIGHTEEN_EIGHTEEN
# asm 1: mulpd EIGHTEEN_EIGHTEEN,<0t15=int6464#2
# asm 2: mulpd EIGHTEEN_EIGHTEEN,<0t15=%xmm1
mov EIGHTEEN_EIGHTEEN@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r6 += 0t15
# asm 1: addpd <0t15=int6464#2,<0r6=int6464#1
# asm 2: addpd <0t15=%xmm1,<0r6=%xmm0
addpd %xmm1,%xmm0

# qhasm: 0t18 = r18
# asm 1: movdqa <r18=int6464#10,>0t18=int6464#2
# asm 2: movdqa <r18=%xmm9,>0t18=%xmm1
movdqa %xmm9,%xmm1

# qhasm: float6464 0t18 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<0t18=int6464#2
# asm 2: mulpd THREE_THREE,<0t18=%xmm1
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r6 -= 0t18
# asm 1: subpd <0t18=int6464#2,<0r6=int6464#1
# asm 2: subpd <0t18=%xmm1,<0r6=%xmm0
subpd %xmm1,%xmm0

# qhasm: 0t21 = r21
# asm 1: movdqa <r21=int6464#12,>0t21=int6464#2
# asm 2: movdqa <r21=%xmm11,>0t21=%xmm1
movdqa %xmm11,%xmm1

# qhasm: float6464 0t21 *= THIRTY_THIRTY
# asm 1: mulpd THIRTY_THIRTY,<0t21=int6464#2
# asm 2: mulpd THIRTY_THIRTY,<0t21=%xmm1
mov THIRTY_THIRTY@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r6 -= 0t21
# asm 1: subpd <0t21=int6464#2,<0r6=int6464#1
# asm 2: subpd <0t21=%xmm1,<0r6=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(rp + 96) = 0r6
# asm 1: movdqa <0r6=int6464#1,96(<rp=int64#4)
# asm 2: movdqa <0r6=%xmm0,96(<rp=%rcx)
movdqa %xmm0,96(%rcx)

# qhasm: 0r9 = *(int128 *)(rp + 144)
# asm 1: movdqa 144(<rp=int64#4),>0r9=int6464#1
# asm 2: movdqa 144(<rp=%rcx),>0r9=%xmm0
movdqa 144(%rcx),%xmm0

# qhasm: float6464 0r9 -= r12
# asm 1: subpd <r12=int6464#15,<0r9=int6464#1
# asm 2: subpd <r12=%xmm14,<0r9=%xmm0
subpd %xmm14,%xmm0

# qhasm: 0t15 = r15
# asm 1: movdqa <r15=int6464#6,>0t15=int6464#2
# asm 2: movdqa <r15=%xmm5,>0t15=%xmm1
movdqa %xmm5,%xmm1

# qhasm: float6464 0t15 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<0t15=int6464#2
# asm 2: mulpd TWO_TWO,<0t15=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r9 += 0t15
# asm 1: addpd <0t15=int6464#2,<0r9=int6464#1
# asm 2: addpd <0t15=%xmm1,<0r9=%xmm0
addpd %xmm1,%xmm0

# qhasm: float6464 0r9 += r18
# asm 1: addpd <r18=int6464#10,<0r9=int6464#1
# asm 2: addpd <r18=%xmm9,<0r9=%xmm0
addpd %xmm9,%xmm0

# qhasm: 0t21 = r21
# asm 1: movdqa <r21=int6464#12,>0t21=int6464#2
# asm 2: movdqa <r21=%xmm11,>0t21=%xmm1
movdqa %xmm11,%xmm1

# qhasm: float6464 0t21 *= NINE_NINE
# asm 1: mulpd NINE_NINE,<0t21=int6464#2
# asm 2: mulpd NINE_NINE,<0t21=%xmm1
mov NINE_NINE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r9 -= 0t21
# asm 1: subpd <0t21=int6464#2,<0r9=int6464#1
# asm 2: subpd <0t21=%xmm1,<0r9=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(rp + 144) = 0r9
# asm 1: movdqa <0r9=int6464#1,144(<rp=int64#4)
# asm 2: movdqa <0r9=%xmm0,144(<rp=%rcx)
movdqa %xmm0,144(%rcx)

# qhasm: 0r1 = *(int128 *)(rp + 16)
# asm 1: movdqa 16(<rp=int64#4),>0r1=int6464#1
# asm 2: movdqa 16(<rp=%rcx),>0r1=%xmm0
movdqa 16(%rcx),%xmm0

# qhasm: float6464 0r1 -= r13
# asm 1: subpd <r13=int6464#4,<0r1=int6464#1
# asm 2: subpd <r13=%xmm3,<0r1=%xmm0
subpd %xmm3,%xmm0

# qhasm: float6464 0r1 += r16
# asm 1: addpd <r16=int6464#7,<0r1=int6464#1
# asm 2: addpd <r16=%xmm6,<0r1=%xmm0
addpd %xmm6,%xmm0

# qhasm: 0t19 = r19
# asm 1: movdqa <r19=int6464#9,>0t19=int6464#2
# asm 2: movdqa <r19=%xmm8,>0t19=%xmm1
movdqa %xmm8,%xmm1

# qhasm: float6464 0t19 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<0t19=int6464#2
# asm 2: mulpd TWO_TWO,<0t19=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r1 -= 0t19
# asm 1: subpd <0t19=int6464#2,<0r1=int6464#1
# asm 2: subpd <0t19=%xmm1,<0r1=%xmm0
subpd %xmm1,%xmm0

# qhasm: float6464 0r1 -= r22
# asm 1: subpd <r22=int6464#13,<0r1=int6464#1
# asm 2: subpd <r22=%xmm12,<0r1=%xmm0
subpd %xmm12,%xmm0

# qhasm: *(int128 *)(rp + 16) = 0r1
# asm 1: movdqa <0r1=int6464#1,16(<rp=int64#4)
# asm 2: movdqa <0r1=%xmm0,16(<rp=%rcx)
movdqa %xmm0,16(%rcx)

# qhasm: 0r4 = *(int128 *)(rp + 64)
# asm 1: movdqa 64(<rp=int64#4),>0r4=int6464#1
# asm 2: movdqa 64(<rp=%rcx),>0r4=%xmm0
movdqa 64(%rcx),%xmm0

# qhasm: 0t13 = r13
# asm 1: movdqa <r13=int6464#4,>0t13=int6464#2
# asm 2: movdqa <r13=%xmm3,>0t13=%xmm1
movdqa %xmm3,%xmm1

# qhasm: float6464 0t13 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0t13=int6464#2
# asm 2: mulpd SIX_SIX,<0t13=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r4 -= 0t13
# asm 1: subpd <0t13=int6464#2,<0r4=int6464#1
# asm 2: subpd <0t13=%xmm1,<0r4=%xmm0
subpd %xmm1,%xmm0

# qhasm: 0t16 = r16
# asm 1: movdqa <r16=int6464#7,>0t16=int6464#2
# asm 2: movdqa <r16=%xmm6,>0t16=%xmm1
movdqa %xmm6,%xmm1

# qhasm: float6464 0t16 *= FIVE_FIVE
# asm 1: mulpd FIVE_FIVE,<0t16=int6464#2
# asm 2: mulpd FIVE_FIVE,<0t16=%xmm1
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r4 += 0t16
# asm 1: addpd <0t16=int6464#2,<0r4=int6464#1
# asm 2: addpd <0t16=%xmm1,<0r4=%xmm0
addpd %xmm1,%xmm0

# qhasm: 0t19 = r19
# asm 1: movdqa <r19=int6464#9,>0t19=int6464#2
# asm 2: movdqa <r19=%xmm8,>0t19=%xmm1
movdqa %xmm8,%xmm1

# qhasm: float6464 0t19 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0t19=int6464#2
# asm 2: mulpd SIX_SIX,<0t19=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r4 -= 0t19
# asm 1: subpd <0t19=int6464#2,<0r4=int6464#1
# asm 2: subpd <0t19=%xmm1,<0r4=%xmm0
subpd %xmm1,%xmm0

# qhasm: 0t22 = r22
# asm 1: movdqa <r22=int6464#13,>0t22=int6464#2
# asm 2: movdqa <r22=%xmm12,>0t22=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t22 *= EIGHT_EIGHT
# asm 1: mulpd EIGHT_EIGHT,<0t22=int6464#2
# asm 2: mulpd EIGHT_EIGHT,<0t22=%xmm1
mov EIGHT_EIGHT@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r4 -= 0t22
# asm 1: subpd <0t22=int6464#2,<0r4=int6464#1
# asm 2: subpd <0t22=%xmm1,<0r4=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(rp + 64) = 0r4
# asm 1: movdqa <0r4=int6464#1,64(<rp=int64#4)
# asm 2: movdqa <0r4=%xmm0,64(<rp=%rcx)
movdqa %xmm0,64(%rcx)

# qhasm: 0r7 = *(int128 *)(rp + 112)
# asm 1: movdqa 112(<rp=int64#4),>0r7=int6464#1
# asm 2: movdqa 112(<rp=%rcx),>0r7=%xmm0
movdqa 112(%rcx),%xmm0

# qhasm: 0t13 = r13
# asm 1: movdqa <r13=int6464#4,>0t13=int6464#2
# asm 2: movdqa <r13=%xmm3,>0t13=%xmm1
movdqa %xmm3,%xmm1

# qhasm: float6464 0t13 *= FOUR_FOUR
# asm 1: mulpd FOUR_FOUR,<0t13=int6464#2
# asm 2: mulpd FOUR_FOUR,<0t13=%xmm1
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r7 -= 0t13
# asm 1: subpd <0t13=int6464#2,<0r7=int6464#1
# asm 2: subpd <0t13=%xmm1,<0r7=%xmm0
subpd %xmm1,%xmm0

# qhasm: 0t16 = r16
# asm 1: movdqa <r16=int6464#7,>0t16=int6464#2
# asm 2: movdqa <r16=%xmm6,>0t16=%xmm1
movdqa %xmm6,%xmm1

# qhasm: float6464 0t16 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<0t16=int6464#2
# asm 2: mulpd THREE_THREE,<0t16=%xmm1
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r7 += 0t16
# asm 1: addpd <0t16=int6464#2,<0r7=int6464#1
# asm 2: addpd <0t16=%xmm1,<0r7=%xmm0
addpd %xmm1,%xmm0

# qhasm: 0t19 = r19
# asm 1: movdqa <r19=int6464#9,>0t19=int6464#2
# asm 2: movdqa <r19=%xmm8,>0t19=%xmm1
movdqa %xmm8,%xmm1

# qhasm: float6464 0t19 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<0t19=int6464#2
# asm 2: mulpd THREE_THREE,<0t19=%xmm1
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r7 -= 0t19
# asm 1: subpd <0t19=int6464#2,<0r7=int6464#1
# asm 2: subpd <0t19=%xmm1,<0r7=%xmm0
subpd %xmm1,%xmm0

# qhasm: 0t22 = r22
# asm 1: movdqa <r22=int6464#13,>0t22=int6464#2
# asm 2: movdqa <r22=%xmm12,>0t22=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t22 *= FIVE_FIVE
# asm 1: mulpd FIVE_FIVE,<0t22=int6464#2
# asm 2: mulpd FIVE_FIVE,<0t22=%xmm1
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r7 -= 0t22
# asm 1: subpd <0t22=int6464#2,<0r7=int6464#1
# asm 2: subpd <0t22=%xmm1,<0r7=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(rp + 112) = 0r7
# asm 1: movdqa <0r7=int6464#1,112(<rp=int64#4)
# asm 2: movdqa <0r7=%xmm0,112(<rp=%rcx)
movdqa %xmm0,112(%rcx)

# qhasm: 0r10 = *(int128 *)(rp + 160)
# asm 1: movdqa 160(<rp=int64#4),>0r10=int6464#1
# asm 2: movdqa 160(<rp=%rcx),>0r10=%xmm0
movdqa 160(%rcx),%xmm0

# qhasm: 0t13 = r13
# asm 1: movdqa <r13=int6464#4,>0t13=int6464#2
# asm 2: movdqa <r13=%xmm3,>0t13=%xmm1
movdqa %xmm3,%xmm1

# qhasm: float6464 0t13 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0t13=int6464#2
# asm 2: mulpd SIX_SIX,<0t13=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r10 -= 0t13
# asm 1: subpd <0t13=int6464#2,<0r10=int6464#1
# asm 2: subpd <0t13=%xmm1,<0r10=%xmm0
subpd %xmm1,%xmm0

# qhasm: 0t16 = r16
# asm 1: movdqa <r16=int6464#7,>0t16=int6464#2
# asm 2: movdqa <r16=%xmm6,>0t16=%xmm1
movdqa %xmm6,%xmm1

# qhasm: float6464 0t16 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<0t16=int6464#2
# asm 2: mulpd TWO_TWO,<0t16=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r10 += 0t16
# asm 1: addpd <0t16=int6464#2,<0r10=int6464#1
# asm 2: addpd <0t16=%xmm1,<0r10=%xmm0
addpd %xmm1,%xmm0

# qhasm: 0t19 = r19
# asm 1: movdqa <r19=int6464#9,>0t19=int6464#2
# asm 2: movdqa <r19=%xmm8,>0t19=%xmm1
movdqa %xmm8,%xmm1

# qhasm: float6464 0t19 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0t19=int6464#2
# asm 2: mulpd SIX_SIX,<0t19=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r10 += 0t19
# asm 1: addpd <0t19=int6464#2,<0r10=int6464#1
# asm 2: addpd <0t19=%xmm1,<0r10=%xmm0
addpd %xmm1,%xmm0

# qhasm: 0t22 = r22
# asm 1: movdqa <r22=int6464#13,>0t22=int6464#2
# asm 2: movdqa <r22=%xmm12,>0t22=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 0t22 *= NINE_NINE
# asm 1: mulpd NINE_NINE,<0t22=int6464#2
# asm 2: mulpd NINE_NINE,<0t22=%xmm1
mov NINE_NINE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r10 -= 0t22
# asm 1: subpd <0t22=int6464#2,<0r10=int6464#1
# asm 2: subpd <0t22=%xmm1,<0r10=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(rp + 160) = 0r10
# asm 1: movdqa <0r10=int6464#1,160(<rp=int64#4)
# asm 2: movdqa <0r10=%xmm0,160(<rp=%rcx)
movdqa %xmm0,160(%rcx)

# qhasm: 0r2 = *(int128 *)(rp + 32)
# asm 1: movdqa 32(<rp=int64#4),>0r2=int6464#1
# asm 2: movdqa 32(<rp=%rcx),>0r2=%xmm0
movdqa 32(%rcx),%xmm0

# qhasm: float6464 0r2 -= r14
# asm 1: subpd <r14=int6464#5,<0r2=int6464#1
# asm 2: subpd <r14=%xmm4,<0r2=%xmm0
subpd %xmm4,%xmm0

# qhasm: float6464 0r2 += r17
# asm 1: addpd <r17=int6464#8,<0r2=int6464#1
# asm 2: addpd <r17=%xmm7,<0r2=%xmm0
addpd %xmm7,%xmm0

# qhasm: 0t20 = r20
# asm 1: movdqa <r20=int6464#11,>0t20=int6464#2
# asm 2: movdqa <r20=%xmm10,>0t20=%xmm1
movdqa %xmm10,%xmm1

# qhasm: float6464 0t20 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<0t20=int6464#2
# asm 2: mulpd TWO_TWO,<0t20=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r2 -= 0t20
# asm 1: subpd <0t20=int6464#2,<0r2=int6464#1
# asm 2: subpd <0t20=%xmm1,<0r2=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(rp + 32) = 0r2
# asm 1: movdqa <0r2=int6464#1,32(<rp=int64#4)
# asm 2: movdqa <0r2=%xmm0,32(<rp=%rcx)
movdqa %xmm0,32(%rcx)

# qhasm: 0r5 = *(int128 *)(rp + 80)
# asm 1: movdqa 80(<rp=int64#4),>0r5=int6464#1
# asm 2: movdqa 80(<rp=%rcx),>0r5=%xmm0
movdqa 80(%rcx),%xmm0

# qhasm: 0t14 = r14
# asm 1: movdqa <r14=int6464#5,>0t14=int6464#2
# asm 2: movdqa <r14=%xmm4,>0t14=%xmm1
movdqa %xmm4,%xmm1

# qhasm: float6464 0t14 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0t14=int6464#2
# asm 2: mulpd SIX_SIX,<0t14=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r5 -= 0t14
# asm 1: subpd <0t14=int6464#2,<0r5=int6464#1
# asm 2: subpd <0t14=%xmm1,<0r5=%xmm0
subpd %xmm1,%xmm0

# qhasm: 0t17 = r17
# asm 1: movdqa <r17=int6464#8,>0t17=int6464#2
# asm 2: movdqa <r17=%xmm7,>0t17=%xmm1
movdqa %xmm7,%xmm1

# qhasm: float6464 0t17 *= FIVE_FIVE
# asm 1: mulpd FIVE_FIVE,<0t17=int6464#2
# asm 2: mulpd FIVE_FIVE,<0t17=%xmm1
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r5 += 0t17
# asm 1: addpd <0t17=int6464#2,<0r5=int6464#1
# asm 2: addpd <0t17=%xmm1,<0r5=%xmm0
addpd %xmm1,%xmm0

# qhasm: 0t20 = r20
# asm 1: movdqa <r20=int6464#11,>0t20=int6464#2
# asm 2: movdqa <r20=%xmm10,>0t20=%xmm1
movdqa %xmm10,%xmm1

# qhasm: float6464 0t20 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0t20=int6464#2
# asm 2: mulpd SIX_SIX,<0t20=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r5 -= 0t20
# asm 1: subpd <0t20=int6464#2,<0r5=int6464#1
# asm 2: subpd <0t20=%xmm1,<0r5=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(rp + 80) = 0r5
# asm 1: movdqa <0r5=int6464#1,80(<rp=int64#4)
# asm 2: movdqa <0r5=%xmm0,80(<rp=%rcx)
movdqa %xmm0,80(%rcx)

# qhasm: 0r8 = *(int128 *)(rp + 128)
# asm 1: movdqa 128(<rp=int64#4),>0r8=int6464#1
# asm 2: movdqa 128(<rp=%rcx),>0r8=%xmm0
movdqa 128(%rcx),%xmm0

# qhasm: 0t14 = r14
# asm 1: movdqa <r14=int6464#5,>0t14=int6464#2
# asm 2: movdqa <r14=%xmm4,>0t14=%xmm1
movdqa %xmm4,%xmm1

# qhasm: float6464 0t14 *= FOUR_FOUR
# asm 1: mulpd FOUR_FOUR,<0t14=int6464#2
# asm 2: mulpd FOUR_FOUR,<0t14=%xmm1
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r8 -= 0t14
# asm 1: subpd <0t14=int6464#2,<0r8=int6464#1
# asm 2: subpd <0t14=%xmm1,<0r8=%xmm0
subpd %xmm1,%xmm0

# qhasm: 0t17 = r17
# asm 1: movdqa <r17=int6464#8,>0t17=int6464#2
# asm 2: movdqa <r17=%xmm7,>0t17=%xmm1
movdqa %xmm7,%xmm1

# qhasm: float6464 0t17 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<0t17=int6464#2
# asm 2: mulpd THREE_THREE,<0t17=%xmm1
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r8 += 0t17
# asm 1: addpd <0t17=int6464#2,<0r8=int6464#1
# asm 2: addpd <0t17=%xmm1,<0r8=%xmm0
addpd %xmm1,%xmm0

# qhasm: 0t20 = r20
# asm 1: movdqa <r20=int6464#11,>0t20=int6464#2
# asm 2: movdqa <r20=%xmm10,>0t20=%xmm1
movdqa %xmm10,%xmm1

# qhasm: float6464 0t20 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<0t20=int6464#2
# asm 2: mulpd THREE_THREE,<0t20=%xmm1
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r8 -= 0t20
# asm 1: subpd <0t20=int6464#2,<0r8=int6464#1
# asm 2: subpd <0t20=%xmm1,<0r8=%xmm0
subpd %xmm1,%xmm0

# qhasm: *(int128 *)(rp + 128) = 0r8
# asm 1: movdqa <0r8=int6464#1,128(<rp=int64#4)
# asm 2: movdqa <0r8=%xmm0,128(<rp=%rcx)
movdqa %xmm0,128(%rcx)

# qhasm: 0r11 = *(int128 *)(rp + 176)
# asm 1: movdqa 176(<rp=int64#4),>0r11=int6464#1
# asm 2: movdqa 176(<rp=%rcx),>0r11=%xmm0
movdqa 176(%rcx),%xmm0

# qhasm: 0t14 = r14
# asm 1: movdqa <r14=int6464#5,>0t14=int6464#2
# asm 2: movdqa <r14=%xmm4,>0t14=%xmm1
movdqa %xmm4,%xmm1

# qhasm: float6464 0t14 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0t14=int6464#2
# asm 2: mulpd SIX_SIX,<0t14=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r11 -= 0t14
# asm 1: subpd <0t14=int6464#2,<0r11=int6464#1
# asm 2: subpd <0t14=%xmm1,<0r11=%xmm0
subpd %xmm1,%xmm0

# qhasm: 0t17 = r17
# asm 1: movdqa <r17=int6464#8,>0t17=int6464#2
# asm 2: movdqa <r17=%xmm7,>0t17=%xmm1
movdqa %xmm7,%xmm1

# qhasm: float6464 0t17 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<0t17=int6464#2
# asm 2: mulpd TWO_TWO,<0t17=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r11 += 0t17
# asm 1: addpd <0t17=int6464#2,<0r11=int6464#1
# asm 2: addpd <0t17=%xmm1,<0r11=%xmm0
addpd %xmm1,%xmm0

# qhasm: 0t20 = r20
# asm 1: movdqa <r20=int6464#11,>0t20=int6464#2
# asm 2: movdqa <r20=%xmm10,>0t20=%xmm1
movdqa %xmm10,%xmm1

# qhasm: float6464 0t20 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<0t20=int6464#2
# asm 2: mulpd SIX_SIX,<0t20=%xmm1
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 0r11 += 0t20
# asm 1: addpd <0t20=int6464#2,<0r11=int6464#1
# asm 2: addpd <0t20=%xmm1,<0r11=%xmm0
addpd %xmm1,%xmm0

# qhasm: *(int128 *)(rp + 176) = 0r11
# asm 1: movdqa <0r11=int6464#1,176(<rp=int64#4)
# asm 2: movdqa <0r11=%xmm0,176(<rp=%rcx)
movdqa %xmm0,176(%rcx)

# qhasm: int6464 0round

# qhasm: int6464 0carry

# qhasm: int6464 1t6

# qhasm: r0 = *(int128 *)(rp + 0)
# asm 1: movdqa 0(<rp=int64#4),>r0=int6464#1
# asm 2: movdqa 0(<rp=%rcx),>r0=%xmm0
movdqa 0(%rcx),%xmm0

# qhasm: r1 = *(int128 *)(rp + 16)
# asm 1: movdqa 16(<rp=int64#4),>r1=int6464#2
# asm 2: movdqa 16(<rp=%rcx),>r1=%xmm1
movdqa 16(%rcx),%xmm1

# qhasm: r2 = *(int128 *)(rp + 32)
# asm 1: movdqa 32(<rp=int64#4),>r2=int6464#3
# asm 2: movdqa 32(<rp=%rcx),>r2=%xmm2
movdqa 32(%rcx),%xmm2

# qhasm: r3 = *(int128 *)(rp + 48)
# asm 1: movdqa 48(<rp=int64#4),>r3=int6464#4
# asm 2: movdqa 48(<rp=%rcx),>r3=%xmm3
movdqa 48(%rcx),%xmm3

# qhasm: r4 = *(int128 *)(rp + 64)
# asm 1: movdqa 64(<rp=int64#4),>r4=int6464#5
# asm 2: movdqa 64(<rp=%rcx),>r4=%xmm4
movdqa 64(%rcx),%xmm4

# qhasm: r5 = *(int128 *)(rp + 80)
# asm 1: movdqa 80(<rp=int64#4),>r5=int6464#6
# asm 2: movdqa 80(<rp=%rcx),>r5=%xmm5
movdqa 80(%rcx),%xmm5

# qhasm: r6 = *(int128 *)(rp + 96)
# asm 1: movdqa 96(<rp=int64#4),>r6=int6464#7
# asm 2: movdqa 96(<rp=%rcx),>r6=%xmm6
movdqa 96(%rcx),%xmm6

# qhasm: r7 = *(int128 *)(rp + 112)
# asm 1: movdqa 112(<rp=int64#4),>r7=int6464#8
# asm 2: movdqa 112(<rp=%rcx),>r7=%xmm7
movdqa 112(%rcx),%xmm7

# qhasm: r8 = *(int128 *)(rp + 128)
# asm 1: movdqa 128(<rp=int64#4),>r8=int6464#9
# asm 2: movdqa 128(<rp=%rcx),>r8=%xmm8
movdqa 128(%rcx),%xmm8

# qhasm: r9 = *(int128 *)(rp + 144)
# asm 1: movdqa 144(<rp=int64#4),>r9=int6464#10
# asm 2: movdqa 144(<rp=%rcx),>r9=%xmm9
movdqa 144(%rcx),%xmm9

# qhasm: r10 = *(int128 *)(rp + 160)
# asm 1: movdqa 160(<rp=int64#4),>r10=int6464#11
# asm 2: movdqa 160(<rp=%rcx),>r10=%xmm10
movdqa 160(%rcx),%xmm10

# qhasm: r11 = *(int128 *)(rp + 176)
# asm 1: movdqa 176(<rp=int64#4),>r11=int6464#12
# asm 2: movdqa 176(<rp=%rcx),>r11=%xmm11
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

# qhasm: 1t6 = 0carry
# asm 1: movdqa <0carry=int6464#14,>1t6=int6464#15
# asm 2: movdqa <0carry=%xmm13,>1t6=%xmm14
movdqa %xmm13,%xmm14

# qhasm: float6464 1t6 *= FOUR_FOUR
# asm 1: mulpd FOUR_FOUR,<1t6=int6464#15
# asm 2: mulpd FOUR_FOUR,<1t6=%xmm14
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: float6464 r6 -= 1t6
# asm 1: subpd <1t6=int6464#15,<r6=int6464#7
# asm 2: subpd <1t6=%xmm14,<r6=%xmm6
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
