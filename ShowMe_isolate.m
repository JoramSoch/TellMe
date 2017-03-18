function ShowMe_isolate(map, regs)
% _
% ShowMe region isolation function
% FORMAT ShowMe_isolate(map, regs)
%     map  - an integer indicating which brain map to use
%     regs - a  1 x R vector of region indices for this atlas
% 
% FORMAT ShowMe_isolate(map, regs) identifies regions indexed by regs in
% brain atlas map (1 = Tal, 2 = AAL, 3 = BA) and isolates these regions
% into separate image files.
% 
% Further information:
%     help ShowMe_display
% 
% Exemplary usage:
%     TellMe_analysis(1,[1:1105]) -> requires ca. 2.746 GB of disk space!!!
%     TellMe_analysis(2,[1:116])
%     TellMe_analysis(3,[1:48])
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% Date  : 28/01/2016, 09:40


%=========================================================================%
% P R E P A R A T I O N                                                   %
%=========================================================================%

% Load TellMe configurations
%-------------------------------------------------------------------------%
load TellMe_config.mat          % home_dir
load TellMe_defaults.mat        % maps(1,2,3)

% Read input arguments if necessary
%-------------------------------------------------------------------------%
if nargin < 1 || isempty(map)
    map = spm_input('Brain map:',1,'b',{'Tal','AAL','BA'},[1 2 3]);
end;
if nargin < 2 || isempty(regs)
    regs = spm_input('Region indices:','+1','r','[1 2 3]');
end;

if ismember(map,[1 2 3])

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


%=========================================================================%
% S T O R A G E                                                           %
%=========================================================================%

% Get number of regions
%-------------------------------------------------------------------------%
num_voxs = numel(M);            % number of voxels
num_regs = max(M);              % number of regions
num_digs = ceil(log10(num_regs+1));

% Isolate all regions
%-------------------------------------------------------------------------%
fprintf('\n');
map_hdr.dt = [spm_type('uint8') spm_platform('bigend')];
for i = 1:numel(regs)
    % message
    fprintf('-> Isolating %s %d (%d out of %d) ... ', maps(map).unit, regs(i), i, numel(regs));
    if ismember(regs(i),[1:num_regs])
        % header
        reg_hdr = map_hdr;
        reg_hdr.fname   = strcat(home_dir,'/',map_str,'/',map_str,'_',int2str0(regs(i),num_digs),'.nii');
        reg_hdr.descrip = sprintf('%s %d', maps(map).unit, regs(i));
        % image
        reg_img = map_img;
        reg_img(reg_img~=regs(i)) = 0;
        reg_img(reg_img==regs(i)) = 1;
        % save
        spm_write_vol(reg_hdr,reg_img);
    end;
    % message
    fprintf('successful! \n');
end;
fprintf('\n');

end;