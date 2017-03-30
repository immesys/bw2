# File:   dclxvi-20130329/fp2e_double.s
# Author: Ruben Niederhagen, Peter Schwabe
# Public Domain


# qhasm: enter fp2e_double_qhasm
.text
.p2align 5
.globl _fp2e_double_qhasm
.globl fp2e_double_qhasm
_fp2e_double_qhasm:
fp2e_double_qhasm:
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

# qhasm: 1t0 = TWO_TWO
# asm 1: movdqa TWO_TWO,<1t0=int6464#13
# asm 2: movdqa TWO_TWO,<1t0=%xmm12
mov TWO_TWO@GOTPCREL(%rip), %rbp
movdqa (%rbp),%xmm12

# qhasm: float6464 0r0  += 0r0
# asm 1: addpd <0r0=int6464#1,<0r0=int6464#1
# asm 2: addpd <0r0=%xmm0,<0r0=%xmm0
addpd %xmm0,%xmm0

# qhasm: float6464 0r1  *= 1t0
# asm 1: mulpd <1t0=int6464#13,<0r1=int6464#2
# asm 2: mulpd <1t0=%xmm12,<0r1=%xmm1
mulpd %xmm12,%xmm1

# qhasm: float6464 0r2  += 0r2
# asm 1: addpd <0r2=int6464#3,<0r2=int6464#3
# asm 2: addpd <0r2=%xmm2,<0r2=%xmm2
addpd %xmm2,%xmm2

# qhasm: float6464 0r3  *= 1t0
# asm 1: mulpd <1t0=int6464#13,<0r3=int6464#4
# asm 2: mulpd <1t0=%xmm12,<0r3=%xmm3
mulpd %xmm12,%xmm3

# qhasm: float6464 0r4  += 0r4
# asm 1: addpd <0r4=int6464#5,<0r4=int6464#5
# asm 2: addpd <0r4=%xmm4,<0r4=%xmm4
addpd %xmm4,%xmm4

# qhasm: float6464 0r5  *= 1t0 
# asm 1: mulpd <1t0=int6464#13,<0r5=int6464#6
# asm 2: mulpd <1t0=%xmm12,<0r5=%xmm5
mulpd %xmm12,%xmm5

# qhasm: float6464 0r6  += 0r6
# asm 1: addpd <0r6=int6464#7,<0r6=int6464#7
# asm 2: addpd <0r6=%xmm6,<0r6=%xmm6
addpd %xmm6,%xmm6

# qhasm: float6464 0r7  *= 1t0 
# asm 1: mulpd <1t0=int6464#13,<0r7=int6464#8
# asm 2: mulpd <1t0=%xmm12,<0r7=%xmm7
mulpd %xmm12,%xmm7

# qhasm: float6464 0r8  += 0r8
# asm 1: addpd <0r8=int6464#9,<0r8=int6464#9
# asm 2: addpd <0r8=%xmm8,<0r8=%xmm8
addpd %xmm8,%xmm8

# qhasm: float6464 0r9  *= 1t0 
# asm 1: mulpd <1t0=int6464#13,<0r9=int6464#10
# asm 2: mulpd <1t0=%xmm12,<0r9=%xmm9
mulpd %xmm12,%xmm9

# qhasm: float6464 0r10 += 0r10
# asm 1: addpd <0r10=int6464#11,<0r10=int6464#11
# asm 2: addpd <0r10=%xmm10,<0r10=%xmm10
addpd %xmm10,%xmm10

# qhasm: float6464 0r11 *= 1t0 
# asm 1: mulpd <1t0=int6464#13,<0r11=int6464#12
# asm 2: mulpd <1t0=%xmm12,<0r11=%xmm11
mulpd %xmm12,%xmm11

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
