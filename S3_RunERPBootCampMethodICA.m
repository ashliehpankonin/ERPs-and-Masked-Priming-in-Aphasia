% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin September 2021
% Operates on individual subject data
% This script loads the prepped-for-ICA semi-continuous EEG data file
% (i.e., with the break periods and noisy segments of EEG removed),
% computes the ICA weights that will be used for artifact correction of
% ocular artifacts, and transfers the ICA weights to the continuous EEG data
% file without the break periods and noisy segments of EEG removed.

% PLEASE NOTE: The results of ICA decomposition using binica/runica (i.e.,
% the ordering of the components, the scalp topographies, and the time
% courses of the components) will differ slightly each time ICA weights are
% computed. This is because ICA decomposition starts with a random weight
% matrix (and randomly shuffles the data order in each training step), so
% the convergence is slightly different every time it is run.

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
SUB = {'a306' };	

% Subjects to prep: 

% 'a302', 'a304' 'a305', 'a307', 'a308','a311', 'a312',
% 'a314','a315', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323', 't104',
% 't105','t106', 't109', 't111' 't113', 't115', 't117','t20',
% 't121','t122', 't123', 't124' 't125', 't128', 't130', 't133', 'a309',
% 'a306', 'a303','t119', 

% Prepped subjects (_cleanedforICA): 'a301', 'a303', 'a304', 'a308', 'a311'
% Prepped subjects (_trimmed): 'a301', 'a303', 'a304', 'a306', 'a308', 'a311'



% Load the Excel file with the list of channels to interpolate for each subject 
[ndata1, text1, alldata1] = xlsread([Current_File_Path filesep 'Interpolate_Channels']);

%***********************************************************************************************************************************************

%Loop through each subject listed in SUB
for i = 1:length(SUB)
    
    %Open EEGLAB and ERPLAB Toolboxes  
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Load the prepped-for-ICA semi-continuous EEG data file in .set EEGLAB file format
    EEG = pop_loadset( 'filename', [SUB{i} '_cleanedforICA.set'], 'filepath', Subject_Path); 
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '_cleanedforICA'], 'gui', 'off'); 

    % Compute ICA weights with binICA (a compiled and faster version of ICA). If binICA is not an option (e.g., on a Windows machine), use runICA by replacing the code with the following: 
    % EEG = pop_runica(EEG,'extended',1,'chanind', [1:31]);
    % Any channels that are not linearly independent (i.e., interpolated channels, bipolar EOG channels) and any channels that will be interpolated at a later step are not included in the channel list for computing ICA weights
    % Channel(s) not to include are specified in Excel file Interpolate_Channels.xls 
    DimensionsOfFile1 = size(alldata1);  
    for j = 1:DimensionsOfFile1(1);
        if isequal(SUB{i},num2str(alldata1{j,1}));
           badchans = (alldata1{j,2});
           if ~isequal(badchans,'none') | ~isempty(badchans)
           	  if ~isnumeric(badchans)
                 badchans = str2num(badchans);
                 goodchans = [1:67];
                 %disp (goodchans)
                 %EEG = pop_runica(EEG,'extended',1,'icatype','binica','chanind',goodchans); 
                 EEG = pop_runica(EEG,'extended',1,'chanind',goodchans); 
              end
             allchans = [1:67];
             goodchans = allchans(~ismember(allchans,badchans));
             %disp (goodchans)
             %EEG = pop_runica(EEG,'extended',1,'icatype','binica','chanind',goodchans); 
             EEG = pop_runica(EEG,'extended',1,'chanind',goodchans);
           end
        end
    end
    %disp(goodchans)
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', [SUB{i} '_cleanedforICA_ICAweightstotransfer'], 'savenew', [Subject_Path SUB{i} '_cleanedforICA_ICAweightstotransfer.set'], 'gui', 'off');
    
    % Load the continuous EEG data file without the break periods and noisy segments of data removed in .set EEGLAB file format
    EEG = pop_loadset( 'filename', [SUB{i} '_uncropped_preproc.set'], 'filepath', Subject_Path);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3, 'setname', [SUB{i} '_uncropped_preproc'], 'gui', 'off'); 
    
    % Transfer ICA weights to the continuous EEG data file without the break periods and noisy segments of data removed and save that as a new EEG data file
    EEG = pop_editset(EEG, 'icachansind', 'ALLEEG(2).icachansind', 'icaweights', 'ALLEEG(2).icaweights', 'icasphere', 'ALLEEG(2).icasphere');%
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4, 'setname', [SUB{i} '_cleanedforICA_ICAweighted'], 'savenew', [Subject_Path SUB{i} '_cleanedforICA_ICAweighted.set'], 'gui', 'off');
    
%     % Save a pdf of the topographic maps of the ICA weights for later review
%     set(groot,'DefaultFigureColormap',jet)
%     pop_topoplot(EEG, 0, goodchans,[SUB{i} '_ICAweightstotransfer'], [9 ceil(numel(goodchans)/9)] ,0,'electrodes','on');
%     save2pdf([Subject_Path 'graphs' filesep SUB{i} '_ICAweights.pdf']);
%     close all
%    
    
%End subject loop
end

%***********************************************************************************************************************************************
