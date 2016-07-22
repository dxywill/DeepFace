clear

fera_loc = 'D:\Datasets\fera\';

out_loc = './out_fera/';

if(~exist(out_loc, 'dir'))
    mkdir(out_loc);
end

%%
executable = '"../../x64/Release/FeatureExtraction.exe"';

fera_dirs = dir([fera_loc, 'au_train*']);

for f1=1:numel(fera_dirs)

    fera_dirs_level_2 = dir([fera_loc, fera_dirs(f1).name]);
    fera_dirs_level_2 = fera_dirs_level_2(3:end);
   
    parfor f2=1:numel(fera_dirs_level_2)

        vid_files = dir([fera_loc, fera_dirs(f1).name, '/', fera_dirs_level_2(f2).name, '/*.avi']);
        
        for v=1:numel(vid_files)

            command = [executable ' -asvid -q -no2Dfp -no3Dfp -noMparams -noPose -noGaze -au_static '];

            curr_vid = [fera_loc, fera_dirs(f1).name, '/', fera_dirs_level_2(f2).name, '/', vid_files(v).name];

            [~,name,~] = fileparts(curr_vid);
            output_file = [out_loc name '.au.txt'];

            command = cat(2, command, [' -f "' curr_vid '" -of "' output_file '"']);


            dos(command);
        end
    end
end

%%
addpath('./helpers/');

find_FERA2011;

[ labels_gt, valid_ids, filenames] = extract_FERA2011_labels(FERA2011_dir, all_recs, all_aus);
labels_gt = cat(1, labels_gt{:});

for i=1:numel(filenames)
    filenames{i} = filenames{i}(1:end-3);
end

%% Identifying which column IDs correspond to which AU
tab = readtable([out_loc, 'train_001.au.txt']);
column_names = tab.Properties.VariableNames;

% As there are both classes and intensities list and evaluate both of them
aus_pred_class = [];

inds_class_in_file = [];

for c=1:numel(column_names)
    if(strfind(column_names{c}, '_c') > 0)
        aus_pred_class = cat(1, aus_pred_class, int32(str2num(column_names{c}(3:end-2))));
        inds_class_in_file = cat(1, inds_class_in_file, c);
    end
end

%%
inds_au_class = zeros(size(all_aus));

for ind=1:numel(all_aus)  
    if(~isempty(find(aus_pred_class==all_aus(ind), 1)))
        inds_au_class(ind) = find(aus_pred_class==all_aus(ind));
    end
end

%%
preds_all_class = [];

for i=1:numel(filenames)
   
    fname = dir([out_loc, '/*', filenames{i}, '.au.txt']);
    fname = fname(1).name;
    
    preds = dlmread([out_loc '/' fname], ',', 1, 0);
    
    % Read all of the intensity AUs
    preds_class = preds(:, inds_class_in_file);
    
    preds_all_class = cat(1, preds_all_class, preds_class);
end

%%
f = fopen('results/FERA2011_res_class.txt', 'w');
au_res = [];
for au = 1:numel(all_aus)
    if(inds_au_class(au) ~= 0)

        tp = sum(labels_gt(:,au) == 1 & preds_all_class(:, inds_au_class(au)) == 1);
        fp = sum(labels_gt(:,au) == 0 & preds_all_class(:, inds_au_class(au)) == 1);
        fn = sum(labels_gt(:,au) == 1 & preds_all_class(:, inds_au_class(au)) == 0);
        tn = sum(labels_gt(:,au) == 0 & preds_all_class(:, inds_au_class(au)) == 0);

        precision = tp./(tp+fp);
        recall = tp./(tp+fn);

        f1 = 2 * precision .* recall ./ (precision + recall);

        fprintf(f, 'AU%d class, Precision - %.3f, Recall - %.3f, F1 - %.3f\n', all_aus(au), precision, recall, f1);
        au_res = cat(1, au_res, f1);
    end
    
end
fclose(f);