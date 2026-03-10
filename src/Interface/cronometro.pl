:- use_module(library(lists)).

/*
    Exibe o cronômetro do jogo
*/
cronometro(TempoIni, Lin, Col) :-
    get_time(TempoCorrente),
    Duracao is TempoCorrente - TempoIni,
    move_to(Lin, Col),
    formata_tempo(Duracao, String),
    write(String),
    flush_output,
    sleep(1),
    cronometro(TempoIni, Lin, Col).

/*
    Formata o tempo de acordo com sua ordem de grandeza
*/
formata_tempo(Tempo, String) :-
    ( Tempo < 60 ->
        format(string(String), '         ~0f seg         ', [Tempo])
    ; Tempo < 3600 ->
        Minutes is floor(Tempo / 60),
        Seconds is Tempo - Minutes * 60,
        format(string(String), '      ~d min ~0f seg      ', [Minutes, Seconds])
    ;   Hours is floor(Tempo / 3600),
        Minutes is floor((Tempo - Hours*3600) / 60),
        Seconds is Tempo - Hours*3600 - Minutes*60,
        format(string(String), '   ~d hr ~d min ~0f seg    ', [Hours, Minutes, Seconds])
    ).

/*
    Atualiza uma lista de tempos adicionando um novo tempo
*/
adiciona_tempo(NovoTempo, Lista, Limite, NovaLista) :-
    adiciona_tempo_aux(NovoTempo, Lista, Limite, [], Temp),
    reverse(Temp, NovaLista).

adiciona_tempo_aux(_, _, 0, Acum, Acum) :- !.
adiciona_tempo_aux(NovoTempo, [], Limite, Acum, [NovoTempo|Acum]) :- Limite > 0.
adiciona_tempo_aux(NovoTempo, [X|Xs], Limite, Acum, Result) :-
    Limite > 0,
    ( NovoTempo < X ->
        NovoLimite is Limite - 1,
        adiciona_tempo_aux(X, Xs, NovoLimite, [NovoTempo|Acum], Result)
    ;   NovoLimite is Limite - 1,
        adiciona_tempo_aux(NovoTempo, Xs, NovoLimite, [X|Acum], Result)
    ).

/*
    Salva um novo tempo
*/
salva_tempo(NovoTempo, Indice) :-
    ler_arquivo((TemposF, TemposM, TemposD)),
    ( Indice =:= 9 ->
        adiciona_tempo(NovoTempo, TemposF, 5, NovosF),
        grava_arquivo((NovosF, TemposM, TemposD))
    ; Indice =:= 16 ->
        adiciona_tempo(NovoTempo, TemposM, 5, NovosM),
        grava_arquivo((TemposF, NovosM, TemposD))
    ;   adiciona_tempo(NovoTempo, TemposD, 5, NovosD),
        grava_arquivo((TemposF, TemposM, NovosD))
    ).