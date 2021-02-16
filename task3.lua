pinLED1=1
pinLED2=2
order = {1000,500, 2000, 200}
gpio.mode(pinLED1, gpio.OUTPUT)
timer = tmr.create()

function waitForX(time, callback)
    timer:alarm(time, tmr.ALARM_SINGLE, function()
      callback()
    end)
end

function turnOff(LED) 
    gpio.write(LED, gpio.LOW)
end
function turnOn(LED) 
    gpio.write(LED, gpio.HIGH)
end

function nextStep() 
    if gpio.read(pinLED1) == 0 then
        turnOn(pinLED1)
    else
        turnOff(pinLED1)
    end
end

index = 1
function main()
    nextStep()
    if index > #order then
        index = 1
    end
    waitForX(order[index], function ()
        nextStep()
        waitForX(order[index+1], function ()
            index = index + 2
            main()
        end)
    end)
end
main()


