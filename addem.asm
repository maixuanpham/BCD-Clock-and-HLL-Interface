; The addem Subroutine    (addem.asm)
; This subroutine links to Visual C++.

;.386P
;.model flat
;public _addem

INCLUDE Irvine32.inc

setClock PROTO C, 
	clock:PTR BYTE, arrayPtr:PTR DWORD
tickClock PROTO C,
	clock:PTR BYTE
getCurrentTime PROTO C,
	time:PTR BYTE

.code
setClock PROC C, clock:PTR BYTE, structPtr:PTR DWORD
	pushad
	mov esi, structPtr
	mov edi, clock
	mov ecx, 3

L1:
	mov eax, 0
	mov edx, 0
	mov eax, [esi]			; eax = struct value 
	mov ebx, 10				
	div ebx
	shl al, 4				; mov 1st digit to upper al
	or al, dl				; mov 2rd digit to lower al
	mov [edi], al			; store in clock
	add esi, 4
	inc edi
	loop L1

	mov al, [esi]			; store AM/PM
	mov [edi], al
	popad
	ret
setClock ENDP

tickClock PROC C clock:PTR BYTE
	pushad
	mov eax, 0
	mov ebx, 0
	mov esi, clock
	add esi, 2				; go to seconds index
	mov ecx, 3

L1:
	mov al, [esi]
	mov bl, [esi]
	and al, 11110000b		; keep upper half in case
	and bl, 00001111b		; keep lower half
	inc bl					
	cmp ecx, 1				; check if in hour index,
	je hour					;   if yes, go to hour loop
	cmp bl, 10				; if min/sec < 10, 
	jb done					;   store the value
	shr al, 4				; if above, shift and inc 
	inc al					;   the upper half
	cmp al, 6				; if upper half < 6
	jb almostDone			;   store upper half
	mov dl, 0				; else store 0 and do it again
	mov [esi], dl 
	dec esi
	loop L1

hour:
	cmp bl, 2				; if hour < 2, store it
	jb done
	cmp bl, 3
	ja done					; if hour > 3, store it
	shr al, 4				; else, check to see if 02 or 12
	cmp al, 0
	je done					; if 02/03, store the value
	cmp bl, 3
	je finish				; if 13, change to 1 by storing the 1 only
	shl al, 4				; else keep upper half and
	mov edi, clock			; check for am/pm
	mov dl, [edi+3]
	cmp dl, 50h
	je am					; if pm, change to am
	cmp dl, 41h
	je pm					; if am, change to pm
am:
	mov dl, 41h				; change to am
	mov [edi+3], dl
	jmp done
pm:
	mov dl, 50h				; change to pm
	mov [edi+3], dl
	jmp done
almostDone:
	shl al, 4				; mov upper half left
	jmp finish
done:
	or al, bl				; combine 2 digits
finish:
	mov [esi], al			; store the value
	popad
	ret
tickClock ENDP

getCurrentTime PROC C, time:PTR BYTE
	pushad
	mov eax, 0
	mov edx, 0
	mov esi, time
	mov al, 41h
	mov [esi+8], al			; store AM 1st
	
	
	call getMseconds		; get current time
	mov ebx, 1000			; get ricks of milli seconds
	div ebx
	mov edx, 0
	mov ebx, 3600			; eax = hour, edx = min+sec
	div ebx	
	cmp al, 10				; hr < 10, store it
	jb l1
	cmp al, 12				; hr > 12, min 12 and change to pm
	ja l2
	jmp l3					; else divide and store
L2:	
	sub ax, 12				; change to 12 hr format
	mov bl, 50h				; cahnge to pm
	mov [esi+8], bl 
L1:
	mov bl, 0				; store leading 0
	mov [esi], bl
	mov [esi + 1], al		; store lower half
	jmp next
L3:
	push edx				; save min/sec
	mov bl, 10				; slit two digits
	div bl					
	mov [esi], al			; store upper half
	mov [esi + 1], ah		; store lower half
	pop edx					; restore min/sec
next:
	mov eax, edx			; get min/sex
	mov ebx, 60		
	mov edx, 0	
	div ebx					; eax = min, edx = sec

	mov bl, 10				; split two digits
	div bl					
	mov [esi + 3], al		; store upper digit
	mov [esi + 4], ah		; store lower digit	

	mov eax, edx			; get sec
	mov bl, 10				; split two digit
	mov ah, 0
	div bl		
	mov [esi + 6], al		; store upper digit
	mov [esi + 7], ah		; store lower digit

	mov eax, 0
	mov esi, time
	mov ecx, 8				; convert all digit to char
L10:
	mov al, [esi]
	add al, 30h
	mov [esi], al
	inc esi
	loop l10
	
	popad
	ret
getCurrentTime ENDP

END

