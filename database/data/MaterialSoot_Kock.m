classdef MaterialSoot_Kock < MaterialProperties
    properties
        name                = 'Soot_Kock';
        
        %% constant properties
        molar_mass          = 0.012011;     % [kg/mol]
        molar_mass_v        = 0.036033;     % [kg/mol] - molar mass of vapor
        %rho_p              = f(T);         % [kg/m^3]         
        %H_v                = f(T);         % [J/mol]  
        alpha_T_eff         = 0.23;         % [-]         - Thermal accommodation coefficient for heat conduction
        theta_e             = 1;            % [-]         - Thermal accommodation coefficient for evaporation
      
        %C_p_mol            = f(T);         % [J/mol/K]   - Molar heat capacity
        %p_v                = notSet;       % [Pa]        - Vapor pressure
        eps                 = 1;            % [-]         - Total emissivity of a single particle (for Stefan-Boltzmann law)        
        
        p_v_ref             = 61.5;         % [Pa] Clausius-Clapeyron - Reference pressure
        T_v_ref             = 3000;         % [K] Clausius-Clapeyron - Reference temperature
    end
    
    methods
        
        %% temperature-dependent properties
        function res = rho_p(obj, T)            
           res = 1860; 
        end
        
        function res = C_p_mol(obj, T)            
           res = 22.5566 ...
                + 0.0013 * T ...
                - 1.8195E6 / T^2; 
        end
        
        function res = H_v(obj, T)
           res = 790776.6; 
        end
    end
end