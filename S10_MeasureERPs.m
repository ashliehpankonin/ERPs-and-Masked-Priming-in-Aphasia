% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin August 2021
% Operates on individual subject data
% This script uses the individual subject averaged ERP waveforms, measures
% the mean amplitude during the time window of the component, and saves a
% separate text file for each measurement in the ERP Measurements folder.
% Note that based on their respective unsusceptibility to high frequency
% noise, mean amplitude is calculated on the averaged ERP waveforms
% *without* a low-pass filter applied.

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
Current_File_Path = '/Volumes/Life Support/EMPIA/Participant EEG Data/ERP Measurements';

% List of subjects to measure component amplitudes and latencies from
% (i.e., subjects that were not excluded due to excessive artifacts), based
% on the name of the folder that contains that subject's data
SUB = {'a301',	'a302',	'a304',	'a305',	'a306',	'a307',	'a312',	'a314',	'a317',	'a318',	'a319',	'a320',	'a322',	'a323',	't104',	't109',	't113',	't117',	't120',	't121',	't122',	't123',	't124',	't125',	't128',	't130',	't133'};

% Subjects to include: 'a301', 'a302', 'a304' 'a305', 'a306', 'a307',
% 'a312', 'a314', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323', 't104',
% 't109', 't113', 't117', 't120', 't121', 't122', 't123', 't124' 't125',
% 't128', 't130', 't133'

% Subjects to exclude due to excessive artifacts (i.e., >50% epochs/trials
% rejected): 'a308', 'a309', 'a311', 'a315', 't105', 't106', 't111',
% 't115', 't119'

%*************************************************************************************************************************************

% Select component to measure mean amplitude of
% P2, N400, P300, LCP
component = 'N400';

% Set measurement time window for measuring mean amplitude in milliseconds
% (e.g., 300 to 500 ms)
% P2 = 150 to 300 ms
% N400 = 300 to 500 ms
% P300 = 400 to 1000 ms
% LPC = 500 to 750 ms
if strcmp('P2',component)
    timewindow = [150 300];
elseif strcmp('N400',component)
    timewindow = [300 500];
elseif strcmp('P300',component)
    timewindow = [400 1000];
elseif strcmp('LPC',component)
    timewindow = [500 750];
end

% Set EEG channel(s) to measure the components
chan = [1	3	5	10	13	15	18	21	26	27	29	30	31	32	33	34	36	38	40	45	47	48	50	52	55	58	63	64]; %[7 9 14 17 27 31 38 42 44 48 51 54 64]; [ 68 69 70 ];

% Set wave bins for measurement
% P2 = [5 6 4 8 7]
% N400 = [5 6 4 8 7]
% P300 = [1 2 3 4]
% LPC = [5 6 4 8 7]
if strcmp('P2',component)
    parentbins = [5 6 4 8 7];
elseif strcmp('N400',component)
    parentbins = [5 6 4 8 7];
elseif strcmp('P300',component)
    parentbins = [1 2 3 4];
elseif strcmp('LPC',component)
    parentbins = [5 6 4 8 7];
end


% Set baseline correction period for measurement
baselinecorr = [-100 0]; 

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%*************************************************************************************************************************************

% Waveform measurements on averaged ERP waveforms without a low-pass filter
% applied

% Create a text file containing a list of unfiltered ERPsets and their file
% locations to measure mean amplitude from
ERPset_list = fullfile(Current_File_Path, 'Measurement_ERP_List.txt');
fid = fopen(ERPset_list, 'w');
    for i = 1:length(SUB)
        Subject_Path = [DIR filesep SUB{i} filesep];
        erppath = [Subject_Path SUB{i} '_ERPs_CorrBinLabs.erp'];
        fprintf(fid,'%s\n', erppath);
    end
fclose(fid);

% Measure mean amplitude using the time window, channel(s), and bin(s)
% specified above
ALLERP = pop_geterpvalues(ERPset_list, timewindow, parentbins, chan, 'Baseline', baselinecorr, 'Measure', 'meanbl', 'Filename',... 
    [Current_File_Path filesep 'Mean_Amplitude_' component '_.txt'], 'Binlabel', 'on', 'FileFormat', 'long', 'InterpFactor',  1,  'Resolution', 3);

%*************************************************************************************************************************************
