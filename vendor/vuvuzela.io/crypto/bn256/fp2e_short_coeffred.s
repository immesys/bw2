# File:   dclxvi-20130329/fp2e_short_coeffred.s
# Author: Ruben Niederhagen, Peter Schwabe
# Public Domain


# qhasm: enter fp2e_short_coeffred_qhasm
.text
.p2align 5
.globl _fp2e_short_coeffred_qhasm
.globl fp2e_short_coeffred_qhasm
_fp2e_short_coeffred_qhasm:
fp2e_short_coeffred_qhasm:
push %rbp
mov %rsp,%r11
and $31,%r11
add $0,%r11
sub %r11,%rsp

# qhasm: int64 rop

# qhasm: input rop

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

# qhasm: 0r0  = *(int128 *)(rop +   0)
# asm 1: movdqa 0(<rop=int64#1),>0r0=int6464#1
# asm 2: movdqa 0(<rop=%rdi),>0r0=%xmm0
movdqa 0(%rdi),%xmm0

# qhasm: 0r1  = *(int128 *)(rop +  16)
# asm 1: movdqa 16(<rop=int64#1),>0r1=int6464#2
# asm 2: movdqa 16(<rop=%rdi),>0r1=%xmm1
movdqa 16(%rdi),%xmm1

# qhasm: 0r2  = *(int128 *)(rop +  32)
# asm 1: movdqa 32(<rop=int64#1),>0r2=int6464#3
# asm 2: movdqa 32(<rop=%rdi),>0r2=%xmm2
movdqa 32(%rdi),%xmm2

# qhasm: 0r3  = *(int128 *)(rop +  48)
# asm 1: movdqa 48(<rop=int64#1),>0r3=int6464#4
# asm 2: movdqa 48(<rop=%rdi),>0r3=%xmm3
movdqa 48(%rdi),%xmm3

# qhasm: 0r4  = *(int128 *)(rop +  64)
# asm 1: movdqa 64(<rop=int64#1),>0r4=int6464#5
# asm 2: movdqa 64(<rop=%rdi),>0r4=%xmm4
movdqa 64(%rdi),%xmm4

# qhasm: 0r5  = *(int128 *)(rop +  80)
# asm 1: movdqa 80(<rop=int64#1),>0r5=int6464#6
# asm 2: movdqa 80(<rop=%rdi),>0r5=%xmm5
movdqa 80(%rdi),%xmm5

# qhasm: 0r6  = *(int128 *)(rop +  96)
# asm 1: movdqa 96(<rop=int64#1),>0r6=int6464#7
# asm 2: movdqa 96(<rop=%rdi),>0r6=%xmm6
movdqa 96(%rdi),%xmm6

# qhasm: 0r7  = *(int128 *)(rop + 112)
# asm 1: movdqa 112(<rop=int64#1),>0r7=int6464#8
# asm 2: movdqa 112(<rop=%rdi),>0r7=%xmm7
movdqa 112(%rdi),%xmm7

# qhasm: 0r8  = *(int128 *)(rop + 128)
# asm 1: movdqa 128(<rop=int64#1),>0r8=int6464#9
# asm 2: movdqa 128(<rop=%rdi),>0r8=%xmm8
movdqa 128(%rdi),%xmm8

# qhasm: 0r9  = *(int128 *)(rop + 144)
# asm 1: movdqa 144(<rop=int64#1),>0r9=int6464#10
# asm 2: movdqa 144(<rop=%rdi),>0r9=%xmm9
movdqa 144(%rdi),%xmm9

# qhasm: 0r10 = *(int128 *)(rop + 160)
# asm 1: movdqa 160(<rop=int64#1),>0r10=int6464#11
# asm 2: movdqa 160(<rop=%rdi),>0r10=%xmm10
movdqa 160(%rdi),%xmm10

# qhasm: 0r11 = *(int128 *)(rop + 176)
# asm 1: movdqa 176(<rop=int64#1),>0r11=int6464#12
# asm 2: movdqa 176(<rop=%rdi),>0r11=%xmm11
movdqa 176(%rdi),%xmm11

# qhasm: int6464 0round

# qhasm: int6464 0carry

# qhasm: int6464 0t6

