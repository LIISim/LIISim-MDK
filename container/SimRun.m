classdef SimRun < handle
    %SIMRUN contains all necessary information for simulation of
    %temperature traces
        
    properties
        name;       % name of SimRun, determines HTM, material and gas mixture
        numeric;    % numeric settings (Numeric)
        
        htm;        % heat transfer model (HeatTransferModel)
        gasmixture; % gas mixture (GasMixture)
        material;   % material of particle (MaterialProperties)
        
        initT;      % peak temperature [K]
        initDp;     % peak particle diameter [m]
    end
    
    methods
        function obj = SimRun(name, numeric)
            
            obj.name = name;
            obj.numeric = numeric;
            
            % Heat transfer model, material and gas mixture 
            switch name
                % soot LII
                case 'Kock_Soot_Nitrogen' % used for LII measurements in flames
                    obj.material    = MaterialSoot_Kock; 
                    obj.gasmixture  = GasMixture('Nitrogen100%',{'NitrogenKock'}, [1]);                     
                    obj.htm = HTM_Kock(obj.material, obj.gasmixture);
                    
                case 'Kock_Soot_Argon' % used for LII measurements on particle generator
                    obj.material    = MaterialSoot_Kock; 
                    obj.gasmixture  = GasMixture('Argon100%',{'Argon'}, [1]);                    
                    obj.htm = HTM_Kock(obj.material, obj.gasmixture);                    
                    
                case 'Liu_Soot' 
                    obj.material    = MaterialSoot_Liu; 
                    obj.gasmixture  = GasMixture('FlameAir',{'FlameLiu'}, [1]);                    
                    obj.htm = HTM_Liu(obj.material, obj.gasmixture);                    
                    
                case 'Melton_Soot'
                    obj.material    = MaterialSoot_Melton; 
                    obj.gasmixture  = GasMixture('Nitrogen100%',{'NitrogenMelton'}, [1]);                     
                    obj.htm = HTM_Melton(obj.material, obj.gasmixture);                    
                    
                % non-soot LII
                case 'Menser_Silicon_Ar'
                    obj.material    = MaterialSilicon_Menser; 
                    obj.gasmixture  = GasMixture('ProcessMixtureAr_100%',{'ArgonMenser'}, [1]);                     
                    obj.htm = HTM_Menser(obj.material, obj.gasmixture);         
                    
                case 'Menser_Silicon_ArH2'
                    obj.material    = MaterialSilicon_Menser; 
                    obj.gasmixture  = GasMixture('ProcessMixtureAr_93%/H2_7%',{'ArgonMenser', 'HydrogenMenser'}, [0.93, 0.07]);                     
                    obj.htm = HTM_Menser(obj.material, obj.gasmixture);           
            end                
        end 
        
        % initial modeling conditions
        function initParameters(obj, initT, initDp, T_g, p_g)
            obj.initT   = initT;    % peak temperature [K]
            obj.initDp  = initDp;   % peak particle diameter [m]
            obj.htm.T_g = T_g;      % gas temperature [K]
            obj.htm.p_g = p_g;      % process pressure [Pa]            
        end
                
        function [T, dp] = simulateTrace(obj)
           [T, dp] = obj.numeric.ode_solver(obj.htm, obj.initT, obj.initDp); 
        end
        
        function [T, dp] = simulateTraceEuler(obj)
           [T, dp] = obj.numeric.ode_euler(obj.htm, obj.initT, obj.initDp); 
        end
        
        function showHeatTransferRatesPeak(obj)
            obj.showHeatTransferRates(obj.initT, obj.initDp);
        end
        
        function showHeatTransferRates(obj, T, dp)
            %% heat transfer rates [J/s] for T and dp
            evap = obj.htm.calculateEvaporation(T, dp);
            cond = obj.htm.calculateConduction(T, dp);
            rad  = obj.htm.calculateRadiation(T, dp);

            disp(['Heat transfer rates [J/s] for SimRun: ' obj.name ...
                ' (T=' num2str(T) ', dp=' num2str(dp) ')']);
            disp(['  Evaporation: ' 09 num2str(evap)]);
            disp(['  Conduction: ' 09 num2str(cond)]);
            disp(['  Radiation: ' 09 num2str(rad)]);
            
        end
        
        function summary(obj)            
            disp(['------------------------------------']);
            disp([09 'Simulation Run Summary: '  inputname(1)]);
            disp(['------------------------------------']);
            disp(['  Material: ' 09 09 09 obj.material.name]); % ASCII 09 == \tab
            disp(['  GasMixure: ' 09 09 09 obj.gasmixture.name]);
            disp(['  HeatTransferModel: ' 09 obj.htm.name]);            
            disp(['  Numeric step size: ' 09 num2str(obj.numeric.dt*1e9) ' ns']);            
            disp(['  GasTemperature: ' 09 09 num2str(obj.htm.T_g) ' K']);
            disp(['  Pressure: ' 09 09 09 num2str(obj.htm.p_g) ' Pa']);
        end        
    end    
end

