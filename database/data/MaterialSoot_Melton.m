classdef MaterialSoot_Melton < MaterialProperties
    properties
        name                = 'Soot_Melton';
        
        %% constant properties
        molar_mass          = 0.012;        % [kg/mol]
        molar_mass_v        = 0.036;        % [kg/mol] - molar mass of vapor
        %rho_p              = f(T);         % [kg/m^3]         
        %H_v                = f(T);         % [J/mol]  
        alpha_T_eff         = 0.3;          % [-]         - Thermal accommodation coefficient for heat conduction
        theta_e             = 1;            % [-]         - Thermal accommodation coefficient for evaporation
      
        %C_p_mol            = f(T);         % [J/mol/K]   - Molar heat capacity
        %p_v                = notSet;       % [Pa]        - Vapor pressure
        %eps                = notSet        % [-]         - Total emissivity of a single particle (for Stefan-Boltzmann law)        
        
        p_v_ref             = 100000;       % [Pa] Clausius-Clapeyron - Reference pressure
        T_v_ref             = 3915;         % [K] Clausius-Clapeyron - Reference temperature
    end
    
    methods
        
        %% temperature-dependent properties 
        % (these properties need to be implemented as function,
        %  but this model only used constant properties)
        function res = rho_p(obj, T)            
           res = 2260; 
        end
        
        function res = C_p_mol(obj, T)            
           res = 22.8; 
        end
        
        function res = H_v(obj, T)
           res = 7.78E5; 
        end
    end
end