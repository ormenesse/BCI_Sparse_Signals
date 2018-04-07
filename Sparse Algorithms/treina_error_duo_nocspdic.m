%treina amostras sem CSP e sem dicionário
function [val_class,qda,lossqda] = treina_error_duo_nocspdic...
    (a1,a2,r,p,K,max,func_dic_spar,func_spar)
    a11 = a1;
    a22 = a2;
    for i=1:1:length(a11)
        dep = periodogram(a11(:,i));
        dep1(:,i) = dep(1:50);
        dep = periodogram(a22(:,i));
        dep2(:,i) = dep(1:50);
    end
    val_class = [abs(dep1) abs(dep2)];
    
    qda = fitcecoc([val_class(:,r) val_class(:,max+r)]', ...
        [ones(1,length(r)) 2*ones(1,length(r))],'Learners','knn');
    lossqda = loss(qda,[val_class(:,p) val_class(:,max+p)]', ...
        [ones(1,length(p)) 2*ones(1,length(p))])
end