%% Clean up workspace
clear;
clc;
close all;  % Close all figures
beep off % turns off the beeping when there is an error 
%% Load data
% load all table
load('X_Alltable.mat')
png_prefix = 'ex_';
%% 
All_table.SI(:) = NaN; % make new column for SI measurements
n = num_batches;
for b = 1:n % for each batch
    b_indices = find(All_table.BatchID == BatchIDs(b)); % get all table indices of all trails in batch
    b_L = size(b_indices,1); % get no. trails in analysis
    for s = 1:b_L % for each sample in the batch
        % load manual data
        manual_data = sprintf([png_prefix char(BatchIDs(b)) num2str(s) '_discretized.mat']);
        load(manual_data, "trail_x", "trail_y");
        % get D_net (net displacement)
        D_last = size(trail_x);
        D_pts = [trail_x(1,1), trail_y(1,1); trail_x(D_last(1,1),1), trail_y(D_last(1,1),1)];
        D_net = All_table.Scale_ratio(b_indices(s))*pdist(D_pts);
        % divide by curvilinear distance (d_n)
        SI = D_net/All_table.TrailLength_mm(b_indices(s));
        All_table.SI(b_indices(s)) = SI;
    end
end
%% save new all table
save('X_Alltable.mat',"All_table","BatchIDs","Sample_Ls","num_batches","png_prefix")
%% Error messages (check if any issues)
errors = find(All_table.SI > 1);
if errors == []
    for e = 1:(size(errors)) % for each entry in errors
        batch = All_table.BatchID(errors(e));
        sample = All_table.SampleID(errors(e));
        msg = sprintf([char(batch) ' sample no.' char(sample) ' has an impossible SI value']);
        msg
    end
else
    msg = "All SI values are possible (SI<1)"
end
