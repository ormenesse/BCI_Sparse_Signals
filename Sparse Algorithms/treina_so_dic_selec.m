%funcao onde o multicsp esta desligado, apenas dicionario
function [val_class,spa_val_class,spa_val_class2,D,filters,qda,lossqda] = treina_so_dic_selec ...
    (a1,a2,a3,a4,r,p,K,max2,func_dic_spar,func_spar)
    
    filters = [];
    %[filters] = multiclasscsp(a1(:,r),a2(:,r),a3(:,r),a4(:,r));
    %filters(isnan(filters)) = 0;
    %for i=1:1:length(a1(1,:))
    %    %filtro todas as amostras
    %    a11(:,i) = abs(filter(filters(1,:),1,a1(:,i)));
    %    a22(:,i) = abs(filter(filters(2,:),1,a2(:,i)));
    %    a33(:,i) = abs(filter(filters(3,:),1,a3(:,i)));
    %    a44(:,i) = abs(filter(filters(4,:),1,a4(:,i)));
    %end
    a11 = a1;
    a22 = a2;
    a33 = a3;
    a44 = a4;
    parfor i=1:1:length(a11(1,:))
        %tiro a densidade espectral de potencia de todas as amostras
        dep1(:,i) = periodogram(a11(:,i));
        dep2(:,i) = periodogram(a22(:,i));
        dep3(:,i) = periodogram(a33(:,i));
        dep4(:,i) = periodogram(a44(:,i));
    end
    %teste porque no espectro de potencia tem muito zero
    dep1 = dep1(1:50,:);
    dep2 = dep2(1:50,:);
    dep3 = dep3(1:50,:);
    dep4 = dep4(1:50,:);
    %para treinar o dicionario, utilizo apenas amostras de teste
    val_class = [abs(dep1(:,r)) abs(dep2(:,r)) abs(dep3(:,r)) abs(dep4(:,r))];
    [D] = func_dic_spar(val_class,K);
    %testes de validacao
    val_class_val = [abs(dep1) abs(dep2) abs(dep3) abs(dep4)];
    %retiro esparsidade de todas as amostras
    parfor i=1:length(val_class_val(1,:))
        [S] = func_spar(D,val_class_val(:,i),K);
        S = full(S);
        if find(isnan(S) == 1)
            S(isnan(S))=0;
            %fprintf('\n sparse -> %d',i);
        end
        spa_val_class(:,i) = S; % atualizo todos os vetores esparsos
    end
    qda = [];
    lossqda = [];
    %try
    %feature selection das amostras
    %S = sum(spa_val_class');
    %S = S./max(S);
    %f_selection = find(S >= 0.5);
    contagem = [];
    S = spa_val_class';
    f_selection = [];
    for y=1:1:6800%length(spa_val_class)
        contagem = find(S(:,y) ~= 0);
        if length(contagem) >= 3600;
            f_selection = [f_selection y];
        end
    end
    spa_val_class2(f_selection,:) = 0;
    spa_val_class2 = spa_val_class;
    for y=1:1:length(spa_val_class)
        deviation = std(spa_val_class(:,y));
        media = mean(spa_val_class(:,y));
        selec = find(spa_val_class(:,y) <= (media-deviation));
        spa_val_class2(selec,y) = 0;
        sel = length(selec);
        selec = find(spa_val_class(:,y) >= (media));
        %spa_val_class2(selec,y) = 0;
        sel = sel + length(selec);
    end
    fprintf('Selecao de caracteristica: %d e %d', length(contagem), length(sel));
    %classificacao e erro das amostras
    try
        qda = fitcecoc([spa_val_class2(:,r) spa_val_class2(:,max2+r) spa_val_class2(:,2*max2+r) ...
        spa_val_class2(:,3*max2+r)]',[ones(1,length(r)) 2*ones(1,length(r)) ...
        3*ones(1,length(r)) 4*ones(1,length(r))],'Learners','knn');
        validacao = [spa_val_class2(:,p) spa_val_class2(:,max2+p) spa_val_class2(:,2*max2+p) spa_val_class2(:,3*max2+p)]';
        respostas = [ones(1,length(p)) 2*ones(1,length(p)) 3*ones(1,length(p)) 4*ones(1,length(p))];
        lossqda = loss(qda,validacao,respostas)
    catch
        fprintf('Deu erro no treinamento');
        lossqda = 100;
    end
end