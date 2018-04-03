classdef HTM_Liu < HeatTransferModel    
    
    % Independent model from:
    % H. A. Michelsen, F. Liu, B. F. Kock, H. Bladh, A. Boiarciuc, M. Charwath,
    % T. Dreier, R. Hadef, M. Hofmann, J. Reimann, S. Will, P. E. Bengtsson, 
    % H. Bockhorn, F. Foucher, K. P. Geigle, C. Mounaïm-Rousselle, 
    % C. Schulz, R. Stirn, B. Tribalet, and R. Suntz
    % "Modeling laser-induced incandescence of soot: a summary and 
    % comparison of LII models, Appl. Phys. B 87, 503-521 (2007)
    
    properties        
        name = 'Liu';
        sysfunc = 'dT_ddp';
    end
    
    methods        
        
         function obj = HTM_Liu(material, gasmix)              
             obj.material   = material;
             obj.gasmixture = gasmix;             
         end
         
         function result = calculateEvaporation(obj, T, dp)                                 
            % This model uses molar mass of vapor species (molar_mass_v)    
            result = -1.0 * obj.material.H_v(T) ...
                    / obj.material.molar_mass_v(T) ...
                    * obj.calculateMassLossEvap(T, dp);
         end
         
         function result = calculateConduction(obj, T, dp)

            % Equation (38):
            % in this model gamma is replaces by gamma_mean
            % (values of gamma rely on particle temperature):
            % integration used 10 data points between Tg and Tp
            
            X = linspace(obj.T_g, T, 10);
            Y = [];
            for i = 1:size(X,2)
                Y(i) = obj.gasmixture.gamma_eqn(X(i));
            end
            
            % trapezoid quadrature
            gamma_mean = trapz(X,Y) / (T - obj.T_g);
            
            % Equation (33)
            result =  pi * dp^2 ...
                      * obj.material.alpha_T_eff ...
                      * obj.p_g ...
                      / 2.0 / obj.T_g ...
                      * sqrt( ...
                            Constants.R ...
                            * obj.T_g ...
                            / 2.0 / pi ...
                            / obj.gasmixture.molar_mass) ...
                      * (gamma_mean + 1.0) ...
                      / (gamma_mean - 1.0) ...
                      * (T - obj.T_g);
         end
         
         function result = calculateRadiation(obj, T, dp)
                          
             result = 199.0 * pi^3 * dp^3 ...
                   * (Constants.k_B * T)^5 ...
                   * obj.material.eps ...
                   / Constants.h^4 ...
                   / Constants.c_0^3;            
         end
         
         
         function result = calculateMassLossEvap(obj, T, dp)

            K = 0.5;                        
            result =  -1.0 * pi * dp^2 ...
                    * obj.material.molar_mass_v(T) ...
                    * obj.material.theta_e ...
                    * obj.material.p_v(T) ...
                    / Constants.R / T ...
                    * (0.5 * Constants.R * T ...
                        / obj.material.molar_mass_v(T) ...
                        / pi)^K;                
         end         
    end
    
end        


