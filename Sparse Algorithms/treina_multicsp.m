function [val_class,spa_val_class,qda,lossqda,D] = treina_multicsp(a1,a2,a3,a4,K,classif,func_dic_spar,func_spar)
    [filters] = multiclasscsp(a1,a2,a3,a4)
    filters(isnan(filters)) = 0;
    for i=1:1:length(a1)
        a11(:,i) = abs(filter(filters(1,:),1,a1(:,i)));
        a22(:,i) = abs(filter(filters(2,:),1,a2(:,i)));
        a33(:,i) = abs(filter(filters(3,:),1,a3(:,i)));
        a44(:,i) = abs(filter(filters(4,:),1,a4(:,i)));
    end
    parfor i=1:1:length(a11)
        dep1(:,i) = periodogram(a11(:,i));
        dep2(:,i) = periodogram(a22(:,i));
        dep3(:,i) = periodogram(a33(:,i));
        dep4(:,i) = periodogram(a44(:,i));
    end
    val_class = [abs(dep1) abs(dep2) abs(dep3) abs(dep4)];
    [D] = func_dic_spar(val_class,K);
    parfor i=1:length(val_class)
        [S] = func_spar(D,val_class(:,i),K);
        S = full(S);
        if find(isnan(S) == 1)
            S(isnan(S))=0;
            fprintf('\n sparse -> %d',i);
        end
        spa_val_class(:,i) = S; % atualizo todos os vetores esparsos
    end
    %qda = fitrlinear(spa_val_class',classif);
    qda = fitcdiscr(spa_val_class',classif,'discrimType','diaLinear');
    %qda = fitcecoc(spa_val_class',classif);
    lossqda = loss(qda,spa_val_class',classif)
end