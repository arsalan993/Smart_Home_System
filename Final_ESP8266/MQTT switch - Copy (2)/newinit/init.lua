
 ESPStatusNew2 = 0
 ESPStatusOld2 = 0
 buttonStatusNew2 = 0
 buttonStatusOld2 = 0
 ESPStatusNew3 = 0
 ESPStatusOld3 = 0
 buttonStatusNew3 = 0
 buttonStatusOld3 = 0
 
 ESPStatusNew5 = 0
 ESPStatusOld5 = 0
 buttonStatusNew5 = 0
 buttonStatusOld5 = 0
 
 
 x = 0
 temp = 0
 
D0 = 0 --switch 1
gpio.mode(D0, gpio.OUTPUT)
D1 = 1 --switch 1
gpio.mode(D1, gpio.INT)

D5 = 5 --switch 3
gpio.mode(D5, gpio.OUTPUT)
D6 = 6 --switch 3
gpio.mode(D6, gpio.INT)
D7 = 8  --switch 5 or fan
gpio.mode(D7, gpio.OUTPUT)
D8 = 7  -- switch 5 or fan
gpio.mode(D8, gpio.INT)

dofile("switch2.lua")
dofile("switch3.lua")
dofile("switch5.lua")

function algorithm (enew,eold,bnew,bold,pinout)
  --print("Entered Algorithm")
  if (enew ~= eold) or (bnew ~= bold) then  --This Equation Checks If There Is Any Change In State Of ESP or Hardware Button
   
    
    out = bit.bor((bit.band(bit.bnot(bold),bnew)),(bit.band(bit.bnot(eold),enew)))  --Karnaugh Map Equation That Determines What Exactly The Change Is
    print(out)
    
    if pinout == 0 then
    file.open("switch2.lua", "w+")
    elseif pinout == 5 then
    file.open("switch3.lua", "w+")
    elseif pinout == 8 then
    file.open("switch5.lua", "w+")
    end
    
    
    if out == 1 then
    
    gpio.write(pinout, gpio.HIGH)   --Change The Pin Status On Arduino Corresponding To This Device To Either Turn It On Or Off
    file.writeline("gpio.write(" .. pinout .. ", gpio.HIGH)")
    file.close()
    elseif out == 0  then
    --print("0")
    gpio.write(pinout, gpio.LOW)
    file.writeline("gpio.write(" .. pinout .. ", gpio.LOW)")
    file.close()
    end
    eold = enew   -- Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
    
    bold = bnew  -- Equates Buttons Old & New Status So Now It's Ready To Detect A Change Again   
   
  end
  
end
function switch2()
 
 buttonStatusNew2 = gpio.read(D1)
 algorithm (ESPStatusNew2,ESPStatusOld2,buttonStatusNew2,buttonStatusOld2,D0)
 
 ESPStatusOld2 = ESPStatusNew2   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
 buttonStatusOld2 = buttonStatusNew2
 name , pass = wifi.ap.getconfig()
 str = " "
 if temp == 1 then
 if (buttonStatusNew2 == 1)then
     str = "sw-on"
 elseif (buttonStatusNew2 == 0)then
     str = "sw-off"
 end
 mqtt:publish("/".. name .."/switch2",str, 2, 1, function(conn)
        end)--publisher end
  end
end
function switch3()
 buttonStatusNew3 = gpio.read(D6)
 algorithm (ESPStatusNew3,ESPStatusOld3,buttonStatusNew3,buttonStatusOld3,D5)
 
 ESPStatusOld3 = ESPStatusNew3   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
 buttonStatusOld3 = buttonStatusNew3
 name , pass = wifi.ap.getconfig()
  str = " "
 if temp == 1 then
 if (buttonStatusNew3 == 1)then
     str = "sw-on"
 elseif (buttonStatusNew3 == 0)then
     str = "sw-off"
 end
 mqtt:publish("/".. name .."/switch3",str, 2, 1, function(conn)
   --        
        end)--publisher end
  end
end

function switch5()

 buttonStatusNew5 = gpio.read(D8)
 algorithm (ESPStatusNew5,ESPStatusOld5,buttonStatusNew5,buttonStatusOld5,D7)
 ESPStatusOld5 = ESPStatusNew5   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
 buttonStatusOld5 = buttonStatusNew5
 name , pass = wifi.ap.getconfig()
str = " "
 if temp == 1 then
 if (buttonStatusNew5 == 1)then
     str = "sw-on"
 elseif (buttonStatusNew5== 0)then
     str = "sw-off"
 end
 mqtt:publish("/".. name .."/switch5",str, 2, 1, function(conn)
   
        end)--publisher end
  end
end



gpio.trig(D1,"both",switch2)
gpio.trig(D6,"both",switch3)

gpio.trig(D8,"both",switch5)

CMDFILE = "mqtt.lua" 
wifi.setmode(wifi.STATIONAP)
dofile("config1.lua")
 table={}
    table=wifi.ap.getclient()
    for mac,ip in pairs(table) do
      print(mac,ip)
    end
   
 cfg =
  {
    ip="192.168.50.2",
    netmask="255.255.255.0",
    gateway="192.168.50.1"
  }
  wifi.ap.setip(cfg)
  dofile("config2.lua")
   print("done it")
    
dofile("script1.lua")
---------------
a ,b, c = wifi.sta.getconfig();
 
 if (string.len(a) ~= 0) then
tmr.alarm(0, 2000, 1, function()

    if wifi.sta.getip() == nil then
        print("Connecting to AP...\n")
       
    elseif (wifi.sta.getip() ~= nil) then
        ip, nm, gw = wifi.sta.getip()
 
        print("\n\nIP Info: \nIP Address: ",ip)
      
        tmr.stop(0)     -- Stop the polling loop
     
        tmr.delay(1000)
        
        dofile(CMDFILE) 
         
         
          end 
       
end)
end

