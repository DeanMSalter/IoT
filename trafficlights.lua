function getCurrentLight() 
    local stopStatus = pwm.getduty(pinSTOP)
    local waitStatus = pwm.getduty(pinWAIT)
    local goStatus = pwm.getduty(pinGO)

    if (stopStatus > 0) then
        return pinSTOP
    elseif (waitStatus > 0) then
        return pinWAIT
    elseif (goStatus > 0) then
        return pinGO
    else
        return pinSTOP
    end
end

function toggleLight(light, state) 
    if state == true then
        pwm.setduty(light,dc)
    else
        pwm.setduty(light,0)
    end
end


pinSTOP=1
pinWAIT=2
pinGO=3

dc=1000

pwm.setup(pinSTOP,1000,dc)
pwm.setup(pinWAIT,1000,dc)
pwm.setup(pinGO,1000,dc)

myTimer = tmr.create()

goTime = 2000
stopTime = 4000
waitTime = 500

intervals = {stopTime, waitTime, goTime, waitTime}
index = 1

nextLight = pinSTOP


toggleLight(pinSTOP, true)
toggleLight(pinWAIT, true)
toggleLight(pinGO, true)


myTimer:register(intervals[1], tmr.ALARM_AUTO, function()
    local currentLight = getCurrentLight()
    toggleLight(currentLight, false)

    if (currentLight == pinGO) then
        nextLight = pinSTOP
        toggleLight(pinWAIT, true)
    elseif (currentLight == pinSTOP) then
        nextLight = pinGO
        toggleLight(pinWAIT, true)
    else 
        toggleLight(nextLight, true)
    end

    if (index >= #intervals) then
      index = 1
    else
      index = index + 1
    end
    myTimer:interval(intervals[index])
end)
myTimer:start()
