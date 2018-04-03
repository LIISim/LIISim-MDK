classdef GasArgon_Menser < GasProperties
    % J. Menser, K. Daun, T. Dreier, and C. Schulz, 
    % "Laser-induced incandescence from laser-heated silicon nanoparticles," 
    % Appl. Phys. B 122, 277 (2016).

    properties
        gasname     = 'ArgonMenser';
        molar_mass  = 0.039948;    % [kg/mol]   - molar mass           
        alpha_T     = 0.35;
        zeta        = 0;
    end
end