# qhasm: 0round = ROUND_ROUND
# asm 1: movdqa ROUND_ROUND,<0round=int6464#13
# asm 2: movdqa ROUND_ROUND,<0round=%xmm12
mov ROUND_ROUND@GOTPCREL(%rip), %rbp
movdqa (%rbp),%xmm12

# qhasm: 0carry = 0r11
# asm 1: movdqa <0r11=int6464#12,>0carry=int6464#14
# asm 2: movdqa <0r11=%xmm11,>0carry=%xmm13
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

# qhasm: float6464 0r0 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r0=int6464#1
# asm 2: subpd <0carry=%xmm13,<0r0=%xmm0
subpd %xmm13,%xmm0

# qhasm: float6464 0r3 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r3=int6464#4
# asm 2: subpd <0carry=%xmm13,<0r3=%xmm3
subpd %xmm13,%xmm3

# qhasm: 0t6 = 0carry
# asm 1: movdqa <0carry=int6464#14,>0t6=int6464#15
# asm 2: movdqa <0carry=%xmm13,>0t6=%xmm14
movdqa %xmm13,%xmm14

# qhasm: float6464 0t6 *= FOUR_FOUR
# asm 1: mulpd FOUR_FOUR,<0t6=int6464#15
# asm 2: mulpd FOUR_FOUR,<0t6=%xmm14
mov FOUR_FOUR@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm14

# qhasm: float6464 0r6 -= 0t6
# asm 1: subpd <0t6=int6464#15,<0r6=int6464#7
# asm 2: subpd <0t6=%xmm14,<0r6=%xmm6
subpd %xmm14,%xmm6

# qhasm: float6464 0r9 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r9=int6464#10
# asm 2: subpd <0carry=%xmm13,<0r9=%xmm9
subpd %xmm13,%xmm9

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0r11 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r11=int6464#12
# asm 2: subpd <0carry=%xmm13,<0r11=%xmm11
subpd %xmm13,%xmm11

# qhasm: 0carry = 0r1
# asm 1: movdqa <0r1=int6464#2,>0carry=int6464#14
# asm 2: movdqa <0r1=%xmm1,>0carry=%xmm13
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

# qhasm: float6464 0r2 += 0carry
# asm 1: addpd <0carry=int6464#14,<0r2=int6464#3
# asm 2: addpd <0carry=%xmm13,<0r2=%xmm2
addpd %xmm13,%xmm2

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0r1 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r1=int6464#2
# asm 2: subpd <0carry=%xmm13,<0r1=%xmm1
subpd %xmm13,%xmm1

# qhasm: 0carry = 0r3
# asm 1: movdqa <0r3=int6464#4,>0carry=int6464#14
# asm 2: movdqa <0r3=%xmm3,>0carry=%xmm13
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

# qhasm: float6464 0r4 += 0carry
# asm 1: addpd <0carry=int6464#14,<0r4=int6464#5
# asm 2: addpd <0carry=%xmm13,<0r4=%xmm4
addpd %xmm13,%xmm4

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0r3 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r3=int6464#4
# asm 2: subpd <0carry=%xmm13,<0r3=%xmm3
subpd %xmm13,%xmm3

# qhasm: 0carry = 0r5
# asm 1: movdqa <0r5=int6464#6,>0carry=int6464#14
# asm 2: movdqa <0r5=%xmm5,>0carry=%xmm13
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

# qhasm: float6464 0r6 += 0carry
# asm 1: addpd <0carry=int6464#14,<0r6=int6464#7
# asm 2: addpd <0carry=%xmm13,<0r6=%xmm6
addpd %xmm13,%xmm6

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0r5 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r5=int6464#6
# asm 2: subpd <0carry=%xmm13,<0r5=%xmm5
subpd %xmm13,%xmm5

# qhasm: 0carry = 0r7
# asm 1: movdqa <0r7=int6464#8,>0carry=int6464#14
# asm 2: movdqa <0r7=%xmm7,>0carry=%xmm13
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

# qhasm: float6464 0r8 += 0carry
# asm 1: addpd <0carry=int6464#14,<0r8=int6464#9
# asm 2: addpd <0carry=%xmm13,<0r8=%xmm8
addpd %xmm13,%xmm8

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0r7 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r7=int6464#8
# asm 2: subpd <0carry=%xmm13,<0r7=%xmm7
subpd %xmm13,%xmm7

