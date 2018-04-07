function [D]  = mod_junto(Y,k) % ,param)

    %itN = param.itN;
    %D = param.initialDictionary;
    %errglobal = param.errorGoal;   
    itN = 1;
    [m,n] = size(Y);
    %D = normcols(randn(m,n));
    D = normcols(Y);
    for itn = 1:itN
        
        %X = OMPerr(D,Y,errglobal);
        %[S] = (OMP(K,Y(:,i)',D));
        parfor i=1:1:n
            %[S] = normal_omp(Y(:,i),D,1e-6,m);
            [S] = (OMPerr(D,Y(:,i),k));            
            %fprintf('\n %d',i);
            if find(isnan(S) == 1)
                %fprintf(' Tem numero NAN')
                S(isnan(S))=0;
            end
            X(:,i) = S; % atualizo todos os vetores esparsos
        end
        %save('OMP_feito.mat','X');
        d = size(X,1); % quantos atomos eu tenho no dicionario
        [m,n] = size(Y); % dimensao de Y
        D = (X'\Y')';
    
        % lida com erros NAN e INF
        if sum(sum(isnan(D)))>0 || sum(sum(isinf(D)))>0 
            D = Y(:,ceil(rand(1,d)*n))+0.1*randn(m,d);
            D = D - ones(m,1)*mean(D);
        end
        em = 0;
        temp = sum(isnan(D));
        if (sum(temp) > 0)
            em = 1;
        else
            temp = sum(isinf(D));
            if (sum(temp) > 0)
                em = 1;
            else
                temp = sum(D.*D);
                if (max(temp) > 10)
                    em = 1;
                elseif min(temp) < 0.1
                    em = 1;
                end
            end
        end


        if (em==1)
            D = Y(:,ceil(rand(1,d)*n))+0.1*randn(m,d);
            D = D - ones(m,1)*mean(D);
        end

        %normaliza o dicionario
        sd = sqrt(sum(D.*D));
        D = D.*repmat(1./sd,m,1);
        %save('dic_mod.mat','D')
        %f=sum(sum((Y-D*X).^2));
        %fprintf('\n ** final cost function value is %3.3e ** \n\n',f);
         
    end


end
