.data
resultfile:.asciiz "result.txt"
filename: .asciiz "input.txt"
prefixfile: .asciiz "prefix.txt"
postfixfile:.asciiz "postfix.txt"
temp:.asciiz "temp"
enter:.ascii "\r\n"
buff: .space 100
postfix: .space 100
tempreverse:.space 100
tempreverse2:.space 100
reversedbuff: .space 100
prefix: .space 100
tempbuff:.space 1
stack: .space 100
reversedstack:.space 100
calstack:.space 100
tempcalbuff:.space 100
result:.space 100
.text
.globl  main
main:
#Mo file prefix.txt
li $v0, 13
la $a0, prefixfile
li $a1, 9
li $a2, 0
syscall
move $t9, $v0

#Mo file postfix.txt
li $v0, 13
la $a0, postfixfile
li $a1, 9
li $a2, 0
syscall
move $t7, $v0

#Mo file result.txt
li $v0, 13
la $a0, resultfile
li $a1, 9
li $a2, 0
syscall
move $t4, $v0

#mo file input
li $v0, 13
la $a0, filename
li $a1, 0
li $a2, 0
syscall

#Luu file descriptor vao a0
move $a0, $v0
la $s0, buff #Luu dia chi buff vao $s0
la $s1, tempbuff

#Doc file	
ReadAllLines:

	jal ReadLine
	la $s0, buff #Luu dia chi buff vao $s0
	bne $v0, 0 , ReadAllLines #So sanh neu $t2 la ki tu ket thuc thi nhay sang out
	j out

