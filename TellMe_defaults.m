function TellMe_defaults
% _
% Defaults for the TellMe toolbox
% FORMAT TellMe_defaults
% 
% FORMAT TellMe_defaults sets default variables for TellMe analysis.
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% Date  : 14/01/2016, 01:30


% Set map parameters (1): Tal
%-------------------------------------------------------------------------%
maps(1).name = 'Tal';
maps(1).dims = [141 172 110];
maps(1).orig = [ 71 103  43];
maps(1).size = [  1   1   1];
maps(1).unit = 'Talairach label';

% Set map parameters (2): AAL
%-------------------------------------------------------------------------%
maps(2).name = 'AAL';
maps(2).dims = [181 217 181];
maps(2).orig = [ 91 126  72];
maps(2).size = [  1   1   1];
maps(2).unit = 'AAL region';

% Set map parameters (3): BA
%-------------------------------------------------------------------------%
maps(3).name = 'BA';
maps(3).dims = [181 217 181];
maps(3).orig = [ 91 126  72];
maps(3).size = [  1   1   1];
maps(3).unit = 'Brodmann area';

% Save map parameters
%-------------------------------------------------------------------------%
save('TellMe_defaults.mat','maps');