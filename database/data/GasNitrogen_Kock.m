classdef GasNitrogen_Kock < GasProperties
%% gas properties (Nitrogen) by Kock

    properties
        gasname     = 'NitrogenKock';
        molar_mass  = 0.028014;    % [kg/mol]   - molar mass         
    end
    
    methods                
        function obj = GasNitrogen_Kock()            
        end
                
        function res = C_p_mol(obj, T)            
            % [J/(molK)] - molar heat capacity
            res = 28.58 + 0.00377 * T - 50000 / T^2;       
        end
    end    
end