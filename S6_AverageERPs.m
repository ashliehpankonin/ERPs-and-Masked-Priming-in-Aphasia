% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin August 2021 
% Operates on individual subject data
% This script loads the epoched and artifact rejected EEG data, creates an
% averaged ERP waveform, calculates the percentage of trials rejected for
% artifacts (in total and per bin) and saves the information to a .csv file
% in each subject's data folder, and creates low-pass filtered versions of
% the ERP waveforms.

close all; clearvars;

%Location of the main study directory, based on where this script is saved
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
SUB = {'a312','a314','a315', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323','t104','t106','t109', 't111' 't113', 't115', 't117', 't120','t121', 't122', 't123', 't124' 't125', 't128', 't130', 't133', 'a309','a306','a303','t119'};	
%SUB = {'a301', 'a302', 'a304' 'a305', 'a307', 'a308','a311','a312','a314','a315', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323','t104','t105','t106','t109', 't111' 't113', 't115', 't117', 't120','t121', 't122', 't123', 't124' 't125', 't128', 't130', 't133', 'a309','a306','a303','t119'};	

% Subjects to process: all subjects processed 11/11/21

% Processed subjects: 'a301', 'a302', 'a304' 'a305', 'a307', 'a308','a311',
% 'a312','a314','a315', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323',
% 't104','t105','t106', 't109', 't111' 't113', 't115', 't117', 't120',
% 't121', 't122', 't123', 't124' 't125', 't128', 't130', 't133', 'a309',
% 'a306','a303','t119',

% Processed subjects (_trimmed): 'a301','a303','a304','a306','a308','a311' (11/3/21)
% Processed subjects (_cleanedforICA): 'a301','a303','a304','a306','a308','a311' (11/3/21)

%**********************************************************************************************************************************************************************

% Create averaged ERP waveforms

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Loop through each subject listed in SUB
for i = 1:length(SUB)
  
    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % % Load the epoched and marked for artifact rejection EEG data file in .set EEGLAB file format
    % EEG = pop_loadset( 'filename', [SUB{i} '_allAR.set'], 'filepath', Subject_Path);
    
    % % Save a version of the EEG data file where all epochs marked for rejection are
    % % actually rejected
    % EEG = eeg_rejsuperpose( EEG, 1, 1, 1, 1, 1, 1, 1, 1);%creates variable for storing all marked epochs
    % EEG = pop_rejepoch(EEG,[EEG.reject.rejglobal],0);%rejects all maked epochs
    % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0, 'setname', [SUB{i} '_artrej'], 'savenew', [Subject_Path SUB{i} '_artrej.set'], 'gui', 'on');%saves data set 

    % % Create an averaged ERP waveform (only trials/epochs not marked for rejection due to artifacts)
    % ERP = pop_averager( EEG , 'Criterion', 'good', 'ExcludeBoundary', 'on', 'SEM', 'on');
    % ERP = pop_savemyerp( ERP, 'erpname', [SUB{i} '_ERPs_CorrBinLabs'], 'filename', [Subject_Path SUB{i} '_ERPs_CorrBinLabs.erp']);
    % 
    % % Apply a low-pass filter (non-causal Butterworth impulse response function, 20 Hz half-amplitude cut-off, 48 dB/oct roll-off) to the ERP waveforms
    % ERP = pop_filterp( ERP,  1:67 , 'Cutoff',  20, 'Design', 'butter', 'Filter', 'lowpass', 'Order',  8 );
    % ERP = pop_savemyerp( ERP, 'erpname', [SUB{i} '_ERPs_lpfilt'], 'filename', [Subject_Path SUB{i} '_ERPs_lpfilt.erp']);

    % % Calculate the percentage of trials that were rejected in each bin 
    % accepted = ERP.ntrials.accepted;
    % rejected= ERP.ntrials.rejected;
    % percent_rejected= rejected./(accepted + rejected)*100;
    % 
    % % Calculate the total percentage of trials rejected across all trial types (all bins)
    % total_accepted = accepted(1) + accepted(2)+ accepted(3) + accepted(4) + accepted(5) + accepted(6) + accepted(7) + accepted(8);
    % total_rejected= rejected(1)+ rejected(2) + rejected(3)+ rejected(4) + rejected(5)+ rejected(6) + rejected(7)+ rejected(8);
    % total_percent_rejected= total_rejected./(total_accepted + total_rejected)*100; 
    % 
    % % Save the percentage of trials rejected (in total and per bin) to a .csv file 
    % fid = fopen([DIR filesep SUB{i} filesep SUB{i} '_AR_Percentages.csv'], 'w');
    % fprintf(fid, 'SubID,Bin,Accepted,Rejected,Total Percent Rejected\n');
    % fprintf(fid, '%s,%s,%d,%d,%.2f\n', SUB{i}, 'Total', total_accepted, total_rejected, total_percent_rejected);
    % bins = strrep(ERP.bindescr,', ',' - ');
    % for b = 1:length(bins)
    %     fprintf(fid, ',%s,%d,%d,%.2f\n', bins{b}, accepted(b), rejected(b), percent_rejected(b));
    % end
    % fclose(fid);
    
%Create difference waveforms

    %Load averaged ERP waveform (without the 20 Hz low-pass filter) 
    ERP = pop_loaderp('filename', [SUB{i} '_ERPs_CorrBinLabs.erp'], 'filepath', Subject_Path);  
    
    %Create ERP difference waveforms between conditions
    ERP = pop_binoperator( ERP, [DIR filesep 'EMPIA_Difference_Waves_Bins.txt']);
    ERP = pop_savemyerp(ERP, 'erpname', [SUB{i} '_ERPs_CorrBinLabs_diffwaves'], 'filename', [Subject_Path SUB{i} '_ERPs_CorrBinLabs_diffwaves.erp']);

    %Apply a low-pass filter (non-causal Butterworth impulse response function, 20 Hz half-amplitude cut-off, 48 dB/oct roll-off) to the difference waveforms
    ERP = pop_filterp( ERP,  1:67, 'Cutoff',  20, 'Design', 'butter', 'Filter', 'lowpass', 'Order',  8 );
    ERP = pop_savemyerp( ERP, 'erpname', [SUB{i} '_ERPs_CorrBinLabs_diffwaves_20hzlpfilt'], 'filename', [Subject_Path SUB{i} '_ERPs_CorrBinLabs_diffwaves_20hzlpfilt.erp']);
        
%End subject loop
end 

%*************************************************************************************************************************************