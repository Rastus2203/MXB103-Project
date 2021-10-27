classdef Plotter
    properties
        accel = struct( ...
            "Name", "Acceleration", ...
            "Unit", "m/s/s", ...
            "Data", "", ...
            "Func", "" ...
            );
    
        vel = struct( ...
            "Name", "Velocity", ...
            "Unit", "m/s", ...
            "Data", "", ...
            "Func", "" ...
            );
        
        height = struct( ...
            "Name", "Height", ...
            "Unit", "m", ...
            "Data", "", ...
            "Func", @() yline(25) ...
            );
        
        time = struct( ...
            "Seconds", "", ...
            "Interval", "", ...
            "IntervalCount", "" ...
            );
        x
    end
    
    methods
        function obj = Plotter(seconds, interval, intervalCount)
            obj.time.Seconds = seconds;
            obj.time.Interval = interval;
            obj.time.IntervalCount = intervalCount;
            obj.x = linspace(0, seconds, intervalCount + 1);
        end
        
        
        function QuickPlot(obj, type)
            figure;
    
            p = plot(obj.x, type.Data);
            ax = p.Parent;
            
            title("Plot of " + type.Name + " over Time");
            xlabel("Time (s)");
            ylabel(type.Name + " (" + type.Unit + ")");
            set(ax, 'Ydir', 'reverse');
            type.Func();
        end
        
        function QuickPlot2(obj, type1, type2)
            figure;
            hold on;
            title("Plot of " + type1.Name + " and " + type2.Name + " over Time");
            xlabel("Time (s)")

            yyaxis left
            ylabel(type1.Name + " (" + type1.Unit + ")");
            p = plot(obj.x, type1.Data);
            ax = p.Parent;
            set(ax, 'Ydir', 'reverse');
            type1.Func();

            yyaxis right
            ylabel(type2.Name + " (" + type2.Unit + ")");
            p = plot(obj.x, type2.Data);
            ax = p.Parent;
            set(ax, 'Ydir', 'reverse');
            type2.Func();
        end
    end
end


