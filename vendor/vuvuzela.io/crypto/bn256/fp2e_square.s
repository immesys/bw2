# File:   dclxvi-20130329/fp2e_square.s
# Author: Ruben Niederhagen, Peter Schwabe
# Public Domain


# qhasm: int64 rop

# qhasm: int64 op

# qhasm: input rop

# qhasm: input op

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

# qhasm: int6464 tmp0

# qhasm: int6464 tmp1

# qhasm: int6464 tmp2

# qhasm: int6464 tmp3

# qhasm: int6464 tmp4

# qhasm: int6464 tmp5

# qhasm: int6464 tmp6

# qhasm: int6464 tmp7

# qhasm: int6464 tmp8

# qhasm: int6464 tmp9

# qhasm: int6464 tmp10

# qhasm: int6464 tmp11

# qhasm: int64 t1p

# qhasm: int64 t2p

# qhasm: int64 rp

# qhasm: int6464 0yoff

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

# qhasm: int64 myp

# qhasm: int6464 round

# qhasm: int6464 carry

# qhasm: int6464 2t6

# qhasm: stack6144 mystack

# qhasm: enter fp2e_square_qhasm
.text
.p2align 5
.globl _fp2e_square_qhasm
.globl fp2e_square_qhasm
_fp2e_square_qhasm:
fp2e_square_qhasm:
push %rbp
mov %rsp,%r11
and $31,%r11
add $768,%r11
sub %r11,%rsp

# qhasm: myp = &mystack
# asm 1: leaq <mystack=stack6144#1,>myp=int64#3
# asm 2: leaq <mystack=0(%rsp),>myp=%rdx
leaq 0(%rsp),%rdx

# qhasm: r0  = *(int128 *)(op +   0)
# asm 1: movdqa 0(<op=int64#2),>r0=int6464#1
# asm 2: movdqa 0(<op=%rsi),>r0=%xmm0
movdqa 0(%rsi),%xmm0

# qhasm: tmp0 = r0                                                          
# asm 1: movdqa <r0=int6464#1,>tmp0=int6464#2
# asm 2: movdqa <r0=%xmm0,>tmp0=%xmm1
movdqa %xmm0,%xmm1

# qhasm: tmp0 = shuffle float64 of tmp0 and tmp0 by 0x1                   
# asm 1: shufpd $0x1,<tmp0=int6464#2,<tmp0=int6464#2
# asm 2: shufpd $0x1,<tmp0=%xmm1,<tmp0=%xmm1
shufpd $0x1,%xmm1,%xmm1

# qhasm: float6464 r0[0] -= tmp0[0]                                       
# asm 1: subsd <tmp0=int6464#2,<r0=int6464#1
# asm 2: subsd <tmp0=%xmm1,<r0=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(int128 *)(myp + 0) = r0
# asm 1: movdqa <r0=int6464#1,0(<myp=int64#3)
# asm 2: movdqa <r0=%xmm0,0(<myp=%rdx)
movdqa %xmm0,0(%rdx)

# qhasm: r0 = tmp0
# asm 1: movdqa <tmp0=int6464#2,>r0=int6464#1
# asm 2: movdqa <tmp0=%xmm1,>r0=%xmm0
movdqa %xmm1,%xmm0

# qhasm: r0 = unpack high double of r0 and r0                      
# asm 1: unpckhpd <r0=int6464#1,<r0=int6464#1
# asm 2: unpckhpd <r0=%xmm0,<r0=%xmm0
unpckhpd %xmm0,%xmm0

# qhasm: float6464 tmp0 += r0
# asm 1: addpd <r0=int6464#1,<tmp0=int6464#2
# asm 2: addpd <r0=%xmm0,<tmp0=%xmm1
addpd %xmm0,%xmm1

# qhasm: *(int128 *)(myp + 192) = tmp0
# asm 1: movdqa <tmp0=int6464#2,192(<myp=int64#3)
# asm 2: movdqa <tmp0=%xmm1,192(<myp=%rdx)
movdqa %xmm1,192(%rdx)

# qhasm: r1  = *(int128 *)(op +  16)
# asm 1: movdqa 16(<op=int64#2),>r1=int6464#1
# asm 2: movdqa 16(<op=%rsi),>r1=%xmm0
movdqa 16(%rsi),%xmm0

# qhasm: tmp1 = r1                                                          
# asm 1: movdqa <r1=int6464#1,>tmp1=int6464#2
# asm 2: movdqa <r1=%xmm0,>tmp1=%xmm1
movdqa %xmm0,%xmm1

# qhasm: tmp1 = shuffle float64 of tmp1 and tmp1 by 0x1                   
# asm 1: shufpd $0x1,<tmp1=int6464#2,<tmp1=int6464#2
# asm 2: shufpd $0x1,<tmp1=%xmm1,<tmp1=%xmm1
shufpd $0x1,%xmm1,%xmm1

# qhasm: float6464 r1[0] -= tmp1[0]                                       
# asm 1: subsd <tmp1=int6464#2,<r1=int6464#1
# asm 2: subsd <tmp1=%xmm1,<r1=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(int128 *)(myp + 16) = r1
# asm 1: movdqa <r1=int6464#1,16(<myp=int64#3)
# asm 2: movdqa <r1=%xmm0,16(<myp=%rdx)
movdqa %xmm0,16(%rdx)

# qhasm: r1 = tmp1
# asm 1: movdqa <tmp1=int6464#2,>r1=int6464#1
# asm 2: movdqa <tmp1=%xmm1,>r1=%xmm0
movdqa %xmm1,%xmm0

# qhasm: r1 = unpack high double of r1 and r1                      
# asm 1: unpckhpd <r1=int6464#1,<r1=int6464#1
# asm 2: unpckhpd <r1=%xmm0,<r1=%xmm0
unpckhpd %xmm0,%xmm0

# qhasm: float6464 tmp1 += r1
# asm 1: addpd <r1=int6464#1,<tmp1=int6464#2
# asm 2: addpd <r1=%xmm0,<tmp1=%xmm1
addpd %xmm0,%xmm1

# qhasm: *(int128 *)(myp + 208) = tmp1
# asm 1: movdqa <tmp1=int6464#2,208(<myp=int64#3)
# asm 2: movdqa <tmp1=%xmm1,208(<myp=%rdx)
movdqa %xmm1,208(%rdx)

# qhasm: r2  = *(int128 *)(op +  32)
# asm 1: movdqa 32(<op=int64#2),>r2=int6464#1
# asm 2: movdqa 32(<op=%rsi),>r2=%xmm0
movdqa 32(%rsi),%xmm0

# qhasm: tmp2 = r2                                                          
# asm 1: movdqa <r2=int6464#1,>tmp2=int6464#2
# asm 2: movdqa <r2=%xmm0,>tmp2=%xmm1
movdqa %xmm0,%xmm1

# qhasm: tmp2 = shuffle float64 of tmp2 and tmp2 by 0x1                   
# asm 1: shufpd $0x1,<tmp2=int6464#2,<tmp2=int6464#2
# asm 2: shufpd $0x1,<tmp2=%xmm1,<tmp2=%xmm1
shufpd $0x1,%xmm1,%xmm1

# qhasm: float6464 r2[0] -= tmp2[0]                                       
# asm 1: subsd <tmp2=int6464#2,<r2=int6464#1
# asm 2: subsd <tmp2=%xmm1,<r2=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(int128 *)(myp + 32) = r2
# asm 1: movdqa <r2=int6464#1,32(<myp=int64#3)
# asm 2: movdqa <r2=%xmm0,32(<myp=%rdx)
movdqa %xmm0,32(%rdx)

# qhasm: r2 = tmp2
# asm 1: movdqa <tmp2=int6464#2,>r2=int6464#1
# asm 2: movdqa <tmp2=%xmm1,>r2=%xmm0
movdqa %xmm1,%xmm0

# qhasm: r2 = unpack high double of r2 and r2                      
# asm 1: unpckhpd <r2=int6464#1,<r2=int6464#1
# asm 2: unpckhpd <r2=%xmm0,<r2=%xmm0
unpckhpd %xmm0,%xmm0

# qhasm: float6464 tmp2 += r2
# asm 1: addpd <r2=int6464#1,<tmp2=int6464#2
# asm 2: addpd <r2=%xmm0,<tmp2=%xmm1
addpd %xmm0,%xmm1

# qhasm: *(int128 *)(myp + 224) = tmp2
# asm 1: movdqa <tmp2=int6464#2,224(<myp=int64#3)
# asm 2: movdqa <tmp2=%xmm1,224(<myp=%rdx)
movdqa %xmm1,224(%rdx)

# qhasm: r3  = *(int128 *)(op +  48)
# asm 1: movdqa 48(<op=int64#2),>r3=int6464#1
# asm 2: movdqa 48(<op=%rsi),>r3=%xmm0
movdqa 48(%rsi),%xmm0

# qhasm: tmp3 = r3                                                          
# asm 1: movdqa <r3=int6464#1,>tmp3=int6464#2
# asm 2: movdqa <r3=%xmm0,>tmp3=%xmm1
movdqa %xmm0,%xmm1

# qhasm: tmp3 = shuffle float64 of tmp3 and tmp3 by 0x1                   
# asm 1: shufpd $0x1,<tmp3=int6464#2,<tmp3=int6464#2
# asm 2: shufpd $0x1,<tmp3=%xmm1,<tmp3=%xmm1
shufpd $0x1,%xmm1,%xmm1

# qhasm: float6464 r3[0] -= tmp3[0]                                       
# asm 1: subsd <tmp3=int6464#2,<r3=int6464#1
# asm 2: subsd <tmp3=%xmm1,<r3=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(int128 *)(myp + 48) = r3
# asm 1: movdqa <r3=int6464#1,48(<myp=int64#3)
# asm 2: movdqa <r3=%xmm0,48(<myp=%rdx)
movdqa %xmm0,48(%rdx)

# qhasm: r3 = tmp3
# asm 1: movdqa <tmp3=int6464#2,>r3=int6464#1
# asm 2: movdqa <tmp3=%xmm1,>r3=%xmm0
movdqa %xmm1,%xmm0

# qhasm: r3 = unpack high double of r3 and r3                      
# asm 1: unpckhpd <r3=int6464#1,<r3=int6464#1
# asm 2: unpckhpd <r3=%xmm0,<r3=%xmm0
unpckhpd %xmm0,%xmm0

# qhasm: float6464 tmp3 += r3
# asm 1: addpd <r3=int6464#1,<tmp3=int6464#2
# asm 2: addpd <r3=%xmm0,<tmp3=%xmm1
addpd %xmm0,%xmm1

# qhasm: *(int128 *)(myp + 240) = tmp3
# asm 1: movdqa <tmp3=int6464#2,240(<myp=int64#3)
# asm 2: movdqa <tmp3=%xmm1,240(<myp=%rdx)
movdqa %xmm1,240(%rdx)

# qhasm: r4  = *(int128 *)(op +  64)
# asm 1: movdqa 64(<op=int64#2),>r4=int6464#1
# asm 2: movdqa 64(<op=%rsi),>r4=%xmm0
movdqa 64(%rsi),%xmm0

# qhasm: tmp4 = r4                                                          
# asm 1: movdqa <r4=int6464#1,>tmp4=int6464#2
# asm 2: movdqa <r4=%xmm0,>tmp4=%xmm1
movdqa %xmm0,%xmm1

# qhasm: tmp4 = shuffle float64 of tmp4 and tmp4 by 0x1                   
# asm 1: shufpd $0x1,<tmp4=int6464#2,<tmp4=int6464#2
# asm 2: shufpd $0x1,<tmp4=%xmm1,<tmp4=%xmm1
shufpd $0x1,%xmm1,%xmm1

# qhasm: float6464 r4[0] -= tmp4[0]                                       
# asm 1: subsd <tmp4=int6464#2,<r4=int6464#1
# asm 2: subsd <tmp4=%xmm1,<r4=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(int128 *)(myp + 64) = r4
# asm 1: movdqa <r4=int6464#1,64(<myp=int64#3)
# asm 2: movdqa <r4=%xmm0,64(<myp=%rdx)
movdqa %xmm0,64(%rdx)

# qhasm: r4 = tmp4
# asm 1: movdqa <tmp4=int6464#2,>r4=int6464#1
# asm 2: movdqa <tmp4=%xmm1,>r4=%xmm0
movdqa %xmm1,%xmm0

# qhasm: r4 = unpack high double of r4 and r4                      
# asm 1: unpckhpd <r4=int6464#1,<r4=int6464#1
# asm 2: unpckhpd <r4=%xmm0,<r4=%xmm0
unpckhpd %xmm0,%xmm0

# qhasm: float6464 tmp4 += r4
# asm 1: addpd <r4=int6464#1,<tmp4=int6464#2
# asm 2: addpd <r4=%xmm0,<tmp4=%xmm1
addpd %xmm0,%xmm1

# qhasm: *(int128 *)(myp + 256) = tmp4
# asm 1: movdqa <tmp4=int6464#2,256(<myp=int64#3)
# asm 2: movdqa <tmp4=%xmm1,256(<myp=%rdx)
movdqa %xmm1,256(%rdx)

# qhasm: r5  = *(int128 *)(op +  80)
# asm 1: movdqa 80(<op=int64#2),>r5=int6464#1
# asm 2: movdqa 80(<op=%rsi),>r5=%xmm0
movdqa 80(%rsi),%xmm0

# qhasm: tmp5 = r5                                                          
# asm 1: movdqa <r5=int6464#1,>tmp5=int6464#2
# asm 2: movdqa <r5=%xmm0,>tmp5=%xmm1
movdqa %xmm0,%xmm1

# qhasm: tmp5 = shuffle float64 of tmp5 and tmp5 by 0x1                   
# asm 1: shufpd $0x1,<tmp5=int6464#2,<tmp5=int6464#2
# asm 2: shufpd $0x1,<tmp5=%xmm1,<tmp5=%xmm1
shufpd $0x1,%xmm1,%xmm1

# qhasm: float6464 r5[0] -= tmp5[0]                                       
# asm 1: subsd <tmp5=int6464#2,<r5=int6464#1
# asm 2: subsd <tmp5=%xmm1,<r5=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(int128 *)(myp + 80) = r5
# asm 1: movdqa <r5=int6464#1,80(<myp=int64#3)
# asm 2: movdqa <r5=%xmm0,80(<myp=%rdx)
movdqa %xmm0,80(%rdx)

# qhasm: r5 = tmp5
# asm 1: movdqa <tmp5=int6464#2,>r5=int6464#1
# asm 2: movdqa <tmp5=%xmm1,>r5=%xmm0
movdqa %xmm1,%xmm0

# qhasm: r5 = unpack high double of r5 and r5                      
# asm 1: unpckhpd <r5=int6464#1,<r5=int6464#1
# asm 2: unpckhpd <r5=%xmm0,<r5=%xmm0
unpckhpd %xmm0,%xmm0

# qhasm: float6464 tmp5 += r5
# asm 1: addpd <r5=int6464#1,<tmp5=int6464#2
# asm 2: addpd <r5=%xmm0,<tmp5=%xmm1
addpd %xmm0,%xmm1

# qhasm: *(int128 *)(myp + 272) = tmp5
# asm 1: movdqa <tmp5=int6464#2,272(<myp=int64#3)
# asm 2: movdqa <tmp5=%xmm1,272(<myp=%rdx)
movdqa %xmm1,272(%rdx)

# qhasm: r6  = *(int128 *)(op +  96)
# asm 1: movdqa 96(<op=int64#2),>r6=int6464#1
# asm 2: movdqa 96(<op=%rsi),>r6=%xmm0
movdqa 96(%rsi),%xmm0

# qhasm: tmp6 = r6                                                          
# asm 1: movdqa <r6=int6464#1,>tmp6=int6464#2
# asm 2: movdqa <r6=%xmm0,>tmp6=%xmm1
movdqa %xmm0,%xmm1

# qhasm: tmp6 = shuffle float64 of tmp6 and tmp6 by 0x1                   
# asm 1: shufpd $0x1,<tmp6=int6464#2,<tmp6=int6464#2
# asm 2: shufpd $0x1,<tmp6=%xmm1,<tmp6=%xmm1
shufpd $0x1,%xmm1,%xmm1

# qhasm: float6464 r6[0] -= tmp6[0]                                       
# asm 1: subsd <tmp6=int6464#2,<r6=int6464#1
# asm 2: subsd <tmp6=%xmm1,<r6=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(int128 *)(myp + 96) = r6
# asm 1: movdqa <r6=int6464#1,96(<myp=int64#3)
# asm 2: movdqa <r6=%xmm0,96(<myp=%rdx)
movdqa %xmm0,96(%rdx)

