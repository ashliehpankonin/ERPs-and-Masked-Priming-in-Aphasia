% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin November 2021
% Operates on individual subject data
% This script loads the continuous EEG data file and interpolates bad
% channels listed in Excel file Interpolate_Channels.xls.

close all; clearvars;

% Location of the main study directory
%This method of specifying the study directory only works if you run the script; for running individual lines of code, replace the study directory with the path on your computer, e.g.: 
%DIR = /Users/KappenmanLab/ERP_CORE/N400
%DIR = fileparts(fileparts(mfilename('fullpath'))); 
DIR = '/Volumes/verb/EMPIA/Participant EEG Data';

% Location of the folder that contains this script and any associated processing files
%This method of specifying the current file path only works if you run the script; for running individual lines of code, replace the current file path with the path on your computer, e.g.: 
%Current_File_Path = /Users/KappenmanLab/ERP_CORE/N400/EEG_ERP_Processing
%Current_File_Path = fileparts(mfilename('fullpath'));
Current_File_Path = '/Volumes/verb/EMPIA/Participant EEG Data';

%List of subjects to process, based on the name of the folder that contains that subject's data
SUB = {'a304' };	 

% Subjects to process: 
% 'a302', 'a304' 'a305', 'a307', 'a308','a311', 'a312',
% 'a314','a315', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323', 't104',
% 't105','t106', 't109', 't111' 't113', 't115', 't117','t20',
% 't121','t122', 't123', 't124' 't125', 't128', 't130', 't133', 'a309',
% 'a306', 'a303','t119'

% Processed subjects (_trimmed):  'a303', 'a301', 'a304', 'a306', 'a308','a311' (11/2/21)
% Processed subjects (_cleanedforICA): 'a301', 'a303', 'a304', 'a306','a308', 'a311' (11/2/21)

%Load the Excel file with the list of channels to interpolate for each subject 
[ndata1, text1, alldata1] = xlsread([Current_File_Path filesep 'Interpolate_Channels']);

%*************************************************************************************************************************************

%Loop through each subject listed in SUB
for i = 1:length(SUB)

    %Open EEGLAB and ERPLAB Toolboxes  
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Load the continuous EEG data file with components removed/artifacts rejected in .set EEGLAB file format
    EEG = pop_loadset( 'filename', [SUB{i} '_trimmed_ICAR2_newmethod.set'], 'filepath', Subject_Path);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '_trimmed_ICAR2_newmethod'], 'gui', 'off'); 

    % Interpolate channel(s) specified in Excel file Interpolate_Channels.xls; any channels without channel locations (e.g., the eye channels) should not be included in the interpolation process and are listed in ignored channels
    % EEG channels that will later be used for measurement of the ERPs should not be interpolated
    ignored_channels = [7 9 14 17 27 31 38 42 44 48 51 54 64 66 67];        
    DimensionsOfFile1 = size(alldata1);
    for j = 1:DimensionsOfFile1(1);
        if isequal(SUB{i},num2str(alldata1{j,1}));
           badchans = (alldata1{j,2});
           if ~isequal(badchans,'none') | ~isempty(badchans)
           	  if ~isnumeric(badchans)
                 badchans = str2num(badchans);
              end
              EEG  = pop_erplabInterpolateElectrodes( EEG , 'displayEEG',  0, 'ignoreChannels',  ignored_channels, 'interpolationMethod', 'spherical', 'replaceChannels', badchans);
           end
           [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', [SUB{i} '_trimmed_ICAR2_newmethod_interp'], 'savenew', [Subject_Path SUB{i} '_trimmed_ICAR2_newmethod_interp.set'], 'gui', 'off'); 
        end
    end 

%End subject loop
end

%*************************************************************************************************************************************
