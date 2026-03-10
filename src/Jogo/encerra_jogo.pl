
/*
    Exibe a tela de derrota ao abrir uma bomba e 
    encerra o jogo.
*/
encerra_jogo_derrota(ThreadId,N) :-
    thread_signal(ThreadId, abort),
    clear,
    tamanho(L,C),
    Linha is L//2,
    Col is C//2,
    LinhaRanking is L//2-21,
    ColunaRanking is C//2-42,

    move_to(Linha-1, Col-5),
    write('GAME OVER! Você pisou em uma bomba'),

    move_to(Linha+2, Col-5),
    write('Pressione qualquer tecla para sair'),

    get_single_char(_),

    encerramento_derrota(N, LinhaRanking, ColunaRanking),
    show_cursor,
    clear,
    halt.
    

/*
    Exibe a tela de vitória ao detectar todas as
    bombas e marcá-las com as bandeiras e encerra o jogo.
*/
encerra_jogo_vitoria(ThreadId, TempoIni, N) :-
    thread_signal(ThreadId, abort),
    get_time(TempoFinal),
    clear,
    tamanho(L,C),
    Linha is L//2,
    Col is C//2,
    LinhaRanking is L//2-21,
    ColunaRanking is C//2-42,

    move_to(Linha-1, Col-5),
    write('PARABÉNS! Você detectou todas as bombas. Ufa!'),

    move_to(Linha+2, Col-5),
    write('Pressione qualquer tecla para sair'),

    get_single_char(_),

    encerramento_vitoria(TempoIni, TempoFinal, N, LinhaRanking, ColunaRanking),
    show_cursor,
    clear,
    halt.

/*
    Finaliza os detalhes de tempo/ranking da partida em caso de vitória
*/
encerramento_vitoria(TempoIni, TempoFinal, Dificuldade, Lin, Col) :-
    Duracao is TempoFinal - TempoIni,
    salva_tempo(Duracao, Dificuldade),
    clear,
    exibe_ranking(Dificuldade, Lin, Col),
    LinMsg is Lin + 15,
    ColMsg is Col + 20,
    exibe_mensagem_ranking(Duracao, Dificuldade, LinMsg, ColMsg),
    flush_output,
    get_single_char(_),
    !.

/*
    Finaliza os detalhes de tempo/ranking da partida em caso de derrota
*/
encerramento_derrota(Dificuldade, Lin, Col) :-
    clear,
    exibe_ranking(Dificuldade, Lin, Col),
    flush_output,
    get_single_char(_),
    !.