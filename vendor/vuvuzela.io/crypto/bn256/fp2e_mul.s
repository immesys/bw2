# File:   dclxvi-20130329/fp2e_mul.s
# Author: Ruben Niederhagen, Peter Schwabe
# Public Domain


# qhasm: int64 rop

# qhasm: int64 op1

# qhasm: int64 b2a2p

# qhasm: input rop

# qhasm: input op1

# qhasm: input b2a2p

# qhasm: stack7680 mystack

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

# qhasm: int6464 d0

# qhasm: int6464 d1

# qhasm: int6464 d2

# qhasm: int6464 d3

# qhasm: int6464 d4

# qhasm: int6464 d5

# qhasm: int6464 d6

# qhasm: int6464 d7

# qhasm: int6464 d8

# qhasm: int6464 d9

# qhasm: int6464 d10

# qhasm: int6464 d11

# qhasm: int6464 d12

# qhasm: int6464 d13

# qhasm: int6464 d14

# qhasm: int6464 d15

# qhasm: int6464 d16

# qhasm: int6464 d17

# qhasm: int6464 d18

# qhasm: int6464 d19

# qhasm: int6464 d20

# qhasm: int6464 d21

# qhasm: int6464 d22

# qhasm: int6464 ab0

# qhasm: int6464 ab1

# qhasm: int6464 ab2

# qhasm: int6464 ab3

# qhasm: int6464 ab4

# qhasm: int6464 ab5

# qhasm: int6464 ab6

# qhasm: int6464 ab7

# qhasm: int6464 ab8

# qhasm: int6464 ab9

# qhasm: int6464 ab10

# qhasm: int6464 ab11

# qhasm: int6464 ab0six

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

# qhasm: int6464 cd0

# qhasm: int6464 cd1

# qhasm: int6464 cd2

# qhasm: int6464 cd3

# qhasm: int6464 cd4

# qhasm: int6464 cd5

# qhasm: int6464 cd6

# qhasm: int6464 cd7

# qhasm: int6464 cd8

# qhasm: int6464 cd9

# qhasm: int6464 cd10

# qhasm: int6464 cd11

# qhasm: int6464 cd0six

# qhasm: int6464 cd1six

# qhasm: int6464 cd2six

# qhasm: int6464 cd3six

# qhasm: int6464 cd4six

# qhasm: int6464 cd5six

# qhasm: int6464 cd6six

# qhasm: int6464 cd7six

# qhasm: int6464 cd8six

# qhasm: int6464 cd9six

# qhasm: int6464 cd10six

# qhasm: int6464 cd11six

# qhasm: int6464 round

# qhasm: int6464 carry

# qhasm: int64 b1b1p

# qhasm: int64 ma1a1p

# qhasm: int64 a2b2p

# qhasm: int64 sixa2b2p

# qhasm: int64 sixb2a2p

# qhasm: enter fp2e_mul_qhasm
.text
.p2align 5
.globl _fp2e_mul_qhasm
.globl fp2e_mul_qhasm
_fp2e_mul_qhasm:
fp2e_mul_qhasm:
push %rbp
mov %rsp,%r11
and $31,%r11
add $960,%r11
sub %r11,%rsp

# qhasm: b1b1p = &mystack
# asm 1: leaq <mystack=stack7680#1,>b1b1p=int64#4
# asm 2: leaq <mystack=0(%rsp),>b1b1p=%rcx
leaq 0(%rsp),%rcx

# qhasm: ma1a1p = b1b1p + 192
# asm 1: lea  192(<b1b1p=int64#4),>ma1a1p=int64#5
# asm 2: lea  192(<b1b1p=%rcx),>ma1a1p=%r8
lea  192(%rcx),%r8

# qhasm: a2b2p = b1b1p + 384
# asm 1: lea  384(<b1b1p=int64#4),>a2b2p=int64#6
# asm 2: lea  384(<b1b1p=%rcx),>a2b2p=%r9
lea  384(%rcx),%r9

# qhasm: sixa2b2p = b1b1p + 576
# asm 1: lea  576(<b1b1p=int64#4),>sixa2b2p=int64#7
# asm 2: lea  576(<b1b1p=%rcx),>sixa2b2p=%rax
lea  576(%rcx),%rax

# qhasm: sixb2a2p = b1b1p + 768
# asm 1: lea  768(<b1b1p=int64#4),>sixb2a2p=int64#8
# asm 2: lea  768(<b1b1p=%rcx),>sixb2a2p=%r10
lea  768(%rcx),%r10

# qhasm: t0 = *(int128 *)(b2a2p + 0)
# asm 1: movdqa 0(<b2a2p=int64#3),>t0=int6464#1
# asm 2: movdqa 0(<b2a2p=%rdx),>t0=%xmm0
movdqa 0(%rdx),%xmm0

# qhasm: t0 = shuffle float64 of t0 and t0 by 0x1
# asm 1: shufpd $0x1,<t0=int6464#1,<t0=int6464#1
# asm 2: shufpd $0x1,<t0=%xmm0,<t0=%xmm0
shufpd $0x1,%xmm0,%xmm0

# qhasm: *(int128 *)(a2b2p + 0) = t0
# asm 1: movdqa <t0=int6464#1,0(<a2b2p=int64#6)
# asm 2: movdqa <t0=%xmm0,0(<a2b2p=%r9)
movdqa %xmm0,0(%r9)

# qhasm: t1 = *(int128 *)(b2a2p + 16)
# asm 1: movdqa 16(<b2a2p=int64#3),>t1=int6464#1
# asm 2: movdqa 16(<b2a2p=%rdx),>t1=%xmm0
movdqa 16(%rdx),%xmm0

# qhasm: t1 = shuffle float64 of t1 and t1 by 0x1
# asm 1: shufpd $0x1,<t1=int6464#1,<t1=int6464#1
# asm 2: shufpd $0x1,<t1=%xmm0,<t1=%xmm0
shufpd $0x1,%xmm0,%xmm0

# qhasm: *(int128 *)(a2b2p + 16) = t1
# asm 1: movdqa <t1=int6464#1,16(<a2b2p=int64#6)
# asm 2: movdqa <t1=%xmm0,16(<a2b2p=%r9)
movdqa %xmm0,16(%r9)

# qhasm: t2 = *(int128 *)(b2a2p + 32)
# asm 1: movdqa 32(<b2a2p=int64#3),>t2=int6464#1
# asm 2: movdqa 32(<b2a2p=%rdx),>t2=%xmm0
movdqa 32(%rdx),%xmm0

# qhasm: t2 = shuffle float64 of t2 and t2 by 0x1
# asm 1: shufpd $0x1,<t2=int6464#1,<t2=int6464#1
# asm 2: shufpd $0x1,<t2=%xmm0,<t2=%xmm0
shufpd $0x1,%xmm0,%xmm0

# qhasm: *(int128 *)(a2b2p + 32) = t2
# asm 1: movdqa <t2=int6464#1,32(<a2b2p=int64#6)
# asm 2: movdqa <t2=%xmm0,32(<a2b2p=%r9)
movdqa %xmm0,32(%r9)

# qhasm: t3 = *(int128 *)(b2a2p + 48)
# asm 1: movdqa 48(<b2a2p=int64#3),>t3=int6464#1
# asm 2: movdqa 48(<b2a2p=%rdx),>t3=%xmm0
movdqa 48(%rdx),%xmm0

# qhasm: t3 = shuffle float64 of t3 and t3 by 0x1
# asm 1: shufpd $0x1,<t3=int6464#1,<t3=int6464#1
# asm 2: shufpd $0x1,<t3=%xmm0,<t3=%xmm0
shufpd $0x1,%xmm0,%xmm0

# qhasm: *(int128 *)(a2b2p + 48) = t3
# asm 1: movdqa <t3=int6464#1,48(<a2b2p=int64#6)
# asm 2: movdqa <t3=%xmm0,48(<a2b2p=%r9)
movdqa %xmm0,48(%r9)

# qhasm: t4 = *(int128 *)(b2a2p + 64)
# asm 1: movdqa 64(<b2a2p=int64#3),>t4=int6464#1
# asm 2: movdqa 64(<b2a2p=%rdx),>t4=%xmm0
movdqa 64(%rdx),%xmm0

# qhasm: t4 = shuffle float64 of t4 and t4 by 0x1
# asm 1: shufpd $0x1,<t4=int6464#1,<t4=int6464#1
# asm 2: shufpd $0x1,<t4=%xmm0,<t4=%xmm0
shufpd $0x1,%xmm0,%xmm0

# qhasm: *(int128 *)(a2b2p + 64) = t4
# asm 1: movdqa <t4=int6464#1,64(<a2b2p=int64#6)
# asm 2: movdqa <t4=%xmm0,64(<a2b2p=%r9)
movdqa %xmm0,64(%r9)

# qhasm: t5 = *(int128 *)(b2a2p + 80)
# asm 1: movdqa 80(<b2a2p=int64#3),>t5=int6464#1
# asm 2: movdqa 80(<b2a2p=%rdx),>t5=%xmm0
movdqa 80(%rdx),%xmm0

# qhasm: t5 = shuffle float64 of t5 and t5 by 0x1
# asm 1: shufpd $0x1,<t5=int6464#1,<t5=int6464#1
# asm 2: shufpd $0x1,<t5=%xmm0,<t5=%xmm0
shufpd $0x1,%xmm0,%xmm0

# qhasm: *(int128 *)(a2b2p + 80) = t5
# asm 1: movdqa <t5=int6464#1,80(<a2b2p=int64#6)
# asm 2: movdqa <t5=%xmm0,80(<a2b2p=%r9)
movdqa %xmm0,80(%r9)

# qhasm: t6 = *(int128 *)(b2a2p + 96)
# asm 1: movdqa 96(<b2a2p=int64#3),>t6=int6464#1
# asm 2: movdqa 96(<b2a2p=%rdx),>t6=%xmm0
movdqa 96(%rdx),%xmm0

# qhasm: t6 = shuffle float64 of t6 and t6 by 0x1
# asm 1: shufpd $0x1,<t6=int6464#1,<t6=int6464#1
# asm 2: shufpd $0x1,<t6=%xmm0,<t6=%xmm0
shufpd $0x1,%xmm0,%xmm0

# qhasm: *(int128 *)(a2b2p + 96) = t6
# asm 1: movdqa <t6=int6464#1,96(<a2b2p=int64#6)
# asm 2: movdqa <t6=%xmm0,96(<a2b2p=%r9)
movdqa %xmm0,96(%r9)

# qhasm: t7 = *(int128 *)(b2a2p + 112)
# asm 1: movdqa 112(<b2a2p=int64#3),>t7=int6464#1
# asm 2: movdqa 112(<b2a2p=%rdx),>t7=%xmm0
movdqa 112(%rdx),%xmm0

# qhasm: t7 = shuffle float64 of t7 and t7 by 0x1
# asm 1: shufpd $0x1,<t7=int6464#1,<t7=int6464#1
# asm 2: shufpd $0x1,<t7=%xmm0,<t7=%xmm0
shufpd $0x1,%xmm0,%xmm0

# qhasm: *(int128 *)(a2b2p + 112) = t7
# asm 1: movdqa <t7=int6464#1,112(<a2b2p=int64#6)
# asm 2: movdqa <t7=%xmm0,112(<a2b2p=%r9)
movdqa %xmm0,112(%r9)

# qhasm: t8 = *(int128 *)(b2a2p + 128)
# asm 1: movdqa 128(<b2a2p=int64#3),>t8=int6464#1
# asm 2: movdqa 128(<b2a2p=%rdx),>t8=%xmm0
movdqa 128(%rdx),%xmm0

# qhasm: t8 = shuffle float64 of t8 and t8 by 0x1
# asm 1: shufpd $0x1,<t8=int6464#1,<t8=int6464#1
# asm 2: shufpd $0x1,<t8=%xmm0,<t8=%xmm0
shufpd $0x1,%xmm0,%xmm0

# qhasm: *(int128 *)(a2b2p + 128) = t8
# asm 1: movdqa <t8=int6464#1,128(<a2b2p=int64#6)
# asm 2: movdqa <t8=%xmm0,128(<a2b2p=%r9)
movdqa %xmm0,128(%r9)

# qhasm: t9 = *(int128 *)(b2a2p + 144)
# asm 1: movdqa 144(<b2a2p=int64#3),>t9=int6464#1
# asm 2: movdqa 144(<b2a2p=%rdx),>t9=%xmm0
movdqa 144(%rdx),%xmm0

# qhasm: t9 = shuffle float64 of t9 and t9 by 0x1
# asm 1: shufpd $0x1,<t9=int6464#1,<t9=int6464#1
# asm 2: shufpd $0x1,<t9=%xmm0,<t9=%xmm0
shufpd $0x1,%xmm0,%xmm0

# qhasm: *(int128 *)(a2b2p + 144) = t9
# asm 1: movdqa <t9=int6464#1,144(<a2b2p=int64#6)
# asm 2: movdqa <t9=%xmm0,144(<a2b2p=%r9)
movdqa %xmm0,144(%r9)

# qhasm: t10 = *(int128 *)(b2a2p + 160)
# asm 1: movdqa 160(<b2a2p=int64#3),>t10=int6464#1
# asm 2: movdqa 160(<b2a2p=%rdx),>t10=%xmm0
movdqa 160(%rdx),%xmm0

# qhasm: t10 = shuffle float64 of t10 and t10 by 0x1
# asm 1: shufpd $0x1,<t10=int6464#1,<t10=int6464#1
# asm 2: shufpd $0x1,<t10=%xmm0,<t10=%xmm0
shufpd $0x1,%xmm0,%xmm0

# qhasm: *(int128 *)(a2b2p + 160) = t10
# asm 1: movdqa <t10=int6464#1,160(<a2b2p=int64#6)
# asm 2: movdqa <t10=%xmm0,160(<a2b2p=%r9)
movdqa %xmm0,160(%r9)

# qhasm: t11 = *(int128 *)(b2a2p + 176)
# asm 1: movdqa 176(<b2a2p=int64#3),>t11=int6464#1
# asm 2: movdqa 176(<b2a2p=%rdx),>t11=%xmm0
movdqa 176(%rdx),%xmm0

# qhasm: t11 = shuffle float64 of t11 and t11 by 0x1
# asm 1: shufpd $0x1,<t11=int6464#1,<t11=int6464#1
# asm 2: shufpd $0x1,<t11=%xmm0,<t11=%xmm0
shufpd $0x1,%xmm0,%xmm0

# qhasm: *(int128 *)(a2b2p + 176) = t11
# asm 1: movdqa <t11=int6464#1,176(<a2b2p=int64#6)
# asm 2: movdqa <t11=%xmm0,176(<a2b2p=%r9)
movdqa %xmm0,176(%r9)

# qhasm: t0 = *(int128 *)(op1 + 0)
# asm 1: movdqa 0(<op1=int64#2),>t0=int6464#1
# asm 2: movdqa 0(<op1=%rsi),>t0=%xmm0
movdqa 0(%rsi),%xmm0

# qhasm: d0 = t0
# asm 1: movdqa <t0=int6464#1,>d0=int6464#2
# asm 2: movdqa <t0=%xmm0,>d0=%xmm1
movdqa %xmm0,%xmm1

# qhasm: t0 = unpack low double of t0 and t0
# asm 1: unpcklpd <t0=int6464#1,<t0=int6464#1
# asm 2: unpcklpd <t0=%xmm0,<t0=%xmm0
unpcklpd %xmm0,%xmm0

# qhasm: d0 = unpack high double of d0 and d0
# asm 1: unpckhpd <d0=int6464#2,<d0=int6464#2
# asm 2: unpckhpd <d0=%xmm1,<d0=%xmm1
unpckhpd %xmm1,%xmm1

# qhasm: float6464 d0 *= MINUSONE_ONE
# asm 1: mulpd MINUSONE_ONE,<d0=int6464#2
# asm 2: mulpd MINUSONE_ONE,<d0=%xmm1
mov MINUSONE_ONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: *(int128 *)(b1b1p + 0)  = t0
# asm 1: movdqa <t0=int6464#1,0(<b1b1p=int64#4)
# asm 2: movdqa <t0=%xmm0,0(<b1b1p=%rcx)
movdqa %xmm0,0(%rcx)

# qhasm: *(int128 *)(ma1a1p + 0)  = d0
# asm 1: movdqa <d0=int6464#2,0(<ma1a1p=int64#5)
# asm 2: movdqa <d0=%xmm1,0(<ma1a1p=%r8)
movdqa %xmm1,0(%r8)

# qhasm: t1 = *(int128 *)(op1 + 16)
# asm 1: movdqa 16(<op1=int64#2),>t1=int6464#1
# asm 2: movdqa 16(<op1=%rsi),>t1=%xmm0
movdqa 16(%rsi),%xmm0

# qhasm: d1 = t1
# asm 1: movdqa <t1=int6464#1,>d1=int6464#2
# asm 2: movdqa <t1=%xmm0,>d1=%xmm1
movdqa %xmm0,%xmm1

# qhasm: t1 = unpack low double of t1 and t1
# asm 1: unpcklpd <t1=int6464#1,<t1=int6464#1
# asm 2: unpcklpd <t1=%xmm0,<t1=%xmm0
unpcklpd %xmm0,%xmm0

# qhasm: d1 = unpack high double of d1 and d1
# asm 1: unpckhpd <d1=int6464#2,<d1=int6464#2
# asm 2: unpckhpd <d1=%xmm1,<d1=%xmm1
unpckhpd %xmm1,%xmm1

# qhasm: float6464 d1 *= MINUSONE_ONE
# asm 1: mulpd MINUSONE_ONE,<d1=int6464#2
# asm 2: mulpd MINUSONE_ONE,<d1=%xmm1
mov MINUSONE_ONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: *(int128 *)(b1b1p + 16)  = t1
# asm 1: movdqa <t1=int6464#1,16(<b1b1p=int64#4)
# asm 2: movdqa <t1=%xmm0,16(<b1b1p=%rcx)
movdqa %xmm0,16(%rcx)

# qhasm: *(int128 *)(ma1a1p + 16)  = d1
# asm 1: movdqa <d1=int6464#2,16(<ma1a1p=int64#5)
# asm 2: movdqa <d1=%xmm1,16(<ma1a1p=%r8)
movdqa %xmm1,16(%r8)

# qhasm: t2 = *(int128 *)(op1 + 32)
# asm 1: movdqa 32(<op1=int64#2),>t2=int6464#1
# asm 2: movdqa 32(<op1=%rsi),>t2=%xmm0
movdqa 32(%rsi),%xmm0

# qhasm: d2 = t2
# asm 1: movdqa <t2=int6464#1,>d2=int6464#2
# asm 2: movdqa <t2=%xmm0,>d2=%xmm1
movdqa %xmm0,%xmm1

# qhasm: t2 = unpack low double of t2 and t2
# asm 1: unpcklpd <t2=int6464#1,<t2=int6464#1
# asm 2: unpcklpd <t2=%xmm0,<t2=%xmm0
unpcklpd %xmm0,%xmm0

# qhasm: d2 = unpack high double of d2 and d2
# asm 1: unpckhpd <d2=int6464#2,<d2=int6464#2
# asm 2: unpckhpd <d2=%xmm1,<d2=%xmm1
unpckhpd %xmm1,%xmm1

# qhasm: float6464 d2 *= MINUSONE_ONE
# asm 1: mulpd MINUSONE_ONE,<d2=int6464#2
# asm 2: mulpd MINUSONE_ONE,<d2=%xmm1
mov MINUSONE_ONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: *(int128 *)(b1b1p + 32)  = t2
# asm 1: movdqa <t2=int6464#1,32(<b1b1p=int64#4)
# asm 2: movdqa <t2=%xmm0,32(<b1b1p=%rcx)
movdqa %xmm0,32(%rcx)

# qhasm: *(int128 *)(ma1a1p + 32)  = d2
# asm 1: movdqa <d2=int6464#2,32(<ma1a1p=int64#5)
# asm 2: movdqa <d2=%xmm1,32(<ma1a1p=%r8)
movdqa %xmm1,32(%r8)

# qhasm: t3 = *(int128 *)(op1 + 48)
# asm 1: movdqa 48(<op1=int64#2),>t3=int6464#1
# asm 2: movdqa 48(<op1=%rsi),>t3=%xmm0
movdqa 48(%rsi),%xmm0

# qhasm: d3 = t3
# asm 1: movdqa <t3=int6464#1,>d3=int6464#2
# asm 2: movdqa <t3=%xmm0,>d3=%xmm1
movdqa %xmm0,%xmm1

# qhasm: t3 = unpack low double of t3 and t3
# asm 1: unpcklpd <t3=int6464#1,<t3=int6464#1
# asm 2: unpcklpd <t3=%xmm0,<t3=%xmm0
unpcklpd %xmm0,%xmm0

# qhasm: d3 = unpack high double of d3 and d3
# asm 1: unpckhpd <d3=int6464#2,<d3=int6464#2
# asm 2: unpckhpd <d3=%xmm1,<d3=%xmm1
unpckhpd %xmm1,%xmm1

# qhasm: float6464 d3 *= MINUSONE_ONE
# asm 1: mulpd MINUSONE_ONE,<d3=int6464#2
# asm 2: mulpd MINUSONE_ONE,<d3=%xmm1
mov MINUSONE_ONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: *(int128 *)(b1b1p + 48)  = t3
# asm 1: movdqa <t3=int6464#1,48(<b1b1p=int64#4)
# asm 2: movdqa <t3=%xmm0,48(<b1b1p=%rcx)
movdqa %xmm0,48(%rcx)

# qhasm: *(int128 *)(ma1a1p + 48)  = d3
# asm 1: movdqa <d3=int6464#2,48(<ma1a1p=int64#5)
# asm 2: movdqa <d3=%xmm1,48(<ma1a1p=%r8)
movdqa %xmm1,48(%r8)

# qhasm: t4 = *(int128 *)(op1 + 64)
# asm 1: movdqa 64(<op1=int64#2),>t4=int6464#1
# asm 2: movdqa 64(<op1=%rsi),>t4=%xmm0
movdqa 64(%rsi),%xmm0

# qhasm: d4 = t4
# asm 1: movdqa <t4=int6464#1,>d4=int6464#2
# asm 2: movdqa <t4=%xmm0,>d4=%xmm1
movdqa %xmm0,%xmm1

# qhasm: t4 = unpack low double of t4 and t4
# asm 1: unpcklpd <t4=int6464#1,<t4=int6464#1
# asm 2: unpcklpd <t4=%xmm0,<t4=%xmm0
unpcklpd %xmm0,%xmm0

# qhasm: d4 = unpack high double of d4 and d4
# asm 1: unpckhpd <d4=int6464#2,<d4=int6464#2
# asm 2: unpckhpd <d4=%xmm1,<d4=%xmm1
unpckhpd %xmm1,%xmm1

# qhasm: float6464 d4 *= MINUSONE_ONE
# asm 1: mulpd MINUSONE_ONE,<d4=int6464#2
# asm 2: mulpd MINUSONE_ONE,<d4=%xmm1
mov MINUSONE_ONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: *(int128 *)(b1b1p + 64)  = t4
# asm 1: movdqa <t4=int6464#1,64(<b1b1p=int64#4)
# asm 2: movdqa <t4=%xmm0,64(<b1b1p=%rcx)
movdqa %xmm0,64(%rcx)

# qhasm: *(int128 *)(ma1a1p + 64)  = d4
# asm 1: movdqa <d4=int6464#2,64(<ma1a1p=int64#5)
# asm 2: movdqa <d4=%xmm1,64(<ma1a1p=%r8)
movdqa %xmm1,64(%r8)

# qhasm: t5 = *(int128 *)(op1 + 80)
# asm 1: movdqa 80(<op1=int64#2),>t5=int6464#1
# asm 2: movdqa 80(<op1=%rsi),>t5=%xmm0
movdqa 80(%rsi),%xmm0

# qhasm: d5 = t5
# asm 1: movdqa <t5=int6464#1,>d5=int6464#2
# asm 2: movdqa <t5=%xmm0,>d5=%xmm1
movdqa %xmm0,%xmm1

# qhasm: t5 = unpack low double of t5 and t5
# asm 1: unpcklpd <t5=int6464#1,<t5=int6464#1
# asm 2: unpcklpd <t5=%xmm0,<t5=%xmm0
unpcklpd %xmm0,%xmm0

# qhasm: d5 = unpack high double of d5 and d5
# asm 1: unpckhpd <d5=int6464#2,<d5=int6464#2
# asm 2: unpckhpd <d5=%xmm1,<d5=%xmm1
unpckhpd %xmm1,%xmm1

# qhasm: float6464 d5 *= MINUSONE_ONE
# asm 1: mulpd MINUSONE_ONE,<d5=int6464#2
# asm 2: mulpd MINUSONE_ONE,<d5=%xmm1
mov MINUSONE_ONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: *(int128 *)(b1b1p + 80)  = t5
# asm 1: movdqa <t5=int6464#1,80(<b1b1p=int64#4)
# asm 2: movdqa <t5=%xmm0,80(<b1b1p=%rcx)
movdqa %xmm0,80(%rcx)

# qhasm: *(int128 *)(ma1a1p + 80)  = d5
# asm 1: movdqa <d5=int6464#2,80(<ma1a1p=int64#5)
# asm 2: movdqa <d5=%xmm1,80(<ma1a1p=%r8)
movdqa %xmm1,80(%r8)

# qhasm: t6 = *(int128 *)(op1 + 96)
# asm 1: movdqa 96(<op1=int64#2),>t6=int6464#1
# asm 2: movdqa 96(<op1=%rsi),>t6=%xmm0
movdqa 96(%rsi),%xmm0

# qhasm: d6 = t6
# asm 1: movdqa <t6=int6464#1,>d6=int6464#2
# asm 2: movdqa <t6=%xmm0,>d6=%xmm1
movdqa %xmm0,%xmm1

# qhasm: t6 = unpack low double of t6 and t6
# asm 1: unpcklpd <t6=int6464#1,<t6=int6464#1
# asm 2: unpcklpd <t6=%xmm0,<t6=%xmm0
unpcklpd %xmm0,%xmm0

# qhasm: d6 = unpack high double of d6 and d6
# asm 1: unpckhpd <d6=int6464#2,<d6=int6464#2
# asm 2: unpckhpd <d6=%xmm1,<d6=%xmm1
unpckhpd %xmm1,%xmm1

# qhasm: float6464 d6 *= MINUSONE_ONE
# asm 1: mulpd MINUSONE_ONE,<d6=int6464#2
# asm 2: mulpd MINUSONE_ONE,<d6=%xmm1
mov MINUSONE_ONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: *(int128 *)(b1b1p + 96)  = t6
# asm 1: movdqa <t6=int6464#1,96(<b1b1p=int64#4)
# asm 2: movdqa <t6=%xmm0,96(<b1b1p=%rcx)
movdqa %xmm0,96(%rcx)

# qhasm: *(int128 *)(ma1a1p + 96)  = d6
# asm 1: movdqa <d6=int6464#2,96(<ma1a1p=int64#5)
# asm 2: movdqa <d6=%xmm1,96(<ma1a1p=%r8)
movdqa %xmm1,96(%r8)

# qhasm: t7 = *(int128 *)(op1 + 112)
# asm 1: movdqa 112(<op1=int64#2),>t7=int6464#1
# asm 2: movdqa 112(<op1=%rsi),>t7=%xmm0
movdqa 112(%rsi),%xmm0

# qhasm: d7 = t7
# asm 1: movdqa <t7=int6464#1,>d7=int6464#2
# asm 2: movdqa <t7=%xmm0,>d7=%xmm1
movdqa %xmm0,%xmm1

# qhasm: t7 = unpack low double of t7 and t7
# asm 1: unpcklpd <t7=int6464#1,<t7=int6464#1
# asm 2: unpcklpd <t7=%xmm0,<t7=%xmm0
unpcklpd %xmm0,%xmm0

# qhasm: d7 = unpack high double of d7 and d7
# asm 1: unpckhpd <d7=int6464#2,<d7=int6464#2
# asm 2: unpckhpd <d7=%xmm1,<d7=%xmm1
unpckhpd %xmm1,%xmm1

# qhasm: float6464 d7 *= MINUSONE_ONE
# asm 1: mulpd MINUSONE_ONE,<d7=int6464#2
# asm 2: mulpd MINUSONE_ONE,<d7=%xmm1
mov MINUSONE_ONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: *(int128 *)(b1b1p + 112)  = t7
# asm 1: movdqa <t7=int6464#1,112(<b1b1p=int64#4)
# asm 2: movdqa <t7=%xmm0,112(<b1b1p=%rcx)
movdqa %xmm0,112(%rcx)

# qhasm: *(int128 *)(ma1a1p + 112)  = d7
# asm 1: movdqa <d7=int6464#2,112(<ma1a1p=int64#5)
# asm 2: movdqa <d7=%xmm1,112(<ma1a1p=%r8)
movdqa %xmm1,112(%r8)

# qhasm: t8 = *(int128 *)(op1 + 128)
# asm 1: movdqa 128(<op1=int64#2),>t8=int6464#1
# asm 2: movdqa 128(<op1=%rsi),>t8=%xmm0
movdqa 128(%rsi),%xmm0

# qhasm: d8 = t8
# asm 1: movdqa <t8=int6464#1,>d8=int6464#2
# asm 2: movdqa <t8=%xmm0,>d8=%xmm1
movdqa %xmm0,%xmm1

# qhasm: t8 = unpack low double of t8 and t8
# asm 1: unpcklpd <t8=int6464#1,<t8=int6464#1
# asm 2: unpcklpd <t8=%xmm0,<t8=%xmm0
unpcklpd %xmm0,%xmm0

# qhasm: d8 = unpack high double of d8 and d8
# asm 1: unpckhpd <d8=int6464#2,<d8=int6464#2
# asm 2: unpckhpd <d8=%xmm1,<d8=%xmm1
unpckhpd %xmm1,%xmm1

# qhasm: float6464 d8 *= MINUSONE_ONE
# asm 1: mulpd MINUSONE_ONE,<d8=int6464#2
# asm 2: mulpd MINUSONE_ONE,<d8=%xmm1
mov MINUSONE_ONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: *(int128 *)(b1b1p + 128)  = t8
# asm 1: movdqa <t8=int6464#1,128(<b1b1p=int64#4)
# asm 2: movdqa <t8=%xmm0,128(<b1b1p=%rcx)
movdqa %xmm0,128(%rcx)

# qhasm: *(int128 *)(ma1a1p + 128)  = d8
# asm 1: movdqa <d8=int6464#2,128(<ma1a1p=int64#5)
# asm 2: movdqa <d8=%xmm1,128(<ma1a1p=%r8)
movdqa %xmm1,128(%r8)

# qhasm: t9 = *(int128 *)(op1 + 144)
# asm 1: movdqa 144(<op1=int64#2),>t9=int6464#1
# asm 2: movdqa 144(<op1=%rsi),>t9=%xmm0
movdqa 144(%rsi),%xmm0

# qhasm: d9 = t9
# asm 1: movdqa <t9=int6464#1,>d9=int6464#2
# asm 2: movdqa <t9=%xmm0,>d9=%xmm1
movdqa %xmm0,%xmm1

# qhasm: t9 = unpack low double of t9 and t9
# asm 1: unpcklpd <t9=int6464#1,<t9=int6464#1
# asm 2: unpcklpd <t9=%xmm0,<t9=%xmm0
unpcklpd %xmm0,%xmm0

# qhasm: d9 = unpack high double of d9 and d9
# asm 1: unpckhpd <d9=int6464#2,<d9=int6464#2
# asm 2: unpckhpd <d9=%xmm1,<d9=%xmm1
unpckhpd %xmm1,%xmm1

# qhasm: float6464 d9 *= MINUSONE_ONE
# asm 1: mulpd MINUSONE_ONE,<d9=int6464#2
# asm 2: mulpd MINUSONE_ONE,<d9=%xmm1
mov MINUSONE_ONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: *(int128 *)(b1b1p + 144)  = t9
# asm 1: movdqa <t9=int6464#1,144(<b1b1p=int64#4)
# asm 2: movdqa <t9=%xmm0,144(<b1b1p=%rcx)
movdqa %xmm0,144(%rcx)

# qhasm: *(int128 *)(ma1a1p + 144)  = d9
# asm 1: movdqa <d9=int6464#2,144(<ma1a1p=int64#5)
# asm 2: movdqa <d9=%xmm1,144(<ma1a1p=%r8)
movdqa %xmm1,144(%r8)

# qhasm: t10 = *(int128 *)(op1 + 160)
# asm 1: movdqa 160(<op1=int64#2),>t10=int6464#1
# asm 2: movdqa 160(<op1=%rsi),>t10=%xmm0
movdqa 160(%rsi),%xmm0

# qhasm: d10 = t10
# asm 1: movdqa <t10=int6464#1,>d10=int6464#2
# asm 2: movdqa <t10=%xmm0,>d10=%xmm1
movdqa %xmm0,%xmm1

# qhasm: t10 = unpack low double of t10 and t10
# asm 1: unpcklpd <t10=int6464#1,<t10=int6464#1
# asm 2: unpcklpd <t10=%xmm0,<t10=%xmm0
unpcklpd %xmm0,%xmm0

# qhasm: d10 = unpack high double of d10 and d10
# asm 1: unpckhpd <d10=int6464#2,<d10=int6464#2
# asm 2: unpckhpd <d10=%xmm1,<d10=%xmm1
unpckhpd %xmm1,%xmm1

# qhasm: float6464 d10 *= MINUSONE_ONE
# asm 1: mulpd MINUSONE_ONE,<d10=int6464#2
# asm 2: mulpd MINUSONE_ONE,<d10=%xmm1
mov MINUSONE_ONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: *(int128 *)(b1b1p + 160)  = t10
# asm 1: movdqa <t10=int6464#1,160(<b1b1p=int64#4)
# asm 2: movdqa <t10=%xmm0,160(<b1b1p=%rcx)
movdqa %xmm0,160(%rcx)

# qhasm: *(int128 *)(ma1a1p + 160)  = d10
# asm 1: movdqa <d10=int6464#2,160(<ma1a1p=int64#5)
# asm 2: movdqa <d10=%xmm1,160(<ma1a1p=%r8)
movdqa %xmm1,160(%r8)

# qhasm: t11 = *(int128 *)(op1 + 176)
# asm 1: movdqa 176(<op1=int64#2),>t11=int6464#1
# asm 2: movdqa 176(<op1=%rsi),>t11=%xmm0
movdqa 176(%rsi),%xmm0

# qhasm: d11 = t11
# asm 1: movdqa <t11=int6464#1,>d11=int6464#2
# asm 2: movdqa <t11=%xmm0,>d11=%xmm1
movdqa %xmm0,%xmm1

# qhasm: t11 = unpack low double of t11 and t11
# asm 1: unpcklpd <t11=int6464#1,<t11=int6464#1
# asm 2: unpcklpd <t11=%xmm0,<t11=%xmm0
unpcklpd %xmm0,%xmm0

# qhasm: d11 = unpack high double of d11 and d11
# asm 1: unpckhpd <d11=int6464#2,<d11=int6464#2
# asm 2: unpckhpd <d11=%xmm1,<d11=%xmm1
unpckhpd %xmm1,%xmm1

# qhasm: float6464 d11 *= MINUSONE_ONE
# asm 1: mulpd MINUSONE_ONE,<d11=int6464#2
# asm 2: mulpd MINUSONE_ONE,<d11=%xmm1
mov MINUSONE_ONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: *(int128 *)(b1b1p + 176)  = t11
# asm 1: movdqa <t11=int6464#1,176(<b1b1p=int64#4)
# asm 2: movdqa <t11=%xmm0,176(<b1b1p=%rcx)
movdqa %xmm0,176(%rcx)

# qhasm: *(int128 *)(ma1a1p + 176)  = d11
# asm 1: movdqa <d11=int6464#2,176(<ma1a1p=int64#5)
# asm 2: movdqa <d11=%xmm1,176(<ma1a1p=%r8)
movdqa %xmm1,176(%r8)

# qhasm: ab0 = *(int128 *)(b1b1p + 0)
# asm 1: movdqa 0(<b1b1p=int64#4),>ab0=int6464#1
# asm 2: movdqa 0(<b1b1p=%rcx),>ab0=%xmm0
movdqa 0(%rcx),%xmm0

# qhasm: cd0 = *(int128 *)(ma1a1p + 0)
# asm 1: movdqa 0(<ma1a1p=int64#5),>cd0=int6464#2
# asm 2: movdqa 0(<ma1a1p=%r8),>cd0=%xmm1
movdqa 0(%r8),%xmm1

# qhasm: r0 = ab0
# asm 1: movdqa <ab0=int6464#1,>r0=int6464#3
# asm 2: movdqa <ab0=%xmm0,>r0=%xmm2
movdqa %xmm0,%xmm2

# qhasm: float6464 r0 *= *(int128 *)(b2a2p + 0)
# asm 1: mulpd 0(<b2a2p=int64#3),<r0=int6464#3
# asm 2: mulpd 0(<b2a2p=%rdx),<r0=%xmm2
mulpd 0(%rdx),%xmm2

# qhasm: d0 = cd0
# asm 1: movdqa <cd0=int6464#2,>d0=int6464#4
# asm 2: movdqa <cd0=%xmm1,>d0=%xmm3
movdqa %xmm1,%xmm3

# qhasm: float6464 d0 *= *(int128 *)(a2b2p + 0)
# asm 1: mulpd 0(<a2b2p=int64#6),<d0=int6464#4
# asm 2: mulpd 0(<a2b2p=%r9),<d0=%xmm3
mulpd 0(%r9),%xmm3

