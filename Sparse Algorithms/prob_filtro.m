function [canais] = prob_filtro(spa_val_class,qda,max,p)

%verificando erro de cada canal (probabilidade de criamos um filtro
    %espacial
    canais_teste = rem(p,25); %sao 25 canais por enquanto
    canais_teste = [canais_teste canais_teste];
    multiplicador = 0;
    for class=1:1:2
        canais = spa_val_class(:,multiplicador*max+p);
        prediz = predict(qda,[canais]');
        for canal=1:1:length(p)
            if prediz(canal) == class
                acerto = 1;
            else
                acerto = 0;
            end
            canais_teste(2,multiplicador*length(p)+canal) = acerto;
        end
        multiplicador = multiplicador+1;
    end
    canais = canais_teste(:,find(canais_teste(2,:)==0));
end