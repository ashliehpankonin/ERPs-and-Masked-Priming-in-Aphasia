% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin August 2021
% Operates on data averaged across participants
% This script loads the low-pass filtered grand average ERP waveforms,
% plots the grand average waveforms, ICA-corrected and uncorrected HEOG,
% and ICA-corrected VEOG, and saves .jpg files of all of the plots in the grand
% average ERPs folder.

close all; clearvars;

% Location of the main study directory
% This method of specifying the study directory only works if you run the
% script; for running individual lines of code, replace the study directory
% with the path on your computer, e.g.: 
% DIR = /Users/KappenmanLab/ERP_CORE/N400
% DIR = fileparts(fileparts(mfilename('fullpath'))); 
DIR = '/Volumes/verb/EMPIA/Participant EEG Data';

% Location of the folder that contains this script and any associated processing files
% This method of specifying the current file path only works if you run the
% script; for running individual lines of code, replace the current file
% path with the path on your computer, e.g.: 
% Current_File_Path = /Users/KappenmanLab/ERP_CORE/N400/EEG_ERP_Processing/Grand_Average_ERPs
% Current_File_Path = fileparts(mfilename('fullpath'));
Current_File_Path = '/Volumes/verb/EMPIA/Participant EEG Data/Grand Averages';

%*************************************************************************************************************************************

% Set baseline correction period in milliseconds
baselinecorr = '-100 0';

% Set x-axis scale in milliseconds
xscale = [-100.0 1180.0   -100:100:1180];

% Set y-axis scale in microvolts for the EEG channels for the waves
yscale_EEG_parent = [-5.0 5.0   -5:1.25:5]; %[-10.0 15.0   -10:5:15];

% Set y-axis scale in microvolts for the ICA-corrected and uncorrected bipolar HEOG channels
yscale_HEOG = [-5.0 10.0   -5:1.25:10]; %[-15.0 15.0   -15:5:15];

% Set y-axis scale in microvolts for the ICA-corrected monopolar VEOG signals and corrected bipolar VEOG signal
yscale_VEOG = [-5.0 10.0   -5:1.25:10]; %[-25.0 25.0   -25:10:25];

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Load the low-pass filtered grand average ERP waveforms in .erp ERPLAB
% file format        
ERP = pop_loaderp('filename', 'GA_ERPs_lpfilt_OldCons_not117ort125.erp', 'filepath', Current_File_Path);    