#Thu tuc doc tung dong
ReadLine:
	li $v0, 14 #Syscall doc file
	la $a1, tempbuff
	li $a2, 1
	syscall

	lb $t2, 0($s1) #Load 1 byte tu tempbuff vao $t2
	sb $t2, 0($s0)
	addi $s0, $s0, 1 #Tang vung nho buff len 1 don vi
	addi $t8, $t8, 1 #Bien dem
	
	bne $t2, 10, ReadLine #So sanh neu ki tu vua doc la ki tu xuong dong thi dung
	
	beq $v0, 0, out
	
	#xem thanh ghi $t0 nhu la stack
	#xem thanh ghi $t0 nhu la stack
	addi $sp, $sp, -24
	sw $a0, 0($sp)
	sw $v0, 4($sp)
	sw $ra, 8($sp)
	sw $t7, 12($sp)
	sw $t9, 16($sp)
	sw $t4, 20($sp)	

	sub $s0, $s0, $t8 #tro ve vi tri ban dau cua chuoi buff
	add $a0, $0, $s0	

	add $t6, $0, $0 #Reset bien dem so phan tu trong stack
	la $t0, stack #Reset lai con tro vao stack
	la $s3, postfix #reset lai con tro vao postfix buffer
	
	jal toPostFix #Chuyen sang hau to
	
	lw $a0, 0($sp)
	lw $v0, 4($sp)
	lw $ra, 8($sp)
	lw $t7, 12($sp)
	lw $t9, 16($sp)
	lw $t4, 20($sp)	
	
	addi $sp, $sp, 24

	
	
	#in vao file postfix.txt
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $v0, 12($sp)
	sw $ra, 16($sp)

	la $a0, postfix
	jal strlen
	add $a0, $0, $t7
	la $a1, postfix
	add $a2, $0, $v0
	addi $a2, $a2, 1
	li $v0, 15
	syscall

	la $a1, enter
	la $a2, 2
	li $v0, 15
	syscall

	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $v0, 12($sp)
	lw $ra, 16($sp)
	
	addi $sp, $sp, 20

	#Tinh gia tri bieu thuc
	addi $sp, $sp, -36
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	sw $v0, 12($sp)
	sw $a2, 16($sp)
	sw $a3, 20($sp)
	sw $t7, 24($sp)
	sw $t9, 28 ($sp)
	sw $t4, 32($sp)

	la $a0, postfix
	jal strlen
	add $a1,$0,  $v0 #Chieu dai chuoi postfix
	la $a2, tempcalbuff
	la $a3, calstack
	la $s7, result #Chuoi ket qua
	la $a0, postfix
	jal equationCal

	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	lw $v0, 12($sp)
	lw $a2, 16($sp)
	lw $a3, 20($sp)
	lw $t7, 24($sp)
	lw $t9, 28 ($sp)
	lw $t4, 32($sp)
	addi $sp, $sp, 36


	#in vao file result.txt
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $v0, 12($sp)
	sw $ra, 16($sp)

	la $a0, result
	jal strlen
	add $a0, $t4, $0
	la $a1, result
	add $a2, $0, $v0
	addi $a2, $a2, 1
	li $v0, 15
	syscall

	la $a1, enter
	la $a2, 2
	li $v0, 15
	syscall

	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $v0, 12($sp)
	lw $ra, 16($sp)
	
	addi $sp, $sp, 20
	
	#Dao nguoc chuoi bieu thuc de chuan bi cho prefix
	addi $sp, $sp, -24
	sw $a0, 0($sp)
	sw $v0, 4($sp)
	sw $ra, 8($sp)
	sw $t7, 12($sp)
	sw $t9, 16($sp)
	sw $t4, 20($sp)	

	add $v0, $0, $t8 #Thanh ghi $v0 chua so ki tu cua chuoi bieu thuc
	#subi $v0, $v0, 2
	la $a0, buff #Thanh ghi $a0 chua dia chi cua chuoi bieu thuc
	la $a1, tempreverse
	la $a2, tempreverse2
	la $s5, reversedbuff #Chuoi ket qua
	
	jal toReversedEquation #Chuyen sang bieu thuc nguoc
	
	lw $a0, 0($sp)
	lw $v0, 4($sp)
	lw $ra, 8($sp)
	lw $t7, 12($sp)
	lw $t9, 16($sp)	
	lw $t4, 20($sp)	
	addi $sp, $sp, 24

	#Chuyen bieu thuc nguoc sang hau to:
	addi $sp, $sp, -24
	sw $a0, 0($sp)
	sw $v0, 4($sp)
	sw $ra, 8($sp)
	sw $t7, 12($sp)
	sw $t9, 16($sp)		
	sw $t4, 20($sp)	
	
	la $a0, reversedbuff

	add $t6, $0, $0 #Reset bien dem so phan tu trong stack
	la $t0, reversedstack #Reset lai con tro vao stack
	la $s3, prefix #reset lai con tro vao postfix buffer
	
	jal toPostFix #Chuyen sang hau to

	addi $t7, $0, 10
	sb $t7, 0($s3)
	addi $s3, $s3, 1

	lw $a0, 0($sp)
	lw $v0, 4($sp)
	lw $ra, 8($sp)
	lw $t7, 12($sp)
	lw $t9, 16($sp)
	lw $t4, 20($sp)		
	addi $sp, $sp, 24

	#Reverse chuoi prefix
	
	addi $sp, $sp, -24
	sw $a0, 0($sp)
	sw $v0, 4($sp)
	sw $ra, 8($sp)
	sw $t7, 12($sp)
	sw $t9, 16($sp)	
	sw $t4, 20($sp)	

	add $v0, $0, $t8 #Thanh ghi $v0 chua so ki tu cua chuoi bieu thuc
	#subi $v0, $v0, 2
	la $a0, prefix #Thanh ghi $a0 chua dia chi cua chuoi bieu thuc

	la $a0, tempreverse
	addi $a1, $0, 100
	jal emptySpace

	la $a0, tempreverse2
	addi $a1, $0, 100
	jal emptySpace

	la $a0, reversedbuff
	addi $a1, $0, 100
	jal emptySpace

	la $a1, tempreverse
	la $a2, tempreverse2
	la $s5, reversedbuff #Chuoi ket qua
	
	la $a0, prefix
	jal strlen
	la $a0, prefix
	jal toReversedEquation.FromReversed #Chuyen sang bieu thuc nguoc
	
	lw $a0, 0($sp)
	lw $v0, 4($sp)
	lw $ra, 8($sp)
	lw $t7, 12($sp)
	lw $t9, 16($sp)	
	lw $t4, 20($sp)	
	addi $sp, $sp, 24

	#In vao file prefix.txt
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $v0, 12($sp)
	sw $ra, 16($sp)

	la $a0, reversedbuff
	jal strlen
	add $a0, $0, $t9
	la $a1, reversedbuff
	add $a2, $0, $v0
	addi $a2, $a2, 1
	li $v0, 15
	syscall

	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $v0, 12($sp)
	lw $ra, 16($sp)
	
	addi $sp, $sp, 20

	
	#Goi ham empty chuoi (buff) cho lan xu li tiep theo
	addi $sp, $sp, -8
	sw $a0, 0($sp)# luu file descriptor
	sw $ra, 4($sp) # luu dia chi tra ve
	
	la $a0, buff #luu dia chi buff vao $a0 de goi ham
	addi $a1,$0, 100 #$a1 dung lam bien dem
	jal emptySpace	
	
	la $a0, postfix
	addi $a1, $0, 100
	jal emptySpace

	la $a0, stack
	addi $a1, $0, 100
	jal emptySpace

	la $a0, reversedbuff
	addi $a1, $0, 100
	jal emptySpace

	la $a0, tempreverse
	addi $a1, $0, 100
	jal emptySpace

	la $a0, tempreverse2
	addi $a1, $0, 100
	jal emptySpace


	la $a0, reversedstack
	addi $a1, $0, 100
	jal emptySpace

	la $a0, prefix
	addi $a1, $0, 100
	jal emptySpace

	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8


	add $t8, $0, $0 #reset lai bien dem t1
	
	jr $ra
	#Thanh ghi $v0 luc nay se ghi lai so ki tu doc duoc

