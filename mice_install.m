%% MICE INSTALLATION %%

% MATLAB environment
clear
clc
close all

if isfile("mice_install.m")
    % SAVE INSTALL TO PATH
    copyfile("mice_install.m",userpath)
    % SAVE PATH TREE
    writelines(["function mice_home_path = mice_home()",join(["mice_home_path = '",pwd,"';"],''),"end"],'mice_home.m')
    movefile('mice_home.m',userpath)
end

% Path
addpath(genpath(mice_home))

% DISPLAY
fprintf(['*** MICE installed. Have fun! ***\n'])
