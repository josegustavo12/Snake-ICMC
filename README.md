# Documentação Detalhada do Código do Jogo Snake em Assembly

## Índice

1. [Introdução](#introdução)
2. [Declarações de Variáveis e Strings](#declarações-de-variáveis-e-strings)
    - [Variáveis](#variáveis)
    - [Strings](#strings)
3. [Estrutura do Programa](#estrutura-do-programa)
    - [Configuração da Tela Inicial](#configuração-da-tela-inicial)
    - [Função Principal (`main`)](#função-principal-main)
    - [Loops do Jogo](#loops-do-jogo)
4. [Sub-rotinas e Funções](#sub-rotinas-e-funções)
    - [Fase_colisoes](#fase_colisoes)
    - [Inicia_Pontuacao](#inicia_pontuacao)
    - [Inicia_Fase_numero](#inicia_fase_numero)
    - [Inicia_Velocidade](#inicia_velocidade)
    - [Inicia_flag_e_tiro](#inicia_flag_e_tiro)
    - [Inicia](#inicia)
    - [FirstPrintSnake](#firstprintsnake)
    - [EraseSnake](#erasesnake)
    - [Desenha_Fase](#desenha_fase)
    - [ImprimeStr](#imprimestr)
    - [Move_Snake](#move_snake)
    - [Torre](#torre)
    - [MoveTiro e Sub-rotinas Relacionadas](#movetiro-e-sub-rotinas-relacionadas)
    - [Shot_snake](#shot_snake)
    - [Increment_Pontuacao](#increment_pontuacao)
    - [Replace_Food](#replace_food)
    - [Morte_Snake_1, Morte_Snake_2, Morte_Snake_3](#morte_snake_1-morte_snake_2-morte_snake_3)
    - [Verificações de Colisão](#verificações-de-colisão)
    - [Delay e Shot_Delay](#delay-e-shot_delay)
    - [NextLevel](#nextlevel)
    - [Restart_Game](#restart_game)
    - [Imprime](#imprime)
    - [Telas Finais](#telas-finais)
5. [Definições de Strings](#definições-de-strings)
    - [Telas Iniciais](#telas-iniciais)
    - [Mensagens de Game Over e Sucesso](#mensagens-de-game-over-e-sucesso)
6. [Fluxo de Execução Detalhado](#fluxo-de-execução-detalhado)
7. [Considerações Finais](#considerações-finais)

---

## Introdução

Este documento fornece uma explicação abrangente de um código em linguagem assembly-like projetado para implementar o clássico jogo Snake. O código gerencia diversos elementos do jogo, como a posição da cobra, direção, posicionamento da comida, pontuação, níveis e detecção de colisões. Além disso, trata das entradas do usuário para controlar a cobra e exibe diferentes estados do jogo, como a tela de início, game over e mensagens de sucesso.

## Declarações de Variáveis e Strings

### Variáveis

O código começa declarando várias variáveis que armazenam o estado do jogo e suas configurações:

```assembly
SnakePos:        var #500 ; Tamanho máximo da cobra - Array para posições da cobra
SnakeTam:        var #1   ; Tamanho atual da cobra
Direcao:         var #1   ; Direção da cobra (0-Direita, 1-Baixo, 2-Esquerda, 3-Cima)

FoodPos:         var #1    ; Posição da comida
FoodStatus:      var #1    ; Status da comida (se precisa ser recolocada ou não)
Pontuacao:       var #1    ; Pontuação do jogador
Fase:            var #1    ; Nível/fase atual do jogo
Velocidade:      var #1    ; Velocidade de jogo (usada no delay)
FlagTiro:        var #1    ; Flag indicando se tiro está ativo
posAtualTiro:    var #1    ; Posição atual do tiro
posAntTiro:      var #1    ; Posição anterior do tiro
```

- **SnakePos**: Um array que pode armazenar até 500 posições representando os segmentos da cobra na tela.
- **SnakeTam**: Um inteiro que indica o número atual de segmentos que a cobra possui.
- **Direcao**: Um inteiro que representa a direção atual da cobra:
  - `0`: Direita
  - `1`: Baixo
  - `2`: Esquerda
  - `3`: Cima

- **FoodPos**: Um inteiro que representa a posição atual da comida na tela.
- **FoodStatus**: Um inteiro que indica o estado da comida, determinando se ela precisa ser reposicionada.
- **Pontuacao**: Um inteiro que armazena a pontuação do jogador.
- **Fase**: Um inteiro que representa o nível ou fase atual do jogo.
- **Velocidade**: Um inteiro que define a velocidade do jogo, utilizada nas rotinas de delay.
- **FlagTiro**: Um inteiro que indica se um tiro está ativo.
- **posAtualTiro**: Um inteiro que representa a posição atual do tiro na tela.
- **posAntTiro**: Um inteiro que representa a posição anterior do tiro, ajudando a criar a ilusão de movimento.

### Strings

As strings são utilizadas para exibir mensagens e desenhar as telas do jogo. Elas são definidas da seguinte forma:

```assembly
SuccessMessage:       string " DIVOOOOOOOUUUUU!!! "
EraseSuccessMessage:  string "                 "
NextLevelMessage:     string " APERTE 'SPACE' E CONTINUE "
EraseNextLevelMessage:string "                               "

inicialLinha0  : string "                                        "
inicialLinha1  : string "                                        "
inicialLinha2  : string "       _____             _              "
...
ganhouLinha29 : string "                                        "
```

- **Mensagens de Game Over e Sucesso**: Strings como `GameOverMessage`, `RestartMessage`, `SuccessMessage`, e `NextLevelMessage` são usadas para informar o jogador sobre o estado do jogo.
- **Mensagens de Erase**: Strings como `EraseGameOver`, `EraseRestart`, etc., são utilizadas para apagar as mensagens anteriores da tela.
- **Telas de Início e Fases**: `inicialLinha0` a `inicialLinha29`, `tela1Linha0` a `tela1Linha29`, etc., armazenam os desenhos das diferentes fases e telas do jogo.

## Estrutura do Programa

### Configuração da Tela Inicial

```assembly
tela_de_inicio_original:

    loadn R1, #inicialLinha0 ; Carrega R1 com o endereço do vetor que contém a mensagem
    loadn R2, #512
    call Desenha_Fase

tela_de_inicio_botao:
    inchar   r3
    loadn    r4, #' '  
    cmp r3, r4

    jne tela_de_inicio_botao
```

- **tela_de_inicio_original**: Carrega o endereço da primeira linha da tela inicial e chama a sub-rotina `Desenha_Fase` para desenhar a tela.
- **tela_de_inicio_botao**: Aguarda a pressão da tecla espaço (`' '`) para iniciar o jogo.

### Função Principal (`main`)

```assembly
main:

    ; Inicializando o jogo, chamando as sub-rotinas e carregando a tela inicial
    call Inicia_Velocidade ; velocidade = 600
    call Inicia_flag_e_tiro ; estado do tiro = 0 ou 1; posição do tiro (atual e anterior)
    call Inicia

    ; Sub-rotina completa para desenhar uma fase
    loadn R1, #tela1Linha0    ; Endereço da primeira linha do ambiente do jogo
    loadn R2, #0
    call Desenha_Fase

    call Inicia_Pontuacao    ; Inicia o placar
    call Inicia_Fase_numero  ; Inicia o número da fase

    loop:
        
        ingame_loop:
            call Draw_Snake
            
            call Fase_colisoes ; Verifica colisões 
            
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
```

- **Inicialização**:
  - **Inicia_Velocidade**: Define a velocidade inicial do jogo.
  - **Inicia_flag_e_tiro**: Inicializa as flags relacionadas ao tiro.
  - **Inicia**: Inicializa o tamanho da cobra, posições iniciais e direção.
- **Desenha_Fase**: Desenha a primeira fase do jogo.
- **Inicia_Pontuacao e Inicia_Fase_numero**: Inicializa a pontuação e o número da fase.
- **Loop Principal**:
  - **ingame_loop**: Enquanto o jogo está ativo, desenha a cobra, verifica colisões, move a cobra, substitui a comida e aplica um delay para controlar a velocidade.
  - **GameOver_loop**: Caso o jogador perca, exibe a tela de game over e aguarda o reinício.
  - **GameOver_Ganhar**: Caso o jogador complete todas as fases, exibe a tela de sucesso e aguarda o reinício.

## Sub-rotinas e Funções

### Fase_colisoes

```assembly
Fase_colisoes:

    load r3, Fase
    loadn r4, #48 ; r4 = 0

    cmp r3, r4 ; se r3 == 0 ou fase_atual == Fase1 => jump Fase1
    jeq Fase1
    
    inc r4 ; se não for 0, incrementa 1, ou seja, r4 = 1
    
    cmp r3, r4 ; mesmo processo da Fase1
    jeq Fase2
    
    inc r4 ; r4 = 2
    
    cmp r3, r6 ; MUDANÇA DO GPT AQUIIIIIIIIIIIIIIIIIIII r3, r6
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
    ;jmp fim ; MUDANÇA DO GPT AQUIIIIIIIIIIIIIIIIIIII

;Fase4:
;call Morte_Snake_4
;jmp fim
    
fim:
    rts
```

- **Objetivo**: Verifica qual fase do jogo está ativa e chama a sub-rotina correspondente para verificar colisões específicas dessa fase.
- **Processo**:
  1. Compara o valor da variável `Fase` com diferentes valores para determinar a fase atual.
  2. Dependendo da fase, chama a sub-rotina apropriada (`Morte_Snake_1`, `Morte_Snake_2`, `Morte_Snake_3`).
  3. Em certas fases, também chama a sub-rotina `Torre` para verificar colisões com torres.

### Inicia_Pontuacao

```assembly
Inicia_Pontuacao:
    
    loadn r0, #48 ; inicializa a pontuação com zero
    store Pontuacao, r0 ; carrega a pontuação em Pontuacao
    
    loadn r1, #9 ; posição da pontuação na tela
    load r2, Pontuacao  
    
    outchar r2, r1 ; MUDAR A COOOOOOOOOOR
     
    rts
```

- **Objetivo**: Inicializa a pontuação do jogador.
- **Processo**:
  1. Carrega o valor `48` (representando zero) em `r0`.
  2. Armazena esse valor na variável `Pontuacao`.
  3. Carrega a posição da pontuação na tela em `r1`.
  4. Exibe o caractere correspondente à pontuação na posição especificada.

### Inicia_Fase_numero

```assembly
Inicia_Fase_numero:
    
    loadn r0, #48 
    store Fase, r0 ; carrega no endereço Fase com zero
    
    loadn r1, #49
    load r2, Fase
    
    outchar r2, r1
     
    rts
```

- **Objetivo**: Inicializa o número da fase atual do jogo.
- **Processo**:
  1. Carrega o valor `48` (representando zero) em `r0`.
  2. Armazena esse valor na variável `Fase`.
  3. Carrega a posição onde o número da fase será exibido na tela.
  4. Exibe o caractere correspondente ao número da fase na posição especificada.

### Inicia_Velocidade

```assembly
Inicia_Velocidade:
    
    loadn r0, #6000 
    store Velocidade, r0 ; carrega Velocidade com 6000
         
    rts
```

- **Objetivo**: Define a velocidade inicial do jogo.
- **Processo**:
  1. Carrega o valor `6000` em `r0`.
  2. Armazena esse valor na variável `Velocidade`, que será usada nas rotinas de delay para controlar a velocidade da cobra.

### Inicia_flag_e_tiro

```assembly
Inicia_flag_e_tiro:
    
    loadn r0, #0
    store FlagTiro, r0 ; indica se o tiro está ativo ou não
        
    loadn r1, #1019
    store posAtualTiro, r1 ; posAtualTiro guarda a posição do tiro na tela, inicialmente 1019
        
    loadn r2, #1059
    store posAntTiro, r2 ; posição anterior do tiro para dar ideia de movimento
                        
                         
    rts    
```

- **Objetivo**: Inicializa as flags relacionadas ao tiro no jogo.
- **Processo**:
  1. Define `FlagTiro` como `0`, indicando que nenhum tiro está ativo no início.
  2. Define `posAtualTiro` como `1019`, representando a posição inicial do tiro na tela.
  3. Define `posAntTiro` como `1059`, representando a posição anterior do tiro, usada para criar a ilusão de movimento.

### Inicia

```assembly
Inicia: ; 1. inicia o tamanho da cobra 2. declara cada pedaço da cobra 3. printa a cobra 4. inicia a direção inicial da cobra
    push r0
    push r1
    
    loadn r0, #3
    store SnakeTam, r0 ; tamanho inicial da cobra
    
    ; SnakePos[0] = 460
    loadn r0, #SnakePos
    loadn r1, #460
    storei r0, r1
    
    ; SnakePos[1] = 459
    inc r0
    dec r1
    storei r0, r1
    
    ; SnakePos[2] = 458
    inc r0
    dec r1
    storei r0, r1
    
    ; SnakePos[3] = 457
    inc r0
    dec r1
    storei r0, r1
    
    ; SnakePos[4] = -1
    inc r0
    loadn r1, #0
    storei r0, r1

    call FirstPrintSnake ; imprime a cobra inicial
    
    loadn r0, #0
    store Direcao, r0 ; Direção da cobra (0-Direita, 1-Baixo, 2-Esquerda, 3-Cima)
    
    pop r1
    pop r0
    
    rts
```

- **Objetivo**: Inicializa a cobra no jogo.
- **Processo**:
  1. Define o tamanho inicial da cobra como `3`.
  2. Define as posições iniciais dos segmentos da cobra na tela:
     - `SnakePos[0] = 460`
     - `SnakePos[1] = 459`
     - `SnakePos[2] = 458`
     - `SnakePos[3] = 457`
     - `SnakePos[4] = -1` (indicando o final da cobra)
  3. Chama a sub-rotina `FirstPrintSnake` para desenhar a cobra inicial na tela.
  4. Define a direção inicial da cobra como `0` (Direita).

### FirstPrintSnake

```assembly
FirstPrintSnake:
    push r0
    push r1
    push r2
    push r3                    ; CASO DE TEMPO, MUDE O CORPO DA CABEÇA
    
    loadn r0, #SnakePos        ; r0 = endereço do array da cobra
    loadn r1, #'%'             ; caractere da cobra
    loadi r2, r0               ; r2 = SnakePos[0]
        
    loadn r3, #0               ; r3 = 0
    
    Print_Loop:
        outchar r1, r2         ; imprime '%' na posição r2 (posição da cobra)
        
        inc r0
        loadi r2, r0
        
        cmp r2, r3
        jne Print_Loop         ; imprime até chegar no -1
    
    ; imprime a comida do início 
    loadn r0, #820             ; posição da comida
    loadn r1, #'.'             ; '.' -> comida
    outchar r1, r0
    store FoodPos, r0
    
    pop r3
    pop r2
    pop r1
    pop r0
    
    rts
```

- **Objetivo**: Desenha a cobra inicial na tela.
- **Processo**:
  1. Carrega o endereço do array `SnakePos` em `r0`.
  2. Define o caractere da cobra como `'%'` em `r1`.
  3. Carrega a posição inicial da cobra (`SnakePos[0]`) em `r2`.
  4. Entra no loop `Print_Loop`, imprimindo o caractere `'%'` em cada posição da cobra até encontrar `-1`, indicando o fim da cobra.
  5. Após desenhar a cobra, posiciona a comida inicial na tela:
     - Carrega a posição `820` em `r0`.
     - Define o caractere da comida como `'.'` em `r1`.
     - Exibe o caractere da comida na posição especificada e atualiza `FoodPos`.

### EraseSnake

```assembly
EraseSnake:
    push r0
    push r1
    push r2
    push r3
    push r4
    
    loadn r0, #SnakePos        
    inc r0
    loadn r1, #' '            ; caractere espaço para apagar
    loadi r2, r0               ; r2 = SnakePos[0]
        
    loadn r3, #0               ; r3 = 0
    
    Print_Loop:
        outchar r1, r2        ; imprime espaço na tela, apagando parte da cobra
        
        inc r0
        loadi r2, r0
        
        cmp r2, r3
        jne Print_Loop
    
    pop r3
    pop r2
    pop r1
    pop r0
    
    rts
```

- **Objetivo**: Apaga a cobra da tela.
- **Processo**:
  1. Carrega o endereço do array `SnakePos` em `r0` e incrementa para apontar para a segunda posição.
  2. Define o caractere de apagamento como espaço (`' '`).
  3. Entra no loop `Print_Loop`, imprimindo espaços nas posições da cobra até encontrar `0`, indicando o fim da cobra.
  4. Remove os registros da pilha e retorna.

### Desenha_Fase

```assembly
Desenha_Fase: ; desenha a fase 30 linhas por 40 colunas (1200 posições)
    
    push r0    
    push r1    
    push r2    
    push r3    
    push r4    
    push r5

    loadn r0, #0      ; posição inicial da tela
    loadn r3, #40     ; incremento por linha (40 colunas)
    loadn r4, #41     ; incremento do ponteiro da string (cada linha + \0)
    loadn r5, #1200   ; limite da tela
    
ImprimeTela_Loop:
    call ImprimeStr    ; imprime uma linha
    add r0, r0, r3     ; pula para a próxima linha da tela (próxima linha de 40 colunas)
    add r1, r1, r4     ; avança o ponteiro da string para a próxima linha
    cmp r0, r5
    jne ImprimeTela_Loop

    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
```

- **Objetivo**: Desenha a fase atual do jogo na tela.
- **Processo**:
  1. Define a posição inicial da tela, o incremento por linha (40 colunas), o incremento do ponteiro da string e o limite total da tela (1200 posições).
  2. Entra no loop `ImprimeTela_Loop`, chamando a sub-rotina `ImprimeStr` para imprimir cada linha da fase.
  3. Incrementa a posição da tela e o ponteiro da string para avançar para a próxima linha.
  4. Continua até que todas as 30 linhas sejam desenhadas.

### ImprimeStr

```assembly
ImprimeStr:
    push r0
    push r1
    push r2
    push r3
    push r4
    
    loadn r3, #'\0'

ImprimeStr_Loop:
    loadi r4, r1          ; Carrega em r4 o caractere apontado por r1
    cmp r4, r3            ; Compara o caractere atual com '\0'
    jeq ImprimeStr_Sai    ; Se for igual a '\0', salta para ImprimeStr_Sai, encerrando a impressão.
    
    add r4, r2, r4        ; Soma r2 ao valor do caractere. 
    
    outchar r4, r0         ; Imprime o caractere (r4) na posição de tela (r0).
    inc r0                 ; Incrementa a posição na tela para o próximo caractere.
    inc r1                 ; Incrementa o ponteiro da string para o próximo caractere.
    jmp ImprimeStr_Loop    ; Volta ao início do loop para continuar imprimindo.

ImprimeStr_Sai:    
    pop r4    ; Resgata os valores dos registradores utilizados na Sub-rotina da Pilha
    pop r3
    pop r2
    pop r1
    pop r0
    rts
```

- **Objetivo**: Imprime uma string na tela.
- **Processo**:
  1. Define `'\0'` como o caractere de término.
  2. Entra no loop `ImprimeStr_Loop`, carregando cada caractere da string apontada por `r1`.
  3. Compara o caractere com `'\0'` para determinar o fim da string.
  4. Se não for o fim, ajusta o valor do caractere adicionando `r2` (cor) e imprime na posição da tela `r0`.
  5. Incrementa as posições da tela e da string para avançar para o próximo caractere.
  6. Continua até encontrar `'\0'`, removendo os registros da pilha e retornando.

### Move_Snake

```assembly
Move_Snake:
    push r0    ; Direção / SnakePos
    push r1    ; inchar
    push r2    ; local helper
    push r3
    push r4
    
    ; Sincronização
    loadn  r0, #15000 ; MUDOU A VELOCIDADE NO PC DA PRO ALUNO !!!!!!!!!!!!!!!!!!!!!!!!!!!!
    loadn  r1, #0
    mod    r0, r6, r0    ; r0 = r6 % 10000 
    cmp    r0, r1
    jne    Move_End ; isso indica que a cada 10000 ciclos o código abaixo será executado
    
Check_Food:
    ; --> R2 = tela0Linha0 + posAnt + posAnt/40  
    ; Precisamos somar posAnt/40 no ponteiro porque cada linha da string do cenário termina com um caractere '\0', 
    ; logo o endereço na memória não é linear apenas por posAnt, é preciso ajustar pelo número de quebras de linha.

    loadn r1, #tela0Linha0    ; Endereço do início do cenário na memória.
    add   r2, r1, r0          ; R2 = endereço base + posAnt
    loadn r4, #40             ; 40 é a largura da linha do cenário.
    div   r3, r0, r4          ; r3 = posAnt/40 (quantas linhas completas acima)
    add   r2, r2, r3          ; R2 = tela0Linha0 + posAnt + posAnt/40

    loadi r5, r2              ; R5 = caractere da tela na posição calculada (Tela[posAnt])
    load  r0, FoodPos         ; r0 = posição da comida
    loadn r1, #SnakePos       ; r1 = endereço base do array SnakePos
    loadi r2, r1              ; r2 = SnakePos[0], posição da cabeça da cobra

    cmp   r0, r2              ; verifica se a posição da comida é igual à da cobra
    jne   Spread_Move         ; não comeu a comida
    
    call  Increment_Pontuacao ; incrementa a pontuação, caso tenha comido a comida
    
    load  r0, SnakeTam
    inc   r0
    store SnakeTam, r0
    
    loadn r0, #0
    dec   r0
    store FoodStatus, r0
    
    ;--------------------------------
    Spread_Move: ; a lógica é para que o corpo acompanhe o movimento da cobra
        loadn  r0, #SnakePos
        loadn  r1, #SnakePos
        load   r2, SnakeTam
        
        add    r0, r0, r2      ; r0 = SnakePos[Size]
        
        dec    r2              ; r1 = SnakePos[Size-1]
        add    r1, r1, r2
        
        loadn r4, #0
        
    Spread_Loop:
        loadi r3, r1           ; r3 = SnakePos[Size-1] (posição do segmento anterior)
        storei r0, r3          ; Atualiza SnakePos[Size] com a posição do segmento anterior
        
        dec    r0              ; Move r0 para o próximo segmento
        dec    r1              ; Move r1 para o próximo segmento anterior
        
        cmp    r2, r4          ; Verifica se ainda há segmentos a serem processados
        dec    r2
        jne    Spread_Loop     ; Continua até que todos os segmentos tenham sido ajustados

    Change_Direcao:
        inchar  r1
        
        loadn r2, #100    ; char r4 = 'd'
        cmp   r1, r2
        jeq   Move_D
        
        loadn r2, #115    ; char r4 = 's'
        cmp   r1, r2
        jeq   Move_S
        
        loadn r2, #97     ; char r4 = 'a'
        cmp   r1, r2
        jeq   Move_A
        
        loadn r2, #119    ; char r4 = 'w'
        cmp   r1, r2
        jeq   Move_W
        
        ; o código acima faz a verificação da tecla pressionada no inchar
        
        jmp Update_Move
    
    Move_D:
        loadn  r0, #0
        ; Impede de "ir pra trás" - virar 180 graus
        loadn  r1, #2
        load   r2, Direcao
        cmp    r1, r2 ; faz a verificação se a direção em r1 e r2 são iguais, caso seja ele move pra esquerda 
        jeq    Move_Left
        
        store  Direcao, r0
        jmp    Move_Right ; caso não seja, ele move pra direita
        
    ; a lógica continua nas próximas interações
        
    Move_S:
        loadn  r0, #1
        ; Impede de "ir pra trás" - virar 180 graus
        loadn  r1, #3
        load   r2, Direcao
        cmp    r1, r2
        jeq    Move_Up
        
        store  Direcao, r0
        jmp    Move_Down
        
    Move_A:
        loadn  r0, #2
        ; Impede de "ir pra trás" - virar 180 graus
        loadn  r1, #0
        load   r2, Direcao
        cmp    r1, r2
        jeq    Move_Right
        
        store  Direcao, r0
        jmp    Move_Left
        
    Move_W:
        loadn  r0, #3
        ; Impede de "ir pra trás" - virar 180 graus
        loadn  r1, #1
        load   r2, Direcao
        cmp    r1, r2
        jeq    Move_Down
        
        store  Direcao, r0
        jmp    Move_Up
    
    Update_Move:
        load    r0, Direcao
                
        loadn   r2, #0
        cmp     r0, r2
        jeq     Move_Right
        
        loadn   r2, #1
        cmp     r0, r2
        jeq     Move_Down
        
        loadn   r2, #2
        cmp     r0, r2
        jeq     Move_Left
        
        loadn   r2, #3
        cmp     r0, r2
        jeq     Move_Up
        
        jmp     Move_End
        
    Move_Right:
        loadn  r0, #SnakePos    ; r0 = & SnakePos
        loadi  r1, r0           ; r1 = SnakePos[0]
        inc    r1               ; r1++
        storei r0, r1
        
        jmp Move_End
            
    Move_Down:
        loadn  r0, #SnakePos    ; r0 = & SnakePos
        loadi  r1, r0           ; r1 = SnakePos[0]
        loadn  r2, #40
        add    r1, r1, r2
        storei r0, r1
        
        jmp Move_End
        
    Move_Left:
        loadn  r0, #SnakePos    ; r0 = & SnakePos
        loadi  r1, r0           ; r1 = SnakePos[0]
        dec    r1               ; r1--
        storei r0, r1
        
        jmp Move_End
        
    Move_Up:
        loadn  r0, #SnakePos    ; r0 = & SnakePos
        loadi  r1, r0           ; r1 = SnakePos[0]
        loadn  r2, #40
        sub    r1, r1, r2
        storei r0, r1
        
        jmp Move_End
    
    Move_End:
        pop r4
        pop r3
        pop r2
        pop r1
        pop r0

        rts
```

- **Objetivo**: Controlar o movimento da cobra, verificando colisões com a comida e atualizando a posição da cobra.
- **Processo**:
  1. **Sincronização**: Usa um contador (`r6`) para determinar quando atualizar a posição da cobra, baseado na velocidade do jogo.
  2. **Check_Food**: Verifica se a cabeça da cobra está na mesma posição que a comida:
     - Calcula a posição atual da cabeça da cobra considerando a estrutura da tela.
     - Compara essa posição com `FoodPos`.
     - Se coincidir, chama `Increment_Pontuacao`, incrementa o tamanho da cobra (`SnakeTam`) e atualiza `FoodStatus` para reposicionar a comida.
  3. **Spread_Move**: Atualiza a posição de cada segmento da cobra para seguir a cabeça.
  4. **Change_Direcao**: Captura a entrada do usuário para mudar a direção da cobra, impedindo movimentos de 180 graus (invertendo a direção atual).
  5. **Update_Move**: Baseado na direção atual, chama a sub-rotina apropriada para mover a cobra (`Move_Right`, `Move_Down`, `Move_Left`, `Move_Up`).

### Torre

```assembly
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
```

- **Objetivo**: Controlar os tiros emitidos pela torre no jogo.
- **Processo**:
  1. Inicializa os registros `r1` e `r2`.
  2. Entra no loop `tiro`, chamando a sub-rotina `MoveTiro` para movimentar o tiro.
  3. Incrementa `r1` e compara com `r2` para determinar se deve continuar emitindo tiros.
  4. Sai do loop quando a condição é satisfeita e retorna.

### MoveTiro e Sub-rotinas Relacionadas

#### MoveTiro

```assembly
MoveTiro: ; a cada interação do tiro ele verifica se a snake for atingida
    call MoveTiro_RecalculaPos
    call Shot_snake
    call MoveTiro_Apaga
    call Shot_snake
    call MoveTiro_Desenha        
    call Shot_snake
    rts
```

- **Objetivo**: Controlar a movimentação do tiro, verificando se atingiu a cobra e atualizando sua posição na tela.
- **Processo**:
  1. **MoveTiro_RecalculaPos**: Recalcula a posição do tiro e verifica colisões.
  2. **Shot_snake**: Verifica se o tiro atingiu algum segmento da cobra.
  3. **MoveTiro_Apaga**: Apaga o rastro anterior do tiro.
  4. **MoveTiro_Desenha**: Desenha o tiro na nova posição.
  5. Repetição de `Shot_snake` para verificar colisões após cada operação.

#### MoveTiro_Apaga

```assembly
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
```

- **Objetivo**: Atualiza a posição do tiro na tela, apagando seu rastro anterior.
- **Processo**:
  1. Carrega a posição atual do tiro (`posAtualTiro`) em `R1`.
  2. Subtrai `40` (largura da tela) para mover o tiro para cima.
  3. Atualiza `posAntTiro` com a posição anterior e `posAtualTiro` com a nova posição.
  4. Apaga o rastro do tiro imprimindo um espaço na posição anterior.
  5. Remove os registros da pilha e retorna.

#### MoveTiro_RecalculaPos

```assembly
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
```

- **Objetivo**: Recalcula a posição do tiro e verifica se atingiu a cobra ou saiu dos limites da tela.
- **Processo**:
  1. Carrega a posição atual do tiro em `R0`.
  2. Verifica se o tiro atingiu a posição `139`:
     - Se sim, finaliza o recalculo.
  3. Compara a posição do tiro com a posição da cobra (`SnakePos`):
     - Se igual, o tiro atingiu a cobra e ativa o game over.
  4. Caso contrário, apaga o tiro e finaliza.
  5. **MoveTiro_RecalculaPos_Fim**:
     - Desenha um caractere `'_'` na posição do tiro.
     - Re-inicializa as flags relacionadas ao tiro.
     - Apaga o tiro.
  6. **MoveTiro_RecalculaPos_Boom**:
     - Ativa o estado de game over se o tiro atingir a cobra.

#### MoveTiro_Desenha

```assembly
MoveTiro_Desenha:
    push R0
    push R1
        
    loadn R1, #'|'    ; Forma do Tiro
    load R0, posAtualTiro
    outchar R1, R0
    store posAntTiro, R0
        
    pop R1
    pop R0
    rts
```

- **Objetivo**: Desenha o tiro na nova posição na tela.
- **Processo**:
  1. Define o caractere do tiro como `'|'`.
  2. Carrega a posição atual do tiro e exibe o caractere na tela.
  3. Atualiza `posAntTiro` com a nova posição do tiro.
  4. Remove os registros da pilha e retorna.

### Shot_snake

```assembly
Shot_snake:

    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    
    loadn  r0, #SnakePos
    loadn  r1, #SnakePos
    load   r2, SnakeTam
    load   r5, posAtualTiro
    
    add    r0, r0, r2      ; r0 = SnakePos[Size]

    loadn  r4, #0
    
Shot_Loop:
    loadi  r3, r0
                
    dec    r0
        
    cmp    r3, r5
    jeq    GameOver_Activate
        
    cmp    r2, r4
    dec    r2
        
    jne    Shot_Loop    

    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0

    rts
```

- **Objetivo**: Verifica se o tiro atingiu algum segmento da cobra.
- **Processo**:
  1. Carrega a posição da cobra (`SnakePos`) e o tamanho atual (`SnakeTam`).
  2. Carrega a posição atual do tiro (`posAtualTiro`) em `r5`.
  3. Entra no loop `Shot_Loop`, comparando a posição do tiro com cada segmento da cobra.
  4. Se o tiro atingir algum segmento (`r3 == r5`), ativa o game over.
  5. Remove os registros da pilha e retorna.

### Increment_Pontuacao

```assembly
Increment_Pontuacao:
    push r0
    push r1
    push r2
    
    loadn r1, #1 ; coloca o número 1 no registrador r1 para somar com a pontuação atual
    
    load r0, Pontuacao ; carrega pontuação atual em r0 
    add  r0, r0, r1
    
    store Pontuacao, r0
    
    loadn r2, #9
    
    outchar r0, r2
    
    loadn r3, #49
    cmp r0, r3    ; checa se a Pontuacao chegou a 7 (55 em ASCII)
    jeq NextLevel
    
    pop r2    
    pop r1    
    pop r0    
     
    rts
```

- **Objetivo**: Incrementa a pontuação do jogador quando a cobra come a comida.
- **Processo**:
  1. Define `1` em `r1` para adicionar à pontuação atual.
  2. Carrega a pontuação atual de `Pontuacao` em `r0` e adiciona `r1`.
  3. Atualiza `Pontuacao` com o novo valor.
  4. Exibe a nova pontuação na tela.
  5. Verifica se a pontuação atingiu `49` (representando 7 em ASCII):
     - Se sim, chama `NextLevel` para avançar para a próxima fase.
  6. Remove os registros da pilha e retorna.

### Replace_Food

```assembly
Replace_Food:
    push r0
    push r1
    
    loadn  r0, #0
    dec    r0
    load   r1, FoodStatus
    cmp    r0, r1
    
    jne    Replace_End
    
    loadn r1, #0
    store FoodStatus, r1
    load  r1, FoodPos
    
    load  r0, Direcao
    
    loadn r2, #0
    cmp   r0, r2
    jeq   Replace_Right
    
    loadn r2, #1
    cmp   r0, r2
    jeq   Replace_Down
    
    loadn r2, #2
    cmp   r0, r2
    jeq   Replace_Left
    
    loadn r2, #3
    cmp   r0, r2
    jeq   Replace_Up
    
    Replace_Right:
        loadn r3, #355
        add   r1, r1, r3
        jmp   Replace_Boundaries
    Replace_Down:
        loadn r3, #445
        sub   r1, r1, r3
        jmp   Replace_Boundaries
    Replace_Left:
        loadn r3, #395
        sub   r1, r1, r3
        jmp   Replace_Boundaries
    Replace_Up:
        loadn r3, #485
        add   r1, r1, r3
        jmp   Replace_Boundaries
    
    ; caso a comida seja inicialmente calculada para aparecer em uma posição já ocupada por uma barreira,
    ; a posição será recalculada para outra posição, definida por:
    ; Replace_Upper, Replace_Lower, Replace_East ou Replace_West
    ; A escolha do Replace será "aleatória"
    Replace_Boundaries:
        loadn r2, #160
        cmp   r1, r2
        jle   Replace_Lower
        
        loadn r2, #1160
        cmp   r1, r2
        jgr   Replace_Upper
        
        loadn r0, #40
        loadn r3, #1
        mod   r2, r1, r0
        cmp   r2, r3
        jel   Replace_West
        
        loadn r0, #40
        loadn r3, #39
        mod   r2, r1, r0
        cmp   r2, r3
        jeg   Replace_East
        
        loadn r2, #391
        cmp   r1, r2
        jeq   Replace_Lower
        
        loadn r2, #407
        cmp   r1, r2
        jeq   Replace_West
        
        loadn r2, #408
        cmp   r1, r2
        jeq   Replace_Upper
        
        loadn r2, #409
        cmp   r1, r2
        jeq   Replace_East
        
        loadn r2, #410
        cmp   r1, r2
        jeq   Replace_Lower
        
        loadn r2, #411
        cmp   r1, r2
        jeq   Replace_West
        
        loadn r2, #412
        cmp   r1, r2
        jeq   Replace_Upper

        loadn r2, #432
        cmp   r1, r2
        jeq   Replace_East
        
        loadn r2, #447
        cmp   r1, r2
        jeq   Replace_Lower
        
        loadn r2, #448
        cmp   r1, r2
        jeq   Replace_West
        
        loadn r2, #449
        cmp   r1, r2
        jeq   Replace_Upper
        
        loadn r2, #450
        cmp   r1, r2
        jeq   Replace_East
        
        loadn r2, #451
        cmp   r1, r2
        jeq   Replace_Lower
        
        loadn r2, #452
        cmp   r1, r2
        jeq   Replace_West
        
        loadn r2, #472
        cmp   r1, r2
        jeq   Replace_Upper
        
        loadn r2, #487
        cmp   r1, r2
        jeq   Replace_East
        
        loadn r2, #488
        cmp   r1, r2
        jeq   Replace_Lower
        
        loadn r2, #489
        cmp   r1, r2
        jeq   Replace_West
        
        loadn r2, #490
        cmp   r1, r2
        jeq   Replace_Upper
        
        loadn r2, #491
        cmp   r1, r2
        jeq   Replace_East
        
        loadn r2, #492
        cmp   r1, r2
        jeq   Replace_Lower
        
        loadn r2, #891
        cmp   r1, r2
        jeq   Replace_Upper

        loadn r2, #942
        cmp   r1, r2
        jeq   Replace_East
        
        loadn r2, #902
        cmp   r1, r2
        jeq   Replace_West
        
        loadn r2, #903
        cmp   r1, r2
        jeq   Replace_Upper
        
        loadn r2, #904
        cmp   r1, r2
        jeq   Replace_East
        
        loadn r2, #905
        cmp   r1, r2
        jeq   Replace_Lower
        
        loadn r2, #906
        cmp   r1, r2
        jeq   Replace_West
        
        loadn r2, #907
        cmp   r1, r2
        jeq   Replace_Upper
        
        loadn r2, #931
        cmp   r1, r2
        jeq   Replace_East
        
        loadn r2, #942
        cmp   r1, r2
        jeq   Replace_Upper
        
        loadn r2, #943
        cmp   r1, r2
        jeq   Replace_West
        
        loadn r2, #944
        cmp   r1, r2
        jeq   Replace_Lower
        
        loadn r2, #945
        cmp   r1, r2
        jeq   Replace_Upper
        
        loadn r2, #946
        cmp   r1, r2
        jeq   Replace_Lower
        
        loadn r2, #947
        cmp   r1, r2
        jeq   Replace_East
        
        loadn r2, #971
        cmp   r1, r2
        jeq   Replace_Upper
        
        loadn r2, #972
        cmp   r1, r2
        jeq   Replace_Lower
        
        loadn r2, #982
        cmp   r1, r2
        jeq   Replace_West
        
        loadn r2, #983
        cmp   r1, r2
        jeq   Replace_Upper
        
        loadn r2, #984
        cmp   r1, r2
        jeq   Replace_East
        
        loadn r2, #985
        cmp   r1, r2
        jeq   Replace_Lower
        
        loadn r2, #986
        cmp   r1, r2
        jeq   Replace_West
        
        loadn r2, #987
        cmp   r1, r2
        jeq   Replace_Upper

        loadn r2, #1059
        cmp   r1, r2
        jeq   Replace_East

        loadn r2, #1098
        cmp   r1, r2
        jeq   Replace_Upper
        
        loadn r2, #1099
        cmp   r1, r2
        jeq   Replace_West
        
        loadn r2, #1100
        cmp   r1, r2
        jeq   Replace_Lower
        
        loadn r2, #1137
        cmp   r1, r2
        jeq   Replace_East
        
        loadn r2, #1138
        cmp   r1, r2
        jeq   Replace_Upper
        
        loadn r2, #1139
        cmp   r1, r2
        jeq   Replace_West
        
        loadn r2, #1140
        cmp   r1, r2
        jeq   Replace_Lower
        
        loadn r2, #1141
        cmp   r1, r2
        jeq   Replace_Upper
                
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
```

- **Objetivo**: Reposiciona a comida no jogo após ser consumida, garantindo que não apareça em posições inválidas ou ocupadas por barreiras.
- **Processo**:
  1. Verifica o `FoodStatus` para determinar se a comida precisa ser reposicionada.
  2. Se necessário, ajusta a posição da comida com base na direção atual da cobra (`Direcao`).
  3. Verifica se a nova posição está dentro dos limites do cenário e não colide com barreiras específicas.
  4. Atualiza `FoodPos` com a nova posição e desenha a comida na tela.
  5. Remove os registros da pilha e retorna.

### Morte_Snake_1, Morte_Snake_2, Morte_Snake_3

#### Morte_Snake_1

```assembly
Morte_Snake_1: ; função para a fase 1
    loadn r0, #SnakePos
    loadi r1, r0
    
    ; colidiu na parede Direita
    loadn r2, #40
    loadn r3, #39
    mod r2, r1, r2        ; r2 = r1 % 40 (Teste condições de contorno)
    cmp r2, r3
    jeq GameOver_Activate
    
    ; colidiu na parede esquerda
    loadn r2, #40
    loadn r3, #0
    mod r2, r1, r2        ; r2 = r1 % 40 (Teste condições de contorno)
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
    load    r2, SnakeTam
    loadn   r3, #1
    loadi   r4, r0          ; Posição da cabeça
    
Collision_Loop:
    inc     r0
    loadi   r1, r0
    cmp     r1, r4
    jeq     GameOver_Activate
    
    dec     r2
    cmp     r2, r3
    jne     Collision_Loop
    
    jmp Morte_Snake_1_End
    
GameOver_Activate:
    load    r0, FoodPos
    loadn   r1, #' '
    outchar r1, r0
        
    jmp GameOver_loop
    
Morte_Snake_1_End:
    
    rts
```

- **Objetivo**: Verifica colisões da cobra na fase 1 do jogo.
- **Processo**:
  1. Verifica se a cabeça da cobra (`SnakePos[0]`) colidiu com as paredes (direita, esquerda, cima, baixo).
  2. Chama sub-rotinas `wall_1_check` e `wall_2_check` para verificar colisões com barreiras específicas.
  3. Verifica se a cobra colidiu consigo mesma, comparando a posição da cabeça com os segmentos restantes.
  4. Se qualquer colisão for detectada, ativa o estado de game over.
  5. Remove os registros da pilha e retorna.

#### Morte_Snake_2

```assembly
Morte_Snake_2: ; função para a fase 2
    loadn r0, #SnakePos
    loadi r1, r0
    
    ; colidiu na parede Direita
    loadn r2, #40
    loadn r3, #39
    mod r2, r1, r2        ; r2 = r1 % 40 (Teste condições de contorno)
    cmp r2, r3
    jeq GameOver_Activate
    
    ; colidiu na parede esquerda
    loadn r2, #40
    loadn r3, #0
    mod r2, r1, r2        ; r2 = r1 % 40 (Teste condições de contorno)
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
    load    r2, SnakeTam
    loadn   r3, #1
    loadi   r4, r0          ; Posição da cabeça
    
Collision_Loop:
    inc     r0
    loadi   r1, r0
    cmp     r1, r4
    jeq     GameOver_Activate
    
    dec     r2
    cmp     r2, r3
    jne     Collision_Loop
    
    jmp Morte_Snake_2_End
    
GameOver_Activate:
    load    r0, FoodPos
    loadn   r1, #' '
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
```

- **Objetivo**: Verifica colisões da cobra na fase 2 do jogo.
- **Processo**:
  1. Similar ao `Morte_Snake_1`, mas inclui verificações adicionais para caixas específicas no cenário.
  2. Chama sub-rotinas `box_1_check`, `box_2_check` e `wall_1_check` para verificar colisões com barreiras e caixas.
  3. Se qualquer colisão for detectada, ativa o estado de game over e exibe as mensagens apropriadas.
  4. Remove os registros da pilha e retorna.

#### Morte_Snake_3

```assembly
Morte_Snake_3: ; função para a fase 3
    loadn r0, #SnakePos
    loadi r1, r0
    
    ; colidiu na parede Direita
    loadn r2, #40
    loadn r3, #39
    mod r2, r1, r2        ; r2 = r1 % 40 (Teste condições de contorno)
    cmp r2, r3
    jeq GameOver_Activate
    
    ; colidiu na parede esquerda
    loadn r2, #40
    loadn r3, #0
    mod r2, r1, r2        ; r2 = r1 % 40 (Teste condições de contorno)
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
    
    call turret_check ; verifica se a snake colidiu com a torre que atira
    call wall_1_check
    call wall_2_check
    
    ; colidiu na própria cobra
Collision_Check:
    load    r2, SnakeTam
    loadn   r3, #1
    loadi   r4, r0          ; Posição da cabeça
    
Collision_Loop:
    inc     r0
    loadi   r1, r0
    cmp     r1, r4
    jeq     GameOver_Activate
    
    dec     r2
    cmp     r2, r3
    jne     Collision_Loop
    
    jmp Morte_Snake_3_End
    
    
GameOver_Activate:
    load    r0, FoodPos
    loadn   r1, #' '
    outchar r1, r0

    jmp GameOver_loop
    
Morte_Snake_3_End:
    
    rts
```

- **Objetivo**: Verifica colisões da cobra na fase 3 do jogo.
- **Processo**:
  1. Similar aos anteriores, mas inclui a verificação da torre (`turret_check`) que atira na cobra.
  2. Chama sub-rotinas adicionais para verificar colisões com diferentes barreiras.
  3. Se qualquer colisão for detectada, ativa o estado de game over e retorna à tela de game over.
  4. Remove os registros da pilha e retorna.

### Collision Checks (Verificações de Colisão)

Sub-rotinas auxiliares para verificar colisões com diferentes elementos do cenário:

#### box_1_check

```assembly
box_1_check: ; checa se a snake colidiu com uma das caixas do cenário 1. 
    
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
```

- **Objetivo**: Verifica se a cobra colidiu com as caixas específicas do cenário 1.
- **Processo**:
  1. Compara a posição da cobra (`r1`) com as posições das caixas.
  2. Se houver uma correspondência, ativa o estado de game over.
  3. Remove os registros da pilha e retorna.

#### box_2_check

```assembly
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
```

- **Objetivo**: Verifica se a cobra colidiu com as caixas específicas do cenário 2.
- **Processo**:
  1. Compara a posição da cobra (`r1`) com as posições das caixas.
  2. Se houver uma correspondência, ativa o estado de game over.
  3. Remove os registros da pilha e retorna.

#### wall_1_check

```assembly
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
```

- **Objetivo**: Verifica se a cobra colidiu com paredes específicas do cenário 1.
- **Processo**:
  1. Compara a posição da cobra (`r1`) com as posições das paredes.
  2. Se houver uma correspondência, ativa o estado de game over.
  3. Remove os registros da pilha e retorna.

#### wall_2_check

```assembly
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
```

- **Objetivo**: Verifica se a cobra colidiu com paredes específicas do cenário 2.
- **Processo**:
  1. Compara a posição da cobra (`r1`) com as posições das paredes.
  2. Se houver uma correspondência, ativa o estado de game over.
  3. Remove os registros da pilha e retorna.

#### turret_check

```assembly
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
```

- **Objetivo**: Verifica se a cobra colidiu com a torre que atira.
- **Processo**:
  1. Compara a posição da cobra (`r1`) com as posições das torres.
  2. Se houver uma correspondência, ativa o estado de game over.
  3. Remove os registros da pilha e retorna.

### Delay e Shot_Delay

#### Delay

```assembly
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
```

- **Objetivo**: Implementa um delay para controlar a velocidade do jogo.
- **Processo**:
  1. Incrementa o contador `r6`.
  2. Compara `r6` com `Velocidade`.
  3. Se `r6` exceder `Velocidade`, reseta o contador.
  4. Remove os registros da pilha e retorna.

#### Shot_Delay

```assembly
Shot_Delay: 
    push r0
    push r1
    
    loadn r1, #5  ; a
    Delay_volta2:                ; Quebrou o contador acima em duas partes (dois loops de decremento)
        loadn r0, #4000    ; b
    Delay_volta: 
        dec r0               ; (4*a + 6*b) = 1000000  == 1 seg em um clock de 1MHz
        jnz Delay_volta    
        dec r1
        jnz Delay_volta2
    
    pop r1
    pop r0
    
    rts
```

- **Objetivo**: Implementa um delay específico para o tiro, garantindo que ele não se mova muito rapidamente.
- **Processo**:
  1. Define dois contadores `r1` e `r0` para criar um delay de aproximadamente 1 segundo.
  2. Decrementa `r0` em um loop interno e `r1` no loop externo.
  3. Remove os registros da pilha e retorna após o delay.

### NextLevel

```assembly
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
    inchar   r3
    loadn    r4, #' '
    
    cmp r3, r4
    jeq     Next_level_activate
    
    jmp     in_loop

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
    
    cmp r0, r1 ; checa se concluiu o último nível. Em caso positivo, o jogo dá game over e recomeça
    jeq     GameOver_Ganhar
    
    call    Draw_new_Fase    
    call    EraseSnake
    call    Inicia
    call    Inicia_Pontuacao    
    call    increase_Velocidade
    
    pop r3
    pop r2
    pop r1
    pop r0
    
    jmp ingame_loop
        
increase_Velocidade:
    push r0
    push r1
    
    loadn r0, #300 
    load   r1, Velocidade
    sub    r1, r1, r0 ; reduzirá em 300 unidades o valor de Velocidade. Na função delay isso fará com que a snake se movimente mais rápido
    store  Velocidade, r1 
    
    pop r1
    pop r0
    
    rts
    
Draw_new_Fase:
    push r0
    push r1
    push r2
    
    load   r3, Fase ; salva o valor ASCII da fase atual (0 == 48, 1 == 49 , 2 == 50)
    inc    r3
    store  Fase, r3
        
    loadn  r4, #49 
    loadn  r5, #50
    
    cmp    r3, r4
    jeq    Desenha_Fase2
    
    jmp    Desenha_Fase3
    
Desenha_Fase2:
    loadn R1, #tela2Linha0    ; Endereço de início da primeira linha do cenário!!
    loadn R2, #1024
    call Desenha_Fase
    
    outchar r3, r4 ; imprime o 1 em ASCII na posição 49 da tela
                        
    jmp fim_Desenha_Fase
    
; Desenhar a fase 3 
Desenha_Fase3:
    loadn R1, #tela3Linha0    ; Endereço de início da primeira linha do cenário!!
    loadn R2, #256
    call increase_Velocidade
    call Desenha_Fase
    
    outchar r3, r4 
    
fim_Desenha_Fase:

    pop r2
    pop r1
    pop r0
    
    
    rts
```

- **Objetivo**: Avança para a próxima fase do jogo quando o jogador atinge a pontuação necessária.
- **Processo**:
  1. Exibe mensagens de sucesso e instruções para avançar para a próxima fase.
  2. Aguarda a pressão da tecla espaço para continuar.
  3. Apaga as mensagens anteriores da tela.
  4. Verifica se o jogador concluiu todas as fases:
     - Se sim, ativa o estado de game over como vitória.
     - Caso contrário, avança para a próxima fase:
       - Chama `Draw_new_Fase` para desenhar a nova fase.
       - Apaga a cobra existente.
       - Re-inicializa a cobra, pontuação e incrementa a velocidade do jogo.
  5. Remove os registros da pilha e retorna ao loop do jogo.

### Restart_Game

```assembly
Restart_Game:
    inchar   r0
    loadn    r1, #' '
    
    cmp r0, r1
    jeq     Restart_Activate
    
    jmp     Restart_End
    
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
```

- **Objetivo**: Reinicia o jogo após o término, aguardando a pressão da tecla espaço.
- **Processo**:
  1. Aguarda a pressão da tecla espaço (`' '`).
  2. Se a tecla for pressionada, apaga as mensagens de game over da tela.
  3. Apaga a cobra existente.
  4. Reinicia o jogo chamando a função `main`.
  5. Remove os registros da pilha e retorna.

### Imprime

```assembly
Imprime:
    push r0        ; Posição na tela para imprimir a string
    push r1        ; Endereço da string a ser impressa
    push r2        ; Cor da mensagem
    push r3
    push r4

    
    loadn r3, #'\0'

LoopImprime:    
    loadi r4, r1
    cmp r4, r3
    jeq SaiImprime
    add  r4, r2, r4
    outchar r4, r0
    inc  r0
    inc  r1
    jmp  LoopImprime
        
SaiImprime:    
    pop r4    ; Resgata os valores dos registradores utilizados na Sub-rotina da Pilha
    pop r3
    pop r2
    pop r1
    pop r0
    
    rts
```

- **Objetivo**: Imprime uma string na tela com uma cor específica.
- **Processo**:
  1. Define `'\0'` como o caractere de término.
  2. Entra no loop `LoopImprime`, carregando cada caractere da string apontada por `r1`.
  3. Compara o caractere com `'\0'` para determinar o fim da string.
  4. Se não for o fim, ajusta o valor do caractere adicionando `r2` (cor) e imprime na posição da tela `r0`.
  5. Incrementa as posições da tela e da string para avançar para o próximo caractere.
  6. Continua até encontrar `'\0'`, removendo os registros da pilha e retornando.

### tela_final_perdeu e tela_final_ganhou

#### tela_final_perdeu

```assembly
tela_final_perdeu:
    loadn R1, #perdeuLinha0    ; Carrega R1 com o endereço do vetor que contém a mensagem
    loadn R2, #2304
    call Desenha_Fase
    rts
```

- **Objetivo**: Exibe a tela de game over quando o jogador perde.
- **Processo**:
  1. Carrega o endereço da primeira linha da tela de game over (`perdeuLinha0`) em `R1`.
  2. Define a posição na tela para desenhar a mensagem.
  3. Chama `Desenha_Fase` para desenhar a tela de game over.
  4. Retorna.

#### tela_final_ganhou

```assembly
tela_final_ganhou:
    loadn R1, #ganhouLinha0    ; Carrega R1 com o endereço do vetor que contém a mensagem
    loadn R2, #2816
    call Desenha_Fase
    rts
```

- **Objetivo**: Exibe a tela de sucesso quando o jogador completa todas as fases.
- **Processo**:
  1. Carrega o endereço da primeira linha da tela de sucesso (`ganhouLinha0`) em `R1`.
  2. Define a posição na tela para desenhar a mensagem.
  3. Chama `Desenha_Fase` para desenhar a tela de sucesso.
  4. Retorna.

## Definições de Strings

### Telas Iniciais

As strings `inicialLinha0` a `inicialLinha29` definem a tela de início do jogo, exibindo um desenho ASCII do título e instruções para começar.

```assembly
inicialLinha0  : string "                                        "
inicialLinha1  : string "                                        "
inicialLinha2  : string "       _____             _              "
...
inicialLinha29 : string "                                        "    
```

- **Objetivo**: Desenhar a tela inicial com o título do jogo e instruções para iniciar.

### Mensagens de Game Over e Sucesso

As strings `perdeuLinha0` a `perdeuLinha29` e `ganhouLinha0` a `ganhouLinha29` definem as telas de game over e sucesso, respectivamente.

```assembly
perdeuLinha0  : string "                                        "
perdeuLinha1  : string "                                        "
perdeuLinha2  : string "  __      ______   _____  //z           "
...
perdeuLinha29 : string "                                        "    

ganhouLinha0  : string "      __     _____   ____  //z          "
ganhouLinha1  : string "      z z   / / _ z / ___||/_z|         "
...
ganhouLinha29 : string "                                        "
```

- **Objetivo**: Exibir mensagens de game over ou sucesso com desenhos ASCII estilizados.

## Fluxo de Execução Detalhado

1. **Inicialização**:
    - O jogo começa chamando as sub-rotinas de inicialização para configurar a velocidade, flags de tiro e a cobra.
    - A tela inicial é desenhada usando a sub-rotina `Desenha_Fase`.
    - A pontuação e o número da fase são inicializados.
    
2. **Loop Principal**:
    - **Ingame Loop**:
        - **Draw_Snake**: Desenha a cobra na tela.
        - **Fase_colisoes**: Verifica se a cobra colidiu com paredes, barreiras ou consigo mesma.
        - **Move_Snake**: Atualiza a posição da cobra com base na direção atual e entradas do usuário.
        - **Replace_Food**: Reposiciona a comida se foi consumida.
        - **Delay**: Aplica um delay para controlar a velocidade da cobra.
    - **GameOver Loop**:
        - Exibe a tela de game over e chama `Restart_Game` para reiniciar o jogo.
    - **GameOver_Ganhar**:
        - Exibe a tela de sucesso e chama `Restart_Game` para reiniciar o jogo ou avançar para novas fases.

3. **Sub-rotinas de Movimento e Colisão**:
    - As sub-rotinas `Move_Snake`, `Fase_colisoes` e outras verificam e atualizam as posições da cobra, verificam colisões com barreiras e comida, e gerenciam o estado do jogo (iniciando game over ou avançando de fase).

4. **Gerenciamento de Pontuação e Fases**:
    - Ao consumir a comida, a pontuação é incrementada e, ao atingir certos valores, o jogo avança para a próxima fase.
    - A sub-rotina `NextLevel` gerencia a transição entre fases, ajustando a velocidade do jogo e redefinindo elementos conforme necessário.

5. **Gerenciamento de Tiros**:
    - A torre pode emitir tiros que movem pela tela, verificando colisões com a cobra e ativando game over se atingirem.

6. **Reinício do Jogo**:
    - Após game over ou sucesso, o jogador pode reiniciar o jogo pressionando a tecla espaço, que reconfigura as variáveis e reinicia o loop principal.