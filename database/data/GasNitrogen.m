classdef GasNitrogen < GasProperties
%% gas properties (Nitrogen)

    properties
        gasname     = 'Nitrogen';
        molar_mass  = 0.0280134;    % [kg/mol]   - molar mass         
    end

    methods                
        function obj = GasNitrogen()           
        end
        
        function res = C_p_mol(obj, T)            
            % [J/(molK)] - molar heat capacity
            res = 29.124;       
        end        
    end    
end