# qhasm: 0carry = 0r9
# asm 1: movdqa <0r9=int6464#10,>0carry=int6464#14
# asm 2: movdqa <0r9=%xmm9,>0carry=%xmm13
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

# qhasm: float6464 0r10 += 0carry
# asm 1: addpd <0carry=int6464#14,<0r10=int6464#11
# asm 2: addpd <0carry=%xmm13,<0r10=%xmm10
addpd %xmm13,%xmm10

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0r9 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r9=int6464#10
# asm 2: subpd <0carry=%xmm13,<0r9=%xmm9
subpd %xmm13,%xmm9

# qhasm: 0carry = 0r0
# asm 1: movdqa <0r0=int6464#1,>0carry=int6464#14
# asm 2: movdqa <0r0=%xmm0,>0carry=%xmm13
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

# qhasm: float6464 0r1 += 0carry
# asm 1: addpd <0carry=int6464#14,<0r1=int6464#2
# asm 2: addpd <0carry=%xmm13,<0r1=%xmm1
addpd %xmm13,%xmm1

# qhasm: float6464 0carry *= V6_V6
# asm 1: mulpd V6_V6,<0carry=int6464#14
# asm 2: mulpd V6_V6,<0carry=%xmm13
mov V6_V6@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0r0 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r0=int6464#1
# asm 2: subpd <0carry=%xmm13,<0r0=%xmm0
subpd %xmm13,%xmm0

# qhasm: 0carry = 0r2
# asm 1: movdqa <0r2=int6464#3,>0carry=int6464#14
# asm 2: movdqa <0r2=%xmm2,>0carry=%xmm13
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

# qhasm: float6464 0r3 += 0carry
# asm 1: addpd <0carry=int6464#14,<0r3=int6464#4
# asm 2: addpd <0carry=%xmm13,<0r3=%xmm3
addpd %xmm13,%xmm3

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0r2 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r2=int6464#3
# asm 2: subpd <0carry=%xmm13,<0r2=%xmm2
subpd %xmm13,%xmm2

# qhasm: 0carry = 0r4
# asm 1: movdqa <0r4=int6464#5,>0carry=int6464#14
# asm 2: movdqa <0r4=%xmm4,>0carry=%xmm13
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

# qhasm: float6464 0r5 += 0carry
# asm 1: addpd <0carry=int6464#14,<0r5=int6464#6
# asm 2: addpd <0carry=%xmm13,<0r5=%xmm5
addpd %xmm13,%xmm5

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0r4 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r4=int6464#5
# asm 2: subpd <0carry=%xmm13,<0r4=%xmm4
subpd %xmm13,%xmm4

# qhasm: 0carry = 0r6
# asm 1: movdqa <0r6=int6464#7,>0carry=int6464#14
# asm 2: movdqa <0r6=%xmm6,>0carry=%xmm13
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

# qhasm: float6464 0r7 += 0carry
# asm 1: addpd <0carry=int6464#14,<0r7=int6464#8
# asm 2: addpd <0carry=%xmm13,<0r7=%xmm7
addpd %xmm13,%xmm7

# qhasm: float6464 0carry *= V6_V6
# asm 1: mulpd V6_V6,<0carry=int6464#14
# asm 2: mulpd V6_V6,<0carry=%xmm13
mov V6_V6@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0r6 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r6=int6464#7
# asm 2: subpd <0carry=%xmm13,<0r6=%xmm6
subpd %xmm13,%xmm6

# qhasm: 0carry = 0r8
# asm 1: movdqa <0r8=int6464#9,>0carry=int6464#14
# asm 2: movdqa <0r8=%xmm8,>0carry=%xmm13
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

# qhasm: float6464 0r9 += 0carry
# asm 1: addpd <0carry=int6464#14,<0r9=int6464#10
# asm 2: addpd <0carry=%xmm13,<0r9=%xmm9
addpd %xmm13,%xmm9

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0r8 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r8=int6464#9
# asm 2: subpd <0carry=%xmm13,<0r8=%xmm8
subpd %xmm13,%xmm8

# qhasm: 0carry = 0r10
# asm 1: movdqa <0r10=int6464#11,>0carry=int6464#14
# asm 2: movdqa <0r10=%xmm10,>0carry=%xmm13
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

