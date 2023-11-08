function [IRS] = x_bound(IRS)
%限制角度在0-2pi
global num;
global Nr;
global L;
for i=1:Nr
    for j=1:L
        for k=1:num
            if(IRS(i,j,k)>2*pi)
                IRS(i,j,k)=2*pi;
            end
            if(IRS(i,j,k)<0)
                IRS(i,j,k)=0.1;
            end
        end
    end
end

end

