function  plot_patient_activity_zone(model)
figure;
plot(model.left.taxis,model.left.kC,'r',model.right.taxis,model.right.kC,'g',model.across.taxis,model.across.kC,'c','LineWidth',2)
hold on;
plot(model.left.taxis,model.left.kLo,'--r',model.left.taxis,model.left.kUp,'--r','LineWidth',1.5)
plot(model.right.taxis,model.right.kLo,'--g',model.right.taxis,model.right.kUp,'--g','LineWidth',1.5)
plot(model.across.taxis,model.across.kLo,'--c',model.across.taxis,model.across.kUp,'--c','LineWidth',1.5)
legend('Left','Right','Between')
legend boxoff
ylim([-0.01 0.5])
title(model.patient_name)
ylabel('Raw Coherence')
xlabel('Time (s)')
set(gca,'FontSize', 18)
box off

end

