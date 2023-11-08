%初始参数
global Nb;  %基站天线数
global Nr;  %IRS
global Nu;  %用户天线数
global L;   %IRS数目
global K;   %用户数目
global KM_result;
global mark_sumrate;
global mark_rank;
Nb=64;Nr=4;Nu=1;L=3;K=16;

%初始化基站预编码矩阵w
global w;
w=zeros(Nb,1,K)+1i*zeros(Nb,1,K);
for i=1:K
    w(:,:,i)=rand(Nb,1)+1i*rand(Nb,1);
end    
    
%生成基站到IRS信道
global H;
H=zeros(Nr,Nb,L)+1i+zeros(Nr,Nb,L);
for i=1:L
    H(:,:,i)=generate_channel(Nb,Nr,1);
end

%初始化IRS相控矩阵
global theta;
theta=zeros(Nr,Nr,L)+1i*zeros(Nr,Nr,L);
for i=1:L
    for j=1:Nr
        for k=1:Nr
            if(j==k)
            tht=rand()*2*pi;  %角度随机生成
            theta(j,k,i)=exp(1i*tht);
            end
        end
    end
end

%生成IRS到用户信道
global h;
h=zeros(Nu,Nr,L,K)+1i*zeros(Nu,Nr,L,K);
for i=1:L
    for j=1:K
        h(:,:,i,j)=generate_channel(Nr,Nu,1);
    end
end
    
%生成KM算法权值矩阵W
W=zeros(K,K);
for i=1:K
    for j=1:K
        W(i,j)=norm(h(:,:,mod(i-1,L)+1,j)*theta(:,:,mod(i-1,L)+1)*H(:,:,mod(i-1,L)+1)*w(:,:,j),'fro');
    end
end
KM_result=KM(W);   %返回配对方案

theta=IRS_PSO();

y=[];
for i=1:1
    %生成KM算法权值矩阵W
    W=zeros(K,K);
    for i=1:K
        for j=1:K
            W(i,j)=norm(h(:,:,mod(i-1,L)+1,j)*theta(:,:,mod(i-1,L)+1)*H(:,:,mod(i-1,L)+1)*w(:,:,j),'fro');
        end
    end
    KM_result=KM(W);   %返回配对方案

    [theta,max]=IRS_PSO();
    y=[y,max];
end


x=1:30;
plot(x,y,'-*');



