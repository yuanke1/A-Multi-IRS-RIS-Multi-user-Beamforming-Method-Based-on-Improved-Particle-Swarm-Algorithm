function [sum_rate] = user_rate(IRS)
%输入为IRS矩阵
%计算所有用户总速率
global H;
global h;
global w;
global KM_result;
global K;
global L;


theta_h=IRS_to_theta(IRS);

sum_rate=0;
for p=1:K

    irs=1;
    numerator=0;
    for i=1:K    %哪个irs服务这个用户
        if(KM_result(i)==p)
            irs=i;break;
        end
    end
    irs=mod(irs-1,L)+1;
    numerator=norm(h(:,:,irs,p)*theta_h(:,:,irs)*H(:,:,irs)*w(:,:,p),'fro');
    
    denominator=0;
    for i=1:K
        for j=1:L
            if(i~=p)
                denominator=denominator+norm(h(:,:,j,i)*theta_h(:,:,j)*H(:,:,j)*w(:,:,i),'fro');
            end
        end
    end
    %denominator=denominator+normrnd(0,1); %加噪声
    rate=100*log2(1+numerator/denominator);
    sum_rate=sum_rate+rate;
end

end

