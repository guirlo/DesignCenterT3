%% Wheel Loader with Hydromechanical Power Split Transmission
% 
% <<sm_wheel_loader_Overview.png>>
%
% (<matlab:web('Wheel_Loader_Design_Overview.html') return to Wheel Loader Design with Simscape Overview>)
% 
% This example models a wheel loader with a power-split hydromechanical
% continuously variable transmission (CVT. Other CVT technologies can be
% tested as well, including pure hydrostatic and electrical CVT. The
% engine, CVT, driveline, chassis, and linkage system are all modeled using
% Simscape.  The control systems are modeled in Simulink.  A bucket or a
% grapple can be attached to the linkage.
%
% Copyright 2023-2024 The MathWorks, Inc.

%% Model
%
% This example models a wheel loader with a power-split hydromechanical
% continuously variable transmission (CVT).
%
% <matlab:open_system('sm_wheel_loader'); Open Model>

open_system('sm_wheel_loader')
set_param(bdroot,'LibraryLinkDisplay','none')
ann_h = find_system('sm_wheel_loader','MatchFilter',@Simulink.match.allVariants,'FindAll', 'on','type','annotation','Tag','ModelFeatures');
for anhi=1:length(ann_h)
    set_param(ann_h(anhi),'Interpreter','off');
end

set_param([bdroot '/Wheel Loader'],'popup_engine','Droop');
set_param([bdroot '/Wheel Loader'],'popup_driveline','1D, CV Joints');
sm_wheel_loader_config_impl(bdroot,'Bucket')
set_param([bdroot '/Wheel Loader'],'popup_cvt','Power Split Hydromechanical')
set_param([bdroot '/Wheel Loader'],'popup_actuator_model','Hydraulic')

%% Wheel Loader Subsystem
%
% The wheel loader is powered by an engine.  The continuously variable
% transmission varies its ratio to drive the vehicle at the desired speed.
% The vehicle includes the driveline, articulated chassis, and linkage
% which operates the implements.
%
% <matlab:open_system('sm_wheel_loader');open_system('sm_wheel_loader/Wheel%20Loader','force'); Open Subsystem>

set_param('sm_wheel_loader/Wheel Loader','LinkStatus','none')
open_system('sm_wheel_loader/Wheel Loader','force')
%set_param(find_system('sm_wheel_loader/Wheel Loader','MatchFilter',@Simulink.match.allVariants,'FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

%% Transmission Variant Subsystems
%
% Four options for modeling the CVT are included in the model.  Using
% variant subsystems, one of them can be activated for a test.  The
% subsystems all have the same interface, which includes a mechanical
% connection to the engine and a mechanical connection to the driveline.
% Intefaces based on physical connections are particularly well-suited to
% swapping between models of different technologies or fidelity.
%
% <matlab:open_system('sm_wheel_loader');open_system('sm_wheel_loader/Wheel%20Loader/Transmission','force'); Open Subsystem>

set_param('sm_wheel_loader/Wheel Loader/Transmission','LinkStatus','none')
open_system('sm_wheel_loader/Wheel Loader/Transmission','force')

%% Abstract CVT Subsystem
%
% Models a CVT as a variable ratio gear. This model can be used in early
% stages of development to refine requirements for the transmission.  It
% can also be tuned to match a more detailed model of the CVT so as to
% provide accurate behavior with less computation.
%
% <matlab:open_system('sm_wheel_loader');open_system('sm_wheel_loader/Wheel%20Loader/Transmission/Abstract','force'); Open Subsystem>

set_param([bdroot '/Wheel Loader'],'popup_cvt','Abstract')
set_param([bdroot '/Wheel Loader/Transmission/Abstract'],'LinkStatus','none')
open_system([bdroot '/Wheel Loader/Transmission/Abstract'],'force')
set_param(bdroot,'SimulationCommand','update')

%% Hydrostatic Transmission Subsystem
%
% Hydrostatic transmission with variable-displacement pump and
% fixed-displacement motor.  This system alone can also serve as a CVT, but
% it is not as efficient as the power-split design, as the mechanical path
% has a higher efficiency.
%
% <matlab:open_system('sm_wheel_loader');open_system('sm_wheel_loader/Wheel%20Loader/Transmission/Hydrostatic/Hydrostatic','force'); Open Subsystem>

set_param([bdroot '/Wheel Loader'],'popup_cvt','Hydrostatic')
set_param([bdroot '/Wheel Loader/Transmission/Hydrostatic/Hydrostatic'],'LinkStatus','none')
open_system([bdroot '/Wheel Loader/Transmission/Hydrostatic/Hydrostatic'],'force')
set_param(bdroot,'SimulationCommand','update')

%% Electrical Transmission Subsystem
%
% Electrical transmission with generator, motor, and battery.  A control
% system adjusts the power flow between the motor and the generator.  The
% control system enables these components to act as a variable ratio
% transmission.
%
% <matlab:open_system('sm_wheel_loader');open_system('sm_wheel_loader/Wheel%20Loader/Transmission/Electrical','force'); Open Subsystem>

set_param([bdroot '/Wheel Loader'],'popup_cvt','Electrical')
set_param([bdroot '/Wheel Loader/Transmission/Electrical'],'LinkStatus','none')
open_system([bdroot '/Wheel Loader/Transmission/Electrical'],'force')
set_param(bdroot,'SimulationCommand','update')


%% Power Split Hydromechanical CVT Subsystem
%
% Transmission with four planetary gears, clutches, and a parallel power
% path through a hydrostatic transmission. A hydraulic regenerative braking
% system is also included to improve fuel economy by storing kinetic energy
% as pressure in an accumulator.
%
% <matlab:open_system('sm_wheel_loader');open_system('sm_wheel_loader/Wheel%20Loader/Transmission/Power%20Split%20Hydromech','force'); Open Subsystem>

set_param([bdroot '/Wheel Loader'],'popup_cvt','Power Split Hydromechanical')
set_param([bdroot '/Wheel Loader/Transmission/Power Split Hydromech'],'LinkStatus','none')
open_system([bdroot '/Wheel Loader/Transmission/Power Split Hydromech'],'force')
set_param(bdroot,'SimulationCommand','update')

%% Vehicle Subsystem
%
% Model of the wheel loader vehicle, including front and rear articulated
% chassis, driveline, and linkage.  An optional load can be added using
% variant subsystems.  
% 
% The fidelity level of the mechanical driveline model can be set to
% different options:
%
% * *Driveline 1D* : Shafts are modeled as rotational inertias only.
% Simulation runs very quickly.
% * *Driveline 3D* : Shafts are modeled with a 3D multibody model.
% Captures all rigid body dynamics of the system.
%
% The actuation model for the steering, linkage, and implements can be
% configured to use the following options
%
% * *Ideal*: Cylinder positions are set using prescribed motion.
% Simulation runs very quickly.  Used to determine actuator requirements.
% * *Hydraulic*: Hydraulic pumps, valves, and cylinders are used to
% model the actuation system.  Used to select hydraulic components and set
% pressure levels.
%
% <matlab:open_system('sm_wheel_loader');open_system('sm_wheel_loader/Wheel%20Loader/Vehicle','force'); Open Subsystem>

set_param([bdroot '/Wheel Loader/Vehicle'],'LinkStatus','none')
open_system([bdroot '/Wheel Loader/Vehicle'],'force')

%% Actuator Subsystem: Hydraulic
%
% In this configuration the cylinders are actuated by a hydraulic system.
% Pumps are driven by the PTO shaft, one for the linkage and implements and
% another for the steering system. Valves control the flow of hydraulic
% fluid to the actuators which extend and contract to the desired position.
%
% The interface from this 1D model of the hydromechanical system and the 3D
% multibody of the linkage is a 1D mechanical connection for the rod of
% each cylinder.
%
% <matlab:open_system('sm_wheel_loader');open_system('sm_wheel_loader/Wheel%20Loader/Vehicle/Actuators/Hydraulic','force'); Open Subsystem>

set_param('sm_wheel_loader/Wheel Loader/Vehicle/Actuators/Hydraulic','LinkStatus','none')
open_system('sm_wheel_loader/Wheel Loader/Vehicle/Actuators/Hydraulic','force')

%% Driveline 3D Subsystem
%
% Models a four-wheel drive driveline using parts imported from a CAD
% assembly.  The output of the CVT connects to the output transfer gear
% which is connected via differentials to all four wheels.  A separate
% variant models the driveline as a 1D mechanical model that can be used
% for exploring the design space of shaft sizes and gear ratios.
%
% <matlab:open_system('sm_wheel_loader');open_system('sm_wheel_loader/Wheel%20Loader/Vehicle/Driveline/Driveline/Driveline%203D','force'); Open Subsystem>

set_param([bdroot '/Wheel Loader'],'popup_driveline','3D, U Joints')
set_param([bdroot '/Wheel Loader/Vehicle/Driveline/Driveline/Driveline 3D'],'LinkStatus','none')
open_system([bdroot '/Wheel Loader/Vehicle/Driveline/Driveline/Driveline 3D'],'force')
set_param(bdroot,'SimulationCommand','update')

%% Driveline 1D Subsystem
%
% Models a four-wheel drive driveline using parts imported from a CAD
% assembly.  The output of the CVT connects to the output transfer gear
% which is connected via differentials to all four wheels.  A separate
% variant models the driveline as a 1D mechanical model that can be used
% for exploring the design space of shaft sizes and gear ratios.
%
% <matlab:open_system('sm_wheel_loader');open_system('sm_wheel_loader/Wheel%20Loader/Vehicle/Driveline/Driveline/Driveline%201D/Driveline','force'); Open Subsystem>

set_param([bdroot '/Wheel Loader'],'popup_driveline','1D, CV Joints')
set_param([bdroot '/Wheel Loader/Vehicle/Driveline/Driveline/Driveline 1D/Driveline'],'LinkStatus','none')
open_system([bdroot '/Wheel Loader/Vehicle/Driveline/Driveline/Driveline 1D/Driveline'],'force')
set_param(bdroot,'SimulationCommand','update')

%% Linkage Subsystem
%
% Models the linkage subsystem for actuating the implement.  Lift and tilt
% actuators actuate the linkage to raise and lower the implement.  The
% implement can be configured to a bucket or a grapple using variant
% subsystems.
%
% <matlab:open_system('sm_wheel_loader');open_system('sm_wheel_loader/Wheel%20Loader/Vehicle/Linkage','force'); Open Subsystem>

set_param([bdroot '/Wheel Loader'],'popup_driveline','3D, U Joints')
set_param([bdroot '/Wheel Loader/Vehicle/Linkage'],'LinkStatus','none')
open_system([bdroot '/Wheel Loader/Vehicle/Linkage'],'force')
set_param(bdroot,'SimulationCommand','update')

%% Simulation Results: Y Cycle, Droop Control, *Power-Split CVT*, 1D Driveline, Bucket, Ideal Actuation
%%
%
% The results below come from a simulation test where the wheel loader
% completes a standard Y-cycle with a power-split CVT.
%

set_param([bdroot '/Wheel Loader'],'popup_engine','Droop');
set_param([bdroot '/Wheel Loader'],'popup_driveline','1D, CV Joints');
sm_wheel_loader_config_impl(bdroot,'Bucket')
set_param([bdroot '/Wheel Loader'],'popup_cvt','Power Split Hydromechanical')
set_param([bdroot '/Wheel Loader'],'popup_actuator_model','Ideal')

sim('sm_wheel_loader');

sm_wheel_loader_plot1whlspd(simlog_sm_wheel_loader,HMPST.Tire.Rad)
sm_wheel_loader_plot2vehpos(simlog_sm_wheel_loader)
sm_wheel_loader_plot3clutches(simlog_sm_wheel_loader.Wheel_Loader.Transmission)
sm_wheel_loader_plot4linkage(logsout_sm_wheel_loader.get('mVehicle').Values)
sm_wheel_loader_plot5steer(simlog_sm_wheel_loader.Wheel_Loader,logsout_sm_wheel_loader.get('mVehicle').Values)

% Get engine torque data
trqCVT = simlog_sm_wheel_loader.Wheel_Loader.Engine.Engine_Droop.Torque_Sensor.Torque_Sensor.t.series.values('N*m');
timCVT = simlog_sm_wheel_loader.Wheel_Loader.Engine.Engine_Droop.Torque_Sensor.Torque_Sensor.t.series.time;

%% Simulation Results: Y Cycle, Droop Control, Abstract CVT, 1D Driveline, Bucket, Ideal Actuation
%%
%
% The results below come from a simulation test where the wheel loader
% completes a standard Y-cycle.  The CVT is modeled abstractly as a
% variable ratio gear.
%

set_param([bdroot '/Wheel Loader'],'popup_engine','Droop');
set_param([bdroot '/Wheel Loader'],'popup_driveline','1D, CV Joints');
sm_wheel_loader_config_impl(bdroot,'Bucket')
set_param([bdroot '/Wheel Loader'],'popup_cvt','Abstract')
set_param([bdroot '/Wheel Loader'],'popup_actuator_model','Ideal')
sim('sm_wheel_loader');

sm_wheel_loader_plot1whlspd(simlog_sm_wheel_loader,HMPST.Tire.Rad)
sm_wheel_loader_plot2vehpos(simlog_sm_wheel_loader)
sm_wheel_loader_plot5steer(simlog_sm_wheel_loader.Wheel_Loader,logsout_sm_wheel_loader.get('mVehicle').Values)

% Get engine torque data
trqAbs = simlog_sm_wheel_loader.Wheel_Loader.Engine.Engine_Droop.Torque_Sensor.Torque_Sensor.t.series.values('N*m');
timAbs = simlog_sm_wheel_loader.Wheel_Loader.Engine.Engine_Droop.Torque_Sensor.Torque_Sensor.t.series.time;

%% Simulation Results: Y Cycle, Droop Control, Electrical CVT, 1D Driveline, Bucket, Ideal Actuation
%%
%
% The results below come from a simulation test where the wheel loader
% completes a standard Y-cycle with an electrical CVT.
%

set_param([bdroot '/Wheel Loader'],'popup_engine','Droop');
set_param([bdroot '/Wheel Loader'],'popup_driveline','1D, CV Joints');
sm_wheel_loader_config_impl(bdroot,'Bucket')
set_param([bdroot '/Wheel Loader'],'popup_cvt','Electrical')
set_param([bdroot '/Wheel Loader'],'popup_actuator_model','Ideal')
sim('sm_wheel_loader');

sm_wheel_loader_plot1whlspd(simlog_sm_wheel_loader,HMPST.Tire.Rad)
sm_wheel_loader_plot2vehpos(simlog_sm_wheel_loader)
sm_wheel_loader_plot5steer(simlog_sm_wheel_loader.Wheel_Loader,logsout_sm_wheel_loader.get('mVehicle').Values)
ssc_hydromech_power_split_cvt_plot4ecvtcurrent(simlog_sm_wheel_loader.Wheel_Loader.Transmission)

% Get engine torque data
trqEle = simlog_sm_wheel_loader.Wheel_Loader.Engine.Engine_Droop.Torque_Sensor.Torque_Sensor.t.series.values('N*m');
timEle = simlog_sm_wheel_loader.Wheel_Loader.Engine.Engine_Droop.Torque_Sensor.Torque_Sensor.t.series.time;

%% Simulation Results: Y Cycle, Droop Control, Hydrostatic CVT, 1D Driveline, Bucket, Ideal Actuation
%%
%
% The results below come from a simulation test where the wheel loader
% completes a standard Y-cycle with an electrical CVT.
%

set_param([bdroot '/Wheel Loader'],'popup_engine','Droop');
set_param([bdroot '/Wheel Loader'],'popup_driveline','1D, CV Joints');
sm_wheel_loader_config_impl(bdroot,'Bucket')
set_param([bdroot '/Wheel Loader'],'popup_cvt','Hydrostatic')
set_param([bdroot '/Wheel Loader'],'popup_actuator_model','Ideal')
sim('sm_wheel_loader');

sm_wheel_loader_plot1whlspd(simlog_sm_wheel_loader,HMPST.Tire.Rad)
sm_wheel_loader_plot2vehpos(simlog_sm_wheel_loader)
sm_wheel_loader_plot5steer(simlog_sm_wheel_loader.Wheel_Loader,logsout_sm_wheel_loader.get('mVehicle').Values)
ssc_hydromech_power_split_cvt_plot2pressure(simlog_sm_wheel_loader.Wheel_Loader.Transmission)

% Get engine torque data
trqHst = simlog_sm_wheel_loader.Wheel_Loader.Engine.Engine_Droop.Torque_Sensor.Torque_Sensor.t.series.values('N*m');
timHst = simlog_sm_wheel_loader.Wheel_Loader.Engine.Engine_Droop.Torque_Sensor.Torque_Sensor.t.series.time;


%% Comparison of CVT Models
%
% The following plot compares the input torque for tests with the power
% split CVT, electrical, and the abstract CVT models.

figure(44)
temp_colororder = get(gca,'defaultAxesColorOrder');

plot(timCVT,trqCVT,'-.','LineWidth',1,'DisplayName','Power Split');
hold on
plot(timAbs,trqAbs,'LineWidth',2,'DisplayName','Abstract');
plot(timHst,trqHst,":",'LineWidth',2,'DisplayName','Hydrostatic');
plot(timEle,trqEle,'-.','LineWidth',2,'DisplayName','Electrical');
hold off
ylabel('CVT Input Torque (N*m)')
xlabel('Time (s)');
legend('Location','Best')
yRange = abs(max(trqAbs)-min(trqAbs));
set(gca,'YLim',[min(trqAbs)-0.1*yRange max(trqAbs)+0.1*yRange])
title('Comparison of CVT Models')

%% Simulation Results: Y Cycle, Droop Control, *Power-Split CVT*, 1D Driveline, Bucket, *Hydraulic Actuation*
%%
%
% The results below come from a simulation test where the wheel loader
% completes a standard Y-cycle. The power-split CVT is included and the
% linkage and steering actuation is modeled as a hydraulic network.
%

close(44)
set_param([bdroot '/Wheel Loader'],'popup_engine','Droop');
set_param([bdroot '/Wheel Loader'],'popup_driveline','1D, CV Joints');
sm_wheel_loader_config_impl(bdroot,'Bucket')
set_param([bdroot '/Wheel Loader'],'popup_cvt','Power Split Hydromechanical')
set_param([bdroot '/Wheel Loader'],'popup_actuator_model','Hydraulic')

sim('sm_wheel_loader');

sm_wheel_loader_plot1whlspd(simlog_sm_wheel_loader,HMPST.Tire.Rad)
sm_wheel_loader_plot2vehpos(simlog_sm_wheel_loader)
sm_wheel_loader_plot3clutches(simlog_sm_wheel_loader.Wheel_Loader.Transmission)
sm_wheel_loader_plot4linkage(logsout_sm_wheel_loader.get('mVehicle').Values)
sm_wheel_loader_plot5steer(simlog_sm_wheel_loader.Wheel_Loader,logsout_sm_wheel_loader.get('mVehicle').Values)
sm_wheel_loader_plot6linkagehydr(simlog_sm_wheel_loader.Wheel_Loader.Vehicle.Actuators.Hydraulic)
sm_wheel_loader_plot7steerhydr(simlog_sm_wheel_loader.Wheel_Loader.Vehicle.Actuators.Hydraulic)

%%

close all
bdclose('sm_wheel_loader');
