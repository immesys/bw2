# File:   dclxvi-20130329/fp2e_mulxi.s
# Author: Ruben Niederhagen, Peter Schwabe
# Public Domain


# qhasm: enter fp2e_mulxi_qhasm
.text
.p2align 5
.globl _fp2e_mulxi_qhasm
.globl fp2e_mulxi_qhasm
_fp2e_mulxi_qhasm:
fp2e_mulxi_qhasm:
push %rbp
mov %rsp,%r11
and $31,%r11
add $0,%r11
sub %r11,%rsp

# qhasm: int64 0rop

# qhasm: int64 0op

# qhasm: input 0rop

# qhasm: input 0op

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

# qhasm: 0r0  = *(int128 *)(0op +   0)
# asm 1: movdqa 0(<0op=int64#2),>0r0=int6464#1
# asm 2: movdqa 0(<0op=%rsi),>0r0=%xmm0
movdqa 0(%rsi),%xmm0

# qhasm: 0r1  = *(int128 *)(0op +  16)
# asm 1: movdqa 16(<0op=int64#2),>0r1=int6464#2
# asm 2: movdqa 16(<0op=%rsi),>0r1=%xmm1
movdqa 16(%rsi),%xmm1

# qhasm: 0r2  = *(int128 *)(0op +  32)
# asm 1: movdqa 32(<0op=int64#2),>0r2=int6464#3
# asm 2: movdqa 32(<0op=%rsi),>0r2=%xmm2
movdqa 32(%rsi),%xmm2

# qhasm: 0r3  = *(int128 *)(0op +  48)
# asm 1: movdqa 48(<0op=int64#2),>0r3=int6464#4
# asm 2: movdqa 48(<0op=%rsi),>0r3=%xmm3
movdqa 48(%rsi),%xmm3

# qhasm: 0r4  = *(int128 *)(0op +  64)
# asm 1: movdqa 64(<0op=int64#2),>0r4=int6464#5
# asm 2: movdqa 64(<0op=%rsi),>0r4=%xmm4
movdqa 64(%rsi),%xmm4

# qhasm: 0r5  = *(int128 *)(0op +  80)
# asm 1: movdqa 80(<0op=int64#2),>0r5=int6464#6
# asm 2: movdqa 80(<0op=%rsi),>0r5=%xmm5
movdqa 80(%rsi),%xmm5

# qhasm: 0r6  = *(int128 *)(0op +  96)
# asm 1: movdqa 96(<0op=int64#2),>0r6=int6464#7
# asm 2: movdqa 96(<0op=%rsi),>0r6=%xmm6
movdqa 96(%rsi),%xmm6

# qhasm: 0r7  = *(int128 *)(0op + 112)
# asm 1: movdqa 112(<0op=int64#2),>0r7=int6464#8
# asm 2: movdqa 112(<0op=%rsi),>0r7=%xmm7
movdqa 112(%rsi),%xmm7

# qhasm: 0r8  = *(int128 *)(0op + 128)
# asm 1: movdqa 128(<0op=int64#2),>0r8=int6464#9
# asm 2: movdqa 128(<0op=%rsi),>0r8=%xmm8
movdqa 128(%rsi),%xmm8

# qhasm: 0r9  = *(int128 *)(0op + 144)
# asm 1: movdqa 144(<0op=int64#2),>0r9=int6464#10
# asm 2: movdqa 144(<0op=%rsi),>0r9=%xmm9
movdqa 144(%rsi),%xmm9

# qhasm: 0r10 = *(int128 *)(0op + 160)
# asm 1: movdqa 160(<0op=int64#2),>0r10=int6464#11
# asm 2: movdqa 160(<0op=%rsi),>0r10=%xmm10
movdqa 160(%rsi),%xmm10

# qhasm: 0r11 = *(int128 *)(0op + 176)
# asm 1: movdqa 176(<0op=int64#2),>0r11=int6464#12
# asm 2: movdqa 176(<0op=%rsi),>0r11=%xmm11
movdqa 176(%rsi),%xmm11

# qhasm: int6464 1t0

# qhasm: int6464 1t1

