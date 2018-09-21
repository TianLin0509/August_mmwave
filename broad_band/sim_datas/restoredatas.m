h2 = openfig('ori_ber.fig','reuse'); % open figure
D2=get(gca,'Children'); %get the handle of the line object
XData2=get(D2,'XData'); %get the x data
YData2=get(D2,'YData'); %get the y data


A = YData2{1,1};