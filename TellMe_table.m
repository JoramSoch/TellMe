function TellMe_table(map, fname)
% _
% TellMe table export function
% FORMAT TellMe_table(map, fname)
%     map   - an integer indicating which brain map to use
%     fname - a string specifying the MS Excel output filename
% 
% FORMAT TellMe_table(map, fname) fetches the currently displayed table
% from the SPM results window, identifies the regions in brain atlas map
% (1 = Tal, 2 = AAL, 3 = AAL3, 4 = BA) belonging to the coordinates x, y, z
% in each table row and saves the results as an Excel file into fname.
% 
% Further information:
%     help TellMe
%     help TellMe_analysis
% 
% Exemplary usage:
%     TellMe_table(1, 'results_Tal.xls')
%     TellMe_table(2, 'results_AAL.xls')
%     TellMe_table(3, 'results_AAL3.xls')
%     TellMe_table(4, 'results_BA.xls')
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% Date  : 02/02/2022, 09:59 / 08/02/2022, 11:22


%=========================================================================%
% P R E P A R A T I O N                                                   %
%=========================================================================%

% Load TellMe configurations
%-------------------------------------------------------------------------%
load TellMe_config.mat          % home_dir
load TellMe_defaults.mat        % maps(1-4)

% Read input arguments if necessary
%-------------------------------------------------------------------------%
if nargin < 1 || isempty(map)
    map = spm_input('Brain map:',1,'b',{'Tal','AAL','AAL3','BA'},[1 2 3 4]);
end;
if nargin < 2 || isempty(fname)
    fname = spm_input('Output filename:','+1','s',sprintf('results_%s.xls', maps(map).name));
end;
try
    hR = evalin('base','hReg');
    xS = evalin('base','xSPM');
catch
    warning('No active SPM results window with results table!')
    return
end;

if ismember(map,[1 2 3 4])

% Assign brain map name
%-------------------------------------------------------------------------%
map_num = map;
map_str = maps(map).name;

% Read brain map image
%-------------------------------------------------------------------------%
filename = strcat(home_dir,'/',map_str,'/',map_str,'.nii');
map_hdr  = spm_vol(filename);
map_img  = spm_read_vols(map_hdr);
[M XYZ]  = spm_read_vols(map_hdr);
 M       = reshape(M,[1 prod(map_hdr.dim)]);

% Load brain map regions
%-------------------------------------------------------------------------%
filename = strcat(home_dir,'/',map_str,'/',map_str,'.mat');
load(filename);                 % nums, abbr, name, xyzc

% Get number of regions
%-------------------------------------------------------------------------%
num_voxs = numel(M);            % number of voxels
num_regs = numel(nums);         % number of regions
num_digs = ceil(log10(num_regs+1));

% Get map parameters
%-------------------------------------------------------------------------%
map_dims = maps(map).dims;      % brain map dimensions [vx]
map_orig = maps(map).orig;      % brain map origin [vx]
map_size = maps(map).size;      % brain map size [mm/vx]
map_unit = maps(map).unit;      % brain map unit name


%=========================================================================%
% E S T I M A T I O N                                                     %
%=========================================================================%

% Save results into Excel table
%-------------------------------------------------------------------------%
TabDat = spm_list('List',xS,hR);
spm_list('XLSList',TabDat,fname);

% Read results from Excel table
%-------------------------------------------------------------------------%
[num, txt, raw] = xlsread(fname);
clear num txt

% Identify coordinate columns
%-------------------------------------------------------------------------%
cols = [];
for i = 1:size(raw,1)
    for j = 1:size(raw,2)
        if strcmp(raw{i,j},'x,y,z {mm}')
            if isempty(cols)
                cols =  j;
                rows = [(i+1):size(raw,1)];
            else
                cols = [cols, j];
            end;
        end;
    end;
end;

% Prepare final results table
%-------------------------------------------------------------------------%
raw = [raw, cell(size(raw,1),3)];
raw(rows(1)-1,end-2:end) = {map_unit, 'Abbreviation', 'Name'};

% Label all coordinate rows
%-------------------------------------------------------------------------%
num_rows = 0;
for i = rows
    % get coordinates
    xyz = cell2mat(raw(i,cols));
    % find target region
    if ~isempty(xyz)
        tar_vox = round(map_orig + xyz./map_size);
        if all(tar_vox > [0 0 0]) && all(tar_vox < map_dims)
            tar_reg = map_img(tar_vox(1), tar_vox(2), tar_vox(3));
            if map == 4 && xyz(1) > 0, tar_reg = tar_reg + 48; end;
        else
            tar_reg = 0;
        end;
    end;
    % store region name
    if ~isempty(xyz)
        if tar_reg ~= 0
            num_rows     = num_rows + 1;
            raw{i,end-2} = int2str0(nums(tar_reg),num_digs);
            raw{i,end-1} = abbr{tar_reg};
            raw{i,end  } = name{tar_reg};
        end;
    end;
end;


%=========================================================================%
% S A V E   R E S U L T S                                                 %
%=========================================================================%

% Display input parameters
%-------------------------------------------------------------------------%
fprintf('\n');
fprintf('-> Your input parameters: \n');
fprintf('   - selected map: ');
switch map
    case 1, fprintf('Tal = Talairach atlas label data image');
    case 2, fprintf('AAL = Automated Anatomical Labeling');
    case 3, fprintf('AAL3 = Automated Anatomical Labeling, Version 3');
    case 4, fprintf('BA = Brodmann area classification');
end;
fprintf('\n');
fprintf('   - output filename: %s.\n', fname);


% Display target regions
%-------------------------------------------------------------------------%
fprintf('\n');
fprintf('-> %d target regions successfully identified and written to disk.\n', num_rows);
fprintf('\n');

% Save final results table
%-------------------------------------------------------------------------%
xlswrite(fname, raw);

end;