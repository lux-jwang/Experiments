% draw mae reults with different alpha/(alpha+\beta)


ml10_m = [0.8195,0.8112,0.8074,0.8104,0.8157,0.829];
ml10_d = [0.0102,0.0096,0.0094,0.0088,0.0076,0.0091];

ml10_max = [0.8314,0.8216,0.819,0.8216,0.8294,0.8437];
ml10_min = [0.8042,0.7948,0.7924,0.7969,0.8084,0.817];

ml50_m = [0.7943,0.78,0.7693,0.7666,0.7658,0.7728];
ml50_d = [0.0125,0.0122,0.0127,0.0156,0.0176,0.0177];

ml50_max = [0.8083,0.796,0.7872,0.7857,0.7888,0.7985];
ml50_min = [0.775,0.7639,0.7518,0.7448,0.7426,0.7499];

ml100_m = [0.7815,0.7626,0.7492,0.7398,0.7371,0.7386];
ml100_d = [0.0102,0.0112,0.013,0.0131,0.0162,0.0184];

ml100_max = [0.7922,0.7737,0.765,0.7583,0.7616,0.764];
ml100_min = [0.7654,0.7449,0.7305,0.7221,0.7163,0.7151];


redat10_m = [0.6178,0.6197,0.6192,0.6299,0.6362,0.6388];
redat10_d = [0.008,0.0107,0.0107,0.0108,0.0129,0.0135];

redat10_max = [0.6316,0.6331,0.6394,0.6473,0.6542,0.6586];
redat10_min = [0.6081,0.6034,0.6096,0.6146,0.6226,0.6189];

redat50_m = [0.6066,0.6053,0.6095,0.6138,0.6199,0.6289];
redat50_d = [0.011,0.0111,0.0122,0.0117,0.0127,0.0142];

redat50_max = [0.623,0.6246,0.6297,0.6336,0.6414,0.6521];
redat50_min = [0.5912,0.5916,0.5931,0.5982,0.6048,0.6103];


figure
hold on
box on
grid on
plot(1:6,ml10_m,'b-o',1:6,ml50_m,'b--*',1:6,ml100_m,'b:>',1:6,redat10_m,'k-d',1:6,redat50_m,'k--^','LineWidth',3, 'MarkerSize',16)

ax = gca;
ax.XTick = 1:6;
set(gca,'xticklabel',{'0.5' '0.6' '0.7' '0.8' '0.9' '1.0'},'FontSize',28);
xlim([0.8,6.2]);
ylim([0.57,0.94]);

legend('MovieLens: 10 Friends','MovieLens: 50 Friends', 'MovieLens: 100 Friends','10-FMT: 10 Friends','10-FMT: 50 Friends','FontSize',28)
xlabel('\alpha/(\alpha+ \beta)','FontSize',28)
ylabel('MAE','FontSize',28)

plot(0.8:0.1:1.2,redat10_max(1)*ones(1,5),1.8:0.1:2.2,redat10_max(2)*ones(1,5),2.8:0.1:3.2,redat10_max(3)*ones(1,5),3.8:0.1:4.2,redat10_max(4)*ones(1,5),4.8:0.1:5.2,redat10_max(5)*ones(1,5),5.8:0.1:6.2,redat10_max(6)*ones(1,5),'Color','g','LineWidth',3);
plot(0.8:0.1:1.2,redat10_min(1)*ones(1,5),1.8:0.1:2.2,redat10_min(2)*ones(1,5),2.8:0.1:3.2,redat10_min(3)*ones(1,5),3.8:0.1:4.2,redat10_min(4)*ones(1,5),4.8:0.1:5.2,redat10_min(5)*ones(1,5),5.8:0.1:6.2,redat10_min(6)*ones(1,5),'Color','g','LineWidth',3);

