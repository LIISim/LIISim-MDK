classdef HeatTransferModel < handle
    %% HeatTransferModel - Abstract Class for Reimplementation
    
   properties      
      material;
      gasmixture;
      p_g;
      T_g            
   end
   
   % properties to be defined by sub models
   properties (Abstract)
      name; 
      sysfunc; % ['dT_dM' | dT_ddp'] % defines which derivative is used by HTM
   end
   
   % heat transfer rates are reimplemented in the subclasses
   methods (Abstract)        
        result = calculateEvaporation(obj, T, dp);
        result = calculateConduction(obj, T, dp);
        result = calculateRadiation(obj, T, dp);
        
        result = calculateMassLossEvap(obj, T, dp);        
   end
   
   % general methods
   methods                  
       function dxdt = ode_sys(obj, ~, x)
           %% ODE system function
           
            dxdt = zeros(2,1);
           
            % x[0]:  temperature
            % x[1]:  particle mass
            if strcmp(obj.sysfunc, 'dT_dM')
    
                T  = x(1);
                mp = x(2);
                
                dp = obj.calculateDiameterFromMass(T, mp);

                dxdt(1) = obj.derivativeT(T, dp); % dT/dt
                dxdt(2) = obj.derivativeMp(T, dp); % dM/dt    
            
            % x[0]:  temperature
            % x[1]:  particle diameter            
            else % dT_ddp
                T  = x(1);
                dp = x(2);

                dxdt(1) = obj.derivativeT(T, dp); % dT/dt
                dxdt(2) = obj.derivativeDp(T, dp); % d(d_p)/dt                
            end   
       end
     
       
       function result = derivativeT(obj, T, dp)
           
           result = -1.0 *( ...
               obj.calculateEvaporation(T, dp) ...
              + obj.calculateConduction(T, dp) ...
              + obj.calculateRadiation(T, dp) ...
              ) ...
            / obj.calculateMassFromDiameter(T, dp) ... 
            / obj.material.c_p_kg(T);
       end
       
       
       function result = derivativeDp(obj, T, dp) 
           
            result = obj.calculateMassLossEvap(T, dp) ...
                    * 2.0 / (pi * obj.material.rho_p(T) * dp^2);
       end
       
        function result = derivativeMp(obj, T, dp) 
           
            result = obj.calculateMassLossEvap(T, dp);
       end
       
       
       function mass = calculateMassFromDiameter(obj, T, dp)

           mass = pi / 6.0 * dp^3 * obj.material.rho_p(T);
       end    
       
       function dp = calculateDiameterFromMass(obj, T, mp)
               
           dp = (6.0 * mp / pi / obj.material.rho_p(T))^(1/3);
       end    
   end
end

