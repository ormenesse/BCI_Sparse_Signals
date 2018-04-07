function [val_class,spa_val_class,qda,lossqda,D] = treina_csp_error...
    (a1,a2,r,p,K,max,func_dic_spar,func_spar)
    % CSP
    cov1 = cov(a1(:,r)');
    cov2 = cov(a2(:,r)');
    cov1(isnan(cov1))=0;
    cov2(isnan(cov2))=0;
    [V,D1,W] = eig(cov1,cov1+cov2);
    filtro = diag(D1);
    filtro(isnan(filtro))=0;
    for i=1:1:length(a1)
        %a11(:,i) = abs(filter(filtro,1,a1(:,i)));
        %a22(:,i) = abs(filter(filtro,1,a2(:,i)));
        a11 = V(:,1)*a1(:,i);
        a22 = V(:,1)*a2(:,i);
    end
    % FIM CSP
    for i=1:1:length(a11)
        dep1(:,i) = periodogram(a11(:,i));
        dep2(:,i) = periodogram(a22(:,i));
    end
    val_class = [abs(dep1(:,r)) abs(dep2(:,r))];
    [D] = func_dic_spar(val_class,K);
    val_class = [abs(dep1) abs(dep2)];
    parfor i=1:length(val_class)
        [S] = func_spar(D,val_class(:,i),K);
        S = full(S);
        if find(isnan(S) == 1)
            S(isnan(S))=0;
            %fprintf('\n sparse -> %d',i);
        end
        spa_val_class(:,i) = S; % atualizo todos os vetores esparsos
    end
    qda = fitcecoc([spa_val_class(:,r) spa_val_class(:,max+r)]', ...
        [ones(1,length(r)) 2*ones(1,length(r))],'Learners','knn');
    lossqda = loss(qda,[spa_val_class(:,p) spa_val_class(:,max+p)]', ...
        [ones(1,length(p)) 2*ones(1,length(p))])
end