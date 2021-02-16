pinDim = 3
dc=1000
dcMax = 1000
rateOfChange = 50

pwm.setup(pinDim,1000,dc)
pwm.start(pinDim)
mytimer = tmr.create()

mytimer:alarm(200,tmr.ALARM_AUTO,function()
    dc=dc-rateOfChange
    print(dc)
    pwm.setduty(pinDim,dc)
    if (dc<=rateOfChange) then
        rateOfChange = -100
    elseif (dc >= dcMax - -rateOfChange) then
        rateOfChange = 100
    end
end
)