# qhasm: float6464 0r11 += 0carry
# asm 1: addpd <0carry=int6464#14,<0r11=int6464#12
# asm 2: addpd <0carry=%xmm13,<0r11=%xmm11
addpd %xmm13,%xmm11

# qhasm: float6464 0carry *= V_V
# asm 1: mulpd V_V,<0carry=int6464#14
# asm 2: mulpd V_V,<0carry=%xmm13
mov V_V@GOTPCREL(%rip), %rbp
mulpd (%rbp),%xmm13

# qhasm: float6464 0r10 -= 0carry
# asm 1: subpd <0carry=int6464#14,<0r10=int6464#11
# asm 2: subpd <0carry=%xmm13,<0r10=%xmm10
subpd %xmm13,%xmm10

# qhasm: *(int128 *)(rop +   0) =  0r0
# asm 1: movdqa <0r0=int6464#1,0(<rop=int64#1)
# asm 2: movdqa <0r0=%xmm0,0(<rop=%rdi)
movdqa %xmm0,0(%rdi)

# qhasm: *(int128 *)(rop +  16) =  0r1
# asm 1: movdqa <0r1=int6464#2,16(<rop=int64#1)
# asm 2: movdqa <0r1=%xmm1,16(<rop=%rdi)
movdqa %xmm1,16(%rdi)

# qhasm: *(int128 *)(rop +  32) =  0r2
# asm 1: movdqa <0r2=int6464#3,32(<rop=int64#1)
# asm 2: movdqa <0r2=%xmm2,32(<rop=%rdi)
movdqa %xmm2,32(%rdi)

# qhasm: *(int128 *)(rop +  48) =  0r3
# asm 1: movdqa <0r3=int6464#4,48(<rop=int64#1)
# asm 2: movdqa <0r3=%xmm3,48(<rop=%rdi)
movdqa %xmm3,48(%rdi)

# qhasm: *(int128 *)(rop +  64) =  0r4
# asm 1: movdqa <0r4=int6464#5,64(<rop=int64#1)
# asm 2: movdqa <0r4=%xmm4,64(<rop=%rdi)
movdqa %xmm4,64(%rdi)

# qhasm: *(int128 *)(rop +  80) =  0r5
# asm 1: movdqa <0r5=int6464#6,80(<rop=int64#1)
# asm 2: movdqa <0r5=%xmm5,80(<rop=%rdi)
movdqa %xmm5,80(%rdi)

# qhasm: *(int128 *)(rop +  96) =  0r6
# asm 1: movdqa <0r6=int6464#7,96(<rop=int64#1)
# asm 2: movdqa <0r6=%xmm6,96(<rop=%rdi)
movdqa %xmm6,96(%rdi)

# qhasm: *(int128 *)(rop + 112) =  0r7
# asm 1: movdqa <0r7=int6464#8,112(<rop=int64#1)
# asm 2: movdqa <0r7=%xmm7,112(<rop=%rdi)
movdqa %xmm7,112(%rdi)

# qhasm: *(int128 *)(rop + 128) =  0r8
# asm 1: movdqa <0r8=int6464#9,128(<rop=int64#1)
# asm 2: movdqa <0r8=%xmm8,128(<rop=%rdi)
movdqa %xmm8,128(%rdi)

# qhasm: *(int128 *)(rop + 144) =  0r9
# asm 1: movdqa <0r9=int6464#10,144(<rop=int64#1)
# asm 2: movdqa <0r9=%xmm9,144(<rop=%rdi)
movdqa %xmm9,144(%rdi)

# qhasm: *(int128 *)(rop + 160) = 0r10
# asm 1: movdqa <0r10=int6464#11,160(<rop=int64#1)
# asm 2: movdqa <0r10=%xmm10,160(<rop=%rdi)
movdqa %xmm10,160(%rdi)

# qhasm: *(int128 *)(rop + 176) = 0r11
# asm 1: movdqa <0r11=int6464#12,176(<rop=int64#1)
# asm 2: movdqa <0r11=%xmm11,176(<rop=%rdi)
movdqa %xmm11,176(%rdi)

# qhasm: leave
add %r11,%rsp
mov %rdi,%rax
mov %rsi,%rdx
pop %rbp
ret
