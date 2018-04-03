classdef MaterialSoot_Liu < MaterialProperties
    properties
        name                = 'Soot_Liu';
        
        %% constant properties
        molar_mass          = 0.012011;     % [kg/mol]
        %molar_mass_v       = f(T);         % [kg/mol] - molar mass of vapor
        %rho_p              = f(T);         % [kg/m^3]         
        %H_v                = f(T);            % [J/mol]  
        alpha_T_eff         = 0.37;         % [-]         - Thermal accommodation coefficient for heat conduction
        theta_e             = 0.77;         % [-]         - Thermal accommodation coefficient for evaporation
      
        %C_p_mol            = f(T);         % [J/mol/K]   - Molar heat capacity
        %p_v                = f(T);         % [Pa]        - Vapor pressure
        eps                 = 0.4;          % [-]         - Total emissivity of a single particle (for Stefan-Boltzmann law)        
        
        %p_v_ref             = notSet;      % [Pa] Clausius-Clapeyron - Reference pressure
        %T_v_ref             = notSet;      % [K] Clausius-Clapeyron - Reference temperature
    end
    
    methods
        
        %% temperature-dependet properties
        function res = molar_mass_v(obj, T)     
            
            % H. R. Leider, O. H. Krikorian, and D. A. Young, 
            % "Thermodynamic properties of carbon up to the critical point," 
            % Carbon 11, 555-563 (1973).
            
            res = 0.017179 ...              %a0
                    + 6.8654E-7 * T ...     %a1
                    + 2.9962E-9 * T^2 ...   %a2
                    - 8.5954E-13 * T^3 ...  %a3
                    + 1.0486E-16 * T^4;     %a4
        end
        
        function res = rho_p(obj, T)            
           res = 1900; 
        end
        
        function res = C_p_mol(obj, T)            
           % valid for 1200 K to 5500 K
            res = 3.54288 ...               %a0
                    + 0.0355694 * T ...     %a1
                    - 2.55018E-5* T^2 ...   %a2
                    + 9.83713E-9 * T^3 ...  %a3
                    - 2.10385E-12 * T^4 ... %a4
                    + 2.35752E-16 * T^5 ... %a5
                    - 1.07879E-20 * T^6;    %a6
        end
        
        function res = H_v(obj, T)
            
            res = 2.05398E5 ...             %a0
                    + 7.366E2 * T ...       %a1
                    - 0.40713 * T^2 ...     %a2
                    + 1.1992E-4 * T^3 ...   %a3
                    - 1.7946E-8 * T^4 ...   %a4
                    + 1.0717E-12 * T^5;     %a5
        end
        
         function res = p_v(obj, T)
             
            % H. R. Leider, O. H. Krikorian, and D. A. Young, 
            % "Thermodynamic properties of carbon up to the critical point," 
            % Carbon 11, 555-563 (1973).
            
            res = 0.0 ...                       %a0
                    + 101325 ...                %a1 (unit conversion from atm to Pa)
                    * exp(- 122.96 ...          %a2
                        + 9.0558E-2 * T ...     %a3
                        - 2.7637E-5 * T^2 ...   %a4
                        + 4.1754E-9 * T^3 ...   %a5
                        - 2.4875E-13 * T^4);    %a6
        end
        
    end
end