:- module(regras_jogo, [
    iniciar_logica/1,
    abrir_celula/6,
    checa_vitoria/1,
    tabuleiro/1          
]).

:- use_module(library(random)).
:- dynamic tabuleiro/1.


/* -------------------------------------------------
   iniciar_logica(+N)

   Cria tabuleiro NxN e distribui bombas
------------------------------------------------- */

iniciar_logica(N) :-
    criar_tabuleiro(N, Tab),
    espalhar_bombas(Tab, N, TabComBombas),
    retractall(tabuleiro(_)),
    assert(tabuleiro(TabComBombas)).


/* 
   Cria matriz NxN preenchida com 0
*/

criar_tabuleiro(N, Tabuleiro) :-
    length(Tabuleiro, N),
    maplist(criar_linha(N), Tabuleiro).

criar_linha(N, Linha) :-
    length(Linha, N),
    maplist(=(0), Linha).


/* 
   Distribui aproximadamente N bombas no tabuleiro aleatoriamente
 */

espalhar_bombas(Tab, N, NovoTab) :-
    Bombas is N,
    espalhar(Bombas, Tab, N, NovoTab).

espalhar(0, Tab, _, Tab).
espalhar(K, Tab, N, NovoTab) :-
    random_between(1, N, L),
    random_between(1, N, C),
    colocar_bomba(Tab, L, C, TabTemp),
    K1 is K - 1,
    espalhar(K1, TabTemp, N, NovoTab).


/*
   colocar_bomba

   Insere bomba na posição
 */

colocar_bomba(Tab, L, C, NovoTab) :-
    nth1(L, Tab, Linha),
    substituir(Linha, C, bomba, NovaLinha),
    substituir(Tab, L, NovaLinha, NovoTab).


/* 
   substituir elemento em lista
 */

substituir([_|T],1,X,[X|T]).
substituir([H|T],I,X,[H|R]) :-
    I > 1,
    I1 is I-1,
    substituir(T,I1,X,R).


/* 
   consulta uma célula e imprime seu valor no tabuleiro

 */

abrir_celula(Lmin,Cmin,CL,CC,_,_) :-
    Linha is ((CL-Lmin)//2)+1,
    Coluna is ((CC-Cmin)//4)+1,
    tabuleiro(Tab),
    info_celula(Tab,Linha,Coluna,Info),

    MeioL is CL + 1,
    MeioC is CC + 2,
    move_to(MeioL,MeioC),

    (
        Info == bomba ->
            write('*'), 
            encerra_jogo_derrota
        ;
            write(Info)
    ),

    flush_output.


/* 
   info_celula(+Tab,+L,+C,-Info)

   Retorna:
      bomba
      ou número de bombas adjacentes
*/

info_celula(Tab,L,C,bomba) :-
    nth1(L,Tab,Linha),
    nth1(C,Linha,bomba), !.

info_celula(Tab,L,C,Num) :-
    contar_bombas(Tab,L,C,Num).


/*
   contar bombas adjacentes a uma célula
 */

contar_bombas(Tab,L,C,Total) :-
    findall(1,
        (
            vizinho(L,C,Vl,Vc),
            dentro(Tab,Vl,Vc),
            eh_bomba(Tab,Vl,Vc)
        ),
    Lista),
    length(Lista,Total).

/*
    Verifica se o jogador já detectou todas as bombas
    e marcou com as bandeiras
*/

checa_vitoria(Tab) :-
    posicoes_bombas(Tab, Posbomba),
    msort(Posbomba, PBomba),
    lista_bandeiras(Lbandeira),
    msort(Lbandeira, PBandeira),
    (
        PBomba = PBandeira
        -> encerra_jogo_vitoria
        ; true
    ).



vizinho(L,C,L1,C1) :-
    member((DL,DC),
    [(-1,-1),(-1,0),(-1,1),
     (0,-1),       (0,1),
     (1,-1),(1,0),(1,1)]),
    L1 is L+DL,
    C1 is C+DC.


dentro(Tab,L,C) :-
    length(Tab,N),
    L >= 1, L =< N,
    C >= 1, C =< N.


eh_bomba(Tab,L,C) :-
    nth1(L,Tab,Linha),
    nth1(C,Linha,bomba).