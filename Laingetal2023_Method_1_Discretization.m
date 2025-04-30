%% Set up
load('X_Alltable.mat') % load all table
% INPUT
b = 1; % Indicate what batch you're working on (ref.  column in BatchIDs string)
s = 1; % Indicate specimen number
scale = 10; % Enter scale (in mm)

png_prefix = 'ex_'; % Enter in text that preceeds all png files
folder = 'C:\FolderLocation'; % Where you would like specimen files to automatically save to
%% MANUAL DATA COLLECTION
close all % close all previous figures
b_indices = find(All_table.BatchID == BatchIDs(b)); % get all table indices of all trails in batch
s_index = b_indices(s); % get all table index for sample

All_table.Scale_mm(s_index) = scale; % populate all table w scale

% load png
img_name = sprintf([png_prefix char(BatchIDs(b)) num2str(s) '.png']);
hold on
fig_title = sprintf([char(BatchIDs(b)) ' sample no. ' num2str(s) ' scale = ' num2str(scale) ' mm']);
title(fig_title);
axis equal
img = imread(img_name);
img1 = flipdim(img, 2); % horz flip
img2 = flipdim(img1,1); % vert flip
img3 = flipdim(img2,2); % horz + vert flip
image(img3); % display image

% MANUAL-- ID scale
[scale_x, scale_y, button] = ginput(); % Click start & end for scale; ENTER when done
plot(scale_x, scale_y, ':*b', 'LineWidth', 2) % plots scale
s2 = [scale_x(1,1), scale_y(1,1); scale_x(2,1),scale_y(2,1)]; % make points
All_table.Scale_pix(s_index) = pdist(s2); % calculate scale in pixels, add to all table
All_table.Scale_ratio(s_index) = scale/All_table.Scale_pix(s_index); % calc scale ratio, add to all table

% MANUAL -- identify trail
[trail_x,trail_y,button] = ginput(); % Click start & end for trail; ENTER when done
plot(trail_x,trail_y, '-*g', 'LineWidth', 2) % plots trail
hold off

% Calculate trail length and add to all table
n = size(trail_x,1);
d_pixel = zeros(n-1,1);
for i = 1:n-1
    p2 = [trail_x(i+1), trail_y(i+1); trail_x(i),trail_y(i)];
    d = pdist(p2,'euclidean'); % same as doing pythagoras
    d_pixel(i) = d;
end
All_table.TrailLength_mm(s_index) = All_table.Scale_ratio(s_index)*sum(d_pixel,'all');

% Save discretized data 
filename_manual_data = sprintf([png_prefix char(BatchIDs(b)) num2str(s) '_discretized.mat']);
% Create full filename with the fullfile() function:
fullFileName = fullfile(folder, filename_manual_data);
save(fullFileName,'trail_x','trail_y');
save('X_Alltable.mat', "All_table","BatchIDs","num_batches")
close all
alert_txt = sprintf(['Data collection ended at ' char(BatchIDs(b)) ' sample no. ' num2str(s)]);
msg = msgbox(alert_txt,"End of discretization")

% After data collection (or re-collection), save file and continue loop
filename_manual_data = sprintf([png_prefix char(BatchIDs(b)) num2str(s) '_discretized.mat']);
% Create full filename with the fullfile() function:
fullFileName = fullfile(folder, filename_manual_data);
save(fullFileName,'trail_x','trail_y');
save('X_Alltable.mat', "All_table","BatchIDs","num_batches")
close all

% SAVE data in all table
save('X_Alltable.mat', "All_table","BatchIDs","num_batches")