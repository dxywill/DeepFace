% Try out the smoothing
addpath('../training_code');

models = dir('mat_models/AU*intensity.mat');

CCCs_sm = zeros(numel(models), 8);
    
for i =1:numel(models)
   
    load(['mat_models/' models(i).name]);
    
    eval_ids_uq = unique(eval_ids)';
    cccs_all = [];
    
    spans = [1, 3, 5, 7, 9, 11, 13];
    cccs = [];
    for s = spans
        ccc = [];
        for e=eval_ids_uq    
            if(strcmp(dataset_ids{e}, 'Bosphorus') == 0)
                smoothed_model = smooth(predictions_all(eval_ids==e), s, 'moving');
                [ ~, ~, ~, ccc_c, ~, ~ ] = evaluate_regression_results( smoothed_model, valid_labels(eval_ids==e));
                ccc = cat(1,ccc, ccc_c);
            end
        end
        ccc = mean(ccc);
        cccs = cat(2, cccs, ccc);        
    end
    cccs_all = cat(1, cccs_all, cccs);
end