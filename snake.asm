;GRUPO: 
;
; JOSÉ GUSTAVO VICTOR PINHEIRO ALENCAR / 14783765 
; MANASSÉS ARANGE DE MOURA
; LARISSA DE MELO ANDRADE 
; CAROLINA GOMES GUERRERO
; SNAKE ICMC


SnakePos:  	var #500 ; tamanho MAXIMO da snake - Array para posições da cobra
SnakeTam:	var #1   ; tamanho atual da cobra
Direcao:		var #1   ; Direção da cobra (0-Direita, 1-baixo, 2-esquerda, 3-cima)

FoodPos:	var #1    ; posição da comida
FoodStatus:	var #1    ; status da comida (se precisa ser recolocada ou não)
Pontuacao:      var #1    ; pontuação do jogador
Fase:      var #1    ; nível/fase atual do jogo
Velocidade:      var #1    ; Velocidade de jogo (usada no delay)
FlagTiro:   var #1    ; flag indicando se tiro está ativo
posAtualTiro: var #1   ; posição atual do tiro
posAntTiro: var #1     ; posição anterior do tiro

GameOverMessage: 	string " FIM DE JOGO, ICMCER! "
EraseGameOver:		string "           "
RestartMessage:		string " TENTE NOVAMENTE! APERTE 'SPACE' "
EraseRestart:		string "                          "

SuccessMessage: 		string " DIVOOOOOOOUUUUU!!! "
EraseSuccessMessage: 	string "                 "
NextLevelMessage: 		string " APERTE 'SPACE' E CONTINUE "
EraseNextLevelMessage:	string "                               "


inicialLinha0  : string "                                        "
inicialLinha1  : string "                                        "
inicialLinha2  : string "       _____             _              "
inicialLinha3  : string "      / ____|           | |             "
inicialLinha4  : string "     | (___  _ __   __ _| | _____       "
inicialLinha5  : string "      z___ z| '_ z / _` | |/ / _ z      "
inicialLinha6  : string "      ____) | | | | (_| |   <  __/      "
inicialLinha7  : string "     |_____/|_| |_|z__,_|_|z_z___|      "
inicialLinha8  : string "                                        "
inicialLinha9  : string "                                        "
inicialLinha10 : string "       _____ _____ __  __  _____        "
inicialLinha11 : string "      |_   _/ ____|  z/  |/ ____|       "
inicialLinha12 : string "        | || |    | z  / | |            "
inicialLinha13 : string "        | || |    | |z/| | |            "
inicialLinha14 : string "       _| || |____| |  | | |____        "
inicialLinha15 : string "      |_____z_____|_|  |_|z_____|       "
inicialLinha16 : string "                                        "
inicialLinha17 : string "                                        "
inicialLinha18 : string "                                        "
inicialLinha19 : string "                                        "
inicialLinha20 : string "       APERTE SPACE PARA INICIAR        "
inicialLinha21 : string "                                        "
inicialLinha22 : string "                                        "
inicialLinha23 : string "                                        "
inicialLinha24 : string "                                        "
inicialLinha25 : string "                                        "
inicialLinha26 : string "                                        "
inicialLinha27 : string "                                        "
inicialLinha28 : string "                                        "
inicialLinha29 : string "                                        "




tela_de_inicio_original:

	loadn R1, #inicialLinha0	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn R2, #512
	call Desenha_Fase

tela_de_inicio_botao:
	inchar 	r3
	loadn 	r4, #' '	
	cmp r3, r4

	jne tela_de_inicio_botao
		





; Main
main:
	
	; inicializando o jogo, chamando as subrotinas e carregando a tela inicial
	call Inicia_Velocidade ; velocidade = 600
	call Inicia_flag_e_tiro ; estado do tiro = 0 ou 1; posicao do tiro (atual e anterior)
	call Inicia

	; subrotina completa para desenhar uma fase
	loadn R1, #tela1Linha0	; Endereco da primeira linha do ambiente do jogo
	loadn R2, #0
	call Desenha_Fase



	call Inicia_Pontuacao	; inicia o placar
	call Inicia_Fase_numero	; inicia o numero da fase
	
	loop:
		
		ingame_loop:
			call Draw_Snake
			
			call Fase_colisoes ; verifica colisões 
			
			call Move_Snake
			call Replace_Food
					
			call Delay
				
				
			jmp ingame_loop
		GameOver_loop:
			call tela_final_perdeu
			call Restart_Game
			
			
			jmp GameOver_loop
			
		GameOver_Ganhar:
			call tela_final_ganhou
			call Restart_Game
			jmp GameOver_Ganhar

			
	
; Funções






Fase_colisoes:
	
	load r3, Fase
	loadn r4, #48 ; r4 = 0
	

	cmp r3, r4 ; if r3 == r4 ou fase_atual == Fase1 => jump Fase1
	jeq Fase1
	
	inc r4 ; se não for 0, incrementa 1, ou seja, r4 = 1
	
	cmp r3, r4 ; mesmo processo da Fase1
	jeq Fase2
	
	inc r4 ; r4 = 2
	
	cmp r3, r6 ; MUDANCA DO GPT AQUIIIIIIIIIIIIIIIIIIII r3, r6
	jeq Fase3

	inc r4 ; r4 = 3
	
	;cmp r3, r4
	;jeq Fase4 
	
	Fase1: 
	call Morte_Snake_1	
	jmp fim ; fim do jogo

	Fase2:
	call Morte_Snake_2
	jmp fim
	
	Fase3:
	call Morte_Snake_3
	call Torre
	;jmp fim ; MUDANCA DO GPT AQUIIIIIIIIIIIIIIIIIIII

	;Fase4:
	;call Morte_Snake_4
	;jmp fim
	
	fim:
	rts	

Inicia_Pontuacao:
	
	loadn r0, #48 ; inicializa a pontuação com zer
	store Pontuacao, r0 ; carrega a pontação no Pontuacao
	
	loadn r1, #9 ; posição da pontuação na tela
	load r2, Pontuacao  
	
	outchar r2, r1 ; MUDAR A COOOOOOOOOOR
	 
	rts
	