equationCal:

	lb $t7, 0($a0) #Doc ki tu moi va xu ly
	beq $t7, 0, equationCal.exit #Da doc het chuoi
	add $t0, $0, $t7
	addi $a0, $a0, 1 #Cong dia chi buff len 1
	
	subi $a1, $a1, 1 #Tru bien dem di 1
	beq $t7, 32, tempcalbuff.check #Da doc den dau cach, nhay den ham kiem tra la toan tu hay toan hang

	sb $t7, 0($a2) #Chua gap dau bang thi add vao tempcalbuff
	addi $a2, $a2, 1 #Cong dia chi tempcalbuff len 1


	j equationCal

equationCal.exit:

	#Kiem tra truoc khi ket thuc chuoi
	#$t7 luc nay chua toan tu cuoi cung
	add $t7, $t0, $t7
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal calstack.poptwo.final
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	
	addi $a3, $a3, 4 #Cong vung nho stack len 4 de lay dinh stack
	lw $t7, 96($a3) #Lay dinh stack (la ket qua)
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	addi $a0, $t7, 0
	la $a1, result
	jal intToString
	
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12

	jr $ra
tempcalbuff.check:
	subi $a2, $a2, 1
	lb $t7, 0($a2)
	addi $t0, $0, 48
	slt $t6, $t7, $t0 
	beq $t6, 1, calstack.poptwo #Neu la toan tu thi pop 2 toan hang ra va tinh
	#Con neu la toan hang thi chuyen qua so int va push vao stack
	add $t5, $0, $ra
	add $t4, $a0, $0
	add $t3, $v0, $0
	la $a0, tempcalbuff
	jal atoi

	
	sw $v0, 96($a3) #luu vao stack
	subi $a3, $a3, 4

	#Sau khi push vao stack thi empty chuoi tam
	addi $sp, $sp, -8
	sw $a0, 0($sp)# luu file descriptor
	sw $ra, 4($sp) # luu dia chi tra ve
	
	la $a0, tempcalbuff #luu dia chi buff vao $a0 de goi ham
	addi $a1,$0, 12 #$a1 dung lam bien dem
	jal emptySpace	
	
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	#Reset lai cac bien tam
	add $ra, $0, $t5
	add $a0, $0, $t4
	add $v0, $0, $t3
	la $a2, tempcalbuff #reset lai vi tri
	j equationCal
calstack.poptwo:
	addi $a3, $a3, 4
	lw $t2, 96($a3)
	addi $a3, $a3, 4
	lw $t1, 96($a3)
	beq $t7, 43, addInt
	beq $t7, 45, subInt
	beq $t7, 42, multInt
	beq $t7, 47, divInt
addInt:
	add $t0, $t2, $t1
	sw $t0, 96($a3)
	subi $a3, $a3, 4
	j equationCal
subInt:
	sub $t0, $t1, $t2
	sw $t0, 96($a3)
	subi $a3, $a3, 4
	j equationCal
multInt:
	mult $t2, $t1
	mflo $t0
	sw $t0, 96($a3)
	subi $a3, $a3, 4
	j equationCal
divInt:
	div $t1, $t2
	mflo $t0
	sw $t0, 96($a3)
	subi $a3, $a3, 4
	j equationCal

calstack.poptwo.final:
	addi $a3, $a3, 4
	lw $t2, 96($a3)
	addi $a3, $a3, 4
	lw $t1, 96($a3)
	beq $t7, 43, addInt.final
	beq $t7, 45, subInt.final
	beq $t7, 42, multInt.final
	beq $t7, 47, divInt.final