# qhasm: int6464 1t2

# qhasm: int6464 1t3

# qhasm: int6464 0t4

# qhasm: int6464 0t5

# qhasm: int6464 0t6

# qhasm: int6464 0t7

# qhasm: int6464 0t8

# qhasm: int6464 0t9

# qhasm: int6464 0t10

# qhasm: int6464 0t11

# qhasm: 1t0 = 0r0
# asm 1: movdqa <0r0=int6464#1,>1t0=int6464#13
# asm 2: movdqa <0r0=%xmm0,>1t0=%xmm12
movdqa %xmm0,%xmm12

# qhasm: float6464 0r0 *= THREE_MINUSONE
# asm 1: mulpd THREE_MINUSONE,<0r0=int6464#1
# asm 2: mulpd THREE_MINUSONE,<0r0=%xmm0
mov THREE_MINUSONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm0

# qhasm: float6464 1t0 *= ONE_THREE
# asm 1: mulpd ONE_THREE,<1t0=int6464#13
# asm 2: mulpd ONE_THREE,<1t0=%xmm12
mov ONE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 0r0[0] += 0r0[1];0r0[1] = 1t0[0] + 1t0[1]
# asm 1: haddpd <1t0=int6464#13,<0r0=int6464#1
# asm 2: haddpd <1t0=%xmm12,<0r0=%xmm0
haddpd %xmm12,%xmm0

# qhasm: 1t1 = 0r1
# asm 1: movdqa <0r1=int6464#2,>1t1=int6464#13
# asm 2: movdqa <0r1=%xmm1,>1t1=%xmm12
movdqa %xmm1,%xmm12

# qhasm: float6464 0r1 *= THREE_MINUSONE
# asm 1: mulpd THREE_MINUSONE,<0r1=int6464#2
# asm 2: mulpd THREE_MINUSONE,<0r1=%xmm1
mov THREE_MINUSONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm1

# qhasm: float6464 1t1 *= ONE_THREE
# asm 1: mulpd ONE_THREE,<1t1=int6464#13
# asm 2: mulpd ONE_THREE,<1t1=%xmm12
mov ONE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 0r1[0] += 0r1[1];0r1[1] = 1t1[0] + 1t1[1]
# asm 1: haddpd <1t1=int6464#13,<0r1=int6464#2
# asm 2: haddpd <1t1=%xmm12,<0r1=%xmm1
haddpd %xmm12,%xmm1

# qhasm: 1t2 = 0r2
# asm 1: movdqa <0r2=int6464#3,>1t2=int6464#13
# asm 2: movdqa <0r2=%xmm2,>1t2=%xmm12
movdqa %xmm2,%xmm12

# qhasm: float6464 0r2 *= THREE_MINUSONE
# asm 1: mulpd THREE_MINUSONE,<0r2=int6464#3
# asm 2: mulpd THREE_MINUSONE,<0r2=%xmm2
mov THREE_MINUSONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm2

# qhasm: float6464 1t2 *= ONE_THREE
# asm 1: mulpd ONE_THREE,<1t2=int6464#13
# asm 2: mulpd ONE_THREE,<1t2=%xmm12
mov ONE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 0r2[0] += 0r2[1];0r2[1] = 1t2[0] + 1t2[1]
# asm 1: haddpd <1t2=int6464#13,<0r2=int6464#3
# asm 2: haddpd <1t2=%xmm12,<0r2=%xmm2
haddpd %xmm12,%xmm2

# qhasm: 1t3 = 0r3
# asm 1: movdqa <0r3=int6464#4,>1t3=int6464#13
# asm 2: movdqa <0r3=%xmm3,>1t3=%xmm12
movdqa %xmm3,%xmm12

# qhasm: float6464 0r3 *= THREE_MINUSONE
# asm 1: mulpd THREE_MINUSONE,<0r3=int6464#4
# asm 2: mulpd THREE_MINUSONE,<0r3=%xmm3
mov THREE_MINUSONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm3