Inicia_Fase_numero:
	
	loadn r0, #48 
	store Fase, r0 ; carrega no endereço Fase com zero
	
	loadn r1, #49
	load r2, Fase
	
	outchar r2, r1
	 
	rts

Inicia_Velocidade:
	
	loadn r0, #6000 
	store Velocidade, r0 ; carrega o Velocidade com 6000
		 
	rts

Inicia_flag_e_tiro:
	
	loadn r0, #0
	store FlagTiro, r0 ; indica se o tiro está ativo ou não
		
	loadn r1, #1019
	store posAtualTiro, r1 ; posAtualTiro guarda a posição do tiro na tela, inicialmente 1019
		
	loadn r2, #1059
	store posAntTiro, r2 ; posição anterior do tiro para dar ideia de movimento
				
						 
	rts	
	
Inicia: ; 1. inicia o tamanho da cobra 2. declara cada pedaço da cobra 3. printa a cobra 4. inicia a direcao inicial da cobra
		push r0
		push r1
		
		loadn r0, #3
		store SnakeTam, r0 ; tamanho inicial da cobra
		
		; SnakePos[0] = 460
		loadn 	r0, #SnakePos
		loadn 	r1, #460
		storei 	r0, r1
		
		; SnakePos[1] = 459
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		; SnakePos[2] = 458
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		; SnakePos[3] = 457
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		; SnakePos[4] = -1
		inc 	r0
		loadn 	r1, #0
		storei 	r0, r1

		
		
				
		call FirstPrintSnake ; printa a cobra inicial
		
		loadn r0, #0
		store Direcao, r0 ; Direção da cobra (0-Direita, 1-baixo, 2-esquerda, 3-cima)
		
		pop r1
		pop r0
		
		rts

FirstPrintSnake:
	push r0
	push r1
	push r2
	push r3					; CASO DE TEMPO, MUDE O CORPO DA CABEÇA
	
	loadn r0, #SnakePos		; r0 = endereço do array da cobra
	loadn r1, #'%'			; caractere da cobra
	loadi r2, r0			; r2 = SnakePos[0]
		
	loadn 	r3, #0			; r3 = 0
	
	Print_Loop:
		outchar r1, r2      ; imprime '%' na posição r2 (posição da cobra)
		
		inc 	r0
		loadi 	r2, r0
		
		cmp r2, r3
		jne Print_Loop     ; imprime até chegar no -1
	
	; imprime a comida do inicio 
	loadn 	r0, #820 ; posição da comida
	loadn 	r1, #'.' ; . -> comida
	outchar r1, r0
	store 	FoodPos, r0
	
	pop	r3
	pop r2
	pop r1
	pop r0
	
	rts
	
EraseSnake:
	push r0
	push r1
	push r2
	push r3
	
	loadn 	r0, #SnakePos		
	inc 	r0
	loadn 	r1, #' '			; caractere espaço para apagar
	loadi 	r2, r0			; r2 = SnakePos[0]
		
	loadn 	r3, #0			; r3 = 0
	
	Print_Loop:
		outchar r1, r2    ; imprime espaço na tela, apagando parte da cobra
		
		inc 	r0
		loadi 	r2, r0
		
		cmp r2, r3
		jne Print_Loop
	
	pop	r3
	pop r2
	pop r1
	pop r0
	
	rts



Desenha_Fase: ; desenha a fase 30 linhas por 40 colunas (1200 posições)
	
	push r0	
	push r1	
	push r2	
	push r3	
	push r4	
	push r5

	loadn r0, #0     ; posição inicial da tela
	loadn r3, #40    ; incremento por linha (40 colunas)
	loadn r4, #41    ; incremento do ponteiro da string (cada linha + \0)
	loadn r5, #1200  ; limite da tela
	
	ImprimeTela_Loop:
		call ImprimeStr  ; imprime uma linha
		add r0, r0, r3   ; pula para a próxima linha da tela (próxima linha de 40 colunas)
		add r1, r1, r4   ; avança o ponteiro da string para a próxima linha
		cmp r0, r5
		jne ImprimeTela_Loop

		pop r5
		pop r4
		pop r3
		pop r2
		pop r1
		pop r0
		rts
				


ImprimeStr:
	push r0
	push r1
	push r2
	push r3
	push r4
	
	loadn r3, #'\0'

	ImprimeStr_Loop:
		loadi r4, r1          ; Carrega no r4 o caractere apontado por r1
		cmp r4, r3            ; Compara o caractere atual com '\0'
		jeq ImprimeStr_Sai    ; Se for igual a '\0', salta para ImprimeStr_Sai, encerrando a impressão.
		
		add r4, r2, r4        ; Soma r2 ao valor do caractere. 
		
		outchar r4, r0         ; Imprime o caractere (r4) na posição de tela (r0).
		inc r0                 ; Incrementa a posição na tela para o próximo caractere.
		inc r1                 ; Incrementa o ponteiro da string para o próximo caractere.
		jmp ImprimeStr_Loop    ; Volta ao início do loop para continuar imprimindo.

   ImprimeStr_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
	

Move_Snake:
	push r0	; Direcao / SnakePos
	push r1	; inchar
	push r2 ; local helper
	push r3
	push r4
	
	; Sincronização
	loadn 	r0, #15000 ; MUDOU A VELOCIDADE NO PC DA PRO ALUNO !!!!!!!!!!!!!!!!!!!!!!!!!!!!
	loadn 	r1, #0
	mod 	r0, r6, r0		; r0 = r6 % 10000 
	cmp 	r0, r1
	jne Move_End ; isso indica que a cada 10000 ciclos o código abaixo será executado
	
	Check_Food:
	; --> R2 = Tela1Linha0 + posAnt + posAnt/40  
	; Precisamos somar posAnt/40 no ponteiro porque cada linha da string do cenário termina com um caractere '\0', 
	; logo o endereço na memória não é linear apenas por posAnt, é preciso ajustar pelo número de quebras de linha.

	loadn r1, #tela0Linha0	; Endereço do início do cenário na memória.
	add r2, r1, r0	        ; R2 = endereço base + posAnt
	loadn r4, #40           ; 40 é a largura da linha do cenário.
	div r3, r0, r4	        ; r3 = posAnt/40 (quantas linhas completas acima)
	; ex: andou 320 caracteres = percorreu 8 linhas
	add r2, r2, r3	        ; R2 = Tela0Linha0 + posAnt + (posAnt/40), ajustando pelo '\0' no final de cada linha.

		loadi R5, R2	        ; Carrega em R5 o caractere da tela na posição calculada (R2).
		load 	r0, FoodPos    ; r0 = posição da comida
		loadn 	r1, #SnakePos  ; r1 = endereço base do array SnakePos
		loadi 	r2, r1         ; r2 = SnakePos[0], posição da cabeça da cobra

		cmp r0, r2 ; verificando se a posição da comida é igual a da snake
		jne Spread_Move	; não comeu a comida
		
		call Increment_Pontuacao ; chamando função que incrementa a pontuação, caso não passe pelo jump no equal
		
		load 	r0, SnakeTam
		inc 	r0
		store 	SnakeTam, r0
		
		loadn 	r0, #0
		dec 	r0
		store 	FoodStatus, r0
		