# qhasm: float6464 r0 += d0
# asm 1: addpd <d0=int6464#4,<r0=int6464#3
# asm 2: addpd <d0=%xmm3,<r0=%xmm2
addpd %xmm3,%xmm2

# qhasm: r1 = ab0
# asm 1: movdqa <ab0=int6464#1,>r1=int6464#4
# asm 2: movdqa <ab0=%xmm0,>r1=%xmm3
movdqa %xmm0,%xmm3

# qhasm: float6464 r1 *= *(int128 *)(b2a2p + 16)
# asm 1: mulpd 16(<b2a2p=int64#3),<r1=int6464#4
# asm 2: mulpd 16(<b2a2p=%rdx),<r1=%xmm3
mulpd 16(%rdx),%xmm3

# qhasm: d1 = cd0
# asm 1: movdqa <cd0=int6464#2,>d1=int6464#5
# asm 2: movdqa <cd0=%xmm1,>d1=%xmm4
movdqa %xmm1,%xmm4

# qhasm: float6464 d1 *= *(int128 *)(a2b2p + 16)
# asm 1: mulpd 16(<a2b2p=int64#6),<d1=int6464#5
# asm 2: mulpd 16(<a2b2p=%r9),<d1=%xmm4
mulpd 16(%r9),%xmm4

# qhasm: float6464 r1 += d1
# asm 1: addpd <d1=int6464#5,<r1=int6464#4
# asm 2: addpd <d1=%xmm4,<r1=%xmm3
addpd %xmm4,%xmm3

# qhasm: r2 = ab0
# asm 1: movdqa <ab0=int6464#1,>r2=int6464#5
# asm 2: movdqa <ab0=%xmm0,>r2=%xmm4
movdqa %xmm0,%xmm4

# qhasm: float6464 r2 *= *(int128 *)(b2a2p + 32)
# asm 1: mulpd 32(<b2a2p=int64#3),<r2=int6464#5
# asm 2: mulpd 32(<b2a2p=%rdx),<r2=%xmm4
mulpd 32(%rdx),%xmm4

# qhasm: d2 = cd0
# asm 1: movdqa <cd0=int6464#2,>d2=int6464#6
# asm 2: movdqa <cd0=%xmm1,>d2=%xmm5
movdqa %xmm1,%xmm5

# qhasm: float6464 d2 *= *(int128 *)(a2b2p + 32)
# asm 1: mulpd 32(<a2b2p=int64#6),<d2=int6464#6
# asm 2: mulpd 32(<a2b2p=%r9),<d2=%xmm5
mulpd 32(%r9),%xmm5

# qhasm: float6464 r2 += d2
# asm 1: addpd <d2=int6464#6,<r2=int6464#5
# asm 2: addpd <d2=%xmm5,<r2=%xmm4
addpd %xmm5,%xmm4

# qhasm: r3 = ab0
# asm 1: movdqa <ab0=int6464#1,>r3=int6464#6
# asm 2: movdqa <ab0=%xmm0,>r3=%xmm5
movdqa %xmm0,%xmm5

# qhasm: float6464 r3 *= *(int128 *)(b2a2p + 48)
# asm 1: mulpd 48(<b2a2p=int64#3),<r3=int6464#6
# asm 2: mulpd 48(<b2a2p=%rdx),<r3=%xmm5
mulpd 48(%rdx),%xmm5

# qhasm: d3 = cd0
# asm 1: movdqa <cd0=int6464#2,>d3=int6464#7
# asm 2: movdqa <cd0=%xmm1,>d3=%xmm6
movdqa %xmm1,%xmm6

# qhasm: float6464 d3 *= *(int128 *)(a2b2p + 48)
# asm 1: mulpd 48(<a2b2p=int64#6),<d3=int6464#7
# asm 2: mulpd 48(<a2b2p=%r9),<d3=%xmm6
mulpd 48(%r9),%xmm6

# qhasm: float6464 r3 += d3
# asm 1: addpd <d3=int6464#7,<r3=int6464#6
# asm 2: addpd <d3=%xmm6,<r3=%xmm5
addpd %xmm6,%xmm5

# qhasm: r4 = ab0
# asm 1: movdqa <ab0=int6464#1,>r4=int6464#7
# asm 2: movdqa <ab0=%xmm0,>r4=%xmm6
movdqa %xmm0,%xmm6

# qhasm: float6464 r4 *= *(int128 *)(b2a2p + 64)
# asm 1: mulpd 64(<b2a2p=int64#3),<r4=int6464#7
# asm 2: mulpd 64(<b2a2p=%rdx),<r4=%xmm6
mulpd 64(%rdx),%xmm6

# qhasm: d4 = cd0
# asm 1: movdqa <cd0=int6464#2,>d4=int6464#8
# asm 2: movdqa <cd0=%xmm1,>d4=%xmm7
movdqa %xmm1,%xmm7

# qhasm: float6464 d4 *= *(int128 *)(a2b2p + 64)
# asm 1: mulpd 64(<a2b2p=int64#6),<d4=int6464#8
# asm 2: mulpd 64(<a2b2p=%r9),<d4=%xmm7
mulpd 64(%r9),%xmm7

# qhasm: float6464 r4 += d4
# asm 1: addpd <d4=int6464#8,<r4=int6464#7
# asm 2: addpd <d4=%xmm7,<r4=%xmm6
addpd %xmm7,%xmm6

# qhasm: r5 = ab0
# asm 1: movdqa <ab0=int6464#1,>r5=int6464#8
# asm 2: movdqa <ab0=%xmm0,>r5=%xmm7
movdqa %xmm0,%xmm7

# qhasm: float6464 r5 *= *(int128 *)(b2a2p + 80)
# asm 1: mulpd 80(<b2a2p=int64#3),<r5=int6464#8
# asm 2: mulpd 80(<b2a2p=%rdx),<r5=%xmm7
mulpd 80(%rdx),%xmm7

# qhasm: d5 = cd0
# asm 1: movdqa <cd0=int6464#2,>d5=int6464#9
# asm 2: movdqa <cd0=%xmm1,>d5=%xmm8
movdqa %xmm1,%xmm8

# qhasm: float6464 d5 *= *(int128 *)(a2b2p + 80)
# asm 1: mulpd 80(<a2b2p=int64#6),<d5=int6464#9
# asm 2: mulpd 80(<a2b2p=%r9),<d5=%xmm8
mulpd 80(%r9),%xmm8

# qhasm: float6464 r5 += d5
# asm 1: addpd <d5=int6464#9,<r5=int6464#8
# asm 2: addpd <d5=%xmm8,<r5=%xmm7
addpd %xmm8,%xmm7

# qhasm: r6 = ab0
# asm 1: movdqa <ab0=int6464#1,>r6=int6464#9
# asm 2: movdqa <ab0=%xmm0,>r6=%xmm8
movdqa %xmm0,%xmm8

# qhasm: float6464 r6 *= *(int128 *)(b2a2p + 96)
# asm 1: mulpd 96(<b2a2p=int64#3),<r6=int6464#9
# asm 2: mulpd 96(<b2a2p=%rdx),<r6=%xmm8
mulpd 96(%rdx),%xmm8

# qhasm: d6 = cd0
# asm 1: movdqa <cd0=int6464#2,>d6=int6464#10
# asm 2: movdqa <cd0=%xmm1,>d6=%xmm9
movdqa %xmm1,%xmm9

# qhasm: float6464 d6 *= *(int128 *)(a2b2p + 96)
# asm 1: mulpd 96(<a2b2p=int64#6),<d6=int6464#10
# asm 2: mulpd 96(<a2b2p=%r9),<d6=%xmm9
mulpd 96(%r9),%xmm9

# qhasm: float6464 r6 += d6
# asm 1: addpd <d6=int6464#10,<r6=int6464#9
# asm 2: addpd <d6=%xmm9,<r6=%xmm8
addpd %xmm9,%xmm8

# qhasm: r7 = ab0
# asm 1: movdqa <ab0=int6464#1,>r7=int6464#10
# asm 2: movdqa <ab0=%xmm0,>r7=%xmm9
movdqa %xmm0,%xmm9

# qhasm: float6464 r7 *= *(int128 *)(b2a2p + 112)
# asm 1: mulpd 112(<b2a2p=int64#3),<r7=int6464#10
# asm 2: mulpd 112(<b2a2p=%rdx),<r7=%xmm9
mulpd 112(%rdx),%xmm9

# qhasm: d7 = cd0
# asm 1: movdqa <cd0=int6464#2,>d7=int6464#11
# asm 2: movdqa <cd0=%xmm1,>d7=%xmm10
movdqa %xmm1,%xmm10

# qhasm: float6464 d7 *= *(int128 *)(a2b2p + 112)
# asm 1: mulpd 112(<a2b2p=int64#6),<d7=int6464#11
# asm 2: mulpd 112(<a2b2p=%r9),<d7=%xmm10
mulpd 112(%r9),%xmm10

# qhasm: float6464 r7 += d7
# asm 1: addpd <d7=int6464#11,<r7=int6464#10
# asm 2: addpd <d7=%xmm10,<r7=%xmm9
addpd %xmm10,%xmm9

# qhasm: r8 = ab0
# asm 1: movdqa <ab0=int6464#1,>r8=int6464#11
# asm 2: movdqa <ab0=%xmm0,>r8=%xmm10
movdqa %xmm0,%xmm10

# qhasm: float6464 r8 *= *(int128 *)(b2a2p + 128)
# asm 1: mulpd 128(<b2a2p=int64#3),<r8=int6464#11
# asm 2: mulpd 128(<b2a2p=%rdx),<r8=%xmm10
mulpd 128(%rdx),%xmm10

# qhasm: d8 = cd0
# asm 1: movdqa <cd0=int6464#2,>d8=int6464#12
# asm 2: movdqa <cd0=%xmm1,>d8=%xmm11
movdqa %xmm1,%xmm11

# qhasm: float6464 d8 *= *(int128 *)(a2b2p + 128)
# asm 1: mulpd 128(<a2b2p=int64#6),<d8=int6464#12
# asm 2: mulpd 128(<a2b2p=%r9),<d8=%xmm11
mulpd 128(%r9),%xmm11

# qhasm: float6464 r8 += d8
# asm 1: addpd <d8=int6464#12,<r8=int6464#11
# asm 2: addpd <d8=%xmm11,<r8=%xmm10
addpd %xmm11,%xmm10

# qhasm: r9 = ab0
# asm 1: movdqa <ab0=int6464#1,>r9=int6464#12
# asm 2: movdqa <ab0=%xmm0,>r9=%xmm11
movdqa %xmm0,%xmm11

# qhasm: float6464 r9 *= *(int128 *)(b2a2p + 144)
# asm 1: mulpd 144(<b2a2p=int64#3),<r9=int6464#12
# asm 2: mulpd 144(<b2a2p=%rdx),<r9=%xmm11
mulpd 144(%rdx),%xmm11

# qhasm: d9 = cd0
# asm 1: movdqa <cd0=int6464#2,>d9=int6464#13
# asm 2: movdqa <cd0=%xmm1,>d9=%xmm12
movdqa %xmm1,%xmm12

# qhasm: float6464 d9 *= *(int128 *)(a2b2p + 144)
# asm 1: mulpd 144(<a2b2p=int64#6),<d9=int6464#13
# asm 2: mulpd 144(<a2b2p=%r9),<d9=%xmm12
mulpd 144(%r9),%xmm12

# qhasm: float6464 r9 += d9
# asm 1: addpd <d9=int6464#13,<r9=int6464#12
# asm 2: addpd <d9=%xmm12,<r9=%xmm11
addpd %xmm12,%xmm11

# qhasm: r10 = ab0
# asm 1: movdqa <ab0=int6464#1,>r10=int6464#13
# asm 2: movdqa <ab0=%xmm0,>r10=%xmm12
movdqa %xmm0,%xmm12

# qhasm: float6464 r10 *= *(int128 *)(b2a2p + 160)
# asm 1: mulpd 160(<b2a2p=int64#3),<r10=int6464#13
# asm 2: mulpd 160(<b2a2p=%rdx),<r10=%xmm12
mulpd 160(%rdx),%xmm12

# qhasm: d10 = cd0
# asm 1: movdqa <cd0=int6464#2,>d10=int6464#14
# asm 2: movdqa <cd0=%xmm1,>d10=%xmm13
movdqa %xmm1,%xmm13

# qhasm: float6464 d10 *= *(int128 *)(a2b2p + 160)
# asm 1: mulpd 160(<a2b2p=int64#6),<d10=int6464#14
# asm 2: mulpd 160(<a2b2p=%r9),<d10=%xmm13
mulpd 160(%r9),%xmm13

# qhasm: float6464 r10 += d10
# asm 1: addpd <d10=int6464#14,<r10=int6464#13
# asm 2: addpd <d10=%xmm13,<r10=%xmm12
addpd %xmm13,%xmm12

# qhasm: r11 = ab0
# asm 1: movdqa <ab0=int6464#1,>r11=int6464#1
# asm 2: movdqa <ab0=%xmm0,>r11=%xmm0
movdqa %xmm0,%xmm0

# qhasm: float6464 r11 *= *(int128 *)(b2a2p + 176)
# asm 1: mulpd 176(<b2a2p=int64#3),<r11=int6464#1
# asm 2: mulpd 176(<b2a2p=%rdx),<r11=%xmm0
mulpd 176(%rdx),%xmm0

# qhasm: d11 = cd0
# asm 1: movdqa <cd0=int6464#2,>d11=int6464#2
# asm 2: movdqa <cd0=%xmm1,>d11=%xmm1
movdqa %xmm1,%xmm1

# qhasm: float6464 d11 *= *(int128 *)(a2b2p + 176)
# asm 1: mulpd 176(<a2b2p=int64#6),<d11=int6464#2
# asm 2: mulpd 176(<a2b2p=%r9),<d11=%xmm1
mulpd 176(%r9),%xmm1

# qhasm: float6464 r11 += d11
# asm 1: addpd <d11=int6464#2,<r11=int6464#1
# asm 2: addpd <d11=%xmm1,<r11=%xmm0
addpd %xmm1,%xmm0

# qhasm: *(int128 *)(b1b1p + 0) = r0
# asm 1: movdqa <r0=int6464#3,0(<b1b1p=int64#4)
# asm 2: movdqa <r0=%xmm2,0(<b1b1p=%rcx)
movdqa %xmm2,0(%rcx)

# qhasm: ab1 = *(int128 *)(b1b1p + 16)
# asm 1: movdqa 16(<b1b1p=int64#4),>ab1=int6464#2
# asm 2: movdqa 16(<b1b1p=%rcx),>ab1=%xmm1
movdqa 16(%rcx),%xmm1

# qhasm: cd1 = *(int128 *)(ma1a1p + 16)
# asm 1: movdqa 16(<ma1a1p=int64#5),>cd1=int6464#3
# asm 2: movdqa 16(<ma1a1p=%r8),>cd1=%xmm2
movdqa 16(%r8),%xmm2

# qhasm: ab1six = ab1
# asm 1: movdqa <ab1=int6464#2,>ab1six=int6464#14
# asm 2: movdqa <ab1=%xmm1,>ab1six=%xmm13
movdqa %xmm1,%xmm13

# qhasm: cd1six = cd1
# asm 1: movdqa <cd1=int6464#3,>cd1six=int6464#15
# asm 2: movdqa <cd1=%xmm2,>cd1six=%xmm14
movdqa %xmm2,%xmm14

# qhasm: float6464 ab1six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab1six=int6464#14
# asm 2: mulpd SIX_SIX,<ab1six=%xmm13
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 cd1six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<cd1six=int6464#15
# asm 2: mulpd SIX_SIX,<cd1six=%xmm14
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: t1 = ab1
# asm 1: movdqa <ab1=int6464#2,>t1=int6464#16
# asm 2: movdqa <ab1=%xmm1,>t1=%xmm15
movdqa %xmm1,%xmm15

# qhasm: float6464 t1 *= *(int128 *)(b2a2p + 0)
# asm 1: mulpd 0(<b2a2p=int64#3),<t1=int6464#16
# asm 2: mulpd 0(<b2a2p=%rdx),<t1=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r1 += t1
# asm 1: addpd <t1=int6464#16,<r1=int6464#4
# asm 2: addpd <t1=%xmm15,<r1=%xmm3
addpd %xmm15,%xmm3

# qhasm: d1 = cd1
# asm 1: movdqa <cd1=int6464#3,>d1=int6464#16
# asm 2: movdqa <cd1=%xmm2,>d1=%xmm15
movdqa %xmm2,%xmm15

# qhasm: float6464 d1 *= *(int128 *)(a2b2p + 0)
# asm 1: mulpd 0(<a2b2p=int64#6),<d1=int6464#16
# asm 2: mulpd 0(<a2b2p=%r9),<d1=%xmm15
mulpd 0(%r9),%xmm15

# qhasm: float6464 r1 += d1
# asm 1: addpd <d1=int6464#16,<r1=int6464#4
# asm 2: addpd <d1=%xmm15,<r1=%xmm3
addpd %xmm15,%xmm3

# qhasm: t7 = ab1
# asm 1: movdqa <ab1=int6464#2,>t7=int6464#2
# asm 2: movdqa <ab1=%xmm1,>t7=%xmm1
movdqa %xmm1,%xmm1

# qhasm: float6464 t7 *= *(int128 *)(b2a2p + 96)
# asm 1: mulpd 96(<b2a2p=int64#3),<t7=int6464#2
# asm 2: mulpd 96(<b2a2p=%rdx),<t7=%xmm1
mulpd 96(%rdx),%xmm1

# qhasm: float6464 r7 += t7
# asm 1: addpd <t7=int6464#2,<r7=int6464#10
# asm 2: addpd <t7=%xmm1,<r7=%xmm9
addpd %xmm1,%xmm9

# qhasm: d7 = cd1
# asm 1: movdqa <cd1=int6464#3,>d7=int6464#2
# asm 2: movdqa <cd1=%xmm2,>d7=%xmm1
movdqa %xmm2,%xmm1

# qhasm: float6464 d7 *= *(int128 *)(a2b2p + 96)
# asm 1: mulpd 96(<a2b2p=int64#6),<d7=int6464#2
# asm 2: mulpd 96(<a2b2p=%r9),<d7=%xmm1
mulpd 96(%r9),%xmm1

# qhasm: float6464 r7 += d7
# asm 1: addpd <d7=int6464#2,<r7=int6464#10
# asm 2: addpd <d7=%xmm1,<r7=%xmm9
addpd %xmm1,%xmm9

# qhasm: t2 = ab1six
# asm 1: movdqa <ab1six=int6464#14,>t2=int6464#2
# asm 2: movdqa <ab1six=%xmm13,>t2=%xmm1
movdqa %xmm13,%xmm1

# qhasm: float6464 t2 *= *(int128 *)(b2a2p + 16)
# asm 1: mulpd 16(<b2a2p=int64#3),<t2=int6464#2
# asm 2: mulpd 16(<b2a2p=%rdx),<t2=%xmm1
mulpd 16(%rdx),%xmm1

# qhasm: float6464 r2 += t2
# asm 1: addpd <t2=int6464#2,<r2=int6464#5
# asm 2: addpd <t2=%xmm1,<r2=%xmm4
addpd %xmm1,%xmm4

# qhasm: d2 = cd1six
# asm 1: movdqa <cd1six=int6464#15,>d2=int6464#2
# asm 2: movdqa <cd1six=%xmm14,>d2=%xmm1
movdqa %xmm14,%xmm1

# qhasm: float6464 d2 *= *(int128 *)(a2b2p + 16)
# asm 1: mulpd 16(<a2b2p=int64#6),<d2=int6464#2
# asm 2: mulpd 16(<a2b2p=%r9),<d2=%xmm1
mulpd 16(%r9),%xmm1

# qhasm: float6464 r2 += d2
# asm 1: addpd <d2=int6464#2,<r2=int6464#5
# asm 2: addpd <d2=%xmm1,<r2=%xmm4
addpd %xmm1,%xmm4

# qhasm: t3 = ab1six
# asm 1: movdqa <ab1six=int6464#14,>t3=int6464#2
# asm 2: movdqa <ab1six=%xmm13,>t3=%xmm1
movdqa %xmm13,%xmm1

# qhasm: float6464 t3 *= *(int128 *)(b2a2p + 32)
# asm 1: mulpd 32(<b2a2p=int64#3),<t3=int6464#2
# asm 2: mulpd 32(<b2a2p=%rdx),<t3=%xmm1
mulpd 32(%rdx),%xmm1

# qhasm: float6464 r3 += t3
# asm 1: addpd <t3=int6464#2,<r3=int6464#6
# asm 2: addpd <t3=%xmm1,<r3=%xmm5
addpd %xmm1,%xmm5

# qhasm: d3 = cd1six
# asm 1: movdqa <cd1six=int6464#15,>d3=int6464#2
# asm 2: movdqa <cd1six=%xmm14,>d3=%xmm1
movdqa %xmm14,%xmm1

# qhasm: float6464 d3 *= *(int128 *)(a2b2p + 32)
# asm 1: mulpd 32(<a2b2p=int64#6),<d3=int6464#2
# asm 2: mulpd 32(<a2b2p=%r9),<d3=%xmm1
mulpd 32(%r9),%xmm1

# qhasm: float6464 r3 += d3
# asm 1: addpd <d3=int6464#2,<r3=int6464#6
# asm 2: addpd <d3=%xmm1,<r3=%xmm5
addpd %xmm1,%xmm5

# qhasm: t4 = ab1six
# asm 1: movdqa <ab1six=int6464#14,>t4=int6464#2
# asm 2: movdqa <ab1six=%xmm13,>t4=%xmm1
movdqa %xmm13,%xmm1

# qhasm: float6464 t4 *= *(int128 *)(b2a2p + 48)
# asm 1: mulpd 48(<b2a2p=int64#3),<t4=int6464#2
# asm 2: mulpd 48(<b2a2p=%rdx),<t4=%xmm1
mulpd 48(%rdx),%xmm1

# qhasm: float6464 r4 += t4
# asm 1: addpd <t4=int6464#2,<r4=int6464#7
# asm 2: addpd <t4=%xmm1,<r4=%xmm6
addpd %xmm1,%xmm6

# qhasm: d4 = cd1six
# asm 1: movdqa <cd1six=int6464#15,>d4=int6464#2
# asm 2: movdqa <cd1six=%xmm14,>d4=%xmm1
movdqa %xmm14,%xmm1

# qhasm: float6464 d4 *= *(int128 *)(a2b2p + 48)
# asm 1: mulpd 48(<a2b2p=int64#6),<d4=int6464#2
# asm 2: mulpd 48(<a2b2p=%r9),<d4=%xmm1
mulpd 48(%r9),%xmm1

# qhasm: float6464 r4 += d4
# asm 1: addpd <d4=int6464#2,<r4=int6464#7
# asm 2: addpd <d4=%xmm1,<r4=%xmm6
addpd %xmm1,%xmm6

# qhasm: t5 = ab1six
# asm 1: movdqa <ab1six=int6464#14,>t5=int6464#2
# asm 2: movdqa <ab1six=%xmm13,>t5=%xmm1
movdqa %xmm13,%xmm1

# qhasm: float6464 t5 *= *(int128 *)(b2a2p + 64)
# asm 1: mulpd 64(<b2a2p=int64#3),<t5=int6464#2
# asm 2: mulpd 64(<b2a2p=%rdx),<t5=%xmm1
mulpd 64(%rdx),%xmm1

# qhasm: float6464 r5 += t5
# asm 1: addpd <t5=int6464#2,<r5=int6464#8
# asm 2: addpd <t5=%xmm1,<r5=%xmm7
addpd %xmm1,%xmm7

# qhasm: d5 = cd1six
# asm 1: movdqa <cd1six=int6464#15,>d5=int6464#2
# asm 2: movdqa <cd1six=%xmm14,>d5=%xmm1
movdqa %xmm14,%xmm1

# qhasm: float6464 d5 *= *(int128 *)(a2b2p + 64)
# asm 1: mulpd 64(<a2b2p=int64#6),<d5=int6464#2
# asm 2: mulpd 64(<a2b2p=%r9),<d5=%xmm1
mulpd 64(%r9),%xmm1

# qhasm: float6464 r5 += d5
# asm 1: addpd <d5=int6464#2,<r5=int6464#8
# asm 2: addpd <d5=%xmm1,<r5=%xmm7
addpd %xmm1,%xmm7

# qhasm: t6 = ab1six
# asm 1: movdqa <ab1six=int6464#14,>t6=int6464#2
# asm 2: movdqa <ab1six=%xmm13,>t6=%xmm1
movdqa %xmm13,%xmm1

# qhasm: float6464 t6 *= *(int128 *)(b2a2p + 80)
# asm 1: mulpd 80(<b2a2p=int64#3),<t6=int6464#2
# asm 2: mulpd 80(<b2a2p=%rdx),<t6=%xmm1
mulpd 80(%rdx),%xmm1

# qhasm: float6464 r6 += t6
# asm 1: addpd <t6=int6464#2,<r6=int6464#9
# asm 2: addpd <t6=%xmm1,<r6=%xmm8
addpd %xmm1,%xmm8

# qhasm: d6 = cd1six
# asm 1: movdqa <cd1six=int6464#15,>d6=int6464#2
# asm 2: movdqa <cd1six=%xmm14,>d6=%xmm1
movdqa %xmm14,%xmm1

# qhasm: float6464 d6 *= *(int128 *)(a2b2p + 80)
# asm 1: mulpd 80(<a2b2p=int64#6),<d6=int6464#2
# asm 2: mulpd 80(<a2b2p=%r9),<d6=%xmm1
mulpd 80(%r9),%xmm1

# qhasm: float6464 r6 += d6
# asm 1: addpd <d6=int6464#2,<r6=int6464#9
# asm 2: addpd <d6=%xmm1,<r6=%xmm8
addpd %xmm1,%xmm8

# qhasm: t8 = ab1six
# asm 1: movdqa <ab1six=int6464#14,>t8=int6464#2
# asm 2: movdqa <ab1six=%xmm13,>t8=%xmm1
movdqa %xmm13,%xmm1

# qhasm: float6464 t8 *= *(int128 *)(b2a2p + 112)
# asm 1: mulpd 112(<b2a2p=int64#3),<t8=int6464#2
# asm 2: mulpd 112(<b2a2p=%rdx),<t8=%xmm1
mulpd 112(%rdx),%xmm1

# qhasm: float6464 r8 += t8
# asm 1: addpd <t8=int6464#2,<r8=int6464#11
# asm 2: addpd <t8=%xmm1,<r8=%xmm10
addpd %xmm1,%xmm10

# qhasm: d8 = cd1six
# asm 1: movdqa <cd1six=int6464#15,>d8=int6464#2
# asm 2: movdqa <cd1six=%xmm14,>d8=%xmm1
movdqa %xmm14,%xmm1

# qhasm: float6464 d8 *= *(int128 *)(a2b2p + 112)
# asm 1: mulpd 112(<a2b2p=int64#6),<d8=int6464#2
# asm 2: mulpd 112(<a2b2p=%r9),<d8=%xmm1
mulpd 112(%r9),%xmm1

# qhasm: float6464 r8 += d8
# asm 1: addpd <d8=int6464#2,<r8=int6464#11
# asm 2: addpd <d8=%xmm1,<r8=%xmm10
addpd %xmm1,%xmm10

# qhasm: t9 = ab1six
# asm 1: movdqa <ab1six=int6464#14,>t9=int6464#2
# asm 2: movdqa <ab1six=%xmm13,>t9=%xmm1
movdqa %xmm13,%xmm1

# qhasm: float6464 t9 *= *(int128 *)(b2a2p + 128)
# asm 1: mulpd 128(<b2a2p=int64#3),<t9=int6464#2
# asm 2: mulpd 128(<b2a2p=%rdx),<t9=%xmm1
mulpd 128(%rdx),%xmm1

# qhasm: float6464 r9 += t9
# asm 1: addpd <t9=int6464#2,<r9=int6464#12
# asm 2: addpd <t9=%xmm1,<r9=%xmm11
addpd %xmm1,%xmm11

# qhasm: d9 = cd1six
# asm 1: movdqa <cd1six=int6464#15,>d9=int6464#2
# asm 2: movdqa <cd1six=%xmm14,>d9=%xmm1
movdqa %xmm14,%xmm1

# qhasm: float6464 d9 *= *(int128 *)(a2b2p + 128)
# asm 1: mulpd 128(<a2b2p=int64#6),<d9=int6464#2
# asm 2: mulpd 128(<a2b2p=%r9),<d9=%xmm1
mulpd 128(%r9),%xmm1

# qhasm: float6464 r9 += d9
# asm 1: addpd <d9=int6464#2,<r9=int6464#12
# asm 2: addpd <d9=%xmm1,<r9=%xmm11
addpd %xmm1,%xmm11

# qhasm: t10 = ab1six
# asm 1: movdqa <ab1six=int6464#14,>t10=int6464#2
# asm 2: movdqa <ab1six=%xmm13,>t10=%xmm1
movdqa %xmm13,%xmm1

# qhasm: float6464 t10 *= *(int128 *)(b2a2p + 144)
# asm 1: mulpd 144(<b2a2p=int64#3),<t10=int6464#2
# asm 2: mulpd 144(<b2a2p=%rdx),<t10=%xmm1
mulpd 144(%rdx),%xmm1

# qhasm: float6464 r10 += t10
# asm 1: addpd <t10=int6464#2,<r10=int6464#13
# asm 2: addpd <t10=%xmm1,<r10=%xmm12
addpd %xmm1,%xmm12

# qhasm: d10 = cd1six
# asm 1: movdqa <cd1six=int6464#15,>d10=int6464#2
# asm 2: movdqa <cd1six=%xmm14,>d10=%xmm1
movdqa %xmm14,%xmm1

# qhasm: float6464 d10 *= *(int128 *)(a2b2p + 144)
# asm 1: mulpd 144(<a2b2p=int64#6),<d10=int6464#2
# asm 2: mulpd 144(<a2b2p=%r9),<d10=%xmm1
mulpd 144(%r9),%xmm1

# qhasm: float6464 r10 += d10
# asm 1: addpd <d10=int6464#2,<r10=int6464#13
# asm 2: addpd <d10=%xmm1,<r10=%xmm12
addpd %xmm1,%xmm12

# qhasm: t11 = ab1six
# asm 1: movdqa <ab1six=int6464#14,>t11=int6464#2
# asm 2: movdqa <ab1six=%xmm13,>t11=%xmm1
movdqa %xmm13,%xmm1

# qhasm: float6464 t11 *= *(int128 *)(b2a2p + 160)
# asm 1: mulpd 160(<b2a2p=int64#3),<t11=int6464#2
# asm 2: mulpd 160(<b2a2p=%rdx),<t11=%xmm1
mulpd 160(%rdx),%xmm1

# qhasm: float6464 r11 += t11
# asm 1: addpd <t11=int6464#2,<r11=int6464#1
# asm 2: addpd <t11=%xmm1,<r11=%xmm0
addpd %xmm1,%xmm0

# qhasm: d11 = cd1six
# asm 1: movdqa <cd1six=int6464#15,>d11=int6464#2
# asm 2: movdqa <cd1six=%xmm14,>d11=%xmm1
movdqa %xmm14,%xmm1

# qhasm: float6464 d11 *= *(int128 *)(a2b2p + 160)
# asm 1: mulpd 160(<a2b2p=int64#6),<d11=int6464#2
# asm 2: mulpd 160(<a2b2p=%r9),<d11=%xmm1
mulpd 160(%r9),%xmm1

# qhasm: float6464 r11 += d11
# asm 1: addpd <d11=int6464#2,<r11=int6464#1
# asm 2: addpd <d11=%xmm1,<r11=%xmm0
addpd %xmm1,%xmm0

# qhasm: r12 = ab1six
# asm 1: movdqa <ab1six=int6464#14,>r12=int6464#2
# asm 2: movdqa <ab1six=%xmm13,>r12=%xmm1
movdqa %xmm13,%xmm1

# qhasm: float6464 r12 *= *(int128 *)(b2a2p + 176)
# asm 1: mulpd 176(<b2a2p=int64#3),<r12=int6464#2
# asm 2: mulpd 176(<b2a2p=%rdx),<r12=%xmm1
mulpd 176(%rdx),%xmm1

# qhasm: d12 = cd1six
# asm 1: movdqa <cd1six=int6464#15,>d12=int6464#3
# asm 2: movdqa <cd1six=%xmm14,>d12=%xmm2
movdqa %xmm14,%xmm2

# qhasm: float6464 d12 *= *(int128 *)(a2b2p + 176)
# asm 1: mulpd 176(<a2b2p=int64#6),<d12=int6464#3
# asm 2: mulpd 176(<a2b2p=%r9),<d12=%xmm2
mulpd 176(%r9),%xmm2

# qhasm: float6464 r12 += d12
# asm 1: addpd <d12=int6464#3,<r12=int6464#2
# asm 2: addpd <d12=%xmm2,<r12=%xmm1
addpd %xmm2,%xmm1

# qhasm: *(int128 *)(b1b1p + 16) = r1
# asm 1: movdqa <r1=int6464#4,16(<b1b1p=int64#4)
# asm 2: movdqa <r1=%xmm3,16(<b1b1p=%rcx)
movdqa %xmm3,16(%rcx)

# qhasm: ab2 = *(int128 *)(b1b1p + 32)
# asm 1: movdqa 32(<b1b1p=int64#4),>ab2=int6464#3
# asm 2: movdqa 32(<b1b1p=%rcx),>ab2=%xmm2
movdqa 32(%rcx),%xmm2

# qhasm: cd2 = *(int128 *)(ma1a1p + 32)
# asm 1: movdqa 32(<ma1a1p=int64#5),>cd2=int6464#4
# asm 2: movdqa 32(<ma1a1p=%r8),>cd2=%xmm3
movdqa 32(%r8),%xmm3

# qhasm: ab2six = ab2
# asm 1: movdqa <ab2=int6464#3,>ab2six=int6464#14
# asm 2: movdqa <ab2=%xmm2,>ab2six=%xmm13
movdqa %xmm2,%xmm13

# qhasm: cd2six = cd2
# asm 1: movdqa <cd2=int6464#4,>cd2six=int6464#15
# asm 2: movdqa <cd2=%xmm3,>cd2six=%xmm14
movdqa %xmm3,%xmm14

# qhasm: float6464 ab2six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab2six=int6464#14
# asm 2: mulpd SIX_SIX,<ab2six=%xmm13
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 cd2six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<cd2six=int6464#15
# asm 2: mulpd SIX_SIX,<cd2six=%xmm14
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: t2 = ab2
# asm 1: movdqa <ab2=int6464#3,>t2=int6464#16
# asm 2: movdqa <ab2=%xmm2,>t2=%xmm15
movdqa %xmm2,%xmm15

# qhasm: float6464 t2 *= *(int128 *)(b2a2p + 0)
# asm 1: mulpd 0(<b2a2p=int64#3),<t2=int6464#16
# asm 2: mulpd 0(<b2a2p=%rdx),<t2=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r2 += t2
# asm 1: addpd <t2=int6464#16,<r2=int6464#5
# asm 2: addpd <t2=%xmm15,<r2=%xmm4
addpd %xmm15,%xmm4

# qhasm: d2 = cd2
# asm 1: movdqa <cd2=int6464#4,>d2=int6464#16
# asm 2: movdqa <cd2=%xmm3,>d2=%xmm15
movdqa %xmm3,%xmm15

# qhasm: float6464 d2 *= *(int128 *)(a2b2p + 0)
# asm 1: mulpd 0(<a2b2p=int64#6),<d2=int6464#16
# asm 2: mulpd 0(<a2b2p=%r9),<d2=%xmm15
mulpd 0(%r9),%xmm15

# qhasm: float6464 r2 += d2
# asm 1: addpd <d2=int6464#16,<r2=int6464#5
# asm 2: addpd <d2=%xmm15,<r2=%xmm4
addpd %xmm15,%xmm4

# qhasm: t7 = ab2
# asm 1: movdqa <ab2=int6464#3,>t7=int6464#16
# asm 2: movdqa <ab2=%xmm2,>t7=%xmm15
movdqa %xmm2,%xmm15

# qhasm: float6464 t7 *= *(int128 *)(b2a2p + 80)
# asm 1: mulpd 80(<b2a2p=int64#3),<t7=int6464#16
# asm 2: mulpd 80(<b2a2p=%rdx),<t7=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r7 += t7
# asm 1: addpd <t7=int6464#16,<r7=int6464#10
# asm 2: addpd <t7=%xmm15,<r7=%xmm9
addpd %xmm15,%xmm9

# qhasm: d7 = cd2
# asm 1: movdqa <cd2=int6464#4,>d7=int6464#16
# asm 2: movdqa <cd2=%xmm3,>d7=%xmm15
movdqa %xmm3,%xmm15

# qhasm: float6464 d7 *= *(int128 *)(a2b2p + 80)
# asm 1: mulpd 80(<a2b2p=int64#6),<d7=int6464#16
# asm 2: mulpd 80(<a2b2p=%r9),<d7=%xmm15
mulpd 80(%r9),%xmm15

# qhasm: float6464 r7 += d7
# asm 1: addpd <d7=int6464#16,<r7=int6464#10
# asm 2: addpd <d7=%xmm15,<r7=%xmm9
addpd %xmm15,%xmm9

# qhasm: t8 = ab2
# asm 1: movdqa <ab2=int6464#3,>t8=int6464#16
# asm 2: movdqa <ab2=%xmm2,>t8=%xmm15
movdqa %xmm2,%xmm15

# qhasm: float6464 t8 *= *(int128 *)(b2a2p + 96)
# asm 1: mulpd 96(<b2a2p=int64#3),<t8=int6464#16
# asm 2: mulpd 96(<b2a2p=%rdx),<t8=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r8 += t8
# asm 1: addpd <t8=int6464#16,<r8=int6464#11
# asm 2: addpd <t8=%xmm15,<r8=%xmm10
addpd %xmm15,%xmm10

