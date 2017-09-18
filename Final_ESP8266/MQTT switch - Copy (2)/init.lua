 ESPStatusNew1 = 0
 ESPStatusOld1 = 0
 buttonStatusNew1 = 0
 buttonStatusOld1 = 0
 ESPStatusNew2 = 0
 ESPStatusOld2 = 0
 buttonStatusNew2 = 0
 buttonStatusOld2 = 0
 ESPStatusNew3 = 0
 ESPStatusOld3 = 0
 buttonStatusNew3 = 0
 buttonStatusOld3 = 0
 ESPStatusNew4 = 0
 ESPStatusOld4 = 0
 buttonStatusNew4 = 0
 buttonStatusOld4 = 0
 ESPStatusNew5 = 0
 ESPStatusOld5 = 0
 buttonStatusNew5 = 0
 buttonStatusOld5 = 0
 
 
--uart.alt(1)
 x = 0
 temp = 0
 
D0 = 0 --switch 1
gpio.mode(D0, gpio.OUTPUT)
D1 = 1 --switch 1
gpio.mode(D1, gpio.INT,gpio.PULLUP)
--D2 = 9  --switch 2 
--gpio.mode(D2, gpio.OUTPUT)
--D3 = 2  -- switch 2  ---- use it in place of D4
--gpio.mode(D3, gpio.INT,gpio.PULLUP)
D5 = 5 --switch 3
gpio.mode(D5, gpio.OUTPUT)
D6 = 6 --switch 3
gpio.mode(D6, gpio.INT,gpio.PULLUP)
D7 = 8  --switch 5 or fan
gpio.mode(D7, gpio.OUTPUT)
D8 = 7  -- switch 5 or fan
gpio.mode(D8, gpio.INT,gpio.PULLUP)
--RX = 9 --switch 6 fan
--gpio.mode(RX, gpio.OUTPUT),
--TX = 10  -- switch 6 fan
--gpio.mode(TX, gpio.INT,gpio.PULLUP)
--D4 = 4  --switch 4
--gpio.mode(D4, gpio.OUTPUT)
--SDD3 = 12  --switch 4
--gpio.mode(SDD3, gpio.INPUT)
--------------------------------------------------

dofile("switch2.lua")
dofile("switch3.lua")
dofile("switch4.lua")
dofile("switch5.lua")

file.open("switch1.lua","r")
switch1_data = file.readline()
--print("switch1 read")
file.close()

--file.open("PWM.lua", "r")
--pwmdata = file.read()
--file.close()

--index1 = string.find(switch1_data,"HIGH")
--index2 = string.find(switch1_data,"LOW")

--if index1 ~= nil then
  -- print("arsalan")
-- pwm.setup(D2,1000,0) --or 255
-- pwm.stop(D2)
--end
--if index2 ~= nil then
   -- print("Ahmed")
--  pwm.setup(D2,1000,pwmdata) --or 255
--  pwm.stop(D2)
--  pwm.start(D2)
--end
--------------------------------------------------

function algorithm (enew,eold,bnew,bold,pinout)
  --print("Entered Algorithm")
  if (enew ~= eold) or (bnew ~= bold) then  --This Equation Checks If There Is Any Change In State Of ESP or Hardware Button
    --print("entered algo condition")
    --print(enew,eold,bnew,bold)
    
    out = bit.bor((bit.band(bit.bnot(bold),bnew)),(bit.band(bit.bnot(eold),enew)))  --Karnaugh Map Equation That Determines What Exactly The Change Is
    print(out)
    
    if pinout == 0 then
    file.open("switch2.lua", "w+")
    elseif pinout == 5 then
    file.open("switch3.lua", "w+")
    elseif pinout == 4 then
    file.open("switch4.lua", "w+")
    elseif pinout == 8 then
    file.open("switch5.lua", "w+")
    end

    
    if out == 0 then
    --print("1")
    gpio.write(pinout, gpio.HIGH)   --Change The Pin Status On Arduino Corresponding To This Device To Either Turn It On Or Off
    file.writeline("gpio.write(" .. pinout .. ", gpio.HIGH)")
    file.close()
    elseif out == 1  then
    --print("0")
    gpio.write(pinout, gpio.LOW)
    file.writeline("gpio.write(" .. pinout .. ", gpio.LOW)")
    file.close()
    end
    eold = enew   -- Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
    --print("old esp =",eold)
    bold = bnew  -- Equates Buttons Old & New Status So Now It's Ready To Detect A Change Again   
    --print("old button  =",bold)
  end
  --print("Leaving Algorith")
end

function switch2()
 --print("switch2 triggered")
 --print("D3 value =" ,gpio.read(D3))
 buttonStatusNew2 = gpio.read(D1)
 algorithm (ESPStatusNew2,ESPStatusOld2,buttonStatusNew2,buttonStatusOld2,D0)
 
 ESPStatusOld2 = ESPStatusNew2   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
 buttonStatusOld2 = buttonStatusNew2
 name , pass = wifi.ap.getconfig()
 if temp == 1 then
 mqtt:publish("/".. name .."/switch2/status/",buttonStatusNew2, 2, 1, function(conn)
  --          print("message published")
        end)--publisher end
  end
