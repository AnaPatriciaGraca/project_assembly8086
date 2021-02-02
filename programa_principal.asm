.STACK 100H

.DATA
    ; Variaveis da divis�o
    ;cache               db 200 dup(0)                     ; array que guarda dados em cache
    array_size  EQU 5
    dividendo           db  16 dup(0)   
    divisor             db  16 dup(0) 
    resto               db  16 dup(0)   
    subtrai             db  32 dup(0) 
    quo                 db  16 dup(0)
    tam_dividendo       db  0FH
    tam_dec_dividendo   db  0FH
    tam_divisor         db  1
    tam_dec_divisor     db  0
    tam_resto           db  1
    tam_dec_resto       db  0
    tam_quo             db  1
    tam_dec_quo         db  0  
    tam_subtrai         db  32 dup (0)            
    ; Flags
    div_decimal         db  0
    flag_neg            db  0
    flag_iterador       db  0   
    print_resto         db  0DH, 0AH, "Resto: $"
    print_quociente     db  0DH, 0AH, "Quociente: $" 
    print_res_raiz         db  0DH, 0AH, "Resultado: $"
                             
    ; Variaveis da tabela 
    ; localiza��o do ficheiro: C:\emu8086\MyBuild
    mapeamento          db  1
    algoritmo           db  1
    politica            db  0                             ; 1=WB+WA ; 2=WT+WA; 3=WB+NWA; 4= WT+NWA
    n_blocos            db  32                            ; 32; 63; 128
    bloco               db 10 dup(0)                      ; array ondem vai ficar o bin�rio lido do ficheiro
    cache               db 200 dup(0)                    ; array que guarda dados em cache
    lei_esc             db 0                              ; verifica��o se � para efetuar leitura ou escrita
    dir_ficheiro        db "./tabela.txt"                 ; diretoria do ficheiro
    ID_ficheiro         dw 0                              ; ap�s abertura do ficheiro, guarda o ID do mesmo
    dir_ficheiro_output db "./tabela_output.txt"                 ; diretoria do ficheiro 
    ID_ficheiro_output  dw 0                              ; ap�s abertura do ficheiro, guarda o ID do mesmo
    tam_index           db 0                              ; a ser calculado  
    dirty_bit           db 0                              ; saber se o dirty_bit est� ativo ou n�o est� a 0 ou nao para calculos
    conjunto            db 0                              ; conjunto Bx
    tag                 db 0                              ; tag lida
    bloco_ini           db 0                              ; bloco inicial
    colocado            db 0                              ; bloco colocado
    posicao_col         db 0                              ; posicao do bloco colocado (para calculos)          
    hit_miss            db 0                              ; saber se existe hit ou miss 
    flag_nao_colocado   db 0                              ; se estiver a 1 indica q o bloco ja esta colocado e apenas imprimimos um "-"   
    TAcesso             dw 1                               
    escrita_cache       dw 10
    escrita_ram         dw 7500
    trf_ram_cache       dw 4500 
    TAcesso_mul         db " TAcesso * $"   
    sum_TAcesso         db " + TAcesso$" 
    caracter            db 0
    cabecalho           db           "    ____________________________________________________________________________________________________________________________________________________________________________", 0DH, 0AH, 
                        db           "  ||                                BLOCO                                       |                                 CACHE                                  |  TEMPO DE EXECU��O   ||", 0DH, 0AH, 
                        db           "    ____________________________________________________________________________________________________________________________________________________________________________", 0180D, 0DH, 0AH,
                        db           "  ||     Endere�o     | TAG base 2 | TAG base 10 | INDEX base 2 | Index Base 10 | Conjunto | Bloco Inicial | Bloco Colocado | Leitura/Escrita | Hit/Miss |      Do Bloco        ||", 0DH, 0AH, 
                        db           "    ____________________________________________________________________________________________________________________________________________________________________________ " , 0DH, 0AH, 0DH, 0AH, "  || $"
    coluna_seg          db " | $" 
    muda_linha          db "||", 0DH, 0AH, "  || $"
    
    ; Variaveis do menu
    print_operacao      db  0DH, 0AH, "Introduza a opera��o a realizar:", 0DH, 0AH,
                        db  "1 - Divis�o", 0DH, 0AH, 
                        db  "2 - Ra�z quadrada", 0DH, 0AH,
                        db  "3 - Tabela", 0DH, 0AH,
                        db  "4 - Terminar", 0DH, 0AH,
                        db  "Opera��o: $"
    print_divisao       db  0DH, 0AH, "Introduza qual a divis�o que pretende:", 0DH, 0AH,
                        db  "1 - Divis�o inteira", 0DH, 0AH,
                        db  "2 - Divis�o decimal", 0DH, 0AH,
                        db  "Divis�o: $"                        
    print_dividendo     db  "Introduza dividendo: $"
    print_divisor       db  "Introduza divisor: $"   
    numeros_invalidos   db  "Deve introduzir numeros v�lidos ", 0DH, 0AH, "$"
    print_raiz_qd       db  "Introduza um valor: $"
    print_mapeamento    db  "Introduza o mapeamento", 0DH, 0AH,
                        db  "1 - Mapeamento direto (one-way)", 0DH, 0AH,
                        db  "2 - Two way", 0DH, 0AH,
                        db  "4 - Four way", 0DH, 0AH,
                        db  "Mapeamento: $"
    print_algoritmo     db  "Introduza o algoritmo: ", 0DH, 0AH,
                        db  "1 - FIFO", 0DH, 0AH,
                        db  "2 - LFU", 0DH, 0AH,
                        db  "3 - LRU", 0DH, 0AH,
                        db  "Algoritmo: $"
    print_politica      db  "Introduza a pol�tica de escrita: ", 0DH, 0AH,
                        db  "1 - Write Back + Write Allocate", 0DH, 0AH,
                        db  "2 - Write Through + Write Allocate", 0DH, 0AH,
                        db  "3 - Write Back + No Write Allocate", 0DH, 0AH,
                        db  "4 - Write Through + No Write Allocate", 0DH, 0AH,
                        db  "Pol�tica: $"
    print_n_blocos      db  "Introduza o tamanho dos blocos: ", 0DH, 0AH,
                        db  "1 - 32", 0DH, 0AH,
                        db  "2 - 64", 0DH, 0AH,
                        db  "3 - 128", 0DH, 0AH,
                        db  "Tamanho: $"  
    aumentar_janela     db  0DH, 0AH, 0DH, 0AH, "   Aguarde o c�lculo do ficheiro. Quando o menu aparecer novamente, o ficheiro foi calculado. ", 0DH, 0AH, 0DH, 0AH, "$"              
    print_vazio         db  80 dup(" "), "$"
    print_nova_linha    db  0DH, 0AH, "$"  
    
    
.CODE

main PROC                                             
    ; Inicializacao
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
    
main_loop:    
    LEA SI, print_operacao
    CALL print_msg
    
    MOV AH, 01h
    INT 21H
    
    CMP AL, 031H
    JE op_divisao
    
    CMP AL, 032H   
    JE op_raiz_qd
    
    CMP AL, 033H   
    JE op_tabela
    
    CMP AL, 034H
    JE main_fim
    
    JMP main_loop
    
op_divisao:
    XOR BX, BX
    LEA SI, print_divisao
    CALL print_msg
    
    MOV AH, 01h
    INT 21H
    
    CMP AL, 031H           
    JE op_divisao_inteira
    
    CMP AL, 032H           
    je op_divisao_decimal
    
    JMP op_divisao
                   
op_divisao_inteira:
    LEA SI, print_nova_linha
    CALL print_msg
    
    ; Introduzir dividendo
    LEA SI, print_dividendo
    CALL print_msg
    
    LEA DI, dividendo   ; Guardar a referencia do array em DI (necessario para o input)
    MOV CH, 01H         ; Indicar que numeros negativos sao permitidos
    MOV DH, 00H         ; Inidcar que casas decimais nao sao permitidas
    CALL input_array
    
    MOV tam_dividendo, AH       ; Guardar o tamanho do array
    MOV tam_dec_dividendo, AL   ; Guardar o tamanho da parte decimal do array
    
    MOV BL, flag_neg            ; Guardar o valor da flag
    MOV BH, div_decimal         ;
    
    LEA SI, print_nova_linha
    CALL print_msg
    
    ; Introduzir divisor
    LEA SI, print_divisor
    CALL print_msg
    
    LEA DI, divisor   ; Guardar a referencia do array em DI (necessario para o input)  
    MOV CH, 01H         ; Indicar que numeros negativos sao permitidos
    MOV DH, 00H         ; Inidcar que casas decimais nao sao permitidas
    CALL input_array
    
    MOV tam_divisor, AH         ; Guardar o tamanho do array
    MOV tam_dec_divisor, AL     ; Guardar o tamanho da parte decimal do array
    
    XOR BL, flag_neg            ; Determinar numero negativo
    MOV flag_neg, bl            
    
    LEA SI, print_nova_linha    ; Determinar se existe virgula
    CALL print_msg
    
    CALL div_inteira            ; CHAMADA PARA OPERACAO DA DIVISAO
    
    LEA SI, print_quociente
    CALL print_msg
    LEA SI, quo           ; Colocar em SI o array a imprimir
    MOV AH, tam_quo       ; Colocar em AH o tamanho do array
    MOV AL, 0   ; Color em AL o tamanho da parte decimal do array 
    CALL print_array
    
    LEA SI, print_resto
    CALL print_msg 
    LEA SI, resto                       ; Colocar em SI o array a imprimir
    MOV AH, tam_resto       ; Colocar em AH o tamanho do array
    MOV AL, 0   ; Color em AL o tamanho da parte decimal do array
    CALL print_array     
    
    MOV AH, 01h
    INT 21H   
    
    ;CALL limpa_ecra
    JMP main_loop
    
