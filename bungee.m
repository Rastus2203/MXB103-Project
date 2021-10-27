% Model Parameters
JumpPointHeight = 74;       % Height of Jump Point              : m
DeckHeight = 31;            % Deck Height                       : m
DragCoefficient = 0.9;      % Drag Coefficient                  : kg/m
HumanMass = 80;             % Mass of Jumper                    : kg
RopeLength = 25;            % Length of Bungee Rope             : m
RopeSpringConstant = 90;    % Spring Constant of Bungee Rope    : N/m
Gravity = 9.8;              % Gravitational Acceleration        : m/s^2

H = JumpPointHeight;
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









% Custom Plotter class to easily draw plots of commonly used variables
p = Plotter(timeSeconds, interval, intervalCount);
p.height.Data = heightList;
p.vel.Data = velList;
p.accel.Data = accelList;








