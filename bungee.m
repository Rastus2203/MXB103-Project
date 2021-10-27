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
yList = results(1,:);
yList = H - yList;
x = linspace(0,timeSeconds, intervalCount + 1);
%vList = results(2,:);

figure;
plot(x, yList);
axis([0, timeSeconds, 20, H]);






