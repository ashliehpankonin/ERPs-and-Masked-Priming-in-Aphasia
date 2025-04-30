% Written by Ashlie Pankonin May 2024

% This script is simply the "for" loop set-up necessary for loading several
% ERP files

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that contains the data folders for all
% subjects.
DIR = '/Volumes/Life Support/EMPIA/Participant EEG Data';

% List all the subject folders you want to loop through (i.e., define your
% set of subjects)
SUB = {'a301', 'a302', 'a304' 'a305', 'a307', 'a308','a311','a312','a314','a315', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323','t104','t105','t106','t109', 't111' 't113', 't115', 't117', 't120','t121', 't122', 't123', 't124' 't125', 't128', 't130', 't133', 'a309','a306','a303','t119'};	

% Loop through each subject listed in SUB
for i = 1:length(SUB)

    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];     
            
    % Load ERP sets
    subjectsetname = [SUB{i} '_ERPs_CorrBinLabs.erp'];
    ERP = pop_loaderp ('filename', subjectsetname, 'filepath', Subject_Path,'overwrite','off','Warning','off','UpdateMainGui','on');
    
end %end of looping through all subjects
