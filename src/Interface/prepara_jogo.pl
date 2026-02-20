:- ['interface.pl'].
:- ['cursor.pl'].



/* ---------------------------------------------------------
   tamanho(-Linhas, -Colunas)

   Verifica o tamanho atual do terminal.

   Requisito mínimo:
     85 colunas x 50 linhas

   Se for menor que o necessário:
     - Exibe mensagem de erro
     - Falha (fail)
--------------------------------------------------------- */
tamanho(Linhas, Colunas) :-
    tty_size(Linhas, Colunas),
    (
        Colunas < 85
        ;
        Linhas < 50
    ),
    !,
    format('TAMANHO INSUFICIENTE!~n', []),
    format('Atual: ~w x ~w | Necessário: 85 x 50~n', [Colunas, Linhas]),
    fail.

tamanho(Linhas, Colunas) :-
    tty_size(Linhas, Colunas).

/* ---------------------------------------------------------
   menu/0

   - Limpa tela
   - Oculta cursor
   - Centraliza texto
   - Exibe opções:
       FACIL
       MEDIO
       DIFICIL
       SAIR
--------------------------------------------------------- */
menu :-
    clear,
    hide_cursor,
    tamanho(L,C),
    LinhaMeio is L//2,
    ColunaMeio is C//2,
    
    move_to(LinhaMeio-4,ColunaMeio-6), write('CAMPO MINADO'),
    move_to(LinhaMeio,ColunaMeio-2), write('FACIL'),
    move_to(LinhaMeio+1,ColunaMeio-2), write('MEDIO'),
    move_to(LinhaMeio+2,ColunaMeio-3), write('DIFICIL'),
    move_to(LinhaMeio+3,ColunaMeio-2), write('SAIR'),

    menu_loop(0, LinhaMeio, ColunaMeio-10).


/* ---------------------------------------------------------
   menu_loop(+IndexAtual, +Linha, +Coluna)

   Loop de navegação do menu.

   - Desenha seta na opção atual
   - Lê tecla
   - ENTER seleciona
   - W/S ou ↑/↓ navegam
--------------------------------------------------------- */
menu_loop(Index, L, Col) :-
    desenha_seta(Index, L, Col),
    get_single_char(Comando),
    limpa_seta(Index, L, Col),
    ((Comando =:= 10 ; Comando =:= 13) ->
       seleciona_opcao(Index,L,Col);
       novo_index(Comando, Index, NovoIndex),
       menu_loop(NovoIndex, L, Col)).

/* ---------------------------------------------------------
   seleciona_opcao(+Index, +Linha, +Coluna)

   0 → Fácil   (9x9)
   1 → Médio   (16x16)
   2 → Difícil (21x21)
   3 → Sair
--------------------------------------------------------- */
seleciona_opcao(0,L,C) :- 
    LimiteL is L-9,
    LimiteC is C-18,
    iniciar(9,LimiteL,LimiteC).
seleciona_opcao(1,L,C) :- 
    LimiteL is L-16,
    LimiteC is C-32,
    iniciar(16,LimiteL,LimiteC).
seleciona_opcao(2,L,C) :- 
    LimiteL is L-21,
    LimiteC is C-42,
    iniciar(21,LimiteL,LimiteC).
seleciona_opcao(3,_,_) :- show_cursor, clear.



/* ---------------------------------------------------------
   iniciar(+Tamanho, +Linha, +Coluna)

   - Limpa tela
   - Desenha tabuleiro NxN
   - Calcula limites máximos do cursor
   - Inicia loop principal do jogo
--------------------------------------------------------- */
iniciar(N,L,C) :-
    clear,
    desenha_tabuleiro(L,C,N),
    Lmax is L+((N-1)*2),
    Cmax is C+((N-1)*4),
    jogo(L,C,Lmax,Cmax,L,C,N).

/* ---------------------------------------------------------
   jogo(+Lmin, +Cmin, +Lmax, +Cmax,
        +LinhaAtual, +ColunaAtual, +N)

   - Marca cursor
   - Lê tecla
   - Apaga cursor
   - Calcula nova posição
   - Continua recursivamente

--------------------------------------------------------- */
jogo(Lmin, Cmin, LMax, CMax, CL, CC, N) :-
    marca_cursor(CL,CC),
    get_single_char(Code),
    apaga_cursor(CL,CC),
    novo_cursor(Code,CL,CC,Lmin,Cmin,LMax,CMax,NL,NC),
    jogo(Lmin,Cmin,LMax, CMax, NL, NC, N). 