# qhasm: r6 = tmp6
# asm 1: movdqa <tmp6=int6464#2,>r6=int6464#1
# asm 2: movdqa <tmp6=%xmm1,>r6=%xmm0
movdqa %xmm1,%xmm0

# qhasm: r6 = unpack high double of r6 and r6                      
# asm 1: unpckhpd <r6=int6464#1,<r6=int6464#1
# asm 2: unpckhpd <r6=%xmm0,<r6=%xmm0
unpckhpd %xmm0,%xmm0

# qhasm: float6464 tmp6 += r6
# asm 1: addpd <r6=int6464#1,<tmp6=int6464#2
# asm 2: addpd <r6=%xmm0,<tmp6=%xmm1
addpd %xmm0,%xmm1

# qhasm: *(int128 *)(myp + 288) = tmp6
# asm 1: movdqa <tmp6=int6464#2,288(<myp=int64#3)
# asm 2: movdqa <tmp6=%xmm1,288(<myp=%rdx)
movdqa %xmm1,288(%rdx)

# qhasm: r7  = *(int128 *)(op + 112)
# asm 1: movdqa 112(<op=int64#2),>r7=int6464#1
# asm 2: movdqa 112(<op=%rsi),>r7=%xmm0
movdqa 112(%rsi),%xmm0

# qhasm: tmp7 = r7                                                          
# asm 1: movdqa <r7=int6464#1,>tmp7=int6464#2
# asm 2: movdqa <r7=%xmm0,>tmp7=%xmm1
movdqa %xmm0,%xmm1

# qhasm: tmp7 = shuffle float64 of tmp7 and tmp7 by 0x1                   
# asm 1: shufpd $0x1,<tmp7=int6464#2,<tmp7=int6464#2
# asm 2: shufpd $0x1,<tmp7=%xmm1,<tmp7=%xmm1
shufpd $0x1,%xmm1,%xmm1

# qhasm: float6464 r7[0] -= tmp7[0]                                       
# asm 1: subsd <tmp7=int6464#2,<r7=int6464#1
# asm 2: subsd <tmp7=%xmm1,<r7=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(int128 *)(myp + 112) = r7
# asm 1: movdqa <r7=int6464#1,112(<myp=int64#3)
# asm 2: movdqa <r7=%xmm0,112(<myp=%rdx)
movdqa %xmm0,112(%rdx)

# qhasm: r7 = tmp7
# asm 1: movdqa <tmp7=int6464#2,>r7=int6464#1
# asm 2: movdqa <tmp7=%xmm1,>r7=%xmm0
movdqa %xmm1,%xmm0

# qhasm: r7 = unpack high double of r7 and r7                      
# asm 1: unpckhpd <r7=int6464#1,<r7=int6464#1
# asm 2: unpckhpd <r7=%xmm0,<r7=%xmm0
unpckhpd %xmm0,%xmm0

# qhasm: float6464 tmp7 += r7
# asm 1: addpd <r7=int6464#1,<tmp7=int6464#2
# asm 2: addpd <r7=%xmm0,<tmp7=%xmm1
addpd %xmm0,%xmm1

# qhasm: *(int128 *)(myp + 304) = tmp7
# asm 1: movdqa <tmp7=int6464#2,304(<myp=int64#3)
# asm 2: movdqa <tmp7=%xmm1,304(<myp=%rdx)
movdqa %xmm1,304(%rdx)

# qhasm: r8  = *(int128 *)(op + 128)
# asm 1: movdqa 128(<op=int64#2),>r8=int6464#1
# asm 2: movdqa 128(<op=%rsi),>r8=%xmm0
movdqa 128(%rsi),%xmm0

# qhasm: tmp8 = r8                                                          
# asm 1: movdqa <r8=int6464#1,>tmp8=int6464#2
# asm 2: movdqa <r8=%xmm0,>tmp8=%xmm1
movdqa %xmm0,%xmm1

# qhasm: tmp8 = shuffle float64 of tmp8 and tmp8 by 0x1                   
# asm 1: shufpd $0x1,<tmp8=int6464#2,<tmp8=int6464#2
# asm 2: shufpd $0x1,<tmp8=%xmm1,<tmp8=%xmm1
shufpd $0x1,%xmm1,%xmm1

# qhasm: float6464 r8[0] -= tmp8[0]                                       
# asm 1: subsd <tmp8=int6464#2,<r8=int6464#1
# asm 2: subsd <tmp8=%xmm1,<r8=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(int128 *)(myp + 128) = r8
# asm 1: movdqa <r8=int6464#1,128(<myp=int64#3)
# asm 2: movdqa <r8=%xmm0,128(<myp=%rdx)
movdqa %xmm0,128(%rdx)

# qhasm: r8 = tmp8
# asm 1: movdqa <tmp8=int6464#2,>r8=int6464#1
# asm 2: movdqa <tmp8=%xmm1,>r8=%xmm0
movdqa %xmm1,%xmm0

# qhasm: r8 = unpack high double of r8 and r8                      
# asm 1: unpckhpd <r8=int6464#1,<r8=int6464#1
# asm 2: unpckhpd <r8=%xmm0,<r8=%xmm0
unpckhpd %xmm0,%xmm0

# qhasm: float6464 tmp8 += r8
# asm 1: addpd <r8=int6464#1,<tmp8=int6464#2
# asm 2: addpd <r8=%xmm0,<tmp8=%xmm1
addpd %xmm0,%xmm1

# qhasm: *(int128 *)(myp + 320) = tmp8
# asm 1: movdqa <tmp8=int6464#2,320(<myp=int64#3)
# asm 2: movdqa <tmp8=%xmm1,320(<myp=%rdx)
movdqa %xmm1,320(%rdx)

# qhasm: r9  = *(int128 *)(op + 144)
# asm 1: movdqa 144(<op=int64#2),>r9=int6464#1
# asm 2: movdqa 144(<op=%rsi),>r9=%xmm0
movdqa 144(%rsi),%xmm0

# qhasm: tmp9 = r9                                                          
# asm 1: movdqa <r9=int6464#1,>tmp9=int6464#2
# asm 2: movdqa <r9=%xmm0,>tmp9=%xmm1
movdqa %xmm0,%xmm1

# qhasm: tmp9 = shuffle float64 of tmp9 and tmp9 by 0x1                   
# asm 1: shufpd $0x1,<tmp9=int6464#2,<tmp9=int6464#2
# asm 2: shufpd $0x1,<tmp9=%xmm1,<tmp9=%xmm1
shufpd $0x1,%xmm1,%xmm1

# qhasm: float6464 r9[0] -= tmp9[0]                                       
# asm 1: subsd <tmp9=int6464#2,<r9=int6464#1
# asm 2: subsd <tmp9=%xmm1,<r9=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(int128 *)(myp + 144) = r9
# asm 1: movdqa <r9=int6464#1,144(<myp=int64#3)
# asm 2: movdqa <r9=%xmm0,144(<myp=%rdx)
movdqa %xmm0,144(%rdx)

# qhasm: r9 = tmp9
# asm 1: movdqa <tmp9=int6464#2,>r9=int6464#1
# asm 2: movdqa <tmp9=%xmm1,>r9=%xmm0
movdqa %xmm1,%xmm0

# qhasm: r9 = unpack high double of r9 and r9                      
# asm 1: unpckhpd <r9=int6464#1,<r9=int6464#1
# asm 2: unpckhpd <r9=%xmm0,<r9=%xmm0
unpckhpd %xmm0,%xmm0

# qhasm: float6464 tmp9 += r9
# asm 1: addpd <r9=int6464#1,<tmp9=int6464#2
# asm 2: addpd <r9=%xmm0,<tmp9=%xmm1
addpd %xmm0,%xmm1

# qhasm: *(int128 *)(myp + 336) = tmp9
# asm 1: movdqa <tmp9=int6464#2,336(<myp=int64#3)
# asm 2: movdqa <tmp9=%xmm1,336(<myp=%rdx)
movdqa %xmm1,336(%rdx)

# qhasm: r10 = *(int128 *)(op + 160)
# asm 1: movdqa 160(<op=int64#2),>r10=int6464#1
# asm 2: movdqa 160(<op=%rsi),>r10=%xmm0
movdqa 160(%rsi),%xmm0

# qhasm: tmp10 = r10                                                          
# asm 1: movdqa <r10=int6464#1,>tmp10=int6464#2
# asm 2: movdqa <r10=%xmm0,>tmp10=%xmm1
movdqa %xmm0,%xmm1

# qhasm: tmp10 = shuffle float64 of tmp10 and tmp10 by 0x1                   
# asm 1: shufpd $0x1,<tmp10=int6464#2,<tmp10=int6464#2
# asm 2: shufpd $0x1,<tmp10=%xmm1,<tmp10=%xmm1
shufpd $0x1,%xmm1,%xmm1

# qhasm: float6464 r10[0] -= tmp10[0]                                       
# asm 1: subsd <tmp10=int6464#2,<r10=int6464#1
# asm 2: subsd <tmp10=%xmm1,<r10=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(int128 *)(myp + 160) = r10
# asm 1: movdqa <r10=int6464#1,160(<myp=int64#3)
# asm 2: movdqa <r10=%xmm0,160(<myp=%rdx)
movdqa %xmm0,160(%rdx)

# qhasm: r10 = tmp10
# asm 1: movdqa <tmp10=int6464#2,>r10=int6464#1
# asm 2: movdqa <tmp10=%xmm1,>r10=%xmm0
movdqa %xmm1,%xmm0

# qhasm: r10 = unpack high double of r10 and r10                      
# asm 1: unpckhpd <r10=int6464#1,<r10=int6464#1
# asm 2: unpckhpd <r10=%xmm0,<r10=%xmm0
unpckhpd %xmm0,%xmm0

# qhasm: float6464 tmp10 += r10
# asm 1: addpd <r10=int6464#1,<tmp10=int6464#2
# asm 2: addpd <r10=%xmm0,<tmp10=%xmm1
addpd %xmm0,%xmm1

# qhasm: *(int128 *)(myp + 352) = tmp10
# asm 1: movdqa <tmp10=int6464#2,352(<myp=int64#3)
# asm 2: movdqa <tmp10=%xmm1,352(<myp=%rdx)
movdqa %xmm1,352(%rdx)

# qhasm: r11 = *(int128 *)(op + 176)
# asm 1: movdqa 176(<op=int64#2),>r11=int6464#1
# asm 2: movdqa 176(<op=%rsi),>r11=%xmm0
movdqa 176(%rsi),%xmm0

# qhasm: tmp11 = r11                                                          
# asm 1: movdqa <r11=int6464#1,>tmp11=int6464#2
# asm 2: movdqa <r11=%xmm0,>tmp11=%xmm1
movdqa %xmm0,%xmm1

# qhasm: tmp11 = shuffle float64 of tmp11 and tmp11 by 0x1                   
# asm 1: shufpd $0x1,<tmp11=int6464#2,<tmp11=int6464#2
# asm 2: shufpd $0x1,<tmp11=%xmm1,<tmp11=%xmm1
shufpd $0x1,%xmm1,%xmm1

# qhasm: float6464 r11[0] -= tmp11[0]                                       
# asm 1: subsd <tmp11=int6464#2,<r11=int6464#1
# asm 2: subsd <tmp11=%xmm1,<r11=%xmm0
subsd %xmm1,%xmm0

# qhasm: *(int128 *)(myp + 176) = r11
# asm 1: movdqa <r11=int6464#1,176(<myp=int64#3)
# asm 2: movdqa <r11=%xmm0,176(<myp=%rdx)
movdqa %xmm0,176(%rdx)

# qhasm: r11 = tmp11
# asm 1: movdqa <tmp11=int6464#2,>r11=int6464#1
# asm 2: movdqa <tmp11=%xmm1,>r11=%xmm0
movdqa %xmm1,%xmm0

# qhasm: r11 = unpack high double of r11 and r11                      
# asm 1: unpckhpd <r11=int6464#1,<r11=int6464#1
# asm 2: unpckhpd <r11=%xmm0,<r11=%xmm0
unpckhpd %xmm0,%xmm0

# qhasm: float6464 tmp11 += r11
# asm 1: addpd <r11=int6464#1,<tmp11=int6464#2
# asm 2: addpd <r11=%xmm0,<tmp11=%xmm1
addpd %xmm0,%xmm1

# qhasm: *(int128 *)(myp + 368) = tmp11
# asm 1: movdqa <tmp11=int6464#2,368(<myp=int64#3)
# asm 2: movdqa <tmp11=%xmm1,368(<myp=%rdx)
movdqa %xmm1,368(%rdx)

# qhasm: t1p  = myp
# asm 1: mov  <myp=int64#3,>t1p=int64#2
# asm 2: mov  <myp=%rdx,>t1p=%rsi
mov  %rdx,%rsi

# qhasm: t2p  = myp + 192
# asm 1: lea  192(<myp=int64#3),>t2p=int64#4
# asm 2: lea  192(<myp=%rdx),>t2p=%rcx
lea  192(%rdx),%rcx

# qhasm: rp = myp + 384
# asm 1: lea  384(<myp=int64#3),>rp=int64#3
# asm 2: lea  384(<myp=%rdx),>rp=%rdx
lea  384(%rdx),%rdx

# qhasm: ab0 = *(int128 *)(t1p + 0)
# asm 1: movdqa 0(<t1p=int64#2),>ab0=int6464#1
# asm 2: movdqa 0(<t1p=%rsi),>ab0=%xmm0
movdqa 0(%rsi),%xmm0

# qhasm: t0 = ab0
# asm 1: movdqa <ab0=int6464#1,>t0=int6464#2
# asm 2: movdqa <ab0=%xmm0,>t0=%xmm1
movdqa %xmm0,%xmm1

# qhasm: float6464 t0 *= *(int128 *)(t2p + 0)
# asm 1: mulpd 0(<t2p=int64#4),<t0=int6464#2
# asm 2: mulpd 0(<t2p=%rcx),<t0=%xmm1
mulpd 0(%rcx),%xmm1

# qhasm: r0 =t0
# asm 1: movdqa <t0=int6464#2,>r0=int6464#2
# asm 2: movdqa <t0=%xmm1,>r0=%xmm1
movdqa %xmm1,%xmm1

# qhasm: t1 = ab0
# asm 1: movdqa <ab0=int6464#1,>t1=int6464#3
# asm 2: movdqa <ab0=%xmm0,>t1=%xmm2
movdqa %xmm0,%xmm2

# qhasm: float6464 t1 *= *(int128 *)(t2p + 16)
# asm 1: mulpd 16(<t2p=int64#4),<t1=int6464#3
# asm 2: mulpd 16(<t2p=%rcx),<t1=%xmm2
mulpd 16(%rcx),%xmm2

# qhasm: r1 =t1
# asm 1: movdqa <t1=int6464#3,>r1=int6464#3
# asm 2: movdqa <t1=%xmm2,>r1=%xmm2
movdqa %xmm2,%xmm2

# qhasm: t2 = ab0
# asm 1: movdqa <ab0=int6464#1,>t2=int6464#4
# asm 2: movdqa <ab0=%xmm0,>t2=%xmm3
movdqa %xmm0,%xmm3

# qhasm: float6464 t2 *= *(int128 *)(t2p + 32)
# asm 1: mulpd 32(<t2p=int64#4),<t2=int6464#4
# asm 2: mulpd 32(<t2p=%rcx),<t2=%xmm3
mulpd 32(%rcx),%xmm3

# qhasm: r2 =t2
# asm 1: movdqa <t2=int6464#4,>r2=int6464#4
# asm 2: movdqa <t2=%xmm3,>r2=%xmm3
movdqa %xmm3,%xmm3

# qhasm: t3 = ab0
# asm 1: movdqa <ab0=int6464#1,>t3=int6464#5
# asm 2: movdqa <ab0=%xmm0,>t3=%xmm4
movdqa %xmm0,%xmm4

# qhasm: float6464 t3 *= *(int128 *)(t2p + 48)
# asm 1: mulpd 48(<t2p=int64#4),<t3=int6464#5
# asm 2: mulpd 48(<t2p=%rcx),<t3=%xmm4
mulpd 48(%rcx),%xmm4

# qhasm: r3 =t3
# asm 1: movdqa <t3=int6464#5,>r3=int6464#5
# asm 2: movdqa <t3=%xmm4,>r3=%xmm4
movdqa %xmm4,%xmm4

# qhasm: t4 = ab0
# asm 1: movdqa <ab0=int6464#1,>t4=int6464#6
# asm 2: movdqa <ab0=%xmm0,>t4=%xmm5
movdqa %xmm0,%xmm5

# qhasm: float6464 t4 *= *(int128 *)(t2p + 64)
# asm 1: mulpd 64(<t2p=int64#4),<t4=int6464#6
# asm 2: mulpd 64(<t2p=%rcx),<t4=%xmm5
mulpd 64(%rcx),%xmm5

