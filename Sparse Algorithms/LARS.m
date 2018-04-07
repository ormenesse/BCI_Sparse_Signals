function [x] = LARS (y,A,i)
%algoritmo p�gina 97 de M. Elad.
%Na realidade isso aqui eh LARS e nao LASSO
Res = y;
[m,n] = size (A);

x = zeros (1,n)' ;
k = 0;
lambda = max(A'*Res);
while 1~=0
    k = k+1;
    x_velho = x;
    %calcular esse z � mais util
    z = A'*(Res-A*x)/lambda;
    [s,j] = max(z);
    x(j) = (A(:,j)'*Res-lambda*sign(x(j)))/(A(:,j)'*A(:,j));
    if norm(x - x_velho) < 1e-6
        break;
    elseif k >= 3000
        %fprintf('\nbreak no LARS');
        break;
    end
    r =rand;
    %fprintf('\n%d %d',k,r);
    lambda = lambda-0.1*lambda;
end
%fprintf('Fim de algoritmo LARS')
