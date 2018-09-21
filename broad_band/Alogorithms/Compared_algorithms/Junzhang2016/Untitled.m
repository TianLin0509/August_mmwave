global H;
for i = 1:64
    H_equal(:,:,i) = obj.W_B(:,:,i)'*W_RF'*H(:,:,i)*V_RF*obj.V_B(:,:,i);
end

for i = 1:64
    X = H_equal(:,:,i);
    a(i) = X(2,2);
end
global H;
for i = 1:64
    H_equal(:,:,i) = obj.W_B(:,:,i)'*H(:,:,i)*obj.V_B(:,:,i);
end
