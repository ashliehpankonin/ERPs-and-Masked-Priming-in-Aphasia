% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin September 2021 
% Operates on individual subject data
% This script loads the averaged ERP waveform and creates low-pass filtered
% versions of the ERP waveforms.

close all; clearvars;

%Location of the main study directory, based on where this script is saved
%This method of specifying the study directory only works if you run the script; for running individual lines of code, replace the study directory with the path on your computer, e.g.: 
%DIR = /Users/KappenmanLab/ERP_CORE/N400
%DIR = fileparts(fileparts(mfilename('fullpath'))); 
DIR = '/Volumes/verb/EMPIA/Participant EEG Data';

%Location of the folder that contains this script and any associated processing files
%This method of specifying the current file path only works if you run the script; for running individual lines of code, replace the current file path with the path on your computer, e.g.: 
%Current_File_Path = /Users/KappenmanLab/ERP_CORE/N400/EEG_ERP_Processing
%Current_File_Path = fileparts(mfilename('fullpath'));
Current_File_Path = '/Volumes/verb/EMPIA/Participant EEG Data';

%List of subjects to process, based on the name of the folder that contains that subject's data
SUB = {'a301', 'a302', 'a304' 'a305', 'a307', 'a308','a311','a312','a314','a315', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323','t104','t105','t106', 't109', 't111' 't113', 't115', 't117', 't120', 't121', 't122', 't123', 't124' 't125', 't128', 't130', 't133', 'a309', 'a306','a303','t119'};
% Subjects to process: all subjects processed on 9/15/21

% Processed subjects: 'a301', 'a302', 'a304' 'a305', 'a307', 'a308','a311',
% 'a312','a314','a315', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323',
% 't104','t105','t106', 't109', 't111' 't113', 't115', 't117', 't120',
% 't121', 't122', 't123', 't124' 't125', 't128', 't130', 't133', 'a309',
% 'a306','a303','t119',

%**********************************************************************************************************************************************************************

% Create averaged ERP waveforms

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Loop through each subject listed in SUB
for i = 1:length(SUB)
  
    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Load the ERP waveforms in .erp ERPLAB file format
    ERP = pop_loaderp('filename', [SUB{i} '_ERPs_CorrBinLabs_12Hzlpfilt.erp'], 'filepath', Subject_Path);
    
    % Apply a low-pass filter (non-causal Butterworth impulse response function, 12 Hz half-amplitude cut-off, 40 dB/oct roll-off) to the ERP waveforms
    ERP = pop_filterp( ERP,  1:67 , 'Cutoff',  12, 'Design', 'butter', 'Filter', 'lowpass', 'Order',  2 );
    ERP = pop_savemyerp( ERP, 'erpname', [SUB{i} '_ERPs_CorrBinLabs_12Hzlpfilt'], 'filename', [Subject_Path SUB{i} '_ERPs_CorrBinLabs_12Hzlpfilt.erp']);

%End subject loop
end 

%*************************************************************************************************************************************