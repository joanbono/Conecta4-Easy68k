*-----------------------------------------------------------
* Title      :CONECTA-4
* Written by :Dario Alandes Codina y Joan Bono Aguilar
* Date       :11/06/2014
* Description:Juego Conecta-4 para MC68000 de Motorola
* Observación:Falta audio tipo wav con nombre INICIO.wav
*-----------------------------------------------------------
    ORG    $1000

*D0 POSICION            *A5 INDICA QUI GUANYA
*D1 ELEMENTO    
*D2 COLUMNA
*D3 FILA
*D4 VAR...
*D5 VAR...
*D6 CONTADOR
*D7 J1 o J2

START
* INICIEM EL JOC 
        MOVE.L #SONIDO_INICIO,A1
        MOVE.B #0,D1
        MOVE.B #71,D0
        TRAP #15
    
        MOVE.B #0,D1
        MOVE.B #72,D0
        TRAP #15 * QUE SONE AL INICI
                
        MOVE.L #11,D0    *SITUA EL CURSOR CENTRAT, MOSTRAR INICI DEL JOC
        MOVE.L #$0B07,D1
        TRAP #15

        MOVE.L #21,D0
        MOVE.L #BLANCO,D1 *COLOR BLANC LLETRES
        MOVE.L #$01150001,D2 *FIXEDYS + BOLD+ 25
        TRAP #15
        
        MOVE.L #14,D0 
        MOVE.L #MENSAJE1,A1 
        TRAP #15   
        
        MOVE.L #11,D0    *MOSTRAR RETRO VERSION
        MOVE.L #$0B08,D1
        TRAP #15
       
        MOVE.L #14,D0 
        MOVE.L #MENSAJE2,A1 
        TRAP #15        
        
        MOVE.L #11,D0    *CURSOR MOSTRAR 'HAZ CLICK PARA'
        MOVE.L #$0B09,D1
        TRAP #15
       
        MOVE.L #14,D0 
        MOVE.L #MENSAJE3,A1 
        TRAP #15
       
       
 * NO INICIA EL JOC SI NO ES DONA CLIC EN LA PANTALLA       
NOCLICKINICIO	  
        MOVE.B 	#0,D1	
	    MOVE	#61,D0
	    TRAP	#15
	    BTST #0,D0 ;COMPROBA CLICK LEFT
	    BEQ NOCLICKINICIO

        *LLEVEM PANTALLA INICI PARA MUSICA            
        MOVE.L #11,D0
        MOVE.W #$FF00,D1 * NETEJA LA PANTALLA
        TRAP #15
        
        MOVE.L #76,D0        *PARA LA CANÇÓ
        MOVE.L #0,D1
        MOVE.L #3,D2
        TRAP #15
           

    MOVE.L #0,A5 
START2:            ; first instruction of program
    MOVE.L #0,D2  ; D2=COL
    MOVE.L #0,D3  ; D3=ROW
    
    
    MOVE.L #11,D0       *\
    MOVE.W #$FF00,D1    *LIMPIAR PANTALLA
    TRAP #15            */
    
****************************** 
****** MOSTRAR TABLA ********* 
******************************     
    MOVE.L #TABLE,A2
LOOP
    MOVE.L D3,D0
    MULU #7,D0
    ADD.L D2,D0  ; D0=ROW*7+COL
    
    MOVE.B (A2,D0),D1  ;D1=ELEMENT
    CMP.B #0,D1
    BEQ EMPTY
    CMP.B #1,D1
    BEQ PLAYER1
    CMP.B #2,D1
    BEQ PLAYER2
EMPTY
    MOVE.B #'.',D1
    MOVE.B #6,D0
    TRAP #15
    BRA NEXT
    
PLAYER1
    MOVEM.L D0-D4,-(A7)
    MOVE.L #21,D0
    MOVE.L #$01150001,D2 *FIXEDYS+BOLD+25
    MOVE.L #AMARILLO,D1 *EL COLOR BLANC A LES LLETRES
    TRAP #15
    MOVEM.L (A7)+,D0-D4
    MOVE.B #'O',D1
    MOVE.B #6,D0
    TRAP #15
    BRA NEXT
    
PLAYER2 
    MOVEM.L D0-D4,-(A7)
    MOVE.L #21,D0
    MOVE.L #$01150001,D2 **FIXEDYS+BOLD+25
    MOVE.L #ROJO,D1 *EL COLOR BLANC A LAS LLETRES
    TRAP #15
    MOVEM.L (A7)+,D0-D4
   
    MOVE.B #'O',D1
    MOVE.B #6,D0
    TRAP #15
    BRA NEXT
    
NEXT ADD.L #1,D2  ; NEXT COL
     CMP.L #7,D2
     BNE LOOP
     MOVE.L #0,D2  
     
     MOVE.L #14,D0
     MOVE.L #CRLF,A1
     TRAP #15
     
     ADD #1,D3     

     CMP.L #6,D3
     BNE LOOP
******************************
******************************  
    CMP #1,A5 *qui ha guanyat
    BEQ WIN1  *j1
    CMP #2,A5
    BEQ WIN2  *j2
     
    CMP #1,D7 
    BEQ J2

