function  plot_patient_activity_zone(model)

plot(model.left.taxis,model.left.kC,'r',model.right.taxis,model.right.kC,'g' ...
    ,model.across.taxis,model.across.kC,'c',model.prepost.taxis,model.prepost.kC,...
    'm',model.phoneme_left.taxis,model.phoneme_left.kC,'k',...
    model.phoneme_right.taxis,model.phoneme_right.kC,'b','LineWidth',2)
hold on;
plot(model.left.taxis,model.left.kLo,'--r',model.left.taxis,model.left.kUp,'--r','LineWidth',1.5)
plot(model.right.taxis,model.right.kLo,'--g',model.right.taxis,model.right.kUp,'--g','LineWidth',1.5)
plot(model.across.taxis,model.across.kLo,'--c',model.across.taxis,model.across.kUp,'--c','LineWidth',1.5)
plot(model.prepost.taxis,model.prepost.kLo,'--m',model.prepost.taxis,model.prepost.kUp,'--m','LineWidth',1.5)
plot(model.phoneme_left.taxis,model.phoneme_left.kLo,'--k',model.phoneme_left.taxis,model.phoneme_left.kUp,'--k','LineWidth',1.5)
plot(model.phoneme_right.taxis,model.phoneme_right.kLo,'--c',model.phoneme_right.taxis,model.phoneme_right.kUp,'--c','LineWidth',1.5)

legend('Left','Right','Between','PrePost','Phoneme L','Phoneme R')
legend boxoff
ylim([-0.01 0.5])
title(model.source_session(1:17))
ylabel('Raw Coherence')
xlabel('Time (s)')
set(gca,'FontSize', 18)
box off

end