addInt.final:
	add $t0, $t2, $t1
	sw $t0, 96($a3)
	subi $a3, $a3, 4
	jr $ra
subInt.final:
	sub $t0, $t1, $t2
	sw $t0, 96($a3)
	subi $a3, $a3, 4
	jr $ra
multInt.final:
	mult $t2, $t1
	mflo $t0
	sw $t0, 96($a3)
	subi $a3, $a3, 4
	jr $ra
divInt.final:
	div $t1, $t2
	mflo $t0
	sw $t0, 96($a3)
	subi $a3, $a3, 4
	jr $ra
atoi: #Ham doi string qua interger
    or      $v0, $zero, $zero   # num = 0
    or      $t1, $zero, $zero   # isNegative = false
    lb      $t0, 0($a0)
    bne     $t0, '+', .isp      # consume a positive symbol
    addi    $a0, $a0, 1
.isp:
    lb      $t0, 0($a0)
    bne     $t0, '-', .num
    addi    $t1, $zero, 1       # isNegative = true
    addi    $a0, $a0, 1
.num:
    lb      $t0, 0($a0)
    slti    $t2, $t0, 58        # *str <= '9'
    slti    $t3, $t0, '0'       # *str < '0'
    beq     $t2, $zero, .done
    bne     $t3, $zero, .done
    sll     $t2, $v0, 1
    sll     $v0, $v0, 3
    add     $v0, $v0, $t2       # num *= 10, using: num = (num << 3) + (num << 1)
    addi    $t0, $t0, -48
    add     $v0, $v0, $t0       # num += (*str - '0')
    addi    $a0, $a0, 1         # ++num
    j   .num
.done:
    beq     $t1, $zero, .out    # if (isNegative) num = -num
    sub     $v0, $zero, $v0
.out:
    jr      $ra         # return
		


toReversedEquation:
	#$v0 chua so ki tu cua chuoi
	#$a0 chua dia chi cua chuoi
	#Tien hanh doc chuoi bieu thuc tu trai sang phai
	add $t9, $ra, $0 #Luu dia chi thanh ghi $ra
	subi $v0, $v0, 1
	jal reverseEquation
	
	#Den day thi reversedbuff chua chuoi bieu thuc da dao nguoc

#Ham reverse bieu thuc, khong lam thay doi gia tri cua toan hang
reverseEquation:
	beq $v0, -1, reverseEquation.exit1
	lb $t1, buff($v0) #Chuoi bieu thuc can dao nguoc
	subi $v0, $v0, 1 #Giam vi tri di 1
	beq $t1, 10, reverseEquation #Da doc het chuoi
	
	addi $t7, $0, 48
	beq $t1, 40, leftToRightBracket #Dao dau ngoac
	beq $t1, 41, rightToLeftBracket 	#Dao dau ngoac
	slt $t6, $t1, $t7 #Neu dung thi $t1 la toan tu
	beq $t6, 1, prefix.Operator

	#Neu khong la toan tu thi la toan hang
	addi $t4, $t4, 1 #Do dai chuoi cong len 1
	sb $t1, 0($a1) #Luu vao chuoi tempreverse
	addi $a1, $a1, 1 #Cong dia chi len 1

	j reverseEquation

leftToRightBracket:
	addi $t1, $0, 41
	j prefix.Operator
rightToLeftBracket:
	addi $t1, $0, 40
	j prefix.Operator
reverseEquation.exit1:
	add $v0, $t4, $0
	la $a0, tempreverse
	jal reverse #reverse chuoi tam
	la $a2, tempreverse2
	j reverseEquation.exit2
reverseEquation.exit2:
	#Ket qua reverse cua chuoi tam hien tai se o trong buffer tempreverse2
	lb $t7, 0($a2)
	addi $a2, $a2, 1
	beqz $t7, reverseEquation.exitConfirm	#Neu da het chuoi tam thi tiep tuc voi ki tu tiep theo
	sb $t7, 0($s5)
	addi $s5, $s5, 1
	j reverseEquation.exit2
reverseEquation.exitConfirm:
	add $t7, $0, 10
	sb $t7, 0($s5)
	addi $s5, $s5, 1
	add $ra, $0, $t9 #Luu dia chi thanh ghi $ra
	jr $ra
