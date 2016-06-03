% Test out smoothing
addpath('../training_code');

models = dir('mat_models/AU*');

F1s_sm = zeros(numel(models), 8);
    
for i =1:numel(models)
   
    load(['mat_models/' models(i).name]);
    
    F1_orig = compute_F1(valid_labels, predictions_all);
    F1s_sm(i, 1) = F1_orig;
    spans = [3, 5, 7, 9, 11, 13, 15];
    sp = 2;
    for s = spans
        pred_smooth = smooth(predictions_all, s, 'moving');
        pred_smooth(pred_smooth < 0.5) = 0;
        pred_smooth(pred_smooth >= 0.5) = 1;
        F1s_sm(i, sp) = compute_F1(valid_labels, pred_smooth);
        sp = sp + 1;
    end
end