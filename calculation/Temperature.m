classdef Temperature
    
    properties        
    end
    
    methods (Static)
                       
        function I = calcPlanckI(lambda, T, C, Em)
            
            lambda_m = lambda * 1E-9;
            
            I = C * Em / lambda_m ...
             * Constants.c_1 ...
             / lambda_m^5 ...
             / (exp(Constants.c_2 / lambda_m / T) - 1);
        end
        
        function T = calcTwoColor(s1, s2, Em_1, Em_2, lambda1, lambda2)            
        
            %lambda unit conversion
            lambda1_m = lambda1 * 1E-9;
            lambda2_m = lambda2 * 1E-9;
                        
            T = Constants.c_2 * (1/lambda2_m - 1/lambda1_m) ...
                / log( s1/s2 * Em_2 / Em_1 *(lambda1/lambda2)^6); 
            
%             disp(' ');
%             disp(['Temperature: ' num2str(T)]);
%             disp(['Ratio S1/S2: ' num2str(s1/s2)]);            
        end
        
        function ratio = calcSignalRatioByTemperature(lambda1, lambda2, Em_1, Em_2, temperature)            
        
            %lambda unit conversion
            lambda1_m = lambda1 * 1E-9;
            lambda2_m = lambda2 * 1E-9;
                        
            % Wien approximation
            S1 = 1 / lambda1^6 * 1 ...
                / exp(Constants.h * Constants.c_0 / Constants.k_B ...
                / lambda1_m / temperature);
            
            S2 = 1 / lambda2^6 * 1 ...
                / exp(Constants.h * Constants.c_0 / Constants.k_B ...
                / lambda2_m / temperature);
                        
            ratio = S1 / S2;
            
%             disp(' ');
%             disp(['Temperature: ' num2str(temperature)]);
%             disp(['Ratio S1/S2: ' num2str(ratio)]);            
        end
        
        function Em = calcDrudeEm(lambda, material) 
            
            % Uses Material: omega_p, tau            
            omega_p = material.omega_p;
            tau     = material.tau;
            
            % allow processing of lambda vector
            [p,q] = size(lambda);
            
            % convert to seconds
            lambda_m = lambda * 1E-9;
            
            % frequency of light
            nu      = Constants.c_0 ./ lambda_m;    
            
            % angular frequency of the electromagnetic wave
            omega   = 2 * pi * nu;
            
            % dielectric function (wavelength-dependent)
            epsilon1 = ones(p,q) - omega_p^2 * tau^2 ...
                        ./ (omega.^2 * tau^2 + ones(p,q));
                    
            epsilon2 = omega_p^2 * tau ...
                        ./ (omega .* (omega.^2 * tau^2 + ones(p,q)));
            
            % electrical permittivity of the bulk nanoparticle material
            % eps = epsI + i*epsII
            eps = epsilon1 + 1i * epsilon2;

            % imaginary part
            Em = imag((eps - 1) ./ (eps + 2));
        end
    end
end     