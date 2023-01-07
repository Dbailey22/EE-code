/*
Daniel Bailey


Code explanation:
	The LOAD loop performs the following operations:

	Increment the value in register R14 by 1.
	Load a value from memory into register R3,
	using the memory address pointed to by the sum of the stack pointer and the value in register R10.
	Subtract the value in register R1 from the value in register R10.
	Compare the value in register R9 with the value in register R8.
	If the values are equal, branch to the EXIT label to exit the loop.
	Otherwise, branch to the LOOP2 label to continue the loop.
	The LOOP2 loop performs the following operations:

	Load a value from memory into register R5, using the memory address pointed to by the sum of
	the stack pointer and the value in register R2.
	Subtract the value in register R7 from the value in register R2.
	Multiply the values in registers R3 and R5, and store the result in register R6.
	Add the value in register R6 to the value in register R0.
	Compare the value in register R14 with the value in register R11.
	If the values are equal, branch to the SAVE label to save the result and continue the loop.
	Otherwise, branch back to the LOAD label to continue the loop.
	The SAVE and RESload labels are used to save the result of the multiplication and reset certain registers
	in preparation for the next iteration of the loop. The RESvals label is used to reset certain registers
	in preparation for the next iteration of the LOAD loop. The EXIT label is used to clean up after the loop
	is finished and branch to the next instruction in the main program.




*/
MATRIX:
	MOV R0, #2  //R0 = 2
	MOV R1, #4 //R1 = 4
	MUL R2, R11, R11  //R2 = R11*R11--N*N
	MOV R8, R2 	//R8 = R2
	MUL R10, R2, R0     //R10 = R2*R0
	SUB R10, #1 		//Decrease r10 by 1 (length-1)
	MUL R10, R1, R10 	//R10 = (R1*R10)
	SUB R2, #1 		//^^
	MUL R2, R1, R2 	//R2 = (R1*R2)
	MUL R7, R11, R1 	//R7 = (R11*R1)

Set:
//registers to hold temps
	MOV R4, #0
	MOV R5, #0
	MOV R6, #0
	MOV R9, #0
	MOV R0, #0
	MOV R3, #0
	MOV R14, #0

LOAD:
	ADD R14, #1 //Increment R14
	LDR R3, [SP, R10] //load val at mem addr pointed by sum of r10 and sp into r3
	SUB R10, R1 //r10-1
	CMP R9, R8
	BNE LOOP2		//R9 != R8 -> next loop
	B EXIT			//R9 == R8 -> Exit

RESload:
	MOV R0, R4
	MUL R4, R1, R4
	SUB R2, R4
	MOV R4, R0
	ADD R10, R7
	MOV R14, #0
	MOV R0, #0
	B LOAD


RESvals:
	MOV R4, #0
	MOV R0, #0
	MOV R14, #0
	B LOAD

LOOP2:
	LDR R5, [SP, R2] //load val at mem address pointed by sum of sp and r2
	SUB R2, R7   //
	MUL R6, R3, R5
	ADD R0, R0, R6
	CMP R14, R11
	BNE LOAD
	B SAVE
SAVE:
	ADD R9, #1
	ADD R4, #1
	MUL R6 , R9, R1
	STR R0, [SP, -R6] //STR
	MUL R2, R11, R11
	SUB R2, #1
	MUL R2, R1, R2
	MOV R0, #0
	MOV R6, #0
	CMP R4, R11
	BNE RESload
	B RESvals
EXIT:
	MUL R9, R1, R9
	SUB SP, R9
	B main_loop_inc
