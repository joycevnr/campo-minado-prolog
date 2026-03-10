/*
    Imprime o ranking
*/
desenha_ranking([], Indice, Lin, Col) :-
    move_to(Lin, Col),
    ( Indice =:= 1 ->
        write('Nenhum tempo registrado nessa dificuldade!')
    ;   desenha_linha(Lin, Col)
    ).
desenha_ranking([X|Xs], Indice, Lin, Col) :-
    desenha_linha(Lin, Col),
    Lin1 is Lin + 1,
    move_to(Lin1, Col),
    pontos(25, Pontos25),
    formata_tempo_str(X, TempoStr),
    pontos(28, Pontos28),
    format('|  ~d° ~s~s~s  |', [Indice, Pontos25, TempoStr, Pontos28]),
    Lin2 is Lin + 2,
    desenha_ranking(Xs, Indice + 1, Lin2, Col).

desenha_linha(Lin, Col) :-
    move_to(Lin, Col),
    tracos(83, Tracos),
    format('+~s+', [Tracos]).

tracos(N, String) :-
    findall('-', between(1, N, _), Chars),
    string_chars(String, Chars).

pontos(N, String) :-
    findall('.', between(1, N, _), Chars),
    string_chars(String, Chars).

formata_tempo_str(Tempo, Sub) :-
    formata_tempo(Tempo, Raw),
    string_length(Raw, Len),
    ( Len =< 23 -> Sub = Raw
    ; sub_string(Raw, 0, 23, _, Sub)
    ).

/*
    Exibe uma mensagem sobre a atualização do ranking
*/
exibe_mensagem_ranking(Tempo, Indice, Lin, Col) :-
    ler_arquivo((TemposF, TemposM, TemposD)),
    ( Indice =:= 9 -> Tempos = TemposF
    ; Indice =:= 16 -> Tempos = TemposM
    ; Tempos = TemposD
    ),
    move_to(Lin, Col),
    ( Tempos = [H|_], Tempo =:= H ->
        write('Parabéns, novo recorde!')
    ; member(Tempo, Tempos) ->
        write('Você obteve um dos seus 5 melhores tempos!')
    ;   write('Que pena, o tempo obtido não está entre os melhores.')
    ).

/*
    Exibe o ranking correspondente
*/
exibe_ranking(Indice, Lin, Col) :-
    ler_arquivo((TemposF, TemposM, TemposD)),
    ( Indice =:= 9 -> Tempos = TemposF
    ; Indice =:= 16 -> Tempos = TemposM
    ; Tempos = TemposD
    ),
    desenha_ranking(Tempos, 1, Lin, Col).
