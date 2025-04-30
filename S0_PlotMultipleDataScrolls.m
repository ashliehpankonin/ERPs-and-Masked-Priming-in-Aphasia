% Written by Ashlie Pankonin November 2021
% Operates on individual subject data
% This script loads the specified continuous EEG data files and plots the
% channel data scrolls

close all; clearvars;

% Location of the main study directory 
% This method of specifying the study directory only works if you run the
% script; for running individual lines of code, replace the study directory
% with the path on your computer, e.g.: DIR =
% /Users/KappenmanLab/ERP_CORE/N400
%DIR = fileparts(fileparts(mfilename('fullpath'))); 
DIR = '/Volumes/verb/EMPIA/Participant EEG Data';

% Location of the folder that contains this script and any associated
% processing files 
% This method of specifying the current file path only works if you run the
% script; for running individual lines of code, replace the current file
% path with the path on your computer, e.g.: Current_File_Path =
% /Users/KappenmanLab/ERP_CORE/N400/EEG_ERP_Processing
%Current_File_Path = fileparts(mfilename('fullpath'));
Current_File_Path = '/Volumes/verb/EMPIA/Participant EEG Data';

%List of subjects to process, based on the name of the folder that contains
%that subject's data
SUB = {'a308'};	

% Subjects to process:  

% 'a302', 'a304' 'a305', 'a307', 'a308','a311', 'a312',
% 'a314','a315', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323', 't104',
% 't105','t106', 't109', 't111' 't113', 't115', 't117','t20',
% 't121','t122', 't123', 't124' 't125', 't128', 't130', 't133', 'a309',
% 'a306', 'a303','t119', 

% Processed subjects: 'a301', 'a303', 'a304', 'a306', 'a308', 'a311' 

%*************************************************************************************************************************************

% Loop through each subject listed in SUB
for i = 1:length(SUB)

    % Open EEGLAB and ERPLAB Toolboxes
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

%     % Load the continuous EEG data file in .set EEGLAB file format
%     EEG = pop_loadset('filename',[SUB{i} '_preproc.set'], 'filepath', Subject_Path)
%     [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%     EEG = eeg_checkset( EEG );
%     pop_eegplot( EEG, 1, 1, 1);
%     eeglab redraw;

    % Load the continuous EEG data file in .set EEGLAB file format
    %EEG = pop_loadset('filename',[SUB{i} '_ICAR.set'], 'filepath', Subject_Path);
    EEG = pop_loadset('filename',[SUB{i} '_allAR.set'], 'filepath', Subject_Path);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = eeg_checkset( EEG );
    pop_eegplot( EEG, 1, 1, 1);
    eeglab redraw;

    % Load the continuous EEG data file in .set EEGLAB file format
    %EEG = pop_loadset('filename',[SUB{i} '_trimmed_ICAR_newmethod_interp.set'], 'filepath', Subject_Path);
    EEG = pop_loadset('filename',[SUB{i} '_trimmed_ICAR_newmethod_allAR.set'], 'filepath', Subject_Path);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = eeg_checkset( EEG );
    pop_eegplot( EEG, 1, 1, 1);
    eeglab redraw;

    % Load the continuous EEG data file in .set EEGLAB file format
    %EEG = pop_loadset('filename',[SUB{i} '_cleanedforICA_ICAR_newmethod_interp.set'], 'filepath', Subject_Path);
    EEG = pop_loadset('filename',[SUB{i} '_cleanedforICA_ICAR_newmethod_allAR.set'], 'filepath', Subject_Path);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = eeg_checkset( EEG );
    pop_eegplot( EEG, 1, 1, 1);
    eeglab redraw;
end