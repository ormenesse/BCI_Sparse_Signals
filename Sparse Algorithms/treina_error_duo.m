%treina amostras sem CSP
function [val_class,spa_val_class,qda,lossqda,D] = treina_error_duo...
    (a1,a2,r,p,K,max,func_dic_spar,func_spar)
    a11 = a1;
    a22 = a2;
    for i=1:1:length(a11)
        dep1(:,i) = periodogram(a11(:,i));
        dep2(:,i) = periodogram(a22(:,i));
    end
    val_class = [abs(dep1(:,r)) abs(dep2(:,r))];
    %[D] = fKSVD(val_class,30,257,12672);
    [D] = func_dic_spar(val_class,K);
    val_class = [abs(dep1) abs(dep2)];
    parfor i=1:length(val_class)
        %[S] = OMP(D,val_class(:,i),K);
        [S] = func_spar(D,val_class(:,i),K);
        S = full(S);
        if find(isnan(S) == 1)
            S(isnan(S))=0;
            fprintf('\n sparse -> %d',i);
        end
        spa_val_class(:,i) = S; % atualizo todos os vetores esparsos
    end
    qda = fitcecoc([spa_val_class(:,r) spa_val_class(:,max+r)]', ...
        [ones(1,length(r)) 2*ones(1,length(r))],'Learners','knn');
    lossqda = loss(qda,[spa_val_class(:,p) spa_val_class(:,max+p)]', ...
        [ones(1,length(p)) 2*ones(1,length(p))])
end