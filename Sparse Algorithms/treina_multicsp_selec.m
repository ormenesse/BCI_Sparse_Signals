% treinamento multi csp com feature selection;
function [val_class,val_class_val,D,filters,qda,lossqda] = treina_multicsp_selec ...
    (a1,a2,a3,a4,r,p,K,max2,func_dic_spar,func_spar)
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
    %testes de validacao
    val_class_val = [abs(dep1) abs(dep2) abs(dep3) abs(dep4)];
    qda = [];
    lossqda = [];
	val_class = [];
    try
        %classificacao e erro das amostras
        qda = fitcecoc([val_class_val(:,r) val_class_val(:,max2+r) val_class_val(:,2*max2+r) ...
        val_class_val(:,3*max2+r)]',[ones(1,length(r)) 2*ones(1,length(r)) ...
        3*ones(1,length(r)) 4*ones(1,length(r))],'Learners','knn');
        validacao = [val_class_val(:,p) val_class_val(:,max2+p) val_class_val(:,2*max2+p) val_class_val(:,3*max2+p)]';
        respostas = [ones(1,length(p)) 2*ones(1,length(p)) 3*ones(1,length(p)) 4*ones(1,length(p))];
        lossqda = loss(qda,validacao,respostas)
    catch
        fprintf('Deu erro no treinamento');
    end
end