;A rotina `Check_Food` verifica se a cabeça da cobra está na mesma posição que a comida no jogo Snake. 
;Primeiro, calcula a posição exata da cabeça da cobra no cenário ajustando para considerar 
;que cada linha do cenário termina com um caractere nulo (`'\0'`), somando a posição atual (`posAnt`) 
;com o número de linhas já percorridas (`posAnt/40`), onde 40 é a largura de cada linha. 
;Em seguida, compara essa posição calculada com a posição da comida (`FoodPos`). Se as posições coincidirem, 
;significa que a cobra comeu a comida, então a rotina chama a função `Increment_Pontuacao` para aumentar 
;a pontuação do jogador, incrementa `SnakeTam` para aumentar o tamanho da cobra, e define `FoodStatus` para 
;-1, indicando que a comida foi consumida e precisa ser reposicionada. 
;Se as posições não coincidirem, a rotina continua a execução normal do jogo sem realizar 
;nenhuma ação adicional. Assim, `Check_Food` assegura que o  jogo responda 
;adequadamente quando a cobra consome a comida, atualizando a pontuação, 
;o tamanho da cobra e preparando a próxima comida.

	Spread_Move: ; a lógica é para que o corpo acompanhe o movimento da cobra
		loadn 	r0, #SnakePos
		loadn 	r1, #SnakePos
		load 	r2, SnakeTam
		
		add 	r0, r0, r2		; r0 = SnakePos[Size]
		
		dec 	r2				; r1 = SnakePos[Size-1]
		add 	r1, r1, r2
		
		loadn r4, #0
		
		Spread_Loop:
			loadi r3, r1         ; r3 = SnakePos[Size-1] (posição do segmento anterior)
			storei r0, r3        ; Atualiza SnakePos[Size] com a posição do segmento anterior
			
			dec r0               ; Move r0 para o próximo segmento
			dec r1               ; Move r1 para o próximo segmento anterior
			
			cmp r2, r4           ; Verifica se ainda há segmentos a serem processados
			dec r2
			jne Spread_Loop      ; Continua até que todos os segmentos tenham sido ajustados

			
	Change_Direcao:
		inchar 	r1
		
		loadn r2, #100	; char r4 = 'd'
		cmp r1, r2
		jeq Move_D
		
		loadn r2, #115	; char r4 = 's'
		cmp r1, r2
		jeq Move_S
		
		loadn r2, #97	; char r4 = 'a'
		cmp r1, r2
		jeq Move_A
		
		loadn r2, #119	; char r4 = 'w'
		cmp r1, r2
		jeq Move_W
		
		; o código acima faz a verificação da tecla pressionada no inchar
		
		jmp Update_Move
	
		Move_D:
			loadn 	r0, #0
			; Impede de "ir pra trás" - virar 180 graus
			loadn 	r1, #2
			load  	r2, Direcao
			cmp 	r1, r2 ; faz a verificação se a direção d r1 e r2 são iguais, caso seja ele move pra esquerda 
			jeq 	Move_Left
			
			store 	Direcao, r0
			jmp 	Move_Right ; caso não seja, ele move pra direita
			
		; a lógica continua nas próximas interações
		
		Move_S:
			loadn 	r0, #1
			; Impede de "ir pra trás" - virar 180 graus
			loadn 	r1, #3
			load  	r2, Direcao
			cmp 	r1, r2
			jeq 	Move_Up
			
			store 	Direcao, r0
			jmp 	Move_Down
		Move_A:
			loadn 	r0, #2
			; Impede de "ir pra trás" - virar 180 graus
			loadn 	r1, #0
			load  	r2, Direcao
			cmp 	r1, r2
			jeq 	Move_Right
			
			store 	Direcao, r0
			jmp 	Move_Left
		Move_W:
			loadn 	r0, #3
			; Impede de "ir pra trás" - virar 180 graus
			loadn 	r1, #1
			load  	r2, Direcao
			cmp 	r1, r2
			jeq 	Move_Down
			
			store 	Direcao, r0
			jmp 	Move_Up
	
	Update_Move:
		load 	r0, Direcao
				
		loadn 	r2, #0
		cmp 	r0, r2
		jeq 	Move_Right
		
		loadn 	r2, #1
		cmp 	r0, r2
		jeq 	Move_Down
		
		loadn 	r2, #2
		cmp 	r0, r2
		jeq 	Move_Left
		
		loadn 	r2, #3
		cmp 	r0, r2
		jeq 	Move_Up
		
		jmp Move_End
		
		Move_Right:
			loadn 	r0, #SnakePos	; r0 = & SnakePos
			loadi 	r1, r0			; r1 = SnakePos[0]
			inc 	r1				; r1++
			storei 	r0, r1
			
			jmp Move_End
				
		Move_Down:
			loadn 	r0, #SnakePos	; r0 = & SnakePos
			loadi 	r1, r0			; r1 = SnakePos[0]
			loadn 	r2, #40
			add 	r1, r1, r2
			storei 	r0, r1
			
			jmp Move_End
		
		Move_Left:
			loadn 	r0, #SnakePos	; r0 = & SnakePos
			loadi 	r1, r0			; r1 = SnakePos[0]
			dec 	r1				; r1--
			storei 	r0, r1
			
			jmp Move_End
		Move_Up:
			loadn 	r0, #SnakePos	; r0 = & SnakePos
			loadi 	r1, r0			; r1 = SnakePos[0]
			loadn 	r2, #40
			sub 	r1, r1, r2
			storei 	r0, r1
			
			jmp Move_End
	
	Move_End:
		pop r4
		pop r3
		pop r2
		pop r1
		pop r0

	rts

