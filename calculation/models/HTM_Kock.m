classdef HTM_Kock < HeatTransferModel
    %HTM_KOCK Heat transfer model by Boris Kock - PhD thesis (2006)
    %   Boris Kock - Soot heat transfer model (evaporation via Clausius-Clapeyron)
    %   Zeitaufgelöste Laserinduzierte Inkandeszenz (TR-LII): 
    %   Partikelgrößenmessung in einem Dieselmotor und einem Gasphasenreaktor (Cuvillier, 2006)
    
    properties        
        name = 'Soot_Kock';
        sysfunc = 'dT_ddp';
    end
    
    methods        
        
         function obj = HTM_Kock(material, gasmix) 
             
             obj.material   = material;
             obj.gasmixture = gasmix;             
         end
         
         function result = calculateEvaporation(obj, T, dp)
            
            % PhD Thesis Kock (page 11):    
            result = -1.0 * obj.material.H_v(T) ...
                    / obj.material.molar_mass_v ...
                    * obj.calculateMassLossEvap(T, dp);
         end
         
         function result = calculateConduction(obj, T, dp)
            
            result = obj.material.alpha_T_eff ...
            * pi * dp^2 * obj.p_g / 8.0 ...
            * obj.gasmixture.c_tg(obj.T_g) ...
            * (obj.gasmixture.gamma(T, obj.T_g) + 1.0) ... 
            / (obj.gasmixture.gamma(T, obj.T_g) - 1.0) ...
            * (T / obj.T_g - 1.0);
                         
         end
         
         function result = calculateRadiation(obj, T, dp)
             
              result = pi * dp^2 * obj.material.eps ...   
                * Constants.sigma * (T^4 - obj.T_g^4); 
         end
         
         
         function result = calculateMassLossEvap(obj, T, dp)

            vapor_density = obj.material.vapor_pressure(T) ...
                        * obj.material.molar_mass_v ...
                        / Constants.R / T;

            result = -0.25 * pi * obj.material.theta_e ... 
                   * dp^2 * obj.material.c_tv(T) ...
                   * vapor_density;    
         end         
    end
    
end        