op_divisao_decimal:
    LEA SI, print_nova_linha
    CALL print_msg
    
    ; Introduzir dividendo
    LEA SI, print_dividendo
    CALL print_msg
    
    LEA DI, dividendo   ; Guardar a referencia do array em DI (necessario para o input) 
    MOV CH, 01H         ; Indicar que numeros negativos sao permitidos
    MOV DH, 01H         ; Inidcar que casas decimais sao permitidas
    CALL input_array
    
    MOV tam_dividendo, AH       ; Guardar o tamanho do array
    MOV tam_dec_dividendo, AL   ; Guardar o tamanho da parte decimal do array
    
    MOV BL, flag_neg            ; Guardar o valor da flag
    
    LEA SI, print_nova_linha
    CALL print_msg
    
    ; Introduzir divisor
    LEA SI, print_divisor
    CALL print_msg
    
    LEA DI, divisor   ; Guardar a referencia do array em DI (necessario para o input)
    MOV CH, 00H         ; Indicar que numeros negativos nao sao permitidos
    MOV DH, 01H         ; Inidcar que casas decimais sao permitidas
    CALL input_array
    
    MOV tam_divisor, AH         ; Guardar o tamanho do array
    MOV tam_dec_divisor, AL     ; Guardar o tamanho da parte decimal do array
    
    XOR BL, flag_neg            ; Determinar numero negativo
    MOV flag_neg, bl
    
    MOV div_decimal, 1
    
    LEA SI, print_nova_linha
    CALL print_msg
    
    CALL div_inteira            ; CHAMADA DA DIVISAO 
     
    LEA SI, print_quociente
    CALL print_msg
    LEA SI, quo           ; Colocar em SI o array a imprimir
    MOV AH, tam_quo       ; Colocar em AH o tamanho do array
    MOV AL, tam_dec_resto 
    DEC AL
    MOV tam_dec_quo, AL 
    ;MOV AL, tam_dec_quo             ; Color em AL o tamanho da parte decimal do array 
    CALL print_array
    
    LEA SI, print_resto
    CALL print_msg
    LEA SI, resto           ; Colocar em SI o array a imprimir
    MOV AH, tam_resto       ; Colocar em AH o tamanho do array
    MOV AL, 0   ; Color em AL o tamanho da parte decimal do array
    CALL print_array     
    
    MOV AH, 01h
    INT 21H 
    
    ;CALL limpa_ecra
    JMP main_loop
    
op_raiz_qd:
    LEA SI, print_nova_linha
    CALL print_msg
    
    ; Introduzir valor para raiz quadrada
    LEA SI, print_raiz_qd
    CALL print_msg
    
    LEA DI, dividendo   ; Guardar a referencia do array em DI (necessario para o input)
    MOV CH, 00H         ; Indicar que numeros negativos nao sao permitidos
    MOV DH, 01H         ; Inidcar que casas decimais sao permitidas
    CALL input_array
    
    MOV tam_dividendo, AH         ; Guardar o tamanho do array
    MOV tam_dec_dividendo, AL     ; Guardar o tamanho da parte decimal do array
    
    OR BH, div_decimal          ; Determinar se existe virgula
    MOV div_decimal, BH
    
    LEA SI, print_nova_linha
    CALL print_msg
    
    CALL raiz_quadrada              ; CHAMADA DA RAIZ QUADRADA
    
    
    ; PRINT DO RESULTADO   
    LEA SI, print_res_raiz
    CALL print_msg     
    LEA SI, quo           ; Colocar em SI o array a imprimir
    MOV AH, tam_quo       ; Colocar em AH o tamanho do array
    MOV AL, tam_dec_quo   ; Color em AL o tamanho da parte decimal do array
    CALL print_array
    
    MOV AH, 01h
    INT 21H   
    
    MOV tam_quo, 1
    MOV tam_dec_quo, 0
    MOV tam_dividendo, 1
    MOV tam_dec_dividendo, 0 
    LEA DI, subtrai
    MOV DL, tam_subtrai
    CALL limpa_array
    ;CALL limpa_ecra
    JMP main_loop
    
op_tabela: 
    ; Reset nas variaveis antes de pedir os seus valores
    MOV mapeamento, 01h
    MOV algoritmo, 01h
    MOV politica, 01h
    MOV n_blocos, 32
                       
tabela_in_mapeamento:
    LEA SI, print_nova_linha
    CALL print_msg
    
    ; Introduzir valor para raiz quadrada
    LEA SI, print_mapeamento
    CALL print_msg
    
    MOV AH, 01H
    INT 21H
               
    CMP AL, 031H
    JE mapeamento_valido
    
    CMP AL, 032H        
    JE mapeamento_valido
    
    CMP AL, 034H
    JE mapeamento_valido
    
    JMP tabela_in_mapeamento
    
mapeamento_valido:
    SUB AL, 30H
    MOV mapeamento, AL

tabela_in_algoritmo:
    LEA SI, print_nova_linha
    CALL print_msg
        
    ; Introduzir valor para raiz quadrada
    LEA SI, print_algoritmo
    CALL print_msg
    
    MOV AH, 01H
    INT 21H
    
    CMP AL, 031H
    JE algoritmo_valido
    
    CMP AL, 032H
    JE algoritmo_valido
    
    CMP AL, 033H
    JE algoritmo_valido
    
    JMP tabela_in_algoritmo
    
algoritmo_valido:
    SUB AL, 030H
    MOV algoritmo, AL

tabela_in_politica:
    LEA SI, print_nova_linha
    CALL print_msg
    
    ; Introduzir valor para raiz quadrada
    LEA SI, print_politica
    CALL print_msg
                  
    MOV AH, 01H
    INT 21H
    
    CMP AL, 031H
    JE politica_valida
    
    CMP AL, 032H
    JE politica_valida
    
    CMP AL, 033H
    JE politica_valida
    
    CMP AL, 034H
    JE politica_valida
    
    JMP tabela_in_politica
     
politica_valida:
    SUB AL, 30H
    MOV politica, AL

tabela_in_n_blocos:
    LEA SI, print_nova_linha
    CALL print_msg
    
    ; Introduzir valor para raiz quadrada
    LEA SI, print_n_blocos
    CALL print_msg
                  
    MOV AH, 01H
    INT 21H
    
    CMP AL, 31H
    JE n_blocos_valido
    
    CMP AL, 32H
    JE n_blocos_valido
    
    CMP AL, 33H
    JE n_blocos_valido
    
n_blocos_valido:
    SUB AL, 30H
    DEC AL
    MOV CL, AL
    SHL n_blocos, CL
    
    MOV DX, OFFSET aumentar_janela
    MOV AH, 9
    INT 21h
    ;MOV AH, 01h
    ;INT 21H                       
    CALL calcula_nr_bits 
    CALL open_file
    CALL open_file_output 
    CALL apresenta_tabela
    CALL read_file    
    CALL close_file
    CALL close_file_output 
    
    ;CALL limpa_ecra
    JMP main_loop

main_fim:
    
    INT 20H
main endp

limpa_ecra proc
    MOV CX, 25
    
loop_limpa: 
    LEA DX, print_vazio
    MOV AH, 09H
    INT 21H
    LOOP loop_limpa
     
    RET
limpa_ecra endp

; INPUT: SI - Referencia para string.
;   Exemplo:
;       LEA SI, var_string
;       CALL PRINT_MSG
;
print_msg proc
    PUSH AX
    PUSH DX
    
    MOV DX, SI
    MOV AH, 09H
    INT 21H
    
    POP DX
    POP AX
    
    RET
print_msg endp

; INPUT:    DI - Referencia para array
;           DH - Se pode introduzir virgula
;           CH - Se pode introduzir numeros negativos
;
; OUTPUT:   AH - Tamanho do array
;           AL - Tamanho da parte decimal do array
input_array proc
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV flag_neg, 00h
    MOV div_decimal, 00h
    
    MOV BX, 01H     ; Tamanho do array     
    MOV CL, 00H     ; Tamanho da parte decimal do array
    
in_array:
    ; Pedir para introduzir um digito (resultado fica em AL)
    MOV AH, 01H
    INT 21H
    
    CMP AL, 08H         ; SE AL == 08H (BACKSPACE) saltar para IN_BACKSPACE
    JE in_backspace
     
    CMP AL, 0DH         ; Se AL == 0DH (ENTER) saltar para FIM_IN_ARRAY
    JE fim_in_array 
    
    CMP AL, 2CH         ; SE AL == 2CH (VIRGULA)
    JE in_virgula
    
    CMP AL, 2DH         ; Se AL == 2DH (SINAL MENOS) saltar para IN_NEGAR
    JE in_negar
    
    CMP AL, '0'         ; Se AL < '0' (ZERO ASCII) entao valor invalido e saltar para IN_INVALIDO 
    JB in_invalido
    
    CMP AL, '9'         ; Se AL > '9' (NOVE ASCII) entao valor invalido e saltar para IN_INVALIDO
    JA in_invalido
    
    SUB AL, '0'         ; Converter ASCII para binario
    XOR AH, AH          ; Limpar AH (porque o seu valor nao tem que ser guardado no array)
    
    CMP BX, 16h         ; Caso input esteja cheio
    JAE in_invalido
    
    MOV [DI + BX], AX   ; Guardar o input no array
    INC BX              ; Incrementar o tamanho do array
    
    CMP div_decimal, 01h    ; Se ja existir virgula entao incrementar CX tbm caso contrario pedir logo outro input
    JNE in_array
    
    INC CX
    
    JMP in_array        ; Saltar para IN_ARRAY para pedir novo input 