Torre:
	
	push r1
	push r2
	
	loadn r1, #0
	loadn r2, #1
		
	tiro:		
		
		call MoveTiro
		inc r1
		
		cmp r1, r2
		jne tiro
		
	fim_tiro:
		pop r2
		pop r1
		
	rts


	

MoveTiro: ; a cada interação do tiro ele verifica se a snake for atingida
	call MoveTiro_RecalculaPos
	call Shot_snake
	call MoveTiro_Apaga
	call Shot_snake
	call MoveTiro_Desenha		
	call Shot_snake
	rts

MoveTiro_Apaga: ; move o tiro e apaga o rastro dele
	push R0
	push R1
	push R2
	push R3
	push R4

	load R1, posAtualTiro	
	loadn R2, #40
	sub R1, R1, R2	
	
	load R3, posAtualTiro
	store posAntTiro, R3
	store posAtualTiro, R1 
	
	loadn R4, #' '
	
  MoveTiro_Apaga_Fim:	
	outchar R4, R3	
	
	
	pop R4
	pop R3
	pop R2
	pop R1
	pop R0
	rts
;--------------------------------------------------------------------------------------------------------
	
	
MoveTiro_RecalculaPos:
	push R0
	push R1
	push R2
	
	load R0, posAtualTiro	
	
	loadn R1, #139		
	cmp R0, R1
	jeq MoveTiro_RecalculaPos_Fim
	
	loadn R1, #SnakePos
	loadn R0, #posAtualTiro	
	
	cmp R0, R1	
	jeq MoveTiro_RecalculaPos_Boom
	
	call MoveTiro_Apaga
	
	jmp MoveTiro_RecalculaPos_Fim2
	
  MoveTiro_RecalculaPos_Fim:
  	loadn R1, #'_'
  	loadn R2, #256
  	add R1, R1, R2
  	outchar R1, R0
  	call Inicia_flag_e_tiro
  	call MoveTiro_Apaga
  	
  MoveTiro_RecalculaPos_Fim2:	
	pop R2
	pop R1
	pop R0
	rts
	
  MoveTiro_RecalculaPos_Boom:	
  	
  	pop R2
	pop R1
	pop R0
  	jmp GameOver_Activate
  

  
MoveTiro_Desenha:
	push R0
	push R1
	
	loadn R1, #'|'	; Forma do Tiro
	load R0, posAtualTiro
	outchar R1, R0
	store posAntTiro, R0
	
	pop R1
	pop R0
	rts


Shot_snake:

	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	
	loadn 	r0, #SnakePos
	loadn 	r1, #SnakePos
	load 	r2, SnakeTam
	load 	r5, posAtualTiro
	
	add 	r0, r0, r2		; r0 = SnakePos[Size]

	loadn 	r4, #0
	
	Shot_Loop:
		loadi 	r3, r0
				
		dec r0
		
		cmp r3, r5
		jeq GameOver_Activate
		
		cmp r2, r4
		dec r2
		
		jne Shot_Loop	

	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0

	rts

	

Increment_Pontuacao:
	push r0
	push r1
	push r2
	
	loadn r1, #1 ; colocando numero 1 no registrador r1 para somar com a pontuação atual
	
	load r0 , Pontuacao ; carregando pontuação atual em r0 
	add r0, r0 , r1

	store Pontuacao, r0
	
	loadn r2, #9
	
	outchar r0, r2
	
	loadn r3, #49
	cmp r0, r3	;checa se o Pontuacao chegou a 7 (55 em ASCII)
	jeq NextLevel
	
	
	pop r2	
	pop r1	
	pop r0	
	 
	rts

Replace_Food:
	push r0
	push r1

	loadn 	r0, #0
	dec 	r0
	load 	r1, FoodStatus
	cmp 	r0, r1
	
	jne Replace_End
	
	loadn r1, #0
	store FoodStatus, r1
	load  r1, FoodPos
	
	load r0, Direcao
	
	loadn r2, #0
	cmp r0, r2
	jeq Replace_Right
	
	loadn r2, #1
	cmp r0, r2
	jeq Replace_Down
	
	loadn r2, #2
	cmp r0, r2
	jeq Replace_Left
	
	loadn r2, #3
	cmp r0, r2
	jeq Replace_Up
	
	Replace_Right:
		loadn r3, #355
		add r1, r1, r3
		jmp Replace_Boundaries
	Replace_Down:
		loadn r3, #445
		sub r1, r1, r3
		jmp Replace_Boundaries
	Replace_Left:
		loadn r3, #395
		sub r1, r1, r3
		jmp Replace_Boundaries
	Replace_Up:
		loadn r3, #485
		add r1, r1, r3
		jmp Replace_Boundaries
	
	;caso a comida seja inicialmente calculada para aparecer em uma posicao ja ocupada por uma barreira,
	;a posicao sera recalculada para outra posicao, definida por:
	;Replace_Upper, Replace_Lower, Replace_East ou Replace_West
	;A escolha do Replace sera "aleatoria"
	Replace_Boundaries:
		loadn r2, #160
		cmp r1, r2
		jle Replace_Lower
		
		loadn r2, #1160
		cmp r1, r2
		jgr Replace_Upper
		
		loadn r0, #40
		loadn r3, #1
		mod r2, r1, r0
		cmp r2, r3
		jel Replace_West
		
		loadn r0, #40
		loadn r3, #39
		mod r2, r1, r0
		cmp r2, r3
		jeg Replace_East
		
		loadn r2, #391
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #407
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #408
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #409
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #410
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #411
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #412
		cmp r1, r2
		jeq Replace_Upper

		loadn r2, #432
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #447
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #448
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #449
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #450
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #451
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #452
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #472
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #487
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #488
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #489
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #490
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #491
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #492
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #891
		cmp r1, r2
		jeq Replace_Upper

		loadn r2, #942
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #902
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #903
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #904
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #905
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #906
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #907
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #931
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #942
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #943
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #944
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #945
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #946
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #947
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #971
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #972
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #982
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #983
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #984
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #985
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #986
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #987
		cmp r1, r2
		jeq Replace_Upper

		loadn r2, #1059
		cmp r1, r2
		jeq Replace_East

		loadn r2, #1098
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #1099
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #1100
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #1137
		cmp r1, r2
		jeq Replace_East
		
		loadn r2, #1138
		cmp r1, r2
		jeq Replace_Upper
		
		loadn r2, #1139
		cmp r1, r2
		jeq Replace_West
		
		loadn r2, #1140
		cmp r1, r2
		jeq Replace_Lower
		
		loadn r2, #1141
		cmp r1, r2
		jeq Replace_Upper
				
		jmp Replace_Update
		
		Replace_Upper:
			loadn r1, #215
			jmp Replace_Update
		Replace_Lower:
			loadn r1, #1035
			jmp Replace_Update
		Replace_East:
			loadn r1, #835
			jmp Replace_Update
		Replace_West:
			loadn r1, #205
			jmp Replace_Update
			
		Replace_Update:
			store FoodPos, r1
			loadn r0, #'.'
			outchar r0, r1
	
	Replace_End:
		pop r1
		pop r0
	
	rts

