function dataset = create_dataset()

%% Prepare a dataset
time = 0:1/20E3:0.1;
f = 60;
w = 2*pi*f;
Vm = 1;   % Voltage amplitude
Im = 2/3; % Current amplitude

%voltage signal
Va = Vm*sin(w*time);
Vb = Vm*sin(w*time-2*pi/3);
Vc = Vm*sin(w*time+2*pi/3);

% current signal
Ia = Im*sin(w*time);
Ib = Im*sin(w*time-2*pi/3);
Ic = Im*sin(w*time+2*pi/3);

%real power 
pa = Va .* Ia; % Instantaneous power for phase a
pb = Vb .* Ib; % Instantaneous power for phase b
pc = Vc .* Ic; % Instantaneous power for phase c
Pgen = pa + pb + pc; % Total instantaneous power


% The dataset matrix has the following columns:
% Column 1: time  -> Time values
% Column 2: Va    -> Phase A voltage
% Column 3: Vb    -> Phase B voltage
% Column 4: Vc    -> Phase C voltage
% Column 5: Ia    -> Phase A current
% Column 6: Ib    -> Phase B current
% Column 7: Ic    -> Phase C current
% Column 8: Pgen  -> Generated power
dataset = [time', Va', Vb', Vc', Ia', Ib', Ic', Pgen'];

end
