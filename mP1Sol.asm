section .data               

developer db "Fernando Santander",0

;Constants que també estan definides en C.
ROWDIM  equ 4       ;files de la matriu.
COLDIM  equ 5       ;columnes de la matriu.

section .text            

;Variables definides en Assemblador.
global developer  

;Subrutines d'assemblador que es criden des de C.
global posCurScreenP1, showDigitsP1, updateBoardP1,
global calcIndexP1, moveCursorP1, openCardP1
global playP1

;Variables definides en C.
extern charac, row, col, indexMat, rowcol, rowScreen, colScreen
extern value, moves, pairs, mCards, mOpenCards, state

;Funcions de C que es criden des de assemblador
extern clearScreen_C, printBoardP1_C, gotoxyP1_C, getchP1_C, printchP1_C
extern printMessageP1_C



gotoxyP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call gotoxyP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


printchP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call printchP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

getchP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   push rbp

   call getchP1_C
 
   pop rbp 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret 


posCurScreenP1:
   push rbp
   mov  rbp, rsp
   
   push rax
   push rbx
   
   mov rax, 0
   mov ax, WORD[rowcol+0]
   shl ax, 1        ;(rowcol[0]*2)
   add ax, 10       ;rowScreen=10+(rowcol[0]*2);
   
   mov rbx, 0
   mov bx, WORD[rowcol+2]  
   shl bx, 2        ;(rowcol[1]*4)
   add bx, 12       ;colScreen=12+(rowcol[1]*4);
   
   mov DWORD[rowScreen], eax
   mov DWORD[colScreen], ebx
   call gotoxyP1    ;gotoxyP1_C();
   
   posCurScreenP1_End:
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret



showDigitsP1:
   push rbp
   mov  rbp, rsp
   
   push rax
   push rbx
   push rdx
   
   mov eax, DWORD[value] ;Valor que volem mostrar
   mov edx, 0
   
   mov ebx,10
   div ebx          ;EAX=EDX:EAX/EBX, EDX=EDX:EAX mod EBX
                    ;d = val / 10;    u = val % 10;
   add al,'0'       ;d = d + '0';
   add dl,'0'       ;u = u + '0';

   call gotoxyP1              ;gotoxyP1_C();
   mov  BYTE[charac], al
   call printchP1             ;printchP1_C();
   inc  DWORD[colScreen]      ;colScreen++;
   call gotoxyP1              ;gotoxyP1_C();
   mov  BYTE[charac], dl
   call printchP1             ;printchP1_C(); 
   
   showDigitsP1_End:
   pop rdx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret


updateBoardP1:
   push rbp
   mov  rbp, rsp
   
   push rbx
   push rcx
   push rdx
   push rdi
   push r10
   push r11
   
   mov edx, DWORD[moves]               ;edx: moves
   mov ebx, DWORD[pairs]               ;ebx: pairs
   mov ecx, 0                          ;ecx: indexMat
   mov DWORD[rowScreen], 10            ;rowScreen=10;
   mov r10d, 0                         ;i=0
   updateBoardP1_bucle_Row:
   cmp r10d, ROWDIM                    ;i<ROWDIM
   jge updateBoardP1_show
    
      mov DWORD[colScreen], 12         ;colScreen=12;
      mov r11d, 0                      ;j=0;
      updateBoardP1_bucle_Col:
      cmp r11d, COLDIM                 ;j<COLDIM
      jge updateBoardP1_Col_end
         call gotoxyP1                 ;gotoxyP1_C();
         mov  dil, BYTE[mOpenCards+ecx];charac = mOpenCards[i][j];
         mov  BYTE[charac], dil
         call printchP1                ;printchP1_C(); 
         inc  rcx
         inc  r11d                     ;j++;
         add  DWORD[colScreen], 4      ;colScreen = colScreen + 4;
      jmp updateBoardP1_bucle_Col

      updateBoardP1_Col_end:
      inc  r10d                        ;i++;
      add  DWORD[rowScreen], 2         ;rowScreen = rowScreen + 2;
   jmp updateBoardP1_bucle_Row
   
   updateBoardP1_show:
   mov DWORD[rowScreen], 19            ;rowScreen = 19;   
   mov DWORD[colScreen], 15            ;colScreen = 15;
   mov edx, DWORD[moves]
   mov DWORD[value], edx               ;value = moves;
   call showDigitsP1                   ;showDigitsP1_C();
   ;mov DWORD[rowScreen], 19            ;rowScreen = 19;   
   mov DWORD[colScreen], 24            ;colScreen = 15;
   mov edx, DWORD[pairs]
   mov DWORD[value], edx               ;value = pairs;
   call showDigitsP1                   ;showDigitsP1_C();
      
   updateBoardP1_End:
   pop r11
   pop r10
   pop rdi
   pop rdx   
   pop rcx
   pop rbx
   
   mov rsp, rbp
   pop rbp
   ret