end
function switch3()
 --print("switch3 triggered")
 --print("D6 value =" ,gpio.read(D6))
 buttonStatusNew3 = gpio.read(D6)
 algorithm (ESPStatusNew3,ESPStatusOld3,buttonStatusNew3,buttonStatusOld3,D5)
 
 ESPStatusOld3 = ESPStatusNew3   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
 buttonStatusOld3 = buttonStatusNew3
 name , pass = wifi.ap.getconfig()
 if temp == 1 then
 mqtt:publish("/".. name .."/switch3/status/",buttonStatusNew3, 2, 1, function(conn)
   --         print("message published")
        end)--publisher end
  end
end
function switch4()
 --print("switch4 triggered")
 --print("SDD3 value =" ,gpio.read(SDD3))
 buttonStatusNew4 = gpio.read(SDD3)
 algorithm (ESPStatusNew4,ESPStatusOld4,buttonStatusNew4,buttonStatusOld4,D4)
 --print("Leaving funct ledtrig1")
 ESPStatusOld4 = ESPStatusNew4   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
 buttonStatusOld4 = buttonStatusNew4
 name , pass = wifi.ap.getconfig()
 if temp == 1 then
 mqtt:publish("/".. name .."/switch4/status/",buttonStatusNew4, 2, 1, function(conn)
   --         print("message published")
        end)--publisher end
  end
end

function deletefile()
    file.remove("init.lua")

end

function switch5()
 --print("switch5 triggered")
 --print("D8 value =" ,gpio.read(D8))
 buttonStatusNew5 = gpio.read(D8)
 algorithm (ESPStatusNew5,ESPStatusOld5,buttonStatusNew5,buttonStatusOld5,D7)
 ESPStatusOld5 = ESPStatusNew5   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
 buttonStatusOld5 = buttonStatusNew5
 name , pass = wifi.ap.getconfig()
 if temp == 1 then
 mqtt:publish("/".. name .."/switch5/status/",buttonStatusNew5, 2, 1, function(conn)
   --         print("message published")
        end)--publisher end
  end
end

--function PWM()

--file.open("PWM.lua", "r")
--pwmdata = file.read()
--file.close()
-- print("PWM")
-- print("DI value =" ,gpio.read(D3))
-- fan = gpio.read(D3)
-- file.open("switch1.lua", "w+")
 
-- if fan == 1 then
-- file.writeline("HIGH")
 --print("writing to switch 1 file")
-- file.close()
-- pwm.setup(D2,1000,0) --or 255
-- pwm.stop(D2)
 --gpio.write(D2, gpio.LOW)
 --if temp == 1 then
-- mqtt:publish("/".. name .."/switch1/status/",gpio.read(D3), 2, 1, function(conn)
   --         print("message published")
  --      end)--publisher end
--  end
-- elseif fan == 0 then
-- file.writeline("LOW")
-- print("writing to switch 1 file")
-- file.close()
-- pwm.setup(D2,1000,pwmdata) --or 255
-- pwm.stop(D2)
-- pwm.start(D2)
-- if temp == 1 then
-- mqtt:publish("/".. name .."/switch1/status/",pwmdata, 2, 1, function(conn)
   --         print("message published")
  --      end)--publisher end
 -- end
-- end
 
--end
-----------------------------------------
--gpio.trig(D3,"both",PWM)
gpio.trig(D1,"both",switch2)
gpio.trig(D6,"both",switch3)
--gpio.trig(SDD3,"both",switch4)
gpio.trig(D8,"both",switch5)
--gpio.trig(TX,"both",deletefile)

----------------------------------------

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
    
--print("ESP8266 mode is: " .. wifi.getmode())
--print("The module MAC address is: " .. wifi.ap.getmac())

