classdef GasNitrogen_Melton < GasProperties
%% gas properties (Nitrogen) by Melton

    properties
        gasname     = 'NitrogenMelton';            
        % molar mass of gas is not used in this model
        molar_mass  = 0;    % [kg/mol]   - molar mass
    end
    
    methods                
        function obj = GasNitrogen_Melton()   
        end
                
        function res = C_p_mol(obj, T)            
            % [J/(molK)] - molar heat capacity
            % calculated from given gamma(1800K) = 1.3
            res = 36.0295;       
        end
    end    
end