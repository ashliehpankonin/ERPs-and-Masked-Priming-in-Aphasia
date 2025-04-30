%Written by Cristy Sotomayor June 2020
%edited by Ashlie Pankonin July 2021
%run ica and save

% This script will run ICA on specified data files and save them for futher
% ERP processing.

% This script and the data files you want to run ICA on should be located
% in a directory that is included in Matlab's search path.

% parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that houses your subject folders.
parentfolder = '/Volumes/verb/EMPIA/Participant EEG Data';

% List all the subject folders you want to loop through
subject_list = {};
% Subjects to run ICA on: ICA run on all subjects on 8/10/21 
% Subjects run on ICA: 'a301','a303','t119','a302','a304','a305',
% 'a306','a307', 'a308','a309','a311', 'a312', 'a314', 'a315',
% 'a317','a318' 'a319', 'a320', 'a322', 'a323', 't104', 't105', 't106',
% 't109','t111' 't113', 't115', 't117',  't120', 't121', 't122',
% 't123','t124' 't125', 't128', 't130', 't133'
numsubjects = length(subject_list); %number of subjects in your set

% Loop through all subjects
for s=1:numsubjects 
    subject = subject_list{s};

    % Get subject info (same name as subjects.m function)
    subjectfolder = [parentfolder '/' subject '/'];
    dataset = [subject '_cleaned.set']; %this creates an ICA file from the file with the name of the subject name and the extension in parentheses, so change the extension to match what you want it use
    

    %load current dataset
    EEG=pop_loadset('filename', dataset, 'filepath', [parentfolder filesep subject filesep]);

    % Make output directories for each subject and condition         
    pathtran = [parentfolder filesep subject filesep];
    if ~exist(pathtran, 'dir')
        mkdir(pathtran);
    end
    newsetname = [subject '_ICA.set']; %output file's new name
        
    EEG= pop_runica(EEG,'extended',1,'interupt', 'on');
    %EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');
    [ALLEEG EEG] = eeg_store(ALLEEG,EEG,CURRENTSET)
    eeglab redraw
    
    % Save EEG to a .set file for futher processing 
    EEG.setname = [subject '_ICA'];
    EEG = pop_saveset( EEG, [pathtran newsetname]);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

end

