.global stext
.section		".head.text","ax"
stext:
	ldr r0, =0x0
	ldr r1, =interrupt_table
	ldr r3, =interrupt_table_end
keep_loading:
	ldr r2, [r1, #0x0]
	str r2, [r0, #0x0]
	add r0, r0, #0x4
	add r1, r1, #0x4
	cmp r1, r3
	bne keep_loading

	ldr sp, =stack_top
	push {r0, r1, r2}
	b main

.global active
active:
	mov ip, sp
	push {r4-fp, ip, lr}
	msr cpsr_c, 0x50
	mov sp, r0
	pop {r0-ip}
	pop {pc}

/* http://infocenter.arm.com/help/topic/com.arm.doc.dui0203j/CHDEFDJG.html */
interrupt_table:
	nop
	nop
	ldr pc, svc_entry_addr
	nop
	nop
	nop
	nop
	nop

	svc_entry_addr: .word svc_entry
interrupt_table_end:


.global svc_entry
svc_entry:
	/* Save user state */
	msr CPSR_c, #0xDF
	push {r4,r5,r6,r7,r8,r9,r10,fp,ip,lr}
	str sp, [r0]

	msr CPSR_c, #0xD3 /* Supervisor mode */

	/* Load kernel state */
	pop {r4,r5,r6,r7,r8,r9,r10,fp,ip,lr}
	bx lr

.type svc_call, %function
.global svc_call
svc_call:
	swi 0
	bx lr
