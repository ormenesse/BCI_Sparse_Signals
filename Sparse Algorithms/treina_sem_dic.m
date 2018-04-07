function [val_class,spa_val_class,D,filters,qda,lossqda] = treina_sem_dic...
    (a1,a2,a3,a4,r,p,K,max,func_dic_spar,func_spar)
%TREINA_SEM_DIC Summary of this function goes here
%   Detailed explanation goes here
    filters = [];
    %[filters] = multiclasscsp(a1(:,r),a2(:,r),a3(:,r),a4(:,r));
    %filters(isnan(filters)) = 0;
    for i=1:1:length(a1(1,:))
        %filtro todas as amostras
%         a11(:,i) = abs(filter(filters(1,:),1,a1(:,i)));
%         a22(:,i) = abs(filter(filters(2,:),1,a2(:,i)));
%         a33(:,i) = abs(filter(filters(3,:),1,a3(:,i)));
%         a44(:,i) = abs(filter(filters(4,:),1,a4(:,i)));
        a11(:,i) = a1(:,i);
        a22(:,i) = a2(:,i);
        a33(:,i) = a3(:,i);
        a44(:,i) = a4(:,i);
    end
    parfor i=1:1:length(a11(1,:))
        %tiro a densidade espectral de potencia de todas as amostras
        dep1(:,i) = periodogram(a11(:,i));
        dep2(:,i) = periodogram(a22(:,i));
        dep3(:,i) = periodogram(a33(:,i));
        dep4(:,i) = periodogram(a44(:,i));
    end
    %teste porque no espectro de potencia tem muito zero
%     dep1 = dep1(1:50,:);
%     dep2 = dep2(1:50,:);
%     dep3 = dep3(1:50,:);
%     dep4 = dep4(1:50,:);
    %para treinar o dicionario, utilizo apenas amostras de teste
    
    [D] = [];
    %testes de validacao
    spa_val_class = [abs(dep1) abs(dep2) abs(dep3) abs(dep4)];
    val_class = [];
    qda = [];
    lossqda = [];
    try
        %classificacao e erro das amostras
        qda = fitcecoc([spa_val_class(:,r) spa_val_class(:,max+r) spa_val_class(:,2*max+r) ...
        spa_val_class(:,3*max+r)]',[ones(1,length(r)) 2*ones(1,length(r)) ...
        3*ones(1,length(r)) 4*ones(1,length(r))],'Learners','linear');
        lossqda = loss(qda,[spa_val_class(:,p) spa_val_class(:,max+p) spa_val_class(:,2*max+p) ...
        spa_val_class(:,3*max+p)]',[ones(1,length(p)) 2*ones(1,length(p)) ...
        3*ones(1,length(p)) 4*ones(1,length(p))])
    catch
        fprintf('Deu erro no treinamento');
    end

end