moveCursorP1:  
   push rbp
   mov  rbp, rsp

   push rax
   push rbx
   push rcx
   
   mov rax, 0
   mov rbx, 0
   mov rcx, 0
   
   mov  al, BYTE[charac]      ;(charac):caràcter llegit de teclat
   mov  bx, WORD[rowcol+0]
   mov  cx, WORD[rowcol+2]
   moveCursorP1_j:   
      cmp al,'i'              ;case 'i': 
      jne moveCursorP1_l
      cmp bx, 0               ;rowcol[0]>0
      jle moveCursorP1_end
      sub bx,1                ;rowcol[0]=rowcol[0]-1;;
      jmp moveCursorP1_end
   moveCursorP1_l:
      cmp al,'k'              ;case 'k':
      jne moveCursorP1_i
      cmp bx, (ROWDIM-1)      ;c[0]<(ROWDIM-1)
      jge moveCursorP1_end
      add bx,1                ;rowcol[0]=rowcol[0]+1;
      jmp moveCursorP1_end
   moveCursorP1_i:   
      cmp al,'j'              ;case 'j':
      jne moveCursorP1_k
      cmp cx, 0               ;rowcol[1]>0
      jle moveCursorP1_end
      sub cx,1                ;rowcol[1]=rowcol[1]-1
      jmp moveCursorP1_end
   moveCursorP1_k:
      cmp al,'l'              ;case 'l':
      jne moveCursorP1_end
      cmp cx, (COLDIM-1)      ;rowcol[1]<(COLDIM-1)
      jge moveCursorP1_end
      add cx, 1               ;rowcol[1]=rowcol[1]+1

   moveCursorP1_end:
   mov  WORD[rowcol+0], bx
   mov  WORD[rowcol+2], cx
      
   moveCursorP1_End:
   pop rcx
   pop rbx
   pop rax
         
   mov rsp, rbp
   pop rbp
   ret


calcIndexP1:
   push rbp
   mov  rbp, rsp

   push rbx
   push rdx
     
   mov rax, 0
   mov rbx, 0
   mov rdx, 0
   mov eax, DWORD[row]
   mov ebx, COLDIM
   mul ebx               ;(EDX:EAX = EAX; font): eax = (row*COLDIM)
   add eax, DWORD[col]   ;eax = (row*COLDIM)+(col)
   mov DWORD[indexMat], eax
  
   calcIndexP1_End:
   pop rdx
   pop rbx
         
   mov rsp, rbp
   pop rbp
   ret


openCardP1:  
   push rbp
   mov  rbp, rsp

   push rbx
   push rdx
   push rsi
   push rdi
   push r10
   
   mov rax, 0
   mov rbx, 0
   mov rcx, 0
   
   mov bx, WORD[rowcol+0]          ;int i = rowcol[0];
   mov cx, WORD[rowcol+2]          ;int j = rowcol[1];
   
   mov  DWORD[row], ebx
   mov  DWORD[col], ecx
   call calcIndexP1 
   mov  eax, DWORD[indexMat]   
   
   mov r10b, BYTE[mCards+eax]
   cmp r10b, 'x'                     ;if (mCards[i][j] != 'x') {
   je  openCardP1_End   
      mov BYTE[mOpenCards+eax], r10b ;mOpenCards[i][j] = mCards[i][j];
      mov BYTE[mCards+eax], 'x'      ;mCards[i][j] = 'x';
      inc DWORD[state]               ;state++;
   
   openCardP1_End:
   pop r10
   pop rdi
   pop rsi
   pop rdx
   pop rbx
         
   mov rsp, rbp
   pop rbp
   ret


printMessageP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ; Quan cridem la funció printMessageP1_C() des d'assemblador, 
   call printMessageP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret

playP1:
   push rbp
   mov  rbp, rsp
   
   push rax
   
   mov DWORD[state], 0   ;state = 0;//Estat per a començar a jugar
   mov WORD[rowcol+0], 2 ;rowcol[0] = 2; //Posició inicial del cursor dins la matriu.
   mov WORD[rowcol+2], 1 ;rowcol[1] = 1;
   
   call clearScreen_C
   call printBoardP1_C        ;printBoard1_C();
     
   call updateBoardP1

   playP1_Loop:               ;while  {  //Bucle principal.
   cmp  DWORD[state], 3        ;(state < 3)
   jge  playP1_End
      
      call printMessageP1     ;printMessageP1_C();
      call posCurScreenP1     ;posCurScreenP1_C();     
      call getchP1            ;charac = getchP1_C();   
      mov  al, BYTE[charac]
      
      cmp al, 'i'             ;if (charac>='i' && charac<='l') {
      jl  playP1_TurnUp
      cmp al, 'l'
      jg  playP1_TurnUp
         call moveCursorP1    ;moveCursorP1_C();
      playP1_TurnUp:
      cmp al, 32              ;if (charac==32) {
      jne playP1_Esc
         call openCardP1      ;state = openCardP1_C();
         
         cmp DWORD[state], 1           ;if (state > 1) {
         jle playP1_Update
			inc DWORD[moves]  ;moves++;
			mov DWORD[state],0;state = 0;
	     playP1_Update:
         call updateBoardP1   ;updateBoardP1_C();
      playP1_Esc:
      cmp al, 27              ;if ( (charac==27) && (state!=1) ) {
      jne playP1_EndLoop
      cmp DWORD[state], 1
      je  playP1_EndLoop
         mov DWORD[state], 5  ;state = 5;
      playP1_EndLoop:
   jmp playP1_Loop
   
   playP1_End:
   pop rax  
   
   mov rsp, rbp
   pop rbp
   ret