in_negar:
    ; Verificar se numeros negativos sao permitidos
    CMP CH, 01H
    JNE in_invalido
    
    ; Comparar BX com 1. Se BX == 1 entao o utilizador nao introduziu nenhum digito e por 
    ; isso a negacao pode ser introduzida. Caso ja tenho introduzido digitos pelo meio
    ; entao a negacao e assumida como invalido
    CMP BX, 01H
    JA in_invalido
    
    ; Se '-' ja foi introduzido, entao o segundo '-' e invalido
    CMP flag_neg, 01H
    JE in_invalido
    
    MOV flag_neg, 01H   ; Inicar que o valor e negativo
     
    JMP in_array        ; Saltar para IN_ARRAY para pedir novo input
        
in_virgula:
    ; Verificar se numeros reais sao permitidos
    CMP DH, 01H
    JNE IN_INVALIDO
    
    CMP BX, 01H
    JE IN_INVALIDO
    
    MOV div_decimal, 01H
    JMP IN_ARRAY
    
in_backspace:
    ; Imprimir SPACE (de forma a apagar o valor que la existia)
    MOV DL, 20H
    MOV AH, 02H
    INT 21H
    
    ; Se existirem digitos a remover do array entao remover
    CMP BX, 01H
    JA in_apagar_digito
    
    ; Se existir flag de negacao a remover entao remover
    CMP flag_neg, 01H
    JE in_apagar_neg
    
    JMP in_array
    
in_apagar_digito: 
    ; Imprimir BACKSPACE (para a voltar o cursor para tras)
    MOV DL, 08H
    MOV AH, 02H
    INT 21H
    
    ; Verificar se o digito a remover e a parte decimal
    CMP CX, 00H
    JA in_apagar_digito_dec
    
    ; Verificar se e para remover a virgula
    CMP div_decimal, 01H
    JE in_apagar_virg
    
    ; Remover so a parte inteira
    MOV [DI + BX], 00H
    DEC BX
    JMP in_array
    
in_apagar_digito_dec: 
    ; Remover a parte decimal
    DEC CX
    MOV [DI + BX], 00H
    DEC BX
    JMP in_array
    
in_apagar_virg:
    MOV div_decimal, 00H     
    JMP IN_ARRAY 
    
in_apagar_neg:
    MOV flag_neg, 00h
    JMP IN_ARRAY
    
in_invalido:
    ; Imprimir BACKSPACE (para mover o cursor para tras)
    MOV DL, 08H
    MOV AH, 02H
    INT 21H
    
    ; Imprimir SPACE (de forma a apagar o valor que la existia)
    MOV DL, 20H
    MOV AH, 02H
    INT 21H
    
    ; Imprimir BACKSPACE (para a voltar o cursor para tras)
    MOV DL, 08H
    MOV AH, 02H
    INT 21H
    
    JMP in_array
     
fim_in_array:
    MOV AH, BL 
    MOV AL, CL
                         
    POP DX
    POP CX
    POP BX
    
    RET
input_array endp

; INPUT:    SI - Referencia para o array
;           AH - Tamanho do array
;           AL - Tamanho da parte decimal do array
print_array proc
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH AX
    DEC AH          ; nunca imprimimos a primeira posi��o
    
    ; Calcular o tamanho da parte inteira do array e guardar em CL
    XOR CX, CX
    MOV CL, AH       
    SUB CL, AL   
    MOV DH, AL
    MOV BX, 01H
    CMP flag_neg, 0
    JE verifica_tam_int
    MOV DL, '-'
    INT 21H  
    verifica_tam_int:
    CMP CL, 0
    JE imprime_virgula  
    print_loop: 
        MOV AH, 02H
        MOV DL, [SI+BX]
        ADD DL, 30H
        INT 21H
        INC BX  
        CMP BL, CL
        JLE print_loop 
    imprime_virgula: 
        CMP DH, 0
        JE termina_imprimir_array
        MOV AH, 02H
        MOV DL, ','
        INT 21H      
    imprime_parte_decimal:  
        MOV AH, 02H
        MOV DL, [SI+BX]
        ADD DL, 30H
        INT 21H  
        INC BX
        DEC DH
        CMP DH, 0
        JE termina_imprimir_array   
        JMP imprime_parte_decimal   
     
        
    termina_imprimir_array:        
    POP DX
    POP CX
    POP BX
    POP AX 
    MOV tam_resto, 1
    MOV tam_dec_resto, 0
    MOV tam_quo, 1
    MOV tam_dec_quo, 0
    RET
print_array endp 


; --------------------------------------------------------------------- TERMINAM PRINTS E COME�AM ALGORITMOS ---------------------------------------------------------------------



; PROCEDIMENTO PARA SOMAR 2 ARRAYS  - recebe valor a somar em DX
soma_array_inteiro proc 
    XOR BX, BX
    XOR CX, CX 
    CMP tam_quo, 1
    JNE array_nao_vazio
    MOV subtrai[2], DL
    MOV tam_subtrai, 3
    RET
    array_nao_vazio:
    MOV BL, tam_quo 
    MOV tam_subtrai, BL
    DEC BX                      
    ADD DL, [SI+BX]  
    CMP DL, 10
    JAE ciclo_soma: 
    MOV subtrai[BX], DL
    RET
    ciclo_soma:
        JMP ativa_carry
        volta_ativa_carry:   
        MOV subtrai[BX], DL
        DEC BX
        CMP BX, 0 
        JNE ciclo_soma2
        CALL ultimo_carry
        MOV AL, tam_subtrai
        RET 
        ciclo_soma2:
        MOV DL, resto[BX]
        ADD DX, CX
        JMP desativa_carry
        volta_desativa_carry:
        CMP DL, 10
        JAE ciclo_soma
        MOV subtrai[BX], DL
        MOV AL, tam_subtrai
        RET
                
        ativa_carry:
            INC CX                          ; ativar carry
            SUB DL, 10                      ; buscar digito menos significativo
            JMP volta_ativa_carry
        desativa_carry:
            CMP CX, 1
            JNE volta_desativa_carry
            DEC CX
            JMP volta_desativa_carry
                       
                              
soma_array_inteiro endp 
 

; PROCEDIMENTO PARA SUBTRAIR 2 ARRAYS  -> resto = subtrai-resto
subtrai_arrays proc
    XOR AX, AX
    XOR CX, CX
    XOR BX, BX          
    MOV AL, tam_resto                         ; comparar tamanho dos arrays para saber qual temos de alinhar � direita
    CMP AL, tam_subtrai
    JE tam_iguais_sub
    JG array_maior_sub
    JL array2_maior_sub
    
    array_maior_sub:                           
       MOV CL, tam_resto                       ; guardar nr de posicoes que cada nr tem de andar para a direita para os array ficarem do mesmo tamanho
       SUB CL, tam_subtrai                     
       MOV BL, tam_subtrai                     ; guardar tamanho do array menor para iterar do fim para o inicio   
       DEC BX                                  ; BX = tam_array2 - 1
       PUSH SI
       LEA SI, subtrai                         ; buscar endere�amento de mem�ria do array menor  
       PUSH AX
       CALL alinha_array_dir                   ; chamar procedimento para alinhar array menor � direita 
       POP AX      
       POP SI
       MOV tam_subtrai, AL                     
       JMP tam_iguais_sub
       
    array2_maior_sub:
       MOV CL, tam_subtrai                      ; guardar nr de posicoes que cada nr tem de andar para a direita para os array ficarem do mesmo tamanho
       SUB CL, tam_resto
       MOV BL, tam_resto                        ; guardar tamanho do array menor para iterar do fim para o inicio    
       DEC BX                                   ; BX = tam_array - 1   
       PUSH SI                              
       LEA SI, resto                            ; buscar endere�amento de mem�ria do array menor                     
       CALL alinha_array_dir                    ; chamar procedimento para alinhar array menor � direita 
       POP SI
       MOV AL, tam_subtrai   
       MOV tam_resto, AL                        ; corrigir tamanho do array menor                                                                                
       
    tam_iguais_sub:
       XOR BX,BX
       MOV BL, AL                               ; ir buscar tamanho para iterar do fim para o incio 
       ;DEC BX                                   ; BX = tam_array - 1
       XOR AX, AX
       XOR CX,CX
       MOV tam_resto, BL                            ; colocar tamanho do resto igual aos restantes 
                               
            ciclo_subtrair:
                MOV DL, [DI+BX]                          
                MOV AL, [SI+BX] 
                CMP CX,1                        ; verifica se existe carry
                JE adiciona_carry               ; se carry � um tem de adicionar o carry
                volta_adiciona_carry: 
                CMP [DI+BX],     AL             ; verificar se o subtrativo � superior
                JA subtrativo_superior
                volta_subtrativo_superior:            
                SUB AL, [DI+BX]                               
                MOV resto[BX], AL               ; coloca no array3 o resultado da subtra��o
                DEC BX
                CMP BX, 0 
                JA ciclo_subtrair                ; voltar a iterar
                CMP CX, 0                        ; existe carry na ultima itera��o?
                JE termina_sub
                CALL ultimo_carry
                termina_sub:   
                RET
                   
                adiciona_carry:
                    INC [DI+BX]                  ; icrementar soma
                    DEC CX                       ; desativar carry
                    JMP volta_adiciona_carry 
                    
                subtrativo_superior:
                    ADD AL, 10
                    INC CX                       ;ativar carry
                    JMP volta_subtrativo_superior            
                              
subtrai_arrays endp  

