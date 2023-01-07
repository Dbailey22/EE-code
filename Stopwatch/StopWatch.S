/*
Daniel Bailey
Stopwatch
*/


.text
.global main

.set SSD_BASE, 0x43C10000
.set TTC_BASE, 0xF8001000
.equ LED_CTL, 0x41210000
.set btn, 0x41200000

main:
	BL enable_7seg
	BL set_timer
	LDR R3, =btn
	MOV R9, #0
	MOV R10, #0
	MOV R11, #0
	mov r8, #0
	BL update_7seg

runapp:

	ldr r5,=LED_CTL
	mov r4, #0b0001
	str r4, [r5]
	mov r6, #0
	ldr r6,[r3]
	and r6,r6,#0b0001 // stop
	cmp r6,#1
	beq run
	b runapp
run:
	ldr r5,=LED_CTL
	mov r4, #0b0010
	str r4, [r5]
	// r6 r7 not used
	mov r6, #0
	mov r7, #0
	ldr r6,[r3]
	ldr r7,[r3]
	and r7, r7,#0b0010 // reset
	and r6,r6,#0b0001 // stop
	cmp r6,#1
	beq stop
	cmp r7, #0b0010
	beq BG
	push {LR}
	bl loop1
	pop {LR}
	b run

stop:
	mov r6, #0
	mov r7, #0
	ldr r5,=LED_CTL
	mov r4, #0b1000
	str r4, [r5]
	ldr r6,[r3]
	ldr r7,[r3]
	and r6,r6,#0b0001 // stop
	cmp r6,#1
	beq run
	and r7, r7,#0b0010 // reset
	cmp r7,#0b0010
	beq reset
	Bl update_7seg
	b stop

reset:
	ldr r5,=LED_CTL
	mov r4, #0b0001
	str r4, [r5]
	MOV R8,#0
	MOV R9,#0
	MOV R10,#0
	MOV R11,#0
	MOV R12,#0
	bl update_7seg
	mov r6, #0
	mov r7,#0
	ldr r6,[r3]
	and r6,r6,#0b0001 // stop
	cmp r6,#1
	beq run
	b reset

BG:
	ldr r5,=LED_CTL
	mov r4, #0b0100
	str r4, [r5]

	mov r6, #0
	mov r7,#0
	ldr r6,[r3]
	ldr r7,[r3]
	and r7, r7,#0b0010 // reset
	and r6,r6,#0b0001 // stop
	cmp r6,#1
	beq stop
	cmp r7, #0b0010
	beq run

	LDR R0, =TTC_BASE
	LDR R1, [R0, #0x54]  // if the counter reaches the max (0.01s), this will be 1.
	CMP R1, #1
	BNE BG

	ADD R9, R9, #1
	CMP R9, #10
	BLT BG
	mov R9,#0
	// new
	// the counter is set to 0.01s. Now, whenever R9 becomes 10 (0.1s), we update the 7seg.
	ADD R10, R10, #1
	CMP R10, #10
	BLT BG
	mov R10, #0

	ADD R11, R11, #1
	CMP R11, #10
	BLT BG
	mov R11,#0
		// new
	add r12, r12, #1
	cmp r12,#10
	BLT BG
	mov R12,#0
	// new
	add r8, r8, #1
	cmp r8,#10
	BLT BG
	mov R8, #0
	b BG

loop1:


	// conter
	LDR R0, =TTC_BASE
	LDR R1, [R0, #0x54]  // if the counter reaches the max (0.01s), this will be 1.
	CMP R1, #1
	BNE loop1
	ADD R9, R9, #1
	CMP R9, #10
	BLT loop1

	// new

	// the counter is set to 0.01s. Now, whenever R9 becomes 10 (0.1s), we update the 7seg.
	MOV R9, #0
	ADD R10, R10, #1
	CMP R10, #10
	BLT proc1
	MOV R10, #0
	ADD R11, R11, #1
	CMP R11, #10
	BLT proc1
	MOV R11, #0
	// new
	add r12, r12, #1
	cmp r12,#10
	blt proc1
	mov r12,#0
	// new
	add r8, r8, #1
	cmp r8,#10
	blt proc1
	mov r8,#0 // r8 couter regester

	// stop r8 will stop the counter
	// reset r8 will reset the counter

proc1:
	push {lr}
	BL update_7seg
	pop {lr}
	Bx lr

enable_7seg:
	LDR R0, =SSD_BASE
	MOV R1, #0x01
	STR R1, [R0]
	BX LR

update_7seg:
	LDR R0, =SSD_BASE
	LDR R1, =0x80008080
	ORR R1, R1, R10
	MOV R2, R11, LSL #8
	ORR R1, R1, R2
	mov r2, r12,lsl #16
	orr r1,r1,r2
	mov r2, r8, lsl #24
	orr r1,r1,r2
	STR R1, [R0, #0x04]
	BX LR

set_timer:
	LDR R0, =TTC_BASE
	// 1. [Clock Control] External clock edge: no. Clock source: no (use the system clock).
	// Prescaler: yes (N = 4'b1001 = 9, i.e., divided by 1024. The timer will run one tick every 1024 system clock ticks.).
	// The system clock is 111MHz, the timer will run one tick every 9.23us.
	MOV R1, #0x13
	STR R1, [R0]
	// 2. [Counter Control] Waveform polarity: 0. Output waveform: disable.
	// Counter reset: no. Match mode: no. Up counter. Counter disable.
	MOV R1, #0x21
	STR R1, [R0, #0x0C]
	// 3. [Interval Value] # ticks before the timer resets itself. After the prescale, the frequency
	// of the timer counter is 111MHz / 1024 = 108.4kHz (111MHz is the system clock).
	// If we set the interval to 1083 ticks, an interval will be approximately 0.01 second.
	LDR R1, =#1083
	STR R1, [R0, #0x24]
	// 4. [Interrupt Enable] Enable the interrupt.
	MOV R1, #0x01
	STR R1, [R0, #0x60]
	// 5. Turn on the counter and enable it (interval mode).
	MOV R1, #0x22
	STR R1, [R0, #0x0C]
	BX LR

.end