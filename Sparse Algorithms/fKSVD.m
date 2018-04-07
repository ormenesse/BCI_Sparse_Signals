function [D] = fKSVD(Y,k) % recebe apenas os parametros de tratamento e esparsidade do dicionario
[n,m] = size(Y);
%D = normcols(randn(n,m));
D = normcols(Y);
itn = 1;
for n=1:itn % quantidade de iteracoes que eu desejo 
   [m,h] = size(Y);
   for i=1:h
       %[S] = normal_omp(Y(:,i),D,1e-6,m);
       [S] = OMPerr(D,Y(:,i),k);
       S = full(S);
       if find(isnan(S) == 1)
          fprintf('Tem numero NAN no vetor esparso');
          S(isnan(S))=0;
       end
       RO(:,i) = S; % atualizo todos os vetores esparsos
       %fprintf('\n %d -> %d',n,i);
       %save('R0_KSVD.mat','RO');
   end
   R = Y - D*RO; % minizo o erro
   R(isnan(R))=0; %controle de nan
   for j=1:k %um atomo por vez
       I = find(R(j,:)); %encontro os exemplos que utilizam esse atomo
       E = R(:,I) + D(:,j)*RO(j,I); % computo o erro geral da matriz, selecionando apenas os vetores em I
       [U,S,V] = svd(E); %decomposicao svd
       D(:,j) = U(:,1);
       RO(j,I) = S(1,1)*V(:,1)';
       R(:,I) = E - D(:,j)*RO(j,I); %aloco a difernça nos vetores correspondentes
       if find(isnan(D) == 1)
          %fprintf('\n Tem numero NAN no dic');
          D(isnan(D))=0;
       end
       %save('dic_ksvd.mat','D');
   end
end
