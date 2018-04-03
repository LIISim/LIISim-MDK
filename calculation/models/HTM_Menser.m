classdef HTM_Menser < HeatTransferModel
    %HTM_MENSER Heat transfer model by Jan Menser - Appl. Phys. B (2016) 122:277
    % J. Menser, K. Daun, T. Dreier, and C. Schulz, 
    % "Laser-induced incandescence from laser-heated silicon nanoparticles," 
    % Appl. Phys. B 122, 277 (2016).
    
    properties        
        name = 'Silicon_Menser';
        sysfunc = 'dT_dM';        
    end
    
    methods        
        
         function obj = HTM_Menser(material, gasmix)              
             obj.material   = material;
             obj.gasmixture = gasmix;             
         end
         
         function result = calculateEvaporation(obj, T, dp)                        
             result = -1.0 * obj.material.H_v ...
                        / obj.material.molar_mass_v ...
                        * obj.calculateMassLossEvap(T, dp);
         end
         
         function result = calculateConduction(obj, T, dp)
                        
            % calculate sum for all gases in mixture
            sum = 0;
            for i = 1:size(obj.gasmixture.gases,2)
                gas = obj.gasmixture.gases{i};
                
                sum = sum + (obj.gasmixture.x(i) ...
                            * gas.c_tg(obj.T_g)  ...
                            * gas.alpha_T  ...
                            * (2 + gas.zeta / 2));
            end
             
            result = pi * dp^2 * 0.25 ...
                    * obj.p_g / Constants.k_B / obj.T_g ...
                    * sum ...                    
                    * Constants.k_B * (T - obj.T_g);                  
         end
         
         function result = calculateRadiation(obj, T, dp)             
             result = 0; % not used in this model
         end
         
         
         function result = calculateMassLossEvap(obj, T, dp)

             % Kelvin equation
             gamma = (732 - 0.086*(T - 1685))*1e-3; %surface tension (Millot et al., 2008)
             p_v_kelvin = obj.material.p_v(T) * exp( 4*gamma ...
                                              / (dp ...  
                                                * obj.material.rho_p(T) ...
                                                * Constants.R ...
                                                / obj.material.molar_mass_v ...
                                                * T));
             
             % no Kelvin effect
             %p_v = obj.material.p_v(T);
                          
             result = -pi * dp^2 * 0.25 ...
                        * p_v_kelvin ...                        
                        / Constants.k_B ...
                        / T ...                        
                        * obj.material.c_tv(T) ...
                        / Constants.N_A * obj.material.molar_mass_v; % convert from molecule to mol                          
         end         
    end
    
end        