# qhasm: r4 =t4
# asm 1: movdqa <t4=int6464#6,>r4=int6464#6
# asm 2: movdqa <t4=%xmm5,>r4=%xmm5
movdqa %xmm5,%xmm5

# qhasm: t5 = ab0
# asm 1: movdqa <ab0=int6464#1,>t5=int6464#7
# asm 2: movdqa <ab0=%xmm0,>t5=%xmm6
movdqa %xmm0,%xmm6

# qhasm: float6464 t5 *= *(int128 *)(t2p + 80)
# asm 1: mulpd 80(<t2p=int64#4),<t5=int6464#7
# asm 2: mulpd 80(<t2p=%rcx),<t5=%xmm6
mulpd 80(%rcx),%xmm6

# qhasm: r5 =t5
# asm 1: movdqa <t5=int6464#7,>r5=int6464#7
# asm 2: movdqa <t5=%xmm6,>r5=%xmm6
movdqa %xmm6,%xmm6

# qhasm: t6 = ab0
# asm 1: movdqa <ab0=int6464#1,>t6=int6464#8
# asm 2: movdqa <ab0=%xmm0,>t6=%xmm7
movdqa %xmm0,%xmm7

# qhasm: float6464 t6 *= *(int128 *)(t2p + 96)
# asm 1: mulpd 96(<t2p=int64#4),<t6=int6464#8
# asm 2: mulpd 96(<t2p=%rcx),<t6=%xmm7
mulpd 96(%rcx),%xmm7

# qhasm: r6 =t6
# asm 1: movdqa <t6=int6464#8,>r6=int6464#8
# asm 2: movdqa <t6=%xmm7,>r6=%xmm7
movdqa %xmm7,%xmm7

# qhasm: t7 = ab0
# asm 1: movdqa <ab0=int6464#1,>t7=int6464#9
# asm 2: movdqa <ab0=%xmm0,>t7=%xmm8
movdqa %xmm0,%xmm8

# qhasm: float6464 t7 *= *(int128 *)(t2p + 112)
# asm 1: mulpd 112(<t2p=int64#4),<t7=int6464#9
# asm 2: mulpd 112(<t2p=%rcx),<t7=%xmm8
mulpd 112(%rcx),%xmm8

# qhasm: r7 =t7
# asm 1: movdqa <t7=int6464#9,>r7=int6464#9
# asm 2: movdqa <t7=%xmm8,>r7=%xmm8
movdqa %xmm8,%xmm8

# qhasm: t8 = ab0
# asm 1: movdqa <ab0=int6464#1,>t8=int6464#10
# asm 2: movdqa <ab0=%xmm0,>t8=%xmm9
movdqa %xmm0,%xmm9

# qhasm: float6464 t8 *= *(int128 *)(t2p + 128)
# asm 1: mulpd 128(<t2p=int64#4),<t8=int6464#10
# asm 2: mulpd 128(<t2p=%rcx),<t8=%xmm9
mulpd 128(%rcx),%xmm9

# qhasm: r8 =t8
# asm 1: movdqa <t8=int6464#10,>r8=int6464#10
# asm 2: movdqa <t8=%xmm9,>r8=%xmm9
movdqa %xmm9,%xmm9

# qhasm: t9 = ab0
# asm 1: movdqa <ab0=int6464#1,>t9=int6464#11
# asm 2: movdqa <ab0=%xmm0,>t9=%xmm10
movdqa %xmm0,%xmm10

# qhasm: float6464 t9 *= *(int128 *)(t2p + 144)
# asm 1: mulpd 144(<t2p=int64#4),<t9=int6464#11
# asm 2: mulpd 144(<t2p=%rcx),<t9=%xmm10
mulpd 144(%rcx),%xmm10

# qhasm: r9 =t9
# asm 1: movdqa <t9=int6464#11,>r9=int6464#11
# asm 2: movdqa <t9=%xmm10,>r9=%xmm10
movdqa %xmm10,%xmm10

# qhasm: t10 = ab0
# asm 1: movdqa <ab0=int6464#1,>t10=int6464#12
# asm 2: movdqa <ab0=%xmm0,>t10=%xmm11
movdqa %xmm0,%xmm11

# qhasm: float6464 t10 *= *(int128 *)(t2p + 160)
# asm 1: mulpd 160(<t2p=int64#4),<t10=int6464#12
# asm 2: mulpd 160(<t2p=%rcx),<t10=%xmm11
mulpd 160(%rcx),%xmm11

# qhasm: r10 =t10
# asm 1: movdqa <t10=int6464#12,>r10=int6464#12
# asm 2: movdqa <t10=%xmm11,>r10=%xmm11
movdqa %xmm11,%xmm11

# qhasm: r11 = ab0
# asm 1: movdqa <ab0=int6464#1,>r11=int6464#1
# asm 2: movdqa <ab0=%xmm0,>r11=%xmm0
movdqa %xmm0,%xmm0

# qhasm: float6464 r11 *= *(int128 *)(t2p + 176)
# asm 1: mulpd 176(<t2p=int64#4),<r11=int6464#1
# asm 2: mulpd 176(<t2p=%rcx),<r11=%xmm0
mulpd 176(%rcx),%xmm0

# qhasm: *(int128 *)(rp + 0) = r0
# asm 1: movdqa <r0=int6464#2,0(<rp=int64#3)
# asm 2: movdqa <r0=%xmm1,0(<rp=%rdx)
movdqa %xmm1,0(%rdx)

# qhasm: ab1 = *(int128 *)(t1p + 16)
# asm 1: movdqa 16(<t1p=int64#2),>ab1=int6464#2
# asm 2: movdqa 16(<t1p=%rsi),>ab1=%xmm1
movdqa 16(%rsi),%xmm1

# qhasm: ab1six = ab1
# asm 1: movdqa <ab1=int6464#2,>ab1six=int6464#13
# asm 2: movdqa <ab1=%xmm1,>ab1six=%xmm12
movdqa %xmm1,%xmm12

# qhasm: float6464 ab1six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab1six=int6464#13
# asm 2: mulpd SIX_SIX,<ab1six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: t1 = ab1
# asm 1: movdqa <ab1=int6464#2,>t1=int6464#14
# asm 2: movdqa <ab1=%xmm1,>t1=%xmm13
movdqa %xmm1,%xmm13

# qhasm: float6464 t1 *= *(int128 *)(t2p + 0)
# asm 1: mulpd 0(<t2p=int64#4),<t1=int6464#14
# asm 2: mulpd 0(<t2p=%rcx),<t1=%xmm13
mulpd 0(%rcx),%xmm13

# qhasm: float6464 r1 +=t1
# asm 1: addpd <t1=int6464#14,<r1=int6464#3
# asm 2: addpd <t1=%xmm13,<r1=%xmm2
addpd %xmm13,%xmm2

# qhasm: t7 = ab1
# asm 1: movdqa <ab1=int6464#2,>t7=int6464#2
# asm 2: movdqa <ab1=%xmm1,>t7=%xmm1
movdqa %xmm1,%xmm1

# qhasm: float6464 t7 *= *(int128 *)(t2p + 96)
# asm 1: mulpd 96(<t2p=int64#4),<t7=int6464#2
# asm 2: mulpd 96(<t2p=%rcx),<t7=%xmm1
mulpd 96(%rcx),%xmm1

# qhasm: float6464 r7 +=t7
# asm 1: addpd <t7=int6464#2,<r7=int6464#9
# asm 2: addpd <t7=%xmm1,<r7=%xmm8
addpd %xmm1,%xmm8

# qhasm: t2 = ab1six
# asm 1: movdqa <ab1six=int6464#13,>t2=int6464#2
# asm 2: movdqa <ab1six=%xmm12,>t2=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 t2 *= *(int128 *)(t2p + 16)
# asm 1: mulpd 16(<t2p=int64#4),<t2=int6464#2
# asm 2: mulpd 16(<t2p=%rcx),<t2=%xmm1
mulpd 16(%rcx),%xmm1

# qhasm: float6464 r2 +=t2
# asm 1: addpd <t2=int6464#2,<r2=int6464#4
# asm 2: addpd <t2=%xmm1,<r2=%xmm3
addpd %xmm1,%xmm3

# qhasm: t3 = ab1six
# asm 1: movdqa <ab1six=int6464#13,>t3=int6464#2
# asm 2: movdqa <ab1six=%xmm12,>t3=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 t3 *= *(int128 *)(t2p + 32)
# asm 1: mulpd 32(<t2p=int64#4),<t3=int6464#2
# asm 2: mulpd 32(<t2p=%rcx),<t3=%xmm1
mulpd 32(%rcx),%xmm1

# qhasm: float6464 r3 +=t3
# asm 1: addpd <t3=int6464#2,<r3=int6464#5
# asm 2: addpd <t3=%xmm1,<r3=%xmm4
addpd %xmm1,%xmm4

# qhasm: t4 = ab1six
# asm 1: movdqa <ab1six=int6464#13,>t4=int6464#2
# asm 2: movdqa <ab1six=%xmm12,>t4=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 t4 *= *(int128 *)(t2p + 48)
# asm 1: mulpd 48(<t2p=int64#4),<t4=int6464#2
# asm 2: mulpd 48(<t2p=%rcx),<t4=%xmm1
mulpd 48(%rcx),%xmm1

# qhasm: float6464 r4 +=t4
# asm 1: addpd <t4=int6464#2,<r4=int6464#6
# asm 2: addpd <t4=%xmm1,<r4=%xmm5
addpd %xmm1,%xmm5

# qhasm: t5 = ab1six
# asm 1: movdqa <ab1six=int6464#13,>t5=int6464#2
# asm 2: movdqa <ab1six=%xmm12,>t5=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 t5 *= *(int128 *)(t2p + 64)
# asm 1: mulpd 64(<t2p=int64#4),<t5=int6464#2
# asm 2: mulpd 64(<t2p=%rcx),<t5=%xmm1
mulpd 64(%rcx),%xmm1

# qhasm: float6464 r5 +=t5
# asm 1: addpd <t5=int6464#2,<r5=int6464#7
# asm 2: addpd <t5=%xmm1,<r5=%xmm6
addpd %xmm1,%xmm6

# qhasm: t6 = ab1six
# asm 1: movdqa <ab1six=int6464#13,>t6=int6464#2
# asm 2: movdqa <ab1six=%xmm12,>t6=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 t6 *= *(int128 *)(t2p + 80)
# asm 1: mulpd 80(<t2p=int64#4),<t6=int6464#2
# asm 2: mulpd 80(<t2p=%rcx),<t6=%xmm1
mulpd 80(%rcx),%xmm1

# qhasm: float6464 r6 +=t6
# asm 1: addpd <t6=int6464#2,<r6=int6464#8
# asm 2: addpd <t6=%xmm1,<r6=%xmm7
addpd %xmm1,%xmm7

# qhasm: t8 = ab1six
# asm 1: movdqa <ab1six=int6464#13,>t8=int6464#2
# asm 2: movdqa <ab1six=%xmm12,>t8=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 t8 *= *(int128 *)(t2p + 112)
# asm 1: mulpd 112(<t2p=int64#4),<t8=int6464#2
# asm 2: mulpd 112(<t2p=%rcx),<t8=%xmm1
mulpd 112(%rcx),%xmm1

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#2,<r8=int6464#10
# asm 2: addpd <t8=%xmm1,<r8=%xmm9
addpd %xmm1,%xmm9

# qhasm: t9 = ab1six
# asm 1: movdqa <ab1six=int6464#13,>t9=int6464#2
# asm 2: movdqa <ab1six=%xmm12,>t9=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 t9 *= *(int128 *)(t2p + 128)
# asm 1: mulpd 128(<t2p=int64#4),<t9=int6464#2
# asm 2: mulpd 128(<t2p=%rcx),<t9=%xmm1
mulpd 128(%rcx),%xmm1

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#2,<r9=int6464#11
# asm 2: addpd <t9=%xmm1,<r9=%xmm10
addpd %xmm1,%xmm10

# qhasm: t10 = ab1six
# asm 1: movdqa <ab1six=int6464#13,>t10=int6464#2
# asm 2: movdqa <ab1six=%xmm12,>t10=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 t10 *= *(int128 *)(t2p + 144)
# asm 1: mulpd 144(<t2p=int64#4),<t10=int6464#2
# asm 2: mulpd 144(<t2p=%rcx),<t10=%xmm1
mulpd 144(%rcx),%xmm1

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#2,<r10=int6464#12
# asm 2: addpd <t10=%xmm1,<r10=%xmm11
addpd %xmm1,%xmm11

# qhasm: t11 = ab1six
# asm 1: movdqa <ab1six=int6464#13,>t11=int6464#2
# asm 2: movdqa <ab1six=%xmm12,>t11=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 t11 *= *(int128 *)(t2p + 160)
# asm 1: mulpd 160(<t2p=int64#4),<t11=int6464#2
# asm 2: mulpd 160(<t2p=%rcx),<t11=%xmm1
mulpd 160(%rcx),%xmm1

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#2,<r11=int6464#1
# asm 2: addpd <t11=%xmm1,<r11=%xmm0
addpd %xmm1,%xmm0

# qhasm: r12 = ab1six
# asm 1: movdqa <ab1six=int6464#13,>r12=int6464#2
# asm 2: movdqa <ab1six=%xmm12,>r12=%xmm1
movdqa %xmm12,%xmm1

# qhasm: float6464 r12 *= *(int128 *)(t2p + 176)
# asm 1: mulpd 176(<t2p=int64#4),<r12=int6464#2
# asm 2: mulpd 176(<t2p=%rcx),<r12=%xmm1
mulpd 176(%rcx),%xmm1

# qhasm: *(int128 *)(rp + 16) = r1
# asm 1: movdqa <r1=int6464#3,16(<rp=int64#3)
# asm 2: movdqa <r1=%xmm2,16(<rp=%rdx)
movdqa %xmm2,16(%rdx)

# qhasm: ab2 = *(int128 *)(t1p + 32)
# asm 1: movdqa 32(<t1p=int64#2),>ab2=int6464#3
# asm 2: movdqa 32(<t1p=%rsi),>ab2=%xmm2
movdqa 32(%rsi),%xmm2

# qhasm: ab2six = ab2
# asm 1: movdqa <ab2=int6464#3,>ab2six=int6464#13
# asm 2: movdqa <ab2=%xmm2,>ab2six=%xmm12
movdqa %xmm2,%xmm12

# qhasm: float6464 ab2six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab2six=int6464#13
# asm 2: mulpd SIX_SIX,<ab2six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: t2 = ab2
# asm 1: movdqa <ab2=int6464#3,>t2=int6464#14
# asm 2: movdqa <ab2=%xmm2,>t2=%xmm13
movdqa %xmm2,%xmm13

# qhasm: float6464 t2 *= *(int128 *)(t2p + 0)
# asm 1: mulpd 0(<t2p=int64#4),<t2=int6464#14
# asm 2: mulpd 0(<t2p=%rcx),<t2=%xmm13
mulpd 0(%rcx),%xmm13

# qhasm: float6464 r2 +=t2
# asm 1: addpd <t2=int6464#14,<r2=int6464#4
# asm 2: addpd <t2=%xmm13,<r2=%xmm3
addpd %xmm13,%xmm3

# qhasm: t7 = ab2
# asm 1: movdqa <ab2=int6464#3,>t7=int6464#14
# asm 2: movdqa <ab2=%xmm2,>t7=%xmm13
movdqa %xmm2,%xmm13

# qhasm: float6464 t7 *= *(int128 *)(t2p + 80)
# asm 1: mulpd 80(<t2p=int64#4),<t7=int6464#14
# asm 2: mulpd 80(<t2p=%rcx),<t7=%xmm13
mulpd 80(%rcx),%xmm13

# qhasm: float6464 r7 +=t7
# asm 1: addpd <t7=int6464#14,<r7=int6464#9
# asm 2: addpd <t7=%xmm13,<r7=%xmm8
addpd %xmm13,%xmm8

# qhasm: t8 = ab2
# asm 1: movdqa <ab2=int6464#3,>t8=int6464#14
# asm 2: movdqa <ab2=%xmm2,>t8=%xmm13
movdqa %xmm2,%xmm13

# qhasm: float6464 t8 *= *(int128 *)(t2p + 96)
# asm 1: mulpd 96(<t2p=int64#4),<t8=int6464#14
# asm 2: mulpd 96(<t2p=%rcx),<t8=%xmm13
mulpd 96(%rcx),%xmm13

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#14,<r8=int6464#10
# asm 2: addpd <t8=%xmm13,<r8=%xmm9
addpd %xmm13,%xmm9

