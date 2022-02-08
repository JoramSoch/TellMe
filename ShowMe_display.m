function ShowMe_display(map, regs)
% _
% ShowMe region display function
% FORMAT ShowMe_display(map, regs)
%     map  - an integer indicating which brain map to use
%     regs - a  1 x R vector of region indices for this atlas
% 
% FORMAT ShowMe_display(map, regs) identifies regions indexed by regs in
% brain atlas map (1 = Tal, 2 = AAL, 3 = AAL 3, 4 = BA) and displays these
% regions using SPM's CheckReg function.
% 
% Further information:
%     help ShowMe
% 
% Exemplary usage:
%     ShowMe_display(1,[1:10])
%     ShowMe_display(2,[35 36 37 38])
%     ShowMe_display(3,[41 42 43 44])
%     ShowMe_display(4,[1:3 5,7 4,6])
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% Date  : 28/01/2016, 09:55 / 08/02/2022, 14:54


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
if nargin < 2 || isempty(regs)
    regs = spm_input('Region indices:','+1','r','[1 2 3]');
end;

if ismember(map,[1 2 3 4])

% Isolate regions
%-------------------------------------------------------------------------%
ShowMe_isolate(map, regs);


%=========================================================================%
% D I S P L A Y                                                           %
%=========================================================================%

% Get number of regions
%-------------------------------------------------------------------------%
num_regs = [1105 116 170 48];
num_regs = num_regs(map);
num_digs = ceil(log10(num_regs+1));
R = numel(regs);

% List regions
%-------------------------------------------------------------------------%
reg_imgs = cell(min([R 23]),1);
for i = 1:min([R 23])
    if ismember(regs(i),[1:num_regs])
        reg_imgs{i} = strcat(home_dir,'/',maps(map).name,'/',maps(map).name,'_',int2str0(regs(i),num_digs),'.nii');
    end;
end;
reg_imgs = [{temp_img}; reg_imgs];

% Call CheckReg
%-------------------------------------------------------------------------%
reg_imgs = char(reg_imgs);
spm_check_registration(reg_imgs);

end;