; PROCEDIMENTO PARA MULTIPLICAR UM ARRAY POR UM NUMERO INTEIRO >0 E <10  - assume que o digito pelo qual se vai multiplicar (o array2) est� em DX, 
;                                                                        - coloca resultado no array "subtrai" 
;                                                                        - assume que tamanho do array vem em BX
multiplica_por_array proc        
    XOR CX, CX                                  ;vai ser a nossa flag do carry , iniciar a 0
    XOR AX, AX    
    
    MOV tam_subtrai, BL                         ; colocar o tamanho do array que mostra o resultado igual ao tamanho do array
    iteracao_mul:     
        MOV AL, DL                              ; colocar o inteiro no AX para se conseguir efetuar a divis�o (quando se chama o procedimento o interiro/iterador deve vir sempre no DX) 
        MUL [SI+BX]                             ; MUL OP => AX * OP = DX:AX     -> o DX vai estar sempre a 0 por isso nao temos de nos preocupar com ele 
        CMP CX, 0                               ; verificar se existe carry
        JNE desativar_carry_flag                    
        volta_lidar_flag:                                                                                            
        CMP AX, 10                              ; verificar se  multiplica��o � um numero superior a 9 para ativar a flag   
        JAE ativar_carry_mul     
        MOV subtrai[BX], AL                     ; colocar resultado no array que guarda o resultado da opera��o
        DEC BX                                  ; decrementar posi��o do array    
        CMP BX, 0
        JA iteracao_mul                         ; se ainda n�o chegamos ao final do array, voltar a iterar     
        CMP CX, 0                               ; existe carry na ultima itera��o?
        JNE ultimo_carry 
        RET
        
        ativar_carry_mul:                       ; se a multiplica��o � maior ou igual a 10
            SUB AX, 10                          ; subtrair 10
            INC CX                              ; incrementar carry
            JMP volta_lidar_flag                ; voltar a verificar
        
        desativar_carry_flag:
            ADD AX, CX                          ;somar carry ao valor da multiplica��o
            XOR CX, CX                          ; colocar carry a 0
            JMP volta_lidar_flag
                             
multiplica_por_array endp 

encontrar_multiplo_mul proc
    XOR BX, BX  
    itera_multiplo:
        LEA SI, divisor                        ; ir buscar referencia do array pelo qual queremos multiplicar o numero para depois chamar procedimento da multiplicacao
        INC BX                                 ; iterar 
        MOV DX, BX                             ; o procedimento da multiplica��o de um array por um numero assume que o numero est� sempre em DX 
        PUSH BX                                
        MOV Bl, tam_divisor                    ; procedimento precisa saber tamanho do array
        CALL multiplica_por_array              ; multiplicar array pelo iterador
        POP BX 
        MOV CL, tam_resto    
        CMP CL, tam_subtrai
        JLE compara_encontra_mul
        SUB CL, tam_subtrai
        LEA SI, subtrai   
        ADD tam_subtrai, CL   
        PUSH BX
        CALL alinha_array_dir 
        POP bx
        compara_encontra_mul:
        LEA SI, resto                          ; ir buscar o outro array para se fazer a compara��o se j� � maior
        LEA DI, subtrai                        ; multiplicacao colocou o resultado no array subtrai
        MOV CL, tam_resto                      ; colocar valores nas variaveis corretas para chamar procedimento que compara arrays
        MOV DL, tam_subtrai                    ; colocar valores nas variaveis corretas para chamar procedimento que compara arrays 
        PUSH BX 
        CALL compara_arrays                    ; devolve DX=1 se primeiro array � maior que o segundo   
        POP BX
        CMP DX, 1                              ; verifica se o primeiro array � maior que o segundo 
        JE itera_multiplo                      ; se for menor voltar a iterar 
        CMP BX, 0
        JE multiplo_zero
        CMP BX, 0
        JE multiplo_zero
        DEC BX 
        MOV DX, BX  
        LEA SI, divisor 
        PUSH BX
        MOV Bl, tam_divisor                    ; procedimento precisa saber tamanho do array
        CALL multiplica_por_array              ;iterador fica em BX
        POP BX  
        multiplo_zero:          
        RET 
encontrar_multiplo_mul endp

ultimo_carry proc
    CMP CX, 0
    JE termina                                   ; se nao existe carry termina
    existe_carry:
        INC tam_subtrai                          ; aumenta o array
        MOV BL, tam_subtrai                      ; guarda tamanho do array para ir decrementando at� terminar o array
        shift_array:
        DEC BX                                   ; decrementa para ir buscar o valor anterior
        MOV AL, subtrai[BX]                      ; vai buscar valor da posicao anterior
        INC BX
        MOV subtrai[BX], AL                      ; colocar o calor na posicao seguinte
        DEC BX
        CMP BX, 0                                ; verifica se ja terminou
        JNE shift_array                          ; se nao terminou volta a iterar
        MOV subtrai[1],CL                        ; coloca valor do carry na primeira posi��o
        termina: 
        RET

ultimo_carry endp
                      
; PROCEDIMENTO PARA ALINHAR OS 2 ARRAYS � DIREITA - recebe numero de casas a acrescentar em CX                      
alinha_array_dir proc   
    iterar_array_alinha_dir:
        MOV AX, [SI+BX]                         ; ir buscar valor que vamos mudar de posi��o 
        ADD BX, CX                              ; ir buscar nova posi��o
        MOV [SI+BX], AL                         ; colocar valor na posi��o correta (alinhado �) direita -> tem de ser AL por causa do tamanho DB
        SUB  BX, CX                             ; voltar a posicao anterior
        MOV [SI+BX], 0                          ; colocar a 0 a posi��o onde estava o valor anteriormente
        DEC BX                                  ; decrementar BX (iterador)
        CMP BX, 0                               ; verificar se j� terminamos a intera��o
        JNE iterar_array_alinha_dir                                                                                                                                                                                                            
                                                                                                                                                     
    RET    
alinha_array_dir endp    

; PROCEDIMENTO PARA ALINHAR OS 2 ARRAYS � ESQUERDA - recebe tamanho do array em CX                      
alinha_array_esq proc   
    XOR BX, BX                                  ; limpar registos que vamos utilizar
    XOR AX, AX
    encontra_nr_casas_esq:
        INC BX                                  ; incrementar iterador 
        CMP [SI+BX], 0                          ; comparar valor da posi��o em BX com 0 
        JE array_vazio                          ; se for 0 voltar a iterar
    DEC BX                                      ; decrementar iterador para obter numero de casas que vamos ter de "andar" para a esquerda
    MOV AX, CX                                  ; novo tam_array = tam_array - iterador
    SUB AL, BL
    MOV CX, AX                                  ; actualizar tamanho do array 
    MOV DX, BX                                  ; copiar para AX nr de casas a "recuar"
    XOR BX, BX                                  ; limpar iterador 
    iterar_array_alinha_esq:
        INC BX                                  ; iniciar iterador a 1
        ADD BX, DX                              ; calcular posi��o de onde vamos buscar o valor
        MOV AL, [SI+BX]                         ; ir buscar valor para copiar
        MOV [SI+BX], 0                          ; colocar posi��o antiga do valor a 0 
        SUB BX, DX                              ; calular nova posi��o do valor
        MOV [SI+BX], AL                         ; copiar valor para posi��o correta
        CMP BX, CX                              ; verificar se j� chegamos ao fim do array
        JNE iterar_array_alinha_esq             ; se ainda n�o chegamos ao fim voltar a iterar                                                                                                                                                                                                                                                                                       
    RET
    
    array_vazio:                                ; verificar se o array est� vazio
        CMP BX, CX
        JNE encontra_nr_casas_esq
        MOV CX, 1                               ; devolver tamanho correto do array em CX
        RET    
alinha_array_esq endp 

;PROCEDIMENTO PARA COMPARAR 2 ARRAYS -> devolve DX=1 se primeiro array � maior ou igual que o segundo, devolve DX=0 se for menor, recebe tamanho dos arrays (com referencias em SI e DI) em CX e DX correspectivamente 
compara_arrays proc
    XOR BX, BX
    CMP CX, DX                                  ; compara o tamanho dos dois arrays
    JG array_maiore
    JL array2_maiore
    itera_e_compara:                            ; se entra aqui � porque os arrays t�m o mesmo tamanho
        INC BX                                  ; itera arrays
        MOV AL, [SI+BX]
        CMP AL, [DI+BX]                         ; compara valores nas posi��es dos arrays
        JA array_maiore
        JL array2_maiore
        CMP BX, CX                              ; verifica se j� chegou ao final dos arrays
        JNE itera_e_compara     
    array_maiore:
        MOV DX, 1                               ; retorna DX=1 se o primeiro array � maior ou igual
        RET   
    array2_maiore:                              ; se entrou aqui sem saltar � porque s�o do mesmo tamanho  e reotrna DX=0 na mesma
        XOR DX,DX                               ; retorna DX=0 se o primeiro array � menor
        RET  
compara_arrays endp    


