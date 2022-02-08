function ShowMe(varargin)
% _
% ShowMe command-line function
% FORMAT ShowMe map r1 r2 r3 ... rR
%     map  - a string indicating which brain map to use
%     rX   - up to R vectors of region indices for this atlas
% 
% (=2) FORMAT ShowMe map r1   displays region r1 from brain atlas map.
% 
% (>2) FORMAT ShowMe map r1 ... rR   displays indexed regions from map.
% 
% Further information:
%     help ShowMe_display
% 
% Exemplary usage:
%     ShowMe Tal 1:10
%     ShowMe AAL 35 36 37 38
%     ShowMe AAL3 41 42 43 44
%     ShowMe BA 1:3 [5,7] [4,6]
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% Date  : 28/01/2016, 10:00 / 08/02/2022, 14:52


% 0-1 input arguments
%-------------------------------------------------------------------------%
if nargin < 2                   % no map or rX
    warning('Not enough input arguments!')
end;

% 2+ input arguments
%-------------------------------------------------------------------------%
if nargin >= 2                  % map and rX
    str = varargin{1};
    map = str2map(str);
    regs = [];
    for i = 2:nargin
        regs = [regs str2num(varargin{i})];
    end;
    ShowMe_display(map, regs);
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