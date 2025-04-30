% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin August 2021
% Operates on individual subject data
% This script uses the individual subject averaged ERP waveforms to create
% grand average ERP waveforms across participants both with and without a
% low-pass filter applied.

close all; clearvars;

% Location of the main study directory
% This method of specifying the study directory only works if you run the
% script; for running individual lines of code, replace the study directory
% with the path on your computer, e.g.: 
% DIR = /Users/KappenmanLab/ERP_CORE/N400
% DIR = fileparts(fileparts(mfilename('fullpath'))); 
DIR = '/Volumes/Life Support/EMPIA/Participant EEG Data';

% Location of the folder that contains this script and any associated processing files
% This method of specifying the current file path only works if you run the
% script; for running individual lines of code, replace the current file
% path with the path on your computer, e.g.: 
% Current_File_Path = /Users/KappenmanLab/ERP_CORE/N400/EEG_ERP_Processing/Grand_Average_ERPs
% Current_File_Path = fileparts(mfilename('fullpath'));
Current_File_Path = '/Volumes/Life Support/EMPIA/Participant EEG Data';

% List of subjects to include in the grand average ERP waveforms (i.e.,
% subjects that were not excluded due to excessive artifacts), based on the
% name of the folder that contains that subject's data
SUB = {'t104', 't109', 't113', 't120', 't121', 't122', 't123', 't124', 't128', 't130', 't133', 't117','t125',};	
%SUB = {'a301', 'a302', 'a304' 'a305', 'a306', 'a307', 'a312', 'a314', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323'};
%SUB = {'a301', 'a302', 'a304' 'a305', 'a306', 'a307', 'a312', 'a314','a317', 'a318' 'a319', 'a320', 'a322', 'a323','t104', 't109', 't113','t120', 't121', 't122', 't123', 't124', 't128', 't130', 't133','t117','t125'};

% Subjects to include: 'a301', 'a302', 'a304' 'a305', 'a306', 'a307',
% 'a312', 'a314', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323', 
% 't104', 't109', 't113', 't117', 't120', 't121', 't122', 't123', 't124'
% 't125', 't128', 't130', 't133'

% Subjects to exclude due to excessive artifacts (i.e., >50% epochs/trials
% rejected): 'a308', 'a309', 'a311', 'a315', 't105', 't106', 't111',
% 't115', 't119'

%*************************************************************************************************************************************

% Create grand average ERP waveforms from individual subject ERPs *WITHOUT* low-pass filter applied 

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Create a text file containing a list of ERPsets and their file locations to include in the grand average ERP waveforms
ERPset_list = fullfile(Current_File_Path, 'GA_ERPs_OldCons.txt');
fid = fopen(ERPset_list, 'w');
    for i = 1:length(SUB)
        Subject_Path = [DIR filesep SUB{i} filesep];
        erppath = [Subject_Path SUB{i} '_ERPs_CorrBinLabs_diffwaves.erp'];
        fprintf(fid,'%s\n', erppath);
    end
fclose(fid);

% Create a grand average ERP waveform
ERP = pop_gaverager( ERPset_list , 'ExcludeNullBin', 'on', 'SEM', 'on' );
ERP = pop_savemyerp(ERP, 'erpname', 'GA_ERPs_OldCons_diffwaves', 'filename', 'GA_ERPs_OldCons_diffwaves.erp', 'filepath', [Current_File_Path filesep 'Grand Averages'], 'Warning', 'off');

%*************************************************************************************************************************************

% Create grand average ERP waveforms from individual subject ERPs *WITH* a low-pass filter applied

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Create a text file containing a list of low-pass filtered ERPsets and
% their file locations to include in the grand average ERP waveforms
ERPset_list = fullfile(Current_File_Path, 'GA_ERPs_lpfilt_OldCons.txt');
fid = fopen(ERPset_list, 'w');
    for i = 1:length(SUB)
        Subject_Path = [DIR filesep SUB{i} filesep];
        erppath = [Subject_Path SUB{i} '_ERPs_CorrBinLabs_diffwaves_20hzlpfilt.erp'];
        fprintf(fid,'%s\n', erppath);
    end
fclose(fid);

% Create a grand average ERP waveform
ERP = pop_gaverager( ERPset_list , 'ExcludeNullBin', 'on', 'SEM', 'on' );
ERP = pop_savemyerp(ERP, 'erpname', 'GA_ERPs_20hzlpfilt_OldCons_diffwaves', 'filename', 'GA_ERPs_20hzlpfilt_OldCons_diffwaves.erp', 'filepath', [Current_File_Path filesep 'Grand Averages'], 'Warning', 'off');

%*************************************************************************************************************************************
