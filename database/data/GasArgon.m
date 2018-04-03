classdef GasArgon < GasProperties
%% gas properties (Argon)

    properties
         gasname     = 'Argon';
         molar_mass  = 0.039948;    % [kg/mol]   - molar mass
    end

    methods                
        function obj = GasArgon()            
        end
        
        function res = C_p_mol(obj, T)            
        	% [J/(molK)] - molar heat capacity
            res = 20.786;       
        end        
    end    
end