# qhasm: float6464 1t3 *= ONE_THREE
# asm 1: mulpd ONE_THREE,<1t3=int6464#13
# asm 2: mulpd ONE_THREE,<1t3=%xmm12
mov ONE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 0r3[0] += 0r3[1];0r3[1] = 1t3[0] + 1t3[1]
# asm 1: haddpd <1t3=int6464#13,<0r3=int6464#4
# asm 2: haddpd <1t3=%xmm12,<0r3=%xmm3
haddpd %xmm12,%xmm3

# qhasm: 0t4 = 0r4
# asm 1: movdqa <0r4=int6464#5,>0t4=int6464#13
# asm 2: movdqa <0r4=%xmm4,>0t4=%xmm12
movdqa %xmm4,%xmm12

# qhasm: float6464 0r4 *= THREE_MINUSONE
# asm 1: mulpd THREE_MINUSONE,<0r4=int6464#5
# asm 2: mulpd THREE_MINUSONE,<0r4=%xmm4
mov THREE_MINUSONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm4

# qhasm: float6464 0t4 *= ONE_THREE
# asm 1: mulpd ONE_THREE,<0t4=int6464#13
# asm 2: mulpd ONE_THREE,<0t4=%xmm12
mov ONE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 0r4[0] += 0r4[1];0r4[1] = 0t4[0] + 0t4[1]
# asm 1: haddpd <0t4=int6464#13,<0r4=int6464#5
# asm 2: haddpd <0t4=%xmm12,<0r4=%xmm4
haddpd %xmm12,%xmm4

# qhasm: 0t5 = 0r5
# asm 1: movdqa <0r5=int6464#6,>0t5=int6464#13
# asm 2: movdqa <0r5=%xmm5,>0t5=%xmm12
movdqa %xmm5,%xmm12

# qhasm: float6464 0r5 *= THREE_MINUSONE
# asm 1: mulpd THREE_MINUSONE,<0r5=int6464#6
# asm 2: mulpd THREE_MINUSONE,<0r5=%xmm5
mov THREE_MINUSONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm5

# qhasm: float6464 0t5 *= ONE_THREE
# asm 1: mulpd ONE_THREE,<0t5=int6464#13
# asm 2: mulpd ONE_THREE,<0t5=%xmm12
mov ONE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 0r5[0] += 0r5[1];0r5[1] = 0t5[0] + 0t5[1]
# asm 1: haddpd <0t5=int6464#13,<0r5=int6464#6
# asm 2: haddpd <0t5=%xmm12,<0r5=%xmm5
haddpd %xmm12,%xmm5

# qhasm: 0t6 = 0r6
# asm 1: movdqa <0r6=int6464#7,>0t6=int6464#13
# asm 2: movdqa <0r6=%xmm6,>0t6=%xmm12
movdqa %xmm6,%xmm12

# qhasm: float6464 0r6 *= THREE_MINUSONE
# asm 1: mulpd THREE_MINUSONE,<0r6=int6464#7
# asm 2: mulpd THREE_MINUSONE,<0r6=%xmm6
mov THREE_MINUSONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm6

# qhasm: float6464 0t6 *= ONE_THREE
# asm 1: mulpd ONE_THREE,<0t6=int6464#13
# asm 2: mulpd ONE_THREE,<0t6=%xmm12
mov ONE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 0r6[0] += 0r6[1];0r6[1] = 0t6[0] + 0t6[1]
# asm 1: haddpd <0t6=int6464#13,<0r6=int6464#7
# asm 2: haddpd <0t6=%xmm12,<0r6=%xmm6
haddpd %xmm12,%xmm6

# qhasm: 0t7 = 0r7
# asm 1: movdqa <0r7=int6464#8,>0t7=int6464#13
# asm 2: movdqa <0r7=%xmm7,>0t7=%xmm12
movdqa %xmm7,%xmm12

# qhasm: float6464 0r7 *= THREE_MINUSONE
# asm 1: mulpd THREE_MINUSONE,<0r7=int6464#8
# asm 2: mulpd THREE_MINUSONE,<0r7=%xmm7
mov THREE_MINUSONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm7

