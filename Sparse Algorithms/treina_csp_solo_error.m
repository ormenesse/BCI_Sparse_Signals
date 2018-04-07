%treinamento só com csp
function [val_class,spa_val_class,qda,lossqda,D] = treina_csp_solo_error...
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
        a11(:,i) = V*a1(:,i);
        a22(:,i) = V*a2(:,i);
    end
    % FIM CSP
    for i=1:1:length(a11)
        dep1(:,i) = periodogram(a11(:,i));
        dep2(:,i) = periodogram(a22(:,i));
    end
    val_class = [abs(dep1) abs(dep2)];
    qda = fitcecoc([val_class(:,r) val_class(:,max+r)]', ...
        [ones(1,length(r)) 2*ones(1,length(r))],'Learners','knn');
    lossqda = loss(qda,[val_class(:,p) val_class(:,max+p)]', ...
        [ones(1,length(p)) 2*ones(1,length(p))])
    spa_val_class = 0;
    qda = 0;
    D = 0;
end