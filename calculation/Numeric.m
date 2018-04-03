classdef Numeric
    
    properties        
        % default numeric settings
        start_time  = 0;
        dt          = 1E-9;
        sig_length  = 2500E-9;
    end
    
    methods 
        
        function [T, dp] = ode_solver(obj, htm, T_start, dp_start) 

            % type of system function:
            % sysfunc = 'dT_ddp':   x[0]:  temperature x[1]:  particle diameter
            % sysfunc = 'dT_dM':    x[0]:  temperature x[1]:  particle mass
            % is defined in HeatTransferModel sub classes
            if strcmp(htm.sysfunc, 'dT_dM')               
                x0(1) = T_start;
                x0(2) = htm.calculateMassFromDiameter(T_start, dp_start);
            else % 'dT_ddp'                
                x0(1) = T_start;
                x0(2) = dp_start;
            end
                
                
            % init default signal
            simSignal = Signal(obj.start_time, obj.dt, obj.sig_length);
            
            % copy default signal
            T    = simSignal;
            dp   = simSignal;
                        
            %   ODE45 is an implementation of the explicit Runge-Kutta (4,5) pair of
            %   Dormand and Prince called variously RK5(4)7FM, DOPRI5, DP(4,5) and DP54.
            %   It uses a "free" interpolant of order 4 communicated privately by
            %   Dormand and Prince.  Local extrapolation is done.
            [~, x] = ode45(@(t,x) htm.ode_sys(t,x), simSignal.time(), x0);
            
            % assign ODE results
            T.data   = x(:,1);
            
            if strcmp(htm.sysfunc, 'dT_dM')             
                for i = 1:size(x,1)
                    dp.data(i)  = htm.calculateDiameterFromMass(x(i,1),x(i,2));                
                end
            else % 'dT_ddp'                
                dp.data  = x(:,2);
            end
        end        

        function [T, dp] = ode_euler(obj, htm, T_start, dp_start) 
            
            % init default signal
            simSignal = Signal(obj.start_time, obj.dt, obj.sig_length);
                        
            % copy default signal 
            T    = simSignal;
            dp   = simSignal;
            
            % solve ODE
            t       = simSignal.start_time;
            dt      = simSignal.dt;
            n       = size(simSignal.data,1);
                        
            % type of system function:
            % sysfunc = 'dT_ddp':   x[0]:  temperature x[1]:  particle diameter
            % sysfunc = 'dT_dM':    x[0]:  temperature x[1]:  particle mass
            % is defined in HeatTransferModel sub classes
            if strcmp(htm.sysfunc, 'dT_dM')                
                x(1,1) = T_start;
                x(1,2) = htm.calculateMassFromDiameter(T_start, dp_start);
            else % 'dT_ddp'                
                x(1,1) = T_start;
                x(1,2) = dp_start;
            end
                                    
            for i = 2:n
                dxdt    = htm.ode_sys(t, x(i-1,:));
                x(i,1)  = x(i-1,1) + dxdt(1) * dt;
                x(i,2)  = x(i-1,2) + dxdt(2) * dt;                                   
            end
            
            % assign ODE results
            T.data   = x(:,1);
            
            if strcmp(htm.sysfunc, 'dT_dM')                
                for i = 1:size(x,1)
                    dp.data(i)  = htm.calculateDiameterFromMass(x(i,1), x(i,2));                
                end
            else % 'dT_ddp'                                
                dp.data  = x(:,2);                                
            end
        end
    end
end