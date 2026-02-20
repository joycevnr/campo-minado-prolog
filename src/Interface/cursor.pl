
/* ---------------------------------------------------------
   move_to(+Linha, +Coluna)

   Move o cursor do terminal para a posição especificada.
   Utiliza código ANSI: ESC[Linha;ColunaH
--------------------------------------------------------- */
move_to(L,C) :-
    format('\e[~d;~dH', [L,C]).
    

/* ---------------------------------------------------------
   clamp(+Min, +Max, +Valor, -Resultado)

   Garante que Valor esteja dentro do intervalo [Min, Max].

   Se Valor < Min → Resultado = Min
   Se Valor > Max → Resultado = Max
   Caso contrário → Resultado = Valor

   Usado para impedir que o cursor saia do tabuleiro.
--------------------------------------------------------- */    
clamp(Min, Max, X, R) :-
    ( X < Min -> R = Min
    ; X > Max -> R = Max
    ; R = X ).


/* ---------------------------------------------------------
   marca_cursor(+Linha, +Coluna)

   Desenha o cursor (borda vermelha) ao redor da célula
   cuja posição base é (Linha, Coluna).

   Estrutura desenhada:

       +---+
       |   |
       +---+

   Usa ANSI \33[31m para cor vermelha.
--------------------------------------------------------- */
marca_cursor(L,C) :-
    write('\33[31m'),
    Topo is L,
    Meio is 1+ Topo,
    Floor is 1+Meio,
    Esq is C,
    Dir is 4+Esq,
    move_to(Topo,Esq),
    write('+---+'),
    move_to(Meio,Esq),
    write('|'),
    move_to(Floor,Esq),
    write('+---+'),
    move_to(Meio,Dir),
    write('|'),
    write('\33[0m'),
    flush_output.


/* ---------------------------------------------------------
   apaga_cursor(+Linha, +Coluna)

   Remove o destaque vermelho redesenhando a borda normal
   da célula.
--------------------------------------------------------- */
apaga_cursor(L,C) :-
    Topo is L,
    Meio is 1+ Topo,
    Floor is 1+Meio,
    Esq is C,
    Dir is 4+Esq,
    move_to(Topo,Esq),
    write('+---+'),
    move_to(Meio,Esq),
    write('|'),
    move_to(Floor,Esq),
    write('+---+'),
    move_to(Meio,Dir),
    write('|'),
    flush_output.

/* ---------------------------------------------------------
   novo_cursor(+Tecla,
               +LinhaAtual, +ColunaAtual,
               +Lmin, +Cmin,
               +Lmax, +Cmax,
               -NovaLinha, -NovaColuna)

   Calcula nova posição do cursor com base na tecla pressionada.

   Movimento:
    W  : sobe 2 linhas
    S  : desce 2 linhas
    A  : esquerda 4 colunas
    D  : direita 4 colunas

   O deslocamento é:
    - 2 linhas (cada célula ocupa 2 linhas)
    - 4 colunas (cada célula ocupa 4 colunas)

   Usa clamp/4 para manter o cursor dentro dos limites.
--------------------------------------------------------- */
novo_cursor(119,L,C,Lmin,_,LMax,_,NL,C) :-
    NL0 is L-2, clamp(Lmin,LMax,NL0,NL).

novo_cursor(115,L,C,Lmin,_,LMax,_,NL,C) :-
    NL0 is L+2, clamp(Lmin,LMax,NL0,NL).

novo_cursor(97,L,C,_,Cmin,_,CMax,L,NC) :-
    NC0 is C-4, clamp(Cmin,CMax,NC0,NC).

novo_cursor(100,L,C,_,Cmin,_,CMax,L,NC) :-
    NC0 is C+4, clamp(Cmin,CMax,NC0,NC).

novo_cursor(27,L,C,Lmin,Cmin,LMax,CMax,NL,NC) :-
    get_single_char(91),
    get_single_char(Direcao),
    novo_cursor(Direcao,L,C,Lmin,Cmin,LMax,CMax,NL,NC).

novo_cursor(65,L,C,Lmin,_,LMax,_,NL,C) :-
    NL0 is L-2, clamp(Lmin,LMax,NL0,NL).

novo_cursor(66,L,C,Lmin,_,LMax,_,NL,C) :-
    NL0 is L+2, clamp(Lmin,LMax,NL0,NL).

novo_cursor(67,L,C,_,Cmin,_,CMax,L,NC) :-
    NC0 is C+4, clamp(Cmin,CMax,NC0,NC).

novo_cursor(68,L,C,_,Cmin,_,CMax,L,NC) :-
    NC0 is C-4, clamp(Cmin,CMax,NC0,NC).

novo_cursor(_,L,C,_,_,_,_,L,C).