# qhasm: float6464 0t7 *= ONE_THREE
# asm 1: mulpd ONE_THREE,<0t7=int6464#13
# asm 2: mulpd ONE_THREE,<0t7=%xmm12
mov ONE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 0r7[0] += 0r7[1];0r7[1] = 0t7[0] + 0t7[1]
# asm 1: haddpd <0t7=int6464#13,<0r7=int6464#8
# asm 2: haddpd <0t7=%xmm12,<0r7=%xmm7
haddpd %xmm12,%xmm7

# qhasm: 0t8 = 0r8
# asm 1: movdqa <0r8=int6464#9,>0t8=int6464#13
# asm 2: movdqa <0r8=%xmm8,>0t8=%xmm12
movdqa %xmm8,%xmm12

# qhasm: float6464 0r8 *= THREE_MINUSONE
# asm 1: mulpd THREE_MINUSONE,<0r8=int6464#9
# asm 2: mulpd THREE_MINUSONE,<0r8=%xmm8
mov THREE_MINUSONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm8

# qhasm: float6464 0t8 *= ONE_THREE
# asm 1: mulpd ONE_THREE,<0t8=int6464#13
# asm 2: mulpd ONE_THREE,<0t8=%xmm12
mov ONE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 0r8[0] += 0r8[1];0r8[1] = 0t8[0] + 0t8[1]
# asm 1: haddpd <0t8=int6464#13,<0r8=int6464#9
# asm 2: haddpd <0t8=%xmm12,<0r8=%xmm8
haddpd %xmm12,%xmm8

# qhasm: 0t9 = 0r9
# asm 1: movdqa <0r9=int6464#10,>0t9=int6464#13
# asm 2: movdqa <0r9=%xmm9,>0t9=%xmm12
movdqa %xmm9,%xmm12

# qhasm: float6464 0r9 *= THREE_MINUSONE
# asm 1: mulpd THREE_MINUSONE,<0r9=int6464#10
# asm 2: mulpd THREE_MINUSONE,<0r9=%xmm9
mov THREE_MINUSONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm9

# qhasm: float6464 0t9 *= ONE_THREE
# asm 1: mulpd ONE_THREE,<0t9=int6464#13
# asm 2: mulpd ONE_THREE,<0t9=%xmm12
mov ONE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 0r9[0] += 0r9[1];0r9[1] = 0t9[0] + 0t9[1]
# asm 1: haddpd <0t9=int6464#13,<0r9=int6464#10
# asm 2: haddpd <0t9=%xmm12,<0r9=%xmm9
haddpd %xmm12,%xmm9

# qhasm: 0t10 = 0r10
# asm 1: movdqa <0r10=int6464#11,>0t10=int6464#13
# asm 2: movdqa <0r10=%xmm10,>0t10=%xmm12
movdqa %xmm10,%xmm12

# qhasm: float6464 0r10 *= THREE_MINUSONE
# asm 1: mulpd THREE_MINUSONE,<0r10=int6464#11
# asm 2: mulpd THREE_MINUSONE,<0r10=%xmm10
mov THREE_MINUSONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm10

# qhasm: float6464 0t10 *= ONE_THREE
# asm 1: mulpd ONE_THREE,<0t10=int6464#13
# asm 2: mulpd ONE_THREE,<0t10=%xmm12
mov ONE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 0r10[0] += 0r10[1];0r10[1] = 0t10[0] + 0t10[1]
# asm 1: haddpd <0t10=int6464#13,<0r10=int6464#11
# asm 2: haddpd <0t10=%xmm12,<0r10=%xmm10
haddpd %xmm12,%xmm10

# qhasm: 0t11 = 0r11
# asm 1: movdqa <0r11=int6464#12,>0t11=int6464#13
# asm 2: movdqa <0r11=%xmm11,>0t11=%xmm12
movdqa %xmm11,%xmm12

# qhasm: float6464 0r11 *= THREE_MINUSONE
# asm 1: mulpd THREE_MINUSONE,<0r11=int6464#12
# asm 2: mulpd THREE_MINUSONE,<0r11=%xmm11
mov THREE_MINUSONE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm11

