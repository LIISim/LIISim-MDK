classdef MPoint
   
    properties
        raw_unprocessed=Signal;
        raw_processed=Signal;
       
        absolute_unprocessed=Signal;
        absolute_processed=Signal;
       
        temperature_unprocessed=TempSignal;
        temperature_processed=TempSignal;
    end
    
    methods
        
        function obj = MPoint()
            
        end
        
        function res = getRawUnprocessedChannelCount(obj)
            res = size(obj.raw_unprocessed, 2);
        end
        
        function res = getRawProcessedChannelCOunt(obj)
            res = size(obj.raw_processed, 2);
        end
        
        function res = getAbsUnprocessedChannelCount(obj)
            res = size(obj.absolute_unprocessed, 2);
        end
        
        function res = getAbsProcessedChannelCount(obj)
            res = size(obj.absolute_processed, 2);
        end
        
        function res = getTempUnprocessedChannelCount(obj)
            res = size(obj.temperature_unprocessed, 2);
        end
        
        function res = getTempProcessedChannelCount(obj)
            res = size(obj.temperature_processed, 2);
        end
        
    end
end