********************************   
******TIRADA J1*****************
********************************
J1
    MOVE.L #1,D7
    
* MENSAJE DE TEXTO (14) 
    MOVEM.L D0-D4,-(A7)
    MOVE.L #21,D0
    MOVE.L #$01150001,D2 **FIXEDYS+BOLD+25
    MOVE.L #BLANCO,D1 *COLOR BLANC A LES LLETRES
    TRAP #15
    MOVEM.L (A7)+,D0-D4


    MOVE.L #14,D0 
    MOVE.L #TIRJ1,A1 
    TRAP #15 

* LEER NUMERO(4) 
    MOVE.L #4,D0 
    TRAP #15 
* EN D1.L ESTARÁ EL NÚMERO

    MOVE.L D1,D2  ; D2=COL
    MOVE.L #5,D3  ; D3=FILA
    
    CMP #6,D2 *comprova si tirada valida
    BGT J1
    
POSICIO    
    MOVE.L D3,D0
    MULU #7,D0
    ADD.L D2,D0  ; D0=FILA*7+COL
    
    MOVE.B (A2,D0),D1  ;D1=ELEMENT
     
    CMP #0,D1   **MIRA SI HI HA '.' EN LA TABLA PA TIRAR
    BEQ TIR
        
    CMP #0,D3 *comprova si tirada valida
    BEQ J1
    
    SUB #1,D3
    
    JMP POSICIO
    
TIR
    MOVE.B #1,(A2,D0)
    JMP FIN
    
********************************   
******TIRADA J2*****************
********************************    
J2
    MOVE.L #2,D7
   
* MENSAJE DE TEXTO (14)  
    MOVEM.L D0-D4,-(A7)
    MOVE.L #21,D0
    MOVE.L #$01150001,D2 *PONE LA FUENTE FIXEDYS,DE TAMAÑO 25 Y EN NEGRITA
    MOVE.L #BLANCO,D1 *PONE EL COLOR BLANCO A LAS LETRAS
    TRAP #15
    MOVEM.L (A7)+,D0-D4


    MOVE.L #14,D0 
    MOVE.L #TIRJ2,A1 
    TRAP #15 

* LEER NUMERO(4) 
    MOVE.L #4,D0 
    TRAP #15 
* EN D1.L ESTARÁ EL NÚMERO

    MOVE.L D1,D2  ; D2=COL
    MOVE.L #5,D3  ; D3=FILA
    
    CMP #6,D2 *comprova si tirada valida
    BGT J2
    
POSICIOJ2    
    MOVE.L D3,D0
    MULU #7,D0
    ADD.L D2,D0  ; D0=FILA*7+COL
    
    MOVE.B (A2,D0),D1  ;D1=ELEMENT
    
    CMP #0,D1 **MIRA SI HI HA '.' EN LA TABLA PA TIRAR
    BEQ TIR2
    
    CMP #0,D3 *comprova si tirada valida
    BEQ J2
    
    SUB #1,D3
    
    JMP POSICIOJ2
    
TIR2
    MOVE.B #2,(A2,D0)

FIN

********************************   
******  ARBIT  *****************
******************************** 
*D0 POSICION
*D1 ELEMENTO
*D2 COLUMNA
*D3 FILA
*D4 VAR...
*D5 VAR...
*D6 CONTADOR
*D7 J1 o J2
********************************
********  FILES ****************
********************************
DRETA
    MOVE.L #1,D6 **INICIALIÇAR EL CONTADOR
    MOVE.L D2,D4

LOOP1    
 
    CMP #6,D4 *comprueba si final tabla a dreta
    BEQ IZQ
    
    ADD #1,D4

    MOVE.L D3,D0
    MULU #7,D0
    ADD.L D4,D0  ; D0=FILA*7+COL  
    
    MOVE.B (A2,D0),D1    *
    CMP D7,D1            *
    BNE IZQ 

    ADD #1,D6
    CMP #4,D6   
    BEQ WINNER
       
    JMP LOOP1
*************************************
*D0 POSICION
*D1 ELEMENTO
*D2 COLUMNA
*D3 FILA
*D4 VAR...
*D5 VAR...
*D6 CONTADOR
*D7 J1 o J2
*************************************
IZQ
    MOVE.L D2,D4
    
LOOP2   

    CMP #0,D4 *comprueba si final tabla a esquerra
    BEQ VERTICAL
    SUB #1,D4
    
    MOVE.L D3,D0
    MULU #7,D0
    ADD.L D4,D0  ; D0=FILA*7+COL
   
    MOVE.B (A2,D0),D1    
    CMP D7,D1    
    BNE VERTICAL
    
    ADD #1,D6
    CMP #4,D6   
    BEQ WINNER  

    JMP LOOP2
    
*************************************   
*D0 POSICION
*D1 ELEMENTO
*D2 COLUMNA
*D3 FILA
*D4 -COL'
*D5 -FILA'
*D6 CONTADOR
*D7 J1 o J2 
*************************************
**********COLUMNES*******************
*************************************

VERTICAL

    MOVE.L #1,D6
    MOVE.L D3,D5

