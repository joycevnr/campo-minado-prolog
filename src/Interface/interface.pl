:- ['cursor.pl'].

/* ---------------------------------------------------------
   clear/0

   Limpa completamente a tela do terminal.
   Usa código ANSI: ESC[2J
--------------------------------------------------------- */
clear :-
    format('\e[2J').

/* ---------------------------------------------------------
   hide_cursor/0

   Oculta o cursor piscante do terminal.
   ANSI: ESC[?25l
--------------------------------------------------------- */
hide_cursor :-
    format('\e[?25l').


/* ---------------------------------------------------------
   show_cursor/0

   Torna o cursor visível novamente.
   ANSI: ESC[?25h
--------------------------------------------------------- */
show_cursor :-
    format('\e[?25h').



/* ---------------------------------------------------------
   desenha_seta(+Index, +Linha, +Coluna)

   Desenha a seta de seleção do menu (->)
   na posição correspondente ao Index.

   Linha → linha onde o menu começa
   Coluna    → coluna onde a seta será desenhada
--------------------------------------------------------- */
desenha_seta(Index, L, Col) :-
    NovaLinha is L + Index,
    move_to(NovaLinha, Col),
    write('->'),
    flush_output.

/* ---------------------------------------------------------
   limpa_seta(+Index, +Linha, +Coluna)

   Remove a seta da posição atual
   sobrescrevendo com dois espaços.
--------------------------------------------------------- */
limpa_seta(Index, L, Col) :-
    NovaLinha is L + Index,
    move_to(NovaLinha, Col),
    write('  ').

/* ---------------------------------------------------------
   novo_index(+Tecla, +IndexAtual, -NovoIndex)

   Calcula novo índice do menu com base na tecla pressionada.

   Movimento:
     W : sobe
     S : desce

   O uso de mod 4 mantém o índice circular
   (ex: se subir do 0 vai para 3).
--------------------------------------------------------- */
novo_index(119, I, NovoI) :- NovoI is (I-1) mod 4.
novo_index(115, I, NovoI) :- NovoI is (I+1) mod 4.
novo_index(27, I, NovoI) :-
    get_single_char(91),
    get_single_char(Direcao),
    novo_index(Direcao, I, NovoI).
novo_index(65, I, NovoI) :- NovoI is (I-1) mod 4.
novo_index(66, I, NovoI) :- NovoI is (I+1) mod 4.
novo_index(_, I, I).

/* ---------------------------------------------------------
   linha_horizontal(+N)

   Desenha uma linha horizontal do tabuleiro:

   +---+---+---+ ...
--------------------------------------------------------- */
linha_horizontal(N) :-
    Total is N,
    forall(between(1,Total,_),
        (write('+---'), fail ; true)), !.


/* ---------------------------------------------------------
   linha_celulas(+N)

   Desenha linha interna das células:

   |   |   |   | ...
--------------------------------------------------------- */
linha_celulas(N) :-
    Total is N,
    forall(between(1,Total,_),
        (write('|   '), fail ; true)), !.


/* ---------------------------------------------------------
   desenha_tabuleiro(+LinhaBase, +ColunaBase, +Tamanho)

   Desenha um tabuleiro NxN a partir da posição base
   (LinhaBase, ColunaBase).

   Cada célula ocupa:
     - 2 linhas
     - 4 colunas

   Estrutura visual:

       +---+---+
       |   |   |
       +---+---+
--------------------------------------------------------- */
desenha_tabuleiro(L,C,N) :-
    Limite is N*2,
    forall(between(0,Limite,I),
        (   NovaLinha is L + I,
            move_to(NovaLinha,C),
            ( 0 is I mod 2 -> linha_horizontal(N), write('+'); linha_celulas(N), write('|'))
        )).

