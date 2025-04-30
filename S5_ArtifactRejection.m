% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin August 2021
% Operates on individual subject data
% This script loads the epoched EEG data file and performs artifact
% rejection to remove noisy segments of EEG, segments containing eyeblinks
% or eye movements during the time of the stimulus (i.e., resulting in a
% change in sensory input on that trial), and segments containing
% uncorrected residual eye movements throughout the epoch using the
% parameters tailored to an individual subject's data listed in the
% corresponding Excel file for that artifact.

close all; clearvars;

%Location of the main study directory
%This method of specifying the study directory only works if you run the script; for running individual lines of code, replace the study directory with the path on your computer, e.g.: 
%DIR = /Users/KappenmanLab/ERP_CORE/N400
%DIR = fileparts(fileparts(mfilename('fullpath'))); 
DIR = '/Volumes/Life Support/EMPIA/Participant EEG Data';

%Location of the folder that contains this script and any associated processing files
%This method of specifying the current file path only works if you run the script; for running individual lines of code, replace the current file path with the path on your computer, e.g.: 
%Current_File_Path = /Users/KappenmanLab/ERP_CORE/N400/EEG_ERP_Processing
%Current_File_Path = fileparts(mfilename('fullpath'));
Current_File_Path = '/Volumes/Life Support/EMPIA/Participant EEG Data';

%List of subjects to process, based on the name of the folder that contains that subject's data
SUB = {'a304','a305','a307'};	

% Subjects to process: all subjects processed 8/16/21

% Processed subjects:'a302', 'a304' 'a305', 'a307', 'a308','a311',
% 'a312','a314','a315', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323',
% 't104','t105','t106', 't109', 't111' 't113', 't115', 't117', 't120',
% 't121', 't122', 't123', 't124' 't125', 't128', 't130', 't133', 'a309',
% 'a306','a303','t119','a301'

% Processed subjects (_trimmed): 'a301','a303','a304','a306','a308','a311' (11/3/21)
% Processed subjects (_cleanedforICA): 'a301','a303','a304','a306','a308','a311' (11/3/21)


% Load the Excel file with the list of thresholds and parameters for
% identifying C.R.A.P. with the simple voltage threshold algorithm for each
% subject
[ndata2, text2, alldata2] = xlsread([Current_File_Path filesep 'AR_Parameters_for_SVT_CRAP']);

% Load the Excel file with the list of thresholds and parameters for
% identifying C.R.A.P. with the moving window peak-to-peak algorithm for
% each subject
[ndata3, text3, alldata3] = xlsread([Current_File_Path filesep 'AR_Parameters_for_MW_CRAP']);

% Load the Excel file with the list of thresholds and parameters for
% identifying eyeblinks during the stimulus presentation period (using the
% original non-ICA corrected VEOG signal) with the moving window
% peak-to-peak algorithm for each subject
[ndata4, text4, alldata4] = xlsread([Current_File_Path filesep 'AR_Parameters_for_MW_Blinks']);

% Load the Excel file with the list of thresholds and parameters for
% identifying horizontal eye movements during the stimulus presentation
% period (using the original non-ICA corrected HEOG signal) with the step
% like algorithm for each subject
[ndata5 text5, alldata5] = xlsread([Current_File_Path filesep 'AR_Parameters_for_SL_HEOG_Stim_Pres']);

% Load the Excel file with the list of thresholds and parameters for
% identifying any uncorrected horizontal eye movements (using the
% ICA-corrected HEOG signal) with the step like algorithm for each subject
[ndata6 text6, alldata6] = xlsread([Current_File_Path filesep 'AR_Parameters_for_SL_HEOG']);

%*************************************************************************************************************************************

