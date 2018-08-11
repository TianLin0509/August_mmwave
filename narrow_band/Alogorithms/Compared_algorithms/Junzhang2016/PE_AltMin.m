function [ FRF,FBB ] = PE_AltMin( Fopt )

global  Ns Nrf; 
Nt = size(Fopt,1);
mynorm = [];
FRF = exp( sqrt(-1) * unifrnd (0,2*pi,Nt,Nrf) );
while (isempty(mynorm) || abs( mynorm(end) - mynorm(end-1) ) > 1e-4)
    [U,S,V] = svd(Fopt'*FRF);
    FBB = V(:,[1:Ns])*U';
   % mynorm = [mynorm, norm(Fopt * FBB' - FRF,'fro')^2];
     mynorm = [mynorm, norm(Fopt - FRF * FBB,'fro')];
    FRF = exp(1i * angle(Fopt * FBB'));
    mynorm = [mynorm, norm(Fopt - FRF * FBB,'fro')];
     %mynorm = [mynorm, norm(Fopt * FBB' - FRF,'fro')^2];
end
end