function  mytoc(N_LOOP,t1)
t2 = clock;
myt=etime(t2,t1) ;
mym=fix(myt/60);
mys=myt-60*mym;
wholetime = N_LOOP/10*myt ;
wholeh=fix(wholetime/3600);
wholem=fix((wholetime-3600*wholeh)/60);
wholes=wholetime-wholeh*3600-wholem*60;
disp(['执行10次循环运行时间为：',num2str(mym),'分',num2str(mys),'秒']);
disp(['估计总运行时间为：',num2str(wholeh) '小时',num2str(wholem),'分',num2str(wholes),'秒']);