# qhasm: r13 = ab2
# asm 1: movdqa <ab2=int6464#3,>r13=int6464#3
# asm 2: movdqa <ab2=%xmm2,>r13=%xmm2
movdqa %xmm2,%xmm2

# qhasm: float6464 r13 *= *(int128 *)(t2p + 176)
# asm 1: mulpd 176(<t2p=int64#4),<r13=int6464#3
# asm 2: mulpd 176(<t2p=%rcx),<r13=%xmm2
mulpd 176(%rcx),%xmm2

# qhasm: t3 = ab2six
# asm 1: movdqa <ab2six=int6464#13,>t3=int6464#14
# asm 2: movdqa <ab2six=%xmm12,>t3=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t3 *= *(int128 *)(t2p + 16)
# asm 1: mulpd 16(<t2p=int64#4),<t3=int6464#14
# asm 2: mulpd 16(<t2p=%rcx),<t3=%xmm13
mulpd 16(%rcx),%xmm13

# qhasm: float6464 r3 +=t3
# asm 1: addpd <t3=int6464#14,<r3=int6464#5
# asm 2: addpd <t3=%xmm13,<r3=%xmm4
addpd %xmm13,%xmm4

# qhasm: t4 = ab2six
# asm 1: movdqa <ab2six=int6464#13,>t4=int6464#14
# asm 2: movdqa <ab2six=%xmm12,>t4=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t4 *= *(int128 *)(t2p + 32)
# asm 1: mulpd 32(<t2p=int64#4),<t4=int6464#14
# asm 2: mulpd 32(<t2p=%rcx),<t4=%xmm13
mulpd 32(%rcx),%xmm13

# qhasm: float6464 r4 +=t4
# asm 1: addpd <t4=int6464#14,<r4=int6464#6
# asm 2: addpd <t4=%xmm13,<r4=%xmm5
addpd %xmm13,%xmm5

# qhasm: t5 = ab2six
# asm 1: movdqa <ab2six=int6464#13,>t5=int6464#14
# asm 2: movdqa <ab2six=%xmm12,>t5=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t5 *= *(int128 *)(t2p + 48)
# asm 1: mulpd 48(<t2p=int64#4),<t5=int6464#14
# asm 2: mulpd 48(<t2p=%rcx),<t5=%xmm13
mulpd 48(%rcx),%xmm13

# qhasm: float6464 r5 +=t5
# asm 1: addpd <t5=int6464#14,<r5=int6464#7
# asm 2: addpd <t5=%xmm13,<r5=%xmm6
addpd %xmm13,%xmm6

# qhasm: t6 = ab2six
# asm 1: movdqa <ab2six=int6464#13,>t6=int6464#14
# asm 2: movdqa <ab2six=%xmm12,>t6=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t6 *= *(int128 *)(t2p + 64)
# asm 1: mulpd 64(<t2p=int64#4),<t6=int6464#14
# asm 2: mulpd 64(<t2p=%rcx),<t6=%xmm13
mulpd 64(%rcx),%xmm13

# qhasm: float6464 r6 +=t6
# asm 1: addpd <t6=int6464#14,<r6=int6464#8
# asm 2: addpd <t6=%xmm13,<r6=%xmm7
addpd %xmm13,%xmm7

# qhasm: t9 = ab2six
# asm 1: movdqa <ab2six=int6464#13,>t9=int6464#14
# asm 2: movdqa <ab2six=%xmm12,>t9=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t9 *= *(int128 *)(t2p + 112)
# asm 1: mulpd 112(<t2p=int64#4),<t9=int6464#14
# asm 2: mulpd 112(<t2p=%rcx),<t9=%xmm13
mulpd 112(%rcx),%xmm13

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#14,<r9=int6464#11
# asm 2: addpd <t9=%xmm13,<r9=%xmm10
addpd %xmm13,%xmm10

# qhasm: t10 = ab2six
# asm 1: movdqa <ab2six=int6464#13,>t10=int6464#14
# asm 2: movdqa <ab2six=%xmm12,>t10=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t10 *= *(int128 *)(t2p + 128)
# asm 1: mulpd 128(<t2p=int64#4),<t10=int6464#14
# asm 2: mulpd 128(<t2p=%rcx),<t10=%xmm13
mulpd 128(%rcx),%xmm13

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#14,<r10=int6464#12
# asm 2: addpd <t10=%xmm13,<r10=%xmm11
addpd %xmm13,%xmm11

# qhasm: t11 = ab2six
# asm 1: movdqa <ab2six=int6464#13,>t11=int6464#14
# asm 2: movdqa <ab2six=%xmm12,>t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t11 *= *(int128 *)(t2p + 144)
# asm 1: mulpd 144(<t2p=int64#4),<t11=int6464#14
# asm 2: mulpd 144(<t2p=%rcx),<t11=%xmm13
mulpd 144(%rcx),%xmm13

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#14,<r11=int6464#1
# asm 2: addpd <t11=%xmm13,<r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: t12 = ab2six
# asm 1: movdqa <ab2six=int6464#13,>t12=int6464#13
# asm 2: movdqa <ab2six=%xmm12,>t12=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 t12 *= *(int128 *)(t2p + 160)
# asm 1: mulpd 160(<t2p=int64#4),<t12=int6464#13
# asm 2: mulpd 160(<t2p=%rcx),<t12=%xmm12
mulpd 160(%rcx),%xmm12

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#13,<r12=int6464#2
# asm 2: addpd <t12=%xmm12,<r12=%xmm1
addpd %xmm12,%xmm1

# qhasm: *(int128 *)(rp + 32) = r2
# asm 1: movdqa <r2=int6464#4,32(<rp=int64#3)
# asm 2: movdqa <r2=%xmm3,32(<rp=%rdx)
movdqa %xmm3,32(%rdx)

# qhasm: ab3 = *(int128 *)(t1p + 48)
# asm 1: movdqa 48(<t1p=int64#2),>ab3=int6464#4
# asm 2: movdqa 48(<t1p=%rsi),>ab3=%xmm3
movdqa 48(%rsi),%xmm3

# qhasm: ab3six = ab3
# asm 1: movdqa <ab3=int6464#4,>ab3six=int6464#13
# asm 2: movdqa <ab3=%xmm3,>ab3six=%xmm12
movdqa %xmm3,%xmm12

# qhasm: float6464 ab3six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab3six=int6464#13
# asm 2: mulpd SIX_SIX,<ab3six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: t3 = ab3
# asm 1: movdqa <ab3=int6464#4,>t3=int6464#14
# asm 2: movdqa <ab3=%xmm3,>t3=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 t3 *= *(int128 *)(t2p + 0)
# asm 1: mulpd 0(<t2p=int64#4),<t3=int6464#14
# asm 2: mulpd 0(<t2p=%rcx),<t3=%xmm13
mulpd 0(%rcx),%xmm13

# qhasm: float6464 r3 +=t3
# asm 1: addpd <t3=int6464#14,<r3=int6464#5
# asm 2: addpd <t3=%xmm13,<r3=%xmm4
addpd %xmm13,%xmm4

# qhasm: t7 = ab3
# asm 1: movdqa <ab3=int6464#4,>t7=int6464#14
# asm 2: movdqa <ab3=%xmm3,>t7=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 t7 *= *(int128 *)(t2p + 64)
# asm 1: mulpd 64(<t2p=int64#4),<t7=int6464#14
# asm 2: mulpd 64(<t2p=%rcx),<t7=%xmm13
mulpd 64(%rcx),%xmm13

# qhasm: float6464 r7 +=t7
# asm 1: addpd <t7=int6464#14,<r7=int6464#9
# asm 2: addpd <t7=%xmm13,<r7=%xmm8
addpd %xmm13,%xmm8

# qhasm: t8 = ab3
# asm 1: movdqa <ab3=int6464#4,>t8=int6464#14
# asm 2: movdqa <ab3=%xmm3,>t8=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 t8 *= *(int128 *)(t2p + 80)
# asm 1: mulpd 80(<t2p=int64#4),<t8=int6464#14
# asm 2: mulpd 80(<t2p=%rcx),<t8=%xmm13
mulpd 80(%rcx),%xmm13

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#14,<r8=int6464#10
# asm 2: addpd <t8=%xmm13,<r8=%xmm9
addpd %xmm13,%xmm9

# qhasm: t9 = ab3
# asm 1: movdqa <ab3=int6464#4,>t9=int6464#14
# asm 2: movdqa <ab3=%xmm3,>t9=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 t9 *= *(int128 *)(t2p + 96)
# asm 1: mulpd 96(<t2p=int64#4),<t9=int6464#14
# asm 2: mulpd 96(<t2p=%rcx),<t9=%xmm13
mulpd 96(%rcx),%xmm13

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#14,<r9=int6464#11
# asm 2: addpd <t9=%xmm13,<r9=%xmm10
addpd %xmm13,%xmm10

# qhasm: t13 = ab3
# asm 1: movdqa <ab3=int6464#4,>t13=int6464#14
# asm 2: movdqa <ab3=%xmm3,>t13=%xmm13
movdqa %xmm3,%xmm13

# qhasm: float6464 t13 *= *(int128 *)(t2p + 160)
# asm 1: mulpd 160(<t2p=int64#4),<t13=int6464#14
# asm 2: mulpd 160(<t2p=%rcx),<t13=%xmm13
mulpd 160(%rcx),%xmm13

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#14,<r13=int6464#3
# asm 2: addpd <t13=%xmm13,<r13=%xmm2
addpd %xmm13,%xmm2

# qhasm: r14 = ab3
# asm 1: movdqa <ab3=int6464#4,>r14=int6464#4
# asm 2: movdqa <ab3=%xmm3,>r14=%xmm3
movdqa %xmm3,%xmm3

# qhasm: float6464 r14 *= *(int128 *)(t2p + 176)
# asm 1: mulpd 176(<t2p=int64#4),<r14=int6464#4
# asm 2: mulpd 176(<t2p=%rcx),<r14=%xmm3
mulpd 176(%rcx),%xmm3

# qhasm: t4 = ab3six
# asm 1: movdqa <ab3six=int6464#13,>t4=int6464#14
# asm 2: movdqa <ab3six=%xmm12,>t4=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t4 *= *(int128 *)(t2p + 16)
# asm 1: mulpd 16(<t2p=int64#4),<t4=int6464#14
# asm 2: mulpd 16(<t2p=%rcx),<t4=%xmm13
mulpd 16(%rcx),%xmm13

# qhasm: float6464 r4 +=t4
# asm 1: addpd <t4=int6464#14,<r4=int6464#6
# asm 2: addpd <t4=%xmm13,<r4=%xmm5
addpd %xmm13,%xmm5

# qhasm: t5 = ab3six
# asm 1: movdqa <ab3six=int6464#13,>t5=int6464#14
# asm 2: movdqa <ab3six=%xmm12,>t5=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t5 *= *(int128 *)(t2p + 32)
# asm 1: mulpd 32(<t2p=int64#4),<t5=int6464#14
# asm 2: mulpd 32(<t2p=%rcx),<t5=%xmm13
mulpd 32(%rcx),%xmm13

# qhasm: float6464 r5 +=t5
# asm 1: addpd <t5=int6464#14,<r5=int6464#7
# asm 2: addpd <t5=%xmm13,<r5=%xmm6
addpd %xmm13,%xmm6

# qhasm: t6 = ab3six
# asm 1: movdqa <ab3six=int6464#13,>t6=int6464#14
# asm 2: movdqa <ab3six=%xmm12,>t6=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t6 *= *(int128 *)(t2p + 48)
# asm 1: mulpd 48(<t2p=int64#4),<t6=int6464#14
# asm 2: mulpd 48(<t2p=%rcx),<t6=%xmm13
mulpd 48(%rcx),%xmm13

# qhasm: float6464 r6 +=t6
# asm 1: addpd <t6=int6464#14,<r6=int6464#8
# asm 2: addpd <t6=%xmm13,<r6=%xmm7
addpd %xmm13,%xmm7

# qhasm: t10 = ab3six
# asm 1: movdqa <ab3six=int6464#13,>t10=int6464#14
# asm 2: movdqa <ab3six=%xmm12,>t10=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t10 *= *(int128 *)(t2p + 112)
# asm 1: mulpd 112(<t2p=int64#4),<t10=int6464#14
# asm 2: mulpd 112(<t2p=%rcx),<t10=%xmm13
mulpd 112(%rcx),%xmm13

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#14,<r10=int6464#12
# asm 2: addpd <t10=%xmm13,<r10=%xmm11
addpd %xmm13,%xmm11

# qhasm: t11 = ab3six
# asm 1: movdqa <ab3six=int6464#13,>t11=int6464#14
# asm 2: movdqa <ab3six=%xmm12,>t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t11 *= *(int128 *)(t2p + 128)
# asm 1: mulpd 128(<t2p=int64#4),<t11=int6464#14
# asm 2: mulpd 128(<t2p=%rcx),<t11=%xmm13
mulpd 128(%rcx),%xmm13

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#14,<r11=int6464#1
# asm 2: addpd <t11=%xmm13,<r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: t12 = ab3six
# asm 1: movdqa <ab3six=int6464#13,>t12=int6464#13
# asm 2: movdqa <ab3six=%xmm12,>t12=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 t12 *= *(int128 *)(t2p + 144)
# asm 1: mulpd 144(<t2p=int64#4),<t12=int6464#13
# asm 2: mulpd 144(<t2p=%rcx),<t12=%xmm12
mulpd 144(%rcx),%xmm12

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#13,<r12=int6464#2
# asm 2: addpd <t12=%xmm12,<r12=%xmm1
addpd %xmm12,%xmm1

# qhasm: *(int128 *)(rp + 48) = r3
# asm 1: movdqa <r3=int6464#5,48(<rp=int64#3)
# asm 2: movdqa <r3=%xmm4,48(<rp=%rdx)
movdqa %xmm4,48(%rdx)

# qhasm: ab4 = *(int128 *)(t1p + 64)
# asm 1: movdqa 64(<t1p=int64#2),>ab4=int6464#5
# asm 2: movdqa 64(<t1p=%rsi),>ab4=%xmm4
movdqa 64(%rsi),%xmm4

# qhasm: ab4six = ab4
# asm 1: movdqa <ab4=int6464#5,>ab4six=int6464#13
# asm 2: movdqa <ab4=%xmm4,>ab4six=%xmm12
movdqa %xmm4,%xmm12

# qhasm: float6464 ab4six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab4six=int6464#13
# asm 2: mulpd SIX_SIX,<ab4six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: t4 = ab4
# asm 1: movdqa <ab4=int6464#5,>t4=int6464#14
# asm 2: movdqa <ab4=%xmm4,>t4=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 t4 *= *(int128 *)(t2p + 0)
# asm 1: mulpd 0(<t2p=int64#4),<t4=int6464#14
# asm 2: mulpd 0(<t2p=%rcx),<t4=%xmm13
mulpd 0(%rcx),%xmm13

# qhasm: float6464 r4 +=t4
# asm 1: addpd <t4=int6464#14,<r4=int6464#6
# asm 2: addpd <t4=%xmm13,<r4=%xmm5
addpd %xmm13,%xmm5

# qhasm: t7 = ab4
# asm 1: movdqa <ab4=int6464#5,>t7=int6464#14
# asm 2: movdqa <ab4=%xmm4,>t7=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 t7 *= *(int128 *)(t2p + 48)
# asm 1: mulpd 48(<t2p=int64#4),<t7=int6464#14
# asm 2: mulpd 48(<t2p=%rcx),<t7=%xmm13
mulpd 48(%rcx),%xmm13

# qhasm: float6464 r7 +=t7
# asm 1: addpd <t7=int6464#14,<r7=int6464#9
# asm 2: addpd <t7=%xmm13,<r7=%xmm8
addpd %xmm13,%xmm8

# qhasm: t8 = ab4
# asm 1: movdqa <ab4=int6464#5,>t8=int6464#14
# asm 2: movdqa <ab4=%xmm4,>t8=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 t8 *= *(int128 *)(t2p + 64)
# asm 1: mulpd 64(<t2p=int64#4),<t8=int6464#14
# asm 2: mulpd 64(<t2p=%rcx),<t8=%xmm13
mulpd 64(%rcx),%xmm13

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#14,<r8=int6464#10
# asm 2: addpd <t8=%xmm13,<r8=%xmm9
addpd %xmm13,%xmm9

# qhasm: t9 = ab4
# asm 1: movdqa <ab4=int6464#5,>t9=int6464#14
# asm 2: movdqa <ab4=%xmm4,>t9=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 t9 *= *(int128 *)(t2p + 80)
# asm 1: mulpd 80(<t2p=int64#4),<t9=int6464#14
# asm 2: mulpd 80(<t2p=%rcx),<t9=%xmm13
mulpd 80(%rcx),%xmm13

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#14,<r9=int6464#11
# asm 2: addpd <t9=%xmm13,<r9=%xmm10
addpd %xmm13,%xmm10

