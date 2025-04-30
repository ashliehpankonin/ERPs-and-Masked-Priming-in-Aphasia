% Modified by Ashlie Pankonin April 2021 (not the first author/creator,
% unsure who wrote it originally)

% This script not only prepares EEG datasets for computing averaged ERPs
% via ERPLAB but also computes those averaged ERPs via ERPLAB.

% This script and the data files you want to check should be located in a 
% directory that is included in Matlab's search path.


% Clear memory and the command window
clear
clc
 
% Initialize the ALLERP structure and CURRENTERP
ALLERP = buildERPstruct([]);
CURRENTERP = 0;
 
% Set the save_everything variable to 1 to save all of the intermediate files to the hard drive
% Set to 0 to save only the initial and final dataset and ERPset for each subject
save_everything  = 1;
 
% Set the plot_PDFs variable to 1 to create PDF files with the waveforms
% for each subject (set to 0 if you don't want to create the PDF files).
plot_PDFs = 0;

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that contains the data folders for all
% subjects.
parentfolder = '/Volumes/verb/EMPIA/Participant EEG Data';

% List all the subject folders you want to loop through (i.e., define your
% set of subjects)
subject_list = {'a303'};
% Subjects to prep: 
%'a302', 'a303', 'a304' 'a305', 'a307', 'a308','a311', 'a312', 'a314',
%'a315', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323', 't104', 't105',
%'t106', 't109', 't111' 't113', 't115', 't117', 't119', 't120', 't121',
%'t122', 't123', 't124' 't125', 't128', 't130', 't133', 'a309', 'a306'

% Subjects that are all prepped:
% Manual ICAR: 't119','a301'
% MARA ICAR: 't119','a301'
% No ICAR: 't119','a301'

filespec = '_ICAR_MARA'; %*BE SURE TO CHANGE ACCORDINGLY*
%filespece = part of filename following subject ID that identifies what
%steps of data processing have occured so far (e.g., _ICA)

numsubjects = length(subject_list); %number of subjects in your set

% Loop through all subjects
for s=1:numsubjects
    subject = subject_list{s};
        fprintf('\n******\nProcessing subject %s\n******\n\n', subject);
        % Path to the folder containing the current subject's data
        subjectfolder  = [parentfolder '/' subject '/'];

        % Check to make sure the dataset file exists
        % spath = path + subject ID + filename specifications + .set
         spath = [subjectfolder subject filespec '.set'];
            if exist(spath, 'file')<=0
                fprintf('\n *** WARNING: %s does not exist *** \n', spath);
                fprintf('\n *** Skipping all processing for this subject *** \n\n');

            else
                % Load original dataset
                fprintf('\n\n\n**** %s: Loading dataset ****\n\n\n', subject);
                subjectsetname = [subject filespec]; 
                EEG = pop_loadset('filename', [subjectsetname '.set'], 'filepath', subjectfolder);

                % Create EEG event list
                fprintf('\n\n\n**** %s: Creating EEG event list ****\n\n\n', subject);
                EEG = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } );
                EEG.setname = [EEG.setname '_elist']; % output file's new name
                if (save_everything)
                    EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', subjectfolder);
                end

                % Assign bins via BINLISTER
                fprintf('\n\n\n**** %s: Assigning bins via BINLISTER ****\n\n\n', subject);       
                EEG = pop_binlister( EEG , 'BDF', [parentfolder '/EMPIA_binlist.txt'], 'IndexEL',  1, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
                EEG.setname = [EEG.setname '_bins']; % output file's new name
                if (save_everything)
                    EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', subjectfolder);
                end

                % Extracts bin-based epochs (100ms pre-stim, 1180ms post-stim, baseline correction by pre-stim window)
                fprintf('\n\n\n**** %s: Bin-based epoching ****\n\n\n', subject);
                EEG = pop_epochbin( EEG , [-100.0  1180.0],  'pre');
                EEG.setname = [EEG.setname '_be']; % output file's new name
                if (save_everything)
                    EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', subjectfolder);
                end
                
                % Two rounds of artifact detection
                % Artifact detection: extreme voltage. Test window = [-100 1180];
                % Threshold = -75 to 75 uV (or should we use +/- 50 uV? 50 was used in original/Mark's analyses but Alyson uses 75 and ERPLAB example says 75 is "relatively low" threshold. Using 75 leads to A LOT more viable data, even without any ICAR.) 
                % Flags to be activated = 1; 
                % Channels = 7 9 14 17 27 31 38 42 44 48 51 54 64 66 67
                fprintf('\n\n\n**** %s: Artifact detection (extreme voltage) ****\n\n\n', subject_list{s});              
                EEG  = pop_artextval( EEG , 'Channel', [7 9 14 17 27 31 38 42 44 48 51 54 64 66 67], 'Flag',  1, 'Threshold', [ -75 75], 'Twindow', [ -100 1180] );
                
                % Artifact detection: moving window. Test window = [-100 1180]; 
                % Threshold = 100 uV; Window width = 200 ms;
                % Window step = 50 ms; Flags to be activated = 1 & 4; 
                % Channels = 7 9 14 17 27 31 38 42 44 48 51 54 64 66 67
                fprintf('\n\n\n**** %s: Artifact detection (moving window peak-to-peak and step function) ****\n\n\n', subject);              
                EEG = pop_artmwppth( EEG , 'Channel',  [7 9 14 17 27 31 38 42 44 48 51 54 64 66 67], 'Flag', [ 1 4], 'Threshold',  100, 'Twindow', [ -100 1180], 'Windowsize',  200, 'Windowstep',  50 );   

                % Artifact detection: step-like artifacts (i.e., saccades).
                % Test window = [-100 1180]; Threshold = 20 uV; Window
                % width = 400 ms; Window step = 10 ms; Flags to be
                % activated = 1 & 3; Channels = 66 & 67 (eye electrodes only)
                EEG  = pop_artstep( EEG , 'Channel', [66 67], 'Flag',  [1 3], 'Threshold',  20, 'Twindow', [ -100 1180], 'Windowsize',  400, 'Windowstep',  10 );
                EEG.setname = [EEG.setname '_ar'];
                
                EEG = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', subjectfolder);
                %EEG = pop_exporteegeventlist(EEG, [parentfolder subject '_eventlist_ar.txt']); %export event list 
                
                % Report percentage of rejected trials (collapsed across all bins)
                artifact_proportion = getardetection(EEG);
                fprintf('%s: Percentage of rejected trials was %1.2f\n', subject, artifact_proportion);

                % Compute averaged ERPs (only good epochs)
                fprintf('\n\n\n**** %s: Averaging ERPs ****\n\n\n', subject);              
                ERP = pop_averager( EEG , 'Criterion', 'good', 'ExcludeBoundary', 'on', 'SEM', 'on' );
                ERP.erpname = [subjectsetname '_ERPs'];  % name for erpset 
                pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [ERP.erpname '.erp'], 'filepath', subjectfolder, 'warning', 'off');
            end % end of the "if/else" statement that makes sure the file exists
end % end of looping through all subjects

fprintf('\n\n\n**** FINISHED with Data Processing ****\n\n\n');