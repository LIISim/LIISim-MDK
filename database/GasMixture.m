classdef GasMixture < handle
%% gas mixture properties

    properties
        name;        % name of gas mixture
        gases;         % array of GasProperties instances
        x;           % array of mole fractions
        molar_mass  = 0;               
    end
    
    methods        
        function obj = GasMixture(mixname, gasnames, x) 
            
            obj.name = mixname;
            obj.x = x;
                        
            for i = 1: length(gasnames)
                
                switch gasnames{i}
                    % general
                    case 'Argon'
                        obj.gases{i} = GasArgon;    
                    case 'Nitrogen'
                        obj.gases{i} = GasNitrogen;
                    % individual
                    case 'FlameLiu' % used by Liu
                        obj.gases{i} = GasFlame_Liu;                    
                    case 'NitrogenKock' % used by Kock
                        obj.gases{i} = GasNitrogen_Kock;
                    case 'NitrogenMelton' %used by Melton
                        obj.gases{i} = GasNitrogen_Melton;
                    case 'ArgonMenser' %used by Menser
                        obj.gases{i} = GasArgon_Menser;
                    case 'HydrogenMenser' %used by Menser
                        obj.gases{i} = GasHydrogen_Menser;
                end              
                
                obj.molar_mass  = obj.molar_mass + obj.x(i) * obj.gases{i}.molar_mass;
            end            
        end
        
        function res = c_tg(obj, T_gas)
            %% thermal velocity of gas molecules [m/s]
            res =  sqrt(8 * Constants.k_B * T_gas / pi ...
                    / obj.molar_mass * Constants.N_A);             
        end
        
        function res = gamma(obj, T, T_gas)
             %% heat capacity ratio - [-]
              
             res = obj.C_p_mol(T_gas) / (obj.C_p_mol(T_gas) - Constants.R);
        end
       
        function res = C_p_mol(obj, T)
            %% molar heat capacity - [J/mol/K]
            res = 0;
            for i = 1: length(obj.gases)
                res = res + obj.x(i) * obj.gases{i}.C_p_mol(T);
            end
        end
                
        %%  only for Liu model:
        function res = gamma_eqn(obj, T)            
                    
            % F. Liu, K. J. Daun, D. R. Snelling, and G. J. Smallwood, 
            % "Heat conduction from a spherical nano-particle: status of 
            % modeling heat conduction in laser-induced incandescence," 
            % Appl. Phys. B 83, 355-382 (2006).            
            res = 1.4221163416 ...                  %a0
                    - 1.8636002383E-4   * T ...     %a1
                    + 8.0783894569E-8   * T^2 ...   %a2
                    - 1.6425082302E-11  * T^3 ...   %a3
                    + 1.2750021975E-15  * T^4;      %a4 
        end
        
        
        %% only for Melton model:        
        function res = L(obj, T)
            % free mean path [m]
            res = 0.0 ...            %a0
                  + 2.355E-10 * T;   %a1
        end
        
        function res = therm_cond(obj, T)
            % thermal conductivity [W/m/K]
            res = 0.1068;           %a0
        end

    end    
end