sv=net.createServer(net.TCP) 
sv:listen(325,function(c)
  --    print("entered TCP server")
      tmr.alarm(1, 1000, 0, function()    
          --print("ip")
             ipap,snap,gwap= wifi.ap.getip()
             mac=wifi.sta.getmac()
             c:send(mac)
             print("data send")
              
             tmr.delay(500000)
          end) 
      c:on("receive", function(ab, pl)
      print (pl);
      hub = string.find(pl,"ASDFG");
      --print(hub);
      ch = string.find(pl,"ABCDE");
      --print(ch)
      na = string.find(pl,"QWERT");
      --print(na)


     if ((ch == 1) and (na ~= 1) and (hub ~= 1))then
       SOS = 0
     v = string.find(pl,"\n")
     l = string.len (pl)
     print(v,l)   
     PW = string.sub (pl, v+1 , l-1)
     UN = string.sub (pl, 6 ,v-1)
         print(string.sub (pl, v+1 , l-1))
         print(string.len (PW))
         print(string.sub (pl, 6 ,v-1))
         print(string.len (UN))
         wifi.sta.disconnect()
         
         wifi.sta.config(UN,PW)   
         wifi.sta.connect()
         ip = wifi.sta.getip()
         print(ip)
       if(ip == nil)then  
      tmr.alarm(0,25, 1, function() 
       ip2 , s , g = wifi.sta.getip()
    --   print ("timer 0")
       print(ip2,s,g)
        if(ip2 ~= nil)then
      -- print("connected") 
       SOS = 1     
      tmr.stop(0) 
     if(SOS == 1)then
        --print("Sending data") 
          tmr.alarm(1, 2000, 0, function()    
          --print("ip")
             ipap,snap,gwap= wifi.ap.getip()
             mac=wifi.sta.getmac()
             c:send("Connected".."\n".."MacAddr " .. mac .."\n")
            -- print("data send")
              
             tmr.delay(500000)
          end) 
     end
  
    
      file.open("config2.lua", "w+")
      file.seek("set")
     
       file.writeline(' ')
       file.write('UN ="')
       file.write(UN)
       file.write('"')
       file.writeline(' ')
       file.write('PW ="')
       file.write(PW)
       file.write('"')
       file.writeline(' ')
       file.writeline('wifi.sta.config(UN,PW)')
  
       file.writeline('wifi.sta.connect()')
       file.writeline('wifi.sta.getip()')
       file.flush()
       file.close() 
       
      end
      end) 
      elseif(ip ~= nil) then
      --print(ip)           
end
        
 elseif((ch ~= 1) and (na ~= 1) and (hub ~= 1))then 
         
         R1 = string.find(pl,"R");
        if(R1 == 1)then
        uart.alt(0)
        file.open("config2.lua", "w+")
        file.seek("set")
        file.writeline('print("SSID")')
        file.flush()
        file.close()
        node.restart()
        elseif(R1 ~= 1)then
        --print("not resetting")
        end
  elseif((na == 1) and (ch ~= 1) and (hub ~= 1))then
 
     v1 = string.find(pl,"\n")
     l1 = string.len (pl)
     --print(v1,l1)   
         pass = string.sub (pl, v1+1 , l1-1)
         name = string.sub (pl, 6 ,v1-1)
         --print(string.sub (pl, 6 ,v1-1))
         print(string.len (name))
         --print(string.sub (pl, v1+1 , l1-1))
         print(string.len (pass))

         file.open("config1.lua", "w+")
      file.seek("set")
      file.writeline(' ')
       file.writeline('cfg={}')
       file.writeline(' ')
       file.write('cfg.ssid="')
       file.write(name)
       file.write('"')
       file.writeline(' ')
       file.write('cfg.pwd="')
       file.write(pass)
       file.write('"')
       file.writeline(' ')
       file.writeline('wifi.ap.config(cfg)')
       file.flush()
       file.close()
       node.restart()

elseif((na ~= 1) and (ch ~= 1) and (hub == 1))then
     
     end1 = string.find(pl,"/")
     end2 = string.find(pl,"/",(end1 + 1))
     end3 = string.find(pl,"\n")
     l2 = string.len (pl)
    
     --print(v2,l2)        
         hubip = string.sub (pl, 6 ,end1-1)
         --print(string.sub (pl, 6 ,end1-1))
         --print(string.len (hubip))
         hubUN = string.sub (pl, end1 +1 ,end2-1)
         --print(string.sub (pl, end1 +1 ,end2-1))
        -- print(string.len (hubUN))
         hubPW = string.sub (pl, end2+1 ,end3-1)
         --print(string.sub (pl, end2+1 ,end3-1))
        -- print(string.len (hubPW))
        -- file.open("mqtt-config.lua", "w+")
        -- file.writeline(hubip)
        -- file.writeline(hubUN)
        -- file.writeline(hubPW)
        -- file.close()
         if temp == 1 then
         --mqtt:close()
         close = mqtt:close()
         print("close")
        -- print(mqtt:close())
         --tmr.delay(5000)
         --dofile("mqtt_new.lua")
      end
      
 temp = 1
end   


end)

end)

---------------
a ,b, c = wifi.sta.getconfig();
   -- print(a .. "," .. b .."," .. c)
    --print(string.len(a))
 if (string.len(a) ~= 0) then
tmr.alarm(0, 2000, 1, function()
   -- if wifi.sta.status() == 3 then
   -- tmr.stop(0)
   -- end
    if wifi.sta.getip() == nil then
        print("Connecting to AP...\n")
       
    elseif (wifi.sta.getip() ~= nil) and (temp == 1) then
        ip, nm, gw = wifi.sta.getip()
        
        -- Debug info
        print("\n\nIP Info: \nIP Address: ",ip)
        --print("Netmask: ",nm)
       -- print("Gateway Addr: ",gw,'\n')
        
        tmr.stop(0)     -- Stop the polling loop

        --rint("ESP8266 mode is: " .. wifi.getmode())
     -- print("The module MAC address is: " .. wifi.ap.getmac())
        tmr.delay(1000)
         print ("crashed here")
        -- dofile("mqtt.lua") 
         
         
          end 
        
end
--print("leaving MQTT")
--FileView done.
