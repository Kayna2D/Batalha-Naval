# Batalha Naval
Arquitetura de Computadores - CE4411
Kaynã de Deus - 22.123.096-4
## Descrição
O projeto é desenvolvido no simulador EdSim51 usando Assembly e consiste em um jogo de batalha naval, o tabuleiro 5x5 é gerado na memória RAM e um teclado é usado para que o programa receba a posição desejada.

## Fluxograma
<img src="img/_Fluxograma.png"> 

## Funções
**Montagem do tabuleiro:** O tabuleiro é montado em uma matriz 5x5 na memória de dados, do endereço 020H até 064H, com 0 representando a água e 1 representando os navios. Variáveis para controle de jogadores e pontos também são inicializadas

<img src="img/1.png"/>
<img src="img/2.png"/>
<img src="img/3.png"/>
<img src="img/4.png"/>

**Entrada:** A coordenada que o usuário deseja testar é coletada usando o teclado do simulador, as teclas de linha (0-4) são lidas e armazenadas em R6, enquanto as teclas de coluna (5-9) são lidas e armazenadas em R7.
<img src="img/5.png"/>
<img src="img/6.png"/>
<img src="img/7.png"/>
<img src="img/8.png"/>
<img src="img/9.png"/>
<img src="img/10.png"/>
<img src="img/11.png"/>
<img src="img/12.png"/>
<img src="img/13.png"/>Coordenada da coluna subtraída por 5 para auxiliar na busca dentro do tabuleiro.

**Tiro na memória RAM:** Com a coordenada em mãos, a fórmula para encontrar o endereço correspondente na memória é:
END = Linha * 10H + 20H + (Coluna - 5)
O valor armazenado no endereço é então analisado, se for 0, o novo valor atribuído ao endereço é 02 para sinalizar um tiro errado, se for 1, o novo valor será 3 para sinalizar o acerto. 


<img src="img/14.png"/>
<img src="img/15.png"/>Tiros nos endereços (1,7) e (2,9)


**Mensagens no display:** Sub-rotinas para configurar o display e armazenamento de Strings no endereço 0F00H.

<img src="img/16.png"/>
<img src="img/17.png"/>
<img src="img/18.png"/>
<img src="img/19.png"/>
<img src="img/20.png"/>
<img src="img/21.png"/>
<img src="img/22.png"/>
<img src="img/23.png"/>
<img src="img/24.png"/>
<img src="img/25.png"/>
<img src="img/26.png"/>
<img src="img/27.png"/>
<img src="img/28.png"/>
<img src="img/29.png"/>
<img src="img/30.png"/>
<img src="img/31.png"/>
<img src="img/32.png"/>
<img src="img/33.png"/>

**Mensagem de introdução:** Apresenta o programa e dá instruções pelo display.

<img src="img/34.png"/>
<img src="img/35.png"/>
<img src="img/36.png"/>
<img src="img/37.png"/>
<img src="img/38.png"/>
<img src="img/39.png"/>
<img src="img/40.png"/>
<img src="img/41.png"/>
<img src="img/42.png"/>
<img src="img/43.png"/>

**2 jogadores:** endereço 070h alterna entre 1 e 2 para controlar a vez do jogador e mostrar seus pontos (endereços 071h e 072h) no início de cada turno.
<br/>
<img src="img/44.png"/>
<img src="img/45.png"/>
<img src="img/46.png"/>
<img src="img/47.png"/>
<img src="img/48.png"/>
<img src="img/49.png"/>
<img src="img/50.png"/>

**Fim de turno:** Turno termina mostrando a coordenada e uma sub-rotina para alternar o jogador.
<img src="img/51.png"/>
<img src="img/52.png"/>
<img src="img/53.png"/>
<img src="img/54.png"/>
<img src="img/55.png"/>

**Pontuação:** em caso de acerto, um ponto é incrementado ao endereço que corresponde ao jogador. É feita então a verificação de vitória (pontos = 3).
<br/>
<img src="img/56.png"/>
<img src="img/57.png"/>
<img src="img/58.png"/>
<img src="img/59.png"/>
<img src="img/60.png"/>
<img src="img/61.png"/>


