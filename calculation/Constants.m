classdef Constants
    
    properties (Constant)       
    
        h       = 6.62607004E-34;       % [Js] - Planck
        k_B     = 1.38064852E-23;       % [J/K] - Boltzmann
        sigma   = 5.670367E-8;          % [W/m^2/K^4] - Stefan-Boltzmann
        
        c_0     = 2.99792458E8;         % [m/s] - speed of light
        
        c_1     = 2 * Constants.h * Constants.c_0^2;            % [Wm^2/sr] - first radiation constant (spectral radiance;solid angle of space)
        c_2     = Constants.h * Constants.c_0 / Constants.k_B;  % [Km] - second radiation constant
        
        N_A     = 6.022140857E23;       % [1/mol]
        R       = 8.3144598;            % [J/(mol*K)] - molar gas constant
        
        %pi        
    end    
end
