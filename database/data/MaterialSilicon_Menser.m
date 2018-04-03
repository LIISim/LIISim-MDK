classdef MaterialSilicon_Menser < MaterialProperties
    % J. Menser, K. Daun, T. Dreier, and C. Schulz, 
    % "Laser-induced incandescence from laser-heated silicon nanoparticles," 
    % Appl. Phys. B 122, 277 (2016).
    
    properties
        name                = 'Silicon_Menser';
        
        %% constant properties
        molar_mass          = 0.0280855;    % [kg/mol]
        molar_mass_v        = 0.0280855;    % [kg/mol]    - molar mass of vapor
        %rho_p              = f(T);         % [kg/m^3]         
        H_v                 = 389000;       % [J/mol]  
        %alpha_T_eff        = 0.3;          % [-]         - Thermal accommodation coefficient for heat conduction
        %theta_e            = notSet;       % [-]         - Thermal accommodation coefficient for evaporation
      
        %C_p_mol            = f(T);         % [J/mol/K]   - Molar heat capacity
        %p_v                = f(T);         % [Pa]        - Vapor pressure
        %eps                = notSet;       % [-]         - Total emissivity of a single particle (for Stefan-Boltzmann law)        
        
        %p_v_ref            = notSet;       % [Pa] Clausius-Clapeyron - Reference pressure
        %T_v_ref            = notSet;       % [K] Clausius-Clapeyron - Reference temperature
        
        %% Spectroscopic (only for temperature calculation)
        omega_p             = 2.68E16;      % [rad/s] - plasma frequency (used by Drude function)
        tau                 = 2.18E-16;     % [s] - relaxation time (used by Drude function)
            
    end
    
    methods
        
        %% temperature-dependet properties
        function res = C_p_mol(obj, T)
            res = 27.28;
        end
        
        function res = rho_p(obj, T)            
            res = 2995.368 - 0.264 * T;
        end
        
        function res = p_v(obj, T)
            % type: powx
            a0 = 0;
            a1 = 1;
            a2 = 10;
            a3 = 10.94;
            a4 = -20567;
            a5 = 0;
            
            res = a0 + a1 * a2^(a3 + a4/T + a5*T);            
        end
    end
end