prefix.Operator:
	add $s2, $0, $a0 #Luu de khoi phuc
	add $s4, $0, $v0
	add $s6, $ra, $0 #Luu thanh ghi $ra

	add $v0, $t4, $0
	la $a0, tempreverse
	jal reverse #reverse chuoi tam

	add $ra, $0, $s6
	add $a0, $s2, $0
	add $v0, $s4, $0
	
	#Thuc hien copy chuoi 
	j copyToReversedString
	
	
copyToReversedString:
	#Ket qua reverse cua chuoi tam hien tai se o trong buffer tempreverse2
	lb $t7, 0($a2)
	addi $a2, $a2, 1
	beqz $t7, copyToReversedString.exit	#Neu da het chuoi tam thi tiep tuc voi ki tu tiep theo
	sb $t7, 0($s5)
	addi $s5, $s5, 1
	j copyToReversedString
copyToReversedString.exit:
	
	sb $t1, 0($s5) #Copy toan tu vao chuoi
	addi $s5, $s5, 1

	
	#Empty chuoi

	addi $sp, $sp, -8
	sw $a0, 0($sp)# luu file descriptor
	sw $ra, 4($sp) # luu dia chi tra ve
		
	la $a0, tempreverse
	addi $a1, $0, 100
	jal emptySpace

	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	addi $sp, $sp, -8
	sw $a0, 0($sp)# luu file descriptor
	sw $ra, 4($sp) # luu dia chi tra ve
		
	la $a0, tempreverse2
	addi $a1, $0, 100
	jal emptySpace

	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8

	add $t4, $0, $0 #reset bien dem do dai chuoi tempreverse
	la $a1, tempreverse #Reset Thanh $a1 chua chuoi tam
	la $a2, tempreverse2 #Reset thanh $a2 chua chuoi tam dao nguoc

	j reverseEquation


toReversedEquation.FromReversed:
	#$v0 chua so ki tu cua chuoi
	#$a0 chua dia chi cua chuoi
	#Tien hanh doc chuoi bieu thuc tu trai sang phai
	add $t9, $ra, $0 #Luu dia chi thanh ghi $ra
	subi $v0, $v0, 1
	jal reverseEquation.FromReversed
	
	#Den day thi reversedbuff chua chuoi bieu thuc da dao nguoc

#Ham reverse bieu thuc, khong lam thay doi gia tri cua toan hang
reverseEquation.FromReversed:
	beq $v0, -1, reverseEquation.exit1.FromReversed
	lb $t1, prefix($v0) #Chuoi bieu thuc can dao nguoc
	subi $v0, $v0, 1 #Giam vi tri di 1
	beq $t1, 10, reverseEquation.FromReversed #Da doc het chuoi
	
	addi $t7, $0, 48
	beq $t1, 40, leftToRightBracket.FromReversed #Dao dau ngoac
	beq $t1, 41, rightToLeftBracket.FromReversed 	#Dao dau ngoac
	slt $t6, $t1, $t7 #Neu dung thi $t1 la toan tu
	beq $t6, 1, prefix.Operator.FromReversed

	#Neu khong la toan tu thi la toan hang
	addi $t4, $t4, 1 #Do dai chuoi cong len 1
	sb $t1, 0($a1) #Luu vao chuoi tempreverse
	addi $a1, $a1, 1 #Cong dia chi len 1

	j reverseEquation.FromReversed

leftToRightBracket.FromReversed:
	addi $t1, $0, 41
	j prefix.Operator.FromReversed
rightToLeftBracket.FromReversed:
	addi $t1, $0, 40
	j prefix.Operator.FromReversed
reverseEquation.exit1.FromReversed:
	add $v0, $t4, $0
	la $a0, tempreverse
	jal reverse #reverse chuoi tam
	la $a2, tempreverse2
	j reverseEquation.exit2.FromReversed
reverseEquation.exit2.FromReversed:
	#Ket qua reverse cua chuoi tam hien tai se o trong buffer tempreverse2
	lb $t7, 0($a2)
	addi $a2, $a2, 1
	beqz $t7, reverseEquation.exitConfirm.FromReversed	#Neu da het chuoi tam thi tiep tuc voi ki tu tiep theo
	sb $t7, 0($s5)
	addi $s5, $s5, 1
	j reverseEquation.exit2.FromReversed
reverseEquation.exitConfirm.FromReversed:
	add $t7, $0, 10
	sb $t7, 0($s5)
	addi $s5, $s5, 1
	add $ra, $0, $t9 #Luu dia chi thanh ghi $ra
	jr $ra
