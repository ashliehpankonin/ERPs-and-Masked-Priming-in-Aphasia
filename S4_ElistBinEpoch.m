% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin August 2021
% Operates on individual subject data 
% This script loads the semi-continuous ICA-corrected EEG data file,
% creates an Event List containing a record of all event codes and their
% timing, assigns events to bins using Binlister, epochs the EEG, and
% performs baseline correction.

close all; clearvars;

% Location of the main study directory 
% This method of specifying the study directory only works if you run the
% script; for running individual lines of code, replace the study directory
% with the path on your computer, e.g.: DIR =
% /Users/KappenmanLab/ERP_CORE/N400
%DIR = fileparts(fileparts(mfilename('fullpath'))); 
DIR = '/Volumes/Life Support/EMPIA/Participant EEG Data';

% Location of the folder that contains this script and any associated
% processing files 
% This method of specifying the current file path only works if you run the
% script; for running individual lines of code, replace the current file
% path with the path on your computer, e.g.: Current_File_Path =
% /Users/KappenmanLab/ERP_CORE/N400/EEG_ERP_Processing
%Current_File_Path = fileparts(mfilename('fullpath'));
Current_File_Path = '/Volumes/Life Support/EMPIA/Participant EEG Data';

%List of subjects to process, based on the name of the folder that contains
%that subject's data
SUB = {'a304'};	

% Subjects to prep: all subjects prepped 8/12/21

% Prepped subjects:'a302', 'a304' 'a305', 'a307', 'a308','a311', 'a312',
% 'a314','a315', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323', 't104',
% 't105','t106', 't109', 't111' 't113', 't115', 't117','t20',
% 't121','t122', 't123', 't124' 't125', 't128', 't130', 't133', 'a309',
% 'a306', 'a303','t119','a301'

% Prepped subjects (_trimmed):  'a303', 'a301', 'a304', 'a306', 'a308','a311' (11/3/21)
% Prepped subjects (_cleanedforICA): 'a301', 'a303', 'a304', 'a306','a308', 'a311' (11/3/21)

%**********************************************************************************************************************************************************************

% Loop through each subject listed in SUB
for i = 1:length(SUB)

    % Open EEGLAB and ERPLAB Toolboxes
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
    % Define subject path based on study directory and subject ID of current
    % subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Load the semi-continuous ICA-corrected EEG data file in .set EEGLAB
    % file format
    EEG = pop_loadset( 'filename', [SUB{i} '_interp.set'], 'filepath', Subject_Path);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0, 'setname', [SUB{i} '_interp'], 'gui', 'off'); 

    % Create EEG Event List containing a record of all event codes and
    % their timing
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', [Subject_Path SUB{i} '_Eventlist.txt'] ); 
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '_elist'], 'savenew', [Subject_Path SUB{i} '_elist.set'], 'gui', 'off');

    % Assign events to bins with Binlister; an individual trial may be
    % assigned to more than one bin (bin assignments can be reviewed in
    % each subject's _Eventlist_Bins.txt file)
    EEG = pop_loadset( 'filename', [SUB{i} '_elist.set'], 'filepath', Subject_Path);
    EEG  = pop_binlister( EEG , 'BDF', [Current_File_Path filesep 'EMPIA_binlist_corrected.txt'], 'ExportEL', [Subject_Path SUB{i} '_Eventlist_Bins.txt'], 'IndexEL', 1, 'SendEL2', 'EEG&Text', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', [SUB{i} '_bins'], 'savenew', [Subject_Path SUB{i} '_bins.set'], 'gui', 'off'); 

    %Epoch the EEG into 1280ms segments time-locked to the response (from
    %-100 ms to 1180 ms) and perform baseline correction using the average
    %activity from -100 ms to 0 ms
    EEG = pop_epochbin( EEG , [-100.0  1180.0],  [-100.0  0.0]);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3 , 'setname', [SUB{i} '_epoch'], 'savenew', [Subject_Path SUB{i} '_epoch.set'], 'gui', 'off'); 
    close all;
    
%End subject loop
end

%**********************************************************************************************************************************************************************
