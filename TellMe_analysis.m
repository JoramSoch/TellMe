function TellMe_analysis(map, xyz, ncr1, ncr2)
% _
% TellMe main analysis function
% FORMAT TellMe_analysis(map, xyz, ncr1, ncr2)
%     map  - an integer indicating which brain map to use
%     xyz  - a  1 x 3 vector of MNI coordinates in millimeters
%     ncr1 - the number of closest regions (by voxel coordinates) to show
%     ncr2 - the number of closest regions (by center coordinates) to show
% 
% FORMAT TellMe_analysis(map, xyz, ncr1, ncr2) identifies the region at
% position xyz (MNI in mm) in brain atlas map (1 = Tal, 2 = AAL, 3 = AAL3,
% 4 = BA) and lists ncr1 regions one voxel of which is closest and ncr2
% regions the centers of which are closest to xyz.
% 
% Further information:
%     help TellMe
% 
% Exemplary usage:
%     TellMe_analysis(1, [0 0 0], 10, 10)
%     TellMe_analysis(2, [7 41 16], 10, 0)
%     TellMe_analysis(3, [7 41 16], 0, 10)
%     TellMe_analysis(4, [-45 24 -9], 0, 0)
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% Date  : 14/01/2016, 05:15 / 08/02/2022, 11:14


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
if nargin < 2 || isempty(xyz)
    xyz = spm_input('MNI coordinates [mm]:','+1','r','[0 0 0]');
end;
if nargin < 3 || isempty(ncr1)
    ncr1 = spm_input('Number of closest regions (by voxel):','+1','i','10');
end;
if nargin < 4 || isempty(ncr2)
    ncr2 = spm_input('Number of closest regions (by center):','+1','i','10');
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


%=========================================================================%
% E S T I M A T I O N                                                     %
%=========================================================================%

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

% Determine target region
%-------------------------------------------------------------------------%
tar_vox = round(map_orig + xyz./map_size);
if all(tar_vox > [0 0 0]) && all(tar_vox < map_dims)
    tar_reg = map_img(tar_vox(1), tar_vox(2), tar_vox(3));
    if map == 4 && xyz(1) > 0, tar_reg = tar_reg + 48; end;
else
    tar_reg = 0;
end;

% Calculate voxel distances
%-------------------------------------------------------------------------%
if ncr1 > 0
    vox_dist = [[1:num_voxs]' zeros(num_voxs,1)];
    vox_dist(:,2) = sqrt(sum((XYZ' - repmat(xyz,[num_voxs 1])).^2,2));
    vox_dist = sortrows(vox_dist,2);
end;

% Calculate region distances
%-------------------------------------------------------------------------%
if ncr2 > 0
    reg_dist = [[1:num_regs]' zeros(num_regs,1)];
    reg_dist(:,2) = sqrt(sum((xyzc - repmat(xyz,[num_regs 1])).^2,2));
    reg_dist = sortrows(reg_dist,2);
end;


%=========================================================================%
% D I S P L A Y                                                           %
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
fprintf('   - target location: ');
fprintf('[%s %s %s] mm = ', num2str(xyz(1)), num2str(xyz(2)), num2str(xyz(3)));
fprintf('[%d %d %d] vx \n', tar_vox(1), tar_vox(2), tar_vox(3));

% Display target region
%-------------------------------------------------------------------------%
fprintf('\n');
if tar_reg == 0                 % no match
    an = ''; if ismember(map,[2 3]), an = 'n'; end;
    fprintf(2,'-> These coordinates do not refer to a%s %s: \n', an, map_unit);
    fprintf(2,'   %s - no region available for these coordinates. \n', int2str0(tar_reg,num_digs));
else                            % region found
    fprintf(2,'-> These coordinates refer to %s %d: \n', map_unit, nums(tar_reg));
    fprintf(2,'   %s - %s - %s - ', int2str0(nums(tar_reg),num_digs), abbr{tar_reg}, name{tar_reg});
    fprintf(2,'center: [%0.2f %0.2f %0.2f]. \n', xyzc(tar_reg,1), xyzc(tar_reg,2), xyzc(tar_reg,3));
end;

% Display voxel distances
%-------------------------------------------------------------------------%
if ncr1 > num_regs, ncr1 = num_regs; end;
if ncr1 > 0
    fprintf('\n-> These are the %s regions ONE VOXEL OF WHICH is closest to this point:\n', num2str(ncr1));
    reg_inds = []; j = 1;
    while numel(reg_inds) < ncr1
        vox_reg = M(vox_dist(j,1));
        if map == 4 && XYZ(1,vox_dist(j,1)) > 0, vox_reg = vox_reg + 48; end;
        if vox_reg ~= 0 && ~ismember(vox_reg,reg_inds)
            reg_inds = [reg_inds vox_reg];
            fprintf('   %s - %s - %s - ', int2str0(nums(vox_reg),num_digs), abbr{vox_reg}, name{vox_reg});
            fprintf('voxel: [%d %d %d] - ', XYZ(1,vox_dist(j,1)), XYZ(2,vox_dist(j,1)), XYZ(3,vox_dist(j,1)));
            fprintf('distance: %0.2f mm. \n', vox_dist(j,2));
        end;
        j = j + 1;
    end;
end;

% Display region distances
%-------------------------------------------------------------------------%
if ncr2 > num_regs, ncr2 = num_regs; end;
if ncr2 > 0
    fprintf('\n-> These are the %s regions THE CENTERS OF WHICH are closest to this point:\n', num2str(ncr2));
    for j = 1:ncr2
        reg_num = reg_dist(j,1);
        fprintf('   %s - %s - %s - ', int2str0(nums(reg_num),num_digs), abbr{reg_num}, name{reg_num});
        fprintf('center: [%0.2f %0.2f %0.2f] - ', xyzc(reg_num,1), xyzc(reg_num,2), xyzc(reg_num,3));
        fprintf('distance: %0.2f mm. \n', reg_dist(j,2));
    end;
end;
fprintf('\n');

end;