LOOP3

    CMP #5,D5
    BEQ DIAG
    
    ADD #1,D5
    
    MOVE.L D5,D0
    MULU #7,D0
    ADD.L D2,D0  ; D0=FILA*7+COL

    MOVE.B (A2,D0),D1    
    CMP D7,D1    
    BNE DIAG

    ADD #1,D6
    CMP #4,D6   
    BEQ WINNER

    JMP LOOP3   
*************************************
***********DIAGONALS*****************
*************************************
*D0 POSICION
*D1 ELEMENTO
*D2 COLUMNA
*D3 FILA
*D4 -COL'
*D5 -FILA'
*D6 CONTADOR
*D7 J1 o J2 
***************************************
DIAG *\*
    MOVE.L #1,D6
    MOVE.L D2,D4
    MOVE.L D3,D5
    
LOOP4
    
    CMP #6,D4
    BEQ DIAG1
    CMP #5,D5
    BEQ DIAG1
    
    ADD #1,D4
    ADD #1,D5

    MOVE.L D5,D0
    MULU #7,D0
    ADD.L D4,D0  ; D0=FILA*7+COL

    MOVE.B (A2,D0),D1    
    CMP D7,D1    
    BNE DIAG1
    
    ADD #1,D6
    CMP #4,D6   
    BEQ WINNER

    JMP LOOP4

DIAG1
    MOVE.L D2,D4
    MOVE.L D3,D5
    
LOOP5
    
    CMP #0,D4 *COL
    BEQ DIAG2
    CMP #0,D5 *FIL
    BEQ DIAG2
    
    SUB #1,D4
    SUB #1,D5

    MOVE.L D5,D0
    MULU #7,D0
    ADD.L D4,D0  ; D0=FILA*7+COL

    MOVE.B (A2,D0),D1    
    CMP D7,D1    
    BNE DIAG2
    
    ADD #1,D6
    CMP #4,D6   
    BEQ WINNER

    JMP LOOP5

************************************
************************************
*D0 POSICION
*D1 ELEMENTO
*D2 COLUMNA
*D3 FILA
*D4 -COL'
*D5 -FILA'
*D6 CONTADOR
*D7 J1 o J2 
************************************
DIAG2 */*
    MOVE.L #1,D6
    MOVE.L D2,D4
    MOVE.L D3,D5
    
LOOP6
    
    CMP #0,D4
    BEQ DIAG3
    CMP #5,D5
    BEQ DIAG3
    
    SUB #1,D4
    ADD #1,D5

    MOVE.L D5,D0
    MULU #7,D0
    ADD.L D4,D0  ; D0=FILA*7+COL

    MOVE.B (A2,D0),D1    
    CMP D7,D1    
    BNE DIAG3
    
    ADD #1,D6
    CMP #4,D6   
    BEQ WINNER

    JMP LOOP6

DIAG3
    MOVE.L D2,D4
    MOVE.L D3,D5
    
LOOP7
    
    CMP #6,D4 *COL
    BEQ FINARBIT
    CMP #0,D5 *FIL
    BEQ FINARBIT
    
    ADD #1,D4
    SUB #1,D5

    MOVE.L D5,D0
    MULU #7,D0
    ADD.L D4,D0  ; D0=FILA*7+COL

    MOVE.B (A2,D0),D1    
    CMP D7,D1    
    BNE FINARBIT
    
    ADD #1,D6
    CMP #4,D6   
    BEQ WINNER

    JMP LOOP7

FINARBIT

*************************************
*************************************

   JMP START2  

                       
WINNER   
    MOVE.L #1,A5
    JMP START2
WIN1

    CMP #2,D7
    BEQ WIN2
    
* MENSAJE DE TEXTO (14) 
    MOVE.L #14,D0
    MOVE.L #WINJ1,A1 
    TRAP #15 
    JMP FINAL
    
WIN2
* MENSAJE DE TEXTO (14) 
    MOVE.L #14,D0
    MOVE.L #WINJ2,A1 
    TRAP #15 
FINAL
**************************************
    SIMHALT             
SONIDO_INICIO DC.L 'INICIO.wav',0
MENSAJE1 DC.B 'CONECTA 4',0
MENSAJE2 DC.B 'RETRO VERSION',0
MENSAJE3 DC.B 'CLICK PARA INICIAR',0


NEGRO                   EQU $00000000
ROJO                    EQU $00000B0
AMARILLO                EQU $000FBFF0
BLANCO                  EQU $00FFFFFF  

TIRJ1 DC.B 'J1 COLUMNA?(0-6):  ',0
TIRJ2 DC.B 'J2 COLUMNA?(0-6):  ',0
WINJ1 DC.B 'THE WINNER IS J1  ',0
WINJ2 DC.B 'THE WINNER IS J2  ',0

TABLE DC.B 0,0,0,0,0,0,0  
      DC.B 0,0,0,0,0,0,0  
      DC.B 0,0,0,0,0,0,0
      DC.B 0,0,0,0,0,0,0
      DC.B 0,0,0,0,0,0,0
      DC.B 0,0,0,0,0,0,0  
      
CRLF  DC.B 10,13,0

    END    START        ; last line of source


