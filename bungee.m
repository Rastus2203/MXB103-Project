% Model Parameters
JumpPointHeight = 74;       % Height of Jump Point              : m
DeckHeight = 31;            % Deck Height                       : m
DragCoefficient = 0.9;      % Drag Coefficient                  : kg/m
HumanMass = 80;             % Mass of Jumper                    : kg

%RopeLength = 25;            % Length of Bungee Rope             : m
%RopeSpringConstant = 90;    % Spring Constant of Bungee Rope    : N/m
RopeLength = 43.5;
RopeSpringConstant = 79.5;
Gravity = 9.8;              % Gravitational Acceleration        : m/s^2

H = JumpPointHeight;
D = DeckHeight;
C = DragCoefficient;
L = RopeLength;
K = RopeSpringConstant;
g = Gravity;
m = HumanMass;


timeSeconds = 60;
interval = 0.001;
intervalCount = timeSeconds * (1/interval);

yFunc = @(v, y) (v);
yEuler = ModEulerMethod(yFunc, 0, 0, interval);

vFunc = @(y, v) (g - (C/m) * abs(v) * v - max(0, (K/m) * (y-L)));
vEuler = ModEulerMethod(vFunc, 0, 0, interval);

results = ModEulerMethod.CalcDependant(yEuler, vEuler, intervalCount);

% Array for Height
heightList = results(1,:);

% Array for Velocity
velList = results(2,:);

% Array for time
x = linspace(0,timeSeconds, intervalCount + 1);
  
% Finding max speed and the moment in which it occured
maxSpeed = max(abs(velList));
maxSpeedTime = find(abs(velList) == maxSpeed) * interval;


% Finding the accerlation with numerical differentiation
accelList = zeros(1, intervalCount);
for i = 1:intervalCount
    t = i * interval;
    accelList(i) = ApproxDerivative(@(t,y) y, t, velList(i), t + interval, velList(i+1));
end
accelList(end+1) = accelList(end);




% Finding max acceleration and the moment in which it occured
maxAccel = max(abs(accelList));
maxAccelTime = find(abs(accelList) == maxAccel) * interval;


% Finding total distance travelled
if false
    totalDist = TrapezoidalInt(@(x) abs(velList(x)), 0, 60, interval);
end


% Finding the time offset to trigger capturing the image
cameraHeight = JumpPointHeight - DeckHeight;

firstFallEnd = find(heightList == max(heightList));
belowCamera = find(heightList(1:firstFallEnd) < cameraHeight);
aboveCamera = find(heightList(1:firstFallEnd) > cameraHeight);

x = [belowCamera(end - 1), belowCamera(end), aboveCamera(1), aboveCamera(2)];
y = heightList(x);
x = x * interval;

cameraHeightPoly = Lagrange(x, y);
modifiedHeightPoly = @(x) (cameraHeightPoly.Calculate(x) - (H-D));
root = SecantRoot(modifiedHeightPoly, x(1), x(2), 3);


% Water touch investigation
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

distanceToWater = JumpPointHeight - (max(abs(heightList)) + humanHeightOffset);

disp(distanceToWater);
disp(maxAccel);








% Custom Plotter class to easily draw plots of commonly used variables
p = Plotter(timeSeconds, interval, intervalCount);
p.height.Data = heightList;
p.vel.Data = velList;
p.accel.Data = accelList;

p.height.Data = p.height.Data + humanHeightOffset;
p.QuickPlot(p.height);
$With the new rope parameters K=79.5 and L = 43.5m

%ax = p.QuickPlot(p.height);
%ax.NextPlot = 'add';
%plot(root, (H-D), '.k', "MarkerSize", 20);










