#Christian Rondeau
.data

	baseOutOfRangeError: .asciiz "ERROR: Base is outside of range 2-16"
	wrongBaseError: .asciiz "ERROR: The string contains nums not within the base specified"
	genError: .asciiz "ERROR: You entered something wrong (i.e. no plus signs or lower-case letters allowed)"
	negCheck: .asciiz "-"
	posCheck: .asciiz "+"

.text

	stringToInt: 
		
		main:
			#save current t-register values
			sw $t0, 0($sp)
			addi $sp, $sp, 4
			sw $t1, 0($sp)
			addi $sp, $sp, 4
			sw $t2, 0($sp)
			addi $sp, $sp, 4
			sw $t3, 0($sp)
			addi $sp, $sp, 4
			sw $t4, 0($sp)
			addi $sp, $sp, 4
			sw $t5, 0($sp)
			addi $sp, $sp, 4
			sw $t6, 0($sp)
			addi $sp, $sp, 4
			#save s-registers
			sw $s1, 0($sp)
			addi $sp, $sp, 4
			sw $s2, 0($sp)
			addi $sp, $sp, 4
			sw $s3, 0($sp)
			addi $sp, $sp, 4
			sw $s4, 0($sp)
			addi $sp, $sp, 4
			sw $s5, 0($sp)
			addi $sp, $sp, 4
			sw $s6, 0($sp)
		
			#1st arg (string to be converted)
				#keep track of string user entered
				move $s1, $a0
		
			#check if string is empty
			beq $s1, 0, emptyString
		
			#2nd arg (int for base val)
				#keep track of number user entered
				move $s2, $a1
		
			#check if base is out of range
			addi $t1, $0, 16
			addi $t2, $0, 2
			bgt $s2, $t1, baseOutOfRange
			blt $s2, $t2, baseOutOfRange
		
			#check for if str is neg num, if so, set a flag
			lbu $t3, 0($s1)
        		la $t4, negCheck
        		lbu $t0, ($t4)
        		seq $s3, $t3, $t0
        	
        		#if plus sign is present, throw error
        		lbu $t3, 0($s1)
        		la $t4, posCheck
        		lbu $t0, ($t4)
        		beq $t3, $t0, generalError
        	
        	################################### END OF SETUP ######################################
        		
        		#reset $t4
        		addi $t4, $0, 0
        		#counter/but also store of length of string
        		addi $s4, $0, 0
        		
        		#loop to count string length
        		strLengthLoop:
        			
        			#check to see if we have reached the end of string
        			lbu $t1, 0($s1)
        			beq $t1, 0, converter
        			
        			#increment counter
        			addi $s4, $s4, 1
        			addi $s1, $s1, 1
        			
        			j strLengthLoop
        		
        		#main process of function
        		converter:
        			
				subi $s1, $s1, 1
        			#offset to avoid any negs if necessary
        			sub $s4, $s4, $s3
        			#start incrementer (start at end of str and work back)
        			add $t1, $0, $s4
        			addi $s6, $0, 0
        			#start new int we want to return in the end
        			addi $s5, $0, 0
				#main loop for conversion algorithm
				while: 
					#check to see if we have reached the end of string
        				beq $t1, $s3, negChecker
        				
        				#branch to conversion
        				j convertDigit
        				
        				whileCont:
        					addi $s6, $s6, 1
						subi $t1, $t1, 1
						subi $s1, $s1, 1
					j while
		
				#Function for actually converting from base to 		
				convertDigit:
					
					#branch to proper conversion
        				lbu $t4, 0($s1)
					blt $t4, 58, zeroThruNine
        				bgt $t4, 64, tenThruSixteen
        				
        				
					#conversion math for nums 0-9
					zeroThruNine:
						
						addi $t4, $0, 0
						
						#Make sure char is in the right base (not over 9)
						lbu $t4, 0($s1)
						blt $t4, 48, generalError
						bge $t4, 58, wrongBase
						
						#convert str to int
						subi $t4, $t4, 48
						#check within base given
						bgt $t4, $s2, wrongBase
						
						#start incrementor
						addi $t6, $0, 0
						#save the base for multiplying with
						add $t0, $0, $s2
						subi $t5, $s6, 1
						#avoid loop if first index
						beq $s6, 0, firstIndexCase
						pwrLoop1:
						
							#stop when we reach the right power (our current index)
							beq $t6, $s6, end1
							beq $t6, $t5, end1
							#base times itself
							mul $t0, $s2, $t0

							addi $t6, $t6, 1
							j pwrLoop1
						
						#make sure the first index is just the char
						firstIndexCase: 
							add $s5, $s5, $t4
							
							j return
						
						#finish up conversion
						end1:	
							#finish last part of convert to decimal
							mul $t0, $t4, $t0
							
							#add value to our new int
							add $s5, $s5, $t0
						
					#return to main while loop	
					return:
					j whileCont
						
					#conversion math for nums 10-16
					tenThruSixteen:
						
						addi $t4, $0, 0
						
						#Make sure char is in the right base (not over F and not less than A)
						lbu $t4, 0($s1)
						ble $t4, 64, generalError
						bge $t4, 71, wrongBase
						
						#convert str to int
						subi $t4, $t4, 55
						#check within base given
						bgt $t4, $s2, wrongBase
						
						#start incrementor
						addi $t6, $0, 0
						
						#save the base for multiplying with
						add $t0, $0, $s2
						subi $t5, $s6, 1
						#avoid loop if first index
						beq $s6, 0, firstIndexCase2
						pwrLoop2:
						
							#stop when we reach the right power (our current index)
							beq $t6, $s6, end2
							beq $t6, $t5, end2
							
							#base times itself
							mul $t0, $s2, $t0
					
							addi $t6, $t6, 1
							j pwrLoop2
						
						#make sure the first index is just the char
						firstIndexCase2: 
							add $s5, $s5, $t4
							
							j return
						
						#finish up conversion
						end2:
						
							#finish last part of convert to decimal
							mul $t0, $t4, $t0
							
							#add value to our new int
							add $s5, $s5, $t0
						
					#return to main while loop
					j whileCont
					
			#Checks to see if num was originally neg and if so jumps to negAdder
			negChecker:
			
				addi $t1, $0, 1
        			beq $s3, $t1, negAdder
        			bne $s3, $t1, exit
        		
        		#takes final num and converts it to negative version of num	
        		negAdder:
        		
        			#muliply final num by -1
        			subi $t1, $0, 1
        			mul $s5, $s5, $t1
        			
        			j exit
        		
		################################## END OF LOOPS #######################################
			
			#Function for handling errors in input (base cases)
			baseCases:
				
				#if the string is empty
				emptyString:
					
					#Return zero to who called it
					move $v0, $0
					jr $ra
					
				#if the wrong base is used in string
				wrongBase:
					
					#print error
					li $v0, 4
					la $a0, wrongBaseError
					syscall
					
					#Return zero to who called it
					move $v0, $0
					jr $ra
					
				#if a base not within 2-16 is given
				baseOutOfRange:
					
					#print error
					li $v0, 4
					la $a0, baseOutOfRangeError
					syscall
					
					#Return zero to who called it
					move $v0, $0
					jr $ra
					
				generalError:
					
					#print error
					li $v0, 4
					la $a0, genError
					syscall
					
					#Return zero to who called it
					move $v0, $0
					jr $ra
					
		#################################### END OF BASE CASES/MAIN FUNCTION #####################################
		
		exit: 	
			
			#move new int to $v0
			move $v0, $s5
			
			#reload previous s-register values
			lw $s6, 0($sp)
			subi $sp, $sp, 4
			lw $s5, 0($sp)
			subi $sp, $sp, 4
			lw $s4, 0($sp)
			subi $sp, $sp, 4
			lw $s3, 0($sp)
			subi $sp, $sp, 4
			lw $s2, 0($sp)
			subi $sp, $sp, 4
			lw $s1, 0($sp)
			subi $sp, $sp, 4
			#reload previous t-register values
			lw $t6, 0($sp)
			subi $sp, $sp, 4
			lw $t5, 0($sp)
			subi $sp, $sp, 4
			lw $t4, 0($sp)
			subi $sp, $sp, 4
			lw $t3, 0($sp)
			subi $sp, $sp, 4
			lw $t2, 0($sp)
			subi $sp, $sp, 4
			lw $t1, 0($sp)
			subi $sp, $sp, 4
			lw $t0, 0($sp)
			
			#return to caller
			jr $ra
			
