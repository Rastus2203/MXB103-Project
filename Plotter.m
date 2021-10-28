classdef Plotter
    % A class to simplify drawing plots. Most of the styles I need are
    % already preset here, they just need data.
    properties
        % These effectively act as presets for graphs that can be easily
        % selected to use or modified.
        accel = struct( ...
            "Name", "Acceleration", ...
            "Unit", "m/s/s", ...
            "Data", "", ...
            "Func", "", ...
            "Axes", [-inf, inf, -inf, inf] ...
            );
    
        vel = struct( ...
            "Name", "Velocity", ...
            "Unit", "m/s", ...
            "Data", "", ...
            "Func", "", ...
            "Axes", [-inf, inf, -inf, inf] ...
            );
        
        height = struct( ...
            "Name", "Height", ...
            "Unit", "m", ...
            "Data", "", ...
            "Func", @() yline(25), ...
            "Axes", [-inf, inf, 0, 74] ...
            );
        
        time = struct( ...
            "Seconds", "", ...
            "Interval", "", ...
            "IntervalCount", "" ...
            );
        x
    end
    
    methods
        % Instantiate the plotter, this requires time information.
        function obj = Plotter(seconds, interval, intervalCount)
            obj.time.Seconds = seconds;
            obj.time.Interval = interval;
            obj.time.IntervalCount = intervalCount;
            obj.x = linspace(0, seconds, intervalCount + 1);
        end
        
        % Plots a single 2D line graph according to the presets set above.
        function ax = QuickPlot(obj, type, subtitle, func)
            if (~exist('subtitle', 'var'))
                subtitle = "";
            end
            if (~exist('func', 'var'))
                func = false;
            end
            
            figure;
    
            p = plot(obj.x, type.Data);
            ax = p.Parent;
            ax.XLim = type.Axes(1:2);
            ax.YLim = type.Axes(3:4);
            title(["Plot of " + type.Name + " over Time", subtitle]);
            xlabel("Time (s)");
            ylabel(type.Name + " (" + type.Unit + ")");
            set(ax, 'Ydir', 'reverse');
            if (func)
                type.Func();
            end
        end
        
        % Plots two line graphs on the same axis according to the presets
        % set above.
        function f = QuickPlot2(obj, type1, type2, subtitle, func)
            if (~exist('subtitle', 'var'))
                subtitle = "";
            end
            if (~exist('func', 'var'))
                func = false;
            end
            
            f = figure;
            hold on;
            title(["Plot of " + type1.Name + " and " + type2.Name + " over Time", subtitle]);
            xlabel("Time (s)")
            

            yyaxis left
            ylabel(type1.Name + " (" + type1.Unit + ")");
            p = plot(obj.x, type1.Data);
            ax = p.Parent;
            ax.XLim = type1.Axes(1:2);
            ax.YLim = type1.Axes(3:4);
            set(ax, 'Ydir', 'reverse');
            if (func)
                type1.Func();
            end

            yyaxis right
            ylabel(type2.Name + " (" + type2.Unit + ")");
            p = plot(obj.x, type2.Data);
            ax = p.Parent;
            ax.XLim = type2.Axes(1:2);
            ax.YLim = type2.Axes(3:4);
            set(ax, 'Ydir', 'reverse');
            if (func)
                type2.Func();
            end
        end
    end
end