# qhasm: t10 = ab4
# asm 1: movdqa <ab4=int6464#5,>t10=int6464#14
# asm 2: movdqa <ab4=%xmm4,>t10=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 t10 *= *(int128 *)(t2p + 96)
# asm 1: mulpd 96(<t2p=int64#4),<t10=int6464#14
# asm 2: mulpd 96(<t2p=%rcx),<t10=%xmm13
mulpd 96(%rcx),%xmm13

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#14,<r10=int6464#12
# asm 2: addpd <t10=%xmm13,<r10=%xmm11
addpd %xmm13,%xmm11

# qhasm: t13 = ab4
# asm 1: movdqa <ab4=int6464#5,>t13=int6464#14
# asm 2: movdqa <ab4=%xmm4,>t13=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 t13 *= *(int128 *)(t2p + 144)
# asm 1: mulpd 144(<t2p=int64#4),<t13=int6464#14
# asm 2: mulpd 144(<t2p=%rcx),<t13=%xmm13
mulpd 144(%rcx),%xmm13

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#14,<r13=int6464#3
# asm 2: addpd <t13=%xmm13,<r13=%xmm2
addpd %xmm13,%xmm2

# qhasm: t14 = ab4
# asm 1: movdqa <ab4=int6464#5,>t14=int6464#14
# asm 2: movdqa <ab4=%xmm4,>t14=%xmm13
movdqa %xmm4,%xmm13

# qhasm: float6464 t14 *= *(int128 *)(t2p + 160)
# asm 1: mulpd 160(<t2p=int64#4),<t14=int6464#14
# asm 2: mulpd 160(<t2p=%rcx),<t14=%xmm13
mulpd 160(%rcx),%xmm13

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#14,<r14=int6464#4
# asm 2: addpd <t14=%xmm13,<r14=%xmm3
addpd %xmm13,%xmm3

# qhasm: r15 = ab4
# asm 1: movdqa <ab4=int6464#5,>r15=int6464#5
# asm 2: movdqa <ab4=%xmm4,>r15=%xmm4
movdqa %xmm4,%xmm4

# qhasm: float6464 r15 *= *(int128 *)(t2p + 176)
# asm 1: mulpd 176(<t2p=int64#4),<r15=int6464#5
# asm 2: mulpd 176(<t2p=%rcx),<r15=%xmm4
mulpd 176(%rcx),%xmm4

# qhasm: t5 = ab4six
# asm 1: movdqa <ab4six=int6464#13,>t5=int6464#14
# asm 2: movdqa <ab4six=%xmm12,>t5=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t5 *= *(int128 *)(t2p + 16)
# asm 1: mulpd 16(<t2p=int64#4),<t5=int6464#14
# asm 2: mulpd 16(<t2p=%rcx),<t5=%xmm13
mulpd 16(%rcx),%xmm13

# qhasm: float6464 r5 +=t5
# asm 1: addpd <t5=int6464#14,<r5=int6464#7
# asm 2: addpd <t5=%xmm13,<r5=%xmm6
addpd %xmm13,%xmm6

# qhasm: t6 = ab4six
# asm 1: movdqa <ab4six=int6464#13,>t6=int6464#14
# asm 2: movdqa <ab4six=%xmm12,>t6=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t6 *= *(int128 *)(t2p + 32)
# asm 1: mulpd 32(<t2p=int64#4),<t6=int6464#14
# asm 2: mulpd 32(<t2p=%rcx),<t6=%xmm13
mulpd 32(%rcx),%xmm13

# qhasm: float6464 r6 +=t6
# asm 1: addpd <t6=int6464#14,<r6=int6464#8
# asm 2: addpd <t6=%xmm13,<r6=%xmm7
addpd %xmm13,%xmm7

# qhasm: t11 = ab4six
# asm 1: movdqa <ab4six=int6464#13,>t11=int6464#14
# asm 2: movdqa <ab4six=%xmm12,>t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t11 *= *(int128 *)(t2p + 112)
# asm 1: mulpd 112(<t2p=int64#4),<t11=int6464#14
# asm 2: mulpd 112(<t2p=%rcx),<t11=%xmm13
mulpd 112(%rcx),%xmm13

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#14,<r11=int6464#1
# asm 2: addpd <t11=%xmm13,<r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: t12 = ab4six
# asm 1: movdqa <ab4six=int6464#13,>t12=int6464#13
# asm 2: movdqa <ab4six=%xmm12,>t12=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 t12 *= *(int128 *)(t2p + 128)
# asm 1: mulpd 128(<t2p=int64#4),<t12=int6464#13
# asm 2: mulpd 128(<t2p=%rcx),<t12=%xmm12
mulpd 128(%rcx),%xmm12

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#13,<r12=int6464#2
# asm 2: addpd <t12=%xmm12,<r12=%xmm1
addpd %xmm12,%xmm1

# qhasm: *(int128 *)(rp + 64) = r4
# asm 1: movdqa <r4=int6464#6,64(<rp=int64#3)
# asm 2: movdqa <r4=%xmm5,64(<rp=%rdx)
movdqa %xmm5,64(%rdx)

# qhasm: ab5 = *(int128 *)(t1p + 80)
# asm 1: movdqa 80(<t1p=int64#2),>ab5=int6464#6
# asm 2: movdqa 80(<t1p=%rsi),>ab5=%xmm5
movdqa 80(%rsi),%xmm5

# qhasm: ab5six = ab5
# asm 1: movdqa <ab5=int6464#6,>ab5six=int6464#13
# asm 2: movdqa <ab5=%xmm5,>ab5six=%xmm12
movdqa %xmm5,%xmm12

# qhasm: float6464 ab5six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab5six=int6464#13
# asm 2: mulpd SIX_SIX,<ab5six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: t5 = ab5
# asm 1: movdqa <ab5=int6464#6,>t5=int6464#14
# asm 2: movdqa <ab5=%xmm5,>t5=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 t5 *= *(int128 *)(t2p + 0)
# asm 1: mulpd 0(<t2p=int64#4),<t5=int6464#14
# asm 2: mulpd 0(<t2p=%rcx),<t5=%xmm13
mulpd 0(%rcx),%xmm13

# qhasm: float6464 r5 +=t5
# asm 1: addpd <t5=int6464#14,<r5=int6464#7
# asm 2: addpd <t5=%xmm13,<r5=%xmm6
addpd %xmm13,%xmm6

# qhasm: t7 = ab5
# asm 1: movdqa <ab5=int6464#6,>t7=int6464#14
# asm 2: movdqa <ab5=%xmm5,>t7=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 t7 *= *(int128 *)(t2p + 32)
# asm 1: mulpd 32(<t2p=int64#4),<t7=int6464#14
# asm 2: mulpd 32(<t2p=%rcx),<t7=%xmm13
mulpd 32(%rcx),%xmm13

# qhasm: float6464 r7 +=t7
# asm 1: addpd <t7=int6464#14,<r7=int6464#9
# asm 2: addpd <t7=%xmm13,<r7=%xmm8
addpd %xmm13,%xmm8

# qhasm: t8 = ab5
# asm 1: movdqa <ab5=int6464#6,>t8=int6464#14
# asm 2: movdqa <ab5=%xmm5,>t8=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 t8 *= *(int128 *)(t2p + 48)
# asm 1: mulpd 48(<t2p=int64#4),<t8=int6464#14
# asm 2: mulpd 48(<t2p=%rcx),<t8=%xmm13
mulpd 48(%rcx),%xmm13

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#14,<r8=int6464#10
# asm 2: addpd <t8=%xmm13,<r8=%xmm9
addpd %xmm13,%xmm9

# qhasm: t9 = ab5
# asm 1: movdqa <ab5=int6464#6,>t9=int6464#14
# asm 2: movdqa <ab5=%xmm5,>t9=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 t9 *= *(int128 *)(t2p + 64)
# asm 1: mulpd 64(<t2p=int64#4),<t9=int6464#14
# asm 2: mulpd 64(<t2p=%rcx),<t9=%xmm13
mulpd 64(%rcx),%xmm13

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#14,<r9=int6464#11
# asm 2: addpd <t9=%xmm13,<r9=%xmm10
addpd %xmm13,%xmm10

# qhasm: t10 = ab5
# asm 1: movdqa <ab5=int6464#6,>t10=int6464#14
# asm 2: movdqa <ab5=%xmm5,>t10=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 t10 *= *(int128 *)(t2p + 80)
# asm 1: mulpd 80(<t2p=int64#4),<t10=int6464#14
# asm 2: mulpd 80(<t2p=%rcx),<t10=%xmm13
mulpd 80(%rcx),%xmm13

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#14,<r10=int6464#12
# asm 2: addpd <t10=%xmm13,<r10=%xmm11
addpd %xmm13,%xmm11

# qhasm: t11 = ab5
# asm 1: movdqa <ab5=int6464#6,>t11=int6464#14
# asm 2: movdqa <ab5=%xmm5,>t11=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 t11 *= *(int128 *)(t2p + 96)
# asm 1: mulpd 96(<t2p=int64#4),<t11=int6464#14
# asm 2: mulpd 96(<t2p=%rcx),<t11=%xmm13
mulpd 96(%rcx),%xmm13

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#14,<r11=int6464#1
# asm 2: addpd <t11=%xmm13,<r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: t13 = ab5
# asm 1: movdqa <ab5=int6464#6,>t13=int6464#14
# asm 2: movdqa <ab5=%xmm5,>t13=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 t13 *= *(int128 *)(t2p + 128)
# asm 1: mulpd 128(<t2p=int64#4),<t13=int6464#14
# asm 2: mulpd 128(<t2p=%rcx),<t13=%xmm13
mulpd 128(%rcx),%xmm13

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#14,<r13=int6464#3
# asm 2: addpd <t13=%xmm13,<r13=%xmm2
addpd %xmm13,%xmm2

# qhasm: t14 = ab5
# asm 1: movdqa <ab5=int6464#6,>t14=int6464#14
# asm 2: movdqa <ab5=%xmm5,>t14=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 t14 *= *(int128 *)(t2p + 144)
# asm 1: mulpd 144(<t2p=int64#4),<t14=int6464#14
# asm 2: mulpd 144(<t2p=%rcx),<t14=%xmm13
mulpd 144(%rcx),%xmm13

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#14,<r14=int6464#4
# asm 2: addpd <t14=%xmm13,<r14=%xmm3
addpd %xmm13,%xmm3

# qhasm: t15 = ab5
# asm 1: movdqa <ab5=int6464#6,>t15=int6464#14
# asm 2: movdqa <ab5=%xmm5,>t15=%xmm13
movdqa %xmm5,%xmm13

# qhasm: float6464 t15 *= *(int128 *)(t2p + 160)
# asm 1: mulpd 160(<t2p=int64#4),<t15=int6464#14
# asm 2: mulpd 160(<t2p=%rcx),<t15=%xmm13
mulpd 160(%rcx),%xmm13

# qhasm: float6464 r15 +=t15
# asm 1: addpd <t15=int6464#14,<r15=int6464#5
# asm 2: addpd <t15=%xmm13,<r15=%xmm4
addpd %xmm13,%xmm4

# qhasm: r16 = ab5
# asm 1: movdqa <ab5=int6464#6,>r16=int6464#6
# asm 2: movdqa <ab5=%xmm5,>r16=%xmm5
movdqa %xmm5,%xmm5

# qhasm: float6464 r16 *= *(int128 *)(t2p + 176)
# asm 1: mulpd 176(<t2p=int64#4),<r16=int6464#6
# asm 2: mulpd 176(<t2p=%rcx),<r16=%xmm5
mulpd 176(%rcx),%xmm5

# qhasm: t6 = ab5six
# asm 1: movdqa <ab5six=int6464#13,>t6=int6464#14
# asm 2: movdqa <ab5six=%xmm12,>t6=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t6 *= *(int128 *)(t2p + 16)
# asm 1: mulpd 16(<t2p=int64#4),<t6=int6464#14
# asm 2: mulpd 16(<t2p=%rcx),<t6=%xmm13
mulpd 16(%rcx),%xmm13

# qhasm: float6464 r6 +=t6
# asm 1: addpd <t6=int6464#14,<r6=int6464#8
# asm 2: addpd <t6=%xmm13,<r6=%xmm7
addpd %xmm13,%xmm7

# qhasm: t12 = ab5six
# asm 1: movdqa <ab5six=int6464#13,>t12=int6464#13
# asm 2: movdqa <ab5six=%xmm12,>t12=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 t12 *= *(int128 *)(t2p + 112)
# asm 1: mulpd 112(<t2p=int64#4),<t12=int6464#13
# asm 2: mulpd 112(<t2p=%rcx),<t12=%xmm12
mulpd 112(%rcx),%xmm12

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#13,<r12=int6464#2
# asm 2: addpd <t12=%xmm12,<r12=%xmm1
addpd %xmm12,%xmm1

# qhasm: *(int128 *)(rp + 80) = r5
# asm 1: movdqa <r5=int6464#7,80(<rp=int64#3)
# asm 2: movdqa <r5=%xmm6,80(<rp=%rdx)
movdqa %xmm6,80(%rdx)

# qhasm: ab6 = *(int128 *)(t1p + 96)
# asm 1: movdqa 96(<t1p=int64#2),>ab6=int6464#7
# asm 2: movdqa 96(<t1p=%rsi),>ab6=%xmm6
movdqa 96(%rsi),%xmm6

# qhasm: t6 = ab6
# asm 1: movdqa <ab6=int6464#7,>t6=int6464#13
# asm 2: movdqa <ab6=%xmm6,>t6=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 t6 *= *(int128 *)(t2p + 0)
# asm 1: mulpd 0(<t2p=int64#4),<t6=int6464#13
# asm 2: mulpd 0(<t2p=%rcx),<t6=%xmm12
mulpd 0(%rcx),%xmm12

# qhasm: float6464 r6 +=t6
# asm 1: addpd <t6=int6464#13,<r6=int6464#8
# asm 2: addpd <t6=%xmm12,<r6=%xmm7
addpd %xmm12,%xmm7

# qhasm: t7 = ab6
# asm 1: movdqa <ab6=int6464#7,>t7=int6464#13
# asm 2: movdqa <ab6=%xmm6,>t7=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 t7 *= *(int128 *)(t2p + 16)
# asm 1: mulpd 16(<t2p=int64#4),<t7=int6464#13
# asm 2: mulpd 16(<t2p=%rcx),<t7=%xmm12
mulpd 16(%rcx),%xmm12

# qhasm: float6464 r7 +=t7
# asm 1: addpd <t7=int6464#13,<r7=int6464#9
# asm 2: addpd <t7=%xmm12,<r7=%xmm8
addpd %xmm12,%xmm8

# qhasm: t8 = ab6
# asm 1: movdqa <ab6=int6464#7,>t8=int6464#13
# asm 2: movdqa <ab6=%xmm6,>t8=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 t8 *= *(int128 *)(t2p + 32)
# asm 1: mulpd 32(<t2p=int64#4),<t8=int6464#13
# asm 2: mulpd 32(<t2p=%rcx),<t8=%xmm12
mulpd 32(%rcx),%xmm12

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#13,<r8=int6464#10
# asm 2: addpd <t8=%xmm12,<r8=%xmm9
addpd %xmm12,%xmm9

# qhasm: t9 = ab6
# asm 1: movdqa <ab6=int6464#7,>t9=int6464#13
# asm 2: movdqa <ab6=%xmm6,>t9=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 t9 *= *(int128 *)(t2p + 48)
# asm 1: mulpd 48(<t2p=int64#4),<t9=int6464#13
# asm 2: mulpd 48(<t2p=%rcx),<t9=%xmm12
mulpd 48(%rcx),%xmm12

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#13,<r9=int6464#11
# asm 2: addpd <t9=%xmm12,<r9=%xmm10
addpd %xmm12,%xmm10

# qhasm: t10 = ab6
# asm 1: movdqa <ab6=int6464#7,>t10=int6464#13
# asm 2: movdqa <ab6=%xmm6,>t10=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 t10 *= *(int128 *)(t2p + 64)
# asm 1: mulpd 64(<t2p=int64#4),<t10=int6464#13
# asm 2: mulpd 64(<t2p=%rcx),<t10=%xmm12
mulpd 64(%rcx),%xmm12

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#13,<r10=int6464#12
# asm 2: addpd <t10=%xmm12,<r10=%xmm11
addpd %xmm12,%xmm11

