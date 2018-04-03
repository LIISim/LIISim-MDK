
%% LIISim - Model Development Kit
%
% This model development kit was written in MATLAB for comparison and 
% validation of the integrity of the implemented algorithms of 
% the LIISim 3 Desktop version (C++). For the MDK the same class
% structure is used and the functionalities are limited to simulation 
% of temperature traces using the same heat-transfer models and databases
% as of the C++ version. The MDK can be used for testing and developing 
% new models before they are integrated in the LIISim framework.
%
% See also: LIISim 3 Desktop (http://www.github.com/LIISim/LIISim3)  
%
% Most recent source code can be found on:
% http://www.github.com/LIISim/LIISim-MDK
%
% Version: 0.0.1 (2018-04-03)
% (c) 2018 by Raphael Mansmann and Philip Schmidt
%   
% Contact: raphael.mansmann@uni-due.de
%
% Licensed under the GNU public license. See LICENSE file in the 
% project root for full license information.
%

%% init Core class (session clearance, path settings,...)
clear all
core = Core();

% The usage of this script is shown by two example cases:
% 1) Soot LII - for three different heat transfer models
% 2) Silicon LII - Menster et al. (2016) heat transfer model and properties

% define which simulations should be performed
%dataset = 'SiliconLII';
dataset = 'SootLII';

switch dataset
    
    case 'SootLII'
      % numeric settings
        numeric = Numeric;
        numeric.start_time  = 194.0E-9;    % seconds
        numeric.dt          = 0.1E-9; % seconds
        numeric.sig_length  = 1500E-9; % seconds

        %% Init SimulationRuns
        initT   = 3500;
        initDp  = 35E-9;
        T_g     = 1730;
        p_g     = 100000;

        %% Simulation 1
        sim1 = SimRun('Kock_Soot_Nitrogen', numeric);
        sim1.initParameters(initT, initDp, T_g, p_g);
        sim1.summary();
        sim1.showHeatTransferRatesPeak();
        [T1, dp1] = sim1.simulateTraceEuler();
        [T2, dp2] = sim1.simulateTrace();

        
        %% Simulation 2 (different HTM, same conditions)
        %numeric.dt          = 0.1E-9;
        sim2 = SimRun('Liu_Soot', numeric);
        sim2.initParameters(initT, initDp, T_g, p_g);
        sim2.summary();
        sim2.showHeatTransferRatesPeak();

        [T3, dp3] = sim2.simulateTraceEuler();
        [T4, dp4] = sim2.simulateTrace();


        %% Simulation 3 (different HTM, same conditions)
        sim3 = SimRun('Melton_Soot', numeric);
        sim3.initParameters(initT, initDp, T_g, p_g);
        sim3.showHeatTransferRatesPeak();

        [T5, dp5] = sim3.simulateTraceEuler();
        [T6, dp6] = sim3.simulateTrace();

        %% visualize results
        plot1 = PlotTools(1, 'Simulated temperature decay');
        plot1.setHold();
        plot1.plotTemperature(T1, 'Kock Euler');
        plot1.plotTemperature(T2, 'Kock ode45');
        plot1.plotTemperature(T3, 'Liu Euler');
        plot1.plotTemperature(T4, 'Liu ode45');
        plot1.plotTemperature(T5, 'Melton Euler');
        plot1.plotTemperature(T6, 'Melton ode45');

        plot2 = PlotTools(2, 'Simulated particle diameter over time');
        plot2.setHold();
        plot2.plotDp(dp1, 'Kock Euler');
        plot2.plotDp(dp2, 'Kock ode45');
        plot2.plotDp(dp3, 'Liu Euler');
        plot2.plotDp(dp4, 'Liu ode45');
        plot2.plotDp(dp5, 'Melton Euler');
        plot2.plotDp(dp6, 'Melton ode45');
        
        
        %% Plot 3: show overlay with imported .mat file (LIISim MATLAB export)
        
        % load .mat file (this was exported from the LIISim Desktop software)
        mrun = MRun.loadFromFile('exampleData/1p0_MSA.mat');
        
        % define time of signal peak [s]
        exp_start_time = 2020E-9;
        exp_end_time   = exp_start_time + 2E-6; % + 2 us 
        
        % get section of temperature trace
        start_index = mrun.mpoints(1).temperature_unprocessed(1).indexAt(exp_start_time);
        end_index   = mrun.mpoints(1).temperature_unprocessed(1).indexAt(exp_end_time);
        
        T_exp            = Signal;
        T_exp.start_time = 0; % T1.start_time;
        T_exp.dt         = mrun.mpoints(1).temperature_unprocessed(1).dt;
        T_exp.data       = mrun.mpoints(1).temperature_unprocessed(1).data(start_index:end_index);
                                
        plot3 = PlotTools(3, 'Comparison between a simulated and experimental temperature traces');
        plot3.setHold();
        plot3.plotTemperature(T_exp, 'Experimental Temperature (LIISim MATLAB Export');
        plot3.plotTemperature(T1, 'Kock Euler');
        
    case 'SiliconLII'
                
        % numeric settings
        numeric = Numeric;
        numeric.start_time  = 0E-9;    % seconds
        numeric.dt          = 1E-9; % seconds
        numeric.sig_length  = 800E-9; % seconds

        %% Init SimulationRuns
        initT   = 3400;
        initDp  = 25E-9;
        T_g     = 1560;
        p_g     = 10000; % 100 mbar                               
        
        %% Simulation 1
        sim1 = SimRun('Menser_Silicon_Ar', numeric);
        %sim1 = SimRun('Menser_Silicon_ArH2', numeric);
        
        % Overwrite Properties
        %sim1.gasmixture.gases{1}.alpha_T = 0.2;
        
        sim1.initParameters(initT, initDp, T_g, p_g);
        sim1.summary();
        sim1.showHeatTransferRatesPeak();
        [T1, dp1] = sim1.simulateTraceEuler();
        [T2, dp2] = sim1.simulateTrace();

        plotResults = true;
        
        %% visualize results
        if plotResults == true
            plot1 = PlotTools(1, 'Simulated temperature decay');
            plot1.setHold();
            plot1.plotTemperature(T1, 'Menser Euler');
            plot1.plotTemperature(T2, 'Menser ode45');

            plot2 = PlotTools(2, 'Simulated particle diameter over time');
            plot2.setHold();
            plot2.plotDp(dp1, 'Menser Euler');
            plot2.plotDp(dp2, 'Menser ode45');           
        end   
end
