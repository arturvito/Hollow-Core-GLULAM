function plot_compliance(loop,Variable,y_lim2,beso)

hold on
plot(0:loop,Variable(:,1),'k','LineStyle','-','Marker','o')
xlim([0 length(Variable(:,1))])
% ylabel('Compliance')
% xlabel('Iterations')

yyaxis right
ylim([y_lim2(1) y_lim2(2)])
% ylabel('Volume Fraction')
set(gca,'ycolor','k') 

plot(0:loop,beso.history(:,2),'m','LineStyle','-','Marker','s')

legend('Compliance' , 'Volume Fraction','Location', 'Best')
grid on
box on
hold off




end