# qhasm: t11 = ab6
# asm 1: movdqa <ab6=int6464#7,>t11=int6464#13
# asm 2: movdqa <ab6=%xmm6,>t11=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 t11 *= *(int128 *)(t2p + 80)
# asm 1: mulpd 80(<t2p=int64#4),<t11=int6464#13
# asm 2: mulpd 80(<t2p=%rcx),<t11=%xmm12
mulpd 80(%rcx),%xmm12

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#13,<r11=int6464#1
# asm 2: addpd <t11=%xmm12,<r11=%xmm0
addpd %xmm12,%xmm0

# qhasm: t12 = ab6
# asm 1: movdqa <ab6=int6464#7,>t12=int6464#13
# asm 2: movdqa <ab6=%xmm6,>t12=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 t12 *= *(int128 *)(t2p + 96)
# asm 1: mulpd 96(<t2p=int64#4),<t12=int6464#13
# asm 2: mulpd 96(<t2p=%rcx),<t12=%xmm12
mulpd 96(%rcx),%xmm12

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#13,<r12=int6464#2
# asm 2: addpd <t12=%xmm12,<r12=%xmm1
addpd %xmm12,%xmm1

# qhasm: t13 = ab6
# asm 1: movdqa <ab6=int6464#7,>t13=int6464#13
# asm 2: movdqa <ab6=%xmm6,>t13=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 t13 *= *(int128 *)(t2p + 112)
# asm 1: mulpd 112(<t2p=int64#4),<t13=int6464#13
# asm 2: mulpd 112(<t2p=%rcx),<t13=%xmm12
mulpd 112(%rcx),%xmm12

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#13,<r13=int6464#3
# asm 2: addpd <t13=%xmm12,<r13=%xmm2
addpd %xmm12,%xmm2

# qhasm: t14 = ab6
# asm 1: movdqa <ab6=int6464#7,>t14=int6464#13
# asm 2: movdqa <ab6=%xmm6,>t14=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 t14 *= *(int128 *)(t2p + 128)
# asm 1: mulpd 128(<t2p=int64#4),<t14=int6464#13
# asm 2: mulpd 128(<t2p=%rcx),<t14=%xmm12
mulpd 128(%rcx),%xmm12

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#13,<r14=int6464#4
# asm 2: addpd <t14=%xmm12,<r14=%xmm3
addpd %xmm12,%xmm3

# qhasm: t15 = ab6
# asm 1: movdqa <ab6=int6464#7,>t15=int6464#13
# asm 2: movdqa <ab6=%xmm6,>t15=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 t15 *= *(int128 *)(t2p + 144)
# asm 1: mulpd 144(<t2p=int64#4),<t15=int6464#13
# asm 2: mulpd 144(<t2p=%rcx),<t15=%xmm12
mulpd 144(%rcx),%xmm12

# qhasm: float6464 r15 +=t15
# asm 1: addpd <t15=int6464#13,<r15=int6464#5
# asm 2: addpd <t15=%xmm12,<r15=%xmm4
addpd %xmm12,%xmm4

# qhasm: t16 = ab6
# asm 1: movdqa <ab6=int6464#7,>t16=int6464#13
# asm 2: movdqa <ab6=%xmm6,>t16=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 t16 *= *(int128 *)(t2p + 160)
# asm 1: mulpd 160(<t2p=int64#4),<t16=int6464#13
# asm 2: mulpd 160(<t2p=%rcx),<t16=%xmm12
mulpd 160(%rcx),%xmm12

# qhasm: float6464 r16 +=t16
# asm 1: addpd <t16=int6464#13,<r16=int6464#6
# asm 2: addpd <t16=%xmm12,<r16=%xmm5
addpd %xmm12,%xmm5

# qhasm: r17 = ab6
# asm 1: movdqa <ab6=int6464#7,>r17=int6464#7
# asm 2: movdqa <ab6=%xmm6,>r17=%xmm6
movdqa %xmm6,%xmm6

# qhasm: float6464 r17 *= *(int128 *)(t2p + 176)
# asm 1: mulpd 176(<t2p=int64#4),<r17=int6464#7
# asm 2: mulpd 176(<t2p=%rcx),<r17=%xmm6
mulpd 176(%rcx),%xmm6

# qhasm: *(int128 *)(rp + 96) = r6
# asm 1: movdqa <r6=int6464#8,96(<rp=int64#3)
# asm 2: movdqa <r6=%xmm7,96(<rp=%rdx)
movdqa %xmm7,96(%rdx)

# qhasm: ab7 = *(int128 *)(t1p + 112)
# asm 1: movdqa 112(<t1p=int64#2),>ab7=int6464#8
# asm 2: movdqa 112(<t1p=%rsi),>ab7=%xmm7
movdqa 112(%rsi),%xmm7

# qhasm: ab7six = ab7
# asm 1: movdqa <ab7=int6464#8,>ab7six=int6464#13
# asm 2: movdqa <ab7=%xmm7,>ab7six=%xmm12
movdqa %xmm7,%xmm12

# qhasm: float6464 ab7six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab7six=int6464#13
# asm 2: mulpd SIX_SIX,<ab7six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: t7 = ab7
# asm 1: movdqa <ab7=int6464#8,>t7=int6464#14
# asm 2: movdqa <ab7=%xmm7,>t7=%xmm13
movdqa %xmm7,%xmm13

# qhasm: float6464 t7 *= *(int128 *)(t2p + 0)
# asm 1: mulpd 0(<t2p=int64#4),<t7=int6464#14
# asm 2: mulpd 0(<t2p=%rcx),<t7=%xmm13
mulpd 0(%rcx),%xmm13

# qhasm: float6464 r7 +=t7
# asm 1: addpd <t7=int6464#14,<r7=int6464#9
# asm 2: addpd <t7=%xmm13,<r7=%xmm8
addpd %xmm13,%xmm8

# qhasm: t13 = ab7
# asm 1: movdqa <ab7=int6464#8,>t13=int6464#8
# asm 2: movdqa <ab7=%xmm7,>t13=%xmm7
movdqa %xmm7,%xmm7

# qhasm: float6464 t13 *= *(int128 *)(t2p + 96)
# asm 1: mulpd 96(<t2p=int64#4),<t13=int6464#8
# asm 2: mulpd 96(<t2p=%rcx),<t13=%xmm7
mulpd 96(%rcx),%xmm7

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#8,<r13=int6464#3
# asm 2: addpd <t13=%xmm7,<r13=%xmm2
addpd %xmm7,%xmm2

# qhasm: t8 = ab7six
# asm 1: movdqa <ab7six=int6464#13,>t8=int6464#8
# asm 2: movdqa <ab7six=%xmm12,>t8=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 t8 *= *(int128 *)(t2p + 16)
# asm 1: mulpd 16(<t2p=int64#4),<t8=int6464#8
# asm 2: mulpd 16(<t2p=%rcx),<t8=%xmm7
mulpd 16(%rcx),%xmm7

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#8,<r8=int6464#10
# asm 2: addpd <t8=%xmm7,<r8=%xmm9
addpd %xmm7,%xmm9

# qhasm: t9 = ab7six
# asm 1: movdqa <ab7six=int6464#13,>t9=int6464#8
# asm 2: movdqa <ab7six=%xmm12,>t9=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 t9 *= *(int128 *)(t2p + 32)
# asm 1: mulpd 32(<t2p=int64#4),<t9=int6464#8
# asm 2: mulpd 32(<t2p=%rcx),<t9=%xmm7
mulpd 32(%rcx),%xmm7

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#8,<r9=int6464#11
# asm 2: addpd <t9=%xmm7,<r9=%xmm10
addpd %xmm7,%xmm10

# qhasm: t10 = ab7six
# asm 1: movdqa <ab7six=int6464#13,>t10=int6464#8
# asm 2: movdqa <ab7six=%xmm12,>t10=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 t10 *= *(int128 *)(t2p + 48)
# asm 1: mulpd 48(<t2p=int64#4),<t10=int6464#8
# asm 2: mulpd 48(<t2p=%rcx),<t10=%xmm7
mulpd 48(%rcx),%xmm7

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#8,<r10=int6464#12
# asm 2: addpd <t10=%xmm7,<r10=%xmm11
addpd %xmm7,%xmm11

# qhasm: t11 = ab7six
# asm 1: movdqa <ab7six=int6464#13,>t11=int6464#8
# asm 2: movdqa <ab7six=%xmm12,>t11=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 t11 *= *(int128 *)(t2p + 64)
# asm 1: mulpd 64(<t2p=int64#4),<t11=int6464#8
# asm 2: mulpd 64(<t2p=%rcx),<t11=%xmm7
mulpd 64(%rcx),%xmm7

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#8,<r11=int6464#1
# asm 2: addpd <t11=%xmm7,<r11=%xmm0
addpd %xmm7,%xmm0

# qhasm: t12 = ab7six
# asm 1: movdqa <ab7six=int6464#13,>t12=int6464#8
# asm 2: movdqa <ab7six=%xmm12,>t12=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 t12 *= *(int128 *)(t2p + 80)
# asm 1: mulpd 80(<t2p=int64#4),<t12=int6464#8
# asm 2: mulpd 80(<t2p=%rcx),<t12=%xmm7
mulpd 80(%rcx),%xmm7

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#8,<r12=int6464#2
# asm 2: addpd <t12=%xmm7,<r12=%xmm1
addpd %xmm7,%xmm1

# qhasm: t14 = ab7six
# asm 1: movdqa <ab7six=int6464#13,>t14=int6464#8
# asm 2: movdqa <ab7six=%xmm12,>t14=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 t14 *= *(int128 *)(t2p + 112)
# asm 1: mulpd 112(<t2p=int64#4),<t14=int6464#8
# asm 2: mulpd 112(<t2p=%rcx),<t14=%xmm7
mulpd 112(%rcx),%xmm7

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#8,<r14=int6464#4
# asm 2: addpd <t14=%xmm7,<r14=%xmm3
addpd %xmm7,%xmm3

# qhasm: t15 = ab7six
# asm 1: movdqa <ab7six=int6464#13,>t15=int6464#8
# asm 2: movdqa <ab7six=%xmm12,>t15=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 t15 *= *(int128 *)(t2p + 128)
# asm 1: mulpd 128(<t2p=int64#4),<t15=int6464#8
# asm 2: mulpd 128(<t2p=%rcx),<t15=%xmm7
mulpd 128(%rcx),%xmm7

# qhasm: float6464 r15 +=t15
# asm 1: addpd <t15=int6464#8,<r15=int6464#5
# asm 2: addpd <t15=%xmm7,<r15=%xmm4
addpd %xmm7,%xmm4

# qhasm: t16 = ab7six
# asm 1: movdqa <ab7six=int6464#13,>t16=int6464#8
# asm 2: movdqa <ab7six=%xmm12,>t16=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 t16 *= *(int128 *)(t2p + 144)
# asm 1: mulpd 144(<t2p=int64#4),<t16=int6464#8
# asm 2: mulpd 144(<t2p=%rcx),<t16=%xmm7
mulpd 144(%rcx),%xmm7

# qhasm: float6464 r16 +=t16
# asm 1: addpd <t16=int6464#8,<r16=int6464#6
# asm 2: addpd <t16=%xmm7,<r16=%xmm5
addpd %xmm7,%xmm5

# qhasm: t17 = ab7six
# asm 1: movdqa <ab7six=int6464#13,>t17=int6464#8
# asm 2: movdqa <ab7six=%xmm12,>t17=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 t17 *= *(int128 *)(t2p + 160)
# asm 1: mulpd 160(<t2p=int64#4),<t17=int6464#8
# asm 2: mulpd 160(<t2p=%rcx),<t17=%xmm7
mulpd 160(%rcx),%xmm7

# qhasm: float6464 r17 +=t17
# asm 1: addpd <t17=int6464#8,<r17=int6464#7
# asm 2: addpd <t17=%xmm7,<r17=%xmm6
addpd %xmm7,%xmm6

# qhasm: r18 = ab7six
# asm 1: movdqa <ab7six=int6464#13,>r18=int6464#8
# asm 2: movdqa <ab7six=%xmm12,>r18=%xmm7
movdqa %xmm12,%xmm7

# qhasm: float6464 r18 *= *(int128 *)(t2p + 176)
# asm 1: mulpd 176(<t2p=int64#4),<r18=int6464#8
# asm 2: mulpd 176(<t2p=%rcx),<r18=%xmm7
mulpd 176(%rcx),%xmm7

# qhasm: *(int128 *)(rp + 112) = r7
# asm 1: movdqa <r7=int6464#9,112(<rp=int64#3)
# asm 2: movdqa <r7=%xmm8,112(<rp=%rdx)
movdqa %xmm8,112(%rdx)

# qhasm: ab8 = *(int128 *)(t1p + 128)
# asm 1: movdqa 128(<t1p=int64#2),>ab8=int6464#9
# asm 2: movdqa 128(<t1p=%rsi),>ab8=%xmm8
movdqa 128(%rsi),%xmm8

# qhasm: ab8six = ab8
# asm 1: movdqa <ab8=int6464#9,>ab8six=int6464#13
# asm 2: movdqa <ab8=%xmm8,>ab8six=%xmm12
movdqa %xmm8,%xmm12

# qhasm: float6464 ab8six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab8six=int6464#13
# asm 2: mulpd SIX_SIX,<ab8six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: t8 = ab8
# asm 1: movdqa <ab8=int6464#9,>t8=int6464#14
# asm 2: movdqa <ab8=%xmm8,>t8=%xmm13
movdqa %xmm8,%xmm13

# qhasm: float6464 t8 *= *(int128 *)(t2p + 0)
# asm 1: mulpd 0(<t2p=int64#4),<t8=int6464#14
# asm 2: mulpd 0(<t2p=%rcx),<t8=%xmm13
mulpd 0(%rcx),%xmm13

# qhasm: float6464 r8 +=t8
# asm 1: addpd <t8=int6464#14,<r8=int6464#10
# asm 2: addpd <t8=%xmm13,<r8=%xmm9
addpd %xmm13,%xmm9

# qhasm: t13 = ab8
# asm 1: movdqa <ab8=int6464#9,>t13=int6464#14
# asm 2: movdqa <ab8=%xmm8,>t13=%xmm13
movdqa %xmm8,%xmm13

# qhasm: float6464 t13 *= *(int128 *)(t2p + 80)
# asm 1: mulpd 80(<t2p=int64#4),<t13=int6464#14
# asm 2: mulpd 80(<t2p=%rcx),<t13=%xmm13
mulpd 80(%rcx),%xmm13

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#14,<r13=int6464#3
# asm 2: addpd <t13=%xmm13,<r13=%xmm2
addpd %xmm13,%xmm2

# qhasm: t14 = ab8
# asm 1: movdqa <ab8=int6464#9,>t14=int6464#14
# asm 2: movdqa <ab8=%xmm8,>t14=%xmm13
movdqa %xmm8,%xmm13

# qhasm: float6464 t14 *= *(int128 *)(t2p + 96)
# asm 1: mulpd 96(<t2p=int64#4),<t14=int6464#14
# asm 2: mulpd 96(<t2p=%rcx),<t14=%xmm13
mulpd 96(%rcx),%xmm13

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#14,<r14=int6464#4
# asm 2: addpd <t14=%xmm13,<r14=%xmm3
addpd %xmm13,%xmm3

# qhasm: r19 = ab8
# asm 1: movdqa <ab8=int6464#9,>r19=int6464#9
# asm 2: movdqa <ab8=%xmm8,>r19=%xmm8
movdqa %xmm8,%xmm8

# qhasm: float6464 r19 *= *(int128 *)(t2p + 176)
# asm 1: mulpd 176(<t2p=int64#4),<r19=int6464#9
# asm 2: mulpd 176(<t2p=%rcx),<r19=%xmm8
mulpd 176(%rcx),%xmm8

# qhasm: t9 = ab8six
# asm 1: movdqa <ab8six=int6464#13,>t9=int6464#14
# asm 2: movdqa <ab8six=%xmm12,>t9=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t9 *= *(int128 *)(t2p + 16)
# asm 1: mulpd 16(<t2p=int64#4),<t9=int6464#14
# asm 2: mulpd 16(<t2p=%rcx),<t9=%xmm13
mulpd 16(%rcx),%xmm13

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#14,<r9=int6464#11
# asm 2: addpd <t9=%xmm13,<r9=%xmm10
addpd %xmm13,%xmm10

# qhasm: t10 = ab8six
# asm 1: movdqa <ab8six=int6464#13,>t10=int6464#14
# asm 2: movdqa <ab8six=%xmm12,>t10=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t10 *= *(int128 *)(t2p + 32)
# asm 1: mulpd 32(<t2p=int64#4),<t10=int6464#14
# asm 2: mulpd 32(<t2p=%rcx),<t10=%xmm13
mulpd 32(%rcx),%xmm13

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#14,<r10=int6464#12
# asm 2: addpd <t10=%xmm13,<r10=%xmm11
addpd %xmm13,%xmm11

