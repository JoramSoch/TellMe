function TellMe(varargin)
% _
% TellMe command-line function
% FORMAT TellMe map x y z ncr1 ncr2
%     map  - a string indicating which brain map to use
%     x    - a scalar representing the first  MNI coordinate
%     y    - a scalar representing the second MNI coordinate
%     z    - a scalar representing the third  MNI coordinate
%     ncr1 - the number of closest regions (by voxel coordinates) to show
%     ncr2 - the number of closest regions (by center coordinates) to show
% 
% (0) FORMAT TellMe   fetches x, y, z from the SPM results window, sets map
% to the selected favorite map (see TellMe_config), ncr1 = 10, ncr2 = 10
% and calls TellMe_analysis.
% 
% (1) FORMAT TellMe map   fetches x, y, z from the SPM results window, sets
% ncr1 = 10, ncr2 = 10 and calls TellMe_analysis.
% 
% (2) FORMAT TellMe map ncr1   fetches x, y, z from the SPM results window,
% sets ncr2 = 10 and and calls TellMe_analysis.
% 
% (3) FORMAT TellMe map ncr1 ncr2   fetches x, y, z from the SPM results
% window and calls TellMe_analysis.
% 
% (4) FORMAT TellMe map x y z   sets ncr1 = 10, ncr2 = 10 and calls
% TellMe_analysis.
% 
% (5) FORMAT TellMe map x y z ncr1   sets ncr2 = 10 and calls
% TellMe_analysis.
% 
% (6) FORMAT TellMe map x y z ncr1 ncr2   calls TellMe_analysis.
% 
% Further information:
%     help TellMe_analysis
% 
% Exemplary usage:
%     TellMe
%     TellMe Tal
%     TellMe Tal 5
%     TellMe Tal 10 15
%     TellMe Tal 0 0 0
%     TellMe Tal 0 0 0 20
%     TellMe Tal 0 0 0 10 10
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% Date  : 14/01/2016, 04:50 / 08/02/2022, 11:03


% 0-3 input arguments
%-------------------------------------------------------------------------%
if nargin <= 3                  % no xyz
    try
        hR = evalin('base','hReg');
    catch
        warning('No active SPM results window with MNI coordinates!')
        return
    end
end;

% 0 input arguments
%-------------------------------------------------------------------------%
if nargin == 0                  % nothing
    load TellMe_config.mat
    xyz = spm_XYZreg('GetCoords',hR);
    TellMe_analysis(fav_map, xyz', 10, 10);
end;

% 1 input argument
%-------------------------------------------------------------------------%
if nargin == 1                  % only map
    str = varargin{1};
    map = str2map(str);
    xyz = spm_XYZreg('GetCoords',hR);
    TellMe_analysis(map, xyz', 10, 10);
end;

% 2 input arguments
%-------------------------------------------------------------------------%
if nargin == 2                  % only map and ncr1
    str = varargin{1};
    map = str2map(str);
    xyz = spm_XYZreg('GetCoords',hR);
    ncr1 = str2num(varargin{2});
    TellMe_analysis(map, xyz', ncr1, 10);
end;

% 3 input arguments
%-------------------------------------------------------------------------%
if nargin == 3                  % only map, ncr1, ncr2
    str = varargin{1};
    map = str2map(str);
    xyz = spm_XYZreg('GetCoords',hR);
    ncr1 = str2num(varargin{2});
    ncr2 = str2num(varargin{3});
    TellMe_analysis(map, xyz', ncr1, ncr2);
end;

% 4 input arguments
%-------------------------------------------------------------------------%
if nargin == 4                  % only map, x, y, z
    str = varargin{1};
    map = str2map(str);
    xyz = [str2num(varargin{2}) str2num(varargin{3}) str2num(varargin{4})];
    TellMe_analysis(map, xyz, 10, 10);
end;

% 5 input arguments
%-------------------------------------------------------------------------%
if nargin == 5                  % map, x, y, z, ncr1
    str = varargin{1};
    map = str2map(str);
    xyz = [str2num(varargin{2}) str2num(varargin{3}) str2num(varargin{4})];
    ncr1 = str2num(varargin{5});
    TellMe_analysis(map, xyz, ncr1, 10);
end;

% 6 input arguments
%-------------------------------------------------------------------------%
if nargin == 6                  % map, x, y, z, ncr1, ncr2
    str = varargin{1};
    map = str2map(str);
    xyz = [str2num(varargin{2}) str2num(varargin{3}) str2num(varargin{4})];
    ncr1 = str2num(varargin{5});
    ncr2 = str2num(varargin{6});
    TellMe_analysis(map, xyz, ncr1, ncr2);
end;

% Function from map string to map number
%-------------------------------------------------------------------------%
function map_num = str2map(map_str)

switch map_str
    case 'Tal',  map_num = 1;
    case 'AAL',  map_num = 2;
    case 'AAL3', map_num = 3;
    case 'BA',   map_num = 4;
end;