# qhasm: d8 = cd2
# asm 1: movdqa <cd2=int6464#4,>d8=int6464#16
# asm 2: movdqa <cd2=%xmm3,>d8=%xmm15
movdqa %xmm3,%xmm15

# qhasm: float6464 d8 *= *(int128 *)(a2b2p + 96)
# asm 1: mulpd 96(<a2b2p=int64#6),<d8=int6464#16
# asm 2: mulpd 96(<a2b2p=%r9),<d8=%xmm15
mulpd 96(%r9),%xmm15

# qhasm: float6464 r8 += d8
# asm 1: addpd <d8=int6464#16,<r8=int6464#11
# asm 2: addpd <d8=%xmm15,<r8=%xmm10
addpd %xmm15,%xmm10

# qhasm: r13 = ab2
# asm 1: movdqa <ab2=int6464#3,>r13=int6464#3
# asm 2: movdqa <ab2=%xmm2,>r13=%xmm2
movdqa %xmm2,%xmm2

# qhasm: float6464 r13 *= *(int128 *)(b2a2p + 176)
# asm 1: mulpd 176(<b2a2p=int64#3),<r13=int6464#3
# asm 2: mulpd 176(<b2a2p=%rdx),<r13=%xmm2
mulpd 176(%rdx),%xmm2

# qhasm: d13 = cd2
# asm 1: movdqa <cd2=int6464#4,>d13=int6464#4
# asm 2: movdqa <cd2=%xmm3,>d13=%xmm3
movdqa %xmm3,%xmm3

# qhasm: float6464 d13 *= *(int128 *)(a2b2p + 176)
# asm 1: mulpd 176(<a2b2p=int64#6),<d13=int6464#4
# asm 2: mulpd 176(<a2b2p=%r9),<d13=%xmm3
mulpd 176(%r9),%xmm3

# qhasm: float6464 r13 += d13
# asm 1: addpd <d13=int6464#4,<r13=int6464#3
# asm 2: addpd <d13=%xmm3,<r13=%xmm2
addpd %xmm3,%xmm2

# qhasm: t3 = ab2six
# asm 1: movdqa <ab2six=int6464#14,>t3=int6464#4
# asm 2: movdqa <ab2six=%xmm13,>t3=%xmm3
movdqa %xmm13,%xmm3

# qhasm: float6464 t3 *= *(int128 *)(b2a2p + 16)
# asm 1: mulpd 16(<b2a2p=int64#3),<t3=int6464#4
# asm 2: mulpd 16(<b2a2p=%rdx),<t3=%xmm3
mulpd 16(%rdx),%xmm3

# qhasm: float6464 r3 += t3
# asm 1: addpd <t3=int6464#4,<r3=int6464#6
# asm 2: addpd <t3=%xmm3,<r3=%xmm5
addpd %xmm3,%xmm5

# qhasm: d3 = cd2six
# asm 1: movdqa <cd2six=int6464#15,>d3=int6464#4
# asm 2: movdqa <cd2six=%xmm14,>d3=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 d3 *= *(int128 *)(a2b2p + 16)
# asm 1: mulpd 16(<a2b2p=int64#6),<d3=int6464#4
# asm 2: mulpd 16(<a2b2p=%r9),<d3=%xmm3
mulpd 16(%r9),%xmm3

# qhasm: float6464 r3 += d3
# asm 1: addpd <d3=int6464#4,<r3=int6464#6
# asm 2: addpd <d3=%xmm3,<r3=%xmm5
addpd %xmm3,%xmm5

# qhasm: t4 = ab2six
# asm 1: movdqa <ab2six=int6464#14,>t4=int6464#4
# asm 2: movdqa <ab2six=%xmm13,>t4=%xmm3
movdqa %xmm13,%xmm3

# qhasm: float6464 t4 *= *(int128 *)(b2a2p + 32)
# asm 1: mulpd 32(<b2a2p=int64#3),<t4=int6464#4
# asm 2: mulpd 32(<b2a2p=%rdx),<t4=%xmm3
mulpd 32(%rdx),%xmm3

# qhasm: float6464 r4 += t4
# asm 1: addpd <t4=int6464#4,<r4=int6464#7
# asm 2: addpd <t4=%xmm3,<r4=%xmm6
addpd %xmm3,%xmm6

# qhasm: d4 = cd2six
# asm 1: movdqa <cd2six=int6464#15,>d4=int6464#4
# asm 2: movdqa <cd2six=%xmm14,>d4=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 d4 *= *(int128 *)(a2b2p + 32)
# asm 1: mulpd 32(<a2b2p=int64#6),<d4=int6464#4
# asm 2: mulpd 32(<a2b2p=%r9),<d4=%xmm3
mulpd 32(%r9),%xmm3

# qhasm: float6464 r4 += d4
# asm 1: addpd <d4=int6464#4,<r4=int6464#7
# asm 2: addpd <d4=%xmm3,<r4=%xmm6
addpd %xmm3,%xmm6

# qhasm: t5 = ab2six
# asm 1: movdqa <ab2six=int6464#14,>t5=int6464#4
# asm 2: movdqa <ab2six=%xmm13,>t5=%xmm3
movdqa %xmm13,%xmm3

# qhasm: float6464 t5 *= *(int128 *)(b2a2p + 48)
# asm 1: mulpd 48(<b2a2p=int64#3),<t5=int6464#4
# asm 2: mulpd 48(<b2a2p=%rdx),<t5=%xmm3
mulpd 48(%rdx),%xmm3

# qhasm: float6464 r5 += t5
# asm 1: addpd <t5=int6464#4,<r5=int6464#8
# asm 2: addpd <t5=%xmm3,<r5=%xmm7
addpd %xmm3,%xmm7

# qhasm: d5 = cd2six
# asm 1: movdqa <cd2six=int6464#15,>d5=int6464#4
# asm 2: movdqa <cd2six=%xmm14,>d5=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 d5 *= *(int128 *)(a2b2p + 48)
# asm 1: mulpd 48(<a2b2p=int64#6),<d5=int6464#4
# asm 2: mulpd 48(<a2b2p=%r9),<d5=%xmm3
mulpd 48(%r9),%xmm3

# qhasm: float6464 r5 += d5
# asm 1: addpd <d5=int6464#4,<r5=int6464#8
# asm 2: addpd <d5=%xmm3,<r5=%xmm7
addpd %xmm3,%xmm7

# qhasm: t6 = ab2six
# asm 1: movdqa <ab2six=int6464#14,>t6=int6464#4
# asm 2: movdqa <ab2six=%xmm13,>t6=%xmm3
movdqa %xmm13,%xmm3

# qhasm: float6464 t6 *= *(int128 *)(b2a2p + 64)
# asm 1: mulpd 64(<b2a2p=int64#3),<t6=int6464#4
# asm 2: mulpd 64(<b2a2p=%rdx),<t6=%xmm3
mulpd 64(%rdx),%xmm3

# qhasm: float6464 r6 += t6
# asm 1: addpd <t6=int6464#4,<r6=int6464#9
# asm 2: addpd <t6=%xmm3,<r6=%xmm8
addpd %xmm3,%xmm8

# qhasm: d6 = cd2six
# asm 1: movdqa <cd2six=int6464#15,>d6=int6464#4
# asm 2: movdqa <cd2six=%xmm14,>d6=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 d6 *= *(int128 *)(a2b2p + 64)
# asm 1: mulpd 64(<a2b2p=int64#6),<d6=int6464#4
# asm 2: mulpd 64(<a2b2p=%r9),<d6=%xmm3
mulpd 64(%r9),%xmm3

# qhasm: float6464 r6 += d6
# asm 1: addpd <d6=int6464#4,<r6=int6464#9
# asm 2: addpd <d6=%xmm3,<r6=%xmm8
addpd %xmm3,%xmm8

# qhasm: t9 = ab2six
# asm 1: movdqa <ab2six=int6464#14,>t9=int6464#4
# asm 2: movdqa <ab2six=%xmm13,>t9=%xmm3
movdqa %xmm13,%xmm3

# qhasm: float6464 t9 *= *(int128 *)(b2a2p + 112)
# asm 1: mulpd 112(<b2a2p=int64#3),<t9=int6464#4
# asm 2: mulpd 112(<b2a2p=%rdx),<t9=%xmm3
mulpd 112(%rdx),%xmm3

# qhasm: float6464 r9 += t9
# asm 1: addpd <t9=int6464#4,<r9=int6464#12
# asm 2: addpd <t9=%xmm3,<r9=%xmm11
addpd %xmm3,%xmm11

# qhasm: d9 = cd2six
# asm 1: movdqa <cd2six=int6464#15,>d9=int6464#4
# asm 2: movdqa <cd2six=%xmm14,>d9=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 d9 *= *(int128 *)(a2b2p + 112)
# asm 1: mulpd 112(<a2b2p=int64#6),<d9=int6464#4
# asm 2: mulpd 112(<a2b2p=%r9),<d9=%xmm3
mulpd 112(%r9),%xmm3

# qhasm: float6464 r9 += d9
# asm 1: addpd <d9=int6464#4,<r9=int6464#12
# asm 2: addpd <d9=%xmm3,<r9=%xmm11
addpd %xmm3,%xmm11

# qhasm: t10 = ab2six
# asm 1: movdqa <ab2six=int6464#14,>t10=int6464#4
# asm 2: movdqa <ab2six=%xmm13,>t10=%xmm3
movdqa %xmm13,%xmm3

# qhasm: float6464 t10 *= *(int128 *)(b2a2p + 128)
# asm 1: mulpd 128(<b2a2p=int64#3),<t10=int6464#4
# asm 2: mulpd 128(<b2a2p=%rdx),<t10=%xmm3
mulpd 128(%rdx),%xmm3

# qhasm: float6464 r10 += t10
# asm 1: addpd <t10=int6464#4,<r10=int6464#13
# asm 2: addpd <t10=%xmm3,<r10=%xmm12
addpd %xmm3,%xmm12

# qhasm: d10 = cd2six
# asm 1: movdqa <cd2six=int6464#15,>d10=int6464#4
# asm 2: movdqa <cd2six=%xmm14,>d10=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 d10 *= *(int128 *)(a2b2p + 128)
# asm 1: mulpd 128(<a2b2p=int64#6),<d10=int6464#4
# asm 2: mulpd 128(<a2b2p=%r9),<d10=%xmm3
mulpd 128(%r9),%xmm3

# qhasm: float6464 r10 += d10
# asm 1: addpd <d10=int6464#4,<r10=int6464#13
# asm 2: addpd <d10=%xmm3,<r10=%xmm12
addpd %xmm3,%xmm12

# qhasm: t11 = ab2six
# asm 1: movdqa <ab2six=int6464#14,>t11=int6464#4
# asm 2: movdqa <ab2six=%xmm13,>t11=%xmm3
movdqa %xmm13,%xmm3

# qhasm: float6464 t11 *= *(int128 *)(b2a2p + 144)
# asm 1: mulpd 144(<b2a2p=int64#3),<t11=int6464#4
# asm 2: mulpd 144(<b2a2p=%rdx),<t11=%xmm3
mulpd 144(%rdx),%xmm3

# qhasm: float6464 r11 += t11
# asm 1: addpd <t11=int6464#4,<r11=int6464#1
# asm 2: addpd <t11=%xmm3,<r11=%xmm0
addpd %xmm3,%xmm0

# qhasm: d11 = cd2six
# asm 1: movdqa <cd2six=int6464#15,>d11=int6464#4
# asm 2: movdqa <cd2six=%xmm14,>d11=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 d11 *= *(int128 *)(a2b2p + 144)
# asm 1: mulpd 144(<a2b2p=int64#6),<d11=int6464#4
# asm 2: mulpd 144(<a2b2p=%r9),<d11=%xmm3
mulpd 144(%r9),%xmm3

# qhasm: float6464 r11 += d11
# asm 1: addpd <d11=int6464#4,<r11=int6464#1
# asm 2: addpd <d11=%xmm3,<r11=%xmm0
addpd %xmm3,%xmm0

# qhasm: t12 = ab2six
# asm 1: movdqa <ab2six=int6464#14,>t12=int6464#4
# asm 2: movdqa <ab2six=%xmm13,>t12=%xmm3
movdqa %xmm13,%xmm3

# qhasm: float6464 t12 *= *(int128 *)(b2a2p + 160)
# asm 1: mulpd 160(<b2a2p=int64#3),<t12=int6464#4
# asm 2: mulpd 160(<b2a2p=%rdx),<t12=%xmm3
mulpd 160(%rdx),%xmm3

# qhasm: float6464 r12 += t12
# asm 1: addpd <t12=int6464#4,<r12=int6464#2
# asm 2: addpd <t12=%xmm3,<r12=%xmm1
addpd %xmm3,%xmm1

# qhasm: d12 = cd2six
# asm 1: movdqa <cd2six=int6464#15,>d12=int6464#4
# asm 2: movdqa <cd2six=%xmm14,>d12=%xmm3
movdqa %xmm14,%xmm3

# qhasm: float6464 d12 *= *(int128 *)(a2b2p + 160)
# asm 1: mulpd 160(<a2b2p=int64#6),<d12=int6464#4
# asm 2: mulpd 160(<a2b2p=%r9),<d12=%xmm3
mulpd 160(%r9),%xmm3

# qhasm: float6464 r12 += d12
# asm 1: addpd <d12=int6464#4,<r12=int6464#2
# asm 2: addpd <d12=%xmm3,<r12=%xmm1
addpd %xmm3,%xmm1

# qhasm: *(int128 *)(b1b1p + 32) = r2
# asm 1: movdqa <r2=int6464#5,32(<b1b1p=int64#4)
# asm 2: movdqa <r2=%xmm4,32(<b1b1p=%rcx)
movdqa %xmm4,32(%rcx)

# qhasm: ab3 = *(int128 *)(b1b1p + 48)
# asm 1: movdqa 48(<b1b1p=int64#4),>ab3=int6464#4
# asm 2: movdqa 48(<b1b1p=%rcx),>ab3=%xmm3
movdqa 48(%rcx),%xmm3

# qhasm: cd3 = *(int128 *)(ma1a1p + 48)
# asm 1: movdqa 48(<ma1a1p=int64#5),>cd3=int6464#5
# asm 2: movdqa 48(<ma1a1p=%r8),>cd3=%xmm4
movdqa 48(%r8),%xmm4

# qhasm: ab3six = ab3
# asm 1: movdqa <ab3=int6464#4,>ab3six=int6464#14
# asm 2: movdqa <ab3=%xmm3,>ab3six=%xmm13
movdqa %xmm3,%xmm13

# qhasm: cd3six = cd3
# asm 1: movdqa <cd3=int6464#5,>cd3six=int6464#15
# asm 2: movdqa <cd3=%xmm4,>cd3six=%xmm14
movdqa %xmm4,%xmm14

# qhasm: float6464 ab3six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab3six=int6464#14
# asm 2: mulpd SIX_SIX,<ab3six=%xmm13
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 cd3six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<cd3six=int6464#15
# asm 2: mulpd SIX_SIX,<cd3six=%xmm14
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: t3 = ab3
# asm 1: movdqa <ab3=int6464#4,>t3=int6464#16
# asm 2: movdqa <ab3=%xmm3,>t3=%xmm15
movdqa %xmm3,%xmm15

# qhasm: float6464 t3 *= *(int128 *)(b2a2p + 0)
# asm 1: mulpd 0(<b2a2p=int64#3),<t3=int6464#16
# asm 2: mulpd 0(<b2a2p=%rdx),<t3=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r3 += t3
# asm 1: addpd <t3=int6464#16,<r3=int6464#6
# asm 2: addpd <t3=%xmm15,<r3=%xmm5
addpd %xmm15,%xmm5

# qhasm: d3 = cd3
# asm 1: movdqa <cd3=int6464#5,>d3=int6464#16
# asm 2: movdqa <cd3=%xmm4,>d3=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 d3 *= *(int128 *)(a2b2p + 0)
# asm 1: mulpd 0(<a2b2p=int64#6),<d3=int6464#16
# asm 2: mulpd 0(<a2b2p=%r9),<d3=%xmm15
mulpd 0(%r9),%xmm15

# qhasm: float6464 r3 += d3
# asm 1: addpd <d3=int6464#16,<r3=int6464#6
# asm 2: addpd <d3=%xmm15,<r3=%xmm5
addpd %xmm15,%xmm5

# qhasm: t7 = ab3
# asm 1: movdqa <ab3=int6464#4,>t7=int6464#16
# asm 2: movdqa <ab3=%xmm3,>t7=%xmm15
movdqa %xmm3,%xmm15

# qhasm: float6464 t7 *= *(int128 *)(b2a2p + 64)
# asm 1: mulpd 64(<b2a2p=int64#3),<t7=int6464#16
# asm 2: mulpd 64(<b2a2p=%rdx),<t7=%xmm15
mulpd 64(%rdx),%xmm15

# qhasm: float6464 r7 += t7
# asm 1: addpd <t7=int6464#16,<r7=int6464#10
# asm 2: addpd <t7=%xmm15,<r7=%xmm9
addpd %xmm15,%xmm9

# qhasm: d7 = cd3
# asm 1: movdqa <cd3=int6464#5,>d7=int6464#16
# asm 2: movdqa <cd3=%xmm4,>d7=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 d7 *= *(int128 *)(a2b2p + 64)
# asm 1: mulpd 64(<a2b2p=int64#6),<d7=int6464#16
# asm 2: mulpd 64(<a2b2p=%r9),<d7=%xmm15
mulpd 64(%r9),%xmm15

# qhasm: float6464 r7 += d7
# asm 1: addpd <d7=int6464#16,<r7=int6464#10
# asm 2: addpd <d7=%xmm15,<r7=%xmm9
addpd %xmm15,%xmm9

# qhasm: t8 = ab3
# asm 1: movdqa <ab3=int6464#4,>t8=int6464#16
# asm 2: movdqa <ab3=%xmm3,>t8=%xmm15
movdqa %xmm3,%xmm15

# qhasm: float6464 t8 *= *(int128 *)(b2a2p + 80)
# asm 1: mulpd 80(<b2a2p=int64#3),<t8=int6464#16
# asm 2: mulpd 80(<b2a2p=%rdx),<t8=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r8 += t8
# asm 1: addpd <t8=int6464#16,<r8=int6464#11
# asm 2: addpd <t8=%xmm15,<r8=%xmm10
addpd %xmm15,%xmm10

# qhasm: d8 = cd3
# asm 1: movdqa <cd3=int6464#5,>d8=int6464#16
# asm 2: movdqa <cd3=%xmm4,>d8=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 d8 *= *(int128 *)(a2b2p + 80)
# asm 1: mulpd 80(<a2b2p=int64#6),<d8=int6464#16
# asm 2: mulpd 80(<a2b2p=%r9),<d8=%xmm15
mulpd 80(%r9),%xmm15

# qhasm: float6464 r8 += d8
# asm 1: addpd <d8=int6464#16,<r8=int6464#11
# asm 2: addpd <d8=%xmm15,<r8=%xmm10
addpd %xmm15,%xmm10

# qhasm: t9 = ab3
# asm 1: movdqa <ab3=int6464#4,>t9=int6464#16
# asm 2: movdqa <ab3=%xmm3,>t9=%xmm15
movdqa %xmm3,%xmm15

# qhasm: float6464 t9 *= *(int128 *)(b2a2p + 96)
# asm 1: mulpd 96(<b2a2p=int64#3),<t9=int6464#16
# asm 2: mulpd 96(<b2a2p=%rdx),<t9=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r9 += t9
# asm 1: addpd <t9=int6464#16,<r9=int6464#12
# asm 2: addpd <t9=%xmm15,<r9=%xmm11
addpd %xmm15,%xmm11

# qhasm: d9 = cd3
# asm 1: movdqa <cd3=int6464#5,>d9=int6464#16
# asm 2: movdqa <cd3=%xmm4,>d9=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 d9 *= *(int128 *)(a2b2p + 96)
# asm 1: mulpd 96(<a2b2p=int64#6),<d9=int6464#16
# asm 2: mulpd 96(<a2b2p=%r9),<d9=%xmm15
mulpd 96(%r9),%xmm15

# qhasm: float6464 r9 += d9
# asm 1: addpd <d9=int6464#16,<r9=int6464#12
# asm 2: addpd <d9=%xmm15,<r9=%xmm11
addpd %xmm15,%xmm11

# qhasm: t13 = ab3
# asm 1: movdqa <ab3=int6464#4,>t13=int6464#16
# asm 2: movdqa <ab3=%xmm3,>t13=%xmm15
movdqa %xmm3,%xmm15

# qhasm: float6464 t13 *= *(int128 *)(b2a2p + 160)
# asm 1: mulpd 160(<b2a2p=int64#3),<t13=int6464#16
# asm 2: mulpd 160(<b2a2p=%rdx),<t13=%xmm15
mulpd 160(%rdx),%xmm15

# qhasm: float6464 r13 += t13
# asm 1: addpd <t13=int6464#16,<r13=int6464#3
# asm 2: addpd <t13=%xmm15,<r13=%xmm2
addpd %xmm15,%xmm2

# qhasm: d13 = cd3
# asm 1: movdqa <cd3=int6464#5,>d13=int6464#16
# asm 2: movdqa <cd3=%xmm4,>d13=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 d13 *= *(int128 *)(a2b2p + 160)
# asm 1: mulpd 160(<a2b2p=int64#6),<d13=int6464#16
# asm 2: mulpd 160(<a2b2p=%r9),<d13=%xmm15
mulpd 160(%r9),%xmm15

# qhasm: float6464 r13 += d13
# asm 1: addpd <d13=int6464#16,<r13=int6464#3
# asm 2: addpd <d13=%xmm15,<r13=%xmm2
addpd %xmm15,%xmm2

# qhasm: r14 = ab3
# asm 1: movdqa <ab3=int6464#4,>r14=int6464#4
# asm 2: movdqa <ab3=%xmm3,>r14=%xmm3
movdqa %xmm3,%xmm3

# qhasm: float6464 r14 *= *(int128 *)(b2a2p + 176)
# asm 1: mulpd 176(<b2a2p=int64#3),<r14=int6464#4
# asm 2: mulpd 176(<b2a2p=%rdx),<r14=%xmm3
mulpd 176(%rdx),%xmm3

# qhasm: d14 = cd3
# asm 1: movdqa <cd3=int6464#5,>d14=int6464#5
# asm 2: movdqa <cd3=%xmm4,>d14=%xmm4
movdqa %xmm4,%xmm4

# qhasm: float6464 d14 *= *(int128 *)(a2b2p + 176)
# asm 1: mulpd 176(<a2b2p=int64#6),<d14=int6464#5
# asm 2: mulpd 176(<a2b2p=%r9),<d14=%xmm4
mulpd 176(%r9),%xmm4

# qhasm: float6464 r14 += d14
# asm 1: addpd <d14=int6464#5,<r14=int6464#4
# asm 2: addpd <d14=%xmm4,<r14=%xmm3
addpd %xmm4,%xmm3

# qhasm: t4 = ab3six
# asm 1: movdqa <ab3six=int6464#14,>t4=int6464#5
# asm 2: movdqa <ab3six=%xmm13,>t4=%xmm4
movdqa %xmm13,%xmm4

# qhasm: float6464 t4 *= *(int128 *)(b2a2p + 16)
# asm 1: mulpd 16(<b2a2p=int64#3),<t4=int6464#5
# asm 2: mulpd 16(<b2a2p=%rdx),<t4=%xmm4
mulpd 16(%rdx),%xmm4

# qhasm: float6464 r4 += t4
# asm 1: addpd <t4=int6464#5,<r4=int6464#7
# asm 2: addpd <t4=%xmm4,<r4=%xmm6
addpd %xmm4,%xmm6

# qhasm: d4 = cd3six
# asm 1: movdqa <cd3six=int6464#15,>d4=int6464#5
# asm 2: movdqa <cd3six=%xmm14,>d4=%xmm4
movdqa %xmm14,%xmm4

# qhasm: float6464 d4 *= *(int128 *)(a2b2p + 16)
# asm 1: mulpd 16(<a2b2p=int64#6),<d4=int6464#5
# asm 2: mulpd 16(<a2b2p=%r9),<d4=%xmm4
mulpd 16(%r9),%xmm4

# qhasm: float6464 r4 += d4
# asm 1: addpd <d4=int6464#5,<r4=int6464#7
# asm 2: addpd <d4=%xmm4,<r4=%xmm6
addpd %xmm4,%xmm6

# qhasm: t5 = ab3six
# asm 1: movdqa <ab3six=int6464#14,>t5=int6464#5
# asm 2: movdqa <ab3six=%xmm13,>t5=%xmm4
movdqa %xmm13,%xmm4

# qhasm: float6464 t5 *= *(int128 *)(b2a2p + 32)
# asm 1: mulpd 32(<b2a2p=int64#3),<t5=int6464#5
# asm 2: mulpd 32(<b2a2p=%rdx),<t5=%xmm4
mulpd 32(%rdx),%xmm4

# qhasm: float6464 r5 += t5
# asm 1: addpd <t5=int6464#5,<r5=int6464#8
# asm 2: addpd <t5=%xmm4,<r5=%xmm7
addpd %xmm4,%xmm7

# qhasm: d5 = cd3six
# asm 1: movdqa <cd3six=int6464#15,>d5=int6464#5
# asm 2: movdqa <cd3six=%xmm14,>d5=%xmm4
movdqa %xmm14,%xmm4

# qhasm: float6464 d5 *= *(int128 *)(a2b2p + 32)
# asm 1: mulpd 32(<a2b2p=int64#6),<d5=int6464#5
# asm 2: mulpd 32(<a2b2p=%r9),<d5=%xmm4
mulpd 32(%r9),%xmm4

# qhasm: float6464 r5 += d5
# asm 1: addpd <d5=int6464#5,<r5=int6464#8
# asm 2: addpd <d5=%xmm4,<r5=%xmm7
addpd %xmm4,%xmm7

# qhasm: t6 = ab3six
# asm 1: movdqa <ab3six=int6464#14,>t6=int6464#5
# asm 2: movdqa <ab3six=%xmm13,>t6=%xmm4
movdqa %xmm13,%xmm4

# qhasm: float6464 t6 *= *(int128 *)(b2a2p + 48)
# asm 1: mulpd 48(<b2a2p=int64#3),<t6=int6464#5
# asm 2: mulpd 48(<b2a2p=%rdx),<t6=%xmm4
mulpd 48(%rdx),%xmm4

# qhasm: float6464 r6 += t6
# asm 1: addpd <t6=int6464#5,<r6=int6464#9
# asm 2: addpd <t6=%xmm4,<r6=%xmm8
addpd %xmm4,%xmm8

# qhasm: d6 = cd3six
# asm 1: movdqa <cd3six=int6464#15,>d6=int6464#5
# asm 2: movdqa <cd3six=%xmm14,>d6=%xmm4
movdqa %xmm14,%xmm4

# qhasm: float6464 d6 *= *(int128 *)(a2b2p + 48)
# asm 1: mulpd 48(<a2b2p=int64#6),<d6=int6464#5
# asm 2: mulpd 48(<a2b2p=%r9),<d6=%xmm4
mulpd 48(%r9),%xmm4

# qhasm: float6464 r6 += d6
# asm 1: addpd <d6=int6464#5,<r6=int6464#9
# asm 2: addpd <d6=%xmm4,<r6=%xmm8
addpd %xmm4,%xmm8

# qhasm: t10 = ab3six
# asm 1: movdqa <ab3six=int6464#14,>t10=int6464#5
# asm 2: movdqa <ab3six=%xmm13,>t10=%xmm4
movdqa %xmm13,%xmm4

# qhasm: float6464 t10 *= *(int128 *)(b2a2p + 112)
# asm 1: mulpd 112(<b2a2p=int64#3),<t10=int6464#5
# asm 2: mulpd 112(<b2a2p=%rdx),<t10=%xmm4
mulpd 112(%rdx),%xmm4

# qhasm: float6464 r10 += t10
# asm 1: addpd <t10=int6464#5,<r10=int6464#13
# asm 2: addpd <t10=%xmm4,<r10=%xmm12
addpd %xmm4,%xmm12

# qhasm: d10 = cd3six
# asm 1: movdqa <cd3six=int6464#15,>d10=int6464#5
# asm 2: movdqa <cd3six=%xmm14,>d10=%xmm4
movdqa %xmm14,%xmm4

# qhasm: float6464 d10 *= *(int128 *)(a2b2p + 112)
# asm 1: mulpd 112(<a2b2p=int64#6),<d10=int6464#5
# asm 2: mulpd 112(<a2b2p=%r9),<d10=%xmm4
mulpd 112(%r9),%xmm4

# qhasm: float6464 r10 += d10
# asm 1: addpd <d10=int6464#5,<r10=int6464#13
# asm 2: addpd <d10=%xmm4,<r10=%xmm12
addpd %xmm4,%xmm12

# qhasm: t11 = ab3six
# asm 1: movdqa <ab3six=int6464#14,>t11=int6464#5
# asm 2: movdqa <ab3six=%xmm13,>t11=%xmm4
movdqa %xmm13,%xmm4

# qhasm: float6464 t11 *= *(int128 *)(b2a2p + 128)
# asm 1: mulpd 128(<b2a2p=int64#3),<t11=int6464#5
# asm 2: mulpd 128(<b2a2p=%rdx),<t11=%xmm4
mulpd 128(%rdx),%xmm4

# qhasm: float6464 r11 += t11
# asm 1: addpd <t11=int6464#5,<r11=int6464#1
# asm 2: addpd <t11=%xmm4,<r11=%xmm0
addpd %xmm4,%xmm0

# qhasm: d11 = cd3six
# asm 1: movdqa <cd3six=int6464#15,>d11=int6464#5
# asm 2: movdqa <cd3six=%xmm14,>d11=%xmm4
movdqa %xmm14,%xmm4

# qhasm: float6464 d11 *= *(int128 *)(a2b2p + 128)
# asm 1: mulpd 128(<a2b2p=int64#6),<d11=int6464#5
# asm 2: mulpd 128(<a2b2p=%r9),<d11=%xmm4
mulpd 128(%r9),%xmm4

# qhasm: float6464 r11 += d11
# asm 1: addpd <d11=int6464#5,<r11=int6464#1
# asm 2: addpd <d11=%xmm4,<r11=%xmm0
addpd %xmm4,%xmm0

# qhasm: t12 = ab3six
# asm 1: movdqa <ab3six=int6464#14,>t12=int6464#5
# asm 2: movdqa <ab3six=%xmm13,>t12=%xmm4
movdqa %xmm13,%xmm4

# qhasm: float6464 t12 *= *(int128 *)(b2a2p + 144)
# asm 1: mulpd 144(<b2a2p=int64#3),<t12=int6464#5
# asm 2: mulpd 144(<b2a2p=%rdx),<t12=%xmm4
mulpd 144(%rdx),%xmm4

# qhasm: float6464 r12 += t12
# asm 1: addpd <t12=int6464#5,<r12=int6464#2
# asm 2: addpd <t12=%xmm4,<r12=%xmm1
addpd %xmm4,%xmm1

# qhasm: d12 = cd3six
# asm 1: movdqa <cd3six=int6464#15,>d12=int6464#5
# asm 2: movdqa <cd3six=%xmm14,>d12=%xmm4
movdqa %xmm14,%xmm4

# qhasm: float6464 d12 *= *(int128 *)(a2b2p + 144)
# asm 1: mulpd 144(<a2b2p=int64#6),<d12=int6464#5
# asm 2: mulpd 144(<a2b2p=%r9),<d12=%xmm4
mulpd 144(%r9),%xmm4

# qhasm: float6464 r12 += d12
# asm 1: addpd <d12=int6464#5,<r12=int6464#2
# asm 2: addpd <d12=%xmm4,<r12=%xmm1
addpd %xmm4,%xmm1

# qhasm: *(int128 *)(b1b1p + 48) = r3
# asm 1: movdqa <r3=int6464#6,48(<b1b1p=int64#4)
# asm 2: movdqa <r3=%xmm5,48(<b1b1p=%rcx)
movdqa %xmm5,48(%rcx)

# qhasm: ab4 = *(int128 *)(b1b1p + 64)
# asm 1: movdqa 64(<b1b1p=int64#4),>ab4=int6464#5
# asm 2: movdqa 64(<b1b1p=%rcx),>ab4=%xmm4
movdqa 64(%rcx),%xmm4

# qhasm: cd4 = *(int128 *)(ma1a1p + 64)
# asm 1: movdqa 64(<ma1a1p=int64#5),>cd4=int6464#6
# asm 2: movdqa 64(<ma1a1p=%r8),>cd4=%xmm5
movdqa 64(%r8),%xmm5

# qhasm: ab4six = ab4
# asm 1: movdqa <ab4=int6464#5,>ab4six=int6464#14
# asm 2: movdqa <ab4=%xmm4,>ab4six=%xmm13
movdqa %xmm4,%xmm13

# qhasm: cd4six = cd4
# asm 1: movdqa <cd4=int6464#6,>cd4six=int6464#15
# asm 2: movdqa <cd4=%xmm5,>cd4six=%xmm14
movdqa %xmm5,%xmm14

# qhasm: float6464 ab4six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab4six=int6464#14
# asm 2: mulpd SIX_SIX,<ab4six=%xmm13
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 cd4six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<cd4six=int6464#15
# asm 2: mulpd SIX_SIX,<cd4six=%xmm14
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: t4 = ab4
# asm 1: movdqa <ab4=int6464#5,>t4=int6464#16
# asm 2: movdqa <ab4=%xmm4,>t4=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t4 *= *(int128 *)(b2a2p + 0)
# asm 1: mulpd 0(<b2a2p=int64#3),<t4=int6464#16
# asm 2: mulpd 0(<b2a2p=%rdx),<t4=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r4 += t4
# asm 1: addpd <t4=int6464#16,<r4=int6464#7
# asm 2: addpd <t4=%xmm15,<r4=%xmm6
addpd %xmm15,%xmm6

# qhasm: d4 = cd4
# asm 1: movdqa <cd4=int6464#6,>d4=int6464#16
# asm 2: movdqa <cd4=%xmm5,>d4=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 d4 *= *(int128 *)(a2b2p + 0)
# asm 1: mulpd 0(<a2b2p=int64#6),<d4=int6464#16
# asm 2: mulpd 0(<a2b2p=%r9),<d4=%xmm15
mulpd 0(%r9),%xmm15

# qhasm: float6464 r4 += d4
# asm 1: addpd <d4=int6464#16,<r4=int6464#7
# asm 2: addpd <d4=%xmm15,<r4=%xmm6
addpd %xmm15,%xmm6

# qhasm: t7 = ab4
# asm 1: movdqa <ab4=int6464#5,>t7=int6464#16
# asm 2: movdqa <ab4=%xmm4,>t7=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t7 *= *(int128 *)(b2a2p + 48)
# asm 1: mulpd 48(<b2a2p=int64#3),<t7=int6464#16
# asm 2: mulpd 48(<b2a2p=%rdx),<t7=%xmm15
mulpd 48(%rdx),%xmm15

# qhasm: float6464 r7 += t7
# asm 1: addpd <t7=int6464#16,<r7=int6464#10
# asm 2: addpd <t7=%xmm15,<r7=%xmm9
addpd %xmm15,%xmm9

# qhasm: d7 = cd4
# asm 1: movdqa <cd4=int6464#6,>d7=int6464#16
# asm 2: movdqa <cd4=%xmm5,>d7=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 d7 *= *(int128 *)(a2b2p + 48)
# asm 1: mulpd 48(<a2b2p=int64#6),<d7=int6464#16
# asm 2: mulpd 48(<a2b2p=%r9),<d7=%xmm15
mulpd 48(%r9),%xmm15

# qhasm: float6464 r7 += d7
# asm 1: addpd <d7=int6464#16,<r7=int6464#10
# asm 2: addpd <d7=%xmm15,<r7=%xmm9
addpd %xmm15,%xmm9

# qhasm: t8 = ab4
# asm 1: movdqa <ab4=int6464#5,>t8=int6464#16
# asm 2: movdqa <ab4=%xmm4,>t8=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t8 *= *(int128 *)(b2a2p + 64)
# asm 1: mulpd 64(<b2a2p=int64#3),<t8=int6464#16
# asm 2: mulpd 64(<b2a2p=%rdx),<t8=%xmm15
mulpd 64(%rdx),%xmm15

# qhasm: float6464 r8 += t8
# asm 1: addpd <t8=int6464#16,<r8=int6464#11
# asm 2: addpd <t8=%xmm15,<r8=%xmm10
addpd %xmm15,%xmm10

# qhasm: d8 = cd4
# asm 1: movdqa <cd4=int6464#6,>d8=int6464#16
# asm 2: movdqa <cd4=%xmm5,>d8=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 d8 *= *(int128 *)(a2b2p + 64)
# asm 1: mulpd 64(<a2b2p=int64#6),<d8=int6464#16
# asm 2: mulpd 64(<a2b2p=%r9),<d8=%xmm15
mulpd 64(%r9),%xmm15

# qhasm: float6464 r8 += d8
# asm 1: addpd <d8=int6464#16,<r8=int6464#11
# asm 2: addpd <d8=%xmm15,<r8=%xmm10
addpd %xmm15,%xmm10

# qhasm: t9 = ab4
# asm 1: movdqa <ab4=int6464#5,>t9=int6464#16
# asm 2: movdqa <ab4=%xmm4,>t9=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t9 *= *(int128 *)(b2a2p + 80)
# asm 1: mulpd 80(<b2a2p=int64#3),<t9=int6464#16
# asm 2: mulpd 80(<b2a2p=%rdx),<t9=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r9 += t9
# asm 1: addpd <t9=int6464#16,<r9=int6464#12
# asm 2: addpd <t9=%xmm15,<r9=%xmm11
addpd %xmm15,%xmm11

