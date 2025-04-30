%% Decide on column number & order
ColNames = ["BatchID","SampleID","ColorID","TrailWidth","Scale_mm","Scale_pix","Scale_ratio","TrailLength_mm"];
ColTypes = {'string','string','double','double','double','double','double','double'};
No_Col = size(ColNames,2);
%% Create All table
% INPUT-- Batch IDs and max sample number
% ^this assumes all batches are numbered sequentially starting at 1
BatchIDs = {'A','B','C','D'}; % Batch IDs

% set up table
num_batches = size(BatchIDs,2); % calculate # of batches
All_table = table('Size',[0 No_Col],'VariableTypes',ColTypes); % make table
All_table.Properties.VariableNames = ColNames; % set column names
%% Save all
save('X_Alltable.mat',"All_table","BatchIDs","num_batches")
