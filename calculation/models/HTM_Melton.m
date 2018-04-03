classdef HTM_Melton < HeatTransferModel
        
    properties        
        name = 'Soot_Melton';
        sysfunc = 'dT_ddp';
    end
    
    methods        
        
         function obj = HTM_Melton(material, gasmix)              
             obj.material   = material;
             obj.gasmixture = gasmix;             
         end
         
         function result = calculateEvaporation(obj, T, dp)        
            % This model uses molar mass of solid species (molar_mass)    
            result = -1.0 * obj.material.H_v(T) ...
                    / obj.material.molar_mass ...
                    * obj.calculateMassLossEvap(T, dp);
         end
         
         function result = calculateConduction(obj, T, dp)
             % this model uses:
             %  - L: free mean path of gas
             %  - therm_cond: thermal conductivity of gas
                          
            % Eucken correction f to the thermal conductivity
            f = 0.25 * (9.0 * obj.gasmixture.gamma(T, obj.T_g) - 5.0);

            % geometry-dependent heat-transfer factor G
            G = 8.0 * f / (obj.material.alpha_T_eff ...
                * (obj.gasmixture.gamma(T, obj.T_g) + 1.0));

            result = 2.0 * obj.gasmixture.therm_cond(obj.T_g) ...
                    * pi * dp^2 ...
                    / (dp + G * obj.gasmixture.L(obj.T_g)) ...
                    * (T - obj.T_g);                         
         end
         
         function result = calculateRadiation(obj, T, dp)
              result = 0; % no radiation included
         end
         
         
         function result = calculateMassLossEvap(obj, T, dp)

            result =  -1.0 * pi * dp^2 ...
                    * obj.material.molar_mass_v ...
                    * obj.material.theta_e ...
                    * obj.material.vapor_pressure(T) ...
                    / Constants.R / T ...
                    * sqrt(0.5 * Constants.R * T ...
                        / obj.material.molar_mass_v);                
         end         
    end
    
end        


