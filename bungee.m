% Given Parameters for our Model
JumpPointHeight = 74;       % Height of Jump Point              : m
DeckHeight = 31;            % Deck Height                       : m
DragCoefficient = 0.9;      % Drag Coefficient                  : kg/m
HumanMass = 80;             % Mass of Jumper                    : kg
RopeLength = 25;            % Length of Bungee Rope             : m
RopeSpringConstant = 90;    % Spring Constant of Bungee Rope    : N/m
Gravity = 9.8;              % Gravitational Acceleration        : m/s^2

% Aliases for the model parameters.
% These are typically only used in dense equations, while the full names 
% will be preferred where possible
H = JumpPointHeight;
D = DeckHeight;
C = DragCoefficient;
L = RopeLength;
K = RopeSpringConstant;
g = Gravity;
M = HumanMass;


% Parameters for working with time.
% Defines the length of time to run for, the interval between time steps
% and also the total number of steps.
timeSeconds = 60;
interval = 0.001;
intervalCount = timeSeconds * (1/interval);


% Our approximate model of the bungee jump relies on the Modified Euler
% Method, implemented in the ModEulerMethod class.
% Here we are defining functions and starting values for the Modified Euler
% Method to work with.
vFunc = @(v, y) (v);
yFunc = @(y, v) (g-(C/M) * abs(v) * v -max(0, (K/M)* (y-L)));
vEuler = ModEulerMethod(vFunc, 0, 0, interval);
yEuler = ModEulerMethod(yFunc, 0, 0, interval);

% CalcDependant is a method that takes two coupled ModEulerMethod instances
% and evaluates the Modified Euler Method over both together.
results = ModEulerMethod.CalcDependant(vEuler, yEuler, intervalCount);
% Splits the results into lists containing the calcualted values.
[heightList, velList] = deal(results(1,:), results(2,:));

% I defined my own class Plotter that allows me to draw the graphs I need
% with very little code. This is part of the setup, telling it out the time
% system we use and populating it with data.
p = Plotter(timeSeconds, interval, intervalCount);
p.height.Data = heightList;
p.vel.Data = velList;


disp("==================== TASK 1 ====================");
% Just hand counted the bounces on the graph produced here. On a small enough scale to justify hand
% work.
bounces = 10;
disp("Bounces: " + bounces);

if (bounces >= 10)
    disp("My result of " + bounces + " bounces aligns with the claim of 10 bounces made by the bungee jump company.");
else
    disp("My result of " + bounces + " bounces did not align with the claim of 10 bounces made by the bungee jump company.");
end

% Plots Height against Time.
disp("Displayed plot of Height against Time");
p.QuickPlot(p.height);


disp("==================== TASK 2 ====================");
% Finding max speed and the moment in which it occured
maxSpeed = max(abs(velList));
maxSpeedTime = find(abs(velList) == maxSpeed) * interval;
disp("Max Speed: " + maxSpeed + " (m/s)");
disp("Max speed occurs at " + maxSpeedTime + " seconds from jumping");

disp("Displayed plot of Velocity against Time");
p.QuickPlot(p.vel);
disp("Displayed plot of Height and Velocity against Time");
p.QuickPlot2(p.height, p.vel);

disp("==================== TASK 3 ====================");
% Finding the accerlation
% Using Finite Differences for numerical differentiation
accelFunc = @(t) velList(t);
accelList = FiniteDifferences(accelFunc, interval, intervalCount);
accelList(end+1) = accelList(end);

% Finding max acceleration and the moment in which it occured
maxAccel = max(abs(accelList));
maxAccelTime = find(abs(accelList) == maxAccel) * interval;
disp("Max Acceleration: " + maxAccel + " (m/s/s)");
disp("Max Acceleration occurs at " + maxAccelTime + " seconds from jumping");

if (maxAccel >= (2 * g))
    disp("My calculated maximum acceleration of " + maxAccel + " (m/s/s) reaches 2g, which is potentially dangerous");
