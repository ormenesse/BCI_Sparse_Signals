function [filters] = multiclasscsp(a1,a2,a3,a4)
    %Script feito para calcular MultiClass-CSP para 4 classes
    %Calculando as matrizes de covariancia
    cov1 = cov(a1');
    cov2 = cov(a2');
    cov3 = cov(a3');
    cov4 = cov(a4');
    cov1(isnan(cov1))=0;
    cov2(isnan(cov2))=0;
    cov3(isnan(cov3))=0;
    cov4(isnan(cov4))=0;
    %
    %calculando jjoint diagonalization
    covs = [cov1 cov2 cov3 cov4];
    [ V ,  qDs ]= rjd(covs,1e-3);
    % encontrando os autovalores das matrizes
    eig1 = diag(qDs(:,1:650));
    eig2 = diag(qDs(:,651:1300));
    eig3 = diag(qDs(:,1301:1950));
    eig4 = diag(qDs(:,1951:2600));
    %
    % mapping all eigenvalues of each class
    M = 4;
    opt_eig = zeros(M,length(V));
    for jj=1:length(V)
        opt_eig(1,jj) = max(eig1(jj),(1/((1+(1-1)^(2)*eig1(jj))/(1-eig1(jj)))));
        opt_eig(2,jj) = max(eig2(jj),(1/((1+(2-1)^(2)*eig2(jj))/(1-eig2(jj)))));
        opt_eig(3,jj) = max(eig3(jj),(1/((1+(3-1)^(2)*eig3(jj))/(1-eig3(jj)))));
        opt_eig(4,jj) = max(eig4(jj),(1/((1+(4-1)^(2)*eig4(jj))/(1-eig4(jj)))));
    end
    [valor1,ind1] = max(opt_eig(1,:));
    [valor2,ind2] = max(opt_eig(2,:));
    [valor3,ind3] = max(opt_eig(3,:));
    [valor4,ind4] = max(opt_eig(4,:));
    for tentativas = 1:20
        if ind1 == ind2
            if valor1 > valor2
               [valor2,ind2] = max(opt_eig(2,(opt_eig(2,:)~=valor2)));
            else
               [valor1,ind1] = max(opt_eig(1,(opt_eig(1,:)~=valor1)));
            end
        end
        if ind1 == ind3
            if valor1 >= valor3
               [valor3,ind3] = max(opt_eig(3,(opt_eig(3,:)~=valor3)));
            else
               [valor1,ind1] = max(opt_eig(1,(opt_eig(1,:)~=valor1)));
            end  
        end
        if ind1 == ind4
            if valor1 >= valor4
               [valor4,ind4] = max(opt_eig(4,(opt_eig(4,:)~=valor4)));
            else
               [valor1,ind1] = max(opt_eig(1,(opt_eig(1,:)~=valor1)));
            end
        end    
        if ind2 == ind3
            if valor3 >= valor2
               [valor2,ind2] = max(opt_eig(2,(opt_eig(2,:)~=valor2)));
            else
               [valor3,ind3] = max(opt_eig(3,(opt_eig(3,:)~=valor3)));
            end
        end
        if ind3 == ind4
            if valor3 >= valor4
               [valor4,ind4] = max(opt_eig(4,(opt_eig(4,:)~=valor4)));
            else
               [valor3,ind3] = max(opt_eig(3,(opt_eig(3,:)~=valor3)));
            end
        end
        if length(unique([ind1 ind2 ind3 ind4])) ~= 4
            break
        end
    end
    filters(1,:) = V(:,ind1);
    filters(2,:) = V(:,ind2);
    filters(3,:) = V(:,ind3);
    filters(4,:) = V(:,ind4);
end