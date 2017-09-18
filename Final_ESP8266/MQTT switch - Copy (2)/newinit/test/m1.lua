
file.open("mqtt-config.lua", "r")
link = file.readline()

link = string.sub(link,0,string.len(link)-1)

userhub = file.readline()
userhub = string.sub(userhub,0,string.len(userhub)-1)

passhub = file.readline()
passhub = string.sub(passhub,0,string.len(passhub)-1)
file.close()
mac=wifi.sta.getmac()
print("hello mqtt file")

m = mqtt.Client("clientiddddsfsad", 12 , userhub,passhub)


-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client don't send keepalive packet

m:lwt("/lwt",mac, 1,0)

m:on("connect", function(client) print ("connected")
-- publish a message with data = hello, QoS = 0, retain = 0

end)
m:on("offline", function(client) print ("offline")
tact = 0
end)

-- on publish message receive event
m:on("message", function(client, topic, data) 
name , pass = wifi.ap.getconfig()
    --if string.find(topic,"/updatestatus") == 1 then
    
 --   end
    myString = topic.."/"..data
    
  print(topic .. ":" ) 
  if data ~= nil then
    print(data)
   
    if(myString == "/"..mac.."/" .. name .. "/switch2/sw-on")then    --Compares Received Instruction On Port
      print("switch 2 off")
      ESPStatusNew2 = 1;      --Change New ESP Status To 1 In Recognition That Data Is Received & Asking To Turn ON This Particular Device
      myString = "";          --Empty The String So That It Is Ready For Next String Input From Port
      algorithm (ESPStatusNew2,ESPStatusOld2,buttonStatusNew2,buttonStatusOld2,D0)
      ESPStatusOld2 = ESPStatusNew2   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
      buttonStatusOld2 = buttonStatusNew2
      
    elseif(myString == "/"..mac.."/" .. name .. "/switch2/sw-off")then  --Compares Received Instruction On Port
      print("switch 2 on")
      ESPStatusNew2 = 0;    --Change New ESP Status To 0 In Recognition That Data Is Received & Asking To Turn OFF This Particular Device
      myString = "";      --Empty The String So That It Is Ready For Next String Input From Port
      algorithm (ESPStatusNew2,ESPStatusOld2,buttonStatusNew2,buttonStatusOld2,D0)
      ESPStatusOld2 = ESPStatusNew2   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
      buttonStatusOld2 = buttonStatusNew2
      
    end
    --------------------------------------------
    if(myString == "/"..mac.."/" .. name .. "/switch3/sw-on")then    --Compares Received Instruction On Port
      print("switch 3 off")
      ESPStatusNew3 = 1;      --Change New ESP Status To 1 In Recognition That Data Is Received & Asking To Turn ON This Particular Device
      myString = "";          --Empty The String So That It Is Ready For Next String Input From Port
      algorithm (ESPStatusNew3,ESPStatusOld3,buttonStatusNew3,buttonStatusOld3,D5)
      ESPStatusOld3 = ESPStatusNew3   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
      buttonStatusOld3 = buttonStatusNew3
      
    elseif(myString == "/"..mac.."/" .. name .. "/switch3/sw-off")then  --Compares Received Instruction On Port
      print("switch 3 on")
      ESPStatusNew3 = 0;    --Change New ESP Status To 0 In Recognition That Data Is Received & Asking To Turn OFF This Particular Device
      myString = "";      --Empty The String So That It Is Ready For Next String Input From Port
      algorithm (ESPStatusNew3,ESPStatusOld3,buttonStatusNew3,buttonStatusOld3,D5)
      ESPStatusOld3 = ESPStatusNew3   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
      buttonStatusOld3 = buttonStatusNew3
     
    end
  
    if(myString == "/"..mac.."/" .. name .. "/switch5/sw-on")then    --Compares Received Instruction On Port
      print("switch 5 off")
      ESPStatusNew5 = 1;      --Change New ESP Status To 1 In Recognition That Data Is Received & Asking To Turn ON This Particular Device
      myString = "";          --Empty The String So That It Is Ready For Next String Input From Port
      algorithm (ESPStatusNew5,ESPStatusOld5,buttonStatusNew5,buttonStatusOld5,D7)
      ESPStatusOld5 = ESPStatusNew5   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
      buttonStatusOld5 = buttonStatusNew5
     
    elseif(myString == "/"..mac.."/" .. name .. "/switch5/sw-off")then  --Compares Received Instruction On Port
      print("switch 5 on")
      ESPStatusNew5 = 0;    --Change New ESP Status To 0 In Recognition That Data Is Received & Asking To Turn OFF This Particular Device
      myString = "";      --Empty The String So That It Is Ready For Next String Input From Port
      algorithm (ESPStatusNew5,ESPStatusOld5,buttonStatusNew5,buttonStatusOld5,D7)
      ESPStatusOld5 = ESPStatusNew5   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
      buttonStatusOld5 = buttonStatusNew5
   
    end
   end 
  
  
  
end)
-- subscribe topic with qos = 0

pl = ""
-- for TLS: m:connect("192.168.11.118", secure-port, 1)
m:connect(link, 1883, 0, function(client) 
print("connected here") 
tact = 1
temp = 1
--tmr.stop(1)
if temp == 1 then
dofile("fun.lua")

end
tmr.delay(1500000)
mac=wifi.sta.getmac()

name , pass = wifi.ap.getconfig()
print(name)
print(string.len(name))
temp = 1


--m:subscribe("/topic/arsalan",0, function(client) print("subscribe success")
m:subscribe("/"..mac.."/"..name.."/switch2",1, function(client)
--mqtt:subscribe("/"..name.."/switch1",1, function(client)
m:subscribe("/"..mac.."/"..name.."/switch5",1, function(client)
m:subscribe("/"..mac.."/"..name.."updatestatus",1, function(client)
m:subscribe("/"..mac.."/"..name.."/switch3",1, function(client)
  end)
  end)
  end)
 -- end)
 -- end)

end)
--m:close()
--m:publish("/topic/arsalan","hello",0,0, function(client) print("sent") end)
end, function(client, reason) print("failed reason: "..reason) end)

-- Calling subscribe/publish only makes sense once the connection
-- was successfully established. In a real-world application you want
-- move those into the 'connect' callback or make otherwise sure the 
-- connection was established.


--m:subscribe("/topic/arsalan",0, function(client) print("subscribe success") end)

--m:publish("/topic/arsalan","hello",0,0, function(client) print("sent") end)
--mqtt:close()
--m:close()
