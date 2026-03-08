
/*
    Exibe a tela de derrota ao abrir uma bomba e 
    encerra o jogo.
*/
encerra_jogo_derrota :-
    clear,
    show_cursor,
    tamanho(L,C),
    Linha is L//2,
    Col is C//2,

    move_to(Linha-1, Col-5),
    write('GAME OVER! Você pisou em uma bomba'),

    move_to(Linha+2, Col-5),
    write('Pressione qualquer tecla para sair'),

    get_single_char(_),
    show_cursor,
    clear,
    halt.
    

/*
    Exibe a tela de vitória ao detectar todas as
    bombas e marcá-las com as bandeiras e encerra o jogo.
*/
encerra_jogo_vitoria :-
    clear,
    show_cursor,
    tamanho(L,C),
    Linha is L//2,
    Col is C//2,

    move_to(Linha-1, Col-5),
    write('PARABÉNS! Você detectou todas as bombas. Ufa!'),

    move_to(Linha+2, Col-5),
    write('Pressione qualquer tecla para sair'),

    get_single_char(_),
    show_cursor,
    clear,
    halt.