# qhasm: d9 = cd4
# asm 1: movdqa <cd4=int6464#6,>d9=int6464#16
# asm 2: movdqa <cd4=%xmm5,>d9=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 d9 *= *(int128 *)(a2b2p + 80)
# asm 1: mulpd 80(<a2b2p=int64#6),<d9=int6464#16
# asm 2: mulpd 80(<a2b2p=%r9),<d9=%xmm15
mulpd 80(%r9),%xmm15

# qhasm: float6464 r9 += d9
# asm 1: addpd <d9=int6464#16,<r9=int6464#12
# asm 2: addpd <d9=%xmm15,<r9=%xmm11
addpd %xmm15,%xmm11

# qhasm: t10 = ab4
# asm 1: movdqa <ab4=int6464#5,>t10=int6464#16
# asm 2: movdqa <ab4=%xmm4,>t10=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t10 *= *(int128 *)(b2a2p + 96)
# asm 1: mulpd 96(<b2a2p=int64#3),<t10=int6464#16
# asm 2: mulpd 96(<b2a2p=%rdx),<t10=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r10 += t10
# asm 1: addpd <t10=int6464#16,<r10=int6464#13
# asm 2: addpd <t10=%xmm15,<r10=%xmm12
addpd %xmm15,%xmm12

# qhasm: d10 = cd4
# asm 1: movdqa <cd4=int6464#6,>d10=int6464#16
# asm 2: movdqa <cd4=%xmm5,>d10=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 d10 *= *(int128 *)(a2b2p + 96)
# asm 1: mulpd 96(<a2b2p=int64#6),<d10=int6464#16
# asm 2: mulpd 96(<a2b2p=%r9),<d10=%xmm15
mulpd 96(%r9),%xmm15

# qhasm: float6464 r10 += d10
# asm 1: addpd <d10=int6464#16,<r10=int6464#13
# asm 2: addpd <d10=%xmm15,<r10=%xmm12
addpd %xmm15,%xmm12

# qhasm: t13 = ab4
# asm 1: movdqa <ab4=int6464#5,>t13=int6464#16
# asm 2: movdqa <ab4=%xmm4,>t13=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t13 *= *(int128 *)(b2a2p + 144)
# asm 1: mulpd 144(<b2a2p=int64#3),<t13=int6464#16
# asm 2: mulpd 144(<b2a2p=%rdx),<t13=%xmm15
mulpd 144(%rdx),%xmm15

# qhasm: float6464 r13 += t13
# asm 1: addpd <t13=int6464#16,<r13=int6464#3
# asm 2: addpd <t13=%xmm15,<r13=%xmm2
addpd %xmm15,%xmm2

# qhasm: d13 = cd4
# asm 1: movdqa <cd4=int6464#6,>d13=int6464#16
# asm 2: movdqa <cd4=%xmm5,>d13=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 d13 *= *(int128 *)(a2b2p + 144)
# asm 1: mulpd 144(<a2b2p=int64#6),<d13=int6464#16
# asm 2: mulpd 144(<a2b2p=%r9),<d13=%xmm15
mulpd 144(%r9),%xmm15

# qhasm: float6464 r13 += d13
# asm 1: addpd <d13=int6464#16,<r13=int6464#3
# asm 2: addpd <d13=%xmm15,<r13=%xmm2
addpd %xmm15,%xmm2

# qhasm: t14 = ab4
# asm 1: movdqa <ab4=int6464#5,>t14=int6464#16
# asm 2: movdqa <ab4=%xmm4,>t14=%xmm15
movdqa %xmm4,%xmm15

# qhasm: float6464 t14 *= *(int128 *)(b2a2p + 160)
# asm 1: mulpd 160(<b2a2p=int64#3),<t14=int6464#16
# asm 2: mulpd 160(<b2a2p=%rdx),<t14=%xmm15
mulpd 160(%rdx),%xmm15

# qhasm: float6464 r14 += t14
# asm 1: addpd <t14=int6464#16,<r14=int6464#4
# asm 2: addpd <t14=%xmm15,<r14=%xmm3
addpd %xmm15,%xmm3

# qhasm: d14 = cd4
# asm 1: movdqa <cd4=int6464#6,>d14=int6464#16
# asm 2: movdqa <cd4=%xmm5,>d14=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 d14 *= *(int128 *)(a2b2p + 160)
# asm 1: mulpd 160(<a2b2p=int64#6),<d14=int6464#16
# asm 2: mulpd 160(<a2b2p=%r9),<d14=%xmm15
mulpd 160(%r9),%xmm15

# qhasm: float6464 r14 += d14
# asm 1: addpd <d14=int6464#16,<r14=int6464#4
# asm 2: addpd <d14=%xmm15,<r14=%xmm3
addpd %xmm15,%xmm3

# qhasm: r15 = ab4
# asm 1: movdqa <ab4=int6464#5,>r15=int6464#5
# asm 2: movdqa <ab4=%xmm4,>r15=%xmm4
movdqa %xmm4,%xmm4

# qhasm: float6464 r15 *= *(int128 *)(b2a2p + 176)
# asm 1: mulpd 176(<b2a2p=int64#3),<r15=int6464#5
# asm 2: mulpd 176(<b2a2p=%rdx),<r15=%xmm4
mulpd 176(%rdx),%xmm4

# qhasm: d15 = cd4
# asm 1: movdqa <cd4=int6464#6,>d15=int6464#6
# asm 2: movdqa <cd4=%xmm5,>d15=%xmm5
movdqa %xmm5,%xmm5

# qhasm: float6464 d15 *= *(int128 *)(a2b2p + 176)
# asm 1: mulpd 176(<a2b2p=int64#6),<d15=int6464#6
# asm 2: mulpd 176(<a2b2p=%r9),<d15=%xmm5
mulpd 176(%r9),%xmm5

# qhasm: float6464 r15 += d15
# asm 1: addpd <d15=int6464#6,<r15=int6464#5
# asm 2: addpd <d15=%xmm5,<r15=%xmm4
addpd %xmm5,%xmm4

# qhasm: t5 = ab4six
# asm 1: movdqa <ab4six=int6464#14,>t5=int6464#6
# asm 2: movdqa <ab4six=%xmm13,>t5=%xmm5
movdqa %xmm13,%xmm5

# qhasm: float6464 t5 *= *(int128 *)(b2a2p + 16)
# asm 1: mulpd 16(<b2a2p=int64#3),<t5=int6464#6
# asm 2: mulpd 16(<b2a2p=%rdx),<t5=%xmm5
mulpd 16(%rdx),%xmm5

# qhasm: float6464 r5 += t5
# asm 1: addpd <t5=int6464#6,<r5=int6464#8
# asm 2: addpd <t5=%xmm5,<r5=%xmm7
addpd %xmm5,%xmm7

# qhasm: d5 = cd4six
# asm 1: movdqa <cd4six=int6464#15,>d5=int6464#6
# asm 2: movdqa <cd4six=%xmm14,>d5=%xmm5
movdqa %xmm14,%xmm5

# qhasm: float6464 d5 *= *(int128 *)(a2b2p + 16)
# asm 1: mulpd 16(<a2b2p=int64#6),<d5=int6464#6
# asm 2: mulpd 16(<a2b2p=%r9),<d5=%xmm5
mulpd 16(%r9),%xmm5

# qhasm: float6464 r5 += d5
# asm 1: addpd <d5=int6464#6,<r5=int6464#8
# asm 2: addpd <d5=%xmm5,<r5=%xmm7
addpd %xmm5,%xmm7

# qhasm: t6 = ab4six
# asm 1: movdqa <ab4six=int6464#14,>t6=int6464#6
# asm 2: movdqa <ab4six=%xmm13,>t6=%xmm5
movdqa %xmm13,%xmm5

# qhasm: float6464 t6 *= *(int128 *)(b2a2p + 32)
# asm 1: mulpd 32(<b2a2p=int64#3),<t6=int6464#6
# asm 2: mulpd 32(<b2a2p=%rdx),<t6=%xmm5
mulpd 32(%rdx),%xmm5

# qhasm: float6464 r6 += t6
# asm 1: addpd <t6=int6464#6,<r6=int6464#9
# asm 2: addpd <t6=%xmm5,<r6=%xmm8
addpd %xmm5,%xmm8

# qhasm: d6 = cd4six
# asm 1: movdqa <cd4six=int6464#15,>d6=int6464#6
# asm 2: movdqa <cd4six=%xmm14,>d6=%xmm5
movdqa %xmm14,%xmm5

# qhasm: float6464 d6 *= *(int128 *)(a2b2p + 32)
# asm 1: mulpd 32(<a2b2p=int64#6),<d6=int6464#6
# asm 2: mulpd 32(<a2b2p=%r9),<d6=%xmm5
mulpd 32(%r9),%xmm5

# qhasm: float6464 r6 += d6
# asm 1: addpd <d6=int6464#6,<r6=int6464#9
# asm 2: addpd <d6=%xmm5,<r6=%xmm8
addpd %xmm5,%xmm8

# qhasm: t11 = ab4six
# asm 1: movdqa <ab4six=int6464#14,>t11=int6464#6
# asm 2: movdqa <ab4six=%xmm13,>t11=%xmm5
movdqa %xmm13,%xmm5

# qhasm: float6464 t11 *= *(int128 *)(b2a2p + 112)
# asm 1: mulpd 112(<b2a2p=int64#3),<t11=int6464#6
# asm 2: mulpd 112(<b2a2p=%rdx),<t11=%xmm5
mulpd 112(%rdx),%xmm5

# qhasm: float6464 r11 += t11
# asm 1: addpd <t11=int6464#6,<r11=int6464#1
# asm 2: addpd <t11=%xmm5,<r11=%xmm0
addpd %xmm5,%xmm0

# qhasm: d11 = cd4six
# asm 1: movdqa <cd4six=int6464#15,>d11=int6464#6
# asm 2: movdqa <cd4six=%xmm14,>d11=%xmm5
movdqa %xmm14,%xmm5

# qhasm: float6464 d11 *= *(int128 *)(a2b2p + 112)
# asm 1: mulpd 112(<a2b2p=int64#6),<d11=int6464#6
# asm 2: mulpd 112(<a2b2p=%r9),<d11=%xmm5
mulpd 112(%r9),%xmm5

# qhasm: float6464 r11 += d11
# asm 1: addpd <d11=int6464#6,<r11=int6464#1
# asm 2: addpd <d11=%xmm5,<r11=%xmm0
addpd %xmm5,%xmm0

# qhasm: t12 = ab4six
# asm 1: movdqa <ab4six=int6464#14,>t12=int6464#6
# asm 2: movdqa <ab4six=%xmm13,>t12=%xmm5
movdqa %xmm13,%xmm5

# qhasm: float6464 t12 *= *(int128 *)(b2a2p + 128)
# asm 1: mulpd 128(<b2a2p=int64#3),<t12=int6464#6
# asm 2: mulpd 128(<b2a2p=%rdx),<t12=%xmm5
mulpd 128(%rdx),%xmm5

# qhasm: float6464 r12 += t12
# asm 1: addpd <t12=int6464#6,<r12=int6464#2
# asm 2: addpd <t12=%xmm5,<r12=%xmm1
addpd %xmm5,%xmm1

# qhasm: d12 = cd4six
# asm 1: movdqa <cd4six=int6464#15,>d12=int6464#6
# asm 2: movdqa <cd4six=%xmm14,>d12=%xmm5
movdqa %xmm14,%xmm5

# qhasm: float6464 d12 *= *(int128 *)(a2b2p + 128)
# asm 1: mulpd 128(<a2b2p=int64#6),<d12=int6464#6
# asm 2: mulpd 128(<a2b2p=%r9),<d12=%xmm5
mulpd 128(%r9),%xmm5

# qhasm: float6464 r12 += d12
# asm 1: addpd <d12=int6464#6,<r12=int6464#2
# asm 2: addpd <d12=%xmm5,<r12=%xmm1
addpd %xmm5,%xmm1

# qhasm: *(int128 *)(b1b1p + 64) = r4
# asm 1: movdqa <r4=int6464#7,64(<b1b1p=int64#4)
# asm 2: movdqa <r4=%xmm6,64(<b1b1p=%rcx)
movdqa %xmm6,64(%rcx)

# qhasm: ab5 = *(int128 *)(b1b1p + 80)
# asm 1: movdqa 80(<b1b1p=int64#4),>ab5=int6464#6
# asm 2: movdqa 80(<b1b1p=%rcx),>ab5=%xmm5
movdqa 80(%rcx),%xmm5

# qhasm: cd5 = *(int128 *)(ma1a1p + 80)
# asm 1: movdqa 80(<ma1a1p=int64#5),>cd5=int6464#7
# asm 2: movdqa 80(<ma1a1p=%r8),>cd5=%xmm6
movdqa 80(%r8),%xmm6

# qhasm: ab5six = ab5
# asm 1: movdqa <ab5=int6464#6,>ab5six=int6464#14
# asm 2: movdqa <ab5=%xmm5,>ab5six=%xmm13
movdqa %xmm5,%xmm13

# qhasm: cd5six = cd5
# asm 1: movdqa <cd5=int6464#7,>cd5six=int6464#15
# asm 2: movdqa <cd5=%xmm6,>cd5six=%xmm14
movdqa %xmm6,%xmm14

# qhasm: float6464 ab5six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab5six=int6464#14
# asm 2: mulpd SIX_SIX,<ab5six=%xmm13
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 cd5six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<cd5six=int6464#15
# asm 2: mulpd SIX_SIX,<cd5six=%xmm14
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: t5 = ab5
# asm 1: movdqa <ab5=int6464#6,>t5=int6464#16
# asm 2: movdqa <ab5=%xmm5,>t5=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t5 *= *(int128 *)(b2a2p + 0)
# asm 1: mulpd 0(<b2a2p=int64#3),<t5=int6464#16
# asm 2: mulpd 0(<b2a2p=%rdx),<t5=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r5 += t5
# asm 1: addpd <t5=int6464#16,<r5=int6464#8
# asm 2: addpd <t5=%xmm15,<r5=%xmm7
addpd %xmm15,%xmm7

# qhasm: d5 = cd5
# asm 1: movdqa <cd5=int6464#7,>d5=int6464#16
# asm 2: movdqa <cd5=%xmm6,>d5=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 d5 *= *(int128 *)(a2b2p + 0)
# asm 1: mulpd 0(<a2b2p=int64#6),<d5=int6464#16
# asm 2: mulpd 0(<a2b2p=%r9),<d5=%xmm15
mulpd 0(%r9),%xmm15

# qhasm: float6464 r5 += d5
# asm 1: addpd <d5=int6464#16,<r5=int6464#8
# asm 2: addpd <d5=%xmm15,<r5=%xmm7
addpd %xmm15,%xmm7

# qhasm: t7 = ab5
# asm 1: movdqa <ab5=int6464#6,>t7=int6464#16
# asm 2: movdqa <ab5=%xmm5,>t7=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t7 *= *(int128 *)(b2a2p + 32)
# asm 1: mulpd 32(<b2a2p=int64#3),<t7=int6464#16
# asm 2: mulpd 32(<b2a2p=%rdx),<t7=%xmm15
mulpd 32(%rdx),%xmm15

# qhasm: float6464 r7 += t7
# asm 1: addpd <t7=int6464#16,<r7=int6464#10
# asm 2: addpd <t7=%xmm15,<r7=%xmm9
addpd %xmm15,%xmm9

# qhasm: d7 = cd5
# asm 1: movdqa <cd5=int6464#7,>d7=int6464#16
# asm 2: movdqa <cd5=%xmm6,>d7=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 d7 *= *(int128 *)(a2b2p + 32)
# asm 1: mulpd 32(<a2b2p=int64#6),<d7=int6464#16
# asm 2: mulpd 32(<a2b2p=%r9),<d7=%xmm15
mulpd 32(%r9),%xmm15

# qhasm: float6464 r7 += d7
# asm 1: addpd <d7=int6464#16,<r7=int6464#10
# asm 2: addpd <d7=%xmm15,<r7=%xmm9
addpd %xmm15,%xmm9

# qhasm: t8 = ab5
# asm 1: movdqa <ab5=int6464#6,>t8=int6464#16
# asm 2: movdqa <ab5=%xmm5,>t8=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t8 *= *(int128 *)(b2a2p + 48)
# asm 1: mulpd 48(<b2a2p=int64#3),<t8=int6464#16
# asm 2: mulpd 48(<b2a2p=%rdx),<t8=%xmm15
mulpd 48(%rdx),%xmm15

# qhasm: float6464 r8 += t8
# asm 1: addpd <t8=int6464#16,<r8=int6464#11
# asm 2: addpd <t8=%xmm15,<r8=%xmm10
addpd %xmm15,%xmm10

# qhasm: d8 = cd5
# asm 1: movdqa <cd5=int6464#7,>d8=int6464#16
# asm 2: movdqa <cd5=%xmm6,>d8=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 d8 *= *(int128 *)(a2b2p + 48)
# asm 1: mulpd 48(<a2b2p=int64#6),<d8=int6464#16
# asm 2: mulpd 48(<a2b2p=%r9),<d8=%xmm15
mulpd 48(%r9),%xmm15

# qhasm: float6464 r8 += d8
# asm 1: addpd <d8=int6464#16,<r8=int6464#11
# asm 2: addpd <d8=%xmm15,<r8=%xmm10
addpd %xmm15,%xmm10

# qhasm: t9 = ab5
# asm 1: movdqa <ab5=int6464#6,>t9=int6464#16
# asm 2: movdqa <ab5=%xmm5,>t9=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t9 *= *(int128 *)(b2a2p + 64)
# asm 1: mulpd 64(<b2a2p=int64#3),<t9=int6464#16
# asm 2: mulpd 64(<b2a2p=%rdx),<t9=%xmm15
mulpd 64(%rdx),%xmm15

# qhasm: float6464 r9 += t9
# asm 1: addpd <t9=int6464#16,<r9=int6464#12
# asm 2: addpd <t9=%xmm15,<r9=%xmm11
addpd %xmm15,%xmm11

# qhasm: d9 = cd5
# asm 1: movdqa <cd5=int6464#7,>d9=int6464#16
# asm 2: movdqa <cd5=%xmm6,>d9=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 d9 *= *(int128 *)(a2b2p + 64)
# asm 1: mulpd 64(<a2b2p=int64#6),<d9=int6464#16
# asm 2: mulpd 64(<a2b2p=%r9),<d9=%xmm15
mulpd 64(%r9),%xmm15

# qhasm: float6464 r9 += d9
# asm 1: addpd <d9=int6464#16,<r9=int6464#12
# asm 2: addpd <d9=%xmm15,<r9=%xmm11
addpd %xmm15,%xmm11

# qhasm: t10 = ab5
# asm 1: movdqa <ab5=int6464#6,>t10=int6464#16
# asm 2: movdqa <ab5=%xmm5,>t10=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t10 *= *(int128 *)(b2a2p + 80)
# asm 1: mulpd 80(<b2a2p=int64#3),<t10=int6464#16
# asm 2: mulpd 80(<b2a2p=%rdx),<t10=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r10 += t10
# asm 1: addpd <t10=int6464#16,<r10=int6464#13
# asm 2: addpd <t10=%xmm15,<r10=%xmm12
addpd %xmm15,%xmm12

# qhasm: d10 = cd5
# asm 1: movdqa <cd5=int6464#7,>d10=int6464#16
# asm 2: movdqa <cd5=%xmm6,>d10=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 d10 *= *(int128 *)(a2b2p + 80)
# asm 1: mulpd 80(<a2b2p=int64#6),<d10=int6464#16
# asm 2: mulpd 80(<a2b2p=%r9),<d10=%xmm15
mulpd 80(%r9),%xmm15

# qhasm: float6464 r10 += d10
# asm 1: addpd <d10=int6464#16,<r10=int6464#13
# asm 2: addpd <d10=%xmm15,<r10=%xmm12
addpd %xmm15,%xmm12

# qhasm: t11 = ab5
# asm 1: movdqa <ab5=int6464#6,>t11=int6464#16
# asm 2: movdqa <ab5=%xmm5,>t11=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t11 *= *(int128 *)(b2a2p + 96)
# asm 1: mulpd 96(<b2a2p=int64#3),<t11=int6464#16
# asm 2: mulpd 96(<b2a2p=%rdx),<t11=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r11 += t11
# asm 1: addpd <t11=int6464#16,<r11=int6464#1
# asm 2: addpd <t11=%xmm15,<r11=%xmm0
addpd %xmm15,%xmm0

# qhasm: d11 = cd5
# asm 1: movdqa <cd5=int6464#7,>d11=int6464#16
# asm 2: movdqa <cd5=%xmm6,>d11=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 d11 *= *(int128 *)(a2b2p + 96)
# asm 1: mulpd 96(<a2b2p=int64#6),<d11=int6464#16
# asm 2: mulpd 96(<a2b2p=%r9),<d11=%xmm15
mulpd 96(%r9),%xmm15

# qhasm: float6464 r11 += d11
# asm 1: addpd <d11=int6464#16,<r11=int6464#1
# asm 2: addpd <d11=%xmm15,<r11=%xmm0
addpd %xmm15,%xmm0

# qhasm: t13 = ab5
# asm 1: movdqa <ab5=int6464#6,>t13=int6464#16
# asm 2: movdqa <ab5=%xmm5,>t13=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t13 *= *(int128 *)(b2a2p + 128)
# asm 1: mulpd 128(<b2a2p=int64#3),<t13=int6464#16
# asm 2: mulpd 128(<b2a2p=%rdx),<t13=%xmm15
mulpd 128(%rdx),%xmm15

# qhasm: float6464 r13 += t13
# asm 1: addpd <t13=int6464#16,<r13=int6464#3
# asm 2: addpd <t13=%xmm15,<r13=%xmm2
addpd %xmm15,%xmm2

# qhasm: d13 = cd5
# asm 1: movdqa <cd5=int6464#7,>d13=int6464#16
# asm 2: movdqa <cd5=%xmm6,>d13=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 d13 *= *(int128 *)(a2b2p + 128)
# asm 1: mulpd 128(<a2b2p=int64#6),<d13=int6464#16
# asm 2: mulpd 128(<a2b2p=%r9),<d13=%xmm15
mulpd 128(%r9),%xmm15

# qhasm: float6464 r13 += d13
# asm 1: addpd <d13=int6464#16,<r13=int6464#3
# asm 2: addpd <d13=%xmm15,<r13=%xmm2
addpd %xmm15,%xmm2

# qhasm: t14 = ab5
# asm 1: movdqa <ab5=int6464#6,>t14=int6464#16
# asm 2: movdqa <ab5=%xmm5,>t14=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t14 *= *(int128 *)(b2a2p + 144)
# asm 1: mulpd 144(<b2a2p=int64#3),<t14=int6464#16
# asm 2: mulpd 144(<b2a2p=%rdx),<t14=%xmm15
mulpd 144(%rdx),%xmm15

# qhasm: float6464 r14 += t14
# asm 1: addpd <t14=int6464#16,<r14=int6464#4
# asm 2: addpd <t14=%xmm15,<r14=%xmm3
addpd %xmm15,%xmm3

# qhasm: d14 = cd5
# asm 1: movdqa <cd5=int6464#7,>d14=int6464#16
# asm 2: movdqa <cd5=%xmm6,>d14=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 d14 *= *(int128 *)(a2b2p + 144)
# asm 1: mulpd 144(<a2b2p=int64#6),<d14=int6464#16
# asm 2: mulpd 144(<a2b2p=%r9),<d14=%xmm15
mulpd 144(%r9),%xmm15

# qhasm: float6464 r14 += d14
# asm 1: addpd <d14=int6464#16,<r14=int6464#4
# asm 2: addpd <d14=%xmm15,<r14=%xmm3
addpd %xmm15,%xmm3

# qhasm: t15 = ab5
# asm 1: movdqa <ab5=int6464#6,>t15=int6464#16
# asm 2: movdqa <ab5=%xmm5,>t15=%xmm15
movdqa %xmm5,%xmm15

# qhasm: float6464 t15 *= *(int128 *)(b2a2p + 160)
# asm 1: mulpd 160(<b2a2p=int64#3),<t15=int6464#16
# asm 2: mulpd 160(<b2a2p=%rdx),<t15=%xmm15
mulpd 160(%rdx),%xmm15

# qhasm: float6464 r15 += t15
# asm 1: addpd <t15=int6464#16,<r15=int6464#5
# asm 2: addpd <t15=%xmm15,<r15=%xmm4
addpd %xmm15,%xmm4

# qhasm: d15 = cd5
# asm 1: movdqa <cd5=int6464#7,>d15=int6464#16
# asm 2: movdqa <cd5=%xmm6,>d15=%xmm15
movdqa %xmm6,%xmm15

# qhasm: float6464 d15 *= *(int128 *)(a2b2p + 160)
# asm 1: mulpd 160(<a2b2p=int64#6),<d15=int6464#16
# asm 2: mulpd 160(<a2b2p=%r9),<d15=%xmm15
mulpd 160(%r9),%xmm15

# qhasm: float6464 r15 += d15
# asm 1: addpd <d15=int6464#16,<r15=int6464#5
# asm 2: addpd <d15=%xmm15,<r15=%xmm4
addpd %xmm15,%xmm4

# qhasm: r16 = ab5
# asm 1: movdqa <ab5=int6464#6,>r16=int6464#6
# asm 2: movdqa <ab5=%xmm5,>r16=%xmm5
movdqa %xmm5,%xmm5

# qhasm: float6464 r16 *= *(int128 *)(b2a2p + 176)
# asm 1: mulpd 176(<b2a2p=int64#3),<r16=int6464#6
# asm 2: mulpd 176(<b2a2p=%rdx),<r16=%xmm5
mulpd 176(%rdx),%xmm5

# qhasm: d16 = cd5
# asm 1: movdqa <cd5=int6464#7,>d16=int6464#7
# asm 2: movdqa <cd5=%xmm6,>d16=%xmm6
movdqa %xmm6,%xmm6

# qhasm: float6464 d16 *= *(int128 *)(a2b2p + 176)
# asm 1: mulpd 176(<a2b2p=int64#6),<d16=int6464#7
# asm 2: mulpd 176(<a2b2p=%r9),<d16=%xmm6
mulpd 176(%r9),%xmm6

# qhasm: float6464 r16 += d16
# asm 1: addpd <d16=int6464#7,<r16=int6464#6
# asm 2: addpd <d16=%xmm6,<r16=%xmm5
addpd %xmm6,%xmm5

# qhasm: t6 = ab5six
# asm 1: movdqa <ab5six=int6464#14,>t6=int6464#7
# asm 2: movdqa <ab5six=%xmm13,>t6=%xmm6
movdqa %xmm13,%xmm6

# qhasm: float6464 t6 *= *(int128 *)(b2a2p + 16)
# asm 1: mulpd 16(<b2a2p=int64#3),<t6=int6464#7
# asm 2: mulpd 16(<b2a2p=%rdx),<t6=%xmm6
mulpd 16(%rdx),%xmm6

# qhasm: float6464 r6 += t6
# asm 1: addpd <t6=int6464#7,<r6=int6464#9
# asm 2: addpd <t6=%xmm6,<r6=%xmm8
addpd %xmm6,%xmm8

# qhasm: d6 = cd5six
# asm 1: movdqa <cd5six=int6464#15,>d6=int6464#7
# asm 2: movdqa <cd5six=%xmm14,>d6=%xmm6
movdqa %xmm14,%xmm6

# qhasm: float6464 d6 *= *(int128 *)(a2b2p + 16)
# asm 1: mulpd 16(<a2b2p=int64#6),<d6=int6464#7
# asm 2: mulpd 16(<a2b2p=%r9),<d6=%xmm6
mulpd 16(%r9),%xmm6

# qhasm: float6464 r6 += d6
# asm 1: addpd <d6=int6464#7,<r6=int6464#9
# asm 2: addpd <d6=%xmm6,<r6=%xmm8
addpd %xmm6,%xmm8

# qhasm: t12 = ab5six
# asm 1: movdqa <ab5six=int6464#14,>t12=int6464#7
# asm 2: movdqa <ab5six=%xmm13,>t12=%xmm6
movdqa %xmm13,%xmm6

# qhasm: float6464 t12 *= *(int128 *)(b2a2p + 112)
# asm 1: mulpd 112(<b2a2p=int64#3),<t12=int6464#7
# asm 2: mulpd 112(<b2a2p=%rdx),<t12=%xmm6
mulpd 112(%rdx),%xmm6

# qhasm: float6464 r12 += t12
# asm 1: addpd <t12=int6464#7,<r12=int6464#2
# asm 2: addpd <t12=%xmm6,<r12=%xmm1
addpd %xmm6,%xmm1

# qhasm: d12 = cd5six
# asm 1: movdqa <cd5six=int6464#15,>d12=int6464#7
# asm 2: movdqa <cd5six=%xmm14,>d12=%xmm6
movdqa %xmm14,%xmm6

# qhasm: float6464 d12 *= *(int128 *)(a2b2p + 112)
# asm 1: mulpd 112(<a2b2p=int64#6),<d12=int6464#7
# asm 2: mulpd 112(<a2b2p=%r9),<d12=%xmm6
mulpd 112(%r9),%xmm6

# qhasm: float6464 r12 += d12
# asm 1: addpd <d12=int6464#7,<r12=int6464#2
# asm 2: addpd <d12=%xmm6,<r12=%xmm1
addpd %xmm6,%xmm1

# qhasm: *(int128 *)(b1b1p + 80) = r5
# asm 1: movdqa <r5=int6464#8,80(<b1b1p=int64#4)
# asm 2: movdqa <r5=%xmm7,80(<b1b1p=%rcx)
movdqa %xmm7,80(%rcx)

# qhasm: ab6 = *(int128 *)(b1b1p + 96)
# asm 1: movdqa 96(<b1b1p=int64#4),>ab6=int6464#7
# asm 2: movdqa 96(<b1b1p=%rcx),>ab6=%xmm6
movdqa 96(%rcx),%xmm6

# qhasm: cd6 = *(int128 *)(ma1a1p + 96)
# asm 1: movdqa 96(<ma1a1p=int64#5),>cd6=int6464#8
# asm 2: movdqa 96(<ma1a1p=%r8),>cd6=%xmm7
movdqa 96(%r8),%xmm7

# qhasm: t6 = ab6
# asm 1: movdqa <ab6=int6464#7,>t6=int6464#14
# asm 2: movdqa <ab6=%xmm6,>t6=%xmm13
movdqa %xmm6,%xmm13

# qhasm: float6464 t6 *= *(int128 *)(b2a2p + 0)
# asm 1: mulpd 0(<b2a2p=int64#3),<t6=int6464#14
# asm 2: mulpd 0(<b2a2p=%rdx),<t6=%xmm13
mulpd 0(%rdx),%xmm13

# qhasm: float6464 r6 += t6
# asm 1: addpd <t6=int6464#14,<r6=int6464#9
# asm 2: addpd <t6=%xmm13,<r6=%xmm8
addpd %xmm13,%xmm8

# qhasm: d6 = cd6
# asm 1: movdqa <cd6=int6464#8,>d6=int6464#14
# asm 2: movdqa <cd6=%xmm7,>d6=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 d6 *= *(int128 *)(a2b2p + 0)
# asm 1: mulpd 0(<a2b2p=int64#6),<d6=int6464#14
# asm 2: mulpd 0(<a2b2p=%r9),<d6=%xmm13
mulpd 0(%r9),%xmm13

# qhasm: float6464 r6 += d6
# asm 1: addpd <d6=int6464#14,<r6=int6464#9
# asm 2: addpd <d6=%xmm13,<r6=%xmm8
addpd %xmm13,%xmm8

# qhasm: t7 = ab6
# asm 1: movdqa <ab6=int6464#7,>t7=int6464#14
# asm 2: movdqa <ab6=%xmm6,>t7=%xmm13
movdqa %xmm6,%xmm13

# qhasm: float6464 t7 *= *(int128 *)(b2a2p + 16)
# asm 1: mulpd 16(<b2a2p=int64#3),<t7=int6464#14
# asm 2: mulpd 16(<b2a2p=%rdx),<t7=%xmm13
mulpd 16(%rdx),%xmm13

# qhasm: float6464 r7 += t7
# asm 1: addpd <t7=int6464#14,<r7=int6464#10
# asm 2: addpd <t7=%xmm13,<r7=%xmm9
addpd %xmm13,%xmm9

# qhasm: d7 = cd6
# asm 1: movdqa <cd6=int6464#8,>d7=int6464#14
# asm 2: movdqa <cd6=%xmm7,>d7=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 d7 *= *(int128 *)(a2b2p + 16)
# asm 1: mulpd 16(<a2b2p=int64#6),<d7=int6464#14
# asm 2: mulpd 16(<a2b2p=%r9),<d7=%xmm13
mulpd 16(%r9),%xmm13

# qhasm: float6464 r7 += d7
# asm 1: addpd <d7=int6464#14,<r7=int6464#10
# asm 2: addpd <d7=%xmm13,<r7=%xmm9
addpd %xmm13,%xmm9

# qhasm: t8 = ab6
# asm 1: movdqa <ab6=int6464#7,>t8=int6464#14
# asm 2: movdqa <ab6=%xmm6,>t8=%xmm13
movdqa %xmm6,%xmm13

# qhasm: float6464 t8 *= *(int128 *)(b2a2p + 32)
# asm 1: mulpd 32(<b2a2p=int64#3),<t8=int6464#14
# asm 2: mulpd 32(<b2a2p=%rdx),<t8=%xmm13
mulpd 32(%rdx),%xmm13

# qhasm: float6464 r8 += t8
# asm 1: addpd <t8=int6464#14,<r8=int6464#11
# asm 2: addpd <t8=%xmm13,<r8=%xmm10
addpd %xmm13,%xmm10

# qhasm: d8 = cd6
# asm 1: movdqa <cd6=int6464#8,>d8=int6464#14
# asm 2: movdqa <cd6=%xmm7,>d8=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 d8 *= *(int128 *)(a2b2p + 32)
# asm 1: mulpd 32(<a2b2p=int64#6),<d8=int6464#14
# asm 2: mulpd 32(<a2b2p=%r9),<d8=%xmm13
mulpd 32(%r9),%xmm13

# qhasm: float6464 r8 += d8
# asm 1: addpd <d8=int6464#14,<r8=int6464#11
# asm 2: addpd <d8=%xmm13,<r8=%xmm10
addpd %xmm13,%xmm10

# qhasm: t9 = ab6
# asm 1: movdqa <ab6=int6464#7,>t9=int6464#14
# asm 2: movdqa <ab6=%xmm6,>t9=%xmm13
movdqa %xmm6,%xmm13

# qhasm: float6464 t9 *= *(int128 *)(b2a2p + 48)
# asm 1: mulpd 48(<b2a2p=int64#3),<t9=int6464#14
# asm 2: mulpd 48(<b2a2p=%rdx),<t9=%xmm13
mulpd 48(%rdx),%xmm13

# qhasm: float6464 r9 += t9
# asm 1: addpd <t9=int6464#14,<r9=int6464#12
# asm 2: addpd <t9=%xmm13,<r9=%xmm11
addpd %xmm13,%xmm11

# qhasm: d9 = cd6
# asm 1: movdqa <cd6=int6464#8,>d9=int6464#14
# asm 2: movdqa <cd6=%xmm7,>d9=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 d9 *= *(int128 *)(a2b2p + 48)
# asm 1: mulpd 48(<a2b2p=int64#6),<d9=int6464#14
# asm 2: mulpd 48(<a2b2p=%r9),<d9=%xmm13
mulpd 48(%r9),%xmm13

# qhasm: float6464 r9 += d9
# asm 1: addpd <d9=int6464#14,<r9=int6464#12
# asm 2: addpd <d9=%xmm13,<r9=%xmm11
addpd %xmm13,%xmm11

# qhasm: t10 = ab6
# asm 1: movdqa <ab6=int6464#7,>t10=int6464#14
# asm 2: movdqa <ab6=%xmm6,>t10=%xmm13
movdqa %xmm6,%xmm13

# qhasm: float6464 t10 *= *(int128 *)(b2a2p + 64)
# asm 1: mulpd 64(<b2a2p=int64#3),<t10=int6464#14
# asm 2: mulpd 64(<b2a2p=%rdx),<t10=%xmm13
mulpd 64(%rdx),%xmm13

# qhasm: float6464 r10 += t10
# asm 1: addpd <t10=int6464#14,<r10=int6464#13
# asm 2: addpd <t10=%xmm13,<r10=%xmm12
addpd %xmm13,%xmm12

# qhasm: d10 = cd6
# asm 1: movdqa <cd6=int6464#8,>d10=int6464#14
# asm 2: movdqa <cd6=%xmm7,>d10=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 d10 *= *(int128 *)(a2b2p + 64)
# asm 1: mulpd 64(<a2b2p=int64#6),<d10=int6464#14
# asm 2: mulpd 64(<a2b2p=%r9),<d10=%xmm13
mulpd 64(%r9),%xmm13

# qhasm: float6464 r10 += d10
# asm 1: addpd <d10=int6464#14,<r10=int6464#13
# asm 2: addpd <d10=%xmm13,<r10=%xmm12
addpd %xmm13,%xmm12

# qhasm: t11 = ab6
# asm 1: movdqa <ab6=int6464#7,>t11=int6464#14
# asm 2: movdqa <ab6=%xmm6,>t11=%xmm13
movdqa %xmm6,%xmm13

