function V_RF  = quantizeRF(V_RF, bit)

if nargin == 1
    bit = 4;
end

n = 2^bit;

[i,j] = size(V_RF);

for x = 1:i
    for y = 1:j
        v = V_RF(x,y);
        k = round(angle(v)/(2*pi/n));
        V_RF(x,y) = exp(1i*k*2*pi/n);
    end
end
