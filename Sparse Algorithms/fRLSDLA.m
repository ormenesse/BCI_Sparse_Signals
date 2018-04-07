function [D] = fRLSDLA(Y,k)
[n,m] = size(Y);
%D = normcols(randn(n,m));
D = normcols(Y);
C = zeros(m); %inicializando C, na medida do possivel.
% tentativa de inicializar C com qualquer valor.
% [m,h] = size(X);
% for i=1:h
%     [S] = normal_omp(Y(:,i),D,1e-6,m);
%     W(:,i) = S; % atualizo todos os vetores esparsos
% end
% C = pinv(W*W');
lambda=0.6; % lambda 0 << lambda <= 1
[m,h] = size(Y);
%Y = Y/10000;
for i=1:h
   %fprintf('\n %d',i);
   %[w] = normal_omp(Y(:,i),D,1e-6,16);
   %[w] = LARS (Y(:,i),D);
   [w] = (OMPerr(D,Y(:,i),k)); %w = w'; %so para OMP
   if find(isnan(w) == 1)
       %fprintf(' Tem numero NAN')
       w(isnan(w))=0;
   end
   W(:,i) = w; % atualizo todos os vetores esparsos
   %ate aqui funciona
   r = Y(:,i) - D*w; % minizo o erro
   C_trans = ((1/lambda)*C);
   u = C_trans*w;
   %v = D'*r;
   alpha = 1/(1+w'*u);
   %achando o produto interno do dicion�rio, para Di
   %DD = D'*D + alpha*(v*u'+u*v') + (alpha^2)*(r'*r)*(u'*u);
   D = D+alpha*r*u';
   C = C_trans-alpha*u*u';
   %fprintf('\n %d',i);
   if find(isnan(D) == 1)
        %fprintf(' Tem numero NAN no dicionario\n');
        D(isnan(D))=0;
   end
   %D = normcols(D);
   %save('dic_rls.mat','D');
end