# qhasm: float6464 t11 *= *(int128 *)(b2a2p + 80)
# asm 1: mulpd 80(<b2a2p=int64#3),<t11=int6464#14
# asm 2: mulpd 80(<b2a2p=%rdx),<t11=%xmm13
mulpd 80(%rdx),%xmm13

# qhasm: float6464 r11 += t11
# asm 1: addpd <t11=int6464#14,<r11=int6464#1
# asm 2: addpd <t11=%xmm13,<r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: d11 = cd6
# asm 1: movdqa <cd6=int6464#8,>d11=int6464#14
# asm 2: movdqa <cd6=%xmm7,>d11=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 d11 *= *(int128 *)(a2b2p + 80)
# asm 1: mulpd 80(<a2b2p=int64#6),<d11=int6464#14
# asm 2: mulpd 80(<a2b2p=%r9),<d11=%xmm13
mulpd 80(%r9),%xmm13

# qhasm: float6464 r11 += d11
# asm 1: addpd <d11=int6464#14,<r11=int6464#1
# asm 2: addpd <d11=%xmm13,<r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: t12 = ab6
# asm 1: movdqa <ab6=int6464#7,>t12=int6464#14
# asm 2: movdqa <ab6=%xmm6,>t12=%xmm13
movdqa %xmm6,%xmm13

# qhasm: float6464 t12 *= *(int128 *)(b2a2p + 96)
# asm 1: mulpd 96(<b2a2p=int64#3),<t12=int6464#14
# asm 2: mulpd 96(<b2a2p=%rdx),<t12=%xmm13
mulpd 96(%rdx),%xmm13

# qhasm: float6464 r12 += t12
# asm 1: addpd <t12=int6464#14,<r12=int6464#2
# asm 2: addpd <t12=%xmm13,<r12=%xmm1
addpd %xmm13,%xmm1

# qhasm: d12 = cd6
# asm 1: movdqa <cd6=int6464#8,>d12=int6464#14
# asm 2: movdqa <cd6=%xmm7,>d12=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 d12 *= *(int128 *)(a2b2p + 96)
# asm 1: mulpd 96(<a2b2p=int64#6),<d12=int6464#14
# asm 2: mulpd 96(<a2b2p=%r9),<d12=%xmm13
mulpd 96(%r9),%xmm13

# qhasm: float6464 r12 += d12
# asm 1: addpd <d12=int6464#14,<r12=int6464#2
# asm 2: addpd <d12=%xmm13,<r12=%xmm1
addpd %xmm13,%xmm1

# qhasm: t13 = ab6
# asm 1: movdqa <ab6=int6464#7,>t13=int6464#14
# asm 2: movdqa <ab6=%xmm6,>t13=%xmm13
movdqa %xmm6,%xmm13

# qhasm: float6464 t13 *= *(int128 *)(b2a2p + 112)
# asm 1: mulpd 112(<b2a2p=int64#3),<t13=int6464#14
# asm 2: mulpd 112(<b2a2p=%rdx),<t13=%xmm13
mulpd 112(%rdx),%xmm13

# qhasm: float6464 r13 += t13
# asm 1: addpd <t13=int6464#14,<r13=int6464#3
# asm 2: addpd <t13=%xmm13,<r13=%xmm2
addpd %xmm13,%xmm2

# qhasm: d13 = cd6
# asm 1: movdqa <cd6=int6464#8,>d13=int6464#14
# asm 2: movdqa <cd6=%xmm7,>d13=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 d13 *= *(int128 *)(a2b2p + 112)
# asm 1: mulpd 112(<a2b2p=int64#6),<d13=int6464#14
# asm 2: mulpd 112(<a2b2p=%r9),<d13=%xmm13
mulpd 112(%r9),%xmm13

# qhasm: float6464 r13 += d13
# asm 1: addpd <d13=int6464#14,<r13=int6464#3
# asm 2: addpd <d13=%xmm13,<r13=%xmm2
addpd %xmm13,%xmm2

# qhasm: t14 = ab6
# asm 1: movdqa <ab6=int6464#7,>t14=int6464#14
# asm 2: movdqa <ab6=%xmm6,>t14=%xmm13
movdqa %xmm6,%xmm13

# qhasm: float6464 t14 *= *(int128 *)(b2a2p + 128)
# asm 1: mulpd 128(<b2a2p=int64#3),<t14=int6464#14
# asm 2: mulpd 128(<b2a2p=%rdx),<t14=%xmm13
mulpd 128(%rdx),%xmm13

# qhasm: float6464 r14 += t14
# asm 1: addpd <t14=int6464#14,<r14=int6464#4
# asm 2: addpd <t14=%xmm13,<r14=%xmm3
addpd %xmm13,%xmm3

# qhasm: d14 = cd6
# asm 1: movdqa <cd6=int6464#8,>d14=int6464#14
# asm 2: movdqa <cd6=%xmm7,>d14=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 d14 *= *(int128 *)(a2b2p + 128)
# asm 1: mulpd 128(<a2b2p=int64#6),<d14=int6464#14
# asm 2: mulpd 128(<a2b2p=%r9),<d14=%xmm13
mulpd 128(%r9),%xmm13

# qhasm: float6464 r14 += d14
# asm 1: addpd <d14=int6464#14,<r14=int6464#4
# asm 2: addpd <d14=%xmm13,<r14=%xmm3
addpd %xmm13,%xmm3

# qhasm: t15 = ab6
# asm 1: movdqa <ab6=int6464#7,>t15=int6464#14
# asm 2: movdqa <ab6=%xmm6,>t15=%xmm13
movdqa %xmm6,%xmm13

# qhasm: float6464 t15 *= *(int128 *)(b2a2p + 144)
# asm 1: mulpd 144(<b2a2p=int64#3),<t15=int6464#14
# asm 2: mulpd 144(<b2a2p=%rdx),<t15=%xmm13
mulpd 144(%rdx),%xmm13

# qhasm: float6464 r15 += t15
# asm 1: addpd <t15=int6464#14,<r15=int6464#5
# asm 2: addpd <t15=%xmm13,<r15=%xmm4
addpd %xmm13,%xmm4

# qhasm: d15 = cd6
# asm 1: movdqa <cd6=int6464#8,>d15=int6464#14
# asm 2: movdqa <cd6=%xmm7,>d15=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 d15 *= *(int128 *)(a2b2p + 144)
# asm 1: mulpd 144(<a2b2p=int64#6),<d15=int6464#14
# asm 2: mulpd 144(<a2b2p=%r9),<d15=%xmm13
mulpd 144(%r9),%xmm13

# qhasm: float6464 r15 += d15
# asm 1: addpd <d15=int6464#14,<r15=int6464#5
# asm 2: addpd <d15=%xmm13,<r15=%xmm4
addpd %xmm13,%xmm4

# qhasm: t16 = ab6
# asm 1: movdqa <ab6=int6464#7,>t16=int6464#14
# asm 2: movdqa <ab6=%xmm6,>t16=%xmm13
movdqa %xmm6,%xmm13

# qhasm: float6464 t16 *= *(int128 *)(b2a2p + 160)
# asm 1: mulpd 160(<b2a2p=int64#3),<t16=int6464#14
# asm 2: mulpd 160(<b2a2p=%rdx),<t16=%xmm13
mulpd 160(%rdx),%xmm13

# qhasm: float6464 r16 += t16
# asm 1: addpd <t16=int6464#14,<r16=int6464#6
# asm 2: addpd <t16=%xmm13,<r16=%xmm5
addpd %xmm13,%xmm5

# qhasm: d16 = cd6
# asm 1: movdqa <cd6=int6464#8,>d16=int6464#14
# asm 2: movdqa <cd6=%xmm7,>d16=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 d16 *= *(int128 *)(a2b2p + 160)
# asm 1: mulpd 160(<a2b2p=int64#6),<d16=int6464#14
# asm 2: mulpd 160(<a2b2p=%r9),<d16=%xmm13
mulpd 160(%r9),%xmm13

# qhasm: float6464 r16 += d16
# asm 1: addpd <d16=int6464#14,<r16=int6464#6
# asm 2: addpd <d16=%xmm13,<r16=%xmm5
addpd %xmm13,%xmm5

# qhasm: r17 = ab6
# asm 1: movdqa <ab6=int6464#7,>r17=int6464#7
# asm 2: movdqa <ab6=%xmm6,>r17=%xmm6
movdqa %xmm6,%xmm6

# qhasm: float6464 r17 *= *(int128 *)(b2a2p + 176)
# asm 1: mulpd 176(<b2a2p=int64#3),<r17=int6464#7
# asm 2: mulpd 176(<b2a2p=%rdx),<r17=%xmm6
mulpd 176(%rdx),%xmm6

# qhasm: d17 = cd6
# asm 1: movdqa <cd6=int6464#8,>d17=int6464#8
# asm 2: movdqa <cd6=%xmm7,>d17=%xmm7
movdqa %xmm7,%xmm7

# qhasm: float6464 d17 *= *(int128 *)(a2b2p + 176)
# asm 1: mulpd 176(<a2b2p=int64#6),<d17=int6464#8
# asm 2: mulpd 176(<a2b2p=%r9),<d17=%xmm7
mulpd 176(%r9),%xmm7

# qhasm: float6464 r17 += d17
# asm 1: addpd <d17=int6464#8,<r17=int6464#7
# asm 2: addpd <d17=%xmm7,<r17=%xmm6
addpd %xmm7,%xmm6

# qhasm: *(int128 *)(b1b1p + 96) = r6
# asm 1: movdqa <r6=int6464#9,96(<b1b1p=int64#4)
# asm 2: movdqa <r6=%xmm8,96(<b1b1p=%rcx)
movdqa %xmm8,96(%rcx)

# qhasm: ab7 = *(int128 *)(b1b1p + 112)
# asm 1: movdqa 112(<b1b1p=int64#4),>ab7=int6464#8
# asm 2: movdqa 112(<b1b1p=%rcx),>ab7=%xmm7
movdqa 112(%rcx),%xmm7

# qhasm: cd7 = *(int128 *)(ma1a1p + 112)
# asm 1: movdqa 112(<ma1a1p=int64#5),>cd7=int6464#9
# asm 2: movdqa 112(<ma1a1p=%r8),>cd7=%xmm8
movdqa 112(%r8),%xmm8

# qhasm: ab7six = ab7
# asm 1: movdqa <ab7=int6464#8,>ab7six=int6464#14
# asm 2: movdqa <ab7=%xmm7,>ab7six=%xmm13
movdqa %xmm7,%xmm13

# qhasm: cd7six = cd7
# asm 1: movdqa <cd7=int6464#9,>cd7six=int6464#15
# asm 2: movdqa <cd7=%xmm8,>cd7six=%xmm14
movdqa %xmm8,%xmm14

# qhasm: float6464 ab7six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab7six=int6464#14
# asm 2: mulpd SIX_SIX,<ab7six=%xmm13
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 cd7six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<cd7six=int6464#15
# asm 2: mulpd SIX_SIX,<cd7six=%xmm14
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: t7 = ab7
# asm 1: movdqa <ab7=int6464#8,>t7=int6464#16
# asm 2: movdqa <ab7=%xmm7,>t7=%xmm15
movdqa %xmm7,%xmm15

# qhasm: float6464 t7 *= *(int128 *)(b2a2p + 0)
# asm 1: mulpd 0(<b2a2p=int64#3),<t7=int6464#16
# asm 2: mulpd 0(<b2a2p=%rdx),<t7=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r7 += t7
# asm 1: addpd <t7=int6464#16,<r7=int6464#10
# asm 2: addpd <t7=%xmm15,<r7=%xmm9
addpd %xmm15,%xmm9

# qhasm: d7 = cd7
# asm 1: movdqa <cd7=int6464#9,>d7=int6464#16
# asm 2: movdqa <cd7=%xmm8,>d7=%xmm15
movdqa %xmm8,%xmm15

# qhasm: float6464 d7 *= *(int128 *)(a2b2p + 0)
# asm 1: mulpd 0(<a2b2p=int64#6),<d7=int6464#16
# asm 2: mulpd 0(<a2b2p=%r9),<d7=%xmm15
mulpd 0(%r9),%xmm15

# qhasm: float6464 r7 += d7
# asm 1: addpd <d7=int6464#16,<r7=int6464#10
# asm 2: addpd <d7=%xmm15,<r7=%xmm9
addpd %xmm15,%xmm9

# qhasm: t13 = ab7
# asm 1: movdqa <ab7=int6464#8,>t13=int6464#8
# asm 2: movdqa <ab7=%xmm7,>t13=%xmm7
movdqa %xmm7,%xmm7

# qhasm: float6464 t13 *= *(int128 *)(b2a2p + 96)
# asm 1: mulpd 96(<b2a2p=int64#3),<t13=int6464#8
# asm 2: mulpd 96(<b2a2p=%rdx),<t13=%xmm7
mulpd 96(%rdx),%xmm7

# qhasm: float6464 r13 += t13
# asm 1: addpd <t13=int6464#8,<r13=int6464#3
# asm 2: addpd <t13=%xmm7,<r13=%xmm2
addpd %xmm7,%xmm2

# qhasm: d13 = cd7
# asm 1: movdqa <cd7=int6464#9,>d13=int6464#8
# asm 2: movdqa <cd7=%xmm8,>d13=%xmm7
movdqa %xmm8,%xmm7

# qhasm: float6464 d13 *= *(int128 *)(a2b2p + 96)
# asm 1: mulpd 96(<a2b2p=int64#6),<d13=int6464#8
# asm 2: mulpd 96(<a2b2p=%r9),<d13=%xmm7
mulpd 96(%r9),%xmm7

# qhasm: float6464 r13 += d13
# asm 1: addpd <d13=int6464#8,<r13=int6464#3
# asm 2: addpd <d13=%xmm7,<r13=%xmm2
addpd %xmm7,%xmm2

# qhasm: t8 = ab7six
# asm 1: movdqa <ab7six=int6464#14,>t8=int6464#8
# asm 2: movdqa <ab7six=%xmm13,>t8=%xmm7
movdqa %xmm13,%xmm7

# qhasm: float6464 t8 *= *(int128 *)(b2a2p + 16)
# asm 1: mulpd 16(<b2a2p=int64#3),<t8=int6464#8
# asm 2: mulpd 16(<b2a2p=%rdx),<t8=%xmm7
mulpd 16(%rdx),%xmm7

# qhasm: float6464 r8 += t8
# asm 1: addpd <t8=int6464#8,<r8=int6464#11
# asm 2: addpd <t8=%xmm7,<r8=%xmm10
addpd %xmm7,%xmm10

# qhasm: d8 = cd7six
# asm 1: movdqa <cd7six=int6464#15,>d8=int6464#8
# asm 2: movdqa <cd7six=%xmm14,>d8=%xmm7
movdqa %xmm14,%xmm7

# qhasm: float6464 d8 *= *(int128 *)(a2b2p + 16)
# asm 1: mulpd 16(<a2b2p=int64#6),<d8=int6464#8
# asm 2: mulpd 16(<a2b2p=%r9),<d8=%xmm7
mulpd 16(%r9),%xmm7

# qhasm: float6464 r8 += d8
# asm 1: addpd <d8=int6464#8,<r8=int6464#11
# asm 2: addpd <d8=%xmm7,<r8=%xmm10
addpd %xmm7,%xmm10

# qhasm: t9 = ab7six
# asm 1: movdqa <ab7six=int6464#14,>t9=int6464#8
# asm 2: movdqa <ab7six=%xmm13,>t9=%xmm7
movdqa %xmm13,%xmm7

# qhasm: float6464 t9 *= *(int128 *)(b2a2p + 32)
# asm 1: mulpd 32(<b2a2p=int64#3),<t9=int6464#8
# asm 2: mulpd 32(<b2a2p=%rdx),<t9=%xmm7
mulpd 32(%rdx),%xmm7

# qhasm: float6464 r9 += t9
# asm 1: addpd <t9=int6464#8,<r9=int6464#12
# asm 2: addpd <t9=%xmm7,<r9=%xmm11
addpd %xmm7,%xmm11

# qhasm: d9 = cd7six
# asm 1: movdqa <cd7six=int6464#15,>d9=int6464#8
# asm 2: movdqa <cd7six=%xmm14,>d9=%xmm7
movdqa %xmm14,%xmm7

# qhasm: float6464 d9 *= *(int128 *)(a2b2p + 32)
# asm 1: mulpd 32(<a2b2p=int64#6),<d9=int6464#8
# asm 2: mulpd 32(<a2b2p=%r9),<d9=%xmm7
mulpd 32(%r9),%xmm7

# qhasm: float6464 r9 += d9
# asm 1: addpd <d9=int6464#8,<r9=int6464#12
# asm 2: addpd <d9=%xmm7,<r9=%xmm11
addpd %xmm7,%xmm11

# qhasm: t10 = ab7six
# asm 1: movdqa <ab7six=int6464#14,>t10=int6464#8
# asm 2: movdqa <ab7six=%xmm13,>t10=%xmm7
movdqa %xmm13,%xmm7

# qhasm: float6464 t10 *= *(int128 *)(b2a2p + 48)
# asm 1: mulpd 48(<b2a2p=int64#3),<t10=int6464#8
# asm 2: mulpd 48(<b2a2p=%rdx),<t10=%xmm7
mulpd 48(%rdx),%xmm7

# qhasm: float6464 r10 += t10
# asm 1: addpd <t10=int6464#8,<r10=int6464#13
# asm 2: addpd <t10=%xmm7,<r10=%xmm12
addpd %xmm7,%xmm12

# qhasm: d10 = cd7six
# asm 1: movdqa <cd7six=int6464#15,>d10=int6464#8
# asm 2: movdqa <cd7six=%xmm14,>d10=%xmm7
movdqa %xmm14,%xmm7

# qhasm: float6464 d10 *= *(int128 *)(a2b2p + 48)
# asm 1: mulpd 48(<a2b2p=int64#6),<d10=int6464#8
# asm 2: mulpd 48(<a2b2p=%r9),<d10=%xmm7
mulpd 48(%r9),%xmm7

# qhasm: float6464 r10 += d10
# asm 1: addpd <d10=int6464#8,<r10=int6464#13
# asm 2: addpd <d10=%xmm7,<r10=%xmm12
addpd %xmm7,%xmm12

# qhasm: t11 = ab7six
# asm 1: movdqa <ab7six=int6464#14,>t11=int6464#8
# asm 2: movdqa <ab7six=%xmm13,>t11=%xmm7
movdqa %xmm13,%xmm7

# qhasm: float6464 t11 *= *(int128 *)(b2a2p + 64)
# asm 1: mulpd 64(<b2a2p=int64#3),<t11=int6464#8
# asm 2: mulpd 64(<b2a2p=%rdx),<t11=%xmm7
mulpd 64(%rdx),%xmm7

# qhasm: float6464 r11 += t11
# asm 1: addpd <t11=int6464#8,<r11=int6464#1
# asm 2: addpd <t11=%xmm7,<r11=%xmm0
addpd %xmm7,%xmm0

# qhasm: d11 = cd7six
# asm 1: movdqa <cd7six=int6464#15,>d11=int6464#8
# asm 2: movdqa <cd7six=%xmm14,>d11=%xmm7
movdqa %xmm14,%xmm7

# qhasm: float6464 d11 *= *(int128 *)(a2b2p + 64)
# asm 1: mulpd 64(<a2b2p=int64#6),<d11=int6464#8
# asm 2: mulpd 64(<a2b2p=%r9),<d11=%xmm7
mulpd 64(%r9),%xmm7

# qhasm: float6464 r11 += d11
# asm 1: addpd <d11=int6464#8,<r11=int6464#1
# asm 2: addpd <d11=%xmm7,<r11=%xmm0
addpd %xmm7,%xmm0

# qhasm: t12 = ab7six
# asm 1: movdqa <ab7six=int6464#14,>t12=int6464#8
# asm 2: movdqa <ab7six=%xmm13,>t12=%xmm7
movdqa %xmm13,%xmm7

# qhasm: float6464 t12 *= *(int128 *)(b2a2p + 80)
# asm 1: mulpd 80(<b2a2p=int64#3),<t12=int6464#8
# asm 2: mulpd 80(<b2a2p=%rdx),<t12=%xmm7
mulpd 80(%rdx),%xmm7

# qhasm: float6464 r12 += t12
# asm 1: addpd <t12=int6464#8,<r12=int6464#2
# asm 2: addpd <t12=%xmm7,<r12=%xmm1
addpd %xmm7,%xmm1

# qhasm: d12 = cd7six
# asm 1: movdqa <cd7six=int6464#15,>d12=int6464#8
# asm 2: movdqa <cd7six=%xmm14,>d12=%xmm7
movdqa %xmm14,%xmm7

# qhasm: float6464 d12 *= *(int128 *)(a2b2p + 80)
# asm 1: mulpd 80(<a2b2p=int64#6),<d12=int6464#8
# asm 2: mulpd 80(<a2b2p=%r9),<d12=%xmm7
mulpd 80(%r9),%xmm7

# qhasm: float6464 r12 += d12
# asm 1: addpd <d12=int6464#8,<r12=int6464#2
# asm 2: addpd <d12=%xmm7,<r12=%xmm1
addpd %xmm7,%xmm1

# qhasm: t14 = ab7six
# asm 1: movdqa <ab7six=int6464#14,>t14=int6464#8
# asm 2: movdqa <ab7six=%xmm13,>t14=%xmm7
movdqa %xmm13,%xmm7

# qhasm: float6464 t14 *= *(int128 *)(b2a2p + 112)
# asm 1: mulpd 112(<b2a2p=int64#3),<t14=int6464#8
# asm 2: mulpd 112(<b2a2p=%rdx),<t14=%xmm7
mulpd 112(%rdx),%xmm7

# qhasm: float6464 r14 += t14
# asm 1: addpd <t14=int6464#8,<r14=int6464#4
# asm 2: addpd <t14=%xmm7,<r14=%xmm3
addpd %xmm7,%xmm3

# qhasm: d14 = cd7six
# asm 1: movdqa <cd7six=int6464#15,>d14=int6464#8
# asm 2: movdqa <cd7six=%xmm14,>d14=%xmm7
movdqa %xmm14,%xmm7

# qhasm: float6464 d14 *= *(int128 *)(a2b2p + 112)
# asm 1: mulpd 112(<a2b2p=int64#6),<d14=int6464#8
# asm 2: mulpd 112(<a2b2p=%r9),<d14=%xmm7
mulpd 112(%r9),%xmm7

# qhasm: float6464 r14 += d14
# asm 1: addpd <d14=int6464#8,<r14=int6464#4
# asm 2: addpd <d14=%xmm7,<r14=%xmm3
addpd %xmm7,%xmm3

# qhasm: t15 = ab7six
# asm 1: movdqa <ab7six=int6464#14,>t15=int6464#8
# asm 2: movdqa <ab7six=%xmm13,>t15=%xmm7
movdqa %xmm13,%xmm7

# qhasm: float6464 t15 *= *(int128 *)(b2a2p + 128)
# asm 1: mulpd 128(<b2a2p=int64#3),<t15=int6464#8
# asm 2: mulpd 128(<b2a2p=%rdx),<t15=%xmm7
mulpd 128(%rdx),%xmm7

# qhasm: float6464 r15 += t15
# asm 1: addpd <t15=int6464#8,<r15=int6464#5
# asm 2: addpd <t15=%xmm7,<r15=%xmm4
addpd %xmm7,%xmm4

# qhasm: d15 = cd7six
# asm 1: movdqa <cd7six=int6464#15,>d15=int6464#8
# asm 2: movdqa <cd7six=%xmm14,>d15=%xmm7
movdqa %xmm14,%xmm7

# qhasm: float6464 d15 *= *(int128 *)(a2b2p + 128)
# asm 1: mulpd 128(<a2b2p=int64#6),<d15=int6464#8
# asm 2: mulpd 128(<a2b2p=%r9),<d15=%xmm7
mulpd 128(%r9),%xmm7

# qhasm: float6464 r15 += d15
# asm 1: addpd <d15=int6464#8,<r15=int6464#5
# asm 2: addpd <d15=%xmm7,<r15=%xmm4
addpd %xmm7,%xmm4

# qhasm: t16 = ab7six
# asm 1: movdqa <ab7six=int6464#14,>t16=int6464#8
# asm 2: movdqa <ab7six=%xmm13,>t16=%xmm7
movdqa %xmm13,%xmm7

# qhasm: float6464 t16 *= *(int128 *)(b2a2p + 144)
# asm 1: mulpd 144(<b2a2p=int64#3),<t16=int6464#8
# asm 2: mulpd 144(<b2a2p=%rdx),<t16=%xmm7
mulpd 144(%rdx),%xmm7

# qhasm: float6464 r16 += t16
# asm 1: addpd <t16=int6464#8,<r16=int6464#6
# asm 2: addpd <t16=%xmm7,<r16=%xmm5
addpd %xmm7,%xmm5

# qhasm: d16 = cd7six
# asm 1: movdqa <cd7six=int6464#15,>d16=int6464#8
# asm 2: movdqa <cd7six=%xmm14,>d16=%xmm7
movdqa %xmm14,%xmm7

# qhasm: float6464 d16 *= *(int128 *)(a2b2p + 144)
# asm 1: mulpd 144(<a2b2p=int64#6),<d16=int6464#8
# asm 2: mulpd 144(<a2b2p=%r9),<d16=%xmm7
mulpd 144(%r9),%xmm7

# qhasm: float6464 r16 += d16
# asm 1: addpd <d16=int6464#8,<r16=int6464#6
# asm 2: addpd <d16=%xmm7,<r16=%xmm5
addpd %xmm7,%xmm5

# qhasm: t17 = ab7six
# asm 1: movdqa <ab7six=int6464#14,>t17=int6464#8
# asm 2: movdqa <ab7six=%xmm13,>t17=%xmm7
movdqa %xmm13,%xmm7

# qhasm: float6464 t17 *= *(int128 *)(b2a2p + 160)
# asm 1: mulpd 160(<b2a2p=int64#3),<t17=int6464#8
# asm 2: mulpd 160(<b2a2p=%rdx),<t17=%xmm7
mulpd 160(%rdx),%xmm7

# qhasm: float6464 r17 += t17
# asm 1: addpd <t17=int6464#8,<r17=int6464#7
# asm 2: addpd <t17=%xmm7,<r17=%xmm6
addpd %xmm7,%xmm6

# qhasm: d17 = cd7six
# asm 1: movdqa <cd7six=int6464#15,>d17=int6464#8
# asm 2: movdqa <cd7six=%xmm14,>d17=%xmm7
movdqa %xmm14,%xmm7

# qhasm: float6464 d17 *= *(int128 *)(a2b2p + 160)
# asm 1: mulpd 160(<a2b2p=int64#6),<d17=int6464#8
# asm 2: mulpd 160(<a2b2p=%r9),<d17=%xmm7
mulpd 160(%r9),%xmm7

# qhasm: float6464 r17 += d17
# asm 1: addpd <d17=int6464#8,<r17=int6464#7
# asm 2: addpd <d17=%xmm7,<r17=%xmm6
addpd %xmm7,%xmm6

# qhasm: r18 = ab7six
# asm 1: movdqa <ab7six=int6464#14,>r18=int6464#8
# asm 2: movdqa <ab7six=%xmm13,>r18=%xmm7
movdqa %xmm13,%xmm7

# qhasm: float6464 r18 *= *(int128 *)(b2a2p + 176)
# asm 1: mulpd 176(<b2a2p=int64#3),<r18=int6464#8
# asm 2: mulpd 176(<b2a2p=%rdx),<r18=%xmm7
mulpd 176(%rdx),%xmm7

# qhasm: d18 = cd7six
# asm 1: movdqa <cd7six=int6464#15,>d18=int6464#9
# asm 2: movdqa <cd7six=%xmm14,>d18=%xmm8
movdqa %xmm14,%xmm8

# qhasm: float6464 d18 *= *(int128 *)(a2b2p + 176)
# asm 1: mulpd 176(<a2b2p=int64#6),<d18=int6464#9
# asm 2: mulpd 176(<a2b2p=%r9),<d18=%xmm8
mulpd 176(%r9),%xmm8

# qhasm: float6464 r18 += d18
# asm 1: addpd <d18=int6464#9,<r18=int6464#8
# asm 2: addpd <d18=%xmm8,<r18=%xmm7
addpd %xmm8,%xmm7

# qhasm: *(int128 *)(b1b1p + 112) = r7
# asm 1: movdqa <r7=int6464#10,112(<b1b1p=int64#4)
# asm 2: movdqa <r7=%xmm9,112(<b1b1p=%rcx)
movdqa %xmm9,112(%rcx)

# qhasm: ab8 = *(int128 *)(b1b1p + 128)
# asm 1: movdqa 128(<b1b1p=int64#4),>ab8=int6464#9
# asm 2: movdqa 128(<b1b1p=%rcx),>ab8=%xmm8
movdqa 128(%rcx),%xmm8

# qhasm: cd8 = *(int128 *)(ma1a1p + 128)
# asm 1: movdqa 128(<ma1a1p=int64#5),>cd8=int6464#10
# asm 2: movdqa 128(<ma1a1p=%r8),>cd8=%xmm9
movdqa 128(%r8),%xmm9

# qhasm: ab8six = ab8
# asm 1: movdqa <ab8=int6464#9,>ab8six=int6464#14
# asm 2: movdqa <ab8=%xmm8,>ab8six=%xmm13
movdqa %xmm8,%xmm13

# qhasm: cd8six = cd8
# asm 1: movdqa <cd8=int6464#10,>cd8six=int6464#15
# asm 2: movdqa <cd8=%xmm9,>cd8six=%xmm14
movdqa %xmm9,%xmm14

# qhasm: float6464 ab8six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab8six=int6464#14
# asm 2: mulpd SIX_SIX,<ab8six=%xmm13
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 cd8six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<cd8six=int6464#15
# asm 2: mulpd SIX_SIX,<cd8six=%xmm14
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: t8 = ab8
# asm 1: movdqa <ab8=int6464#9,>t8=int6464#16
# asm 2: movdqa <ab8=%xmm8,>t8=%xmm15
movdqa %xmm8,%xmm15

# qhasm: float6464 t8 *= *(int128 *)(b2a2p + 0)
# asm 1: mulpd 0(<b2a2p=int64#3),<t8=int6464#16
# asm 2: mulpd 0(<b2a2p=%rdx),<t8=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r8 += t8
# asm 1: addpd <t8=int6464#16,<r8=int6464#11
# asm 2: addpd <t8=%xmm15,<r8=%xmm10
addpd %xmm15,%xmm10

# qhasm: d8 = cd8
# asm 1: movdqa <cd8=int6464#10,>d8=int6464#16
# asm 2: movdqa <cd8=%xmm9,>d8=%xmm15
movdqa %xmm9,%xmm15

# qhasm: float6464 d8 *= *(int128 *)(a2b2p + 0)
# asm 1: mulpd 0(<a2b2p=int64#6),<d8=int6464#16
# asm 2: mulpd 0(<a2b2p=%r9),<d8=%xmm15
mulpd 0(%r9),%xmm15

# qhasm: float6464 r8 += d8
# asm 1: addpd <d8=int6464#16,<r8=int6464#11
# asm 2: addpd <d8=%xmm15,<r8=%xmm10
addpd %xmm15,%xmm10

# qhasm: t13 = ab8
# asm 1: movdqa <ab8=int6464#9,>t13=int6464#16
# asm 2: movdqa <ab8=%xmm8,>t13=%xmm15
movdqa %xmm8,%xmm15

# qhasm: float6464 t13 *= *(int128 *)(b2a2p + 80)
# asm 1: mulpd 80(<b2a2p=int64#3),<t13=int6464#16
# asm 2: mulpd 80(<b2a2p=%rdx),<t13=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r13 += t13
# asm 1: addpd <t13=int6464#16,<r13=int6464#3
# asm 2: addpd <t13=%xmm15,<r13=%xmm2
addpd %xmm15,%xmm2

# qhasm: d13 = cd8
# asm 1: movdqa <cd8=int6464#10,>d13=int6464#16
# asm 2: movdqa <cd8=%xmm9,>d13=%xmm15
movdqa %xmm9,%xmm15

# qhasm: float6464 d13 *= *(int128 *)(a2b2p + 80)
# asm 1: mulpd 80(<a2b2p=int64#6),<d13=int6464#16
# asm 2: mulpd 80(<a2b2p=%r9),<d13=%xmm15
mulpd 80(%r9),%xmm15

# qhasm: float6464 r13 += d13
# asm 1: addpd <d13=int6464#16,<r13=int6464#3
# asm 2: addpd <d13=%xmm15,<r13=%xmm2
addpd %xmm15,%xmm2

# qhasm: t14 = ab8
# asm 1: movdqa <ab8=int6464#9,>t14=int6464#16
# asm 2: movdqa <ab8=%xmm8,>t14=%xmm15
movdqa %xmm8,%xmm15

# qhasm: float6464 t14 *= *(int128 *)(b2a2p + 96)
# asm 1: mulpd 96(<b2a2p=int64#3),<t14=int6464#16
# asm 2: mulpd 96(<b2a2p=%rdx),<t14=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r14 += t14
# asm 1: addpd <t14=int6464#16,<r14=int6464#4
# asm 2: addpd <t14=%xmm15,<r14=%xmm3
addpd %xmm15,%xmm3

# qhasm: d14 = cd8
# asm 1: movdqa <cd8=int6464#10,>d14=int6464#16
# asm 2: movdqa <cd8=%xmm9,>d14=%xmm15
movdqa %xmm9,%xmm15

# qhasm: float6464 d14 *= *(int128 *)(a2b2p + 96)
# asm 1: mulpd 96(<a2b2p=int64#6),<d14=int6464#16
# asm 2: mulpd 96(<a2b2p=%r9),<d14=%xmm15
mulpd 96(%r9),%xmm15

# qhasm: float6464 r14 += d14
# asm 1: addpd <d14=int6464#16,<r14=int6464#4
# asm 2: addpd <d14=%xmm15,<r14=%xmm3
addpd %xmm15,%xmm3

# qhasm: r19 = ab8
# asm 1: movdqa <ab8=int6464#9,>r19=int6464#9
# asm 2: movdqa <ab8=%xmm8,>r19=%xmm8
movdqa %xmm8,%xmm8

# qhasm: float6464 r19 *= *(int128 *)(b2a2p + 176)
# asm 1: mulpd 176(<b2a2p=int64#3),<r19=int6464#9
# asm 2: mulpd 176(<b2a2p=%rdx),<r19=%xmm8
mulpd 176(%rdx),%xmm8

# qhasm: d19 = cd8
# asm 1: movdqa <cd8=int6464#10,>d19=int6464#10
# asm 2: movdqa <cd8=%xmm9,>d19=%xmm9
movdqa %xmm9,%xmm9

# qhasm: float6464 d19 *= *(int128 *)(a2b2p + 176)
# asm 1: mulpd 176(<a2b2p=int64#6),<d19=int6464#10
# asm 2: mulpd 176(<a2b2p=%r9),<d19=%xmm9
mulpd 176(%r9),%xmm9

# qhasm: float6464 r19 += d19
# asm 1: addpd <d19=int6464#10,<r19=int6464#9
# asm 2: addpd <d19=%xmm9,<r19=%xmm8
addpd %xmm9,%xmm8

# qhasm: t9 = ab8six
# asm 1: movdqa <ab8six=int6464#14,>t9=int6464#10
# asm 2: movdqa <ab8six=%xmm13,>t9=%xmm9
movdqa %xmm13,%xmm9

# qhasm: float6464 t9 *= *(int128 *)(b2a2p + 16)
# asm 1: mulpd 16(<b2a2p=int64#3),<t9=int6464#10
# asm 2: mulpd 16(<b2a2p=%rdx),<t9=%xmm9
mulpd 16(%rdx),%xmm9

# qhasm: float6464 r9 += t9
# asm 1: addpd <t9=int6464#10,<r9=int6464#12
# asm 2: addpd <t9=%xmm9,<r9=%xmm11
addpd %xmm9,%xmm11

# qhasm: d9 = cd8six
# asm 1: movdqa <cd8six=int6464#15,>d9=int6464#10
# asm 2: movdqa <cd8six=%xmm14,>d9=%xmm9
movdqa %xmm14,%xmm9

# qhasm: float6464 d9 *= *(int128 *)(a2b2p + 16)
# asm 1: mulpd 16(<a2b2p=int64#6),<d9=int6464#10
# asm 2: mulpd 16(<a2b2p=%r9),<d9=%xmm9
mulpd 16(%r9),%xmm9

# qhasm: float6464 r9 += d9
# asm 1: addpd <d9=int6464#10,<r9=int6464#12
# asm 2: addpd <d9=%xmm9,<r9=%xmm11
addpd %xmm9,%xmm11

# qhasm: t10 = ab8six
# asm 1: movdqa <ab8six=int6464#14,>t10=int6464#10
# asm 2: movdqa <ab8six=%xmm13,>t10=%xmm9
movdqa %xmm13,%xmm9

# qhasm: float6464 t10 *= *(int128 *)(b2a2p + 32)
# asm 1: mulpd 32(<b2a2p=int64#3),<t10=int6464#10
# asm 2: mulpd 32(<b2a2p=%rdx),<t10=%xmm9
mulpd 32(%rdx),%xmm9

# qhasm: float6464 r10 += t10
# asm 1: addpd <t10=int6464#10,<r10=int6464#13
# asm 2: addpd <t10=%xmm9,<r10=%xmm12
addpd %xmm9,%xmm12

# qhasm: d10 = cd8six
# asm 1: movdqa <cd8six=int6464#15,>d10=int6464#10
# asm 2: movdqa <cd8six=%xmm14,>d10=%xmm9
movdqa %xmm14,%xmm9