# qhasm: float6464 0t11 *= ONE_THREE
# asm 1: mulpd ONE_THREE,<0t11=int6464#13
# asm 2: mulpd ONE_THREE,<0t11=%xmm12
mov ONE_THREE@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm12

# qhasm: float6464 0r11[0] += 0r11[1];0r11[1] = 0t11[0] + 0t11[1]
# asm 1: haddpd <0t11=int6464#13,<0r11=int6464#12
# asm 2: haddpd <0t11=%xmm12,<0r11=%xmm11
haddpd %xmm12,%xmm11

# qhasm: *(int128 *)(0rop +   0) =  0r0
# asm 1: movdqa <0r0=int6464#1,0(<0rop=int64#1)
# asm 2: movdqa <0r0=%xmm0,0(<0rop=%rdi)
movdqa %xmm0,0(%rdi)

# qhasm: *(int128 *)(0rop +  16) =  0r1
# asm 1: movdqa <0r1=int6464#2,16(<0rop=int64#1)
# asm 2: movdqa <0r1=%xmm1,16(<0rop=%rdi)
movdqa %xmm1,16(%rdi)

# qhasm: *(int128 *)(0rop +  32) =  0r2
# asm 1: movdqa <0r2=int6464#3,32(<0rop=int64#1)
# asm 2: movdqa <0r2=%xmm2,32(<0rop=%rdi)
movdqa %xmm2,32(%rdi)

# qhasm: *(int128 *)(0rop +  48) =  0r3
# asm 1: movdqa <0r3=int6464#4,48(<0rop=int64#1)
# asm 2: movdqa <0r3=%xmm3,48(<0rop=%rdi)
movdqa %xmm3,48(%rdi)

# qhasm: *(int128 *)(0rop +  64) =  0r4
# asm 1: movdqa <0r4=int6464#5,64(<0rop=int64#1)
# asm 2: movdqa <0r4=%xmm4,64(<0rop=%rdi)
movdqa %xmm4,64(%rdi)

# qhasm: *(int128 *)(0rop +  80) =  0r5
# asm 1: movdqa <0r5=int6464#6,80(<0rop=int64#1)
# asm 2: movdqa <0r5=%xmm5,80(<0rop=%rdi)
movdqa %xmm5,80(%rdi)

# qhasm: *(int128 *)(0rop +  96) =  0r6
# asm 1: movdqa <0r6=int6464#7,96(<0rop=int64#1)
# asm 2: movdqa <0r6=%xmm6,96(<0rop=%rdi)
movdqa %xmm6,96(%rdi)

# qhasm: *(int128 *)(0rop + 112) =  0r7
# asm 1: movdqa <0r7=int6464#8,112(<0rop=int64#1)
# asm 2: movdqa <0r7=%xmm7,112(<0rop=%rdi)
movdqa %xmm7,112(%rdi)

# qhasm: *(int128 *)(0rop + 128) =  0r8
# asm 1: movdqa <0r8=int6464#9,128(<0rop=int64#1)
# asm 2: movdqa <0r8=%xmm8,128(<0rop=%rdi)
movdqa %xmm8,128(%rdi)

# qhasm: *(int128 *)(0rop + 144) =  0r9
# asm 1: movdqa <0r9=int6464#10,144(<0rop=int64#1)
# asm 2: movdqa <0r9=%xmm9,144(<0rop=%rdi)
movdqa %xmm9,144(%rdi)

# qhasm: *(int128 *)(0rop + 160) = 0r10
# asm 1: movdqa <0r10=int6464#11,160(<0rop=int64#1)
# asm 2: movdqa <0r10=%xmm10,160(<0rop=%rdi)
movdqa %xmm10,160(%rdi)

# qhasm: *(int128 *)(0rop + 176) = 0r11
# asm 1: movdqa <0r11=int6464#12,176(<0rop=int64#1)
# asm 2: movdqa <0r11=%xmm11,176(<0rop=%rdi)
movdqa %xmm11,176(%rdi)

# qhasm: leave
add %r11,%rsp
mov %rdi,%rax
mov %rsi,%rdx
pop %rbp
ret
