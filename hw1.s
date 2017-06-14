.data			#dataları al
theString1: 
.space 200
mazeSize:
.space 20
position:
.space 20
obsicles:
.space 200
yonler:
.space 200
.text

main:

addu	$s7, $0, $ra	# return adresi sakla
    li      $v0,8				# stringi oku
    la      $a0, theString1
   
    syscall

	la	$t0, theString1		#put string address into register
	la	$t1,mazeSize
	la	$s6,position
	la	$t3,obsicles
	la	$t4,obsicles		#obsicleın son adresi burda
	la	$t5,yonler
	la	$t6,yonler		#yönlerin son adresi burda
	
#maze sizeı al

	lb	$s0,0($t0)			
	sb 	$s0,0($t1)
	lb	$s0,2($t0)		#verilen stringden sizeı cek	
	sb 	$s0,1($t1)
	
#POSİTİONI AL

	lb	$s0,5($t0)			
	sb 	$s0,0($s6)

	lb	$s0,7($t0)		#verilen stringden positionı cek
	sb 	$s0,1($s6)


#OBSICLE
add $t0,$t0,11				#obsicle degerlerine git
L1:	
	lb $s0,0($t0)			
	sb $s0,0($t3)
	add $t0,$t0,2
	lb $s0,0($t0)			#obsicle degerlerini cek,eger # varsa bitir,yoksa loop a devam et
	sb $s0,1($t3)
	lb $s0,2($t0)
	beq 	$s0,'#',L2
	add $t3,$t3,2
	add $t0,$t0,4
	j L1	
	



L2:

	sb $s0,2($t3)   #obsicleın sonuna # koy
	add $t0,$t0,3
	
#YONLER
L3:

	lb $s0,0($t0)			
	sb $s0,0($t5)
	lb $s0,1($t0)
	beq$s0,'#',L4
	add $t5,$t5,1
	add $t0,$t0,1
	j L3
	


L4:
	
	sb $s0,1($t5)   # yönlerin sonuna # koy



#FONKSİYON ÇAĞIRMAYA BAŞLA

L5:

	move $a0,$t4  #mapsize
	move $a1,$s6  #position
	move $a2,$t4  #obsicles
	lb $a3,0($t6)  #yönler
	jal check
	move $s1,$v0
	bne $s1,1,oynama	#deger 0sa birsey yapma,1se devam
	lb  $s1,0($t6)
	beq $s1,'A',Aharek	#hareketin yonunu bul,ona gore islem yap
	beq $s1,'C',Charek
	beq $s1,'E',Eharek
	beq $s1,'G',Gharek
	beq $s1,'B',Bharek
	beq $s1,'D',Dharek
	beq $s1,'F',Fharek
	beq $s1,'H',Hharek

Hharek:

lb $s3,0($s6)				#position degerlerini yon bilgilerine gore guncelle
	add $s3,$s3,-1
	sb $s3,0($s6)

lb $s3,1($s6)
	add $s3,$s3,1
	sb $s3,1($s6)	
j oynama
Fharek:

	lb $s3,1($s6)
	add $s3,$s3,-1
	sb $s3,1($s6)	
	lb $s3,0($s6)
	add $s3,$s3,-1
	sb $s3,0($s6)	

j oynama

Dharek:
	lb $s3,1($s6)
	add $s3,$s3,-1
	sb $s3,1($s6)
	lb $s3,0($s6)
	add $s3,$s3,1
	sb $s3,0($s6)	
j oynama



Bharek:
	lb $s3,1($s6)
	add $s3,$s3,1
	sb $s3,1($s6)	
	lb $s3,0($s6)
	add $s3,$s3,1
	sb $s3,0($s6)	
j oynama




Aharek:
	lb $s3,1($s6)
	add $s3,$s3,1
	sb $s3,1($s6)	
j oynama
Charek:
	lb $s3,0($s6)
	add $s3,$s3,1
	sb $s3,0($s6)	
j oynama

Eharek:
	lb $s3,1($s6)
	add $s3,$s3,-1
	sb $s3,1($s6)	
j oynama
Gharek:
	lb $s3,0($s6)
	add $s3,$s3,-1
	sb $s3,0($s6)	
j oynama

oynama: 
	add $t6,$t6,1
	lb $s2,0($t6)
	beq  $s2,'#',bitti	# # gelmediyse loopa devam
	j L5



bitti:
li $a0, '('
li $v0, 11    # (
syscall


li $v0,11		#print pos[0]
lb $a0,0($s6)
syscall


li $a0, ','
li $v0, 11    # print ,
syscall


li $v0,11		#print pos[1]
lb $a0,1($s6)
syscall

li $a0, ')'
li $v0, 11    # print )
syscall

addu $ra, $0, $s7    # return adresi düzeltip programı bitir
	jr $ra	




check:
#a0=mapsize a1=position a2=obsicles a3=yönler
	#hangi yön olduğuna bak
beq $a3,'A',caseA
beq $a3,'C',caseC
beq $a3,'E',caseE
beq $a3,'G',caseG
beq $a3,'B',caseB
beq $a3,'D',caseD
beq $a3,'F',caseF
beq $a3,'H',caseH
caseA:

