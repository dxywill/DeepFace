function [result, prediction] = svr_test_linear(test_labels, test_samples, model)

    prediction = test_samples * model.w(1:end-1)' + model.w(end);
    
    prediction(~model.success) = 0;
    
    prediction(prediction<0)=0;
    prediction(prediction>5)=5;
    
    % using CCC as the evaluation metric
    result = corr(test_labels, prediction);
    [ ~, ~, ~, ccc, ~, ~ ] = evaluate_regression_results( prediction, test_labels ); 
    
    result = ccc;
    
    if(isnan(result))
        result = 0;
    end
    
end