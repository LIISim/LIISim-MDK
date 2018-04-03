classdef PlotTools < handle
    %% PlotTools handle class takes care of figure layout
    properties
        figureID;
        name;
    end
    
    methods 
        
        function obj = PlotTools(figureID, name)
            obj.figureID = figureID;
            obj.name = name;
        end
        
        function setHold(obj)
            figure(obj.figureID);
            hold on;
        end
        
        function plotTemperature(obj, signal, name)
            figure(obj.figureID);            
            plot(signal.time_ns, signal.data);
            title(obj.name);            
            xlabel('Time \\ns');
            ylabel('Temperature \\K');                      
                        
            % get previous legend
            hLegend = findobj(gcf, 'Type', 'Legend');            
            if size(hLegend,1) == 0                
                legend(name);
            else
                numL = size(hLegend.String,2)-1;                      
                legend({hLegend.String{1:numL}, name});
            end            
        end
        
        function plotDp(obj, signal, name)
        
            figure(obj.figureID);            
            plot(signal.time_ns, signal.data .* 1E9);            
            title(obj.name);                                    
            xlabel('Time \\ns');
            ylabel('Particle diameter\\nm');        
            
            % get previous legend
            hLegend = findobj(gcf, 'Type', 'Legend');            
            if size(hLegend,1) == 0                
                legend(name);
            else
                numL = size(hLegend.String,2)-1;                      
                legend({hLegend.String{1:numL}, name});
            end            
        end
            
    end    
end

