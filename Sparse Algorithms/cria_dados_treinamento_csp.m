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
        %processo é:
        % ~500 amostras fixation cross
        % ~250 amostras Cue
        % ~750 amostras Motor imagery
        % ~500 amostras Break
        % 2000 amostras Total
        tempo = 1/250; %s
        tempo_total = 2; %s
        amostras = 2/tempo; %numero de amostras
        %tenho que pegar as amostras depois de 3,5 segundos
        %então tenho que esperar:
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
        %PRONTO PARA COMEÇAR A TREINAR O MATERIAL

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
        %title('Média dos sinais EEG e suas respectivas classes')
        %xlabel('Amostras')
        %ylabel('Tensão')
        %
        max = 1800; %escolha da quantidade total de amostras
        r = randperm(max,1400);
        p = setdiff(1:max,r);
        %algoritmo para treinar amostras com taxa de treino r/p (70% 30%)


    %     [val_class,spa_val_class,qda, ... 
    %         lossqda,D1] = treina_csp_error(a1,a2,r,p,1e-3,max,@fILSDLA,@OMPerr);
    %     loss(ii-2,1) = lossqda;
    %     resultados_preliminares{ii-2,1} = prob_filtro(spa_val_class,qda,max,p);
    %     [val_class,spa_val_class,qda, ... 
    %         lossqda,D1] = treina_csp_error(a1,a3,r,p,1e-3,max,@fILSDLA,@OMPerr);
    %     loss(ii-2,2) = lossqda;
    %     resultados_preliminares{ii-2,2} = prob_filtro(spa_val_class,qda,max,p)
    %     [val_class,spa_val_class,qda, ... 
    %         lossqda,D1] = treina_csp_error(a1,a4,r,p,1e-3,max,@fILSDLA,@OMPerr);
    %     loss(ii-2,3) = lossqda;
    %     resultados_preliminares{ii-2,3} = prob_filtro(spa_val_class,qda,max,p);
    %     [val_class,spa_val_class,qda, ... 
    %         lossqda,D1] = treina_csp_error(a2,a3,r,p,1e-3,max,@fILSDLA,@OMPerr);
    %     loss(ii-2,4) = lossqda;
    %     resultados_preliminares{ii-2,4} = prob_filtro(spa_val_class,qda,max,p);
    %     [val_class,spa_val_class,qda, ... 
    %         lossqda,D1] = treina_csp_error(a2,a4,r,p,1e-3,max,@fILSDLA,@OMPerr);
    %     loss(ii-2,5) = lossqda;
    %     resultados_preliminares{ii-2,5} = prob_filtro(spa_val_class,qda,max,p);
    %     [val_class,spa_val_class,qda, ... 
    %         lossqda,D1] = treina_csp_error(a3,a4,r,p,1e-3,max,@fILSDLA,@OMPerr);
    %     loss(ii-2,6) = lossqda;
    %     resultados_preliminares{ii-2,6} = prob_filtro(spa_val_class,qda,max,p);

    %     [val_class,spa_val_class,qda, ... 
    %         lossqda,D1] = treina_error_duo(a1,a2,r,p,1e-3,max,@fODL2,@OMPerr);
    %     loss(ii-2,1) = lossqda;
    %     resultados_preliminares{ii-2,1} = prob_filtro(spa_val_class,qda,max,p);
    %     [val_class,spa_val_class,qda, ... 
    %         lossqda,D1] = treina_error_duo(a1,a3,r,p,1e-3,max,@fODL2,@OMPerr);
    %     loss(ii-2,2) = lossqda;
    %     resultados_preliminares{ii-2,2} = prob_filtro(spa_val_class,qda,max,p)
    %     [val_class,spa_val_class,qda, ... 
    %         lossqda,D1] = treina_error_duo(a1,a4,r,p,1e-3,max,@fODL2,@OMPerr);
    %     loss(ii-2,3) = lossqda;
    %     resultados_preliminares{ii-2,3} = prob_filtro(spa_val_class,qda,max,p);
    %     [val_class,spa_val_class,qda, ... 
    %         lossqda,D1] = treina_error_duo(a2,a3,r,p,1e-3,max,@fODL2,@OMPerr);
    %     loss(ii-2,4) = lossqda;
    %     resultados_preliminares{ii-2,4} = prob_filtro(spa_val_class,qda,max,p);
    %     [val_class,spa_val_class,qda, ... 
    %         lossqda,D1] = treina_error_duo(a2,a4,r,p,1e-3,max,@fODL2,@OMPerr);
    %     loss(ii-2,5) = lossqda;
    %     resultados_preliminares{ii-2,5} = prob_filtro(spa_val_class,qda,max,p);
    %     [val_class,spa_val_class,qda, ... 
    %         lossqda,D1] = treina_error_duo(a3,a4,r,p,1e-3,max,@fODL2,@OMPerr);
    %     loss(ii-2,6) = lossqda;
    %     resultados_preliminares{ii-2,6} = prob_filtro(spa_val_class,qda,max,p);

    %     [val_class,qda,lossqda,] = treina_error_duo_nocspdic(a1,a2,r,p,1e-3,max);
    %     loss(ii-2,1) = lossqda;
    %     resultados_preliminares{ii-2,1} = prob_filtro(val_class,qda,max,p);
    %     [val_class,qda,lossqda] = treina_error_duo_nocspdic(a1,a3,r,p,1e-3,max);
    %     loss(ii-2,2) = lossqda;
    %     resultados_preliminares{ii-2,2} = prob_filtro(val_class,qda,max,p);
    %     [val_class,qda,lossqda] = treina_error_duo_nocspdic(a1,a4,r,p,1e-3,max);
    %     loss(ii-2,3) = lossqda;
    %     resultados_preliminares{ii-2,3} = prob_filtro(val_class,qda,max,p);
    %     [val_class,qda,lossqda] = treina_error_duo_nocspdic(a2,a3,r,p,1e-3,max);
    %     loss(ii-2,4) = lossqda;
    %     resultados_preliminares{ii-2,4} = prob_filtro(val_class,qda,max,p);
    %     [val_class,qda,lossqda] = treina_error_duo_nocspdic(a2,a4,r,p,1e-3,max);
    %     loss(ii-2,5) = lossqda;
    %     resultados_preliminares{ii-2,5} = prob_filtro(val_class,qda,max,p);
    %     [val_class,qda,lossqda] = treina_error_duo_nocspdic(a3,a4,r,p,1e-3,max);
    %     loss(ii-2,6) = lossqda;
    %     resultados_preliminares{ii-2,6} = prob_filtro(val_class,qda,max,p);

        [val_class,qda,lossqda,] = treina_csp_solo_error(a1,a2,r,p,1e-3,max);
        loss(ii-2,1) = lossqda;
        %resultados_preliminares{ii-2,1} = prob_filtro(val_class,qda,max,p);
        [val_class,qda,lossqda] = treina_csp_solo_error(a1,a3,r,p,1e-3,max);
        loss(ii-2,2) = lossqda;
        %resultados_preliminares{ii-2,2} = prob_filtro(val_class,qda,max,p);
        [val_class,qda,lossqda] = treina_csp_solo_error(a1,a4,r,p,1e-3,max);
        loss(ii-2,3) = lossqda;
        %resultados_preliminares{ii-2,3} = prob_filtro(val_class,qda,max,p);
        [val_class,qda,lossqda] = treina_csp_solo_error(a2,a3,r,p,1e-3,max);
        loss(ii-2,4) = lossqda;
        %resultados_preliminares{ii-2,4} = prob_filtro(val_class,qda,max,p);
        [val_class,qda,lossqda] = treina_csp_solo_error(a2,a4,r,p,1e-3,max);
        loss(ii-2,5) = lossqda;
        %resultados_preliminares{ii-2,5} = prob_filtro(val_class,qda,max,p);
        [val_class,qda,lossqda] = treina_csp_solo_error(a3,a4,r,p,1e-3,max);
        loss(ii-2,6) = lossqda;
        %resultados_preliminares{ii-2,6} = prob_filtro(val_class,qda,max,p);
        %salvando variaveis.
        %save('D:\OneDrive\Sparse Signals\Vetores Esparsos\csp_files\loss_apenas_csp_duo_classes.mat','loss','resultados_preliminares')
    end
end