# qhasm: t11 = ab8six
# asm 1: movdqa <ab8six=int6464#13,>t11=int6464#14
# asm 2: movdqa <ab8six=%xmm12,>t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t11 *= *(int128 *)(t2p + 48)
# asm 1: mulpd 48(<t2p=int64#4),<t11=int6464#14
# asm 2: mulpd 48(<t2p=%rcx),<t11=%xmm13
mulpd 48(%rcx),%xmm13

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#14,<r11=int6464#1
# asm 2: addpd <t11=%xmm13,<r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: t12 = ab8six
# asm 1: movdqa <ab8six=int6464#13,>t12=int6464#14
# asm 2: movdqa <ab8six=%xmm12,>t12=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t12 *= *(int128 *)(t2p + 64)
# asm 1: mulpd 64(<t2p=int64#4),<t12=int6464#14
# asm 2: mulpd 64(<t2p=%rcx),<t12=%xmm13
mulpd 64(%rcx),%xmm13

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#14,<r12=int6464#2
# asm 2: addpd <t12=%xmm13,<r12=%xmm1
addpd %xmm13,%xmm1

# qhasm: t15 = ab8six
# asm 1: movdqa <ab8six=int6464#13,>t15=int6464#14
# asm 2: movdqa <ab8six=%xmm12,>t15=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t15 *= *(int128 *)(t2p + 112)
# asm 1: mulpd 112(<t2p=int64#4),<t15=int6464#14
# asm 2: mulpd 112(<t2p=%rcx),<t15=%xmm13
mulpd 112(%rcx),%xmm13

# qhasm: float6464 r15 +=t15
# asm 1: addpd <t15=int6464#14,<r15=int6464#5
# asm 2: addpd <t15=%xmm13,<r15=%xmm4
addpd %xmm13,%xmm4

# qhasm: t16 = ab8six
# asm 1: movdqa <ab8six=int6464#13,>t16=int6464#14
# asm 2: movdqa <ab8six=%xmm12,>t16=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t16 *= *(int128 *)(t2p + 128)
# asm 1: mulpd 128(<t2p=int64#4),<t16=int6464#14
# asm 2: mulpd 128(<t2p=%rcx),<t16=%xmm13
mulpd 128(%rcx),%xmm13

# qhasm: float6464 r16 +=t16
# asm 1: addpd <t16=int6464#14,<r16=int6464#6
# asm 2: addpd <t16=%xmm13,<r16=%xmm5
addpd %xmm13,%xmm5

# qhasm: t17 = ab8six
# asm 1: movdqa <ab8six=int6464#13,>t17=int6464#14
# asm 2: movdqa <ab8six=%xmm12,>t17=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t17 *= *(int128 *)(t2p + 144)
# asm 1: mulpd 144(<t2p=int64#4),<t17=int6464#14
# asm 2: mulpd 144(<t2p=%rcx),<t17=%xmm13
mulpd 144(%rcx),%xmm13

# qhasm: float6464 r17 +=t17
# asm 1: addpd <t17=int6464#14,<r17=int6464#7
# asm 2: addpd <t17=%xmm13,<r17=%xmm6
addpd %xmm13,%xmm6

# qhasm: t18 = ab8six
# asm 1: movdqa <ab8six=int6464#13,>t18=int6464#13
# asm 2: movdqa <ab8six=%xmm12,>t18=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 t18 *= *(int128 *)(t2p + 160)
# asm 1: mulpd 160(<t2p=int64#4),<t18=int6464#13
# asm 2: mulpd 160(<t2p=%rcx),<t18=%xmm12
mulpd 160(%rcx),%xmm12

# qhasm: float6464 r18 +=t18
# asm 1: addpd <t18=int6464#13,<r18=int6464#8
# asm 2: addpd <t18=%xmm12,<r18=%xmm7
addpd %xmm12,%xmm7

# qhasm: *(int128 *)(rp + 128) = r8
# asm 1: movdqa <r8=int6464#10,128(<rp=int64#3)
# asm 2: movdqa <r8=%xmm9,128(<rp=%rdx)
movdqa %xmm9,128(%rdx)

# qhasm: ab9 = *(int128 *)(t1p + 144)
# asm 1: movdqa 144(<t1p=int64#2),>ab9=int6464#10
# asm 2: movdqa 144(<t1p=%rsi),>ab9=%xmm9
movdqa 144(%rsi),%xmm9

# qhasm: ab9six = ab9
# asm 1: movdqa <ab9=int6464#10,>ab9six=int6464#13
# asm 2: movdqa <ab9=%xmm9,>ab9six=%xmm12
movdqa %xmm9,%xmm12

# qhasm: float6464 ab9six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab9six=int6464#13
# asm 2: mulpd SIX_SIX,<ab9six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: t9 = ab9
# asm 1: movdqa <ab9=int6464#10,>t9=int6464#14
# asm 2: movdqa <ab9=%xmm9,>t9=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 t9 *= *(int128 *)(t2p + 0)
# asm 1: mulpd 0(<t2p=int64#4),<t9=int6464#14
# asm 2: mulpd 0(<t2p=%rcx),<t9=%xmm13
mulpd 0(%rcx),%xmm13

# qhasm: float6464 r9 +=t9
# asm 1: addpd <t9=int6464#14,<r9=int6464#11
# asm 2: addpd <t9=%xmm13,<r9=%xmm10
addpd %xmm13,%xmm10

# qhasm: t13 = ab9
# asm 1: movdqa <ab9=int6464#10,>t13=int6464#14
# asm 2: movdqa <ab9=%xmm9,>t13=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 t13 *= *(int128 *)(t2p + 64)
# asm 1: mulpd 64(<t2p=int64#4),<t13=int6464#14
# asm 2: mulpd 64(<t2p=%rcx),<t13=%xmm13
mulpd 64(%rcx),%xmm13

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#14,<r13=int6464#3
# asm 2: addpd <t13=%xmm13,<r13=%xmm2
addpd %xmm13,%xmm2

# qhasm: t14 = ab9
# asm 1: movdqa <ab9=int6464#10,>t14=int6464#14
# asm 2: movdqa <ab9=%xmm9,>t14=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 t14 *= *(int128 *)(t2p + 80)
# asm 1: mulpd 80(<t2p=int64#4),<t14=int6464#14
# asm 2: mulpd 80(<t2p=%rcx),<t14=%xmm13
mulpd 80(%rcx),%xmm13

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#14,<r14=int6464#4
# asm 2: addpd <t14=%xmm13,<r14=%xmm3
addpd %xmm13,%xmm3

# qhasm: t15 = ab9
# asm 1: movdqa <ab9=int6464#10,>t15=int6464#14
# asm 2: movdqa <ab9=%xmm9,>t15=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 t15 *= *(int128 *)(t2p + 96)
# asm 1: mulpd 96(<t2p=int64#4),<t15=int6464#14
# asm 2: mulpd 96(<t2p=%rcx),<t15=%xmm13
mulpd 96(%rcx),%xmm13

# qhasm: float6464 r15 +=t15
# asm 1: addpd <t15=int6464#14,<r15=int6464#5
# asm 2: addpd <t15=%xmm13,<r15=%xmm4
addpd %xmm13,%xmm4

# qhasm: t19 = ab9
# asm 1: movdqa <ab9=int6464#10,>t19=int6464#14
# asm 2: movdqa <ab9=%xmm9,>t19=%xmm13
movdqa %xmm9,%xmm13

# qhasm: float6464 t19 *= *(int128 *)(t2p + 160)
# asm 1: mulpd 160(<t2p=int64#4),<t19=int6464#14
# asm 2: mulpd 160(<t2p=%rcx),<t19=%xmm13
mulpd 160(%rcx),%xmm13

# qhasm: float6464 r19 +=t19
# asm 1: addpd <t19=int6464#14,<r19=int6464#9
# asm 2: addpd <t19=%xmm13,<r19=%xmm8
addpd %xmm13,%xmm8

# qhasm: r20 = ab9
# asm 1: movdqa <ab9=int6464#10,>r20=int6464#10
# asm 2: movdqa <ab9=%xmm9,>r20=%xmm9
movdqa %xmm9,%xmm9

# qhasm: float6464 r20 *= *(int128 *)(t2p + 176)
# asm 1: mulpd 176(<t2p=int64#4),<r20=int6464#10
# asm 2: mulpd 176(<t2p=%rcx),<r20=%xmm9
mulpd 176(%rcx),%xmm9

# qhasm: t10 = ab9six
# asm 1: movdqa <ab9six=int6464#13,>t10=int6464#14
# asm 2: movdqa <ab9six=%xmm12,>t10=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t10 *= *(int128 *)(t2p + 16)
# asm 1: mulpd 16(<t2p=int64#4),<t10=int6464#14
# asm 2: mulpd 16(<t2p=%rcx),<t10=%xmm13
mulpd 16(%rcx),%xmm13

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#14,<r10=int6464#12
# asm 2: addpd <t10=%xmm13,<r10=%xmm11
addpd %xmm13,%xmm11

# qhasm: t11 = ab9six
# asm 1: movdqa <ab9six=int6464#13,>t11=int6464#14
# asm 2: movdqa <ab9six=%xmm12,>t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t11 *= *(int128 *)(t2p + 32)
# asm 1: mulpd 32(<t2p=int64#4),<t11=int6464#14
# asm 2: mulpd 32(<t2p=%rcx),<t11=%xmm13
mulpd 32(%rcx),%xmm13

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#14,<r11=int6464#1
# asm 2: addpd <t11=%xmm13,<r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: t12 = ab9six
# asm 1: movdqa <ab9six=int6464#13,>t12=int6464#14
# asm 2: movdqa <ab9six=%xmm12,>t12=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t12 *= *(int128 *)(t2p + 48)
# asm 1: mulpd 48(<t2p=int64#4),<t12=int6464#14
# asm 2: mulpd 48(<t2p=%rcx),<t12=%xmm13
mulpd 48(%rcx),%xmm13

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#14,<r12=int6464#2
# asm 2: addpd <t12=%xmm13,<r12=%xmm1
addpd %xmm13,%xmm1

# qhasm: t16 = ab9six
# asm 1: movdqa <ab9six=int6464#13,>t16=int6464#14
# asm 2: movdqa <ab9six=%xmm12,>t16=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t16 *= *(int128 *)(t2p + 112)
# asm 1: mulpd 112(<t2p=int64#4),<t16=int6464#14
# asm 2: mulpd 112(<t2p=%rcx),<t16=%xmm13
mulpd 112(%rcx),%xmm13

# qhasm: float6464 r16 +=t16
# asm 1: addpd <t16=int6464#14,<r16=int6464#6
# asm 2: addpd <t16=%xmm13,<r16=%xmm5
addpd %xmm13,%xmm5

# qhasm: t17 = ab9six
# asm 1: movdqa <ab9six=int6464#13,>t17=int6464#14
# asm 2: movdqa <ab9six=%xmm12,>t17=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t17 *= *(int128 *)(t2p + 128)
# asm 1: mulpd 128(<t2p=int64#4),<t17=int6464#14
# asm 2: mulpd 128(<t2p=%rcx),<t17=%xmm13
mulpd 128(%rcx),%xmm13

# qhasm: float6464 r17 +=t17
# asm 1: addpd <t17=int6464#14,<r17=int6464#7
# asm 2: addpd <t17=%xmm13,<r17=%xmm6
addpd %xmm13,%xmm6

# qhasm: t18 = ab9six
# asm 1: movdqa <ab9six=int6464#13,>t18=int6464#13
# asm 2: movdqa <ab9six=%xmm12,>t18=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 t18 *= *(int128 *)(t2p + 144)
# asm 1: mulpd 144(<t2p=int64#4),<t18=int6464#13
# asm 2: mulpd 144(<t2p=%rcx),<t18=%xmm12
mulpd 144(%rcx),%xmm12

# qhasm: float6464 r18 +=t18
# asm 1: addpd <t18=int6464#13,<r18=int6464#8
# asm 2: addpd <t18=%xmm12,<r18=%xmm7
addpd %xmm12,%xmm7

# qhasm: *(int128 *)(rp + 144) = r9
# asm 1: movdqa <r9=int6464#11,144(<rp=int64#3)
# asm 2: movdqa <r9=%xmm10,144(<rp=%rdx)
movdqa %xmm10,144(%rdx)

# qhasm: ab10 = *(int128 *)(t1p + 160)
# asm 1: movdqa 160(<t1p=int64#2),>ab10=int6464#11
# asm 2: movdqa 160(<t1p=%rsi),>ab10=%xmm10
movdqa 160(%rsi),%xmm10

# qhasm: ab10six = ab10
# asm 1: movdqa <ab10=int6464#11,>ab10six=int6464#13
# asm 2: movdqa <ab10=%xmm10,>ab10six=%xmm12
movdqa %xmm10,%xmm12

# qhasm: float6464 ab10six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab10six=int6464#13
# asm 2: mulpd SIX_SIX,<ab10six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: t10 = ab10
# asm 1: movdqa <ab10=int6464#11,>t10=int6464#14
# asm 2: movdqa <ab10=%xmm10,>t10=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 t10 *= *(int128 *)(t2p + 0)
# asm 1: mulpd 0(<t2p=int64#4),<t10=int6464#14
# asm 2: mulpd 0(<t2p=%rcx),<t10=%xmm13
mulpd 0(%rcx),%xmm13

# qhasm: float6464 r10 +=t10
# asm 1: addpd <t10=int6464#14,<r10=int6464#12
# asm 2: addpd <t10=%xmm13,<r10=%xmm11
addpd %xmm13,%xmm11

# qhasm: t13 = ab10
# asm 1: movdqa <ab10=int6464#11,>t13=int6464#14
# asm 2: movdqa <ab10=%xmm10,>t13=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 t13 *= *(int128 *)(t2p + 48)
# asm 1: mulpd 48(<t2p=int64#4),<t13=int6464#14
# asm 2: mulpd 48(<t2p=%rcx),<t13=%xmm13
mulpd 48(%rcx),%xmm13

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#14,<r13=int6464#3
# asm 2: addpd <t13=%xmm13,<r13=%xmm2
addpd %xmm13,%xmm2

# qhasm: t14 = ab10
# asm 1: movdqa <ab10=int6464#11,>t14=int6464#14
# asm 2: movdqa <ab10=%xmm10,>t14=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 t14 *= *(int128 *)(t2p + 64)
# asm 1: mulpd 64(<t2p=int64#4),<t14=int6464#14
# asm 2: mulpd 64(<t2p=%rcx),<t14=%xmm13
mulpd 64(%rcx),%xmm13

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#14,<r14=int6464#4
# asm 2: addpd <t14=%xmm13,<r14=%xmm3
addpd %xmm13,%xmm3

# qhasm: t16 = ab10
# asm 1: movdqa <ab10=int6464#11,>t16=int6464#14
# asm 2: movdqa <ab10=%xmm10,>t16=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 t16 *= *(int128 *)(t2p + 96)
# asm 1: mulpd 96(<t2p=int64#4),<t16=int6464#14
# asm 2: mulpd 96(<t2p=%rcx),<t16=%xmm13
mulpd 96(%rcx),%xmm13

# qhasm: float6464 r16 +=t16
# asm 1: addpd <t16=int6464#14,<r16=int6464#6
# asm 2: addpd <t16=%xmm13,<r16=%xmm5
addpd %xmm13,%xmm5

# qhasm: t15 = ab10
# asm 1: movdqa <ab10=int6464#11,>t15=int6464#14
# asm 2: movdqa <ab10=%xmm10,>t15=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 t15 *= *(int128 *)(t2p + 80)
# asm 1: mulpd 80(<t2p=int64#4),<t15=int6464#14
# asm 2: mulpd 80(<t2p=%rcx),<t15=%xmm13
mulpd 80(%rcx),%xmm13

# qhasm: float6464 r15 +=t15
# asm 1: addpd <t15=int6464#14,<r15=int6464#5
# asm 2: addpd <t15=%xmm13,<r15=%xmm4
addpd %xmm13,%xmm4

# qhasm: t19 = ab10
# asm 1: movdqa <ab10=int6464#11,>t19=int6464#14
# asm 2: movdqa <ab10=%xmm10,>t19=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 t19 *= *(int128 *)(t2p + 144)
# asm 1: mulpd 144(<t2p=int64#4),<t19=int6464#14
# asm 2: mulpd 144(<t2p=%rcx),<t19=%xmm13
mulpd 144(%rcx),%xmm13

# qhasm: float6464 r19 +=t19
# asm 1: addpd <t19=int6464#14,<r19=int6464#9
# asm 2: addpd <t19=%xmm13,<r19=%xmm8
addpd %xmm13,%xmm8