prefix.Operator.FromReversed:
	add $s2, $0, $a0 #Luu de khoi phuc
	add $s4, $0, $v0
	add $s6, $ra, $0 #Luu thanh ghi $ra

	add $v0, $t4, $0
	la $a0, tempreverse
	jal reverse #reverse chuoi tam

	add $ra, $0, $s6
	add $a0, $s2, $0
	add $v0, $s4, $0
	
	#Thuc hien copy chuoi 
	j copyToReversedString.FromReversed
	
	
copyToReversedString.FromReversed:
	#Ket qua reverse cua chuoi tam hien tai se o trong buffer tempreverse2
	lb $t7, 0($a2)
	addi $a2, $a2, 1
	beqz $t7, copyToReversedString.exit.FromReversed	#Neu da het chuoi tam thi tiep tuc voi ki tu tiep theo
	sb $t7, 0($s5)
	addi $s5, $s5, 1
	j copyToReversedString.FromReversed
copyToReversedString.exit.FromReversed:
	
	sb $t1, 0($s5) #Copy toan tu vao chuoi
	addi $s5, $s5, 1

	
	#Empty chuoi

	addi $sp, $sp, -8
	sw $a0, 0($sp)# luu file descriptor
	sw $ra, 4($sp) # luu dia chi tra ve
		
	la $a0, tempreverse
	addi $a1, $0, 100
	jal emptySpace

	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	addi $sp, $sp, -8
	sw $a0, 0($sp)# luu file descriptor
	sw $ra, 4($sp) # luu dia chi tra ve
		
	la $a0, tempreverse2
	addi $a1, $0, 100
	jal emptySpace

	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8

	add $t4, $0, $0 #reset bien dem do dai chuoi tempreverse
	la $a1, tempreverse #Reset Thanh $a1 chua chuoi tam
	la $a2, tempreverse2 #Reset thanh $a2 chua chuoi tam dao nguoc

	j reverseEquation.FromReversed



#Ham reverse dao nguoc chuoi
reverse:
	
	add	$t7, $0, $v0		#$t7: do dai chuoi
	subi $t7, $t7, 1
	add	$t2, $0, $a0		#$t2: dia chi goc cua chuoi
	li	$t5, 0	#i=0		#$t5: khoi tao bien dem = 0
	li	$t3, 0			#$t3: dia chi phan tu dau tien hien tai cua chuoi

reverse_loop:
	add	$t3, $t2, $t5		# dia chi cua chuoi o vong lap hien tai
	lb	$t4, 0($t3)		# load 1 byte vao $t4
	beq $t4, 40, bracket.leftToRight #Chuyen tu ngoac trai sang ngoac phai
	beq $t4, 41, bracket.rightToLeft #Chuyen tu ngoac phai sang ngoac trai
	beq	$t4,0,  reverse.exit			# neu la ki tu null thi exit
	sb	$t4, tempreverse2($t7)	# ghi de len byte nay vao bo nho
	subi	$t7, $t7, 1		# Giam chieu dai cua chuoi di 1 (j--)
	addi	$t5, $t5, 1		# bien dem tang len 1 (i++)
	j	reverse_loop
	
bracket.leftToRight:
	addi $t4, $0, 41
	sb	$t4,tempreverse2($t7)	# ghi de len byte nay vao bo nho
	subi	$t7, $t7, 1		# Giam chieu dai cua chuoi di 1 (j--)
	addi	$t5, $t5, 1		# bien dem tang len 1 (i++)
	j	reverse_loop	

bracket.rightToLeft:
	addi $t4, $0, 40
	sb	$t4,tempreverse2($t7)	# ghi de len byte nay vao bo nho
	subi	$t7, $t7, 1		# Giam chieu dai cua chuoi di 1 (j--)
	addi	$t5, $t5, 1		# bien dem tang len 1 (i++)
	j	reverse_loop
	
reverse.exit:
	jr $ra

#ham emptySpace nhan 2 tham so la $a0 dia chi cua buff va $a1 chua so ki tu duoc luu vao buff
emptySpace:
	sb $0, 0($a0)
	subi $a1, $a1, 1
	addi $a0, $a0, 1
	bne $a1,0, emptySpace
	jr $ra

toPostFix: #Ham lay ki tu tu chuoi, va tra ve thu tu uu tien cua no
	#Thu tu uu tien cua toan tu : 
	#-1. Dau ngoac dong
	# 1. Dau ngoac mo 
	#2.Dau +,-  
	#3. Dau *,/
	
	lb $a1, 0($a0)
	addi $a0, $a0, 1 #Cong vung nho $a0 len 1
	j token.Compare
