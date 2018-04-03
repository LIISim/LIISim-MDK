classdef Core < handle 
    properties  
        defaultFigStyle
    end
    
    methods
        function obj = Core()                        
            % reset session path information
            path(pathdef);            
            
            %clear all figures if workspace is empty
            fh = findall(0,'type','figure');
            for i = 1:length(fh)
                 clf(fh(i));
            end
            
            obj.defaultFigStyle = get(0,'DefaultFigureWindowStyle');
            set(0,'DefaultFigureWindowStyle','docked');
                                   
            % set path to class folders
            path(path, strcat(pwd, '/calculation/'));
            path(path, strcat(pwd, '/calculation/models/'));
            path(path, strcat(pwd, '/container/'));
            path(path, strcat(pwd, '/database'));
            path(path, strcat(pwd, '/database/data'));
            path(path, strcat(pwd, '/gui/'));
            
            clc
            disp('--- LIISim Model Development Kit ---');                        
        end
        
        %% destructor resets path settings 
        % (avoid problems with other scripts)
        function delete(obj)            
            
            set(0,'DefaultFigureWindowStyle', obj.defaultFigStyle);
            
            disp('Core: Reset MATLAB path settings');
            path(pathdef);
        end
        
    end    
end

