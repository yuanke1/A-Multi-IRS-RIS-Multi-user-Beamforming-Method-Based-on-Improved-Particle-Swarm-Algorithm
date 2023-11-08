function H = generate_channel(Nt, Nr, L)

AOD = pi*rand(L, 2) - pi/2;  %-2/pi~2/pi
AOA = pi*rand(L, 2) - pi/2;  %-2/pi~2/pi
alpha(1) = 1; % gain of the LoS
alpha(2:L) = 10^(-0.5)*(randn(1,L-1)+1i*randn(1,L-1))/sqrt(2);
H = zeros(Nr, Nt);
for l=1:1:L
    ar = array_response(AOA(L,1),AOA(L,2), Nr);
    at = array_response(AOD(L,1),AOD(L,2), Nt);
    H = H + sqrt(Nr * Nt)*alpha(l)*ar*at';
end


