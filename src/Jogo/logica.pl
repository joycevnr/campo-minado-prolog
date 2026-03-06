:- use_module(library(random)).

/* 
   Cria matriz NxN preenchida com 0
*/

cria_tabuleiro(N, Tabuleiro) :-
    length(Tabuleiro, N),
    maplist(cria_linha(N), Tabuleiro).

cria_linha(N, Linha) :-
    length(Linha, N),
    maplist(=(0), Linha).


/* 
   Gera posição aleatória válida
*/

gerar_posicao(N, L, C) :-
    random_between(1, N, L),
    random_between(1, N, C).


/* 
   espalhar_bombas(+Tabuleiro, +QtdBombas, -NovoTabuleiro)

   Coloca bombas aleatórias sem repetir posição
*/

espalhar_bombas(Tabuleiro, 0, Tabuleiro).

espalhar_bombas(Tabuleiro, B, NovoTabuleiro) :-
    length(Tabuleiro, N),
    gerar_posicao(N, L, C),
    nth1(L, Tabuleiro, Linha),
    nth1(C, Linha, Valor),

    (
        Valor == bomba ->
            espalhar_bombas(Tabuleiro, B, NovoTabuleiro)
        ;
            substituir(Tabuleiro, L, C, bomba, T2),
            B1 is B - 1,
            espalhar_bombas(T2, B1, NovoTabuleiro)
    ).


/* 
   Atualiza posição na matriz
 */

substituir(Tabuleiro, L, C, Valor, NovoTabuleiro) :-
    nth1(L, Tabuleiro, Linha),
    substituir_lista(Linha, C, Valor, NovaLinha),
    substituir_lista(Tabuleiro, L, NovaLinha, NovoTabuleiro).

substituir_lista([_|T], 1, V, [V|T]).
substituir_lista([H|T], I, V, [H|R]) :-
    I > 1,
    I1 is I - 1,
    substituir_lista(T, I1, V, R).


/* 
   Retorna:
     bomba -> se for bomba
     N     -> número de bombas ao redor
*/

info_celula(Tab, L, C, bomba) :-
    nth1(L, Tab, Linha),
    nth1(C, Linha, bomba),
    !.

info_celula(Tab, L, C, N) :-
    bombas_adjacentes(Tab, L, C, N).


/* 

   Conta quantas bombas existem ao redor
*/

bombas_adjacentes(Tab, L, C, Total) :-
    findall(1,
        vizinho_com_bomba(Tab, L, C),
        Lista),
    length(Lista, Total).


/* 
   Verifica se algum vizinho possui bomba
*/

vizinho_com_bomba(Tab, L, C) :-
    between(-1,1,DL),
    between(-1,1,DC),
    (DL \= 0 ; DC \= 0),

    NL is L + DL,
    NC is C + DC,

    posicao_valida(Tab, NL, NC),

    nth1(NL, Tab, Linha),
    nth1(NC, Linha, bomba).


/* 

   Gera posições vizinhas
 */

vizinho(L,C,LV,CV) :-
    member(DL,[-1,0,1]),
    member(DC,[-1,0,1]),
    (DL \= 0 ; DC \= 0),
    LV is L + DL,
    CV is C + DC.


/*
   Verifica se posição está dentro do tabuleiro
*/

posicao_valida(Tabuleiro,L,C) :-
    length(Tabuleiro,N),
    L >= 1, L =< N,
    C >= 1, C =< N.