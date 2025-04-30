% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin September 2021
% Operates on individual subject data
% This script loads the outputted continuous EEG data file, applies a
% band-ass filter, downsamples the data to 100 Hz to speed ICA data
% processing time, removes segments of EEG during the break periods in
% between trial blocks, and removes especially noisy segments of EEG during
% the trial blocks to prepare the data for ICA. Note that the goal of this
% stage of processing is to remove particularly noisy segments of data; a
% more thorough rejection of artifacts will be performed later on the
% epoched data.


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
SUB = { };	

% Subjects to prep:  

% 'a302', 'a304' 'a305', 'a307', 'a308','a311', 'a312',
% 'a314','a315', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323', 't104',
% 't105','t106', 't109', 't111' 't113', 't115', 't117','t20',
% 't121','t122', 't123', 't124' 't125', 't128', 't130', 't133', 'a309',
% 'a306', 'a303','t119', 

% Prepped subjects: 'a301', 'a303', 'a304', 'a306', 'a308', 'a311' 

%*************************************************************************************************************************************

% Loop through each subject listed in SUB
for i = 1:length(SUB)

    % Open EEGLAB and ERPLAB Toolboxes
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Load the continuous EEG data file in .set EEGLAB file format
    EEG = pop_loadset( 'filename', [SUB{i} '_preproc.set'], 'filepath', Subject_Path);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '_preproc'], 'gui', 'off'); 
    
    % Apply a band-pass filter (non-causal Butterworth impulse response function, 1-30 Hz half-amplitude cut-off, 48 dB/oct roll-off)
    EEG  = pop_basicfilter( EEG,  1:67 , 'Boundary', 'boundary', 'Cutoff',  [ 1 30], 'Design', 'butter', 'Filter', 'bandpass', 'Order',  8);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', [SUB{i} '_bpfilt'], 'savenew', [Subject_Path SUB{i} '_bpfilt.set'], 'gui', 'off');

    % Downsample to 100 Hz to speed ICA data processing (automatically applies the appropriate low-pass anti-aliasing filter)
    EEG = pop_resample( EEG, 100);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'setname',[SUB{i} '_ds100'],'savenew',[Subject_Path SUB{i} '_ds100.set'] ,'gui','off'); 
    
    % Remove segments of EEG during the break periods in between trial blocks (defined as 2 seconds or longer in between successive stimulus event codes)
    EEG  = pop_erplabDeleteTimeSegments( EEG , 'displayEEG', 0, 'endEventcodeBufferMS',  2000, 'ignoreUseEventcodes', [1 2 3 7 8 11 22 33 40 49 55 56 66 77 88], 'ignoreUseType', 'Use', 'startEventcodeBufferMS',  2000, 'timeThresholdMS',  2000 );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4, 'setname', [SUB{i} '_trimmed'], 'savenew', [Subject_Path SUB{i} '_trimmed.set'], 'gui', 'off'); 

    % Load parameters for rejecting especially noisy segments of EEG during trial blocks from Excel file ICA_Prep_Values.xls. 
    % Default parameters can be used initially but may need to be modified for a given participant on the basis of visual inspection of the data.
    [ndata, text, alldata] = xlsread([Current_File_Path filesep 'ICA_Prep_Values']); 
        for j = 1:length(alldata)           
            if isequal(SUB{i},num2str(alldata{j,1}));
                AmpthValue = alldata{j,2};
                WindowValue = alldata{j,3};
                StepValue = alldata{j,4};
            end
        end

    % Delete segments of the EEG exceeding the thresholds defined above
    EEG = pop_continuousartdet( EEG, 'ampth', AmpthValue, 'winms', WindowValue, 'stepms', StepValue, 'chanArray', 1:67, 'review', 'off');        
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5, 'setname', [SUB{i} '_cleanedforICA'], 'savenew', [Subject_Path SUB{i} '_cleanedforICA.set'], 'gui', 'off'); 

% End subject loop
end

%*************************************************************************************************************************************
