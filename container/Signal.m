classdef Signal
%% Signal class describes data structure for signal objects 
% and provides several functions for signal handling
    properties                        
        start_time;     % [s] - t0
        dt;             % [s] - delta time
        data;           % data container for signal y values
        stdev;          % data container for standard deviation values
    end
    
    methods 
        
        function obj = Signal(start_time, dt, slength)
            
            if nargin > 1                              
               numData = round(slength/dt) + 1;
               
               obj.start_time   = start_time;
               obj.dt           = dt;                            
               obj.data         = zeros(numData, 1);               
            end        
        end    
        
                
        % returns time-axis [Nx1 double]
        function res = time(obj)
            
            numData = size(obj.data, 1);
            
            res = linspace(obj.start_time, ...
                           obj.start_time + (numData-1)*obj.dt, ...
                           numData)';      
        end
        
        % returns time-axis in nano seconds [Nx1 double]
        function res = time_ns(obj)            
            res = obj.time * 1E9;
        end
        
        % returns data at time in ns
        function res = dataAtTime(obj, time)            
            
            idx = floor((time * 1E-9 - obj.start_time) / obj.dt + 1);
            
            if idx > size(obj.data,1)
                disp(['No data available at ' num2str(time) ' ns']);
                res = 0;
            else
                res = obj.data(idx);
            end
        end
        
        function res = indexAt(obj, time)
           
            if time < obj.start_time
                disp(['No data available at ' num2str(time) ' ns']);
                res = -1;
            elseif time > (size(obj.data, 1) * obj.dt + obj.start_time)
                disp(['No data available at ' num2str(time) ' ns']);
                res = -1;
            else
                index = (time - obj.start_time) / obj.dt;
                res = round(index);
                if res > size(obj.data, 1)
                    res = size(obj.data, 1);
                end
            end
        end
        
    end    
end
