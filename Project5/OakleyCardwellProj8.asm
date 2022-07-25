COMMENT *
	Title:			Project08 - Greatest Common Divisor
	Version:		1.
	4-12-2022
	Copyright:		Copyright (c) 2022
	Author:			Oakley Cardwell
	Company:		Fort Hays State University
	Goals:			Create a program that implements the Euclidean 
					algorithm to find the Greatest Common Divisor
*

INCLUDE Irvine32.inc
 
.386															; 32-bit program, accesses 32-bit registers/addresses
.model flat,stdcall												; Program memory model(flat), calling convention is 'stdcall'
.stack 4096														; Sets aside 4096 bytes of storage for the runtime stack

ExitProcess PROTO,dwExitCode:DWORD								; Exit process prototype, where dwExitCode is passed back to the OS 
String_find PROTO, pTarget:PTR BYTE, pSource:PTR BYTE			; String finding Protocol	

.data
target BYTE "01ABAAAAAABABCC45ABC9012",0
source BYTE "AAABA",0

sourcePrompt BYTE "Enter the source string (the string to search for): ",0
targetPrompt BYTE "Enter the target string (the string to search from): ", 0
stringFoundOne BYTE "Source string found at position ",0
stringFoundTwo BYTE " in Target string (counting from zero).",0
stringNotFound BYTE "Unable to find Source string in Target string.",0

stop DWORD ?
lenTarget DWORD ?
lenSource DWORD ?
position DWORD ?


;---------------------------------------------------------------
.code															; Beginning of the code area
main PROC														; Program entry point

call Clrscr														; Clear the console

mov edx, OFFSET sourcePrompt									; Set the source 
call WriteString
mov edx, OFFSET source
mov ecx, SIZEOF source
call ReadString

mov edx, OFFSET targetPrompt									; Set the target
call WriteString
mov edx, OFFSET target
mov ecx, SIZEOF target
call ReadString

INVOKE String_find, ADDR target, ADDR source
  mov position, eax
  jz WasFound													; ZF = 1 indicates string found
  mov edx,OFFSET stringNotFound									; String not found
  call WriteString
  jmp   Quit

WasFound:														; Display message
  mov edx,OFFSET stringFoundOne
  call WriteString
  mov eax,position												; Write position value
  call WriteDec
  mov edx,OFFSET stringFoundTwo
  call WriteString

Quit:
  exit


call WaitMsg													; Write prompt to the console

	INVOKE ExitProcess,0
main ENDP														; Marks the end of the procedure

;---------------------------------------------------------------
; Receives: Pointer to source, pointer to target
; Returns: Match found ZF = 1 and EAX points to OFFSET. 
; No Match found, ZF = 0
;---------------------------------------------------------------
String_find PROC, pTarget:PTR BYTE,	pSource:PTR BYTE			

  INVOKE Str_length,pTarget										
  mov lenTarget,eax
  INVOKE Str_length,pSource							     		
  mov lenSource,eax
  mov edi,OFFSET target											
  mov esi,OFFSET source											
																
  mov eax,edi													
  add eax,lenTarget												
  sub eax,lenSource										
  inc eax														
  mov stop,eax												
														
  cld
  mov ecx,lenSource												

L1:
  pushad
  repe cmpsb												
  popad
  je Found													
  inc edi														
  cmp edi,stop													
  jae NotFound													
  jmp L1														

NotFound:														
  or eax,1													
  jmp Finish

Found:															
  mov eax,edi													
  sub eax,pTarget
  cmp eax,eax												

Finish:
  ret

String_find ENDP

END main														; END marks the last line, main defines the address where the program
																; should execute