lb $s1,1($a1)			#positionın ysini al 1 artır
add $s1,$s1,1
lb $s2,1($t1)			#mapsizeın ysini al 1 çıkar			
beq $s2,$s1,faila		#sınırdan çıktıysa fail
loopA:
lb	$t7,1($a2)		
beq $s1,$t7,obschecka		#obsicle ile position aynıysa fail
aort:
lb	$s4,2($a2)		
beq $s4,'#',truea
add $a2,$a2,2

j loopA


obschecka:
lb	$s4,0($a2)		
lb	$s3,0($a1)
beq $s3,$s4,faila
j aort

caseC:

lb $s1,0($a1)			#positionın ysini 
add $s1,$s1,1
lb $s2,0($t1)			#mapsizeın ysini al 1 çıkar			
beq $s2,$s1,faila		#sınırdan çıktıysa fail
loopC:
lb	$t7,0($a2)		
beq $s1,$t7,obscheckc
cort:	#obsicle ile position aynıysa fail
lb	$s4,2($a2)		
beq $s4,'#',truea
add $a2,$a2,2

j loopC

obscheckc:
lb	$s4,1($a2)		
lb	$s3,1($a1)
beq $s3,$s4,faila
j cort



caseE:
#a0=mapsize a1=position a2=obsicles a3=yönler
lb $s1,1($a1)			#positionın ysini al 1 artır
			
beq $s1,'0',faila		#sınırdan çıktıysa fail
add $s1,$s1,-1
loopE:
lb	$t7,1($a2)		
beq $s1,$t7,obschecke		#obsicle ile position aynıysa fail
eort:
lb	$s4,2($a2)		
beq $s4,'#',truea
add $a2,$a2,2

j loopE


obschecke:
lb	$s4,0($a2)		
lb	$s3,0($a1)
beq $s3,$s4,faila
j eort



caseG:

lb $s1,0($a1)			#positionın ysini al 1 artır
beq $s1,'0',faila		#sınırdan çıktıysa fail
add $s1,$s1,-1			

loopG:
lb	$t7,0($a2)		
beq $s1,$t7,obscheckg
gort:	#obsicle ile position aynıysa fail
lb	$s4,2($a2)		
beq $s4,'#',truea
add $a2,$a2,2

j loopG

obscheckg:
lb	$s4,1($a2)		
lb	$s3,1($a1)
beq $s3,$s4,faila
j gort











caseB:

lb $s1,1($a1)			#positionın ysini al 1 artır
add $s1,$s1,1
lb $s2,1($t1)			#mapsizeın ysini al 1 çıkar			
beq $s2,$s1,faila		#sınırdan çıktıysa fail
lb	$s3,0($a1)
add	$s3,$s3,1
lb $s2,0($t1)			#mapsizeın ysini al 1 çıkar			
beq $s2,$s3,faila
loopA1:
lb	$t7,1($a2)		
beq $s1,$t7,obschecka1		#obsicle ile position aynıysa fail
aort1:
lb	$s4,2($a2)		
beq $s4,'#',truea
add $a2,$a2,2

j loopA1


obschecka1:
lb	$s4,0($a2)		
lb	$s3,0($a1)
add	$s3,$s3,1
beq $s3,$s4,faila
j aort1



caseD:


lb $s1,0($a1)			#positionın ysini al 1 artır
add $s1,$s1,1
lb $s2,0($t1)			#mapsizeın ysini al 1 çıkar			
beq $s2,$s1,faila		#sınırdan çıktıysa fail
lb	$s3,1($a1)
beq $s3,'0',faila
loopC2:
lb	$t7,0($a2)		
beq $s1,$t7,obscheckc2
cort2:	#obsicle ile position aynıysa fail
lb	$s4,2($a2)		
beq $s4,'#',truea
add $a2,$a2,2

j loopC2

obscheckc2:
lb	$s3,1($a1)
lb	$s4,1($a2)		
add	$s3,$s3,-1
beq $s3,$s4,faila

j cort2


caseF:
lb $s1,1($a1)			#positionın ysini al 1 artır
			
beq $s1,'0',faila		#sınırdan çıktıysa fail
add $s1,$s1,-1
lb $s2,0($a1)
beq $s2,'0',faila

loopE2:
lb	$t7,1($a2)		
beq $s1,$t7,obschecke2		#obsicle ile position aynıysa fail
eort2:
lb	$s4,2($a2)		
beq $s4,'#',truea
add $a2,$a2,2

j loopE2


obschecke2:
lb	$s4,0($a2)		
lb	$s3,0($a1)
add $s3,$s3,-1
beq $s3,$s4,faila

j eort2




caseH:


lb $s1,1($a1)			#positionın ysini al 1 artır
add $s1,$s1,1
lb $s2,1($t1)			#mapsizeın ysini al 1 çıkar			
beq $s2,$s1,faila		#sınırdan çıktıysa fail

lb $s2,0($a1)
beq $s2,'0',faila




loopH:
lb	$t7,1($a2)		
beq $s1,$t7,obscheckh		#obsicle ile position aynıysa fail

aorth:
lb	$s4,2($a2)		
beq $s4,'#',truea
add $a2,$a2,2

j loopH


obscheckh:
lb	$s4,0($a2)		
lb	$s3,0($a1)
add $s3,$s3,-1
beq $s3,$s4,faila
j aorth




truea:
li $v0,1		#engel veya sınırdan çıkma yoksa 1 bas,varsa 0
jr $ra

faila:
li $v0,0
jr $ra



















