%% Load data
% load all table
load('X_Alltable.mat')
% INPUT
b = 1; % Locality (Batch) ID identifier
seg_mult = [1,2,4,16]; % segment multipliers to be used
png_prefix = 'ex_'; % Enter in text that preceeds all png files
%%
% Divide into equidistant segments and save data to folder
for seg = seg_mult % x trail width segment distances (so from segdist = 1*w to 5*w)
    BatchIDs_L = size(BatchIDs,2);
    b_indices = find(All_table.BatchID == BatchIDs(b)); % get all table indices of all trails in batch
    b_L = size(b_indices,1); % get no. trails in analysis
    for s = 1:b_L % for each sample in the batch
        % load manual data
        manual_data = sprintf([png_prefix char(BatchIDs(b)) num2str(s) '_discretized.mat']);
        s_file = matfile(manual_data);
        % Convert to mm
        trail_x = s_file.trail_x*(All_table.Scale_ratio(b_indices(s)));
        trail_y = s_file.trail_y*(All_table.Scale_ratio(b_indices(s)));
        % Get equidistant coordinates along this line
        seg_dist = All_table.TrailWidth(b_indices(s))*seg;
        trail_L = All_table.TrailLength_mm(b_indices(s));
        s_ratio = All_table.Scale_ratio(b_indices(s));
        num_seg = seg_dist\trail_L ; % determine # of segments
        num_seg = round(num_seg);
        trail_equi_mm = interparc(num_seg,trail_x,trail_y,'spline');

        % save MaxT for this segment #
        MaxT = size(trail_equi_mm,1);

        % normalize data & populate matrix w it
        trail_norm_mm = zeros(MaxT,2); % preallocate
        trail_norm_mm(:,1) = (trail_equi_mm(:,1) - trail_equi_mm(1,1)); % norm x
        trail_norm_mm(:,2) = (trail_equi_mm(:,2) - trail_equi_mm(1,2)); % norm y
        trail_norm_mm(trail_norm_mm == 0) = NaN;
        trail_norm_mm(1,:) = 0;

        % save equidistant coordinates
        file_trail_equi = sprintf([png_prefix char(BatchIDs(b)) num2str(s) '_seg_' num2str(seg) '.mat']);
        folder = 'C:\Users\Brittany Laing\Documents\SCHOOL\PhD\Searching Data Collection\MethodsPaper\Example\ex_sample';
        % Create full filename with the fullfile() function:
        fullFileName = fullfile(folder, file_trail_equi);
        save(fullFileName,'trail_equi_mm','MaxT','trail_norm_mm');
    end
end