token.Compare:
	beq $a1, 13, toPostFix
	beq $a1, 10, toPostFix.exit #Neu da het chuoi, pop toan bo phan con lai trong stack va exit ham
	beq $a1, 40, tokenChecker.leftBracket #dau ngoac mo
	beq $a1, 41, tokenChecker.pop #dau ngoac dong
	beq $a1, 43, tokenChecker.add #dau cong
	beq $a1, 45, tokenChecker.sub #dau tru
	beq $a1, 42, tokenChecker.mult #dau nhan
	beq $a1, 47, tokenChecker.div #dau chia

	#neu khong phai la toan tu thi la toan hang,push lien vao bieu thuc
	sb $a1, 0($s3)
	addi $s3, $s3, 1 #Cong vung nho chuoi postfix len 1

	j toPostFix #Lap tiep tuc

toPostFix.exit:
	addi $t0, $t0, 1
	lb $t2, 99($t0)

	beq $t2, 0, toPostFix.exitJump #Neu da pop het stack

	addi $t7, $0, 32 #Them Dau khoang cach
	sb $t7, 0($s3)
	addi $s3, $s3, 1

	sb $0, 99($t0) #Empty dinh stack
	sb $t2, 0($s3) #Dua ki tu vua pop vao chuoi postfix
	addi $s3, $s3, 1 #Cong vung nho chuoi
	
	subi $t6, $t6, 1
	j toPostFix.exit

toPostFix.exitJump:

	jr $ra

tokenChecker.leftBracket: #Gap ngoac trai thi push vao stack
	sb $a1, 99($t0) #Push vao dinh stack
	sub $t0, $t0, 1
	addi $t6, $t6, 1
	j toPostFix #Nhay den ham doc ki tu tiep theo

tokenChecker.pop:

	addi $t0, $t0, 1
	lb $t1, 99($t0) #Load phan tu
	beq $t1, 40, stack.popExit #Khi da gap dau ngoac mo thi pop va tiep tuc doc phan tu tiep theo cua chuoi

	#Neu khong thi cu pop va luu vao chuoi postfix cho toi khi gap ngoac mo
	addi $t7, $0, 32 #Them Dau khoang cach
	sb $t7, 0($s3)
	addi $s3, $s3, 1

	sb $t1, 0($s3)
	addi $s3, $s3, 1
	sb $0, 99($t0)
	subi $t6, $t6, 1 #Tru bien dem di 1
	j tokenChecker.pop
	
stack.popExit:

	sb $0, 99($t0)
	subi $t6, $t6, 1
	j toPostFix

tokenChecker.add:
	addi $t7, $0, 32 #Them Dau khoang cach
	sb $t7, 0($s3)
	addi $s3, $s3, 1
	addi $v1,$0,1
	move $v0, $a1
	j tokenChecker.push

tokenChecker.sub:
	addi $t7, $0, 32 #Them Dau khoang cach
	sb $t7, 0($s3)
	addi $s3, $s3, 1
	addi $v1,$0,1
	move $v0, $a1
	j tokenChecker.push

tokenChecker.mult:
	addi $t7, $0, 32 #Them Dau khoang cach
	sb $t7, 0($s3)
	addi $s3, $s3, 1
	addi $v1,$0,2
	move $v0, $a1
	j tokenChecker.push

tokenChecker.div:
	addi $t7, $0, 32 #Them Dau khoang cach
	sb $t7, 0($s3)
	addi $s3, $s3, 1
	addi $v1,$0,2
	move $v0, $a1
	j tokenChecker.push

tokenChecker.push:
	
	add $t2, $0, $v0 #t2 chua ki tu vua get
	add $t3, $0, $v1 #t3 chua do uu tien cua ki tu do

	beq $t6, 0, pushToEmptyStack #Bien t6 dem so luong phan tu trong stack

	addi $t0, $t0, 1
	lb $a1, 99($t0) #Lay phan tu o dinh stack
	add $t4, $0, $ra #Luu thanh ghi $ra
	
	jal 	tokenFromStackChecker.compare #Ham tinh do uu tien cua toan tu dinh stack
	add $ra, $0, $t4 #Khoi phuc thanh ghi $ra

	beq $v1, $t3, stack.popAndPush #Bang thu tu
	slt $t5, $t3, $v1
	beq $t5, 1, stack.popAndPush	#Thu tu dinh stack lon hon

	#Neu thu tu o dinh stack lon hon thi push ki tu vao stack binh thuong
	sub $t0, $t0, 1 #Tro lai vi tri dinh stack rong
	sb $t2, 99($t0)
	sub $t0, $t0, 1
	addi $t6, $t6, 1 #Cong so phan tu len 1

	j toPostFix
	pushToEmptyStack: #Neu stack rong thi push truc tiep toan tu vao stack
	sb $t2, 99($t0)
	sub $t0, $t0, 1
	addi $t6, $t6, 1 #Cong bien dem phan tu stack len 1

	j toPostFix