; PROCEDIMENTO DA DIVIS�O INTEIRA
div_inteira proc
    LEA DI, quo                                 ; limpar arrays utilizados anteriormente
    MOV DL, tam_quo 
    MOV tam_quo, 1
    CALL limpa_array 
    LEA DI, resto
    MOV DL, tam_resto  
    MOV tam_resto, 1
    CALL limpa_array                                
    XOR BX, BX                                  
    XOR DX, DX 
    XOR AX, AX 
    XOR CX, CX                                
    MOV DL, tam_divisor                     ; copiar tamanho do divisor 
    CMP DL, 1
    JNE div_verifica_zero     
    LEA SI, numeros_invalidos
    CALL print_msg 
    CALL main 
    MOV DL, tam_dividendo
    CMP DL, 1
    JNE dividir
    LEA SI, numeros_invalidos
    CALL print_msg  
    CALL main
    div_verifica_zero:
    MOV DL, tam_divisor
    CMP DL, 2
    JNE dividir  
    CMP divisor[1], 0
    JNE dividir
    LEA SI, numeros_invalidos
    CALL print_msg 
    CALL main 
    
    
    
    dividir:                                    
        MOV BX, 1                                ; confirmar que o iterador est� limpo 
        MOV tam_resto, 1
        copiar_num_para_resto: 
        MOV AL, dividendo[BX]
        MOV resto[BX], AL 
        INC BX                                   ; incrementar interador para copiar do array para o resto 
        INC tam_resto                            ; incrementar tamanho do array resto
        MOV AL, tam_dividendo
        SUB AL, tam_dec_dividendo
        CMP AL, BL
        JAE nao_baixar_decimal
        INC tam_dec_resto
        nao_baixar_decimal:
        CMP BX, DX 
        JB copiar_num_para_resto  
        LEA SI, resto                            ; preparar para comparar arrays
        LEA DI, divisor 
        MOV CL, tam_resto 
        MOV DL, tam_divisor   
        PUSH SI
        PUSH DX
        PUSH BX
        CALL compara_arrays                      ; comparar array resto com divisor 
        CMP DX, 1                                ; se DX=1 array � maior ou igual que divisor  
        POP BX   
        POP DX 
        POP SI
        JNE verifica_tipo_divisao                ; se o resto continuar a ser maior, baixar mais numeros 
        PUSH SI
        PUSH DX                                  ; guardar na stack o valor de DX
        PUSH BX                                  ; guardar na stack o valor de BX
        CALL encontrar_multiplo_mul              ; se o resto � maior precisamos come�ar a iterar para saber qual o minimo multiplo entre o resto e o quociente   
        POP BX                                   ; voltar a ir buscar o valor de BX 
        MOV AX, BX
        MOV BL, tam_quo 
        MOV quo[BX], DL                          ; guardar valor do retorno no quociente
        CMP DL, 0  
        JNE continua_divisao
        PUSH BX
        MOV BL, tam_subtrai
        DEC BL
        MOV subtrai[BX], 0   
        POP BX
        continua_divisao:
        MOV BX, AX
        POP DX                                   ; voltar a ir buscar o valor de DX
        INC tam_quo                              ; incrementar tamanho do array quociente
        POP SI
        PUSH DX
        PUSH BX
        CALL subtrai_arrays                      ; subtrair array "subtrai" ao array "resto" 
        POP BX
        POP DX        
        CMP BL, tam_dividendo
        JB itera_div                             ; se ainda n baixamos todas as posi��es voltar a iterar
        JAE verifica_tipo_divisao                ; vai verificar se estamos a efetuar uma divisao inteira ou decimal (para saber se � preciso acrestar zeros no dividento) 
        volta_verifica_tipo_divisao:
        RET                                                                                                                                                                 
          
        itera_div:                               ; antes de iterar temos de limpar o array que subtrai
        PUSH BX 
        PUSH DX
        MOV DL, tam_resto
        CALL limpa_array                         ; porque DI j� tem referencia para array subtrai
        POP DX
        POP BX 
        JMP copiar_num_para_resto                               
        
        verifica_tipo_divisao:
        ; SI j� tem referencia para array resto
        MOV CL, tam_resto                        ; n�o tem problema estragar este valor
        PUSH BX                                  ; guardar valor do iterador principal
        CALL alinha_array_esq                    ; procedimento que alinha array � esquerda (resto)
        MOV tam_resto, CL                        ; o procedimento devolve o novo tamanho do array em CX 
        POP BX                                   ; guardar valor do iterador principal
        CMP div_decimal, 0                       ; verifica se a flag da divisao decimal estiver desativada
        JE volta_verifica_tipo_divisao           ; se n�o for divis�o decimal, volta e termina 
        CMP resto[1], 0                          ; se o resto for 0 a primeira posi��o do resto est� a 0     PODEMOS VERIFICAR TAMB�M PELO TAMANHO DO ARRAY
        JE volta_verifica_tipo_divisao           ; se o resto for 0 termina tamb�m
        MOV AL, tam_quo
        CMP AL, array_size                       ; verificar se atingimos o tamanho maximo q o array pode ter
        JE volta_verifica_tipo_divisao           ; se atingiu tamanho maximo termina
        INC tam_dec_resto                        ; incrementar parte decimal do array
        LEA DI, subtrai
        JMP itera_div                            ; voltar a iterar
    
div_inteira endp 

raiz_quadrada proc
    XOR AX, AX
    XOR CX, CX
    XOR BX, BX  
    XOR DX, DX
    ; se for impar parte inteira acrescentar 0 � esquerda
    ; se for impar na parte decimal acrescentar 0 � direira 
    MOV AL, tam_dec_dividendo                     ; fazer resto da divis�o por dois (parte decimal)
    MOV BX, 2
    DIV BX
    CMP AH, 0                                     ; verificar se parte decimal � �mpar
    JE verificar_parte_inteira
    INC tam_dec_dividendo                         ; incrementar tamanho da parte decimal
    INC tam_dividendo                             ; incrementar tamanho total do array 
    verificar_parte_inteira:
    MOV AL, tam_dividendo                         ; fazer resto da divis�o por dois (tamanho total)
    DIV BX                                                                              
    MOV BX, 1
    CMP AH, 0                                     ; verificar se tamanho do array � par
    JE calcular_raiz
    MOV CX, 1                                     ; procedimento precisa de saber quantas casas tem de andar para a direita
    LEA SI, dividendo                                 ; procedimento precisa de saber refer�ncia do array a alterar
    CALL alinha_array_dir                         ; este procedimento tamb�m estraga o BX 
    INC tam_dividendo   
    ;mov al, tam_dividendo
    
    
    MOV BX, 1                                   ; iniciar iterador
    calcular_raiz:
    ; copiar numeros de 2 em 2 para array resto
    MOV AL, dividendo[BX]
    MOV resto[BX], AL
    INC BX 
    MOV AL, dividendo[BX]
    MOV resto[BX], AL
    INC BX  
    ADD tam_resto, 2
    
    PUSH BX                                       ; guardar valor da posi��o no array
    XOR BX, BX
    INC BX 
    calcular_resul:
        ; cacular resultado : parcial = (2 * resul * 10 + j) * j    
        ; (2 * resul * 10)
        PUSH BX                                   ; guardar valor de j
        MOV DX, 2
        LEA SI, quo
        MOV BL, tam_quo                        ;procedimento precisa saber tamanho do array
        CALL multiplica_por_array                 ; coloca resultado no array subtrai
        ;(2 * resul * 10 + j)  
        MOV DL, tam_subtrai
        POP BX                                    ; retirar valor de j
        MOV DX, BX
        PUSH BX                                   ; guardar valor de j
        LEA SI, subtrai                           ; agora estamos no array subtrai
        CALL soma_array_inteiro
        ; (2 * resul * 10 + j) * j 
        POP BX
        MOV DX, BX  
        PUSH BX 
        MOV BL, tam_subtrai                       ; procedimento precisa saber tamanho do array
        CALL multiplica_por_array                 ; coloca resultado no array subtrai
        ;verifica se resultado obtido � superior ao array resto
        POP bx
        CMP flag_iterador, 1 
        JE subtracao_final
        push bx
        LEA SI, resto
        LEA DI, subtrai                           ; multiplicacao colocou o resultado no array subtrai
        MOV CL, tam_resto                         ; colocar valores nas variaveis corretas para chamar procedimento que compara arrays
        MOV DL, tam_subtrai                       ; colocar valores nas variaveis corretas para chamar procedimento que compara arrays 
        CALL compara_arrays                       ; devolve DX=1 se primeiro array � maior que o segundo   
        POP BX                                    ; retirar valor de j 
        INC BX
        CMP DX, 1                                 ; verifica se o primeiro array � maior que o segundo 
        JE calcular_resul                         ; se for menor voltar a iterar  
        SUB BX, 2
        INC flag_iterador
        JMP calcular_resul
        subtracao_final:
        MOV AX, BX 
        MOV BL, tam_quo
        MOV quo[BX], AL 
        INC tam_quo
        DEC flag_iterador
        CALL subtrai_arrays
    POP BX                                        ; para voltar a iterar array
    CMP BL, tam_dividendo
    JB calcular_raiz 
    MOV CL, tam_resto
    CALL alinha_array_esq                         ; procedimento que alinha array � esquerda (resto)
    MOV tam_resto, CL                             ; o procedimento devolve o novo tamanho do array em CX 
    CMP resto[1], 0                               ; verifica se o resto � 0
    JNE aumentar_array_raiz                       ; precisamos continuar
    RET                                           ; terminar se o resto � 0 e chegamos ao fim do array
    aumentar_array_raiz:
    MOV AL, tam_quo
    CMP AL, array_size                            ; verifica se chegamos ao tamanho m�ximo q o array pode ter
    JNE aumenta
    RET                                           ; se chegamos ao limite do tamanho do resultado terminar
    aumenta: 
    ADD tam_dividendo, 2
    ADD tam_dec_dividendo, 2                      ; aumenta tamanho do array e volta a iterar
    JMP calcular_raiz
    
    ; voltar a iterar at� resto ser 0 ou at� encher tamanho maximo do array
    
raiz_quadrada endp

; PROCEDIMENTO PARA LIMPAR UM ARRAY - recebe refer�ncia para array em DI e tamanho do array em DL   
limpa_array proc
    XOR BX, BX       
    MOV BL, DL
    itera_limpa_array:
    MOV [DI+BX], 0 
    DEC BL
    CMP BL, 0
    JA itera_limpa_array
    RET  
    
limpa_array endp 

; ---------------------------------------------------------------- PARTE DOS FICHEIROS ----------------------------------------------------------------