plot(0.8:0.1:1.2,redat50_max(1)*ones(1,5),1.8:0.1:2.2,redat50_max(2)*ones(1,5),2.8:0.1:3.2,redat50_max(3)*ones(1,5),3.8:0.1:4.2,redat50_max(4)*ones(1,5),4.8:0.1:5.2,redat50_max(5)*ones(1,5),5.8:0.1:6.2,redat50_max(6)*ones(1,5),'Color','r','LineWidth',3);
plot(0.8:0.1:1.2,redat50_min(1)*ones(1,5),1.8:0.1:2.2,redat50_min(2)*ones(1,5),2.8:0.1:3.2,redat50_min(3)*ones(1,5),3.8:0.1:4.2,redat50_min(4)*ones(1,5),4.8:0.1:5.2,redat50_min(5)*ones(1,5),5.8:0.1:6.2,redat50_min(6)*ones(1,5),'Color','r','LineWidth',3);


plot(0.8:0.1:1.2,ml10_max(1)*ones(1,5),1.8:0.1:2.2,ml10_max(2)*ones(1,5),2.8:0.1:3.2,ml10_max(3)*ones(1,5),3.8:0.1:4.2,ml10_max(4)*ones(1,5),4.8:0.1:5.2,ml10_max(5)*ones(1,5),5.8:0.1:6.2,ml10_max(6)*ones(1,5),'Color','g','LineWidth',3);
plot(0.8:0.1:1.2,ml10_min(1)*ones(1,5),1.8:0.1:2.2,ml10_min(2)*ones(1,5),2.8:0.1:3.2,ml10_min(3)*ones(1,5),3.8:0.1:4.2,ml10_min(4)*ones(1,5),4.8:0.1:5.2,ml10_min(5)*ones(1,5),5.8:0.1:6.2,ml10_min(6)*ones(1,5),'Color','g','LineWidth',3);

plot(0.8:0.1:1.2,ml50_max(1)*ones(1,5),1.8:0.1:2.2,ml50_max(2)*ones(1,5),2.8:0.1:3.2,ml50_max(3)*ones(1,5),3.8:0.1:4.2,ml50_max(4)*ones(1,5),4.8:0.1:5.2,ml50_max(5)*ones(1,5),5.8:0.1:6.2,ml50_max(6)*ones(1,5),'Color','r','LineWidth',3);
plot(0.8:0.1:1.2,ml50_min(1)*ones(1,5),1.8:0.1:2.2,ml50_min(2)*ones(1,5),2.8:0.1:3.2,ml50_min(3)*ones(1,5),3.8:0.1:4.2,ml50_min(4)*ones(1,5),4.8:0.1:5.2,ml50_min(5)*ones(1,5),5.8:0.1:6.2,ml50_min(6)*ones(1,5),'Color','r','LineWidth',3);

plot(0.8:0.1:1.2,ml100_max(1)*ones(1,5),1.8:0.1:2.2,ml100_max(2)*ones(1,5),2.8:0.1:3.2,ml100_max(3)*ones(1,5),3.8:0.1:4.2,ml100_max(4)*ones(1,5),4.8:0.1:5.2,ml100_max(5)*ones(1,5),5.8:0.1:6.2,ml100_max(6)*ones(1,5),'Color','b','LineWidth',3);
plot(0.8:0.1:1.2,ml100_min(1)*ones(1,5),1.8:0.1:2.2,ml100_min(2)*ones(1,5),2.8:0.1:3.2,ml100_min(3)*ones(1,5),3.8:0.1:4.2,ml100_min(4)*ones(1,5),4.8:0.1:5.2,ml100_min(5)*ones(1,5),5.8:0.1:6.2,ml100_min(6)*ones(1,5),'Color','b','LineWidth',3);

hold off

draw_rectangle(ml10_m,ml10_d,'g');
draw_rectangle(ml100_m,ml100_d,'b');
draw_rectangle(ml50_m,ml50_d,'r');

draw_rectangle(redat10_m,redat10_d,'g');
draw_rectangle(redat50_m,redat50_d,'r');










