% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin August 2021
% Operates on individual subject data
% This script loads the individual subject difference waveform measurement
% values, creates histogram plots of the single-participant measurement
% values for each measure of mean amplitude, and saves pdfs of all of the
% plots in the ERP Measurements folder.

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
Current_File_Path = '/Volumes/verb/EMPIA/Participant EEG Data/ERP Measurements';

%*************************************************************************************************************************************

% Specify the measurements that will be used to create histograms using text files (e.g., Mean_Amplitude_Diff_Waves.txt)
Measures = {'Mean_Amplitude'}; 

% Set the histogram bin edges (lower and upper limits for each bar) to be plotted for each measurement
Xranges = {-14:2:18};

% Loop through each measurement listed in Measures
for m = 1:length(Measures)
    
    meas = Measures{m};
    
    % Calculate center points of histogram bins based on bin edges specified above
    intervals = diff(Xranges{m});
    bincenters = Xranges{m}(1:end-1) + intervals/2;
    
    % Load the single-participant measurement values
    Meas_file = [Current_File_Path filesep meas '_LPC.txt'];
    Meas_table = readtable(Meas_file,'delimiter','\t','HeaderLines',1);
    Meas_data = Meas_table{:,1};
    
    % Create histogram plots (this is for difference waves only, so not
    % sure how to alter for my data ATM)
    [bincounts] = histcounts(Meas_data,Xranges{m});
    bar(bincenters,bincounts,0.75,'FaceColor',[0.2 0.2 0.5]);
    ylim([0 30]); xticks(bincenters); 
    ylabel('Number of Subjects')
    xlabel(strrep(meas,'_',' '))
    set(gca,'fontsize',12)
    legend({'Unrelated-Related'});
    
    % Saves the histogram plots to pdf
    save2pdf([Current_File_Path filesep meas '_Histogram_LPC.pdf']);
    close all
    
%End measures loop    
end

%*************************************************************************************************************************************
