<div align="center">

# 💣 Campo Minado em Prolog

<img src="https://img.shields.io/badge/Prolog-000000?style=for-the-badge&logo=prolog&logoColor=white" alt="Prolog" />
<img src="https://img.shields.io/badge/Paradigm-Logical-D00000?style=for-the-badge" alt="Logical" />
<img src="https://img.shields.io/badge/UFCG-PLP-blue?style=for-the-badge&logo=google-scholar&logoColor=white" alt="UFCG" />
<img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License" />

<br />

<p align="center">
  <b>Uma implementação lógica e dedutiva do clássico jogo de estratégia.</b><br>
  Desenvolvido para a disciplina de <i>Paradigmas de Linguagens de Programação</i> da <b>UFCG</b>.
</p>

[Funcionalidades](#funcionalidades-do-projeto) • [Demonstração](#demonstração) • [Estrutura](#estrutura-do-projeto) • [Instalação](#configuração-e-instalação) • [Autores](#autores)

</div>

<div style="border-bottom: 3px solid #D00000;"></div>

---

## Visão Geral

Este projeto é uma implementação do clássico jogo **Campo Minado** (Minesweeper) desenvolvido inteiramente em **Prolog**, utilizando o ambiente **SWI-Prolog**. O objetivo principal é aplicar conceitos fundamentais do **Paradigma Lógico** — como declaração de fatos, definição de regras, unificação e *backtracking* — em uma aplicação interativa executada via terminal.

---

## Funcionalidades do Projeto

O jogo é totalmente executado no terminal (`CLI`) e conta com as seguintes características:

1. **Menu Principal:** Seleção de dificuldade (Fácil, Médio, Difícil) e opção de sair.
2. **Navegação Interativa:** Cursor controlado via teclado ou inserção de coordenadas lógicas.
3. **Mecanismo de Inferência:** Distribuição de bombas, cálculo de vizinhos e revelação em cascata (recursão lógica).
4. **Estados do Jogo:** Validação contínua das condições de Vitória e Derrota.
5. **Ranking:** Sistema de pontuação com persistência de melhores tempos (leitura e escrita de base de conhecimento).
6. **Interface:** Desenho do tabuleiro no console utilizando a biblioteca nativa `ansi_term` para cores e formatação.

---
<!-- 
## Demonstração -->

<!-- <div align="center">
  <table>
    <tr>
      <td align="center">
        <img src="img/Menu.png" height="200" alt="Menu Principal">
        <br><sub><b>Menu Principal</b></sub>
      </td>
      <td align="center">
        <img src="img/Vitoria.png" height="200" alt="Vitória">
        <br><sub><b>Vitória</b></sub>
      </td>
      <td align="center">
        <img src="img/GameOver.png" height="200" alt="Game Over">
        <br><sub><b>Derrota</b></sub>
      </td>
    </tr>
  </table>
  <br />
    <img src="img/Jogo.png" height="500" alt="Gameplay">
  <br>
  <sub><b>Tabuleiro em Execução</b></sub>
</div> -->


## Estrutura do Projeto

O código foi modularizado utilizando a diretiva `:- module` do Prolog para garantir legibilidade e facilitar a manutenção:

| Arquivo | Descrição |
| :--- | :--- |
| `src/main.pl` | Ponto de entrada, inicialização e importação dos módulos principais. |
| `src/Interface/prepara_jogo.pl` | Configuração inicial do terminal e renderização do menu. |
| `src/Interface/interface.pl` | Controle de I/O, renderização do tabuleiro e interação do usuário. |
| `src/Jogo/logica.pl` | Base de conhecimento, distribuição de bombas e regras de negócio. |
| `src/Jogo/regras_jogo.pl` | Verificação de estados: cálculo de vizinhança, vitória e derrota. |

---

## Configuração e Instalação

Este projeto utiliza o **SWI-Prolog** como ambiente de desenvolvimento e execução.

### Pré-requisitos

* [SWI-Prolog](https://www.swi-prolog.org/Download.html) instalado na máquina.
* Terminal com suporte a *ANSI escape codes* (Linux, macOS ou Windows via WSL/PowerShell).

### Passo a Passo

1.  **Clone o repositório:**

    ```bash
    git clone https://github.com/SEU-USUARIO/campo-minado-prolog.git
    cd campo-minado-prolog
    ```

2.  **Inicie o ambiente interativo do Prolog:**

    ```bash
    swipl
    ```

3.  **Carregue o arquivo principal e inicie o jogo:**

    ```prolog
    ?- ['src/main.pl'].
    ?- main.
    ```

---

## Autores

Este projeto foi desenvolvido pelos alunos:

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/annegmsilva">
        <img src="https://github.com/annegmsilva.png" width="100px;" alt="Foto de Anne Grazieli"/><br>
        <sub><b>Anne Grazieli</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/joycevnr">
        <img src="https://github.com/joycevnr.png" width="100px;" alt="Foto de Joyce Vitória"/><br>
        <sub><b>Joyce Vitória</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/Eduarda-Cabral">
        <img src="https://github.com/Eduarda-Cabral.png" width="100px;" alt="Foto de Maria Eduarda"/><br>
        <sub><b>Maria Eduarda</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/Pedroz007">
        <img src="https://github.com/Pedroz007.png" width="100px;" alt="Foto de Pedro Henrique"/><br>
        <sub><b>Pedro Henrique</b></sub>
      </a>
    </td>
     <td align="center">
      <a href="https://github.com/Thiago-Barbos">
        <img src="https://github.com/Thiago-Barbos.png" width="100px;" alt="Foto de Thiago Barbosa"/><br>
        <sub><b>Thiago Barbosa</b></sub>
      </a>
    </td>
  </tr>
</table>