# qhasm: float6464 d10 *= *(int128 *)(a2b2p + 32)
# asm 1: mulpd 32(<a2b2p=int64#6),<d10=int6464#10
# asm 2: mulpd 32(<a2b2p=%r9),<d10=%xmm9
mulpd 32(%r9),%xmm9

# qhasm: float6464 r10 += d10
# asm 1: addpd <d10=int6464#10,<r10=int6464#13
# asm 2: addpd <d10=%xmm9,<r10=%xmm12
addpd %xmm9,%xmm12

# qhasm: t11 = ab8six
# asm 1: movdqa <ab8six=int6464#14,>t11=int6464#10
# asm 2: movdqa <ab8six=%xmm13,>t11=%xmm9
movdqa %xmm13,%xmm9

# qhasm: float6464 t11 *= *(int128 *)(b2a2p + 48)
# asm 1: mulpd 48(<b2a2p=int64#3),<t11=int6464#10
# asm 2: mulpd 48(<b2a2p=%rdx),<t11=%xmm9
mulpd 48(%rdx),%xmm9

# qhasm: float6464 r11 += t11
# asm 1: addpd <t11=int6464#10,<r11=int6464#1
# asm 2: addpd <t11=%xmm9,<r11=%xmm0
addpd %xmm9,%xmm0

# qhasm: d11 = cd8six
# asm 1: movdqa <cd8six=int6464#15,>d11=int6464#10
# asm 2: movdqa <cd8six=%xmm14,>d11=%xmm9
movdqa %xmm14,%xmm9

# qhasm: float6464 d11 *= *(int128 *)(a2b2p + 48)
# asm 1: mulpd 48(<a2b2p=int64#6),<d11=int6464#10
# asm 2: mulpd 48(<a2b2p=%r9),<d11=%xmm9
mulpd 48(%r9),%xmm9

# qhasm: float6464 r11 += d11
# asm 1: addpd <d11=int6464#10,<r11=int6464#1
# asm 2: addpd <d11=%xmm9,<r11=%xmm0
addpd %xmm9,%xmm0

# qhasm: t12 = ab8six
# asm 1: movdqa <ab8six=int6464#14,>t12=int6464#10
# asm 2: movdqa <ab8six=%xmm13,>t12=%xmm9
movdqa %xmm13,%xmm9

# qhasm: float6464 t12 *= *(int128 *)(b2a2p + 64)
# asm 1: mulpd 64(<b2a2p=int64#3),<t12=int6464#10
# asm 2: mulpd 64(<b2a2p=%rdx),<t12=%xmm9
mulpd 64(%rdx),%xmm9

# qhasm: float6464 r12 += t12
# asm 1: addpd <t12=int6464#10,<r12=int6464#2
# asm 2: addpd <t12=%xmm9,<r12=%xmm1
addpd %xmm9,%xmm1

# qhasm: d12 = cd8six
# asm 1: movdqa <cd8six=int6464#15,>d12=int6464#10
# asm 2: movdqa <cd8six=%xmm14,>d12=%xmm9
movdqa %xmm14,%xmm9

# qhasm: float6464 d12 *= *(int128 *)(a2b2p + 64)
# asm 1: mulpd 64(<a2b2p=int64#6),<d12=int6464#10
# asm 2: mulpd 64(<a2b2p=%r9),<d12=%xmm9
mulpd 64(%r9),%xmm9

# qhasm: float6464 r12 += d12
# asm 1: addpd <d12=int6464#10,<r12=int6464#2
# asm 2: addpd <d12=%xmm9,<r12=%xmm1
addpd %xmm9,%xmm1

# qhasm: t15 = ab8six
# asm 1: movdqa <ab8six=int6464#14,>t15=int6464#10
# asm 2: movdqa <ab8six=%xmm13,>t15=%xmm9
movdqa %xmm13,%xmm9

# qhasm: float6464 t15 *= *(int128 *)(b2a2p + 112)
# asm 1: mulpd 112(<b2a2p=int64#3),<t15=int6464#10
# asm 2: mulpd 112(<b2a2p=%rdx),<t15=%xmm9
mulpd 112(%rdx),%xmm9

# qhasm: float6464 r15 += t15
# asm 1: addpd <t15=int6464#10,<r15=int6464#5
# asm 2: addpd <t15=%xmm9,<r15=%xmm4
addpd %xmm9,%xmm4

# qhasm: d15 = cd8six
# asm 1: movdqa <cd8six=int6464#15,>d15=int6464#10
# asm 2: movdqa <cd8six=%xmm14,>d15=%xmm9
movdqa %xmm14,%xmm9

# qhasm: float6464 d15 *= *(int128 *)(a2b2p + 112)
# asm 1: mulpd 112(<a2b2p=int64#6),<d15=int6464#10
# asm 2: mulpd 112(<a2b2p=%r9),<d15=%xmm9
mulpd 112(%r9),%xmm9

# qhasm: float6464 r15 += d15
# asm 1: addpd <d15=int6464#10,<r15=int6464#5
# asm 2: addpd <d15=%xmm9,<r15=%xmm4
addpd %xmm9,%xmm4

# qhasm: t16 = ab8six
# asm 1: movdqa <ab8six=int6464#14,>t16=int6464#10
# asm 2: movdqa <ab8six=%xmm13,>t16=%xmm9
movdqa %xmm13,%xmm9

# qhasm: float6464 t16 *= *(int128 *)(b2a2p + 128)
# asm 1: mulpd 128(<b2a2p=int64#3),<t16=int6464#10
# asm 2: mulpd 128(<b2a2p=%rdx),<t16=%xmm9
mulpd 128(%rdx),%xmm9

# qhasm: float6464 r16 += t16
# asm 1: addpd <t16=int6464#10,<r16=int6464#6
# asm 2: addpd <t16=%xmm9,<r16=%xmm5
addpd %xmm9,%xmm5

# qhasm: d16 = cd8six
# asm 1: movdqa <cd8six=int6464#15,>d16=int6464#10
# asm 2: movdqa <cd8six=%xmm14,>d16=%xmm9
movdqa %xmm14,%xmm9

# qhasm: float6464 d16 *= *(int128 *)(a2b2p + 128)
# asm 1: mulpd 128(<a2b2p=int64#6),<d16=int6464#10
# asm 2: mulpd 128(<a2b2p=%r9),<d16=%xmm9
mulpd 128(%r9),%xmm9

# qhasm: float6464 r16 += d16
# asm 1: addpd <d16=int6464#10,<r16=int6464#6
# asm 2: addpd <d16=%xmm9,<r16=%xmm5
addpd %xmm9,%xmm5

# qhasm: t17 = ab8six
# asm 1: movdqa <ab8six=int6464#14,>t17=int6464#10
# asm 2: movdqa <ab8six=%xmm13,>t17=%xmm9
movdqa %xmm13,%xmm9

# qhasm: float6464 t17 *= *(int128 *)(b2a2p + 144)
# asm 1: mulpd 144(<b2a2p=int64#3),<t17=int6464#10
# asm 2: mulpd 144(<b2a2p=%rdx),<t17=%xmm9
mulpd 144(%rdx),%xmm9

# qhasm: float6464 r17 += t17
# asm 1: addpd <t17=int6464#10,<r17=int6464#7
# asm 2: addpd <t17=%xmm9,<r17=%xmm6
addpd %xmm9,%xmm6

# qhasm: d17 = cd8six
# asm 1: movdqa <cd8six=int6464#15,>d17=int6464#10
# asm 2: movdqa <cd8six=%xmm14,>d17=%xmm9
movdqa %xmm14,%xmm9

# qhasm: float6464 d17 *= *(int128 *)(a2b2p + 144)
# asm 1: mulpd 144(<a2b2p=int64#6),<d17=int6464#10
# asm 2: mulpd 144(<a2b2p=%r9),<d17=%xmm9
mulpd 144(%r9),%xmm9

# qhasm: float6464 r17 += d17
# asm 1: addpd <d17=int6464#10,<r17=int6464#7
# asm 2: addpd <d17=%xmm9,<r17=%xmm6
addpd %xmm9,%xmm6

# qhasm: t18 = ab8six
# asm 1: movdqa <ab8six=int6464#14,>t18=int6464#10
# asm 2: movdqa <ab8six=%xmm13,>t18=%xmm9
movdqa %xmm13,%xmm9

# qhasm: float6464 t18 *= *(int128 *)(b2a2p + 160)
# asm 1: mulpd 160(<b2a2p=int64#3),<t18=int6464#10
# asm 2: mulpd 160(<b2a2p=%rdx),<t18=%xmm9
mulpd 160(%rdx),%xmm9

# qhasm: float6464 r18 += t18
# asm 1: addpd <t18=int6464#10,<r18=int6464#8
# asm 2: addpd <t18=%xmm9,<r18=%xmm7
addpd %xmm9,%xmm7

# qhasm: d18 = cd8six
# asm 1: movdqa <cd8six=int6464#15,>d18=int6464#10
# asm 2: movdqa <cd8six=%xmm14,>d18=%xmm9
movdqa %xmm14,%xmm9

# qhasm: float6464 d18 *= *(int128 *)(a2b2p + 160)
# asm 1: mulpd 160(<a2b2p=int64#6),<d18=int6464#10
# asm 2: mulpd 160(<a2b2p=%r9),<d18=%xmm9
mulpd 160(%r9),%xmm9

# qhasm: float6464 r18 += d18
# asm 1: addpd <d18=int6464#10,<r18=int6464#8
# asm 2: addpd <d18=%xmm9,<r18=%xmm7
addpd %xmm9,%xmm7

# qhasm: *(int128 *)(b1b1p + 128) = r8
# asm 1: movdqa <r8=int6464#11,128(<b1b1p=int64#4)
# asm 2: movdqa <r8=%xmm10,128(<b1b1p=%rcx)
movdqa %xmm10,128(%rcx)

# qhasm: ab9 = *(int128 *)(b1b1p + 144)
# asm 1: movdqa 144(<b1b1p=int64#4),>ab9=int6464#10
# asm 2: movdqa 144(<b1b1p=%rcx),>ab9=%xmm9
movdqa 144(%rcx),%xmm9

# qhasm: cd9 = *(int128 *)(ma1a1p + 144)
# asm 1: movdqa 144(<ma1a1p=int64#5),>cd9=int6464#11
# asm 2: movdqa 144(<ma1a1p=%r8),>cd9=%xmm10
movdqa 144(%r8),%xmm10

# qhasm: ab9six = ab9
# asm 1: movdqa <ab9=int6464#10,>ab9six=int6464#14
# asm 2: movdqa <ab9=%xmm9,>ab9six=%xmm13
movdqa %xmm9,%xmm13

# qhasm: cd9six = cd9
# asm 1: movdqa <cd9=int6464#11,>cd9six=int6464#15
# asm 2: movdqa <cd9=%xmm10,>cd9six=%xmm14
movdqa %xmm10,%xmm14

# qhasm: float6464 ab9six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab9six=int6464#14
# asm 2: mulpd SIX_SIX,<ab9six=%xmm13
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 cd9six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<cd9six=int6464#15
# asm 2: mulpd SIX_SIX,<cd9six=%xmm14
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: t9 = ab9
# asm 1: movdqa <ab9=int6464#10,>t9=int6464#16
# asm 2: movdqa <ab9=%xmm9,>t9=%xmm15
movdqa %xmm9,%xmm15

# qhasm: float6464 t9 *= *(int128 *)(b2a2p + 0)
# asm 1: mulpd 0(<b2a2p=int64#3),<t9=int6464#16
# asm 2: mulpd 0(<b2a2p=%rdx),<t9=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r9 += t9
# asm 1: addpd <t9=int6464#16,<r9=int6464#12
# asm 2: addpd <t9=%xmm15,<r9=%xmm11
addpd %xmm15,%xmm11

# qhasm: d9 = cd9
# asm 1: movdqa <cd9=int6464#11,>d9=int6464#16
# asm 2: movdqa <cd9=%xmm10,>d9=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 d9 *= *(int128 *)(a2b2p + 0)
# asm 1: mulpd 0(<a2b2p=int64#6),<d9=int6464#16
# asm 2: mulpd 0(<a2b2p=%r9),<d9=%xmm15
mulpd 0(%r9),%xmm15

# qhasm: float6464 r9 += d9
# asm 1: addpd <d9=int6464#16,<r9=int6464#12
# asm 2: addpd <d9=%xmm15,<r9=%xmm11
addpd %xmm15,%xmm11

# qhasm: t13 = ab9
# asm 1: movdqa <ab9=int6464#10,>t13=int6464#16
# asm 2: movdqa <ab9=%xmm9,>t13=%xmm15
movdqa %xmm9,%xmm15

# qhasm: float6464 t13 *= *(int128 *)(b2a2p + 64)
# asm 1: mulpd 64(<b2a2p=int64#3),<t13=int6464#16
# asm 2: mulpd 64(<b2a2p=%rdx),<t13=%xmm15
mulpd 64(%rdx),%xmm15

# qhasm: float6464 r13 += t13
# asm 1: addpd <t13=int6464#16,<r13=int6464#3
# asm 2: addpd <t13=%xmm15,<r13=%xmm2
addpd %xmm15,%xmm2

# qhasm: d13 = cd9
# asm 1: movdqa <cd9=int6464#11,>d13=int6464#16
# asm 2: movdqa <cd9=%xmm10,>d13=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 d13 *= *(int128 *)(a2b2p + 64)
# asm 1: mulpd 64(<a2b2p=int64#6),<d13=int6464#16
# asm 2: mulpd 64(<a2b2p=%r9),<d13=%xmm15
mulpd 64(%r9),%xmm15

# qhasm: float6464 r13 += d13
# asm 1: addpd <d13=int6464#16,<r13=int6464#3
# asm 2: addpd <d13=%xmm15,<r13=%xmm2
addpd %xmm15,%xmm2

# qhasm: t14 = ab9
# asm 1: movdqa <ab9=int6464#10,>t14=int6464#16
# asm 2: movdqa <ab9=%xmm9,>t14=%xmm15
movdqa %xmm9,%xmm15

# qhasm: float6464 t14 *= *(int128 *)(b2a2p + 80)
# asm 1: mulpd 80(<b2a2p=int64#3),<t14=int6464#16
# asm 2: mulpd 80(<b2a2p=%rdx),<t14=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r14 += t14
# asm 1: addpd <t14=int6464#16,<r14=int6464#4
# asm 2: addpd <t14=%xmm15,<r14=%xmm3
addpd %xmm15,%xmm3

# qhasm: d14 = cd9
# asm 1: movdqa <cd9=int6464#11,>d14=int6464#16
# asm 2: movdqa <cd9=%xmm10,>d14=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 d14 *= *(int128 *)(a2b2p + 80)
# asm 1: mulpd 80(<a2b2p=int64#6),<d14=int6464#16
# asm 2: mulpd 80(<a2b2p=%r9),<d14=%xmm15
mulpd 80(%r9),%xmm15

# qhasm: float6464 r14 += d14
# asm 1: addpd <d14=int6464#16,<r14=int6464#4
# asm 2: addpd <d14=%xmm15,<r14=%xmm3
addpd %xmm15,%xmm3

# qhasm: t15 = ab9
# asm 1: movdqa <ab9=int6464#10,>t15=int6464#16
# asm 2: movdqa <ab9=%xmm9,>t15=%xmm15
movdqa %xmm9,%xmm15

# qhasm: float6464 t15 *= *(int128 *)(b2a2p + 96)
# asm 1: mulpd 96(<b2a2p=int64#3),<t15=int6464#16
# asm 2: mulpd 96(<b2a2p=%rdx),<t15=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r15 += t15
# asm 1: addpd <t15=int6464#16,<r15=int6464#5
# asm 2: addpd <t15=%xmm15,<r15=%xmm4
addpd %xmm15,%xmm4

# qhasm: d15 = cd9
# asm 1: movdqa <cd9=int6464#11,>d15=int6464#16
# asm 2: movdqa <cd9=%xmm10,>d15=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 d15 *= *(int128 *)(a2b2p + 96)
# asm 1: mulpd 96(<a2b2p=int64#6),<d15=int6464#16
# asm 2: mulpd 96(<a2b2p=%r9),<d15=%xmm15
mulpd 96(%r9),%xmm15

# qhasm: float6464 r15 += d15
# asm 1: addpd <d15=int6464#16,<r15=int6464#5
# asm 2: addpd <d15=%xmm15,<r15=%xmm4
addpd %xmm15,%xmm4

# qhasm: t19 = ab9
# asm 1: movdqa <ab9=int6464#10,>t19=int6464#16
# asm 2: movdqa <ab9=%xmm9,>t19=%xmm15
movdqa %xmm9,%xmm15

# qhasm: float6464 t19 *= *(int128 *)(b2a2p + 160)
# asm 1: mulpd 160(<b2a2p=int64#3),<t19=int6464#16
# asm 2: mulpd 160(<b2a2p=%rdx),<t19=%xmm15
mulpd 160(%rdx),%xmm15

# qhasm: float6464 r19 += t19
# asm 1: addpd <t19=int6464#16,<r19=int6464#9
# asm 2: addpd <t19=%xmm15,<r19=%xmm8
addpd %xmm15,%xmm8

# qhasm: d19 = cd9
# asm 1: movdqa <cd9=int6464#11,>d19=int6464#16
# asm 2: movdqa <cd9=%xmm10,>d19=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 d19 *= *(int128 *)(a2b2p + 160)
# asm 1: mulpd 160(<a2b2p=int64#6),<d19=int6464#16
# asm 2: mulpd 160(<a2b2p=%r9),<d19=%xmm15
mulpd 160(%r9),%xmm15

# qhasm: float6464 r19 += d19
# asm 1: addpd <d19=int6464#16,<r19=int6464#9
# asm 2: addpd <d19=%xmm15,<r19=%xmm8
addpd %xmm15,%xmm8

# qhasm: r20 = ab9
# asm 1: movdqa <ab9=int6464#10,>r20=int6464#10
# asm 2: movdqa <ab9=%xmm9,>r20=%xmm9
movdqa %xmm9,%xmm9

# qhasm: float6464 r20 *= *(int128 *)(b2a2p + 176)
# asm 1: mulpd 176(<b2a2p=int64#3),<r20=int6464#10
# asm 2: mulpd 176(<b2a2p=%rdx),<r20=%xmm9
mulpd 176(%rdx),%xmm9

# qhasm: d20 = cd9
# asm 1: movdqa <cd9=int6464#11,>d20=int6464#11
# asm 2: movdqa <cd9=%xmm10,>d20=%xmm10
movdqa %xmm10,%xmm10

# qhasm: float6464 d20 *= *(int128 *)(a2b2p + 176)
# asm 1: mulpd 176(<a2b2p=int64#6),<d20=int6464#11
# asm 2: mulpd 176(<a2b2p=%r9),<d20=%xmm10
mulpd 176(%r9),%xmm10

# qhasm: float6464 r20 += d20
# asm 1: addpd <d20=int6464#11,<r20=int6464#10
# asm 2: addpd <d20=%xmm10,<r20=%xmm9
addpd %xmm10,%xmm9

# qhasm: t10 = ab9six
# asm 1: movdqa <ab9six=int6464#14,>t10=int6464#11
# asm 2: movdqa <ab9six=%xmm13,>t10=%xmm10
movdqa %xmm13,%xmm10

# qhasm: float6464 t10 *= *(int128 *)(b2a2p + 16)
# asm 1: mulpd 16(<b2a2p=int64#3),<t10=int6464#11
# asm 2: mulpd 16(<b2a2p=%rdx),<t10=%xmm10
mulpd 16(%rdx),%xmm10

# qhasm: float6464 r10 += t10
# asm 1: addpd <t10=int6464#11,<r10=int6464#13
# asm 2: addpd <t10=%xmm10,<r10=%xmm12
addpd %xmm10,%xmm12

# qhasm: d10 = cd9six
# asm 1: movdqa <cd9six=int6464#15,>d10=int6464#11
# asm 2: movdqa <cd9six=%xmm14,>d10=%xmm10
movdqa %xmm14,%xmm10

# qhasm: float6464 d10 *= *(int128 *)(a2b2p + 16)
# asm 1: mulpd 16(<a2b2p=int64#6),<d10=int6464#11
# asm 2: mulpd 16(<a2b2p=%r9),<d10=%xmm10
mulpd 16(%r9),%xmm10

# qhasm: float6464 r10 += d10
# asm 1: addpd <d10=int6464#11,<r10=int6464#13
# asm 2: addpd <d10=%xmm10,<r10=%xmm12
addpd %xmm10,%xmm12

# qhasm: t11 = ab9six
# asm 1: movdqa <ab9six=int6464#14,>t11=int6464#11
# asm 2: movdqa <ab9six=%xmm13,>t11=%xmm10
movdqa %xmm13,%xmm10

# qhasm: float6464 t11 *= *(int128 *)(b2a2p + 32)
# asm 1: mulpd 32(<b2a2p=int64#3),<t11=int6464#11
# asm 2: mulpd 32(<b2a2p=%rdx),<t11=%xmm10
mulpd 32(%rdx),%xmm10

# qhasm: float6464 r11 += t11
# asm 1: addpd <t11=int6464#11,<r11=int6464#1
# asm 2: addpd <t11=%xmm10,<r11=%xmm0
addpd %xmm10,%xmm0

# qhasm: d11 = cd9six
# asm 1: movdqa <cd9six=int6464#15,>d11=int6464#11
# asm 2: movdqa <cd9six=%xmm14,>d11=%xmm10
movdqa %xmm14,%xmm10

# qhasm: float6464 d11 *= *(int128 *)(a2b2p + 32)
# asm 1: mulpd 32(<a2b2p=int64#6),<d11=int6464#11
# asm 2: mulpd 32(<a2b2p=%r9),<d11=%xmm10
mulpd 32(%r9),%xmm10

# qhasm: float6464 r11 += d11
# asm 1: addpd <d11=int6464#11,<r11=int6464#1
# asm 2: addpd <d11=%xmm10,<r11=%xmm0
addpd %xmm10,%xmm0

# qhasm: t12 = ab9six
# asm 1: movdqa <ab9six=int6464#14,>t12=int6464#11
# asm 2: movdqa <ab9six=%xmm13,>t12=%xmm10
movdqa %xmm13,%xmm10

# qhasm: float6464 t12 *= *(int128 *)(b2a2p + 48)
# asm 1: mulpd 48(<b2a2p=int64#3),<t12=int6464#11
# asm 2: mulpd 48(<b2a2p=%rdx),<t12=%xmm10
mulpd 48(%rdx),%xmm10

# qhasm: float6464 r12 += t12
# asm 1: addpd <t12=int6464#11,<r12=int6464#2
# asm 2: addpd <t12=%xmm10,<r12=%xmm1
addpd %xmm10,%xmm1

# qhasm: d12 = cd9six
# asm 1: movdqa <cd9six=int6464#15,>d12=int6464#11
# asm 2: movdqa <cd9six=%xmm14,>d12=%xmm10
movdqa %xmm14,%xmm10

# qhasm: float6464 d12 *= *(int128 *)(a2b2p + 48)
# asm 1: mulpd 48(<a2b2p=int64#6),<d12=int6464#11
# asm 2: mulpd 48(<a2b2p=%r9),<d12=%xmm10
mulpd 48(%r9),%xmm10

# qhasm: float6464 r12 += d12
# asm 1: addpd <d12=int6464#11,<r12=int6464#2
# asm 2: addpd <d12=%xmm10,<r12=%xmm1
addpd %xmm10,%xmm1

# qhasm: t16 = ab9six
# asm 1: movdqa <ab9six=int6464#14,>t16=int6464#11
# asm 2: movdqa <ab9six=%xmm13,>t16=%xmm10
movdqa %xmm13,%xmm10

# qhasm: float6464 t16 *= *(int128 *)(b2a2p + 112)
# asm 1: mulpd 112(<b2a2p=int64#3),<t16=int6464#11
# asm 2: mulpd 112(<b2a2p=%rdx),<t16=%xmm10
mulpd 112(%rdx),%xmm10

# qhasm: float6464 r16 += t16
# asm 1: addpd <t16=int6464#11,<r16=int6464#6
# asm 2: addpd <t16=%xmm10,<r16=%xmm5
addpd %xmm10,%xmm5

# qhasm: d16 = cd9six
# asm 1: movdqa <cd9six=int6464#15,>d16=int6464#11
# asm 2: movdqa <cd9six=%xmm14,>d16=%xmm10
movdqa %xmm14,%xmm10

# qhasm: float6464 d16 *= *(int128 *)(a2b2p + 112)
# asm 1: mulpd 112(<a2b2p=int64#6),<d16=int6464#11
# asm 2: mulpd 112(<a2b2p=%r9),<d16=%xmm10
mulpd 112(%r9),%xmm10

# qhasm: float6464 r16 += d16
# asm 1: addpd <d16=int6464#11,<r16=int6464#6
# asm 2: addpd <d16=%xmm10,<r16=%xmm5
addpd %xmm10,%xmm5

# qhasm: t17 = ab9six
# asm 1: movdqa <ab9six=int6464#14,>t17=int6464#11
# asm 2: movdqa <ab9six=%xmm13,>t17=%xmm10
movdqa %xmm13,%xmm10

# qhasm: float6464 t17 *= *(int128 *)(b2a2p + 128)
# asm 1: mulpd 128(<b2a2p=int64#3),<t17=int6464#11
# asm 2: mulpd 128(<b2a2p=%rdx),<t17=%xmm10
mulpd 128(%rdx),%xmm10

# qhasm: float6464 r17 += t17
# asm 1: addpd <t17=int6464#11,<r17=int6464#7
# asm 2: addpd <t17=%xmm10,<r17=%xmm6
addpd %xmm10,%xmm6

# qhasm: d17 = cd9six
# asm 1: movdqa <cd9six=int6464#15,>d17=int6464#11
# asm 2: movdqa <cd9six=%xmm14,>d17=%xmm10
movdqa %xmm14,%xmm10

# qhasm: float6464 d17 *= *(int128 *)(a2b2p + 128)
# asm 1: mulpd 128(<a2b2p=int64#6),<d17=int6464#11
# asm 2: mulpd 128(<a2b2p=%r9),<d17=%xmm10
mulpd 128(%r9),%xmm10

# qhasm: float6464 r17 += d17
# asm 1: addpd <d17=int6464#11,<r17=int6464#7
# asm 2: addpd <d17=%xmm10,<r17=%xmm6
addpd %xmm10,%xmm6

# qhasm: t18 = ab9six
# asm 1: movdqa <ab9six=int6464#14,>t18=int6464#11
# asm 2: movdqa <ab9six=%xmm13,>t18=%xmm10
movdqa %xmm13,%xmm10

# qhasm: float6464 t18 *= *(int128 *)(b2a2p + 144)
# asm 1: mulpd 144(<b2a2p=int64#3),<t18=int6464#11
# asm 2: mulpd 144(<b2a2p=%rdx),<t18=%xmm10
mulpd 144(%rdx),%xmm10

# qhasm: float6464 r18 += t18
# asm 1: addpd <t18=int6464#11,<r18=int6464#8
# asm 2: addpd <t18=%xmm10,<r18=%xmm7
addpd %xmm10,%xmm7

# qhasm: d18 = cd9six
# asm 1: movdqa <cd9six=int6464#15,>d18=int6464#11
# asm 2: movdqa <cd9six=%xmm14,>d18=%xmm10
movdqa %xmm14,%xmm10

# qhasm: float6464 d18 *= *(int128 *)(a2b2p + 144)
# asm 1: mulpd 144(<a2b2p=int64#6),<d18=int6464#11
# asm 2: mulpd 144(<a2b2p=%r9),<d18=%xmm10
mulpd 144(%r9),%xmm10

# qhasm: float6464 r18 += d18
# asm 1: addpd <d18=int6464#11,<r18=int6464#8
# asm 2: addpd <d18=%xmm10,<r18=%xmm7
addpd %xmm10,%xmm7

# qhasm: *(int128 *)(b1b1p + 144) = r9
# asm 1: movdqa <r9=int6464#12,144(<b1b1p=int64#4)
# asm 2: movdqa <r9=%xmm11,144(<b1b1p=%rcx)
movdqa %xmm11,144(%rcx)

# qhasm: ab10 = *(int128 *)(b1b1p + 160)
# asm 1: movdqa 160(<b1b1p=int64#4),>ab10=int6464#11
# asm 2: movdqa 160(<b1b1p=%rcx),>ab10=%xmm10
movdqa 160(%rcx),%xmm10

# qhasm: cd10 = *(int128 *)(ma1a1p + 160)
# asm 1: movdqa 160(<ma1a1p=int64#5),>cd10=int6464#12
# asm 2: movdqa 160(<ma1a1p=%r8),>cd10=%xmm11
movdqa 160(%r8),%xmm11

# qhasm: ab10six = ab10
# asm 1: movdqa <ab10=int6464#11,>ab10six=int6464#14
# asm 2: movdqa <ab10=%xmm10,>ab10six=%xmm13
movdqa %xmm10,%xmm13

# qhasm: cd10six = cd10
# asm 1: movdqa <cd10=int6464#12,>cd10six=int6464#15
# asm 2: movdqa <cd10=%xmm11,>cd10six=%xmm14
movdqa %xmm11,%xmm14

# qhasm: float6464 ab10six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab10six=int6464#14
# asm 2: mulpd SIX_SIX,<ab10six=%xmm13
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 cd10six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<cd10six=int6464#15
# asm 2: mulpd SIX_SIX,<cd10six=%xmm14
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: t10 = ab10
# asm 1: movdqa <ab10=int6464#11,>t10=int6464#16
# asm 2: movdqa <ab10=%xmm10,>t10=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t10 *= *(int128 *)(b2a2p + 0)
# asm 1: mulpd 0(<b2a2p=int64#3),<t10=int6464#16
# asm 2: mulpd 0(<b2a2p=%rdx),<t10=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r10 += t10
# asm 1: addpd <t10=int6464#16,<r10=int6464#13
# asm 2: addpd <t10=%xmm15,<r10=%xmm12
addpd %xmm15,%xmm12

# qhasm: d10 = cd10
# asm 1: movdqa <cd10=int6464#12,>d10=int6464#16
# asm 2: movdqa <cd10=%xmm11,>d10=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 d10 *= *(int128 *)(a2b2p + 0)
# asm 1: mulpd 0(<a2b2p=int64#6),<d10=int6464#16
# asm 2: mulpd 0(<a2b2p=%r9),<d10=%xmm15
mulpd 0(%r9),%xmm15

# qhasm: float6464 r10 += d10
# asm 1: addpd <d10=int6464#16,<r10=int6464#13
# asm 2: addpd <d10=%xmm15,<r10=%xmm12
addpd %xmm15,%xmm12

# qhasm: t13 = ab10
# asm 1: movdqa <ab10=int6464#11,>t13=int6464#16
# asm 2: movdqa <ab10=%xmm10,>t13=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t13 *= *(int128 *)(b2a2p + 48)
# asm 1: mulpd 48(<b2a2p=int64#3),<t13=int6464#16
# asm 2: mulpd 48(<b2a2p=%rdx),<t13=%xmm15
mulpd 48(%rdx),%xmm15

# qhasm: float6464 r13 += t13
# asm 1: addpd <t13=int6464#16,<r13=int6464#3
# asm 2: addpd <t13=%xmm15,<r13=%xmm2
addpd %xmm15,%xmm2

# qhasm: d13 = cd10
# asm 1: movdqa <cd10=int6464#12,>d13=int6464#16
# asm 2: movdqa <cd10=%xmm11,>d13=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 d13 *= *(int128 *)(a2b2p + 48)
# asm 1: mulpd 48(<a2b2p=int64#6),<d13=int6464#16
# asm 2: mulpd 48(<a2b2p=%r9),<d13=%xmm15
mulpd 48(%r9),%xmm15

# qhasm: float6464 r13 += d13
# asm 1: addpd <d13=int6464#16,<r13=int6464#3
# asm 2: addpd <d13=%xmm15,<r13=%xmm2
addpd %xmm15,%xmm2

# qhasm: t14 = ab10
# asm 1: movdqa <ab10=int6464#11,>t14=int6464#16
# asm 2: movdqa <ab10=%xmm10,>t14=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t14 *= *(int128 *)(b2a2p + 64)
# asm 1: mulpd 64(<b2a2p=int64#3),<t14=int6464#16
# asm 2: mulpd 64(<b2a2p=%rdx),<t14=%xmm15
mulpd 64(%rdx),%xmm15

# qhasm: float6464 r14 += t14
# asm 1: addpd <t14=int6464#16,<r14=int6464#4
# asm 2: addpd <t14=%xmm15,<r14=%xmm3
addpd %xmm15,%xmm3

# qhasm: d14 = cd10
# asm 1: movdqa <cd10=int6464#12,>d14=int6464#16
# asm 2: movdqa <cd10=%xmm11,>d14=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 d14 *= *(int128 *)(a2b2p + 64)
# asm 1: mulpd 64(<a2b2p=int64#6),<d14=int6464#16
# asm 2: mulpd 64(<a2b2p=%r9),<d14=%xmm15
mulpd 64(%r9),%xmm15

# qhasm: float6464 r14 += d14
# asm 1: addpd <d14=int6464#16,<r14=int6464#4
# asm 2: addpd <d14=%xmm15,<r14=%xmm3
addpd %xmm15,%xmm3

# qhasm: t16 = ab10
# asm 1: movdqa <ab10=int6464#11,>t16=int6464#16
# asm 2: movdqa <ab10=%xmm10,>t16=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t16 *= *(int128 *)(b2a2p + 96)
# asm 1: mulpd 96(<b2a2p=int64#3),<t16=int6464#16
# asm 2: mulpd 96(<b2a2p=%rdx),<t16=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r16 += t16
# asm 1: addpd <t16=int6464#16,<r16=int6464#6
# asm 2: addpd <t16=%xmm15,<r16=%xmm5
addpd %xmm15,%xmm5

# qhasm: d16 = cd10
# asm 1: movdqa <cd10=int6464#12,>d16=int6464#16
# asm 2: movdqa <cd10=%xmm11,>d16=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 d16 *= *(int128 *)(a2b2p + 96)
# asm 1: mulpd 96(<a2b2p=int64#6),<d16=int6464#16
# asm 2: mulpd 96(<a2b2p=%r9),<d16=%xmm15
mulpd 96(%r9),%xmm15

# qhasm: float6464 r16 += d16
# asm 1: addpd <d16=int6464#16,<r16=int6464#6
# asm 2: addpd <d16=%xmm15,<r16=%xmm5
addpd %xmm15,%xmm5

# qhasm: t15 = ab10
# asm 1: movdqa <ab10=int6464#11,>t15=int6464#16
# asm 2: movdqa <ab10=%xmm10,>t15=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t15 *= *(int128 *)(b2a2p + 80)
# asm 1: mulpd 80(<b2a2p=int64#3),<t15=int6464#16
# asm 2: mulpd 80(<b2a2p=%rdx),<t15=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r15 += t15
# asm 1: addpd <t15=int6464#16,<r15=int6464#5
# asm 2: addpd <t15=%xmm15,<r15=%xmm4
addpd %xmm15,%xmm4

# qhasm: d15 = cd10
# asm 1: movdqa <cd10=int6464#12,>d15=int6464#16
# asm 2: movdqa <cd10=%xmm11,>d15=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 d15 *= *(int128 *)(a2b2p + 80)
# asm 1: mulpd 80(<a2b2p=int64#6),<d15=int6464#16
# asm 2: mulpd 80(<a2b2p=%r9),<d15=%xmm15
mulpd 80(%r9),%xmm15

# qhasm: float6464 r15 += d15
# asm 1: addpd <d15=int6464#16,<r15=int6464#5
# asm 2: addpd <d15=%xmm15,<r15=%xmm4
addpd %xmm15,%xmm4

# qhasm: t19 = ab10
# asm 1: movdqa <ab10=int6464#11,>t19=int6464#16
# asm 2: movdqa <ab10=%xmm10,>t19=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t19 *= *(int128 *)(b2a2p + 144)
# asm 1: mulpd 144(<b2a2p=int64#3),<t19=int6464#16
# asm 2: mulpd 144(<b2a2p=%rdx),<t19=%xmm15
mulpd 144(%rdx),%xmm15

# qhasm: float6464 r19 += t19
# asm 1: addpd <t19=int6464#16,<r19=int6464#9
# asm 2: addpd <t19=%xmm15,<r19=%xmm8
addpd %xmm15,%xmm8

# qhasm: d19 = cd10
# asm 1: movdqa <cd10=int6464#12,>d19=int6464#16
# asm 2: movdqa <cd10=%xmm11,>d19=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 d19 *= *(int128 *)(a2b2p + 144)
# asm 1: mulpd 144(<a2b2p=int64#6),<d19=int6464#16
# asm 2: mulpd 144(<a2b2p=%r9),<d19=%xmm15
mulpd 144(%r9),%xmm15

# qhasm: float6464 r19 += d19
# asm 1: addpd <d19=int6464#16,<r19=int6464#9
# asm 2: addpd <d19=%xmm15,<r19=%xmm8
addpd %xmm15,%xmm8

# qhasm: t20 = ab10
# asm 1: movdqa <ab10=int6464#11,>t20=int6464#16
# asm 2: movdqa <ab10=%xmm10,>t20=%xmm15
movdqa %xmm10,%xmm15

# qhasm: float6464 t20 *= *(int128 *)(b2a2p + 160)
# asm 1: mulpd 160(<b2a2p=int64#3),<t20=int6464#16
# asm 2: mulpd 160(<b2a2p=%rdx),<t20=%xmm15
mulpd 160(%rdx),%xmm15

# qhasm: float6464 r20 += t20
# asm 1: addpd <t20=int6464#16,<r20=int6464#10
# asm 2: addpd <t20=%xmm15,<r20=%xmm9
addpd %xmm15,%xmm9