open_file proc
    MOV AH, 3Dh
    MOV AL, 0                                            ; 1- escrita, 0- leitura, 2-leitura/escrita 
    LEA DX, dir_ficheiro
    INT 21h                                              ; se flag activar, AX fica com c�digo do erro, sen�o AX fica com o ID do ficheiro
    MOV ID_ficheiro, AX
    
    RET    
open_file endp

close_file proc
    MOV BX, ID_ficheiro
    MOV AH, 3Eh
    INT 21h                                               ; se der erro a fechar AX guarda erro do c�digo
    RET
close_file endp

open_file_output proc
    MOV AH, 3Dh
    MOV AL, 1                                            ; 1- escrita, 0- leitura, 2-leitura/escrita 
    LEA DX, dir_ficheiro_output
    INT 21h                                              ; se flag activar, AX fica com c�digo do erro, sen�o AX fica com o ID do ficheiro
    MOV ID_ficheiro_output, AX
    
    RET    
open_file_output endp

close_file_output proc
    MOV BX, ID_ficheiro_output
    MOV AH, 3Eh
    INT 21h                                               ; se der erro a fechar AX guarda erro do c�digo
    RET
close_file_output endp 

write_file_output proc              ;RECEBER EM CX NR CARACTERES A IMPRIMIR  E EM DX REFERENCIA DE MEMORIA PARA O Q QUER IMRIMIR    
    MOV BX, ID_ficheiro_output 
    MOV AH, 40h
    INT 21H
    RET
write_file_output endp

read_file proc
    itera_ficheiro:
        MOV BX, ID_ficheiro
        MOV CX, 10                                        ; ler 10 posicoes  
        LEA DX, bloco                                     ; referencia para onde ele vai coloar os 10 valores qur mandei ler
        MOV AH, 3Fh                                       ;INTERRUP��O PARA LER BLOCO (l� 10 posi��es de cada vez)
        INT 21h 
        CMP AL, 10                                        ; verificar se leu 10 digitos (por causa do fim do ficheiro)
        JE ler_tipo_escrita
        RET
        ler_tipo_escrita:
        MOV AL, 1                                         ; current file position   
        MOV DX, 2                                         ; quero saltar 2 posi��es (lixo: enter + alinhamento do ponteiro)
        XOR CX, CX                                        ; tem de ser 0 porque o meu numero est� em CX:DX
        MOV AH, 42h
        INT 21h                                           ; INTERRUP��O DO SEEK (2 posi��es)
        LEA DX, lei_esc
        MOV CX, 1                                         ; ler apenas 1 posicao
        MOV AH, 3Fh                                       ; interrup��o para ler o R ou o W
        INT 21h
        CALL calcular_blocos
        CALL apresenta_bloco
        CALL apresenta_conjunto
        CALL apresenta_bloco_ini 
        CALL bloco_colocado  
        CALL leitura_escrita  
        CALL prt_hit_miss
        CALL prt_descricao
        CALL termina_linha 
        MOV BX , ID_ficheiro                          
        MOV AL, 1                                         ; current file position   
        MOV DX, 3                                         ; quero saltar 3 posi��es (lixo: parentesis +  enter + alinhamento do ponteiro)
        XOR CX, CX                                        ; tem de ser 0 porque o meu numero est� em CX:DX
        MOV AH, 42h                                       ; INTERRUP��O DO SEEK
        INT 21h 
        JMP itera_ficheiro
read_file endp  

calcula_nr_bits proc
    ; NR_BLOCOS/MAPEAMENTO
    XOR AX, AX      
    XOR BX, BX
    MOV AL, n_blocos
    DIV mapeamento                                        ; numero_blocos / mapeamento
    MOV DX, AX
    MOV AX, 1 
    MOV CX, 2
    iteracao_bits:
        INC BX                                            ; 2^BX
        PUSH DX
        MUL CX                                            ; 2*2*2...
        POP DX
        CMP AX, DX                                        ; verificar se 2^BX = numero_blocos/mapeamento
        JNE iteracao_bits
        MOV tam_index, BL                                 ; sabemos que tam_index = BX e que  tag = 10 - tam_index
    RET    
calcula_nr_bits endp

calcular_blocos proc 
    XOR AX, AX
    LEA SI, bloco
    MOV BX, 10                                             ; come�ar do final do array
    calcula_conjunto:
        DEC BX  
        MOV DX, 10
        SUB DX, BX                                         ; DX � O EXPOENTE 
        CMP DL, tam_index                                  ; verificar se j� terminou de calcular o index
        JLE nao_terminou
        XOR AX, AX
        XOR DX, DX 
        JMP calcula_tag
        nao_terminou:
        CMP BYTE PTR [SI+BX], 31h                          ; verifica se � 0 ou 1 (comparamos 30 E 31 por causa da tabela ASCII)
        JNE calcula_conjunto
        DEC DX                                             ; acerta expoente
        CMP DX , 0                                         ; primeira iteracao 2^0
        JNE segunda_verificacao
        MOV AX, 1
        JMP calcula_conjunto 
        segunda_verificacao:
        CMP DX , 1                                         ; segunda iteracao 2^1
        JNE segue_calcular_expoente
        ADD AX, 2
        JMP calcula_conjunto 
        segue_calcular_expoente:
        MOV CX, 2 
        PUSH BX
        PUSH AX 
        MOV BX, 1
        MOV AX, 2
        ciclo_expoente:
            INC BX
            PUSH DX
            MUL CX                                          ; 2*2*2*2......
            MOV CX, AX
            MOV AX, 2
            POP DX
            CMP BX, DX                                      ; at� numero de ciclos ser = DX ( 2 ^ DX )
            JL ciclo_expoente
        POP AX
        ADD AX, CX                                          ; adiciona ao valor que j� estava em AX (conjunto)
        POP BX 
    MOV conjunto, AL  
    JMP calcula_conjunto  
    
    calcula_tag:
        CMP BYTE PTR [SI+BX], 31h
        JNE verifica_fim_tag
        CMP DX, 0
        JNE segunda_verificacao_tag 
        MOV AX, 1
        JMP verifica_fim_tag
        segunda_verificacao_tag:
        CMP DX, 1
        JNE calcular_expoente_tag
        ADD AX, 2
        JMP verifica_fim_tag
        calcular_expoente_tag:
            MOV CX, 2 
            PUSH BX
            PUSH AX 
            MOV BX, 1
            MOV AX, 2
            ciclo_expoente_tag:
                INC BX
                PUSH DX
                MUL CX                                          ; 2*2*2*2......
                MOV CX, AX
                MOV AX, 2
                POP DX
                CMP BX, DX                                      ; at� numero de ciclos ser = DX ( 2 ^ DX )
                JL ciclo_expoente_tag
            POP AX
            ADD AX, CX                                          ; adiciona ao valor que j� estava em AX (conjunto)
            POP BX 
        MOV tag, AL     
        
        verifica_fim_tag:
        CMP BX, 0
        JNE itera_tag
        RET
        itera_tag:
            DEC BX        
            INC DX
            JMP calcula_tag
    
calcular_blocos endp 

apresenta_bloco proc
    LEA SI, bloco  
    XOR AX, AX
    XOR BX, BX  
    XOR DX, DX 
    XOR CX, CX
    DEC BX
    ciclo_apresentar_endereco: 
        INC BX
        MOV DL, BYTE PTR [SI+BX] 
        MOV caracter, DL
        LEA DX, caracter    
        MOV CX, 1  
        PUSH BX
        CALL write_file_output
        POP BX
        CMP BX, 10
        JNE ciclo_apresentar_endereco 
    XOR BX, BX
    ciclo_espacos_inicial:
        INC BX 
        MOV AH, 2
        MOV DL, " "
        MOV caracter, DL
        LEA DX, caracter
        MOV CX, 1   
        PUSH BX
        CALL write_file_output 
        POP BX
        CMP BX , 5
        JNE ciclo_espacos_inicial    
    LEA DX, coluna_seg
    MOV CX, 3
    CALL write_file_output
    MOV CX, 10
    SUB CL, tam_index
    DEC CX 
    XOR BX, BX
    DEC BX
    ciclo_apresentar_tag_b:  
        INC BX
        MOV DL, BYTE PTR [SI+BX]
        MOV caracter, DL
        LEA DX, caracter 
        PUSH CX
        PUSH BX
        MOV CX, 1 
        CALL write_file_output
        POP BX
        POP CX
        CMP BL, CL
        JNE ciclo_apresentar_tag_b   
    ciclo_espacos_tag:
        INC BX 
        MOV AH, 2
        MOV DL, " "
        MOV caracter, DL
        LEA DX, caracter
        MOV CX, 1   
        PUSH BX
        CALL write_file_output 
        POP BX
        CMP BX , 9
        JNE ciclo_espacos_tag         
    LEA DX, coluna_seg
    MOV CX, 3
    CALL write_file_output 
    MOV BL, 10
    SUB BL, tam_index
    DEC BX
    XOR DX, DX
    MOV AH, 2
    MOV DL, tag                                                 ; valor calculado - vai ter de se fazer divisoes sucessivas para imprimir   (EST� EM HEXADECIMAL)  
    PUSH BX 
    call converte_ascii
    ciclo_espacos_tagd:
        MOV DL, " " 
        PUSH CX
        MOV caracter, DL
        LEA DX, caracter
        MOV CX, 1
        CALL write_file_output
        POP CX
        INC CX
        CMP CX , 11
        JNE ciclo_espacos_tagd  
    LEA DX, coluna_seg
    MOV CX, 3
    CALL write_file_output  
    POP BX
    ciclo_apresentar_tag_d:
        INC BX 
        MOV DL, BYTE PTR [SI+BX] 
        MOV caracter, DL
        LEA DX, caracter
        MOV CX, 1  
        PUSH BX
        CALL write_file_output 
        POP BX
        CMP BX, 8
        JNE ciclo_apresentar_tag_d
    MOV CL, 10
    SUB CL, tam_index
    XOR BX, BX
    DEC BX  
    INC CX
    ciclo_espacos_index:
        INC BX
        MOV DL, " "  
        PUSH BX
        PUSH CX
        MOV caracter, DL
        LEA DX, caracter
        MOV CX, 1
        CALL write_file_output
        POP CX
        POP BX
        CMP BX , CX
        JNE ciclo_espacos_index
    LEA DX, coluna_seg
    MOV CX, 3
    CALL write_file_output 
    MOV DL, conjunto                                              ; valor calculado - vai ter de se fazer divisoes sucessivas para imprimir   (EST� EM HEXADECIMAL) 
    CALL converte_ascii
    ciclo_espacos_indexd:
        MOV DL, " " 
        MOV caracter, DL
        LEA DX, caracter 
        PUSH CX
        MOV CX, 1
        CALL write_file_output 
        POP CX
        INC CX
        CMP CX , 12
        JNE ciclo_espacos_indexd  
    LEA DX, coluna_seg
    MOV CX, 3
    CALL write_file_output 
          
    RET
