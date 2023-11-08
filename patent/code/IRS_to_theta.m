function [theta_h] = IRS_to_theta(IRS)
%把列向量的角度转换为IRS矩阵
global Nr;
global L;

theta_h=zeros(Nr,Nr,L)+1i*zeros(Nr,Nr,L);
for  i=1:L
    for j=1:Nr
        theta_h(j,j,i)=exp(1i*IRS(j,i));
    end
end

end