% Loop through each subject listed in SUB
for i = 1:length(SUB)

    % Open EEGLAB and ERPLAB Toolboxes  
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Load the epoched EEG data file in .set EEGLAB file format
    EEG = pop_loadset( 'filename', [SUB{i} '_epoch.set'], 'filepath', Subject_Path);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0, 'setname', [SUB{i} '_epoch'], 'gui', 'on'); 

    % Identify segments of EEG with C.R.A.P. artifacts using the simple
    % voltage threshold algorithm with the parameters in the Excel file
    % (AR_Parameters_for_SVT_CRAP.xlsx) for this subject
    DimensionsOfFile2 = size(alldata2);
    for j = 1:DimensionsOfFile2(1)
        if isequal(SUB{i},num2str(alldata2{j,1}));
            if isequal(alldata2{j,2}, 'default')
                Channels = 1:65; %This operation is performed on all channels except for the bipolar HEOG and VEOG channels - change this here
            else
                Channels = str2num(alldata2{j,2});
            end
            ThresholdMinimum = alldata2{j,3};
            ThresholdMaximum = alldata2{j,4};
            TimeWindowMinimum = alldata2{j,5};
            TimeWindowMaximum = alldata2{j,6};
        end
    end

    EEG  = pop_artextval( EEG , 'Channel',  Channels, 'Flag', [1 2], 'Threshold', [ThresholdMinimum ThresholdMaximum], 'Twindow', [TimeWindowMinimum  TimeWindowMaximum] ); 
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '_arSVT'], 'gui', 'on'); 

    % Identify segments of EEG with C.R.A.P. artifacts using the moving
    % window peak-to-peak algorithm with the parameters in the Excel file
    % (AR_Parameters_for_MW_CRAP.xlsx) for this subject
    DimensionsOfFile3 = size(alldata3);
    for j = 1:DimensionsOfFile3(1)
        if isequal(SUB{i},num2str(alldata3{j,1}));
            if isequal(alldata3{j,2}, 'default')
                Channels = 1:65; %This operation is performed on all the non-occular channels - change this here
            else
                Channels = str2num(alldata3{j,2});
            end
            Threshold = alldata3{j,3};
            TimeWindowMinimum = alldata3{j,4};
            TimeWindowMaximum = alldata3{j,5};
            WindowSize = alldata3{j,6};
            WindowStep = alldata3{j,7};
        end
    end

    EEG  = pop_artmwppth( EEG , 'Channel',  Channels, 'Flag', [1 3], 'Threshold', Threshold, 'Twindow', [TimeWindowMinimum  TimeWindowMaximum], 'Windowsize', WindowSize, 'Windowstep', WindowStep ); 
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', [SUB{i} '_arSVT_arMWcrap'], 'gui', 'on'); 

    % Identify segments of EEG with blink artifacts during the stimulus
    % presentation window (using the original non-ICA corrected VEOG
    % signal) with the moving window peak-to-peak algorithm with the
    % parameters in the Excel file (AR_Parameters_for_MW_Blinks.xlsx) for
    % this subject
    DimensionsOfFile4 = size(alldata4);
    for j = 1:DimensionsOfFile4(1)
        if isequal(SUB{i},num2str(alldata4{j,1}));
            Channel = alldata4{j,2}; %This operation is performed on the non-ICA corrected bipolar VEOG channel - change this in the Excel file (not using bipolar channels right now)
            Threshold = alldata4{j,3};
            TimeWindowMinimum = alldata4{j,4};
            TimeWindowMaximum = alldata4{j,5};
            WindowSize = alldata4{j,6};
            WindowStep = alldata4{j,7};
        end
    end

    EEG  = pop_artmwppth( EEG , 'Channel',  Channel, 'Flag', [1 4], 'Threshold', Threshold, 'Twindow', [TimeWindowMinimum  TimeWindowMaximum], 'Windowsize', WindowSize, 'Windowstep', WindowStep ); 
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3, 'setname', [SUB{i} '_arSVT_arMWcrap_arMWeyes'], 'gui', 'on'); 

    % Identify segments of EEG with horizontal eye movement artifacts
    % during the stimulus presentation window (using the original non-ICA
    % corrected HEOG signal) with the step like algorithm with the
    % parameters in the Excel file
    % (AR_Parameters_for_SL_HEOG_Stim_Pres.xlsx) for this subject
    DimensionsOfFile5 = size(alldata5);
    for j = 1:DimensionsOfFile5(1)
        if isequal(SUB{i},num2str(alldata5{j,1}));
            Channel = alldata5{j,2}; %This operation is performed on the non-ICA corrected bipolar HEOG channel - change this in the Excel file (not using bipolar channels right now)
            Threshold = alldata5{j,3};
            TimeWindowMinimum = alldata5{j,4};
            TimeWindowMaximum = alldata5{j,5};
            WindowSize = alldata5{j,6};
            WindowStep = alldata5{j,7};
        end
    end

    EEG  = pop_artstep( EEG , 'Channel', Channel, 'Flag', [1 5], 'Threshold',  Threshold, 'Twindow', [TimeWindowMinimum  TimeWindowMaximum], 'Windowsize',  WindowSize, 'Windowstep', WindowStep );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4, 'setname', [SUB{i} '_arSVT_arMWcrap_arMWeyes_arSL1'], 'gui', 'on'); 

    % Identify segments of EEG with any uncorrected horizontal eye movement
    % artifacts (using the ICA-corrected HEOG signal) with the step like
    % algorithm with the parameters in the Excel file
    % (AR_Parameters_for_SL_HEOG.xlsx) for this subject
    DimensionsOfFile6 = size(alldata6);
    for j = 1:DimensionsOfFile6(1)
        if isequal(SUB{i},num2str(alldata6{j,1}));
            Channel = alldata6{j,2}; %This operation is performed on the ICA-corrected HEOG channel - change this in the Excel file 
            Threshold = alldata6{j,3};
            TimeWindowMinimum = alldata6{j,4};
            TimeWindowMaximum = alldata6{j,5};
            WindowSize = alldata6{j,6};
            WindowStep = alldata6{j,7};
        end
    end

    EEG  = pop_artstep( EEG , 'Channel', Channel, 'Flag', [1 6], 'Threshold',  Threshold, 'Twindow', [TimeWindowMinimum  TimeWindowMaximum], 'Windowsize',  WindowSize, 'Windowstep', WindowStep );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5, 'setname', [SUB{i} '_arSVT_arMWcrap_arMWeyes_arSL1_arSL2'], 'savenew', [Subject_Path SUB{i} '_allAR.set'], 'gui', 'on'); 

% End subject loop
end

%*************************************************************************************************************************************
