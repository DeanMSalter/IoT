function toggleLight(light, state) 
    if state == true then
        pwm.setduty(light,dc)
    else
        pwm.setduty(light,0)
    end
end

function nextStep() 
    if pwm.getduty(pin) == 0 then
        toggleLight(pin, true)
    else
        toggleLight(pin, false)
    end
end


pin = 1
dc = 1000
dcMax = 1000
rateOfChange = 50

pwm.setup(pin,1000,dc)

intervals = {2000, 300, 5000, 200}
index = 1
toggleLight(pin, true)

myTimer = tmr.create()
myTimer:register(intervals[1], tmr.ALARM_AUTO, function()
    nextStep()
    if (index >= #intervals) then
      index = 1
    else
      index = index + 1
    end
    myTimer:interval(intervals[index])
end)
myTimer:start()

dimerTimer = tmr.create()
dimerTimer:alarm(200,tmr.ALARM_AUTO,function()
    dc=dc-rateOfChange
    pwm.setduty(pin,dc)
    if (dc<=rateOfChange) then
        rateOfChange = -100
    elseif (dc >= dcMax - -rateOfChange) then
        rateOfChange = 100
    end
end
)