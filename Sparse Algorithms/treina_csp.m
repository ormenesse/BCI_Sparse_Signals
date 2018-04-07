%este script e' responsavel por estabelecer todo o processo de filtragem
%classificacao, criacao de dicionarios esparsos e treino atraves de LDA
%para obter um resultado final. Ainda tenho que implementar mais opcoes de
%classficacao e mais opcoes de criacao de dicionarios e retirada de
%esparsidade.
function [val_class,spa_val_class,qda,lossqda,D] = treina_csp(a1,a2,K,classif,func_dic_spar,func_spar)
    cov1 = cov(a1');
    cov2 = cov(a2');
    cov1(isnan(cov1))=0;
    cov2(isnan(cov2))=0;
    [V,D1,W] = eig(cov1,cov1+cov2);
    filtro = diag(D1);
    filtro(isnan(filtro))=0;
    for i=1:1:length(a1)
        a11(:,i) = abs(filter(filtro,1,a1(:,i)));
        a22(:,i) = abs(filter(filtro,1,a2(:,i)));
    end
    for i=1:1:length(a11)
        dep1(:,i) = periodogram(a11(:,i));
        dep2(:,i) = periodogram(a22(:,i));
    end
    val_class = [abs(dep1) abs(dep2)];
    %[D] = fKSVD(val_class,30,257,12672);
    [D] = func_dic_spar(val_class,K);
    parfor i=1:length(val_class)
        %[S] = OMP(D,val_class(:,i),K);
        [S] = OMP(D,val_class(:,i),K);
        S = full(S);
        if find(isnan(S) == 1)
            S(isnan(S))=0;
            fprintf('\n sparse -> %d',i);
        end
        spa_val_class(:,i) = S; % atualizo todos os vetores esparsos
    end
    qda = fitcdiscr(spa_val_class',classif,'discrimType','diagLinear');
    lossqda = loss(qda,spa_val_class',classif)
end