%%% Part 1: Extract coordinates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load BA map
filename = 'BA.nii';
map_hdr  = spm_vol(filename);
[M,XYZ]  = spm_read_vols(map_hdr);
 M       = reshape(M,[1 prod(map_hdr.dim)]);
 
% prepare centers
num_regs = max(M);
xyz_cent = zeros(num_regs,6);

% load BA names
filename = 'BA.xls';
[num, txt, raw] = xlsread(filename, 'Tabelle1', strcat('A1:C',num2str(num_regs)));

% prepare regions
reg_info = raw(:,3);
reg_nams = cell(num_regs,2);

% calculate centers
for i = 1:num_regs
    reg_nams{i,1} = sprintf('[left] %s',  reg_info{i,1});
    reg_nams{i,2} = sprintf('[right] %s', reg_info{i,1});
    if ~isempty(find(M==i))
        xyz_cent(i,1:3) = mean(XYZ(:,M==i & XYZ(1,:)<0),2)';
        xyz_cent(i,4:6) = mean(XYZ(:,M==i & XYZ(1,:)>0),2)';
    else
        xyz_cent(i,1:6) = [-150 -150 -150 -150 -150 -150];
    end;
end;

% save regions
xlswrite('BA.xls', [reg_nams(:,1); reg_nams(:,2)], 'Tabelle2', strcat('C1:C',num2str(2*num_regs)));

% save centers
xlswrite('BA.xls', [xyz_cent(:,1:3); xyz_cent(:,4:6)], 'Tabelle2', strcat('D1:F',num2str(2*num_regs)));


%%% Part 2: Save region infos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load BA data
[num, txt, raw] = xlsread('BA.xls', 'Tabelle2', strcat('A1:F',num2str(2*num_regs)));
nums = cell2mat(raw(:,1));      % region index
abbr = raw(:,2);                % region abbreviation
name = raw(:,3);                % region full name
xyzc = cell2mat(raw(:,4:6));    % center coordinates
clear num txt raw

% save regions
save('BA.mat', 'nums', 'abbr', 'name', 'xyzc');