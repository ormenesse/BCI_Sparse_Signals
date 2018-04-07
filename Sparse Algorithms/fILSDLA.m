function [D] = fILSDLA(Y,k) % recebe apenas os parametros de tratamento
[m,n] = size(Y);
%D = normcols(randn(m,n));
D = normcols(Y);
for it = 1:1
    [m,h] = size(Y);
    D(isnan(D))=0;
    parfor i=1:h
        [S] = OMPerr(D,Y(:,i),k);
        S(isnan(S))=0;
        %i
        W(:,i) = S; % atualizo todos os vetores esparsos
    end
%     W = normcols(W);
%     Y = normcols(Y);
%     D = normcols(D);
    fprintf('Criando o dicionário');
    D = (Y*W')/(W*W');
    D(isnan(D))=0;
    fprintf('Normalizando o dicionário');
    D = normcols(D);
end
