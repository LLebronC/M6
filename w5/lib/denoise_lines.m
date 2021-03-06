function [lines, lines_short_denoised] = denoise_lines(lines, params)
% this script takes a list of line segments and performs denoising by:
% - dividing the set of lines into short and long lines
% - creating groups of lines according to orientation and finding
% alignments of line segment endpoints
% - adding the alignments founds to the list of lines
% - removing short lines from the list

% This program is written by Jose Lezama <jlezama@gmail.com> and
% distributed under the terms of the GPLv3 license.


%% threshold by line length
lengths = sqrt(sum([lines(:,3)-lines(:,1) lines(:,4)-lines(:,2)].^2,2));

% find lines that dont need denoising
z = find(lengths> params.LENGTH_THRESHOLD);


lines_large = lines(z,:);

lines(z,:)=[];

lines_short = lines;


angles_short = atan((lines_short(:,4)-lines_short(:,2))./(lines_short(:,3)-lines_short(:,1)));
angles_large = atan((lines_large(:,4)-lines_large(:,2))./(lines_large(:,3)-lines_large(:,1)));

angles_short = angles_short*180/pi;
angles_large = angles_large*180/pi;

all_detections = [];

for ANG = [0:30:180-30];
    angdiff_short = abs(angles_short-ANG);
    angdiff_large = abs(angles_large-ANG);
    
    angdiff_short = min(abs(angdiff_short),abs(angdiff_short-180));
    angdiff_large = min(abs(angdiff_large),abs(angdiff_large-180));
    
    z_short = find(angdiff_short<20);
    z_large = find(angdiff_large<20);
    
    params.ANG = ANG;
    
    if ~isempty(z_short)
        params.line_size = 'short';
        detections = find_endpoints_detections(lines_short, z_short, params);
        if ~isempty(detections)
            all_detections = [all_detections; detections(:,[1:4])];
        end
    end
    
    if ~isempty(z_large)
        params.line_size = 'large';
        detections = find_endpoints_detections(lines_large, z_large, params);
        if ~isempty(detections)
            all_detections = [all_detections; detections(:,[1:4])];
        end
    end
end
lines_short_denoised = all_detections;
lines_short_denoised(:,[2 4]) = params.H-lines_short_denoised(:,[2 4]);

lines = [lines_large; lines_short_denoised];
