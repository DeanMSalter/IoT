buttonPin = 2
ledPin = 3
dhtPin = 1
gpio.mode(buttonPin, gpio.INPUT)
gpio.write(buttonPin, gpio.LOW)
output = false
buttonPushedTime = 0
mytimer = tmr.create()
mytimer:register(100, 1, function()
    buttonState = gpio.read(buttonPin)
    if buttonState == 1 then
        gpio.write(ledPin, gpio.HIGH)
    elseif buttonState == 0 then
        gpio.write(ledPin, gpio.LOW)
    end
end)
mytimer:start()

toggleTimer = tmr.create()
toggleTimer:register(1000, 1, function()
    buttonState = gpio.read(buttonPin)
    if buttonState == 1 then
        buttonPushedTime = buttonPushedTime + 1
        gpio.write(ledPin, gpio.HIGH)
    elseif buttonState == 0 then
        buttonPushedTime = 0
        gpio.write(ledPin, gpio.LOW)
    end

    if (buttonPushedTime == 2) then
        output = not output
        print (output)
    end
end)
toggleTimer:start()


tempTimer = tmr.create()
tempTimer:register(5000, tmr.ALARM_AUTO, function()
    if output == true then
        status, temp, humi, temp_dec, humi_dec = dht.read11(dhtPin)
        if status == dht.OK then
            --3 different status
            --dht.OK, dht.ERROR_CHECKSUM, dht.ERROR_TIMEOUT
            print("DHT Temperature:"..temp..";".."Humidity:"..humi)
            -- 2 dots are used for concatenation
        elseif status == dht.ERROR_CHECKSUM then
            print("DHT Checksum error.")
        elseif status == dht.ERROR_TIMEOUT then
            print("DHT timed out.")
        end
    end
end)
tempTimer:start()

