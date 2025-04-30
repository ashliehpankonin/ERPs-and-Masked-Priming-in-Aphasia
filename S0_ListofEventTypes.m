% Written by Ashlie Pankonin April 2021

% This script obtains a list of all the unique event codes (listed in
% EEG.event.type data structure) for a file.

% This script and the data files you want to check should be located in a 
% directory that is included in Matlab's search path.

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that houses your subject folders.
parentfolder = '/Volumes/verb/EMPIA/Participant EEG Data';

% List all the subject folders you want to loop through
subject_list = {'a306'};
% Subjects to check: checked all subjects on 4/8/2021
% Subjects that have been checked: 'a301', 'a302', 'a303', 'a304' 
% 'a305', 'a307', 'a308','a311', 'a312', 'a314', 'a315', 'a317', 'a318'
% 'a319', 'a320', 'a322', 'a323', 't104', 't105', 't106', 't109', 't111'
% 't113', 't115', 't117', 't119', 't120', 't121', 't122', 't123', 't124'
% 't125', 't128', 't130', 't133', 'a309', 'a306'

numsubjects = length(subject_list);
for s=1:numsubjects

    subject = subject_list{s};
    
    % Get subject info (same name as subjects.m function)
    subjectfolder = [parentfolder '/' subject '/'];
    
    % Start EEGLAB
    eeglab;
    
    % Load dataset
    EEG = pop_loadset('filename',[subject '_fullycropped_preproc.set'],'filepath',subjectfolder);
    
    % Create list of event codes for that subject
    tEvents=[EEG.event.type];
    
    % Add list of unique event codes for that subject to a master list of
    % unique event codes for each subject
    masterlist.(subject) = unique(tEvents);

end