for i = 1:length(YData2)
    semilogy(XData2{length(YData2)+1-i,1},YData2{length(YData2)+1-i,1},'LineWidth',2);
    hold on 
end