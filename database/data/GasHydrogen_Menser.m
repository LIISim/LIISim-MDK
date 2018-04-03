classdef GasHydrogen_Menser < GasProperties
    % J. Menser, K. Daun, T. Dreier, and C. Schulz, 
    % "Laser-induced incandescence from laser-heated silicon nanoparticles," 
    % Appl. Phys. B 122, 277 (2016).

    properties
         gasname     = 'HydrogenMenser';
         molar_mass  = 0.00201588;    % [kg/mol]   - molar mass
         alpha_T     = 0.11
         zeta        = 1;
    end
end