elseif (maxAccel > (1.8 * g))
    percent2G = compose("%.2f", 100 * maxAccel / (2 * g));
    disp("My calculated maximum acceleration of " + maxAccel + " (m/s/s) does not quite reach 2g, " ...
        + "however it comes quite close, being " + percent2G + "% of 2g.");
else
    disp("My calculated maximum acceleration of " + maxAccel + " (m/s/s) is significantly below 2g.");
end


p.accel.Data = accelList;
disp("Displayed plot of Acceleration against Time");
p.QuickPlot(p.accel);
disp("Displayed plot of Height and Acceleration against Time");
p.QuickPlot2(p.height, p.accel, "func", true);

disp("==================== TASK 4 ====================");
% Finding total distance travelled
% Using the Trapezoidal rule for numeric integration
totalDist = TrapezoidalInt(@(x) abs(velList(x)), 0, 60, interval);
disp("Total distance travelled: " + totalDist + " (m)");


disp("==================== TASK 5 ====================");
% Finding the time offset to trigger capturing the image
cameraHeight = JumpPointHeight - DeckHeight;

% Narrowing our heightList to only points before the first bounce.
firstFallEnd = find(heightList == max(heightList));

% Getting two lists of heights, one containing values below cameraHeight
% and the other containing values above.
belowCamera = find(heightList(1:firstFallEnd) < cameraHeight);
aboveCamera = find(heightList(1:firstFallEnd) > cameraHeight);

% Values for the interpolating polynomial
x = [belowCamera(end - 1), belowCamera(end), aboveCamera(1), aboveCamera(2)];
y = heightList(x);
x = x * interval;

% Creates a Lagrange Polynomial for interpolation.
cameraHeightPoly = Lagrange(x, y);
% A function to pass to SecantRoot that allows it to directly call our
% Lagrange Polynomial. Also subtracts (H-D) so that our roots are the
% time we want to take the photo at.
modifiedHeightPoly = @(x) (cameraHeightPoly.Calculate(x) - (H-D));
root = SecantRoot(modifiedHeightPoly, x(1), x(2), 3);

disp("The photo must be taken at " + root + " seconds after the jump.");



disp("==================== TASK 6 ====================");
% Water touch investigation
%
% Model Human height = 1.75m
% Need to find where rope attaches
% https://www.researchgate.net/publication/283532449_Modeling_and_Simulation_of_a_Passive_Lower-Body_Mechanism_for_Rehabilitation
% Reference to paper containing chart of human proportions
% Reference placed waist at 100.4cm and chest at 149.2cm
% A bungee harness typically attaches around the stomach area, which is an
% estimated 40% between the waist and chest measurements on the reference.
% We will therefore assume that the Model Users feet are an estimated
% 0.4 * (149.2 - 100.4) + 100.4 ~= 119.92cm (1.1992m) below the rope attach point.
humanHeightOffset = 1.1992;

newL = 43.5;
newK = 79.5;

% Rerunning earlier code to see how the modified L/K affect the bungee
% jump.
vFunc = @(v, y) (v);
yFunc = @(y, v) (g-(C/M) * abs(v) * v -max(0, (newK/M)* (y-newL)));
vEuler = ModEulerMethod(vFunc, 0, 0, interval);
yEuler = ModEulerMethod(yFunc, 0, 0, interval);
results = ModEulerMethod.CalcDependant(vEuler, yEuler, intervalCount);
[heightList, velList] = deal(results(1,:), results(2,:));

distanceToWater = JumpPointHeight - (max(abs(heightList)) + humanHeightOffset);
accelFunc = @(t) velList(t);
accelList = FiniteDifferences(accelFunc, interval, intervalCount);
accelList(end+1) = accelList(end);
maxAccel = max(abs(accelList));

disp("After changing the properties of the rope such that the length is " + ...
    newL + " (m) and the new spring contstant of the rope is " + newK + ",");
disp("the calcuations on our model with a 80kg and 1.75m tall bungee jumper show that " + ...
    "the jumper will dip " + compose("%.2f", abs(distanceToWater)) + " (m) " + ...
    "into the water and will reach a maximum acceleration of " + maxAccel + " (m/s/s).");

