classdef GasProperties < handle 
%% material properties (general)
    
    % mandatory properties  - need to be implemented in subclasses 
    properties (Abstract)
        gasname        
        molar_mass            
    end    
        
    % optional properties (dependent on HTM)
    properties 
        %alpha_T    % [-] - effective thermal accomodaction coefficient
        %zeta       % [-] - number of active internal degrees of freedom 
                    %       of the gas molecule (0 for Argon, 1 for Hydrogen) 
    end
    
    methods
       function res = c_tg(obj, T_gas)
            %% thermal velocity of gas molecules [m/s]
            res =  sqrt(8 * Constants.k_B * T_gas / pi ...
                    / obj.molar_mass * Constants.N_A);            
        end         
    end
end