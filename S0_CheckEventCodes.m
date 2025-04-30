% Written by Ashlie Pankonin March 2021

% With BIOSEMI EEG data, there is sometimes an overlap of a stimulus 
% presentation and a subject's response. BIOSEMI marks these occurrences
% with improbable event codes (i.e., much larger than 255). This script 
% checks to see if there are any instances of overlap recorded in the EEG
% event codes (listed in EEG.event.type data structure).

% This script and the data files you want to check should be located in a 
% directory that is included in Matlab's search path.

% Create a text file to collect output in
fileID = fopen('/Volumes/verb/EMPIA/EventCodeCheck.txt','w');
fprintf(fileID, 'Event Code Check\n\n');

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that houses your subject folders.
parentfolder = '/Volumes/verb/EMPIA/Participant EEG Data';

% List all the subject folders you want to loop through
subject_list = {};
% Subjects to check: checked all subjects on 3/11/2021 - all are good
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
    EEG = pop_loadset('filename',[subject '_preproc.set'],'filepath',subjectfolder);
    
    % Create list of event codes
    tEvents=[EEG.event.type]';
    
    % Check for any event codes > 255 and provide status report
    fileID = fopen('/Volumes/verb/EMPIA/EventCodeCheck.txt','a');
    if max(tEvents)> 255
        fprintf(fileID,[ subject ' has overlapping stimulus and response codes! Please examine.\n'] );
        return;
    end
    fprintf(fileID, [ subject ' is good.\n' ] );
    fclose(fileID);
end

% Open text file and review contents
open '/Volumes/verb/EMPIA/EventCodeCheck.txt'