apresenta_bloco endp  

apresenta_conjunto proc
    MOV DX, "S"
    MOV caracter, DL
    LEA DX, caracter
    MOV CX, 1
    CALL write_file_output  
    MOV AL, conjunto
    MOV DX, AX
    call converte_ascii
    ciclo_espacos_conjunto:
        MOV DL, " "
        MOV caracter, DL
        LEA DX, caracter    
        PUSH CX
        MOV CX, 1
        CALL write_file_output  
        POP CX
        INC CX
        CMP CX , 6
        JNE ciclo_espacos_conjunto 
    LEA DX, coluna_seg
    MOV CX, 3
    CALL write_file_output 
    RET
apresenta_conjunto endp 

apresenta_bloco_ini proc
    MOV DX, "B"
    MOV caracter, DL
    LEA DX, caracter
    MOV CX, 1
    CALL write_file_output
    MOV AL, conjunto
    MUL mapeamento
    MOV DX, AX 
    MOV bloco_ini, AL
    call converte_ascii
    ciclo_espacos_bloco_ini:
        MOV DL, " "
        MOV caracter, DL
        LEA DX, caracter
        PUSH CX
        MOV CX, 1
        CALL write_file_output
        POP CX 
        INC CX
        CMP CX , 11
        JNE ciclo_espacos_bloco_ini 
    LEA DX, coluna_seg
    MOV CX, 3
    CALL write_file_output
    RET
apresenta_bloco_ini endp 

bloco_colocado proc 
    XOR BX, BX
    XOR AX, AX
    XOR CX, CX   
    XOR DX, DX
    MOV AL, bloco_ini                       ; AL TEM VALOR bloco_ini
    MOV DL, tag                             ; DL tem valor da tag
    CMP algoritmo, 1                        ;1=FIFO
    JE fifo
        
        fifo:                                   ; iterar a cache para ver se encontramos o bloco 
        CMP cache[BX], AL
        JNE fifo_nao_encontrou_bloco
        
            PUSH BX
            XOR BX, BX                          ; encontrou bloco, vamos procurar tag
            ciclo_encontrar_tag:
                ADD BX, 3
                INC CL                          ; guarda, nr de iteracoes q ja fez
                CMP cache[BX], DL               ; verifica se encontrou tag            
                JE encontrou_tag                 
                CMP cache[BX], 0                ; cache nao cheia
                JE fifo_prepara_colocar_bloco
                
                ;TAG NAO ECONTRADA, DEVE ITERAR?
                CMP CL, mapeamento              ; verifica se j� procurou todas as tags
                JNE ciclo_encontrar_tag     
                
                fifo_prepara_colocar_bloco:
                    MOV hit_miss, 0 
                    POP BX
                    MOV hit_miss, 0 
                    CMP lei_esc, 52h             ;estamos a ler ou a escrever?? 52=Read ; 57=W   
                
                JNE fifo_escrita_nao_encontrado  ; READ MISS FIFO 
                
                fifo_colocar_bloco:
                    INC BL                      ; ver onde vamos colocar bloco
                    MOV CL, cache[BX]           ; guardar em CL, posicao a colocar
                    CMP CL, mapeamento          ; verificar se bloco esta cheio 
                    JE fifo_bloco_cheio
                        ADD cache[BX], 1        ; incrementar proxima posicao a alterar
                        INC CL
                        JMP fifo_alterar_bloco
                    fifo_bloco_cheio:
                        MOV cache[BX], 1        ; proxima posicao a alterar � a primeira  
                        MOV CL, 1
                    fifo_alterar_bloco:
                        DEC BL
                        PUSH AX
                        MOV AL, bloco_ini
                        ADD AL, CL  
                        DEC AL
                        MOV colocado, AL        ; guardar bloco colocado
                        MOV AL, CL
                        MOV CL, 3
                        MUL CL                  ; calcular posicao do bloco
                        MOV CL, AL
                        ADD BL, CL 
                        MOV AL, colocado  
                        DEC BX
                        MOV cache[BX], AL
                        MOV posicao_col, BL
                        INC BL
                        MOV AL, tag                  
                        MOV cache[BX], AL  
                        INC BL 
                        MOV AL, cache[BX]
                        MOV dirty_bit, AL 
                        POP AX   
                        CMP lei_esc, 57h          ; 57 WRITE
                        JNE fifo_lidar_DB 
                        JMP terminar_blobo_colocado
                        
                fifo_escrita_nao_encontrado:       ;WRITE MISS FIFO 
                    CMP politica, 03H                ; verificar se � NWA + WB
                    JE fifo_escrita_NWA                  
                    CMP politica, 04H                ; verificar se � NWA + WT
                    JE fifo_escrita_NWA      
                    JMP fifo_colocar_bloco   
                      
                    fifo_escrita_NWA:              ;escrita + miss + NWA
                        MOV flag_nao_colocado, 1        ; apenas escrevemos na RAM    
                        JMP terminar_blobo_colocado
                    
                 fifo_lidar_DB: 
                    CMP politica, 01H                 ; � WB + WA ? 
                    JNE terminar_blobo_colocado     ; se for WT + WA nao ativar DB
                        MOV cache[BX], 1            ; se fot WB + WA ativar DB
                        JMP terminar_blobo_colocado                       
                    
        fifo_nao_encontrou_bloco:
            CMP cache[BX], 0            ; se o bloco est� vazio
            JNE iterar_blocos_fifo
                MOV AL, bloco_ini
                MOV cache[BX], AL
                INC BL
                MOV cache[BX], 1
                INC BL
                MOV colocado, AL
                MOV cache[BX], AL
                INC BL
                MOV AL, tag
                MOV cache[BX], AL
                MOV dirty_bit, 0
                MOV posicao_col, 1    
                JMP terminar_blobo_colocado
            iterar_blocos_fifo:
                ADD BL, 8
                CMP BL, 50H             ; ja procuramos 10x?
                JNE fifo
                JMP terminar_blobo_colocado   
        
                           
                encontrou_tag:           
                MOV hit_miss, 1             ; ENCONTROU TAG
                DEC BL                      ; guardar posicao do bloco colocado
                MOV posicao_col, BL  
                MOV AL, cache[BX]       
                MOV colocado, AL            ; guardar valor do bloco colocado (ainda temos de ver se � colocado ou nao) 
                MOV flag_nao_colocado, 1    ; temos de imprimir um "-" no sitio do colocado    (nao colocamos com RH nem WH, apenas precisamos de saber se � para ativar DIRTY_BIT)
                CMP lei_esc, 52h            ;estamos a ler ou a escrever?? 52=Read ; 57=W
                JNE escrita_encontrado
                    MOV dirty_bit, 0        ; estamos a ler e encontramos    
                    POP BX
                    JMP terminar_blobo_colocado     
                escrita_encontrado:         ; ESTAMOS A ESCREVER precisamos de saber se � WB ou WT
                    CMP politica, 1 
                    JNE hit_escrita_WB
                        ADD BL, 2
                        MOV cache[BX], 1     ; ativar DB para este bloco
                        JMP hit_escrita_WT    
                    hit_escrita_WB:       
                    CMP politica, 3
                    JNE hit_escrita_WT
                        ADD BL, 2
                        MOV cache[BX], 1     ; ativar DB para este bloco   
                    hit_escrita_WT: 
                        MOV dirty_bit, 0   
                        POP BX
                        JMP terminar_blobo_colocado 
                            

    
    terminar_blobo_colocado:
        MOV DL, "B" 
        MOV caracter, DL
        LEA DX, caracter
        MOV CX, 1
        CALL write_file_output
        MOV DL, colocado   
        CALL converte_ascii
        JAE ciclo_espacos_bloco_colocado
        MOV DL, " "
        MOV caracter, DL
        LEA DX, caracter
        MOV CX, 1
        CALL write_file_output 
        MOV CX, 1
        ciclo_espacos_bloco_colocado:
        MOV DL, " "
        MOV caracter, DL
        LEA DX, caracter
        PUSH CX
        MOV CX, 1
        CALL write_file_output 
        POP CX
        INC CL
        CMP CL , 12
        JNE ciclo_espacos_bloco_colocado
        LEA DX, coluna_seg
        MOV CX, 3
        CALL write_file_output
    
    RET
bloco_colocado endp    