%%% Animal Primes vs. Non-animal Primes %%%
% Plot the animal primes and non-animal primes individual waveforms at the key electrode sites of interest (F7, FC5, C5, CP5, O1, Pz, Fz, F8, FC6, Cz, C6, CP6, O2)
ERP = pop_ploterps( ERP, [1 2], [7 9 14 17 27 31 38 42 44 48 51 54 64] , 'Box', [4 4], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
saveas(gcf,[Current_File_Path filesep 'GA_AnimalvsNonanimalPrimes_Waves_OldCons_not117ort125_lpfilt.jpg']);
close all

% % Plot the animal primes and non-animal primes individual waveforms at all electrode sites
% ERP = pop_ploterps( ERP, [1 2], [1:67] , 'Box', [8 9], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
% saveas(gcf,[Current_File_Path filesep 'GA_AnimalvsNonanimalPrimes_Waves_AllChans_OldCons_not117ort125_lpfilt.jpg']);
% close all
% 
% % Plot the individual (animal primes and non-animal primes conditions)
% % ICA-corrected and uncorrected bipolar HEOG signals (only ICA-corrected
% % non-bipolar channels here)
% ERP = pop_ploterps( ERP, [1 2], [67] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_HEOG);
% saveas(gcf,[Current_File_Path filesep 'GA_AnimalvsNonanimalPrimes_ROC_OldCons_not117ort125_lpfilt.jpg']);
% close all
% 
% % Plot the individual (animal primes and non-animal primes conditions)
% % ICA-corrected monopolar VEOG signals and corrected bipolar VEOG
% % signal (only ICA-corrected non-bipolar channels here)
% ERP = pop_ploterps( ERP, [1 2], [66] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_VEOG);
% saveas(gcf,[Current_File_Path filesep 'GA_AnimalvsNonanimalPrimes_LIO_OldCons_not117ort125_lpfilt.jpg']);
% close all


%%% Animal Targets vs. Non-animal Targets %%%
% Plot the animal targets and non-animal targets individual waveforms at the key electrode sites of interest (F7, FC5, C5, CP5, O1, Pz, Fz, F8, FC6, Cz, C6, CP6, O2)
ERP = pop_ploterps( ERP, [3 4], [7 9 14 17 27 31 38 42 44 48 51 54 64] , 'Box', [4 4], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
saveas(gcf,[Current_File_Path filesep 'GA_AnimalvsNonanimalTargets_Waves_OldCons_not117ort125_lpfilt.jpg']);
close all

% % Plot the animal targets and non-animal targets individual waveforms at all electrode sites
% ERP = pop_ploterps( ERP, [3 4], [1:67] , 'Box', [8 9], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
% saveas(gcf,[Current_File_Path filesep 'GA_AnimalvsNonanimalTargets_Waves_AllChans_OldCons_not117ort125_lpfilt.jpg']);
% close all
% 
% % Plot the individual (animal targets and non-animal targets conditions)
% % ICA-corrected and uncorrected bipolar HEOG signals (only ICA-corrected
% % non-bipolar channels here)
% ERP = pop_ploterps( ERP, [3 4], [67] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_HEOG);
% saveas(gcf,[Current_File_Path filesep 'GA_AnimalvsNonanimalTargets_ROC_OldCons_not117ort125_lpfilt.jpg']);
% close all
% 
% % Plot the individual (animal targets and non-animal targets conditions)
% % ICA-corrected monopolar VEOG signals and corrected bipolar VEOG
% % signal (only ICA-corrected non-bipolar channels here)
% ERP = pop_ploterps( ERP, [3 4], [66] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_VEOG);
% saveas(gcf,[Current_File_Path filesep 'GA_AnimalvsNonanimalTargets_LIO_OldCons_not117ort125_lpfilt.jpg']);
% close all


%%% Immediate Masked Primes vs. No (Unrelated) Primes %%%
% Plot the immediate masked primes and no (unrelated) primes individual waveforms at the key electrode sites of interest (F7, FC5, C5, CP5, O1, Pz, Fz, F8, FC6, Cz, C6, CP6, O2)
ERP = pop_ploterps( ERP, [5 6], [7 9 14 17 27 31 38 42 44 48 51 54 64] , 'Box', [4 4], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
saveas(gcf,[Current_File_Path filesep 'GA_ImmMaskedPrimesvsNoPrimes_Waves_OldCons_not117ort125_lpfilt.jpg']);
close all

% % Plot the immediate masked primes and no (unrelated) primes individual waveforms at all electrode sites
% ERP = pop_ploterps( ERP, [5 6], [1:67] , 'Box', [8 9], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
% saveas(gcf,[Current_File_Path filesep 'GA_ImmMaskedPrimesvsNoPrimes_Waves_AllChans_OldCons_not117ort125_lpfilt.jpg']);
% close all
% 
% % Plot the individual (immediate masked primes and no (unrelated) primes conditions)
% % ICA-corrected and uncorrected bipolar HEOG signals (only ICA-corrected
% % non-bipolar channels here)
% ERP = pop_ploterps( ERP, [5 6], [67] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_HEOG);
% saveas(gcf,[Current_File_Path filesep 'GA_ImmMaskedPrimesvsNoPrimes_ROC_OldCons_not117ort125_lpfilt.jpg']);
% close all
% 
% % Plot the individual (immediate masked primes and no (unrelated) primes conditions)
% % ICA-corrected monopolar VEOG signals and corrected bipolar VEOG
% % signal (only ICA-corrected non-bipolar channels here)
% ERP = pop_ploterps( ERP, [5 6], [66] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_VEOG);
% saveas(gcf,[Current_File_Path filesep 'GA_ImmMaskedPrimesvsNoPrimes_LIO_OldCons_not117ort125_lpfilt.jpg']);
% close all


%%% Delayed Masked Primes vs. No Primes %%%
% Plot the delayed masked primes and no primes individual waveforms at the key electrode sites of interest (F7, FC5, C5, CP5, O1, Pz, Fz, F8, FC6, Cz, C6, CP6, O2)
ERP = pop_ploterps( ERP, [7 4], [7 9 14 17 27 31 38 42 44 48 51 54 64] , 'Box', [4 4], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
saveas(gcf,[Current_File_Path filesep 'GA_DelMaskedPrimesvsNoPrimes_Waves_OldCons_not117ort125_lpfilt.jpg']);
close all

% % Plot the delayed masked primes and no primes individual waveforms at all electrode sites
% ERP = pop_ploterps( ERP, [7 4], [1:67] , 'Box', [8 9], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
% saveas(gcf,[Current_File_Path filesep 'GA_DelMaskedPrimesvsNoPrimes_Waves_AllChans_OldCons_not117ort125_lpfilt.jpg']);
% close all
% 
% % Plot the individual (delayed masked primes and no primes conditions)
% % ICA-corrected and uncorrected bipolar HEOG signals (only ICA-corrected
% % non-bipolar channels here)
% ERP = pop_ploterps( ERP, [7 4], [67] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_HEOG);
% saveas(gcf,[Current_File_Path filesep 'GA_DelMaskedPrimesvsNoPrimes_ROC_OldCons_not117ort125_lpfilt.jpg']);
% close all
% 
% % Plot the individual (delayed masked primes and no primes conditions)
% % ICA-corrected monopolar VEOG signals and corrected bipolar VEOG
% % signal (only ICA-corrected non-bipolar channels here)
% ERP = pop_ploterps( ERP, [7 4], [66] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_VEOG);
% saveas(gcf,[Current_File_Path filesep 'GA_DelMaskedPrimesvsNoPrimes_LIO_OldCons_not117ort125_lpfilt.jpg']);
% close all


%%% Delayed Visible Primes vs. No Primes %%%
% Plot the delayed visible primes and no primes individual waveforms at the key electrode sites of interest (F7, FC5, C5, CP5, O1, Pz, Fz, F8, FC6, Cz, C6, CP6, O2)
ERP = pop_ploterps( ERP, [8 4], [7 9 14 17 27 31 38 42 44 48 51 54 64] , 'Box', [4 4], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
saveas(gcf,[Current_File_Path filesep 'GA_DelVisPrimesvsNoPrimes_Waves_OldCons_not117ort125_lpfilt.jpg']);
close all

% % Plot the delayed visible primes and no primes individual waveforms at all electrode sites
% ERP = pop_ploterps( ERP, [8 4], [1:67] , 'Box', [8 9], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
% saveas(gcf,[Current_File_Path filesep 'GA_DelVisPrimesvsNoPrimes_Waves_AllChans_OldCons_not117ort125_lpfilt.jpg']);
% close all
% 
% % Plot the individual (delayed visible primes and no primes conditions)
% % ICA-corrected and uncorrected bipolar HEOG signals (only ICA-corrected
% % non-bipolar channels here)
% ERP = pop_ploterps( ERP, [8 4], [67] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_HEOG);
% saveas(gcf,[Current_File_Path filesep 'GA_DelVisPrimesvsNoPrimes_ROC_OldCons_not117ort125_lpfilt.jpg']);
% close all
% 
% % Plot the individual (delayed visible primes and no primes conditions)
% % ICA-corrected monopolar VEOG signals and corrected bipolar VEOG
% % signal (only ICA-corrected non-bipolar channels here)
% ERP = pop_ploterps( ERP, [8 4], [66] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_VEOG);
% saveas(gcf,[Current_File_Path filesep 'GA_DelVisPrimesvsNoPrimes_LIO_OldCons_not117ort125_lpfilt.jpg']);
% close all


%%% Delayed Masked Primes vs. Delayed Visible Primes %%%
% Plot the delayed masked primes and delayed visible primes individual waveforms at the key electrode sites of interest (F7, FC5, C5, CP5, O1, Pz, Fz, F8, FC6, Cz, C6, CP6, O2)
ERP = pop_ploterps( ERP, [7 8], [7 9 14 17 27 31 38 42 44 48 51 54 64] , 'Box', [4 4], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
saveas(gcf,[Current_File_Path filesep 'GA_DelMaskedPrimesvsDelVisPrimes_Waves_OldCons_not117ort125_lpfilt.jpg']);
close all

% % Plot the delayed masked primes and delayed visible primes individual waveforms at all electrode sites
% ERP = pop_ploterps( ERP, [7 8], [1:67] , 'Box', [8 9], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
% saveas(gcf,[Current_File_Path filesep 'GA_DelMaskedPrimesvsDelVisPrimes_Waves_AllChans_OldCons_not117ort125_lpfilt.jpg']);
% close all
% 
% % Plot the individual (delayed masked primes and delayed visible primes conditions)
% % ICA-corrected and uncorrected bipolar HEOG signals (only ICA-corrected
% % non-bipolar channels here)
% ERP = pop_ploterps( ERP, [7 8], [67] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_HEOG);
% saveas(gcf,[Current_File_Path filesep 'GA_DelMaskedPrimesvsDelVisPrimes_ROC_OldCons_not117ort125_lpfilt.jpg']);
% close all
% 
% % Plot the individual (delayed masked primes and delayed visible primes conditions)
% % ICA-corrected monopolar VEOG signals and corrected bipolar VEOG
% % signal (only ICA-corrected non-bipolar channels here)
% ERP = pop_ploterps( ERP, [7 8], [66] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_VEOG);
% saveas(gcf,[Current_File_Path filesep 'GA_DelMaskedPrimesvsDelVisPrimes_LIO_OldCons_not117ort125_lpfilt.jpg']);
% close all

%*************************************************************************************************************************************
