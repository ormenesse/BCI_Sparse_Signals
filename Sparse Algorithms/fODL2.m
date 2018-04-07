function [D] = fODL2(Y,k) % recebe apenas os parametros de tratamento
[n,m] = size(Y);
%D = normcols(randn(n,m));
D = Y;
[m,k] = size(D);

B = zeros(n,m);
C = zeros(m,m);
p = n;
for i=1:1:length(Y(1,:))
    [x] = LARS (Y(:,i),D,1);
    %[x] = OMPerr(D,Y(:,i),1e-3);
    X(:,i) = x;
    %fprintf('\n %d \n-',i);
    if find(isnan(x) == 1)
        %fprintf('Tem numero NAN')
        x(isnan(x))=0;
    end
end
%fprintf('Terminou de retirar esparsidade');
B = Y*X';
C = X*X';
%fprintf('Terminou de multiplicar matrizes B e C');
for j=1:1:length(D(1,:))
    D(:,j) = (1/(max(sqrt(sum(D(:,j).^2)),1)))*D(:,j);
    %fprintf('\n %d \n-',j);
    %D = normcols(D);
    %save('dic_odl.mat','D');
    if find(isnan(D) == 1)
        %fprintf('Tem numero NAN')
    end
end

end
