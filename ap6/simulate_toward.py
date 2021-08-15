from simglucose.simulation.env import T1DSimEnv
from simglucose.controller.basal_bolus_ctrller import BBController
from simglucose.sensor.cgm import CGMSensor
from simglucose.actuator.pump import InsulinPump
from simglucose.patient.t1dpatient import T1DPatient
from simglucose.simulation.scenario_gen import RandomScenario
from simglucose.simulation.scenario import CustomScenario
from simglucose.simulation.sim_engine import SimObj, sim, batch_sim
from datetime import timedelta
from datetime import datetime

# specify start_time as the beginning of today
now = datetime.now()
start_time = datetime.combine(now.date(), datetime.min.time())
start_time = datetime.fromisoformat("2021-08-15T19:00:00")

# Specify results saving path
path = "./results"

## Create a simulation environment
# patient = T1DPatient.withName("adult#001")
# sensor = CGMSensor.withName("Navigator", seed=1)
# pump = InsulinPump.withName("Cozmo")
# scenario = RandomScenario(start_time=start_time, seed=1)
# env = T1DSimEnv(patient, sensor, pump, scenario)
#
## Create a controller
# controller = BBController()
#
## Put them together to create a simulation object
# s1 = SimObj(env, controller, timedelta(days=1), animate=False, path=path)
# results1 = sim(s1)
# print(results1)

# --------- Create Custom Scenario --------------
# Create a simulation environment
patient = T1DPatient.withName("adult#001")
sensor = CGMSensor.withName("Navigator", seed=1)
pump = InsulinPump.withName("Cozmo")
# custom scenario is a list of tuples (time, meal_size)
scen = [(0, 100)]
scenario = CustomScenario(start_time=start_time, scenario=scen)
env = T1DSimEnv(patient, sensor, pump, scenario)

# Create a controller
controller = BBController()

# Put them together to create a simulation object
s2 = SimObj(env, controller, timedelta(days=0.5), animate=False, path=path)
results2 = sim(s2)
print(results2)


# --------- batch simulation --------------
# Re-initialize simulation objects
s2.reset()

# create a list of SimObj, and call batch_sim
s = [s2]
results = batch_sim(s, parallel=True)
print(results)
