function [val_class,spa_val_class,D,filters,qda,lossqda] = treina_multicsp_error ...
    (a1,a2,a3,a4,r,p,K,max,func_dic_spar,func_spar)
    [filters] = multiclasscsp(a1(:,r),a2(:,r),a3(:,r),a4(:,r));
    filters(isnan(filters)) = 0;
    for i=1:1:length(a1(1,:))
		for j=1:1:length(filters)
			%filtro todas as amostras
			%a11(:,i) = abs(filter(filters(1,:),1,a1(:,i)));
			%a22(:,i) = abs(filter(filters(2,:),1,a2(:,i)));
			%a33(:,i) = abs(filter(filters(3,:),1,a3(:,i)));
			%a44(:,i) = abs(filter(filters(4,:),1,a4(:,i)));
			a11(:,i) = filters(j,:)*a1(:,i)));
			a22(:,i) = filters(j,:)*a2(:,i)));
			a33(:,i) = filters(j,:)*a3(:,i)));
			a44(:,i) = filters(j,:)*a4(:,i)));
		end
    end
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
            fprintf('\n sparse -> %d',i);
        end
        spa_val_class(:,i) = S; % atualizo todos os vetores esparsos
    end
    qda = [];
    lossqda = [];
    try
        %classificacao e erro das amostras
        qda = fitcecoc([spa_val_class(:,r) spa_val_class(:,max+r) spa_val_class(:,2*max+r) ...
        spa_val_class(:,3*max+r)]',[ones(1,length(r)) 2*ones(1,length(r)) ...
        3*ones(1,length(r)) 4*ones(1,length(r))],'Learners','knn');
        lossqda = loss(qda,[spa_val_class(:,p) spa_val_class(:,max+p) spa_val_class(:,2*max+p) ...
        spa_val_class(:,3*max+p)]',[ones(1,length(p)) 2*ones(1,length(p)) ...
        3*ones(1,length(p)) 4*ones(1,length(p))])
    catch
        fprintf('Deu erro no treinamento');
    end
end