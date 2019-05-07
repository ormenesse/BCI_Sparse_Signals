# Brain Computer Interface - A approach with Sparse Signals

Como utilizar meus scripts:

Criação de dicionário: fODL2.m, fRLSDLA.m, fILSDLA.m, fKSVD.m, mod_junto.m.
Extração de vetores esparsos: OMP.m, LARS.m
filtro 0.5 a 20hz: filtro_kaiser_0a20.m

Script para rodar os dados:

- cria_dados_treinamento -  4 classes
- cria_dados_treinamento_csp - 2 classes
- dual_csp_22_canais_num_vetor - CSP utilizando 22 canais em um vetor + DEP + KNN - Problema 72 vetores apenas por classe utilizada.

Script de treinamento e erro dos métodos:

- treina_error_duo_nocspdic -> DEP + KNN - 2 classes
- treina_error_duo -> DEP + ESP + KNN - 2 classes
- treina_csp_error -> CSP + DEP + ESP + KNN - 2 classes
- treina_csp_solo_error -> CSP + DEP + KNN - 2 classes

- treina_so_dic ->  DEP + ESP + KNN - 4 classes
- treina_sem_dic -> DEP + KNN - 4 classes
- treina_multicsp_error -> MCSP + DEP + ESP + KNN - 4 classes
- treina_multicsp_selec -> MCSP + DEP + KNN - 4 classes



Para criar todo processo descrito no trabalho eu basicamente utilizei dois scripts:
- cria_dados_treinamento.m -> 4 classes
- cria_dados_treinamento_csp -> 2 classes

Esses scripts são responsáveis por separar, primeiramente, partes que nos são interessantes na amostra do eeg (linhas ~1 à ~77), utilizar filtro kaiser na amostra (linhas ~70 à 87) e treinar as amostras do modo que desejamos (todo o resto), onde aí utilizamos os scripts mencionados acima, que recebem como entradas os dados já tratados e filtrados como deveriam.

Estas linhas:

ele = ls;
load(ele(ii,:));

Leem todas as amostras de cada invíduo, e testa as técnicas um a um. Então se temos 9 individuos, ele faz os testes individuo a individuo e guarda, depois os resultados (esse script talvez seja mais útil que a simulação do BCI Competition 4).

Estas linhas:

  max = 1800; %escolha da quantidade total de amostras
    r = randperm(max,1400);
    p = setdiff(1:max,r);
	
É onde o sistema aleatoriamente pega 70% das amostras para teste e 30% para validação. Como pode-se perceber é variável e podemos mudar isso para o que queiramos. Tentei deixar o mais escalável possível.

Estas linhas:

[val_class,spa_val_class,D1,filters,qda,lossqda] = ...
       treina_multicsp_error(a1,a2,a3,a4,r,p,1e-3,max,@ILSDLA,@OMPerr);
	   
São responsáveis pelo treinamento das amostras. @<método de dicionario> ou @<método extração de vetor>.

a1 = classes.
a2 = classes.
a3 = classes.
a4 = classes.
r = amostras treinamento.
p = amostras validação.
1e-3 = erro mínimo.
max = maximo numero de amostras por classes.
---
val_class = amostras depois da densidade espectral de potência.
spa_val_class = todos os vetores esparsos do sistema.
D1 =  dicionário criado.
filters = filtros mcsp.
qda = modelo criado.
lossqda = erro.


Em cria_dados_treinamento_csp, pode-se encontrar a mesma coisa para duas classes. A única diferença é que eu criei uma função chamada "prob_filtro" para gravar informações sobre a possibilidade de se criar um filtro espacial (não extrai nenhuma informação útil dessa técnica).