Morte_Snake_1: ; função para a fase 1
	loadn r0, #SnakePos
	loadi r1, r0
	
	; colidiu na parede Direita
	loadn r2, #40
	loadn r3, #39
	mod r2, r1, r2		; r2 = r1 % r2 (Teste condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; colidiu na parede esquerda
	loadn r2, #40
	loadn r3, #0
	mod r2, r1, r2		; r2 = r1 % r2 (Teste condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; colidiu na parede de cima
	loadn r2, #160
	cmp r1, r2
	jle GameOver_Activate
	
	; colidiu na parede de baixo
	loadn r2, #1160
	cmp r1, r2
	jgr GameOver_Activate
	
	call wall_1_check
	call wall_2_check
	
	; colidiu na própria cobra
	Collision_Check:
		load 	r2, SnakeTam
		loadn 	r3, #1
		loadi 	r4, r0			
		
		Collision_Loop:
			inc 	r0
			loadi 	r1, r0
			cmp r1, r4
			jeq GameOver_Activate
			
			dec r2
			cmp r2, r3
			jne Collision_Loop
		
	
	jmp Morte_Snake_1_End
	
	GameOver_Activate:
		load 	r0, FoodPos
		loadn 	r1, #' '
		outchar r1, r0
			
		jmp GameOver_loop
	
	Morte_Snake_1_End:
	
	rts

Morte_Snake_2: ; função para a fase 2
	loadn r0, #SnakePos
	loadi r1, r0
	
	; colidiu na parede Direita
	loadn r2, #40
	loadn r3, #39
	mod r2, r1, r2		; r2 = r1 % r2 (Teste condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; colidiu na parede esquerda
	loadn r2, #40
	loadn r3, #0
	mod r2, r1, r2		; r2 = r1 % r2 (Teste condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; colidiu na parede de cima
	loadn r2, #160
	cmp r1, r2
	jle GameOver_Activate
	
	; colidiu na parede de baixo
	loadn r2, #1160
	cmp r1, r2
	jgr GameOver_Activate
	
	call box_1_check
	call box_2_check
	call wall_1_check
	
	
	; colidiu na própria cobra
	Collision_Check:
		load 	r2, SnakeTam
		loadn 	r3, #1
		loadi 	r4, r0			; Posição da cabeça
		
		Collision_Loop:
			inc 	r0
			loadi 	r1, r0
			cmp r1, r4
			jeq GameOver_Activate
			
			dec r2
			cmp r2, r3
			jne Collision_Loop
		
	
	jmp Morte_Snake_2_End
	
	GameOver_Activate:
		load 	r0, FoodPos
		loadn 	r1, #' '
		outchar r1, r0
	
		loadn r0, #615
		loadn r1, #GameOverMessage
		loadn r2, #0
		call Imprime
		
		loadn r0, #687
		loadn r1, #RestartMessage
		loadn r2, #0
		call Imprime
		
		jmp GameOver_loop
	
	Morte_Snake_2_End:
	
	rts

Morte_Snake_3: ; função para a fase 3
	loadn r0, #SnakePos
	loadi r1, r0
	
	; colidiu na parede Direita
	loadn r2, #40
	loadn r3, #39
	mod r2, r1, r2		; r2 = r1 % r2 (Testa condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; colidiu na parede esquerda
	loadn r2, #40
	loadn r3, #0
	mod r2, r1, r2		; r2 = r1 % r2 (Testa condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; colidiu na parede de cima
	loadn r2, #160
	cmp r1, r2
	jle GameOver_Activate
	
	; colidiu na parede de baixo
	loadn r2, #1160
	cmp r1, r2
	jgr GameOver_Activate
	
	call turret_check ;verifica se a snake colidiu com a torreta que atira
	call wall_1_check
	call wall_2_check
	
	; colidiu na própria cobra
	Collision_Check:
		load 	r2, SnakeTam
		loadn 	r3, #1
		loadi 	r4, r0			; Posição da cabeça
		
		Collision_Loop:
			inc 	r0
			loadi 	r1, r0
			cmp r1, r4
			jeq GameOver_Activate
			
			dec r2
			cmp r2, r3
			jne Collision_Loop
		
	
	jmp Morte_Snake_3_End
	
	
	
	
	
	GameOver_Activate:
		load 	r0, FoodPos
		loadn 	r1, #' '
		outchar r1, r0

		
		jmp GameOver_loop
	
	Morte_Snake_3_End:
	
	rts


box_1_check: ; checa se a snake colidiu com uma das caixas do cenario 1. 
	
	loadn r2, #407
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #408
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #409
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #410
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #411
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #412
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #447
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #452
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #487
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #488
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #489
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #490
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #491
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #492
	cmp r1, r2
	jeq GameOver_Activate
	
	
	rts

box_2_check:
	
	loadn r2, #902
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #903
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #904
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #905
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #906
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #907
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #942
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #947
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #982
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #983
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #984
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #985
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #986
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #987
	cmp r1, r2
	jeq GameOver_Activate
	
	
	rts
	
wall_1_check:

	
	loadn r2, #391
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #432
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #472
	cmp r1, r2
	jeq GameOver_Activate
	
	
	
	rts
	
wall_2_check:

	
	loadn r2, #891
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #931
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #971
	cmp r1, r2
	jeq GameOver_Activate
	
	loadn r2, #972
	cmp r1, r2
	jeq GameOver_Activate
	
	
	
	rts

turret_check:
	
	loadn r2, #1059
	cmp r1, r2
	jeq GameOver_Activate
	
	
	loadn r2, #1098
	cmp r1, r2
	jeq GameOver_Activate
	
	
	loadn r2, #1099
	cmp r1, r2
	jeq GameOver_Activate
	
	
	loadn r2, #1100
	cmp r1, r2
	jeq GameOver_Activate
	
	
	
	loadn r2, #1137
	cmp r1, r2
	jeq GameOver_Activate
	
	
	loadn r2, #1138
	cmp r1, r2
	jeq GameOver_Activate
	
	
	loadn r2, #1139
	cmp r1, r2
	jeq GameOver_Activate
	
	
	loadn r2, #1140
	cmp r1, r2
	jeq GameOver_Activate
	
	
	loadn r2, #1141
	cmp r1, r2
	jeq GameOver_Activate
	
	
	
	rts




Draw_Snake:
	push r0
	push r1
	push r2
	push r3 
	push r4
	push r5
	push r6
	
	; --> R2 = Tela1Linha0 + posAnt + posAnt/40  ; tem que somar posAnt/40 no ponteiro pois as linas da string terminam com /0 !!
	loadn R1, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	add R2, R1, r0	; R2 = Tela1Linha0 + posAnt
	loadn R4, #40
	div R3, R0, R4	; R3 = posAnt/40
	add R2, R2, R3	; R2 = Tela1Linha0 + posAnt + posAnt/40
	
	loadi R5, R2	; R5 = Char (Tela(posAnt))
  

	
	; Sincronização
	loadn 	r0, #1000
	loadn 	r1, #0
	mod 	r0, r6, r0		; r1 = r0 % r1 (Testa condições de contorno)
	cmp 	r0, r1
	jne Draw_End
	
	load 	r0, FoodPos
	loadn 	r1, #'$'
	outchar r1, r0
	
	loadn 	r0, #SnakePos	; r0 = & SnakePos
	loadn 	r1, #'%'		; r1 = '}'
	loadi 	r2, r0			; r2 = SnakePos[0]
	outchar r1, r2			
	
	loadn 	r0, #SnakePos	; r0 = & SnakePos
	
	
	
	;loadn 	r1, #' '		; r1 = ' '
	load 	r3, SnakeTam	; r3 = SnakeTam
	add 	r0, r0, r3		; r0 += SnakeTam
	loadi 	r2, r0			; r2 = SnakePos[SnakeTam]
	load r0, Fase			; r0 = fase atual
	loadn r6, #48			; r6 = 48 (relativo a fase 1)
	cmp r6, r0				; Se a fase atual for a primeira
	ceq Set_cenario1		; Chama uma função que coloca a posição inicial do cenario 1 em r1
	loadn r6, #49			; r6 = 49 (relativo a fase 2)
	cmp r6, r0				; Se a fase atual for a segunda
	ceq Set_cenario2		; Chama uma função que coloca a posição inicial do cenario 2 em r1
	loadn r6, #50			; r6 = 50 (relativo a fase 3)
	cmp r6, r0				; Se a fase atual for a terceira
	ceq Set_cenario3		; Chama uma função que coloca a posição inicial do cenario 3 em r1
	loadn r4, #40			; r4 = 40
	div r3, r2, r4 			; r3 = SnakePos[SnakeTam]/40
	add r1, r1, r2			; r1 = PosInicialCenarioAtual + SnakePos[SnakeTam] + SnakePos[SnakeTam]/40
	add r1, r3, r1
	loadi r5, r1			; r5 é o caracter relativo a posição no cenario a ser printada
	outchar r5, r2			; printa o caracter de r5 na posição final da cobra
	
	Draw_End:
		pop r6
		pop r5
		pop r4
		pop	r3
		pop r2
		pop r1
		pop r0
	
	rts
	
	
Set_cenario1:				; Função que coloca a posição inicial do cenario 1 em r1
	loadn r1, #tela1Linha0
	rts
	
Set_cenario2:				; Função que coloca a posição inicial do cenario 2 em r1
	loadn r1, #tela2Linha0
	rts
	
Set_cenario3:				; Função que coloca a posição inicial do cenario 3 em r1
	loadn r1, #tela3Linha0
	rts
;--------------------------------------------------------------------------------------------------------
Delay:
	push r0
	
	inc r6
	load r0, Velocidade
	cmp r6, r0
	jgr Reset_Timer
	
	jmp Timer_End
	
	Reset_Timer:
		loadn r6, #0
	Timer_End:		
		pop r0
	
	rts
	
Delay2: ; Delay para desenhar o cenário sem bugar
	push r0
	
	inc r6
	loadn r0, #1
	cmp r6, r0
	jgr Reset_Timer
	
	jmp Timer_End
	
	Reset_Timer:
		loadn r6, #0
	Timer_End:		
		pop r0
	
	rts

Shot_Delay: 
	push r0
	push r1
	
	loadn r1, #5  ; a
   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	loadn r0, #4000	; b
   Delay_volta: 
	dec r0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	jnz Delay_volta	
	dec r1
	jnz Delay_volta2
	
	pop r1
	pop r0
	
	rts


NextLevel:
	
	push r0
	push r1
	push r2
	push r3
	
	
	loadn r0, #615
	loadn r1, #SuccessMessage
	loadn r2, #0
	call Imprime
		
	loadn r0, #687
	loadn r1, #NextLevelMessage
	loadn r2, #0
	call Imprime
	
	in_loop:
		inchar 	r3
		loadn 	r4, #' '
		
		cmp r3, r4
		jeq Next_level_activate
		
	jmp in_loop

	Next_level_activate:
		loadn r0, #615
		loadn r1, #EraseSuccessMessage
		loadn r2, #0
		call Imprime
		
		loadn r0, #687
		loadn r1, #EraseNextLevelMessage
		loadn r2, #0
		call Imprime
	
	load r0, Fase 
	loadn r1, #50
	
	cmp r0, r1 ; checa se concluiu o ultimo nivel. Em caso positivo, o jogo dá game over e recomeça
	jeq GameOver_Ganhar
	
	call Draw_new_Fase	
	call EraseSnake
	call Inicia
	call Inicia_Pontuacao	
	call increase_Velocidade
	
	pop r3
	pop r2
	pop r1
	pop r0
	
	jmp ingame_loop
		
increase_Velocidade:
	push r0
	push r1
	
	loadn r0, #300 
	load r1, Velocidade
	sub r1, r1, r0 ; reduzirá em 300 unidades o valor de Velocidade. Na função delay isso fará com que a snake se movimente mais rapido
	store Velocidade, r1 
	
	pop r1
	pop r0
	
	rts
	
Draw_new_Fase:
	push r0
	push r1
	push r2
	
	load r3, Fase ; salva o valor ASCII da fase atual (0 == 48, 1 == 49 , 2 == 50)
	inc r3
	store Fase, r3
		
	loadn r4, #49 
	loadn r5, #50
	
	cmp r3, r4
	jeq Desenha_Fase2
	
	jmp Desenha_Fase3
	
	Desenha_Fase2:
		loadn R1, #tela2Linha0	; Endereco de inicio da primeira linha do cenario!!
		loadn R2, #1024
		call Desenha_Fase
		
		outchar r3, r4 ; imprime o 1 em ascII  na posição 49 da tela
				
		jmp fim_Desenha_Fase
		
	;Desenhar a fase 3 
	Desenha_Fase3:
		loadn R1, #tela3Linha0	; Endereco de inicio da primeira linha do cenario!!
		loadn R2, #256
		call increase_Velocidade
		call Desenha_Fase
		
		outchar r3, r4 
		

	fim_Desenha_Fase:

	pop r2
	pop r1
	pop r0
	
	
	rts
	

Restart_Game:
	inchar 	r0
	loadn 	r1, #' '
	
	cmp r0, r1
	jeq Restart_Activate
	
	jmp Restart_End
	
	Restart_Activate:
		loadn r0, #615
		loadn r1, #EraseGameOver
		loadn r2, #0
		call Imprime
		
		loadn r0, #687
		loadn r1, #EraseRestart
		loadn r2, #0
		call Imprime
		
		call EraseSnake		
		
		jmp main
		
		
	Restart_End:
	
	rts


Imprime:
	push r0		; Posição na tela para imprimir a string
	push r1		; Endereço da string a ser impressa
	push r2		; Cor da mensagem
	push r3
	push r4

	
	loadn r3, #'\0'

	LoopImprime:	
		loadi r4, r1
		cmp r4, r3
		jeq SaiImprime
		add r4, r2, r4
		outchar r4, r0
		inc r0
		inc r1
		jmp LoopImprime
		
	SaiImprime:	
		pop r4	
		pop r3
		pop r2
		pop r1
		pop r0
		
	rts
	
tela_final_perdeu:
	loadn R1, #perdeuLinha0	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn R2, #2304
	call Desenha_Fase
	rts

tela_final_ganhou:
	loadn R1, #ganhouLinha0	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn R2, #2816
	call Desenha_Fase
	rts



tela0Linha0  : string "                                        "
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "                                        "
tela0Linha4  : string "                                        "
tela0Linha5  : string "                                        "
tela0Linha6  : string "                                        "
tela0Linha7  : string "                                        "
tela0Linha8  : string "                                        "
tela0Linha9  : string "                                        "
tela0Linha10 : string "                                        "
tela0Linha11 : string "                                        "
tela0Linha12 : string "                                        "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                                        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "	
	

tela1Linha0  : string "PONTOS ==                               "
tela1Linha1  : string "LEVEL ==                                "
tela1Linha2  : string "            JARDIM SECRETO              "
tela1Linha3  : string "}-}-}-}-}-}-}-}-}-}-}-}-}-}-}-}-}-}-}-}-"
tela1Linha4  : string "-                                      -"
tela1Linha5  : string "}      @@@                             }"
tela1Linha6  : string "-     @@@@@            @@@             -"
tela1Linha7  : string "}      @@@            @@@@@            }"
tela1Linha8  : string "-       |              @@@             -"
tela1Linha9  : string "}       |               |      _       }"
tela1Linha10 : string "-                       |       |      -"
tela1Linha11 : string "}                               |      }"
tela1Linha12 : string "-                                      -"
tela1Linha13 : string "}                                      }"
tela1Linha14 : string "-                                      -"
tela1Linha15 : string "}                                      }"
tela1Linha16 : string "-                                      -"
tela1Linha17 : string "}                                      }"
tela1Linha18 : string "-                                      -"
tela1Linha19 : string "}   @@@                                }"
tela1Linha20 : string "-  @@@@@                               -"
tela1Linha21 : string "}   @@@                                }"
tela1Linha22 : string "-    |     |                           -"
tela1Linha23 : string "}    |     |                           }"
tela1Linha24 : string "-          |_                    @@@   -"
tela1Linha25 : string "}                               @@@@@  }"
tela1Linha26 : string "-                                @@@   -"
tela1Linha27 : string "}                                 |    }"
tela1Linha28 : string "-                                 |    -"
tela1Linha29 : string "}-}-}-}-}-}-}-}-}-}-}-}-}-}-}-}-}-}-}-}-"		




tela2Linha0  : string "PONTOS ==                               "
tela2Linha1  : string "LEVEL ==                                "
tela2Linha2  : string "                CANTINA                 "
tela2Linha3  : string " ______________________________________ "
tela2Linha4  : string "|                                      |"
tela2Linha5  : string "|                                      |"
tela2Linha6  : string "|                                      |"
tela2Linha7  : string "|         *                   *~~      |"
tela2Linha8  : string "|                                      |"
tela2Linha9  : string "|                              _       |"
tela2Linha10 : string "|      ______                   |      |"
tela2Linha11 : string "|      |   ~|                   |      |"
tela2Linha12 : string "|      |____|                          |"
tela2Linha13 : string "|                                      |"
tela2Linha14 : string "|                                      |"
tela2Linha15 : string "|                                      |"
tela2Linha16 : string "|                                      |"
tela2Linha17 : string "|        *                             |"
tela2Linha18 : string "|                                      |"
tela2Linha19 : string "|                                      |"
tela2Linha20 : string "|                                      |"
tela2Linha21 : string "|                                      |"
tela2Linha22 : string "|    *                 ______          |"
tela2Linha23 : string "|                     | ^* |           |"
tela2Linha24 : string "|                     |____|           |"
tela2Linha25 : string "|                                      |"
tela2Linha26 : string "|               *~                     |"
tela2Linha27 : string "|                                      |"
tela2Linha28 : string "|                                      |"
tela2Linha29 : string "|______________________________________|"
	

tela3Linha0  : string "PONTOS ==                               "
tela3Linha1  : string "LEVEL ==                                "
tela3Linha2  : string "                                        "
tela3Linha3  : string " ______________________________________ "
tela3Linha4  : string "|                                      |"
tela3Linha5  : string "|                                      |"
tela3Linha6  : string "|                                      |"
tela3Linha7  : string "|                                      |"
tela3Linha8  : string "|                                      |"
tela3Linha9  : string "|                              _       |"
tela3Linha10 : string "|                               |      |"
tela3Linha11 : string "|                               |      |"
tela3Linha12 : string "|                                      |"
tela3Linha13 : string "|                                      |"
tela3Linha14 : string "|                                      |"
tela3Linha15 : string "|                                      |"
tela3Linha16 : string "|                                      |"
tela3Linha17 : string "|                                      |"
tela3Linha18 : string "|                                      |"
tela3Linha19 : string "|                                      |"
tela3Linha20 : string "|                                      |"
tela3Linha21 : string "|                                      |"
tela3Linha22 : string "|          |                           |"
tela3Linha23 : string "|          |                           |"
tela3Linha24 : string "|          |_                          |"
tela3Linha25 : string "|                                      |"
tela3Linha26 : string "|                 xw                   |"
tela3Linha27 : string "|                 vu                   |"
tela3Linha28 : string "|                 {{                   |"
tela3Linha29 : string "|______________________________________|"


perdeuLinha0  : string "                                        "
perdeuLinha1  : string "                                        "
perdeuLinha2  : string "  __      ______   _____  //z           "
perdeuLinha3  : string "  z z    / / __ z / ____||/ z |         "
perdeuLinha4  : string "   z z  / / |  | | |    | ____|         "
perdeuLinha5  : string "    z z/ /| |  | | |    |  _|           "
perdeuLinha6  : string "     z  / | |__| | |____| |___          "
perdeuLinha7  : string "      z/   z____/ z_____|_____|         "
perdeuLinha8  : string "                                        "
perdeuLinha9  : string "                                        "
perdeuLinha10 : string " _____  ____ _____  _____  _____ _    _ "
perdeuLinha11 : string "|  __ z|  __|  __ z|  __ z|  ___| |  | |"
perdeuLinha12 : string "| |__) | |_ | |__) | |  | | |_  | |  | |"
perdeuLinha13 : string "|  ___/|  _||  _  /| |  | |  _| | |  | |"
perdeuLinha14 : string "| |    | |__| | z z| |__| | |___| |__| |"
perdeuLinha15 : string "|_|    |____|_|  z_|_____/|_____|z____/ "
perdeuLinha16 : string "                                        "
perdeuLinha17 : string "                                        "
perdeuLinha18 : string "                                        "
perdeuLinha19 : string "                                        "
perdeuLinha20 : string "  APERTE SPACE PARA JOGAR NOVAMENTE     "
perdeuLinha21 : string "                                        "
perdeuLinha22 : string "                                        "
perdeuLinha23 : string "                                        "
perdeuLinha24 : string "                                        "
perdeuLinha25 : string "                                        "
perdeuLinha26 : string "                                        "
perdeuLinha27 : string "                                        "
perdeuLinha28 : string "                                        "
perdeuLinha29 : string "                                        "	

ganhouLinha0  : string "      __     _____   ____  //z          "
ganhouLinha1  : string "      z z   / / _ z / ___||/_z|         "
ganhouLinha2  : string "       z z / / | | | |   | ____|        "
ganhouLinha3  : string "        z V /| |_| | |___|  _|_         "
ganhouLinha4  : string "         z_/  z___/ z____|_____|        "
ganhouLinha5  : string "                                        "
ganhouLinha6  : string "  ____    _    _   _ _   _  ___  _   _  "
ganhouLinha7  : string " / ___|  / z  | z | | | | |z _ z| | | | "
ganhouLinha8  : string "| |  _  / _ z |  z| | |_| | | | | | | | "
ganhouLinha9  : string "| |_| |/ ___ z| |z  |  _  | |_| | |_| | "
ganhouLinha10 : string " z____/_/   z_z_| z_|_| |_|z___/ z___/  "
ganhouLinha11 : string "                                        "
ganhouLinha12 : string "                                        "
ganhouLinha13 : string "                                        "
ganhouLinha14 : string "                                        "
ganhouLinha15 : string "                                        "
ganhouLinha16 : string "                                        "
ganhouLinha17 : string "                                        "
ganhouLinha18 : string "                                        "
ganhouLinha19 : string "                                        "
ganhouLinha20 : string "                                        "
ganhouLinha21 : string "                                        "
ganhouLinha22 : string "    APERTE SPACE PARA CONTINUAR         "
ganhouLinha23 : string "                                        "
ganhouLinha24 : string "                                        "
ganhouLinha25 : string "                                        "
ganhouLinha26 : string "                                        "
ganhouLinha27 : string "                                        "
ganhouLinha28 : string "                                        "
ganhouLinha29 : string "                                        "


	

	
