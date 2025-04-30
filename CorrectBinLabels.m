% Written by Ashlie Pankonin August 2021
% Operates on individual subject data
% This script loads the (low-pass filtered) averaged ERP waveforms and
% corrects bin labels.
close all; clearvars;

%Location of the main study directory, based on where this script is saved
%This method of specifying the study directory only works if you run the script; for running individual lines of code, replace the study directory with the path on your computer, e.g.: 
%DIR = /Users/KappenmanLab/ERP_CORE/N400
%DIR = fileparts(fileparts(mfilename('fullpath'))); 
DIR = '/Volumes/verb/EMPIA/Participant EEG Data';

%List of subjects to process, based on the name of the folder that contains that subject's data
SUB = {'a301', 'a302', 'a304' 'a305', 'a307', 'a308','a311','a312','a314','a315', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323', 't104','t105','t106', 't109', 't111' 't113', 't115', 't117', 't120', 't121', 't122', 't123', 't124' 't125', 't128', 't130', 't133', 'a309','a306','a303', 't119'};	

% Subjects to process: all subjects processed 11/11/21

% Processed subjects: 't119', 'a301', 'a302', 'a304' 'a305', 'a307',
% 'a308','a311', 'a312','a314','a315', 'a317', 'a318' 'a319', 'a320',
% 'a322', 'a323', 't104','t105','t106', 't109', 't111' 't113', 't115',
% 't117', 't120', 't121', 't122', 't123', 't124' 't125', 't128', 't130',
% 't133', 'a309', 'a306','a303'

%**********************************************************************************************************************************************************************

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Loop through each subject listed in SUB
for i = 1:length(SUB)
  
    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Load the (low-pass filtered) averaged ERP waveforms outputted in .erp ERPLAB file format
    ERP = pop_loaderp('filename', [SUB{i} '_ERPs.erp'], 'filepath', Subject_Path);  

    % Rename the bin labels with the correct labels
    ERP = pop_binoperator( ERP, {  'nbin1 = bin1 label Animal primes',  'nbin2 = bin2 label Non-animal primes',  'nbin3 = bin3 label Animal targets',...
    'nbin4 = bin4 label Non-animal targets/no primes',  'nbin5 = bin5 label Immediate masked primes',  'nbin6 = bin6 label Unrelated primes',...
    'nbin7 = bin7 label Delayed masked primes',  'nbin8 = bin8 label Delayed visible primes'});
    
    % Save the file
    ERP = pop_savemyerp( ERP, 'erpname', [SUB{i} '_ERPs_CorrBinLabs'], 'filename', [Subject_Path SUB{i} '_ERPs_CorrBinLabs.erp']);

%End subject loop
end 

%*************************************************************************************************************************************