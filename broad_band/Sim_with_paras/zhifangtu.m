x = EVD.ber;
x(x==0) = [];
y = MO.ber;
y(y==0) = [];
asi = [1 5 10 30];
hist(x,asi);
hold on 
hist(y,asi);