
func = {'mod_junto','fILSDLA','fKSVD','fODL2','fRLSDLA'};
for e=1:1:5%length(func)
    fprintf(func{e})
    for ii=3:1:19
        %lendo dados
        ele = ls;
        load(ele(ii,:));
        %fim leitura dados
        DadosBrutos = [];
        y = [];
        %processo �:
        % ~500 amostras fixation cross
        % ~250 amostras Cue
        % ~750 amostras Motor imagery
        % ~500 amostras Break
        % 2000 amostras Total
        tempo = 1/250; %s
        tempo_total = 2; %s
        amostras = 2/tempo; %numero de amostras
        %tenho que pegar as amostras depois de 3,5 segundos
        %ent�o tenho que esperar:
        motor = 3/tempo; % tempo de espera amostras
        %definindo os tempos de cada treinamento
        for j=4:9
            t = data{1,j}.trial;
            t1 = [data{1,j}.trial;0];
            t2 = [0;data{1,j}.trial];
            t3 = t1-t2;
            t3 = t3(2:48);
            %
            for i=1:(length(t))
               if i == length(t)
                   dados = data{1,j}.X(t(i):end,:);
               else
                   dados = data{1,j}.X(t(i):t(i+1),:);
               end
               DadosBrutos = [DadosBrutos; dados(751:1400,:)'];
            end
            y = [y; data{1,j}.y];
        end

        rot_dados = ones(1,length(y)*25)';
        j = 0;
        for i=1:length(y)*25
            if mod(i-1,25) == 0
                j = j + 1;
            end
            rot_dados(i) = y(j)*rot_dados(i); % Rotulo dados eu tenho que ter salvado em algum lugar
        end

        %%%%%%%%%
        %Extraindo as features e separando em 4 classes
        %%%%%%%%%
        %extraindo features dos dados brutos
        a1 = [];
        a2 = [];
        a3 = [];
        a4 = [];
        DadosBrutos = DadosBrutos';
        for i=1:length(rot_dados)
          if rot_dados(i)==1
            %a1 = [Rotulo(:,i) a1];
            [m,n] = size(a1);
            a1(:,n+1) = DadosBrutos(:,i);
          elseif rot_dados(i)==2
            %a2 = [Rotulo(:,i) a2];
            [m,n] = size(a2);
            a2(:,n+1) = DadosBrutos(:,i);
          elseif rot_dados(i)==3
            %a3 = [Rotulo(:,i) a3];
            [m,n] = size(a3);
            a3(:,n+1) = DadosBrutos(:,i);
          elseif rot_dados(i)==4
            %a4 = [Rotulo(:,i) a4];
            [m,n] = size(a4);
            a4(:,n+1) = DadosBrutos(:,i);
          end
        end
        %features extraidas
        %PRONTO PARA COME�AR A TREINAR O MATERIAL

        b = filtro_kaiser_0a20;
        b = b.Numerator;
        a = 1;
        for j=1:length(a1(1,:))
            a1(:,j) = (filter(b,a,a1(:,j)));
            a2(:,j) = (filter(b,a,a2(:,j)));
            a3(:,j) = (filter(b,a,a3(:,j)));
            a4(:,j) = (filter(b,a,a4(:,j)));
        end
        %plotando grafico com a media dos sinais.
        %a11 = sum(a1,2)/1800;
        %a22 = sum(a2,2)/1800;
        %a33 = sum(a3,2)/1800;
        %a44 = sum(a4,2)/1800;
        %plot(a11)
        %hold on 
        %plot(a22,'r');
        %plot(a33,'k');
        %plot(a44,'g');
        %legend('a1','a2','a3','a4')
        %title('M�dia dos sinais EEG e suas respectivas classes')
        %xlabel('Amostras')
        %ylabel('Tens�o')
        %
        max = 1800; %escolha da quantidade total de amostras
        r = randperm(max,1700);
        p = setdiff(1:max,r);
        %algoritmo para treinar amostras com taxa de treino r/p (70% 30%)

        %[val_class,spa_val_class,D1,filters,qda,lossqda] = ...
        %   treina_multicsp_error(a1,a2,a3,a4,r,p,1e-3,max,@mod_junto,@OMPerr);

        %[val_class,spa_val_class,D1,filters,qda,lossqda] = ...
        %    treina_sem_dic(a1,a2,a3,a4,r,p,1e-3,max,@fILSDLA,@OMPerr2);

        %[val_class,spa_val_class,D1,filters,qda,lossqda] = ...
        %   treina_so_dic(a1,a2,a3,a4,r,p,1e-3,max,@fRLSDLA,@OMPerr);
        
        %[val_class,spa_val_class,D1,filters,qda,lossqda] = ...
        %   treina_multicsp_selec(a1,a2,a3,a4,r,p,1e-3,max,str2func(func{e}),@OMPerr);
       
        [val_class,spa_val_class,spa_val_class2,D1,filters,qda,lossqda] = ...
           treina_so_dic_selec(a1,a2,a3,a4,r,p,1e-3,max,str2func(func{e}),@OMPerr);
       
        loss(ii-2) = lossqda;
        %verificando erro de cada canal (probabilidade de criamos um filtro
        %espacial
        canais_teste = rem(p,25); %sao 25 canais por enquanto
        canais_teste = [canais_teste canais_teste canais_teste canais_teste];
        multiplicador = 0;
        for class=1:1:4
            canais = spa_val_class2(:,multiplicador*max+p);
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
        resultados_preliminares{ii-2} = canais_teste(:,find(canais_teste(2,:)==0));
        %salvando variaveis.
        save(strcat('D:\OneDrive\Sparse Signals\Vetores Esparsos\csp_files\loss_so_dic_selec_',func{e},'.mat'),'loss','resultados_preliminares');
    end
    fprintf('trocando de algoritmo');
end