leitura_escrita proc
    LEA DX, lei_esc
    MOV CX, 1
    CALL write_file_output 
    MOV CX, 1
    ciclo_espacos_lei_esc:
        MOV DL, " "
        MOV caracter, DL
        LEA DX, caracter
        PUSH CX
        MOV CX, 1
        CALL write_file_output
        POP CX
        INC CL
        CMP CL , 15
        JNE ciclo_espacos_lei_esc
    LEA DX, coluna_seg
    MOV CX, 3
    CALL write_file_output     
    
    RET    
leitura_escrita endp   

prt_hit_miss proc  
    mov ah, hit_miss
    CMP hit_miss, 1
    JE existe_hit
        MOV DL, "M"
        MOV caracter, DL 
        LEA DX, caracter   
        JMP mostra_hit_miss
    existe_hit:
    MOV DL, "H"
    MOV caracter, DL 
    LEA DX, caracter
    mostra_hit_miss:
    MOV CX, 1
    CALL write_file_output 
    MOV CX, 1
    ciclo_espacos_hit_miss:
        MOV DL, " " 
        MOV caracter, DL
        LEA DX, caracter
        PUSH CX
        MOV CX, 1
        CALL write_file_output
        POP CX  
        INC CX
        CMP CX , 8
        JNE ciclo_espacos_hit_miss
    LEA DX, coluna_seg
    MOV CX, 3
    CALL write_file_output                
  
    RET    
prt_hit_miss endp  

prt_descricao proc 
    XOR BX, BX
    XOR AX, AX  
    ciclo_encontrar_bloco_desc:
    MOV AL, bloco_ini  
    MOV CX, 1
    CMP cache[BX], AL
    JNE iterar_descricao
        MOV AL, tag
        ADD BL, 3
        CMP cache[BX], AL
        INC CL
        CMP CL, mapeamento                 ; posicao fica em CL
        JNE iterar_descricao
        JMP imprimir_desc
    iterar_descricao:  
        ADD BL, 8
        CMP BX, 50h                         ; ja procuramos 10x?
        JNE ciclo_encontrar_bloco_desc
  
    imprimir_desc:
    CMP lei_esc, 52h                        ; read  (se for write � 57)
    JNE vamos_escrever
        CMP hit_miss, 1                     ; 0=miss; 1=hit
        JNE miss_leitura
            ; TAcesso * Posicao(CL) + TAcesso 
            MOV AX, TAcesso
            MUL CX
            ADD AX, TAcesso
            MOV DX, AX 
            CALL converte_ascii_16 
            JMP fim_imprime_descricao 
        miss_leitura: 
            ; DB(ESCRITA_RAM) + TAcesso * i + Trf_Ram_Cache + TAcesso    >>> atribuir bloco 
            CMP dirty_bit, 0
            JE nao_ha_db_leitura
                MOV AX, TAcesso
                MUL CX
                ADD AX, escrita_ram
                ADD AX, trf_ram_cache
                ADD AX, TAcesso
                MOV DX, AX
                CALL converte_ascii_16 
                JMP fim_imprime_descricao
            nao_ha_db_leitura:
                MOV AX, TAcesso
                MUL CX
                ADD AX, trf_ram_cache
                ADD AX, TAcesso
                MOV DX, AX
                CALL converte_ascii_16 
                JMP fim_imprime_descricao
    vamos_escrever:                         ; write     
        CMP hit_miss, 1                     ; 0=miss; 1=hit                                          ;BLOCO COLOCADO
        JNE miss_escrita
            CMP politica, 1                 ; 1 = WB + WA
            JNE politica_2
                ; CALCULAR TAcesso * Posicao(CL) + escrita_na_cache (ativar db)
                MOV AX, TAcesso
                MUL CX
                ADD AX, escrita_cache
                MOV DX, AX 
                CALL converte_ascii_16 
                JMP fim_imprime_descricao 
            
            politica_2: 
            CMP politica, 2                 ; 2 = WT + WA
            JNE politica_3 
                ; CALCULAR TAcesso * Posicao(CL) + escrita_ram
                MOV AX, TAcesso
                MUL CX
                ADD AX, escrita_ram
                MOV DX, AX 
                CALL converte_ascii_16 
                JMP fim_imprime_descricao
                
            politica_3:  
            CMP politica, 3                 ; 3 = WB  + NWA 
            JNE politica_4
                ; CALCULAR TAcesso * Posicao(CL) + escrita_na_cache (ativar db)
                MOV AX, TAcesso
                MUL CX
                ADD AX, escrita_cache
                MOV DX, AX 
                CALL converte_ascii_16 
                JMP fim_imprime_descricao        
                
            politica_4:                     ; WT + NWA
                ; CALCULAR TAcesso * Posicao(CL) + escrita_ram
                MOV AX, TAcesso
                MUL CX
                ADD AX, escrita_ram
                MOV DX, AX 
                CALL converte_ascii_16 
                JMP fim_imprime_descricao
                
        miss_escrita:                                                                                 ; BLOCO NAO COLOCADO
            CMP politica, 1                 ; 1 = WB + WA
            JNE politica_miss_2
                ; DB(ESCRITA_RAM) + TAcesso * i + Trf_Ram_Cache + escrita_cache (ativar db)
            CMP dirty_bit, 0
            JE nao_ha_db_escrita
                MOV AX, TAcesso
                MUL CX
                ADD AX, escrita_ram
                ADD AX, trf_ram_cache
                ADD AX, TAcesso
                MOV DX, AX
                CALL converte_ascii_16 
                JMP fim_imprime_descricao
            nao_ha_db_escrita:
                MOV AX, TAcesso
                MUL CX
                ADD AX, trf_ram_cache
                ADD AX, escrita_cache
                MOV DX, AX
                CALL converte_ascii_16 
                JMP fim_imprime_descricao
                    
            politica_miss_2:   
            CMP politica, 2                 ; 2 = WT + WA
            JNE politica_miss_3
                ; DB(ESCRITA_RAM) + TAcesso * i + Trf_Ram_Cache + escrita_ram 
            CMP dirty_bit, 0
            JE nao_ha_db_escrita2
                MOV AX, TAcesso
                MUL CX
                ADD AX, escrita_ram
                ADD AX, trf_ram_cache
                ADD AX, TAcesso
                MOV DX, AX
                CALL converte_ascii_16 
                JMP fim_imprime_descricao
            nao_ha_db_escrita2:
                MOV AX, TAcesso
                MUL CX
                ADD AX, trf_ram_cache
                ADD AX, escrita_ram
                MOV DX, AX
                CALL converte_ascii_16 
                JMP fim_imprime_descricao   
                
            politica_miss_3:                ; 3 e 4 NWA faz-se igual independentemente de ser WT ou WB
                ; DB(ESCRITA_RAM) + TAcesso * i + escrita_RAM   >>>> N�o � colocado em nenhum bloco na cache 
            CMP dirty_bit, 0
            JE nao_ha_db_escrita3
                MOV AX, TAcesso
                MUL CX
                ADD AX, escrita_ram
                ADD AX, trf_ram_cache
                ADD AX, TAcesso
                MOV DX, AX
                CALL converte_ascii_16 
                JMP fim_imprime_descricao
            nao_ha_db_escrita3:
                MOV AX, TAcesso
                MUL CX
                ADD AX, escrita_ram
                MOV DX, AX
                CALL converte_ascii_16 
                JMP fim_imprime_descricao
                
    fim_imprime_descricao: 
            
    RET
prt_descricao endp

termina_linha proc
    ciclo_espacos_temp_bloco:
        MOV DL, " " 
        MOV caracter, DL
        LEA DX, caracter
        PUSH CX
        MOV CX, 1
        CALL write_file_output
        POP CX  
        INC CL
        CMP CL , 18
        JNE ciclo_espacos_temp_bloco
        
    LEA DX, muda_linha
    MOV CX, 9
    CALL write_file_output
    
    RET
termina_linha endp

converte_ascii proc                         ; recebe o valor em DL  - divisoes sucessivas por 10(0AH)       
    XOR AX, AX
    MOV AL, DL 
    XOR DX, DX
    MOV CX, 0AH 
    XOR BX, BX
    itera_converter:
        DIV CL 
        INC BX
        PUSH AX
        XOR AH, AH
        CMP AL, 0
        JNE itera_converter 
    MOV CL, BL 
    itera_resolve_nr:
        POP AX  
        DEC BX 
        MOV DL, AH
        ADD DL, 30H
        MOV caracter, DL
        LEA DX, caracter
        MOV CX, 1
        PUSH BX    
        CALL write_file_output 
        POP BX                           ;imprime no ecr� em decimal
        CMP BX, 0
        JNE itera_resolve_nr    
    termina_conversao:                      ; DEVOLVE EM CX NR DE CARACTERES IMPRIMIDOS
    RET
converte_ascii endp   

converte_ascii_16 proc                         ; recebe o valor em DL  - divisoes sucessivas por 10(0AH)       
    XOR AX, AX
    MOV AX, DX 
    XOR DX, DX
    MOV CX, 0AH 
    XOR BX, BX
    itera_converter_16:
        DIV CX 
        INC BX
        PUSH DX
        XOR DX, DX
        CMP AX, 0
        JNE itera_converter_16 
    MOV CX, BX 
    itera_resolve_nr_16:
        POP DX  
        DEC BX 
        ADD DX, 30H    
        MOV caracter, DL
        LEA DX, caracter
        MOV CX, 1
        PUSH BX    
        CALL write_file_output 
        POP BX                             ;imprime no ecr� em decimal
        CMP BX, 0
        JNE itera_resolve_nr_16    
    termina_conversao_16:                      ; DEVOLVE EM CX NR DE CARACTERES IMPRIMIDOS
    RET
converte_ascii_16 endp 

apresenta_tabela proc 
    MOV CX, 903
    LEA DX, cabecalho
    CALL write_file_output
    RET    
apresenta_tabela endp

END