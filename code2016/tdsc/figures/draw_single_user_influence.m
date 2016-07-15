

% load 10-FMT results
  load fmtdata
% load MovieLens 100K results
% load mldata

% for 10fmt, let cutf = 5000; for movielens, let cutf = 50000
% cutf is the number of the differences (N)  fall into [-10^{-5},10^{-5}] selected for draw histogram.
% note that, N is very large, and the number of other differences is very small ( each bin less than 1000). Setting curtf = 5000 or 50000 does not change histogram's struture. 
cutf = 5000; 
mark_num = 5;
binn = 200;

[fax10,fbx10, fcx10] = filterdata(fd10,-0.00001,0.00001,cutf);
[fax30,fbx30, fcx30] = filterdata(fd30,-0.00001,0.00001,cutf);
[tax10,tbx10, tcx10] = filterdata(td10,-0.00001,0.00001,cutf);
[tax30,tbx30, tcx30] = filterdata(td30,-0.00001,0.00001,cutf);

[countf1, binf1] = hist(fcx10, binn);
[countf3, binf3] = hist(fcx30, binn);
[countt1, bint1] = hist(tcx10, binn);
[countt3, bint3] = hist(tcx30, binn);

figure
hold on;
box on
line_fewer_markers(binf1, countf1,mark_num+1,'r-*','linewidth',3,'MarkerSize',17);
line_fewer_markers(binf3, countf3,mark_num,'g:o','linewidth',3,'MarkerSize',15);
line_fewer_markers(bint1, countt1,mark_num,'b-d','linewidth',3,'MarkerSize',18);
line_fewer_markers(bint3, countt3,mark_num+1,'m-.s','linewidth',3,'MarkerSize',14);
grid on;
% Put up legend.
legend1 = sprintf('single friend influence (|F_u|=10, |T_u|=10)');
legend2 = sprintf('single friend influence (|F_u|=30, |T_u|=10)');
legend3 = sprintf('single stranger influence (|F_u|=10, |T_u|=10)');
legend4 = sprintf('single stranger influence (|F_u|=30, |T_u|=10)');
legend({legend1, legend2, legend3,legend4},'FontSize',24);
axis tight
set(gca,'FontSize',24);
ylabel('Frequency (\times 10^3)','FontSize',24)
xlabel('Difference','FontSize',24)
set(gca,'yticklabel',{'0' '1' '2' '3' '4' '5' '6' '7' '8', '9'},'FontSize',28);

