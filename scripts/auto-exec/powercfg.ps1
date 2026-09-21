# Power Configuration
# ac - Wall power
# dc - Battery power
# where UPS ?

# Screen sleeps after 3 min
    powercfg /Change monitor-timeout-ac 3
    powercfg /Change monitor-timeout-dc 3

# Disk sleep
    powercfg /Change disk-timeout-ac 0 # Reduces spin down wear
    powercfg /Change disk-timeout-dc 10 # Reduces battery drain

# Sleep faster, assuming s2idle for faster wakeup
    powercfg /Change standby-timeout-ac 5
    powercfg /Change standby-timeout-dc 5

# Hibernate
    powercfg /H ON # For fast startup and hibernate
    powercfg /Change hibernate-timeout-ac 0 # Preserve disk lifespan on AC
    powercfg /Change hibernate-timeout-dc 360 # Hibernate like Macbooks do

# Power Plan
    #powercfg.exe -import "!cd!\powerplan.pow">nul