stack.popAndPush:

	sb $v0, 0($s3) #Luu toan tu o dinh vao chuoi postfix
	addi $s3, $s3, 1
	sb $0, 99($t0) #Ghi de toan tu vao dinh stack
	add $v0, $0, $t2
	add $v1, $0, $t3
	addi $t7, $0, 32 #Them Dau khoang cach
	sb $t7, 0($s3)
	addi $s3, $s3, 1
	j tokenChecker.push

tokenFromStackChecker.compare:
	
	beq $a1, 40, tokenFromStackChecker.leftBracket #dau ngoac mo
	beq $a1, 43, tokenFromStackChecker.add #dau cong
	beq $a1, 45, tokenFromStackChecker.sub #dau tru
	beq $a1, 42, tokenFromStackChecker.mult #dau nhan
	beq $a1, 47, tokenFromStackChecker.div #dau chia
	

tokenFromStackChecker.leftBracket:
	addi $v1, $0, 0
	add $v0, $0, $a1
	jr $ra

tokenFromStackChecker.add:
	addi $v1, $0, 1
	add $v0, $0, $a1
	jr $ra

tokenFromStackChecker.sub:
	addi $v1, $0, 1
	add $v0, $0, $a1
	jr $ra

tokenFromStackChecker.mult:
	addi $v1, $0, 2
	add $v0, $0, $a1
	jr $ra

tokenFromStackChecker.div:
	addi $v1, $0, 2
	add $v0, $0, $a1
	jr $ra


strlen:
	li $t5, 0
	li $t2, 0

	strlen_loop:
		add	$t2, $a0, $t5
		lb	$t1, 0($t2)
		beqz	$t1, strlen_exit
		addiu $t5, $t5, 1
		j strlen_loop
	
	strlen_exit:
		subi	$t5, $t5, 1
		add	$v0, $0, $t5
		add	$t5, $0, $0
		jr	$ra



intToString:
  bnez $a0, intToString.non_zero  # first, handle the special case of a value of zero
  nop
  li   $t0, '0'
  sb   $t0, 0($a1)
  sb   $zero, 1($a1)
  li   $v0, 1
  jr   $ra
intToString.non_zero:
  addi $t0, $zero, 10     # now check for a negative value
  li $v0, 0
    
  bgtz $a0, intToString.recurse
  nop
  li   $t1, '-'
  sb   $t1, 0($a1)
  addi $v0, $v0, 1
  neg  $a0, $a0
intToString.recurse:
  addi $sp, $sp, -24
  sw   $fp, 8($sp)
  addi $fp, $sp, 8
  sw   $a0, 4($fp)
  sw   $a1, 8($fp)
  sw   $ra, -4($fp)
  sw   $s0, -8($fp)
  sw   $s1, -12($fp)
   
  div  $a0, $t0       # $a0/10
  mflo $s0            # $s0 = quotient
  mfhi $s1            # s1 = remainder  
  beqz $s0, intToString.write
intToString.continue:
  move $a0, $s0  
  jal intToString.recurse
  nop
intToString.write:
  add  $t1, $a1, $v0
  addi $v0, $v0, 1    
  addi $t2, $s1, 0x30 # convert to ASCII
  sb   $t2, 0($t1)    # store in the buffer
  sb   $zero, 1($t1)
  
intToString.exit:
  lw   $a1, 8($fp)
  lw   $a0, 4($fp)
  lw   $ra, -4($fp)
  lw   $s0, -8($fp)
  lw   $s1, -12($fp)
  lw   $fp, 8($sp)    
  addi $sp, $sp, 24
  jr $ra



out:
li $v0, 16
add $a0, $0, $t9
syscall

li $v0, 16
add $a0, $0, $t7
syscall

li $v0, 16
add $a0, $0, $t2
syscall

li $v0,10
syscall
