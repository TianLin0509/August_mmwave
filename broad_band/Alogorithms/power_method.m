function eigenvec = power_method (A, n)

l = length(A);
eigenvec = complex(randn(l,1),randn(l,1));
eigenvec = eigenvec / norm(eigenvec);

for i = 1:n
    
    eigenvec = A * eigenvec ; 
    eigenvec = eigenvec/ norm(eigenvec);
    
end