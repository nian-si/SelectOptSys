% https://www.mathworks.com/help/matlab/creating_plots/specify-line-and-marker-appearance-in-plots.html
clear 
type = 2;
target_K = [128];
% target_K = 128;
if (type == 2)
    load('data/data_Queueing.mat');
    main_data = cor_rec;
    load('data/data_uniform_Queueing.mat');
    uniform_data = cor_rec;
    load('data/data_OCBA_Queueing.mat');
    OCBA_data = cor_rec;
    idx = 1:length(T_list);
elseif type ==1
    load('data/data_newsvendor.mat');
    main_data = cor_rec;
    load('data/data_uniform_newsvendor.mat');
    uniform_data = cor_rec;
    idx = 1:length(T_list);
else
    load('data/data_dose.mat');
    main_data = cor_rec;
    load('data/data_uniform_dose.mat');
    uniform_data = cor_rec;
    load('data/data_OCBA_dose.mat');
    OCBA_data = cor_rec;
    idx = 1:2:length(T_list);
    
end
if (target_K == 128)
    if(type == 3)
        load('data/data_128_dose.mat');
        main_data = cor_rec;
        load('data/data_uniform_128_dose.mat');
        uniform_data = cor_rec;
        load('data/data_OCBA_128_dose.mat');
        OCBA_data = cor_rec;
        idx = 1:2:length(T_list);
    end
    if (type == 2)
        load('data/data_Queueing_K_128.mat');
        main_data = cor_rec;
        load('data/data_uniform_Queueing_K_128.mat');
        uniform_data = cor_rec;
        load('data/data_OCBA_Queueing_K_128.mat');
        OCBA_data = cor_rec;
        idx = 1:length(T_list);
    end
    
end
for K_i = 1:length(K_list)
    figure

    plot(T_list(idx),main_data(idx,K_i),'-ok','LineWidth',3,'MarkerSize',4);

    hold on
    %plot(loss_data(:,1),loss_data(:,3),'s-','LineWidth',3,'MarkerSize',4);
    plot(T_list(idx),uniform_data(idx,K_i),'>--','LineWidth',3,'MarkerSize',4);
    if type ~= 1
        plot(T_list(idx),OCBA_data(idx,K_i),':d','LineWidth',3,'MarkerSize',4);
    end

    if( type == 1)
        legend({'SEO','Uniform'},'Location','southeast','interpreter','latex')
    elseif type == 2 
        legend({'SEO','Uniform','OCBA'},'Location','east','interpreter','latex')
    else
        legend({'SEO','Uniform','OCBA'},'Location','southeast','interpreter','latex')
    end
    xlabel('T','interpreter','latex')
    ylabel('Probability of Correct Selection')
    if (target_K ~= 128)
        if(type == 2)
            ylim([0.3,1]) 
        elseif type == 1
            ylim([0.5,1])     
        else
            ylim([0.1,1])
        end
    end
    set(gcf, 'position', [0 0 578 488]);
    set(gca,'fontsize',18,'fontname','Times');
    hold off
    saveas(gcf,strcat('pic/PTS_K=',num2str(K_list(K_i)),'_',type_name{type}),'epsc')
end