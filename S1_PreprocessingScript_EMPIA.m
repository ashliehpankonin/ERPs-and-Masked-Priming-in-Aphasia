% Written by Ashlie Pankonin March 2021, based on scripts written 
% by Julie Schneider and Bambi DeLaRosa May 2016 and Mark Pettet 2013-2018

% resample = 500; %set resample rate (not resampled in current script; need
% to add function for resampling if we decide we want to resample)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script will preprocess BIOSEMI (.bdf) files and return EEGLAB data 
% structures.

%   NOTES:

% 	1) PreprocessingScript_EMPIA.m should be located in a 
%   directory that is included in Matlab's search path.
	
% 	2) The "bdfplugin1.00" toolbox folder should be in the same location 
%   and included in the search path; it can be downloaded from
% 	http://sccn.ucsd.edu/eeglab/plugins/bdfimport1_00.zip
	
% 	3) The .txt files should also be stored in the same location as
% 	PreprocessingScript_EMPIA.m

% Parentfolder should be the main file path that leads you to your data. 
% The last file should be the one that houses your subject folders.
parentfolder = '/Volumes/verb/EMPIA/Participant EEG Data';

% List all the subject folders you want to loop through
subject_list = {};
% Subjects to preprocess: preprocessed all subjects on 3/11/2021
% Subjects that have been preprocessed:'a301', 'a302', 'a303', 'a304' 
% 'a305', 'a307', 'a308','a311', 'a312', 'a314', 'a315', 'a317', 'a318'
% 'a319', 'a320', 'a322', 'a323', 't104', 't105', 't106', 't109', 't111'
% 't113', 't115', 't117', 't119', 't120', 't121', 't122', 't123', 't124'
% 't125', 't128', 't130', 't133', 'a309', 'a306'

numsubjects = length(subject_list);
for s=1:numsubjects

    subject = subject_list{s};
    
    % Get subject info (same name as subjects.m function)
    subjectfolder = [parentfolder '/' subject '/'];
    
        % Make output directories for each subject and condition         
        pathtran = [parentfolder filesep subject filesep];
        if ~exist(pathtran, 'dir')
            mkdir(pathtran);
        end
        newsetname = [subject '_preproc.set']; % output file's new name

        clear EEG ALLEEG
        
        % Start EEGLAB
        eeglab;
        
        % Import BIOSEMI file into EEGLAB structure via
        % EEG = pop_biosig( aBiosemiPFNm ); 
        % pop_readbdf() doesn't get events unless you know which channel has them...
        EEG = pop_biosig([subjectfolder subject '.bdf'], 'ref', 65); % "65" is event channel

        % Event type codes greater than 255 are the event markers for button
        % device. These are good for accurate reaction time measurements, but
        % they impinge between the stimulus and response codes. So we remove
        % them.

        %tLSS = [ EEG.urevent.type ] < 256;
        %EEG.urevent = EEG.urevent( tLSS );
        %EEG.event = EEG.event( tLSS );
        %tUREv = num2cell( 1:numel( EEG.urevent ) );
        %[ EEG.event.urevent ] = deal( tUREv{:} );

       % Change set name to subject name
       EEG = pop_editset(EEG, 'setname', subject, 'run', []);
       eeglab redraw

       % This runs a 0.1-30 Hz bandpass on the data; 0.1 Hz is fine for the P600
       EEG = pop_basicfilter( EEG,  1:EEG.nbchan, 'Cutoff', [ 0.1 30], 'Design', 'butter', 'Filter', 'bandpass', 'Order',  4, 'RemoveDC', 'on' ); 

       % pop_reref() below will remove the reference channel, so we must keep
       % track of how that shifts the artifact and analysis channels.

       tRefChan = 65; % M1, this will get removed
       tChanLocFNm = 'ChanLocs68.txt'; % assumed to be in working directory

       % where ChanLocs68.txt was created from the "64-chan" sheet in BIOSEMI's
       % Cap_coords_all.xls; specfically the columns:
       % "Electrode", "x = ...", "y = ...", and "z = ..."
       % were used to create ChanLocs.txt columns listed in 'format' specifier
       % above. Note that "-X" and "-Y" flip the sign of the values in the
       % file to coerce BIOSEMI coordinates into EEGLAB convention.

       EEG = pop_chanedit( EEG, 'load', { tChanLocFNm, 'format', { 'labels' '-X' '-Y' 'Z' } } );
       EEG = pop_reref( EEG, tRefChan );

       % Save EEG to a .set file for futher ERP processing 
       EEG = eeg_checkset( EEG ); 
       EEG = pop_saveset( EEG, [subjectfolder newsetname]);
       [ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
end
        
        
        
        
        
        
    