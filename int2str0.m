function str = int2str0(int, dig)
% _
% Convert integer to string of specified length
% FORMAT str = int2str0(int, dig)
% 
%     int - integer
%     dig - digits
% 
%     str - string
% 
% FORMAT str = int2str0(int, dig) converts integer int to string str using
% int2str and adds zeros at the left until the resulting string has a
% length of dig. Example: int2str0(42,5) = '00042'.
% 
% Author: Joram Soch, BCCN Berlin
% E-Mail: joram.soch@bccn-berlin.de
% Date  : 14/01/2016, 09:50


% Convert to string
%-------------------------------------------------------------------------%
str = int2str(int);

% Add zeros at the left
%-------------------------------------------------------------------------%
while length(str) < dig
    str = strcat('0',str);
end;