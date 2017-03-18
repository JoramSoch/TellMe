%%% Part 1: Extract coordinates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load Tal map
filename = 'Tal.nii';
map_hdr  = spm_vol(filename);
[M,XYZ]  = spm_read_vols(map_hdr);
 M       = reshape(M,[1 prod(map_hdr.dim)]);

% prepare centers
num_regs = max(M);
xyz_abbr = cell(num_regs,1);
xyz_cent = zeros(num_regs,3);

% calculate centers
for i = 1:num_regs
    xyz_abbr{i} = strcat('Tal.',int2str0(i,4));
    if ~isempty(find(M==i))
        xyz_cent(i,:) = mean(XYZ(:,M==i),2)';    % weighted center
    else
        xyz_cent(i,:) = [-150 -150 -150];        % far left, back, down
    end;
end;

% save centers
xlswrite('Tal.xls', xyz_abbr, 'Tabelle2', strcat('B1:B',num2str(num_regs)));
xlswrite('Tal.xls', xyz_cent, 'Tabelle2', strcat('D1:F',num2str(num_regs)));


%%% Part 2: Save region infos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load Tal data
[num, txt, raw] = xlsread('Tal.xls', 'Tabelle2', strcat('A1:F',num2str(num_regs)));
nums = cell2mat(raw(:,1));      % region index
abbr = raw(:,2);                % region abbreviation
name = raw(:,3);                % region full name
xyzc = cell2mat(raw(:,4:6));    % center coordinates
clear num txt raw

% save regions
save('Tal.mat', 'nums', 'abbr', 'name', 'xyzc');