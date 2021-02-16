buttonPin = 2
ledPin = 3
dhtPin = 1
gpio.mode(buttonPin, gpio.INPUT)
gpio.write(buttonPin, gpio.LOW)
pushed = 0
mytimer = tmr.create()
mytimer:register(100, 1, function()
    if gpio.read(buttonPin)==1 and pushed == 0 then
        pushed = 1
        gpio.write(ledPin, gpio.HIGH)
    elseif gpio.read(buttonPin) == 0 then
        pushed = 0
        gpio.write(ledPin, gpio.LOW)
    end
end)
mytimer:start()


tempTimer1 = tmr.create()
tempTimer1:register(1000, tmr.ALARM_AUTO, function()
    if pushed == 1 then
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
tempTimer1:start()