# qhasm: d20 = cd10
# asm 1: movdqa <cd10=int6464#12,>d20=int6464#16
# asm 2: movdqa <cd10=%xmm11,>d20=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 d20 *= *(int128 *)(a2b2p + 160)
# asm 1: mulpd 160(<a2b2p=int64#6),<d20=int6464#16
# asm 2: mulpd 160(<a2b2p=%r9),<d20=%xmm15
mulpd 160(%r9),%xmm15

# qhasm: float6464 r20 += d20
# asm 1: addpd <d20=int6464#16,<r20=int6464#10
# asm 2: addpd <d20=%xmm15,<r20=%xmm9
addpd %xmm15,%xmm9

# qhasm: r21 = ab10
# asm 1: movdqa <ab10=int6464#11,>r21=int6464#11
# asm 2: movdqa <ab10=%xmm10,>r21=%xmm10
movdqa %xmm10,%xmm10

# qhasm: float6464 r21 *= *(int128 *)(b2a2p + 176)
# asm 1: mulpd 176(<b2a2p=int64#3),<r21=int6464#11
# asm 2: mulpd 176(<b2a2p=%rdx),<r21=%xmm10
mulpd 176(%rdx),%xmm10

# qhasm: d21 = cd10
# asm 1: movdqa <cd10=int6464#12,>d21=int6464#12
# asm 2: movdqa <cd10=%xmm11,>d21=%xmm11
movdqa %xmm11,%xmm11

# qhasm: float6464 d21 *= *(int128 *)(a2b2p + 176)
# asm 1: mulpd 176(<a2b2p=int64#6),<d21=int6464#12
# asm 2: mulpd 176(<a2b2p=%r9),<d21=%xmm11
mulpd 176(%r9),%xmm11

# qhasm: float6464 r21 += d21
# asm 1: addpd <d21=int6464#12,<r21=int6464#11
# asm 2: addpd <d21=%xmm11,<r21=%xmm10
addpd %xmm11,%xmm10

# qhasm: t11 = ab10six
# asm 1: movdqa <ab10six=int6464#14,>t11=int6464#12
# asm 2: movdqa <ab10six=%xmm13,>t11=%xmm11
movdqa %xmm13,%xmm11

# qhasm: float6464 t11 *= *(int128 *)(b2a2p + 16)
# asm 1: mulpd 16(<b2a2p=int64#3),<t11=int6464#12
# asm 2: mulpd 16(<b2a2p=%rdx),<t11=%xmm11
mulpd 16(%rdx),%xmm11

# qhasm: float6464 r11 += t11
# asm 1: addpd <t11=int6464#12,<r11=int6464#1
# asm 2: addpd <t11=%xmm11,<r11=%xmm0
addpd %xmm11,%xmm0

# qhasm: d11 = cd10six
# asm 1: movdqa <cd10six=int6464#15,>d11=int6464#12
# asm 2: movdqa <cd10six=%xmm14,>d11=%xmm11
movdqa %xmm14,%xmm11

# qhasm: float6464 d11 *= *(int128 *)(a2b2p + 16)
# asm 1: mulpd 16(<a2b2p=int64#6),<d11=int6464#12
# asm 2: mulpd 16(<a2b2p=%r9),<d11=%xmm11
mulpd 16(%r9),%xmm11

# qhasm: float6464 r11 += d11
# asm 1: addpd <d11=int6464#12,<r11=int6464#1
# asm 2: addpd <d11=%xmm11,<r11=%xmm0
addpd %xmm11,%xmm0

# qhasm: t12 = ab10six
# asm 1: movdqa <ab10six=int6464#14,>t12=int6464#12
# asm 2: movdqa <ab10six=%xmm13,>t12=%xmm11
movdqa %xmm13,%xmm11

# qhasm: float6464 t12 *= *(int128 *)(b2a2p + 32)
# asm 1: mulpd 32(<b2a2p=int64#3),<t12=int6464#12
# asm 2: mulpd 32(<b2a2p=%rdx),<t12=%xmm11
mulpd 32(%rdx),%xmm11

# qhasm: float6464 r12 += t12
# asm 1: addpd <t12=int6464#12,<r12=int6464#2
# asm 2: addpd <t12=%xmm11,<r12=%xmm1
addpd %xmm11,%xmm1

# qhasm: d12 = cd10six
# asm 1: movdqa <cd10six=int6464#15,>d12=int6464#12
# asm 2: movdqa <cd10six=%xmm14,>d12=%xmm11
movdqa %xmm14,%xmm11

# qhasm: float6464 d12 *= *(int128 *)(a2b2p + 32)
# asm 1: mulpd 32(<a2b2p=int64#6),<d12=int6464#12
# asm 2: mulpd 32(<a2b2p=%r9),<d12=%xmm11
mulpd 32(%r9),%xmm11

# qhasm: float6464 r12 += d12
# asm 1: addpd <d12=int6464#12,<r12=int6464#2
# asm 2: addpd <d12=%xmm11,<r12=%xmm1
addpd %xmm11,%xmm1

# qhasm: t17 = ab10six
# asm 1: movdqa <ab10six=int6464#14,>t17=int6464#12
# asm 2: movdqa <ab10six=%xmm13,>t17=%xmm11
movdqa %xmm13,%xmm11

# qhasm: float6464 t17 *= *(int128 *)(b2a2p + 112)
# asm 1: mulpd 112(<b2a2p=int64#3),<t17=int6464#12
# asm 2: mulpd 112(<b2a2p=%rdx),<t17=%xmm11
mulpd 112(%rdx),%xmm11

# qhasm: float6464 r17 += t17
# asm 1: addpd <t17=int6464#12,<r17=int6464#7
# asm 2: addpd <t17=%xmm11,<r17=%xmm6
addpd %xmm11,%xmm6

# qhasm: d17 = cd10six
# asm 1: movdqa <cd10six=int6464#15,>d17=int6464#12
# asm 2: movdqa <cd10six=%xmm14,>d17=%xmm11
movdqa %xmm14,%xmm11

# qhasm: float6464 d17 *= *(int128 *)(a2b2p + 112)
# asm 1: mulpd 112(<a2b2p=int64#6),<d17=int6464#12
# asm 2: mulpd 112(<a2b2p=%r9),<d17=%xmm11
mulpd 112(%r9),%xmm11

# qhasm: float6464 r17 += d17
# asm 1: addpd <d17=int6464#12,<r17=int6464#7
# asm 2: addpd <d17=%xmm11,<r17=%xmm6
addpd %xmm11,%xmm6

# qhasm: t18 = ab10six
# asm 1: movdqa <ab10six=int6464#14,>t18=int6464#12
# asm 2: movdqa <ab10six=%xmm13,>t18=%xmm11
movdqa %xmm13,%xmm11

# qhasm: float6464 t18 *= *(int128 *)(b2a2p + 128)
# asm 1: mulpd 128(<b2a2p=int64#3),<t18=int6464#12
# asm 2: mulpd 128(<b2a2p=%rdx),<t18=%xmm11
mulpd 128(%rdx),%xmm11

# qhasm: float6464 r18 += t18
# asm 1: addpd <t18=int6464#12,<r18=int6464#8
# asm 2: addpd <t18=%xmm11,<r18=%xmm7
addpd %xmm11,%xmm7

# qhasm: d18 = cd10six
# asm 1: movdqa <cd10six=int6464#15,>d18=int6464#12
# asm 2: movdqa <cd10six=%xmm14,>d18=%xmm11
movdqa %xmm14,%xmm11

# qhasm: float6464 d18 *= *(int128 *)(a2b2p + 128)
# asm 1: mulpd 128(<a2b2p=int64#6),<d18=int6464#12
# asm 2: mulpd 128(<a2b2p=%r9),<d18=%xmm11
mulpd 128(%r9),%xmm11

# qhasm: float6464 r18 += d18
# asm 1: addpd <d18=int6464#12,<r18=int6464#8
# asm 2: addpd <d18=%xmm11,<r18=%xmm7
addpd %xmm11,%xmm7

# qhasm: *(int128 *)(b1b1p + 160) = r10
# asm 1: movdqa <r10=int6464#13,160(<b1b1p=int64#4)
# asm 2: movdqa <r10=%xmm12,160(<b1b1p=%rcx)
movdqa %xmm12,160(%rcx)

# qhasm: ab11 = *(int128 *)(b1b1p + 176)
# asm 1: movdqa 176(<b1b1p=int64#4),>ab11=int6464#12
# asm 2: movdqa 176(<b1b1p=%rcx),>ab11=%xmm11
movdqa 176(%rcx),%xmm11

# qhasm: cd11 = *(int128 *)(ma1a1p + 176)
# asm 1: movdqa 176(<ma1a1p=int64#5),>cd11=int6464#13
# asm 2: movdqa 176(<ma1a1p=%r8),>cd11=%xmm12
movdqa 176(%r8),%xmm12

# qhasm: ab11six = ab11
# asm 1: movdqa <ab11=int6464#12,>ab11six=int6464#14
# asm 2: movdqa <ab11=%xmm11,>ab11six=%xmm13
movdqa %xmm11,%xmm13

# qhasm: cd11six = cd11
# asm 1: movdqa <cd11=int6464#13,>cd11six=int6464#15
# asm 2: movdqa <cd11=%xmm12,>cd11six=%xmm14
movdqa %xmm12,%xmm14

# qhasm: float6464 ab11six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab11six=int6464#14
# asm 2: mulpd SIX_SIX,<ab11six=%xmm13
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 cd11six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<cd11six=int6464#15
# asm 2: mulpd SIX_SIX,<cd11six=%xmm14
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: t11 = ab11
# asm 1: movdqa <ab11=int6464#12,>t11=int6464#16
# asm 2: movdqa <ab11=%xmm11,>t11=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t11 *= *(int128 *)(b2a2p + 0)
# asm 1: mulpd 0(<b2a2p=int64#3),<t11=int6464#16
# asm 2: mulpd 0(<b2a2p=%rdx),<t11=%xmm15
mulpd 0(%rdx),%xmm15

# qhasm: float6464 r11 += t11
# asm 1: addpd <t11=int6464#16,<r11=int6464#1
# asm 2: addpd <t11=%xmm15,<r11=%xmm0
addpd %xmm15,%xmm0

# qhasm: d11 = cd11
# asm 1: movdqa <cd11=int6464#13,>d11=int6464#16
# asm 2: movdqa <cd11=%xmm12,>d11=%xmm15
movdqa %xmm12,%xmm15

# qhasm: float6464 d11 *= *(int128 *)(a2b2p + 0)
# asm 1: mulpd 0(<a2b2p=int64#6),<d11=int6464#16
# asm 2: mulpd 0(<a2b2p=%r9),<d11=%xmm15
mulpd 0(%r9),%xmm15

# qhasm: float6464 r11 += d11
# asm 1: addpd <d11=int6464#16,<r11=int6464#1
# asm 2: addpd <d11=%xmm15,<r11=%xmm0
addpd %xmm15,%xmm0

# qhasm: t13 = ab11
# asm 1: movdqa <ab11=int6464#12,>t13=int6464#16
# asm 2: movdqa <ab11=%xmm11,>t13=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t13 *= *(int128 *)(b2a2p + 32)
# asm 1: mulpd 32(<b2a2p=int64#3),<t13=int6464#16
# asm 2: mulpd 32(<b2a2p=%rdx),<t13=%xmm15
mulpd 32(%rdx),%xmm15

# qhasm: float6464 r13 += t13
# asm 1: addpd <t13=int6464#16,<r13=int6464#3
# asm 2: addpd <t13=%xmm15,<r13=%xmm2
addpd %xmm15,%xmm2

# qhasm: d13 = cd11
# asm 1: movdqa <cd11=int6464#13,>d13=int6464#16
# asm 2: movdqa <cd11=%xmm12,>d13=%xmm15
movdqa %xmm12,%xmm15

# qhasm: float6464 d13 *= *(int128 *)(a2b2p + 32)
# asm 1: mulpd 32(<a2b2p=int64#6),<d13=int6464#16
# asm 2: mulpd 32(<a2b2p=%r9),<d13=%xmm15
mulpd 32(%r9),%xmm15

# qhasm: float6464 r13 += d13
# asm 1: addpd <d13=int6464#16,<r13=int6464#3
# asm 2: addpd <d13=%xmm15,<r13=%xmm2
addpd %xmm15,%xmm2

# qhasm: t14 = ab11
# asm 1: movdqa <ab11=int6464#12,>t14=int6464#16
# asm 2: movdqa <ab11=%xmm11,>t14=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t14 *= *(int128 *)(b2a2p + 48)
# asm 1: mulpd 48(<b2a2p=int64#3),<t14=int6464#16
# asm 2: mulpd 48(<b2a2p=%rdx),<t14=%xmm15
mulpd 48(%rdx),%xmm15

# qhasm: float6464 r14 += t14
# asm 1: addpd <t14=int6464#16,<r14=int6464#4
# asm 2: addpd <t14=%xmm15,<r14=%xmm3
addpd %xmm15,%xmm3

# qhasm: d14 = cd11
# asm 1: movdqa <cd11=int6464#13,>d14=int6464#16
# asm 2: movdqa <cd11=%xmm12,>d14=%xmm15
movdqa %xmm12,%xmm15

# qhasm: float6464 d14 *= *(int128 *)(a2b2p + 48)
# asm 1: mulpd 48(<a2b2p=int64#6),<d14=int6464#16
# asm 2: mulpd 48(<a2b2p=%r9),<d14=%xmm15
mulpd 48(%r9),%xmm15

# qhasm: float6464 r14 += d14
# asm 1: addpd <d14=int6464#16,<r14=int6464#4
# asm 2: addpd <d14=%xmm15,<r14=%xmm3
addpd %xmm15,%xmm3

# qhasm: t15 = ab11
# asm 1: movdqa <ab11=int6464#12,>t15=int6464#16
# asm 2: movdqa <ab11=%xmm11,>t15=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t15 *= *(int128 *)(b2a2p + 64)
# asm 1: mulpd 64(<b2a2p=int64#3),<t15=int6464#16
# asm 2: mulpd 64(<b2a2p=%rdx),<t15=%xmm15
mulpd 64(%rdx),%xmm15

# qhasm: float6464 r15 += t15
# asm 1: addpd <t15=int6464#16,<r15=int6464#5
# asm 2: addpd <t15=%xmm15,<r15=%xmm4
addpd %xmm15,%xmm4

# qhasm: d15 = cd11
# asm 1: movdqa <cd11=int6464#13,>d15=int6464#16
# asm 2: movdqa <cd11=%xmm12,>d15=%xmm15
movdqa %xmm12,%xmm15

# qhasm: float6464 d15 *= *(int128 *)(a2b2p + 64)
# asm 1: mulpd 64(<a2b2p=int64#6),<d15=int6464#16
# asm 2: mulpd 64(<a2b2p=%r9),<d15=%xmm15
mulpd 64(%r9),%xmm15

# qhasm: float6464 r15 += d15
# asm 1: addpd <d15=int6464#16,<r15=int6464#5
# asm 2: addpd <d15=%xmm15,<r15=%xmm4
addpd %xmm15,%xmm4

# qhasm: t16 = ab11
# asm 1: movdqa <ab11=int6464#12,>t16=int6464#16
# asm 2: movdqa <ab11=%xmm11,>t16=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t16 *= *(int128 *)(b2a2p + 80)
# asm 1: mulpd 80(<b2a2p=int64#3),<t16=int6464#16
# asm 2: mulpd 80(<b2a2p=%rdx),<t16=%xmm15
mulpd 80(%rdx),%xmm15

# qhasm: float6464 r16 += t16
# asm 1: addpd <t16=int6464#16,<r16=int6464#6
# asm 2: addpd <t16=%xmm15,<r16=%xmm5
addpd %xmm15,%xmm5

# qhasm: d16 = cd11
# asm 1: movdqa <cd11=int6464#13,>d16=int6464#16
# asm 2: movdqa <cd11=%xmm12,>d16=%xmm15
movdqa %xmm12,%xmm15

# qhasm: float6464 d16 *= *(int128 *)(a2b2p + 80)
# asm 1: mulpd 80(<a2b2p=int64#6),<d16=int6464#16
# asm 2: mulpd 80(<a2b2p=%r9),<d16=%xmm15
mulpd 80(%r9),%xmm15

# qhasm: float6464 r16 += d16
# asm 1: addpd <d16=int6464#16,<r16=int6464#6
# asm 2: addpd <d16=%xmm15,<r16=%xmm5
addpd %xmm15,%xmm5

# qhasm: t17 = ab11
# asm 1: movdqa <ab11=int6464#12,>t17=int6464#16
# asm 2: movdqa <ab11=%xmm11,>t17=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t17 *= *(int128 *)(b2a2p + 96)
# asm 1: mulpd 96(<b2a2p=int64#3),<t17=int6464#16
# asm 2: mulpd 96(<b2a2p=%rdx),<t17=%xmm15
mulpd 96(%rdx),%xmm15

# qhasm: float6464 r17 += t17
# asm 1: addpd <t17=int6464#16,<r17=int6464#7
# asm 2: addpd <t17=%xmm15,<r17=%xmm6
addpd %xmm15,%xmm6

# qhasm: d17 = cd11
# asm 1: movdqa <cd11=int6464#13,>d17=int6464#16
# asm 2: movdqa <cd11=%xmm12,>d17=%xmm15
movdqa %xmm12,%xmm15

# qhasm: float6464 d17 *= *(int128 *)(a2b2p + 96)
# asm 1: mulpd 96(<a2b2p=int64#6),<d17=int6464#16
# asm 2: mulpd 96(<a2b2p=%r9),<d17=%xmm15
mulpd 96(%r9),%xmm15

# qhasm: float6464 r17 += d17
# asm 1: addpd <d17=int6464#16,<r17=int6464#7
# asm 2: addpd <d17=%xmm15,<r17=%xmm6
addpd %xmm15,%xmm6

# qhasm: t19 = ab11
# asm 1: movdqa <ab11=int6464#12,>t19=int6464#16
# asm 2: movdqa <ab11=%xmm11,>t19=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t19 *= *(int128 *)(b2a2p + 128)
# asm 1: mulpd 128(<b2a2p=int64#3),<t19=int6464#16
# asm 2: mulpd 128(<b2a2p=%rdx),<t19=%xmm15
mulpd 128(%rdx),%xmm15

# qhasm: float6464 r19 += t19
# asm 1: addpd <t19=int6464#16,<r19=int6464#9
# asm 2: addpd <t19=%xmm15,<r19=%xmm8
addpd %xmm15,%xmm8

# qhasm: d19 = cd11
# asm 1: movdqa <cd11=int6464#13,>d19=int6464#16
# asm 2: movdqa <cd11=%xmm12,>d19=%xmm15
movdqa %xmm12,%xmm15

# qhasm: float6464 d19 *= *(int128 *)(a2b2p + 128)
# asm 1: mulpd 128(<a2b2p=int64#6),<d19=int6464#16
# asm 2: mulpd 128(<a2b2p=%r9),<d19=%xmm15
mulpd 128(%r9),%xmm15

# qhasm: float6464 r19 += d19
# asm 1: addpd <d19=int6464#16,<r19=int6464#9
# asm 2: addpd <d19=%xmm15,<r19=%xmm8
addpd %xmm15,%xmm8

# qhasm: t20 = ab11
# asm 1: movdqa <ab11=int6464#12,>t20=int6464#16
# asm 2: movdqa <ab11=%xmm11,>t20=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t20 *= *(int128 *)(b2a2p + 144)
# asm 1: mulpd 144(<b2a2p=int64#3),<t20=int6464#16
# asm 2: mulpd 144(<b2a2p=%rdx),<t20=%xmm15
mulpd 144(%rdx),%xmm15

# qhasm: float6464 r20 += t20
# asm 1: addpd <t20=int6464#16,<r20=int6464#10
# asm 2: addpd <t20=%xmm15,<r20=%xmm9
addpd %xmm15,%xmm9

# qhasm: d20 = cd11
# asm 1: movdqa <cd11=int6464#13,>d20=int6464#16
# asm 2: movdqa <cd11=%xmm12,>d20=%xmm15
movdqa %xmm12,%xmm15

# qhasm: float6464 d20 *= *(int128 *)(a2b2p + 144)
# asm 1: mulpd 144(<a2b2p=int64#6),<d20=int6464#16
# asm 2: mulpd 144(<a2b2p=%r9),<d20=%xmm15
mulpd 144(%r9),%xmm15

# qhasm: float6464 r20 += d20
# asm 1: addpd <d20=int6464#16,<r20=int6464#10
# asm 2: addpd <d20=%xmm15,<r20=%xmm9
addpd %xmm15,%xmm9

# qhasm: t21 = ab11
# asm 1: movdqa <ab11=int6464#12,>t21=int6464#16
# asm 2: movdqa <ab11=%xmm11,>t21=%xmm15
movdqa %xmm11,%xmm15

# qhasm: float6464 t21 *= *(int128 *)(b2a2p + 160)
# asm 1: mulpd 160(<b2a2p=int64#3),<t21=int6464#16
# asm 2: mulpd 160(<b2a2p=%rdx),<t21=%xmm15
mulpd 160(%rdx),%xmm15

# qhasm: float6464 r21 += t21
# asm 1: addpd <t21=int6464#16,<r21=int6464#11
# asm 2: addpd <t21=%xmm15,<r21=%xmm10
addpd %xmm15,%xmm10

# qhasm: d21 = cd11
# asm 1: movdqa <cd11=int6464#13,>d21=int6464#16
# asm 2: movdqa <cd11=%xmm12,>d21=%xmm15
movdqa %xmm12,%xmm15

# qhasm: float6464 d21 *= *(int128 *)(a2b2p + 160)
# asm 1: mulpd 160(<a2b2p=int64#6),<d21=int6464#16
# asm 2: mulpd 160(<a2b2p=%r9),<d21=%xmm15
mulpd 160(%r9),%xmm15

# qhasm: float6464 r21 += d21
# asm 1: addpd <d21=int6464#16,<r21=int6464#11
# asm 2: addpd <d21=%xmm15,<r21=%xmm10
addpd %xmm15,%xmm10

# qhasm: r22 = ab11
# asm 1: movdqa <ab11=int6464#12,>r22=int6464#12
# asm 2: movdqa <ab11=%xmm11,>r22=%xmm11
movdqa %xmm11,%xmm11

# qhasm: float6464 r22 *= *(int128 *)(b2a2p + 176)
# asm 1: mulpd 176(<b2a2p=int64#3),<r22=int6464#12
# asm 2: mulpd 176(<b2a2p=%rdx),<r22=%xmm11
mulpd 176(%rdx),%xmm11

# qhasm: d22 = cd11
# asm 1: movdqa <cd11=int6464#13,>d22=int6464#13
# asm 2: movdqa <cd11=%xmm12,>d22=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 d22 *= *(int128 *)(a2b2p + 176)
# asm 1: mulpd 176(<a2b2p=int64#6),<d22=int6464#13
# asm 2: mulpd 176(<a2b2p=%r9),<d22=%xmm12
mulpd 176(%r9),%xmm12

# qhasm: float6464 r22 += d22
# asm 1: addpd <d22=int6464#13,<r22=int6464#12
# asm 2: addpd <d22=%xmm12,<r22=%xmm11
addpd %xmm12,%xmm11

# qhasm: t12 = ab11six
# asm 1: movdqa <ab11six=int6464#14,>t12=int6464#13
# asm 2: movdqa <ab11six=%xmm13,>t12=%xmm12
movdqa %xmm13,%xmm12

# qhasm: float6464 t12 *= *(int128 *)(b2a2p + 16)
# asm 1: mulpd 16(<b2a2p=int64#3),<t12=int6464#13
# asm 2: mulpd 16(<b2a2p=%rdx),<t12=%xmm12
mulpd 16(%rdx),%xmm12

# qhasm: float6464 r12 += t12
# asm 1: addpd <t12=int6464#13,<r12=int6464#2
# asm 2: addpd <t12=%xmm12,<r12=%xmm1
addpd %xmm12,%xmm1

# qhasm: d12 = cd11six
# asm 1: movdqa <cd11six=int6464#15,>d12=int6464#13
# asm 2: movdqa <cd11six=%xmm14,>d12=%xmm12
movdqa %xmm14,%xmm12

# qhasm: float6464 d12 *= *(int128 *)(a2b2p + 16)
# asm 1: mulpd 16(<a2b2p=int64#6),<d12=int6464#13
# asm 2: mulpd 16(<a2b2p=%r9),<d12=%xmm12
mulpd 16(%r9),%xmm12

# qhasm: float6464 r12 += d12
# asm 1: addpd <d12=int6464#13,<r12=int6464#2
# asm 2: addpd <d12=%xmm12,<r12=%xmm1
addpd %xmm12,%xmm1

# qhasm: t18 = ab11six
# asm 1: movdqa <ab11six=int6464#14,>t18=int6464#13
# asm 2: movdqa <ab11six=%xmm13,>t18=%xmm12
movdqa %xmm13,%xmm12

# qhasm: float6464 t18 *= *(int128 *)(b2a2p + 112)
# asm 1: mulpd 112(<b2a2p=int64#3),<t18=int6464#13
# asm 2: mulpd 112(<b2a2p=%rdx),<t18=%xmm12
mulpd 112(%rdx),%xmm12

# qhasm: float6464 r18 += t18
# asm 1: addpd <t18=int6464#13,<r18=int6464#8
# asm 2: addpd <t18=%xmm12,<r18=%xmm7
addpd %xmm12,%xmm7

# qhasm: d18 = cd11six
# asm 1: movdqa <cd11six=int6464#15,>d18=int6464#13
# asm 2: movdqa <cd11six=%xmm14,>d18=%xmm12
movdqa %xmm14,%xmm12

# qhasm: float6464 d18 *= *(int128 *)(a2b2p + 112)
# asm 1: mulpd 112(<a2b2p=int64#6),<d18=int6464#13
# asm 2: mulpd 112(<a2b2p=%r9),<d18=%xmm12
mulpd 112(%r9),%xmm12

# qhasm: float6464 r18 += d18
# asm 1: addpd <d18=int6464#13,<r18=int6464#8
# asm 2: addpd <d18=%xmm12,<r18=%xmm7
addpd %xmm12,%xmm7

# qhasm: *(int128 *)(b1b1p + 176) = r11
# asm 1: movdqa <r11=int6464#1,176(<b1b1p=int64#4)
# asm 2: movdqa <r11=%xmm0,176(<b1b1p=%rcx)
movdqa %xmm0,176(%rcx)

# qhasm: r0 = *(int128 *)(b1b1p + 0)
# asm 1: movdqa 0(<b1b1p=int64#4),>r0=int6464#1
# asm 2: movdqa 0(<b1b1p=%rcx),>r0=%xmm0
movdqa 0(%rcx),%xmm0

# qhasm: float6464 r0 -= r12
# asm 1: subpd <r12=int6464#2,<r0=int6464#1
# asm 2: subpd <r12=%xmm1,<r0=%xmm0
subpd %xmm1,%xmm0

# qhasm: t15 = r15
# asm 1: movdqa <r15=int6464#5,>t15=int6464#13
# asm 2: movdqa <r15=%xmm4,>t15=%xmm12
movdqa %xmm4,%xmm12

# qhasm: float6464 t15 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<t15=int6464#13
# asm 2: mulpd SIX_SIX,<t15=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 r0 += t15
# asm 1: addpd <t15=int6464#13,<r0=int6464#1
# asm 2: addpd <t15=%xmm12,<r0=%xmm0
addpd %xmm12,%xmm0

# qhasm: t18 = r18
# asm 1: movdqa <r18=int6464#8,>t18=int6464#13
# asm 2: movdqa <r18=%xmm7,>t18=%xmm12
movdqa %xmm7,%xmm12

# qhasm: float6464 t18 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<t18=int6464#13
# asm 2: mulpd TWO_TWO,<t18=%xmm12
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 r0 -= t18
# asm 1: subpd <t18=int6464#13,<r0=int6464#1
# asm 2: subpd <t18=%xmm12,<r0=%xmm0
subpd %xmm12,%xmm0

# qhasm: t21 = r21
# asm 1: movdqa <r21=int6464#11,>t21=int6464#13
# asm 2: movdqa <r21=%xmm10,>t21=%xmm12
movdqa %xmm10,%xmm12

# qhasm: float6464 t21 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<t21=int6464#13
# asm 2: mulpd SIX_SIX,<t21=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 r0 -= t21
# asm 1: subpd <t21=int6464#13,<r0=int6464#1
# asm 2: subpd <t21=%xmm12,<r0=%xmm0
subpd %xmm12,%xmm0

# qhasm: r3 = *(int128 *)(b1b1p + 48)
# asm 1: movdqa 48(<b1b1p=int64#4),>r3=int6464#13
# asm 2: movdqa 48(<b1b1p=%rcx),>r3=%xmm12
movdqa 48(%rcx),%xmm12

# qhasm: float6464 r3 -= r12
# asm 1: subpd <r12=int6464#2,<r3=int6464#13
# asm 2: subpd <r12=%xmm1,<r3=%xmm12
subpd %xmm1,%xmm12

# qhasm: t15 = r15
# asm 1: movdqa <r15=int6464#5,>t15=int6464#14
# asm 2: movdqa <r15=%xmm4,>t15=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 t15 *= FIVE_FIVE
# asm 1: mulpd FIVE_FIVE,<t15=int6464#14
# asm 2: mulpd FIVE_FIVE,<t15=%xmm13
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r3 += t15
# asm 1: addpd <t15=int6464#14,<r3=int6464#13
# asm 2: addpd <t15=%xmm13,<r3=%xmm12
addpd %xmm13,%xmm12

# qhasm: float6464 r3 -= r18
# asm 1: subpd <r18=int6464#8,<r3=int6464#13
# asm 2: subpd <r18=%xmm7,<r3=%xmm12
subpd %xmm7,%xmm12

# qhasm: t21 = r21
# asm 1: movdqa <r21=int6464#11,>t21=int6464#14
# asm 2: movdqa <r21=%xmm10,>t21=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 t21 *= EIGHT_EIGHT
# asm 1: mulpd EIGHT_EIGHT,<t21=int6464#14
# asm 2: mulpd EIGHT_EIGHT,<t21=%xmm13
mov EIGHT_EIGHT@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 r3 -= t21
# asm 1: subpd <t21=int6464#14,<r3=int6464#13
# asm 2: subpd <t21=%xmm13,<r3=%xmm12
subpd %xmm13,%xmm12

# qhasm: r6 = *(int128 *)(b1b1p + 96)
# asm 1: movdqa 96(<b1b1p=int64#4),>r6=int6464#14
# asm 2: movdqa 96(<b1b1p=%rcx),>r6=%xmm13
movdqa 96(%rcx),%xmm13

# qhasm: t12 = r12
# asm 1: movdqa <r12=int6464#2,>t12=int6464#15
# asm 2: movdqa <r12=%xmm1,>t12=%xmm14
movdqa %xmm1,%xmm14

# qhasm: float6464 t12 *= FOUR_FOUR
# asm 1: mulpd FOUR_FOUR,<t12=int6464#15
# asm 2: mulpd FOUR_FOUR,<t12=%xmm14
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: float6464 r6 -= t12
# asm 1: subpd <t12=int6464#15,<r6=int6464#14
# asm 2: subpd <t12=%xmm14,<r6=%xmm13
subpd %xmm14,%xmm13

# qhasm: t15 = r15
# asm 1: movdqa <r15=int6464#5,>t15=int6464#15
# asm 2: movdqa <r15=%xmm4,>t15=%xmm14
movdqa %xmm4,%xmm14

# qhasm: float6464 t15 *= EIGHTEEN_EIGHTEEN
# asm 1: mulpd EIGHTEEN_EIGHTEEN,<t15=int6464#15
# asm 2: mulpd EIGHTEEN_EIGHTEEN,<t15=%xmm14
mov EIGHTEEN_EIGHTEEN@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: float6464 r6 += t15
# asm 1: addpd <t15=int6464#15,<r6=int6464#14
# asm 2: addpd <t15=%xmm14,<r6=%xmm13
addpd %xmm14,%xmm13

# qhasm: t18 = r18
# asm 1: movdqa <r18=int6464#8,>t18=int6464#15
# asm 2: movdqa <r18=%xmm7,>t18=%xmm14
movdqa %xmm7,%xmm14

# qhasm: float6464 t18 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<t18=int6464#15
# asm 2: mulpd THREE_THREE,<t18=%xmm14
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: float6464 r6 -= t18
# asm 1: subpd <t18=int6464#15,<r6=int6464#14
# asm 2: subpd <t18=%xmm14,<r6=%xmm13
subpd %xmm14,%xmm13

# qhasm: t21 = r21
# asm 1: movdqa <r21=int6464#11,>t21=int6464#15
# asm 2: movdqa <r21=%xmm10,>t21=%xmm14
movdqa %xmm10,%xmm14

# qhasm: float6464 t21 *= THIRTY_THIRTY
# asm 1: mulpd THIRTY_THIRTY,<t21=int6464#15
# asm 2: mulpd THIRTY_THIRTY,<t21=%xmm14
mov THIRTY_THIRTY@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: float6464 r6 -= t21
# asm 1: subpd <t21=int6464#15,<r6=int6464#14
# asm 2: subpd <t21=%xmm14,<r6=%xmm13
subpd %xmm14,%xmm13

# qhasm: r9 = *(int128 *)(b1b1p + 144)
# asm 1: movdqa 144(<b1b1p=int64#4),>r9=int6464#15
# asm 2: movdqa 144(<b1b1p=%rcx),>r9=%xmm14
movdqa 144(%rcx),%xmm14

# qhasm: float6464 r9 -= r12
# asm 1: subpd <r12=int6464#2,<r9=int6464#15
# asm 2: subpd <r12=%xmm1,<r9=%xmm14
subpd %xmm1,%xmm14

# qhasm: t15 = r15
# asm 1: movdqa <r15=int6464#5,>t15=int6464#2
# asm 2: movdqa <r15=%xmm4,>t15=%xmm1
movdqa %xmm4,%xmm1

# qhasm: float6464 t15 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<t15=int6464#2
# asm 2: mulpd TWO_TWO,<t15=%xmm1
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 r9 += t15
# asm 1: addpd <t15=int6464#2,<r9=int6464#15
# asm 2: addpd <t15=%xmm1,<r9=%xmm14
addpd %xmm1,%xmm14

# qhasm: float6464 r9 += r18
# asm 1: addpd <r18=int6464#8,<r9=int6464#15
# asm 2: addpd <r18=%xmm7,<r9=%xmm14
addpd %xmm7,%xmm14

# qhasm: t21 = r21
# asm 1: movdqa <r21=int6464#11,>t21=int6464#2
# asm 2: movdqa <r21=%xmm10,>t21=%xmm1
movdqa %xmm10,%xmm1

# qhasm: float6464 t21 *= NINE_NINE
# asm 1: mulpd NINE_NINE,<t21=int6464#2
# asm 2: mulpd NINE_NINE,<t21=%xmm1
mov NINE_NINE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 r9 -= t21
# asm 1: subpd <t21=int6464#2,<r9=int6464#15
# asm 2: subpd <t21=%xmm1,<r9=%xmm14
subpd %xmm1,%xmm14

# qhasm: r1 = *(int128 *)(b1b1p + 16)
# asm 1: movdqa 16(<b1b1p=int64#4),>r1=int6464#2
# asm 2: movdqa 16(<b1b1p=%rcx),>r1=%xmm1
movdqa 16(%rcx),%xmm1

# qhasm: float6464 r1 -= r13
# asm 1: subpd <r13=int6464#3,<r1=int6464#2
# asm 2: subpd <r13=%xmm2,<r1=%xmm1
subpd %xmm2,%xmm1

# qhasm: float6464 r1 += r16
# asm 1: addpd <r16=int6464#6,<r1=int6464#2
# asm 2: addpd <r16=%xmm5,<r1=%xmm1
addpd %xmm5,%xmm1

# qhasm: t19 = r19
# asm 1: movdqa <r19=int6464#9,>t19=int6464#5
# asm 2: movdqa <r19=%xmm8,>t19=%xmm4
movdqa %xmm8,%xmm4

# qhasm: float6464 t19 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<t19=int6464#5
# asm 2: mulpd TWO_TWO,<t19=%xmm4
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm4

# qhasm: float6464 r1 -= t19
# asm 1: subpd <t19=int6464#5,<r1=int6464#2
# asm 2: subpd <t19=%xmm4,<r1=%xmm1
subpd %xmm4,%xmm1

# qhasm: float6464 r1 -= r22
# asm 1: subpd <r22=int6464#12,<r1=int6464#2
# asm 2: subpd <r22=%xmm11,<r1=%xmm1
subpd %xmm11,%xmm1

# qhasm: r4 = *(int128 *)(b1b1p + 64)
# asm 1: movdqa 64(<b1b1p=int64#4),>r4=int6464#5
# asm 2: movdqa 64(<b1b1p=%rcx),>r4=%xmm4
movdqa 64(%rcx),%xmm4

# qhasm: t13 = r13
# asm 1: movdqa <r13=int6464#3,>t13=int6464#8
# asm 2: movdqa <r13=%xmm2,>t13=%xmm7
movdqa %xmm2,%xmm7

# qhasm: float6464 t13 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<t13=int6464#8
# asm 2: mulpd SIX_SIX,<t13=%xmm7
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm7

# qhasm: float6464 r4 -= t13
# asm 1: subpd <t13=int6464#8,<r4=int6464#5
# asm 2: subpd <t13=%xmm7,<r4=%xmm4
subpd %xmm7,%xmm4

# qhasm: t16 = r16
# asm 1: movdqa <r16=int6464#6,>t16=int6464#8
# asm 2: movdqa <r16=%xmm5,>t16=%xmm7
movdqa %xmm5,%xmm7

