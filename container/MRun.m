classdef MRun
    
    %{
    
    *** Example usage: ***
    
    mrun = MRun.loadFromFile('2016-10-07_13-43-30.mat');

    disp(mrun);
    disp(mrun.mpoints(1));
    disp('*** first mpoint / first channel raw signal ***');
    disp(mrun.mpoints(1).raw_unprocessed(1));
    disp(mrun.mpoints(1).raw_processed(1));
    disp('*** first mpoint / first channel absolute signal ***');
    disp(mrun.mpoints(1).absolute_unprocessed(1));
    disp(mrun.mpoints(1).absolute_processed(1));
    if mrun.mpoints(1).getTempChannelCount > 1
        disp('*** first mpoint / first channel temperature signal ***');
        disp(mrun.mpoints(1).temperature_unprocessed(1));
        disp(mrun.mpoints(1).temperature_processed(1));
        if mrun.mpoints(1).getTempChannelCount >= 2
            disp('*** first mpoint / second channel temperature signal ***');
            disp(mrun.mpoints(1).temperature_unprocessed(2));
            disp(mrun.mpoints(1).temperature_processed(2));
        end
    end
    
    %}
    
    properties
        name;               %measurement run name
        description;        %measurement run description
        
        mpoints=MPoint;     %container for all measurement points
        
        %settings
        liisettings;
        ndFilterID;
        ndFilterTransmission;
        laserFluence;
        pmtGain;
    end
    
    methods
       
        function obj = MRun()
            
        end
        
        function res = getMPointCount(obj)
            res = size(obj.mpoints, 2);            
        end
        
    end
    
    methods (Static)
        
        function obj = loadFromFile(file)
            
           run = load(file);
           
           obj = MRun();
           
           obj.name = run.measurement_run.name;
           obj.description = run.measurement_run.description;
           
           obj.liisettings = run.measurement_run.settings.liisettings;
           obj.ndFilterID = run.measurement_run.settings.nd_filter_id;
           obj.ndFilterTransmission = run.measurement_run.settings.nd_filter_transmission;
           obj.laserFluence = run.measurement_run.settings.laser_fluence;
           obj.pmtGain = run.measurement_run.settings.pmt_gain_set;
           
           rowHeadings = {'mpoint'};
                      
           if(isstruct(run.measurement_run.raw) == 1)
               %unprocessed raw signal
               signal_count = size(run.measurement_run.raw.unprocessed, 1);
               channel_count = size(run.measurement_run.raw.unprocessed, 2);
           
               for m = 1:signal_count
                   for n = 1:channel_count
                       s = cell2struct(run.measurement_run.raw.unprocessed(m, n), rowHeadings, 1);
                   
                       sig = Signal(s.mpoint.start_time, s.mpoint.dt, s.mpoint.size * s.mpoint.dt);
                       sig.data = s.mpoint.data;
                       sig.stdev = s.mpoint.stdev;
                                      
                       obj.mpoints(m).raw_unprocessed(n) = sig;
                   end
               end
               
               %processed raw signal
               signal_count = size(run.measurement_run.raw.processed, 1);
               channel_count = size(run.measurement_run.raw.processed, 2);
           
               for m = 1:signal_count
                   for n = 1:channel_count
                       s = cell2struct(run.measurement_run.raw.processed(m, n), rowHeadings, 1);
                   
                       sig = Signal(s.mpoint.start_time, s.mpoint.dt, s.mpoint.size * s.mpoint.dt);
                       sig.data = s.mpoint.data;
                       sig.stdev = s.mpoint.stdev;
                                      
                       obj.mpoints(m).raw_processed(n) = sig;
                   end
               end
           end
           
           if(isstruct(run.measurement_run.absolute) == 1)
               %unprocessed absolute signal
               signal_count = size(run.measurement_run.absolute.unprocessed, 1);
               channel_count = size(run.measurement_run.absolute.unprocessed, 2);
           
               for m = 1:signal_count
                   for n = 1:channel_count
                       s = cell2struct(run.measurement_run.absolute.unprocessed(m, n), rowHeadings, 1);
                   
                       sig = Signal(s.mpoint.start_time, s.mpoint.dt, s.mpoint.size * s.mpoint.dt);
                       sig.data = s.mpoint.data;
                       sig.stdev = s.mpoint.stdev;
                                      
                       obj.mpoints(m).absolute_unprocessed(n) = sig;
                   end
               end
           
               %processed absolute signal
               signal_count = size(run.measurement_run.absolute.processed, 1);
               channel_count = size(run.measurement_run.absolute.processed, 2);
           
               for m = 1:signal_count
                   for n = 1:channel_count
                       s = cell2struct(run.measurement_run.absolute.processed(m, n), rowHeadings, 1);
           
                       sig = Signal(s.mpoint.start_time, s.mpoint.dt, s.mpoint.size * s.mpoint.dt);
                       sig.data = s.mpoint.data;
                       sig.stdev = s.mpoint.stdev;
                                      
                       obj.mpoints(m).absolute_processed(n) = sig;
                   end
               end
           end
           
           if(isstruct(run.measurement_run.temperature) == 1)
               %unprocessed temperature signal
               signal_count = size(run.measurement_run.temperature.unprocessed, 1);
               channel_count = size(run.measurement_run.temperature.unprocessed, 2);
           
               for m = 1:signal_count
                   for n = 1:channel_count
                       t = cell2struct(run.measurement_run.temperature.unprocessed(m, n), rowHeadings, 1);
                   
                       tsig = TempSignal(t.mpoint.start_time, t.mpoint.dt, t.mpoint.size * t.mpoint.dt);
                       tsig.data = t.mpoint.data;
                       tsig.stdev = t.mpoint.stdev;
                   
                       tsig.method = t.mpoint.temperature_metadata.method;
                       tsig.source_channels = t.mpoint.temperature_metadata.channels;
                       tsig.material = t.mpoint.temperature_metadata.material;
                                      
                       obj.mpoints(m).temperature_unprocessed(n) = tsig;
                   end
               end
           
               %processed temperature signal
               signal_count = size(run.measurement_run.temperature.processed, 1);
               channel_count = size(run.measurement_run.temperature.processed, 2);
           
               for m = 1:signal_count
                   for n = 1:channel_count
                       t = cell2struct(run.measurement_run.temperature.processed(m, n), rowHeadings, 1);
                   
                       tsig = TempSignal(t.mpoint.start_time, t.mpoint.dt, t.mpoint.size * t.mpoint.dt);
                       tsig.data = t.mpoint.data;
                       tsig.stdev = t.mpoint.stdev;
                   
                       tsig.method = t.mpoint.temperature_metadata.method;
                       tsig.source_channels = t.mpoint.temperature_metadata.channels;
                       tsig.material = t.mpoint.temperature_metadata.material;
                                      
                       obj.mpoints(m).temperature_processed(n) = tsig;
                   end
               end
           end
           
        end 
    end
end