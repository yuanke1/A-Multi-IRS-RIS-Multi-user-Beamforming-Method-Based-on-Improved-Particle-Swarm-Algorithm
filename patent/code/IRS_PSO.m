function [theta_return,global_max] = IRS_PSO()
%TCPSO完成对IRS优化
global Nr;
global L;
global num;
global mark_sumrate;

num=30;  %粒子群粒子数目
C_1_s=1;C_2_s=1;C_1_m=1;C_2_m=1;C_3_m=1;w_m=0.5; %更新参数
thetaP=zeros(Nr,L);

IRS_m_x=rand(Nr,L,num); %初始化master位置
IRS_m_v=rand(Nr,L,num); %初始化master速度
IRS_s_x=rand(Nr,L,num); %初始化slave位置
IRS_s_v=rand(Nr,L,num); %初始化slave速度
P_G=zeros(Nr,L,num);  %某次迭代的全局最优,复制num次
P_G_slave=zeros(Nr,L,num); %某次迭代slave的全局最优，复制num次
P_i_m=zeros(Nr,L,num); %记录每个master粒子自己的最优值
P_i_s=zeros(Nr,L,num); %记录每个slave粒子自己的最优值
max_m=zeros(num,1); %记录master粒子的历史最大值
max_s=zeros(num,1); %记录slave粒子的历史最大值

literation=20; %迭代次数
global_max=0;

mark_sumrate=[]; %记录每一次迭代的变化
mark_rank=[];

for i=1:literation
    %首先更新全局最优解
    max=0;
    for j=1:num
        if(user_rate(IRS_m_x(:,:,j))>max)
            max=user_rate(IRS_m_x(:,:,j));
            P_G=IRS_m_x(:,:,j);
        end
    end
    max_slave=0;
    for j=1:num
        if(user_rate(IRS_s_x(:,:,j))>max)
            max=user_rate(IRS_s_x(:,:,j));
            P_G=IRS_s_x(:,:,j);
        end
        if(user_rate(IRS_s_x(:,:,j))>max_slave)
            max_slave=user_rate(IRS_s_x(:,:,j));
            P_G_slave=IRS_s_x(:,:,j);
        end
    end
    
    for j=2:num
        P_G(:,:,j)=P_G(:,:,1);
        P_G_slave(:,:,j)=P_G_slave(:,:,1);
    end
    
    %然后更新每个粒子自己的历史最优解
    %首先更新master
    for j=1:num
        if(user_rate(IRS_m_x(:,:,j))>max_m(j))
            max_m(j)=user_rate(IRS_m_x(:,:,j));
            P_i_m(:,:,j)=IRS_m_x(:,:,j);
        end        
    end
    %然后更新slave
    for j=1:num
        if(user_rate(IRS_s_x(:,:,j))>max_s(j))
            max_s(j)=user_rate(IRS_s_x(:,:,j));
            P_i_m(:,:,j)=IRS_s_x(:,:,j);
        end        
    end
    
    r1=1;r2=1;r3=1; %生成系数
    C_1_m=exp(-i/literation);
    C_2_m=exp(-i/literation);
    C_3_m=exp(-i/literation);
    C_1_s=exp(-i/literation);
    C_1_s=exp(-i/literation);
    %更新master的速度
    IRS_m_v=w_m*IRS_m_v+C_1_m*r1*(P_i_m-IRS_m_x)+C_2_m*r2*(P_G-IRS_m_x)+C_3_m*r3*(P_G_slave-IRS_m_x);
    
    %更新slave速度
    IRS_s_v=C_1_s*r1*(P_i_s-IRS_s_x)+C_2_s*r2*(P_G-IRS_s_x);
    
    %更新master位置
    IRS_m_x=x_bound(IRS_m_x+IRS_m_v);
    %更新slave位置
    IRS_s_x=x_bound(IRS_s_x+IRS_m_v);
    
    %在每一次搜索结束后记录最优解
    if(user_rate(P_G(:,:,1))>global_max)
        global_max=user_rate(P_G(:,:,1));
        thetaP=P_G(:,:,1);
    end
    
    mark_sumrate=[mark_sumrate,global_max];
end
%最后把theta校正为标准形式返回
theta_return=zeros(Nr,Nr,L)+1i*zeros(Nr,Nr,L);

for i=1:L
    for j=1:Nr
        theta_return(j,j,i)=exp(1i*thetaP(j,i));
    end
end


axis_x=1:literation;
plot(axis_x,mark_sumrate,'-*');xlabel('迭代次数');ylabel('用户总速率');title('PSO算法解决IRS优化性能');

end