# qhasm: float6464 t16 *= FIVE_FIVE
# asm 1: mulpd FIVE_FIVE,<t16=int6464#8
# asm 2: mulpd FIVE_FIVE,<t16=%xmm7
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm7

# qhasm: float6464 r4 += t16
# asm 1: addpd <t16=int6464#8,<r4=int6464#5
# asm 2: addpd <t16=%xmm7,<r4=%xmm4
addpd %xmm7,%xmm4

# qhasm: t19 = r19
# asm 1: movdqa <r19=int6464#9,>t19=int6464#8
# asm 2: movdqa <r19=%xmm8,>t19=%xmm7
movdqa %xmm8,%xmm7

# qhasm: float6464 t19 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<t19=int6464#8
# asm 2: mulpd SIX_SIX,<t19=%xmm7
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm7

# qhasm: float6464 r4 -= t19
# asm 1: subpd <t19=int6464#8,<r4=int6464#5
# asm 2: subpd <t19=%xmm7,<r4=%xmm4
subpd %xmm7,%xmm4

# qhasm: t22 = r22
# asm 1: movdqa <r22=int6464#12,>t22=int6464#8
# asm 2: movdqa <r22=%xmm11,>t22=%xmm7
movdqa %xmm11,%xmm7

# qhasm: float6464 t22 *= EIGHT_EIGHT
# asm 1: mulpd EIGHT_EIGHT,<t22=int6464#8
# asm 2: mulpd EIGHT_EIGHT,<t22=%xmm7
mov EIGHT_EIGHT@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm7

# qhasm: float6464 r4 -= t22
# asm 1: subpd <t22=int6464#8,<r4=int6464#5
# asm 2: subpd <t22=%xmm7,<r4=%xmm4
subpd %xmm7,%xmm4

# qhasm: r7 = *(int128 *)(b1b1p + 112)
# asm 1: movdqa 112(<b1b1p=int64#4),>r7=int6464#8
# asm 2: movdqa 112(<b1b1p=%rcx),>r7=%xmm7
movdqa 112(%rcx),%xmm7

# qhasm: t13 = r13
# asm 1: movdqa <r13=int6464#3,>t13=int6464#11
# asm 2: movdqa <r13=%xmm2,>t13=%xmm10
movdqa %xmm2,%xmm10

# qhasm: float6464 t13 *= FOUR_FOUR
# asm 1: mulpd FOUR_FOUR,<t13=int6464#11
# asm 2: mulpd FOUR_FOUR,<t13=%xmm10
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm10

# qhasm: float6464 r7 -= t13
# asm 1: subpd <t13=int6464#11,<r7=int6464#8
# asm 2: subpd <t13=%xmm10,<r7=%xmm7
subpd %xmm10,%xmm7

# qhasm: t16 = r16
# asm 1: movdqa <r16=int6464#6,>t16=int6464#11
# asm 2: movdqa <r16=%xmm5,>t16=%xmm10
movdqa %xmm5,%xmm10

# qhasm: float6464 t16 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<t16=int6464#11
# asm 2: mulpd THREE_THREE,<t16=%xmm10
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm10

# qhasm: float6464 r7 += t16
# asm 1: addpd <t16=int6464#11,<r7=int6464#8
# asm 2: addpd <t16=%xmm10,<r7=%xmm7
addpd %xmm10,%xmm7

# qhasm: t19 = r19
# asm 1: movdqa <r19=int6464#9,>t19=int6464#11
# asm 2: movdqa <r19=%xmm8,>t19=%xmm10
movdqa %xmm8,%xmm10

# qhasm: float6464 t19 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<t19=int6464#11
# asm 2: mulpd THREE_THREE,<t19=%xmm10
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm10

# qhasm: float6464 r7 -= t19
# asm 1: subpd <t19=int6464#11,<r7=int6464#8
# asm 2: subpd <t19=%xmm10,<r7=%xmm7
subpd %xmm10,%xmm7

# qhasm: t22 = r22
# asm 1: movdqa <r22=int6464#12,>t22=int6464#11
# asm 2: movdqa <r22=%xmm11,>t22=%xmm10
movdqa %xmm11,%xmm10

# qhasm: float6464 t22 *= FIVE_FIVE
# asm 1: mulpd FIVE_FIVE,<t22=int6464#11
# asm 2: mulpd FIVE_FIVE,<t22=%xmm10
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm10

# qhasm: float6464 r7 -= t22
# asm 1: subpd <t22=int6464#11,<r7=int6464#8
# asm 2: subpd <t22=%xmm10,<r7=%xmm7
subpd %xmm10,%xmm7

# qhasm: r10 = *(int128 *)(b1b1p + 160)
# asm 1: movdqa 160(<b1b1p=int64#4),>r10=int6464#11
# asm 2: movdqa 160(<b1b1p=%rcx),>r10=%xmm10
movdqa 160(%rcx),%xmm10

# qhasm: t13 = r13
# asm 1: movdqa <r13=int6464#3,>t13=int6464#3
# asm 2: movdqa <r13=%xmm2,>t13=%xmm2
movdqa %xmm2,%xmm2

# qhasm: float6464 t13 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<t13=int6464#3
# asm 2: mulpd SIX_SIX,<t13=%xmm2
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm2

# qhasm: float6464 r10 -= t13
# asm 1: subpd <t13=int6464#3,<r10=int6464#11
# asm 2: subpd <t13=%xmm2,<r10=%xmm10
subpd %xmm2,%xmm10

# qhasm: t16 = r16
# asm 1: movdqa <r16=int6464#6,>t16=int6464#3
# asm 2: movdqa <r16=%xmm5,>t16=%xmm2
movdqa %xmm5,%xmm2

# qhasm: float6464 t16 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<t16=int6464#3
# asm 2: mulpd TWO_TWO,<t16=%xmm2
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm2

# qhasm: float6464 r10 += t16
# asm 1: addpd <t16=int6464#3,<r10=int6464#11
# asm 2: addpd <t16=%xmm2,<r10=%xmm10
addpd %xmm2,%xmm10

# qhasm: t19 = r19
# asm 1: movdqa <r19=int6464#9,>t19=int6464#3
# asm 2: movdqa <r19=%xmm8,>t19=%xmm2
movdqa %xmm8,%xmm2

# qhasm: float6464 t19 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<t19=int6464#3
# asm 2: mulpd SIX_SIX,<t19=%xmm2
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm2

# qhasm: float6464 r10 += t19
# asm 1: addpd <t19=int6464#3,<r10=int6464#11
# asm 2: addpd <t19=%xmm2,<r10=%xmm10
addpd %xmm2,%xmm10

# qhasm: t22 = r22
# asm 1: movdqa <r22=int6464#12,>t22=int6464#3
# asm 2: movdqa <r22=%xmm11,>t22=%xmm2
movdqa %xmm11,%xmm2

# qhasm: float6464 t22 *= NINE_NINE
# asm 1: mulpd NINE_NINE,<t22=int6464#3
# asm 2: mulpd NINE_NINE,<t22=%xmm2
mov NINE_NINE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm2

# qhasm: float6464 r10 -= t22
# asm 1: subpd <t22=int6464#3,<r10=int6464#11
# asm 2: subpd <t22=%xmm2,<r10=%xmm10
subpd %xmm2,%xmm10

# qhasm: r2 = *(int128 *)(b1b1p + 32)
# asm 1: movdqa 32(<b1b1p=int64#4),>r2=int6464#3
# asm 2: movdqa 32(<b1b1p=%rcx),>r2=%xmm2
movdqa 32(%rcx),%xmm2

# qhasm: float6464 r2 -= r14
# asm 1: subpd <r14=int6464#4,<r2=int6464#3
# asm 2: subpd <r14=%xmm3,<r2=%xmm2
subpd %xmm3,%xmm2

# qhasm: float6464 r2 += r17
# asm 1: addpd <r17=int6464#7,<r2=int6464#3
# asm 2: addpd <r17=%xmm6,<r2=%xmm2
addpd %xmm6,%xmm2

# qhasm: t20 = r20
# asm 1: movdqa <r20=int6464#10,>t20=int6464#6
# asm 2: movdqa <r20=%xmm9,>t20=%xmm5
movdqa %xmm9,%xmm5

# qhasm: float6464 t20 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<t20=int6464#6
# asm 2: mulpd TWO_TWO,<t20=%xmm5
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm5

# qhasm: float6464 r2 -= t20
# asm 1: subpd <t20=int6464#6,<r2=int6464#3
# asm 2: subpd <t20=%xmm5,<r2=%xmm2
subpd %xmm5,%xmm2

# qhasm: r5 = *(int128 *)(b1b1p + 80)
# asm 1: movdqa 80(<b1b1p=int64#4),>r5=int6464#6
# asm 2: movdqa 80(<b1b1p=%rcx),>r5=%xmm5
movdqa 80(%rcx),%xmm5

# qhasm: t14 = r14
# asm 1: movdqa <r14=int6464#4,>t14=int6464#9
# asm 2: movdqa <r14=%xmm3,>t14=%xmm8
movdqa %xmm3,%xmm8

# qhasm: float6464 t14 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<t14=int6464#9
# asm 2: mulpd SIX_SIX,<t14=%xmm8
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm8

# qhasm: float6464 r5 -= t14
# asm 1: subpd <t14=int6464#9,<r5=int6464#6
# asm 2: subpd <t14=%xmm8,<r5=%xmm5
subpd %xmm8,%xmm5

# qhasm: t17 = r17
# asm 1: movdqa <r17=int6464#7,>t17=int6464#9
# asm 2: movdqa <r17=%xmm6,>t17=%xmm8
movdqa %xmm6,%xmm8

# qhasm: float6464 t17 *= FIVE_FIVE
# asm 1: mulpd FIVE_FIVE,<t17=int6464#9
# asm 2: mulpd FIVE_FIVE,<t17=%xmm8
mov FIVE_FIVE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm8

# qhasm: float6464 r5 += t17
# asm 1: addpd <t17=int6464#9,<r5=int6464#6
# asm 2: addpd <t17=%xmm8,<r5=%xmm5
addpd %xmm8,%xmm5

# qhasm: t20 = r20
# asm 1: movdqa <r20=int6464#10,>t20=int6464#9
# asm 2: movdqa <r20=%xmm9,>t20=%xmm8
movdqa %xmm9,%xmm8

# qhasm: float6464 t20 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<t20=int6464#9
# asm 2: mulpd SIX_SIX,<t20=%xmm8
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm8

# qhasm: float6464 r5 -= t20
# asm 1: subpd <t20=int6464#9,<r5=int6464#6
# asm 2: subpd <t20=%xmm8,<r5=%xmm5
subpd %xmm8,%xmm5

# qhasm: r8 = *(int128 *)(b1b1p + 128)
# asm 1: movdqa 128(<b1b1p=int64#4),>r8=int6464#9
# asm 2: movdqa 128(<b1b1p=%rcx),>r8=%xmm8
movdqa 128(%rcx),%xmm8

# qhasm: t14 = r14
# asm 1: movdqa <r14=int6464#4,>t14=int6464#12
# asm 2: movdqa <r14=%xmm3,>t14=%xmm11
movdqa %xmm3,%xmm11

# qhasm: float6464 t14 *= FOUR_FOUR
# asm 1: mulpd FOUR_FOUR,<t14=int6464#12
# asm 2: mulpd FOUR_FOUR,<t14=%xmm11
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm11

# qhasm: float6464 r8 -= t14
# asm 1: subpd <t14=int6464#12,<r8=int6464#9
# asm 2: subpd <t14=%xmm11,<r8=%xmm8
subpd %xmm11,%xmm8

# qhasm: t17 = r17
# asm 1: movdqa <r17=int6464#7,>t17=int6464#12
# asm 2: movdqa <r17=%xmm6,>t17=%xmm11
movdqa %xmm6,%xmm11

# qhasm: float6464 t17 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<t17=int6464#12
# asm 2: mulpd THREE_THREE,<t17=%xmm11
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm11

# qhasm: float6464 r8 += t17
# asm 1: addpd <t17=int6464#12,<r8=int6464#9
# asm 2: addpd <t17=%xmm11,<r8=%xmm8
addpd %xmm11,%xmm8

# qhasm: t20 = r20
# asm 1: movdqa <r20=int6464#10,>t20=int6464#12
# asm 2: movdqa <r20=%xmm9,>t20=%xmm11
movdqa %xmm9,%xmm11

# qhasm: float6464 t20 *= THREE_THREE
# asm 1: mulpd THREE_THREE,<t20=int6464#12
# asm 2: mulpd THREE_THREE,<t20=%xmm11
mov THREE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm11

# qhasm: float6464 r8 -= t20
# asm 1: subpd <t20=int6464#12,<r8=int6464#9
# asm 2: subpd <t20=%xmm11,<r8=%xmm8
subpd %xmm11,%xmm8

# qhasm: r11 = *(int128 *)(b1b1p + 176)
# asm 1: movdqa 176(<b1b1p=int64#4),>r11=int6464#12
# asm 2: movdqa 176(<b1b1p=%rcx),>r11=%xmm11
movdqa 176(%rcx),%xmm11

# qhasm: t14 = r14
# asm 1: movdqa <r14=int6464#4,>t14=int6464#4
# asm 2: movdqa <r14=%xmm3,>t14=%xmm3
movdqa %xmm3,%xmm3

# qhasm: float6464 t14 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<t14=int6464#4
# asm 2: mulpd SIX_SIX,<t14=%xmm3
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm3

# qhasm: float6464 r11 -= t14
# asm 1: subpd <t14=int6464#4,<r11=int6464#12
# asm 2: subpd <t14=%xmm3,<r11=%xmm11
subpd %xmm3,%xmm11

# qhasm: t17 = r17
# asm 1: movdqa <r17=int6464#7,>t17=int6464#4
# asm 2: movdqa <r17=%xmm6,>t17=%xmm3
movdqa %xmm6,%xmm3

# qhasm: float6464 t17 *= TWO_TWO
# asm 1: mulpd TWO_TWO,<t17=int6464#4
# asm 2: mulpd TWO_TWO,<t17=%xmm3
mov TWO_TWO@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm3

# qhasm: float6464 r11 += t17
# asm 1: addpd <t17=int6464#4,<r11=int6464#12
# asm 2: addpd <t17=%xmm3,<r11=%xmm11
addpd %xmm3,%xmm11

# qhasm: t20 = r20
# asm 1: movdqa <r20=int6464#10,>t20=int6464#4
# asm 2: movdqa <r20=%xmm9,>t20=%xmm3
movdqa %xmm9,%xmm3

# qhasm: float6464 t20 *= SIX_SIX
# asm 1: mulpd SIX_SIX,<t20=int6464#4
# asm 2: mulpd SIX_SIX,<t20=%xmm3
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm3

# qhasm: float6464 r11 += t20
# asm 1: addpd <t20=int6464#4,<r11=int6464#12
# asm 2: addpd <t20=%xmm3,<r11=%xmm11
addpd %xmm3,%xmm11

# qhasm: round = ROUND_ROUND
# asm 1: movdqa ROUND_ROUND,<round=int6464#4
# asm 2: movdqa ROUND_ROUND,<round=%xmm3
mov ROUND_ROUND@GOTPCREL(%rip), %rbp
movdqa (%rbp),%xmm3

# qhasm: carry = r1
# asm 1: movdqa <r1=int6464#2,>carry=int6464#7
# asm 2: movdqa <r1=%xmm1,>carry=%xmm6
movdqa %xmm1,%xmm6

# qhasm: float6464 carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<carry=int6464#7
# asm 2: mulpd VINV_VINV,<carry=%xmm6
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#7
# asm 2: addpd <round=%xmm3,<carry=%xmm6
addpd %xmm3,%xmm6

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#7
# asm 2: subpd <round=%xmm3,<carry=%xmm6
subpd %xmm3,%xmm6

# qhasm: float6464 r2 += carry
# asm 1: addpd <carry=int6464#7,<r2=int6464#3
# asm 2: addpd <carry=%xmm6,<r2=%xmm2
addpd %xmm6,%xmm2

# qhasm: float6464 carry *= V_V
# asm 1: mulpd V_V,<carry=int6464#7
# asm 2: mulpd V_V,<carry=%xmm6
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 r1 -= carry
# asm 1: subpd <carry=int6464#7,<r1=int6464#2
# asm 2: subpd <carry=%xmm6,<r1=%xmm1
subpd %xmm6,%xmm1

# qhasm: carry = r4
# asm 1: movdqa <r4=int6464#5,>carry=int6464#7
# asm 2: movdqa <r4=%xmm4,>carry=%xmm6
movdqa %xmm4,%xmm6

# qhasm: float6464 carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<carry=int6464#7
# asm 2: mulpd VINV_VINV,<carry=%xmm6
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#7
# asm 2: addpd <round=%xmm3,<carry=%xmm6
addpd %xmm3,%xmm6

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#7
# asm 2: subpd <round=%xmm3,<carry=%xmm6
subpd %xmm3,%xmm6

# qhasm: float6464 r5 += carry
# asm 1: addpd <carry=int6464#7,<r5=int6464#6
# asm 2: addpd <carry=%xmm6,<r5=%xmm5
addpd %xmm6,%xmm5

# qhasm: float6464 carry *= V_V
# asm 1: mulpd V_V,<carry=int6464#7
# asm 2: mulpd V_V,<carry=%xmm6
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 r4 -= carry
# asm 1: subpd <carry=int6464#7,<r4=int6464#5
# asm 2: subpd <carry=%xmm6,<r4=%xmm4
subpd %xmm6,%xmm4

# qhasm: carry = r7
# asm 1: movdqa <r7=int6464#8,>carry=int6464#7
# asm 2: movdqa <r7=%xmm7,>carry=%xmm6
movdqa %xmm7,%xmm6

# qhasm: float6464 carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<carry=int6464#7
# asm 2: mulpd VINV_VINV,<carry=%xmm6
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#7
# asm 2: addpd <round=%xmm3,<carry=%xmm6
addpd %xmm3,%xmm6

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#7
# asm 2: subpd <round=%xmm3,<carry=%xmm6
subpd %xmm3,%xmm6

# qhasm: float6464 r8 += carry
# asm 1: addpd <carry=int6464#7,<r8=int6464#9
# asm 2: addpd <carry=%xmm6,<r8=%xmm8
addpd %xmm6,%xmm8

# qhasm: float6464 carry *= V_V
# asm 1: mulpd V_V,<carry=int6464#7
# asm 2: mulpd V_V,<carry=%xmm6
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 r7 -= carry
# asm 1: subpd <carry=int6464#7,<r7=int6464#8
# asm 2: subpd <carry=%xmm6,<r7=%xmm7
subpd %xmm6,%xmm7

# qhasm: carry = r10
# asm 1: movdqa <r10=int6464#11,>carry=int6464#7
# asm 2: movdqa <r10=%xmm10,>carry=%xmm6
movdqa %xmm10,%xmm6

# qhasm: float6464 carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<carry=int6464#7
# asm 2: mulpd VINV_VINV,<carry=%xmm6
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#7
# asm 2: addpd <round=%xmm3,<carry=%xmm6
addpd %xmm3,%xmm6

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#7
# asm 2: subpd <round=%xmm3,<carry=%xmm6
subpd %xmm3,%xmm6

# qhasm: float6464 r11 += carry
# asm 1: addpd <carry=int6464#7,<r11=int6464#12
# asm 2: addpd <carry=%xmm6,<r11=%xmm11
addpd %xmm6,%xmm11

# qhasm: float6464 carry *= V_V
# asm 1: mulpd V_V,<carry=int6464#7
# asm 2: mulpd V_V,<carry=%xmm6
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 r10 -= carry
# asm 1: subpd <carry=int6464#7,<r10=int6464#11
# asm 2: subpd <carry=%xmm6,<r10=%xmm10
subpd %xmm6,%xmm10

# qhasm: carry = r2
# asm 1: movdqa <r2=int6464#3,>carry=int6464#7
# asm 2: movdqa <r2=%xmm2,>carry=%xmm6
movdqa %xmm2,%xmm6

# qhasm: float6464 carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<carry=int6464#7
# asm 2: mulpd VINV_VINV,<carry=%xmm6
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#7
# asm 2: addpd <round=%xmm3,<carry=%xmm6
addpd %xmm3,%xmm6

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#7
# asm 2: subpd <round=%xmm3,<carry=%xmm6
subpd %xmm3,%xmm6

# qhasm: float6464 r3 += carry
# asm 1: addpd <carry=int6464#7,<r3=int6464#13
# asm 2: addpd <carry=%xmm6,<r3=%xmm12
addpd %xmm6,%xmm12

# qhasm: float6464 carry *= V_V
# asm 1: mulpd V_V,<carry=int6464#7
# asm 2: mulpd V_V,<carry=%xmm6
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 r2 -= carry
# asm 1: subpd <carry=int6464#7,<r2=int6464#3
# asm 2: subpd <carry=%xmm6,<r2=%xmm2
subpd %xmm6,%xmm2

# qhasm: carry = r5
# asm 1: movdqa <r5=int6464#6,>carry=int6464#7
# asm 2: movdqa <r5=%xmm5,>carry=%xmm6
movdqa %xmm5,%xmm6

# qhasm: float6464 carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<carry=int6464#7
# asm 2: mulpd VINV_VINV,<carry=%xmm6
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#7
# asm 2: addpd <round=%xmm3,<carry=%xmm6
addpd %xmm3,%xmm6

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#7
# asm 2: subpd <round=%xmm3,<carry=%xmm6
subpd %xmm3,%xmm6

# qhasm: float6464 r6 += carry
# asm 1: addpd <carry=int6464#7,<r6=int6464#14
# asm 2: addpd <carry=%xmm6,<r6=%xmm13
addpd %xmm6,%xmm13

# qhasm: float6464 carry *= V_V
# asm 1: mulpd V_V,<carry=int6464#7
# asm 2: mulpd V_V,<carry=%xmm6
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 r5 -= carry
# asm 1: subpd <carry=int6464#7,<r5=int6464#6
# asm 2: subpd <carry=%xmm6,<r5=%xmm5
subpd %xmm6,%xmm5

# qhasm: carry = r8
# asm 1: movdqa <r8=int6464#9,>carry=int6464#7
# asm 2: movdqa <r8=%xmm8,>carry=%xmm6
movdqa %xmm8,%xmm6

# qhasm: float6464 carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<carry=int6464#7
# asm 2: mulpd VINV_VINV,<carry=%xmm6
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#7
# asm 2: addpd <round=%xmm3,<carry=%xmm6
addpd %xmm3,%xmm6

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#7
# asm 2: subpd <round=%xmm3,<carry=%xmm6
subpd %xmm3,%xmm6

# qhasm: float6464 r9 += carry
# asm 1: addpd <carry=int6464#7,<r9=int6464#15
# asm 2: addpd <carry=%xmm6,<r9=%xmm14
addpd %xmm6,%xmm14

# qhasm: float6464 carry *= V_V
# asm 1: mulpd V_V,<carry=int6464#7
# asm 2: mulpd V_V,<carry=%xmm6
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 r8 -= carry
# asm 1: subpd <carry=int6464#7,<r8=int6464#9
# asm 2: subpd <carry=%xmm6,<r8=%xmm8
subpd %xmm6,%xmm8

# qhasm: carry = r11
# asm 1: movdqa <r11=int6464#12,>carry=int6464#7
# asm 2: movdqa <r11=%xmm11,>carry=%xmm6
movdqa %xmm11,%xmm6

# qhasm: float6464 carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<carry=int6464#7
# asm 2: mulpd VINV_VINV,<carry=%xmm6
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#7
# asm 2: addpd <round=%xmm3,<carry=%xmm6
addpd %xmm3,%xmm6

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#7
# asm 2: subpd <round=%xmm3,<carry=%xmm6
subpd %xmm3,%xmm6

# qhasm: float6464 r0 -= carry
# asm 1: subpd <carry=int6464#7,<r0=int6464#1
# asm 2: subpd <carry=%xmm6,<r0=%xmm0
subpd %xmm6,%xmm0

# qhasm: float6464 r3 -= carry
# asm 1: subpd <carry=int6464#7,<r3=int6464#13
# asm 2: subpd <carry=%xmm6,<r3=%xmm12
subpd %xmm6,%xmm12

# qhasm: t6 = carry
# asm 1: movdqa <carry=int6464#7,>t6=int6464#10
# asm 2: movdqa <carry=%xmm6,>t6=%xmm9
movdqa %xmm6,%xmm9

# qhasm: float6464 t6 *= FOUR_FOUR
# asm 1: mulpd FOUR_FOUR,<t6=int6464#10
# asm 2: mulpd FOUR_FOUR,<t6=%xmm9
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm9

# qhasm: float6464 r6 -= t6
# asm 1: subpd <t6=int6464#10,<r6=int6464#14
# asm 2: subpd <t6=%xmm9,<r6=%xmm13
subpd %xmm9,%xmm13

# qhasm: float6464 r9 -= carry
# asm 1: subpd <carry=int6464#7,<r9=int6464#15
# asm 2: subpd <carry=%xmm6,<r9=%xmm14
subpd %xmm6,%xmm14

# qhasm: float6464 carry *= V_V
# asm 1: mulpd V_V,<carry=int6464#7
# asm 2: mulpd V_V,<carry=%xmm6
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 r11 -= carry
# asm 1: subpd <carry=int6464#7,<r11=int6464#12
# asm 2: subpd <carry=%xmm6,<r11=%xmm11
subpd %xmm6,%xmm11

# qhasm: carry = r0
# asm 1: movdqa <r0=int6464#1,>carry=int6464#7
# asm 2: movdqa <r0=%xmm0,>carry=%xmm6
movdqa %xmm0,%xmm6

# qhasm: float6464 carry *= V6INV_V6INV
# asm 1: mulpd V6INV_V6INV,<carry=int6464#7
# asm 2: mulpd V6INV_V6INV,<carry=%xmm6
mov V6INV_V6INV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#7
# asm 2: addpd <round=%xmm3,<carry=%xmm6
addpd %xmm3,%xmm6

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#7
# asm 2: subpd <round=%xmm3,<carry=%xmm6
subpd %xmm3,%xmm6

# qhasm: float6464 r1 += carry
# asm 1: addpd <carry=int6464#7,<r1=int6464#2
# asm 2: addpd <carry=%xmm6,<r1=%xmm1
addpd %xmm6,%xmm1

# qhasm: float6464 carry *= V6_V6
# asm 1: mulpd V6_V6,<carry=int6464#7
# asm 2: mulpd V6_V6,<carry=%xmm6
mov V6_V6@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 r0 -= carry
# asm 1: subpd <carry=int6464#7,<r0=int6464#1
# asm 2: subpd <carry=%xmm6,<r0=%xmm0
subpd %xmm6,%xmm0

# qhasm: *(int128 *)(rop +   0) =  r0
# asm 1: movdqa <r0=int6464#1,0(<rop=int64#1)
# asm 2: movdqa <r0=%xmm0,0(<rop=%rdi)
movdqa %xmm0,0(%rdi)

# qhasm: carry = r3
# asm 1: movdqa <r3=int6464#13,>carry=int6464#1
# asm 2: movdqa <r3=%xmm12,>carry=%xmm0
movdqa %xmm12,%xmm0

# qhasm: float6464 carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<carry=int6464#1
# asm 2: mulpd VINV_VINV,<carry=%xmm0
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#1
# asm 2: addpd <round=%xmm3,<carry=%xmm0
addpd %xmm3,%xmm0

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#1
# asm 2: subpd <round=%xmm3,<carry=%xmm0
subpd %xmm3,%xmm0

# qhasm: float6464 r4 += carry
# asm 1: addpd <carry=int6464#1,<r4=int6464#5
# asm 2: addpd <carry=%xmm0,<r4=%xmm4
addpd %xmm0,%xmm4

# qhasm: float6464 carry *= V_V
# asm 1: mulpd V_V,<carry=int6464#1
# asm 2: mulpd V_V,<carry=%xmm0
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 r3 -= carry
# asm 1: subpd <carry=int6464#1,<r3=int6464#13
# asm 2: subpd <carry=%xmm0,<r3=%xmm12
subpd %xmm0,%xmm12

# qhasm: *(int128 *)(rop +  48) =  r3
# asm 1: movdqa <r3=int6464#13,48(<rop=int64#1)
# asm 2: movdqa <r3=%xmm12,48(<rop=%rdi)
movdqa %xmm12,48(%rdi)

# qhasm: carry = r6
# asm 1: movdqa <r6=int6464#14,>carry=int6464#1
# asm 2: movdqa <r6=%xmm13,>carry=%xmm0
movdqa %xmm13,%xmm0

# qhasm: float6464 carry *= V6INV_V6INV
# asm 1: mulpd V6INV_V6INV,<carry=int6464#1
# asm 2: mulpd V6INV_V6INV,<carry=%xmm0
mov V6INV_V6INV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#1
# asm 2: addpd <round=%xmm3,<carry=%xmm0
addpd %xmm3,%xmm0

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#1
# asm 2: subpd <round=%xmm3,<carry=%xmm0
subpd %xmm3,%xmm0

# qhasm: float6464 r7 += carry
# asm 1: addpd <carry=int6464#1,<r7=int6464#8
# asm 2: addpd <carry=%xmm0,<r7=%xmm7
addpd %xmm0,%xmm7

# qhasm: float6464 carry *= V6_V6
# asm 1: mulpd V6_V6,<carry=int6464#1
# asm 2: mulpd V6_V6,<carry=%xmm0
mov V6_V6@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 r6 -= carry
# asm 1: subpd <carry=int6464#1,<r6=int6464#14
# asm 2: subpd <carry=%xmm0,<r6=%xmm13
subpd %xmm0,%xmm13

# qhasm: *(int128 *)(rop +  96) =  r6
# asm 1: movdqa <r6=int6464#14,96(<rop=int64#1)
# asm 2: movdqa <r6=%xmm13,96(<rop=%rdi)
movdqa %xmm13,96(%rdi)

# qhasm: carry = r9
# asm 1: movdqa <r9=int6464#15,>carry=int6464#1
# asm 2: movdqa <r9=%xmm14,>carry=%xmm0
movdqa %xmm14,%xmm0

# qhasm: float6464 carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<carry=int6464#1
# asm 2: mulpd VINV_VINV,<carry=%xmm0
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#1
# asm 2: addpd <round=%xmm3,<carry=%xmm0
addpd %xmm3,%xmm0

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#1
# asm 2: subpd <round=%xmm3,<carry=%xmm0
subpd %xmm3,%xmm0

# qhasm: float6464 r10 += carry
# asm 1: addpd <carry=int6464#1,<r10=int6464#11
# asm 2: addpd <carry=%xmm0,<r10=%xmm10
addpd %xmm0,%xmm10

# qhasm: float6464 carry *= V_V
# asm 1: mulpd V_V,<carry=int6464#1
# asm 2: mulpd V_V,<carry=%xmm0
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 r9 -= carry
# asm 1: subpd <carry=int6464#1,<r9=int6464#15
# asm 2: subpd <carry=%xmm0,<r9=%xmm14
subpd %xmm0,%xmm14

# qhasm: *(int128 *)(rop + 144) =  r9
# asm 1: movdqa <r9=int6464#15,144(<rop=int64#1)
# asm 2: movdqa <r9=%xmm14,144(<rop=%rdi)
movdqa %xmm14,144(%rdi)

# qhasm: carry = r1
# asm 1: movdqa <r1=int6464#2,>carry=int6464#1
# asm 2: movdqa <r1=%xmm1,>carry=%xmm0
movdqa %xmm1,%xmm0

# qhasm: float6464 carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<carry=int6464#1
# asm 2: mulpd VINV_VINV,<carry=%xmm0
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#1
# asm 2: addpd <round=%xmm3,<carry=%xmm0
addpd %xmm3,%xmm0

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#1
# asm 2: subpd <round=%xmm3,<carry=%xmm0
subpd %xmm3,%xmm0

# qhasm: float6464 r2 += carry
# asm 1: addpd <carry=int6464#1,<r2=int6464#3
# asm 2: addpd <carry=%xmm0,<r2=%xmm2
addpd %xmm0,%xmm2

# qhasm: float6464 carry *= V_V
# asm 1: mulpd V_V,<carry=int6464#1
# asm 2: mulpd V_V,<carry=%xmm0
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 r1 -= carry
# asm 1: subpd <carry=int6464#1,<r1=int6464#2
# asm 2: subpd <carry=%xmm0,<r1=%xmm1
subpd %xmm0,%xmm1

# qhasm: *(int128 *)(rop +  16) =  r1
# asm 1: movdqa <r1=int6464#2,16(<rop=int64#1)
# asm 2: movdqa <r1=%xmm1,16(<rop=%rdi)
movdqa %xmm1,16(%rdi)

# qhasm: *(int128 *)(rop +  32) =  r2
# asm 1: movdqa <r2=int6464#3,32(<rop=int64#1)
# asm 2: movdqa <r2=%xmm2,32(<rop=%rdi)
movdqa %xmm2,32(%rdi)

# qhasm: carry = r4
# asm 1: movdqa <r4=int6464#5,>carry=int6464#1
# asm 2: movdqa <r4=%xmm4,>carry=%xmm0
movdqa %xmm4,%xmm0

# qhasm: float6464 carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<carry=int6464#1
# asm 2: mulpd VINV_VINV,<carry=%xmm0
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#1
# asm 2: addpd <round=%xmm3,<carry=%xmm0
addpd %xmm3,%xmm0

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#1
# asm 2: subpd <round=%xmm3,<carry=%xmm0
subpd %xmm3,%xmm0

# qhasm: float6464 r5 += carry
# asm 1: addpd <carry=int6464#1,<r5=int6464#6
# asm 2: addpd <carry=%xmm0,<r5=%xmm5
addpd %xmm0,%xmm5

# qhasm: float6464 carry *= V_V
# asm 1: mulpd V_V,<carry=int6464#1
# asm 2: mulpd V_V,<carry=%xmm0
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 r4 -= carry
# asm 1: subpd <carry=int6464#1,<r4=int6464#5
# asm 2: subpd <carry=%xmm0,<r4=%xmm4
subpd %xmm0,%xmm4

# qhasm: *(int128 *)(rop +  64) =  r4
# asm 1: movdqa <r4=int6464#5,64(<rop=int64#1)
# asm 2: movdqa <r4=%xmm4,64(<rop=%rdi)
movdqa %xmm4,64(%rdi)

# qhasm: *(int128 *)(rop +  80) =  r5
# asm 1: movdqa <r5=int6464#6,80(<rop=int64#1)
# asm 2: movdqa <r5=%xmm5,80(<rop=%rdi)
movdqa %xmm5,80(%rdi)

# qhasm: carry = r7
# asm 1: movdqa <r7=int6464#8,>carry=int6464#1
# asm 2: movdqa <r7=%xmm7,>carry=%xmm0
movdqa %xmm7,%xmm0

# qhasm: float6464 carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<carry=int6464#1
# asm 2: mulpd VINV_VINV,<carry=%xmm0
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#1
# asm 2: addpd <round=%xmm3,<carry=%xmm0
addpd %xmm3,%xmm0

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#1
# asm 2: subpd <round=%xmm3,<carry=%xmm0
subpd %xmm3,%xmm0

# qhasm: float6464 r8 += carry
# asm 1: addpd <carry=int6464#1,<r8=int6464#9
# asm 2: addpd <carry=%xmm0,<r8=%xmm8
addpd %xmm0,%xmm8

# qhasm: float6464 carry *= V_V
# asm 1: mulpd V_V,<carry=int6464#1
# asm 2: mulpd V_V,<carry=%xmm0
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 r7 -= carry
# asm 1: subpd <carry=int6464#1,<r7=int6464#8
# asm 2: subpd <carry=%xmm0,<r7=%xmm7
subpd %xmm0,%xmm7

# qhasm: *(int128 *)(rop + 112) =  r7
# asm 1: movdqa <r7=int6464#8,112(<rop=int64#1)
# asm 2: movdqa <r7=%xmm7,112(<rop=%rdi)
movdqa %xmm7,112(%rdi)

# qhasm: *(int128 *)(rop + 128) =  r8
# asm 1: movdqa <r8=int6464#9,128(<rop=int64#1)
# asm 2: movdqa <r8=%xmm8,128(<rop=%rdi)
movdqa %xmm8,128(%rdi)

# qhasm: carry = r10
# asm 1: movdqa <r10=int6464#11,>carry=int6464#1
# asm 2: movdqa <r10=%xmm10,>carry=%xmm0
movdqa %xmm10,%xmm0

# qhasm: float6464 carry *= VINV_VINV
# asm 1: mulpd VINV_VINV,<carry=int6464#1
# asm 2: mulpd VINV_VINV,<carry=%xmm0
mov VINV_VINV@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 carry += round
# asm 1: addpd <round=int6464#4,<carry=int6464#1
# asm 2: addpd <round=%xmm3,<carry=%xmm0
addpd %xmm3,%xmm0

# qhasm: float6464 carry -= round
# asm 1: subpd <round=int6464#4,<carry=int6464#1
# asm 2: subpd <round=%xmm3,<carry=%xmm0
subpd %xmm3,%xmm0

# qhasm: float6464 r11 += carry
# asm 1: addpd <carry=int6464#1,<r11=int6464#12
# asm 2: addpd <carry=%xmm0,<r11=%xmm11
addpd %xmm0,%xmm11

# qhasm: float6464 carry *= V_V
# asm 1: mulpd V_V,<carry=int6464#1
# asm 2: mulpd V_V,<carry=%xmm0
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 r10 -= carry
# asm 1: subpd <carry=int6464#1,<r10=int6464#11
# asm 2: subpd <carry=%xmm0,<r10=%xmm10
subpd %xmm0,%xmm10

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
