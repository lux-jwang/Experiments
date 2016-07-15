

% draw pure single friend influence without stranger MovieLens

load pfml_s

pfml6 = pfml2;
pfml11 = pfml5;
pfml21 = pfml10;

cutf = 40000;
mark_num = 5;
binn = 200;

[fax6,fbx6, fcx6] = filterdata(pfml6,-0.00001,0.00001,cutf);
[fax11,fbx11, fcx11] = filterdata(pfml11,-0.00001,0.00001,cutf);
[tax21,tbx21, fcx21] = filterdata(pfml21,-0.00001,0.00001,cutf);
% [fax31,fbx31, fcx31] = filterdata(pfml31,-0.00001,0.00001,cutf);
% [fax41,fbx41, fcx41] = filterdata(pfml41,-0.00001,0.00001,cutf);
% [fax51,fbx51, fcx51] = filterdata(pfml51,-0.00001,0.00001,cutf);


[count6, bin6] = hist(fcx6, binn);
[count11, bin11] = hist(fcx11, binn);
[count21, bin21] = hist(fcx21, binn);
% [count31, bin31] = hist(fcx31, binn);
% [count41, bin41] = hist(fcx41, binn);
% [count51, bin51] = hist(fcx51, binn);

figure
hold on;
box on
line_fewer_markers(bin6, count6,mark_num,'r-*','linewidth',3,'MarkerSize',18);
line_fewer_markers(bin11, count11,mark_num,'g-.o','linewidth',2,'MarkerSize',15);
line_fewer_markers(bin21, count21,mark_num,'b--d','linewidth',2,'MarkerSize',17);
%line_fewer_markers(bin31, count31,mark_num+1,'g-.s','linewidth',2,'MarkerSize',14);
%line_fewer_markers(bin41, count41,mark_num+4,'c->','linewidth',2,'MarkerSize',17);
% line_fewer_markers(bin51, count51,mark_num+2,'b--^','linewidth',2,'MarkerSize',16);
%plot(binf1, countf1, 'r-','LineWidth',2);
% plot(binf3, countf3, 'g-','LineWidth',2);
% plot(bint1, countt1, 'b-','LineWidth',2);
% plot(bint3, countt3, 'm-','LineWidth',2);
grid on;
% Put up legend.
legend1 = sprintf('|F_u|=2');
legend2 = sprintf('|F_u|=5');
legend3 = sprintf('|F_u|=10');
% legend4 = sprintf('|F_u|=30');
% legend5 = sprintf('|F_u|=40');
% legend6 = sprintf('|F_u|=50');
legend({legend1,legend2 ,legend3 },'FontSize',28);
axis tight
set(gca,'FontSize',24);
ylabel('Frequency (\times 10^4)','FontSize',24)
xlabel('Difference','FontSize',24)
% set(gca,'yticklabel',{'0' '2' '4' '6' '8' '10' '12'},'FontSize',24);
set(gca,'yticklabel',{'0' '1' '2' '3' '4' '5' '6' },'FontSize',24);

