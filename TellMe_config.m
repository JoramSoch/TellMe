function TellMe_config
% _
% Setup of the TellMe toolbox
% FORMAT TellMe_config
% 
% FORMAT TellMe_config configures pathes for TellMe analysis.
% You need to have SPM installed in order to run TellMe config.
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% Date  : 14/01/2016, 12:35


% Get home directory
%-------------------------------------------------------------------------%
home_dir = pwd;
addpath(home_dir);

% Get anatomical template
%-------------------------------------------------------------------------%
temp_img = fullfile(spm('Dir'),'canonical','single_subj_T1.nii');

% Get favorite brain map
%-------------------------------------------------------------------------%
fav_map  = spm_input('Which is your favorite brain atlas?',1,'b',{'Talairach','AAL','Brodmann'},[1 2 3]);

% Save dir, map and template
%-------------------------------------------------------------------------%
save(fullfile(home_dir,'TellMe_config.mat'),'home_dir','temp_img','fav_map');

% Run TellMe defaults
%-------------------------------------------------------------------------%
cd(home_dir);
TellMe_defaults;