# qhasm: t20 = ab10
# asm 1: movdqa <ab10=int6464#11,>t20=int6464#14
# asm 2: movdqa <ab10=%xmm10,>t20=%xmm13
movdqa %xmm10,%xmm13

# qhasm: float6464 t20 *= *(int128 *)(t2p + 160)
# asm 1: mulpd 160(<t2p=int64#4),<t20=int6464#14
# asm 2: mulpd 160(<t2p=%rcx),<t20=%xmm13
mulpd 160(%rcx),%xmm13

# qhasm: float6464 r20 +=t20
# asm 1: addpd <t20=int6464#14,<r20=int6464#10
# asm 2: addpd <t20=%xmm13,<r20=%xmm9
addpd %xmm13,%xmm9

# qhasm: r21 = ab10
# asm 1: movdqa <ab10=int6464#11,>r21=int6464#11
# asm 2: movdqa <ab10=%xmm10,>r21=%xmm10
movdqa %xmm10,%xmm10

# qhasm: float6464 r21 *= *(int128 *)(t2p + 176)
# asm 1: mulpd 176(<t2p=int64#4),<r21=int6464#11
# asm 2: mulpd 176(<t2p=%rcx),<r21=%xmm10
mulpd 176(%rcx),%xmm10

# qhasm: t11 = ab10six
# asm 1: movdqa <ab10six=int6464#13,>t11=int6464#14
# asm 2: movdqa <ab10six=%xmm12,>t11=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t11 *= *(int128 *)(t2p + 16)
# asm 1: mulpd 16(<t2p=int64#4),<t11=int6464#14
# asm 2: mulpd 16(<t2p=%rcx),<t11=%xmm13
mulpd 16(%rcx),%xmm13

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#14,<r11=int6464#1
# asm 2: addpd <t11=%xmm13,<r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: t12 = ab10six
# asm 1: movdqa <ab10six=int6464#13,>t12=int6464#14
# asm 2: movdqa <ab10six=%xmm12,>t12=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t12 *= *(int128 *)(t2p + 32)
# asm 1: mulpd 32(<t2p=int64#4),<t12=int6464#14
# asm 2: mulpd 32(<t2p=%rcx),<t12=%xmm13
mulpd 32(%rcx),%xmm13

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#14,<r12=int6464#2
# asm 2: addpd <t12=%xmm13,<r12=%xmm1
addpd %xmm13,%xmm1

# qhasm: t17 = ab10six
# asm 1: movdqa <ab10six=int6464#13,>t17=int6464#14
# asm 2: movdqa <ab10six=%xmm12,>t17=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t17 *= *(int128 *)(t2p + 112)
# asm 1: mulpd 112(<t2p=int64#4),<t17=int6464#14
# asm 2: mulpd 112(<t2p=%rcx),<t17=%xmm13
mulpd 112(%rcx),%xmm13

# qhasm: float6464 r17 +=t17
# asm 1: addpd <t17=int6464#14,<r17=int6464#7
# asm 2: addpd <t17=%xmm13,<r17=%xmm6
addpd %xmm13,%xmm6

# qhasm: t18 = ab10six
# asm 1: movdqa <ab10six=int6464#13,>t18=int6464#13
# asm 2: movdqa <ab10six=%xmm12,>t18=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 t18 *= *(int128 *)(t2p + 128)
# asm 1: mulpd 128(<t2p=int64#4),<t18=int6464#13
# asm 2: mulpd 128(<t2p=%rcx),<t18=%xmm12
mulpd 128(%rcx),%xmm12

# qhasm: float6464 r18 +=t18
# asm 1: addpd <t18=int6464#13,<r18=int6464#8
# asm 2: addpd <t18=%xmm12,<r18=%xmm7
addpd %xmm12,%xmm7

# qhasm: *(int128 *)(rp + 160) = r10
# asm 1: movdqa <r10=int6464#12,160(<rp=int64#3)
# asm 2: movdqa <r10=%xmm11,160(<rp=%rdx)
movdqa %xmm11,160(%rdx)

# qhasm: ab11 = *(int128 *)(t1p + 176)
# asm 1: movdqa 176(<t1p=int64#2),>ab11=int6464#12
# asm 2: movdqa 176(<t1p=%rsi),>ab11=%xmm11
movdqa 176(%rsi),%xmm11

# qhasm: ab11six = ab11
# asm 1: movdqa <ab11=int6464#12,>ab11six=int6464#13
# asm 2: movdqa <ab11=%xmm11,>ab11six=%xmm12
movdqa %xmm11,%xmm12

# qhasm: float6464 ab11six *= SIX_SIX
# asm 1: mulpd SIX_SIX,<ab11six=int6464#13
# asm 2: mulpd SIX_SIX,<ab11six=%xmm12
mov SIX_SIX@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: t11 = ab11
# asm 1: movdqa <ab11=int6464#12,>t11=int6464#14
# asm 2: movdqa <ab11=%xmm11,>t11=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 t11 *= *(int128 *)(t2p + 0)
# asm 1: mulpd 0(<t2p=int64#4),<t11=int6464#14
# asm 2: mulpd 0(<t2p=%rcx),<t11=%xmm13
mulpd 0(%rcx),%xmm13

# qhasm: float6464 r11 +=t11
# asm 1: addpd <t11=int6464#14,<r11=int6464#1
# asm 2: addpd <t11=%xmm13,<r11=%xmm0
addpd %xmm13,%xmm0

# qhasm: t13 = ab11
# asm 1: movdqa <ab11=int6464#12,>t13=int6464#14
# asm 2: movdqa <ab11=%xmm11,>t13=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 t13 *= *(int128 *)(t2p + 32)
# asm 1: mulpd 32(<t2p=int64#4),<t13=int6464#14
# asm 2: mulpd 32(<t2p=%rcx),<t13=%xmm13
mulpd 32(%rcx),%xmm13

# qhasm: float6464 r13 +=t13
# asm 1: addpd <t13=int6464#14,<r13=int6464#3
# asm 2: addpd <t13=%xmm13,<r13=%xmm2
addpd %xmm13,%xmm2

# qhasm: t14 = ab11
# asm 1: movdqa <ab11=int6464#12,>t14=int6464#14
# asm 2: movdqa <ab11=%xmm11,>t14=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 t14 *= *(int128 *)(t2p + 48)
# asm 1: mulpd 48(<t2p=int64#4),<t14=int6464#14
# asm 2: mulpd 48(<t2p=%rcx),<t14=%xmm13
mulpd 48(%rcx),%xmm13

# qhasm: float6464 r14 +=t14
# asm 1: addpd <t14=int6464#14,<r14=int6464#4
# asm 2: addpd <t14=%xmm13,<r14=%xmm3
addpd %xmm13,%xmm3

# qhasm: t15 = ab11
# asm 1: movdqa <ab11=int6464#12,>t15=int6464#14
# asm 2: movdqa <ab11=%xmm11,>t15=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 t15 *= *(int128 *)(t2p + 64)
# asm 1: mulpd 64(<t2p=int64#4),<t15=int6464#14
# asm 2: mulpd 64(<t2p=%rcx),<t15=%xmm13
mulpd 64(%rcx),%xmm13

# qhasm: float6464 r15 +=t15
# asm 1: addpd <t15=int6464#14,<r15=int6464#5
# asm 2: addpd <t15=%xmm13,<r15=%xmm4
addpd %xmm13,%xmm4

# qhasm: t16 = ab11
# asm 1: movdqa <ab11=int6464#12,>t16=int6464#14
# asm 2: movdqa <ab11=%xmm11,>t16=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 t16 *= *(int128 *)(t2p + 80)
# asm 1: mulpd 80(<t2p=int64#4),<t16=int6464#14
# asm 2: mulpd 80(<t2p=%rcx),<t16=%xmm13
mulpd 80(%rcx),%xmm13

# qhasm: float6464 r16 +=t16
# asm 1: addpd <t16=int6464#14,<r16=int6464#6
# asm 2: addpd <t16=%xmm13,<r16=%xmm5
addpd %xmm13,%xmm5

# qhasm: t17 = ab11
# asm 1: movdqa <ab11=int6464#12,>t17=int6464#14
# asm 2: movdqa <ab11=%xmm11,>t17=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 t17 *= *(int128 *)(t2p + 96)
# asm 1: mulpd 96(<t2p=int64#4),<t17=int6464#14
# asm 2: mulpd 96(<t2p=%rcx),<t17=%xmm13
mulpd 96(%rcx),%xmm13

# qhasm: float6464 r17 +=t17
# asm 1: addpd <t17=int6464#14,<r17=int6464#7
# asm 2: addpd <t17=%xmm13,<r17=%xmm6
addpd %xmm13,%xmm6

# qhasm: t19 = ab11
# asm 1: movdqa <ab11=int6464#12,>t19=int6464#14
# asm 2: movdqa <ab11=%xmm11,>t19=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 t19 *= *(int128 *)(t2p + 128)
# asm 1: mulpd 128(<t2p=int64#4),<t19=int6464#14
# asm 2: mulpd 128(<t2p=%rcx),<t19=%xmm13
mulpd 128(%rcx),%xmm13

# qhasm: float6464 r19 +=t19
# asm 1: addpd <t19=int6464#14,<r19=int6464#9
# asm 2: addpd <t19=%xmm13,<r19=%xmm8
addpd %xmm13,%xmm8

# qhasm: t20 = ab11
# asm 1: movdqa <ab11=int6464#12,>t20=int6464#14
# asm 2: movdqa <ab11=%xmm11,>t20=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 t20 *= *(int128 *)(t2p + 144)
# asm 1: mulpd 144(<t2p=int64#4),<t20=int6464#14
# asm 2: mulpd 144(<t2p=%rcx),<t20=%xmm13
mulpd 144(%rcx),%xmm13

# qhasm: float6464 r20 +=t20
# asm 1: addpd <t20=int6464#14,<r20=int6464#10
# asm 2: addpd <t20=%xmm13,<r20=%xmm9
addpd %xmm13,%xmm9

# qhasm: t21 = ab11
# asm 1: movdqa <ab11=int6464#12,>t21=int6464#14
# asm 2: movdqa <ab11=%xmm11,>t21=%xmm13
movdqa %xmm11,%xmm13

# qhasm: float6464 t21 *= *(int128 *)(t2p + 160)
# asm 1: mulpd 160(<t2p=int64#4),<t21=int6464#14
# asm 2: mulpd 160(<t2p=%rcx),<t21=%xmm13
mulpd 160(%rcx),%xmm13

# qhasm: float6464 r21 +=t21
# asm 1: addpd <t21=int6464#14,<r21=int6464#11
# asm 2: addpd <t21=%xmm13,<r21=%xmm10
addpd %xmm13,%xmm10

# qhasm: r22 = ab11
# asm 1: movdqa <ab11=int6464#12,>r22=int6464#12
# asm 2: movdqa <ab11=%xmm11,>r22=%xmm11
movdqa %xmm11,%xmm11

# qhasm: float6464 r22 *= *(int128 *)(t2p + 176)
# asm 1: mulpd 176(<t2p=int64#4),<r22=int6464#12
# asm 2: mulpd 176(<t2p=%rcx),<r22=%xmm11
mulpd 176(%rcx),%xmm11

# qhasm: t12 = ab11six
# asm 1: movdqa <ab11six=int6464#13,>t12=int6464#14
# asm 2: movdqa <ab11six=%xmm12,>t12=%xmm13
movdqa %xmm12,%xmm13

# qhasm: float6464 t12 *= *(int128 *)(t2p + 16)
# asm 1: mulpd 16(<t2p=int64#4),<t12=int6464#14
# asm 2: mulpd 16(<t2p=%rcx),<t12=%xmm13
mulpd 16(%rcx),%xmm13

# qhasm: float6464 r12 +=t12
# asm 1: addpd <t12=int6464#14,<r12=int6464#2
# asm 2: addpd <t12=%xmm13,<r12=%xmm1
addpd %xmm13,%xmm1

# qhasm: t18 = ab11six
# asm 1: movdqa <ab11six=int6464#13,>t18=int6464#13
# asm 2: movdqa <ab11six=%xmm12,>t18=%xmm12
movdqa %xmm12,%xmm12

# qhasm: float6464 t18 *= *(int128 *)(t2p + 112)
# asm 1: mulpd 112(<t2p=int64#4),<t18=int6464#13
# asm 2: mulpd 112(<t2p=%rcx),<t18=%xmm12
mulpd 112(%rcx),%xmm12

# qhasm: float6464 r18 +=t18
# asm 1: addpd <t18=int6464#13,<r18=int6464#8
# asm 2: addpd <t18=%xmm12,<r18=%xmm7
addpd %xmm12,%xmm7

# qhasm: *(int128 *)(rp + 176) = r11
# asm 1: movdqa <r11=int6464#1,176(<rp=int64#3)
# asm 2: movdqa <r11=%xmm0,176(<rp=%rdx)
movdqa %xmm0,176(%rdx)

# qhasm: r0 = *(int128 *)(rp + 0)
# asm 1: movdqa 0(<rp=int64#3),>r0=int6464#1
# asm 2: movdqa 0(<rp=%rdx),>r0=%xmm0
movdqa 0(%rdx),%xmm0

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

# qhasm: r3 = *(int128 *)(rp + 48)
# asm 1: movdqa 48(<rp=int64#3),>r3=int6464#13
# asm 2: movdqa 48(<rp=%rdx),>r3=%xmm12
movdqa 48(%rdx),%xmm12

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

# qhasm: r6 = *(int128 *)(rp + 96)
# asm 1: movdqa 96(<rp=int64#3),>r6=int6464#14
# asm 2: movdqa 96(<rp=%rdx),>r6=%xmm13
movdqa 96(%rdx),%xmm13

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

# qhasm: r9 = *(int128 *)(rp + 144)
# asm 1: movdqa 144(<rp=int64#3),>r9=int6464#15
# asm 2: movdqa 144(<rp=%rdx),>r9=%xmm14
movdqa 144(%rdx),%xmm14

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

# qhasm: r1 = *(int128 *)(rp + 16)
# asm 1: movdqa 16(<rp=int64#3),>r1=int6464#2
# asm 2: movdqa 16(<rp=%rdx),>r1=%xmm1
movdqa 16(%rdx),%xmm1

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

# qhasm: r4 = *(int128 *)(rp + 64)
# asm 1: movdqa 64(<rp=int64#3),>r4=int6464#5
# asm 2: movdqa 64(<rp=%rdx),>r4=%xmm4
movdqa 64(%rdx),%xmm4

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

# qhasm: r7 = *(int128 *)(rp + 112)
# asm 1: movdqa 112(<rp=int64#3),>r7=int6464#8
# asm 2: movdqa 112(<rp=%rdx),>r7=%xmm7
movdqa 112(%rdx),%xmm7

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

# qhasm: r10 = *(int128 *)(rp + 160)
# asm 1: movdqa 160(<rp=int64#3),>r10=int6464#11
# asm 2: movdqa 160(<rp=%rdx),>r10=%xmm10
movdqa 160(%rdx),%xmm10

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

# qhasm: r2 = *(int128 *)(rp + 32)
# asm 1: movdqa 32(<rp=int64#3),>r2=int6464#3
# asm 2: movdqa 32(<rp=%rdx),>r2=%xmm2
movdqa 32(%rdx),%xmm2

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

# qhasm: r5 = *(int128 *)(rp + 80)
# asm 1: movdqa 80(<rp=int64#3),>r5=int6464#6
# asm 2: movdqa 80(<rp=%rdx),>r5=%xmm5
movdqa 80(%rdx),%xmm5

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

# qhasm: r8 = *(int128 *)(rp + 128)
# asm 1: movdqa 128(<rp=int64#3),>r8=int6464#9
# asm 2: movdqa 128(<rp=%rdx),>r8=%xmm8
movdqa 128(%rdx),%xmm8

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

# qhasm: r11 = *(int128 *)(rp + 176)
# asm 1: movdqa 176(<rp=int64#3),>r11=int6464#12
# asm 2: movdqa 176(<rp=%rdx),>r11=%xmm11
movdqa 176(%rdx),%xmm11

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

# qhasm: 2t6 = carry
# asm 1: movdqa <carry=int6464#7,>2t6=int6464#10
# asm 2: movdqa <carry=%xmm6,>2t6=%xmm9
movdqa %xmm6,%xmm9

# qhasm: float6464 2t6 *= FOUR_FOUR
# asm 1: mulpd FOUR_FOUR,<2t6=int6464#10
# asm 2: mulpd FOUR_FOUR,<2t6=%xmm9
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm9

# qhasm: float6464 r6 -= 2t6
# asm 1: subpd <2t6=int6464#10,<r6=int6464#14
# asm 2: subpd <2t6=%xmm9,<r6=%xmm13
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
