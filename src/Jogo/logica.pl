:- use_module(library(random)).
:- dynamic bandeira/2.
:- dynamic contador_bandeiras/1.

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

/*
    Inicializa o contador de bombas
*/

iniciar_contador :-
    retractall(contador_bandeiras(_)),
    assertz(contador_bandeiras(0)).

/*
   Recebe o tabuleiro e retorna uma lista com todas 
   as posições que possuem bombas
*/

posicoes_bombas(Tab, Lista) :-
    findall((L,C),
        (
            nth1(L, Tab, Linha),
            nth1(C, Linha, bomba)
        ),
        Lista).


/*
    Incrementa o contador de bandeiras em 1
*/

incrementa_bandeiras :-
    contador_bandeiras(N),
    N1 is N + 1,
    retract(contador_bandeiras(N)),
    assertz(contador_bandeiras(N1)).

/*
    Incrementa o contador de bandeiras em 1
*/

decrementa_bandeiras :-
    contador_bandeiras(N),
    N1 is N - 1,
    retract(contador_bandeiras(N)),
    assertz(contador_bandeiras(N1)).


/*
   adiciona uma bandeira a uma posição se ainda não houver e
   a remove se já tiver sido adicionada àquela posição
*/

manipula_bandeira(CL,CC,Lmin,Cmin) :-
    Linha is ((CL-Lmin)//2)+1,
    Coluna is ((CC-Cmin)//4)+1,
    (   bandeira(Linha,Coluna)
    ->  retract(bandeira(Linha,Coluna)), decrementa_bandeiras, apaga_bandeira(CL,CC)
    ;   assertz(bandeira(Linha,Coluna)), incrementa_bandeiras
    ).

/*
    Apaga uma bandeira do tabuleiro e da lista de bandeiras se
    o usuário seleciona espaco em uma casa que já possui
    uma bandeira
*/

apaga_bandeira(L, C) :-
    MeioL is L + 1,
    MeioC is C + 2,
    move_to(MeioL, MeioC),
    write(' '),
    flush_output.

/*
    Retorna uma lista com todas as posições de bandeiras
*/

lista_bandeiras(Lista) :-
    findall((L,C), bandeira(L,C), Lista).