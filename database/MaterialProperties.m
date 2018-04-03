classdef MaterialProperties < handle
%% material properties (general)
    
    % mandatory properties to be implemented in sub classes
    properties (Abstract)
        name;
    end
    
    properties        
%% this properties are implemented as variable (f(T)=const) or function f(T) in the sub classes
%      molar_mass      [kg/mol]    - Molar mass
%      molar_mass_v    [kg/mol]    - Molar mass of vapor species
%      rho_p           [kg/m^3]    - Particle density
%      H_v             [J/mol]     - Evaporation enthalpy
%      
%      alpha_T_eff     [-]         - Effective thermal accommodation coefficient for heat conduction
%      theta_e         [-]         - Thermal accommodation coefficient for evaporation
%      
%      C_mol_p         [J/mol/K]   - Molar heat capacity
%      p_v             [Pa]        - Vapor pressure
%      
%      eps             [-]         - Total emissivity of a single particle (for Stefan-Boltzmann law)
%      Em              [-]         - E(m) - Absorption function at fixed wavelength lambda
%      Em_func         [-]         - E(m) - Absorption function as function of wavelength lambda
%      p_v_ref         [Pa] Clausius-Clapeyron - Reference pressure
%      T_v_ref         [K] Clausius-Clapeyron - Reference temperature
    end
    
    % mandatory properties to be reimplemented 
    % (required by HeatTransferModel base class)
    methods (Abstract)
        res = C_p_mol(obj, T); 
        res = rho_p(obj, T);
    end
    
    methods 
        function res = c_p_kg(obj, temperature)            
            
            res = obj.C_p_mol(temperature) / obj.molar_mass;            
        end
        
        function res = c_tv(obj, temperature)
            
            res = sqrt(8.0 * Constants.k_B ...
                * temperature ...
                / pi / obj.molar_mass_v ...
                * Constants.N_A);
        end
        
        function res = vapor_pressure(obj, temperature)
                        
            res = obj.p_v_ref ...
                   * exp( -1.0 * obj.H_v(temperature) ...
                   / Constants.R ...
                   * (1.0 / temperature - 1.0 / obj.T_v_ref) ...
                   );
        end        
    end 
    
end
