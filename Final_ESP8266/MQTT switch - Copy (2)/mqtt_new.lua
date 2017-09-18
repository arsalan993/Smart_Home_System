
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

--mqtt = mqtt.Client("newcliesfdsdntvjjjj", 10, userhub, passhub)

mqtt:lwt("/lwt",mac, 1,1)

mqtt:on("connect", function(client)
print ("i am clientected")
--node.restart()
end)

mqtt:on("offline", function(client) 
print ("offline") 
--dofile("mqtt_new.lua")
--if (temp2 == 0)then
--node.restart()
--end
end)

-- on receive message
mqtt:on("message", function(client, topic, data)
      --control here  
     print(topic)
     print(data) 
      
    name , pass = wifi.ap.getconfig()
    --if string.find(topic,"/updatestatus") == 1 then
    
 --   end
    myString = topic.."/"..data
    print(myString)

if(data ~= nil)then
    ------------------------------------------------
    if(myString == "/" .. name .. "/switch2/sw-on")then    --Compares Received Instruction On Port
      print("switch 2 on")
      ESPStatusNew2 = 1;      --Change New ESP Status To 1 In Recognition That Data Is Received & Asking To Turn ON This Particular Device
      myString = "";          --Empty The String So That It Is Ready For Next String Input From Port
      algorithm (ESPStatusNew2,ESPStatusOld2,buttonStatusNew2,buttonStatusOld2,D0)
      ESPStatusOld2 = ESPStatusNew2   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
      buttonStatusOld2 = buttonStatusNew2
      
    elseif(myString == "/" .. name .. "/switch2/sw-off")then  --Compares Received Instruction On Port
      print("switch 2 off")
      ESPStatusNew2 = 0;    --Change New ESP Status To 0 In Recognition That Data Is Received & Asking To Turn OFF This Particular Device
      myString = "";      --Empty The String So That It Is Ready For Next String Input From Port
      algorithm (ESPStatusNew2,ESPStatusOld2,buttonStatusNew2,buttonStatusOld2,D0)
      ESPStatusOld2 = ESPStatusNew2   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
      buttonStatusOld2 = buttonStatusNew2
      
    end
    --------------------------------------------
    if(myString == "/" .. name .. "/switch3/sw-on")then    --Compares Received Instruction On Port
      print("switch 3 on")
      ESPStatusNew3 = 1;      --Change New ESP Status To 1 In Recognition That Data Is Received & Asking To Turn ON This Particular Device
      myString = "";          --Empty The String So That It Is Ready For Next String Input From Port
      algorithm (ESPStatusNew3,ESPStatusOld3,buttonStatusNew3,buttonStatusOld3,D5)
      ESPStatusOld3 = ESPStatusNew3   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
      buttonStatusOld3 = buttonStatusNew3
      
    elseif(myString == "/" .. name .. "/switch3/sw-off")then  --Compares Received Instruction On Port
      print("switch 3 off")
      ESPStatusNew3 = 0;    --Change New ESP Status To 0 In Recognition That Data Is Received & Asking To Turn OFF This Particular Device
      myString = "";      --Empty The String So That It Is Ready For Next String Input From Port
      algorithm (ESPStatusNew3,ESPStatusOld3,buttonStatusNew3,buttonStatusOld3,D5)
      ESPStatusOld3 = ESPStatusNew3   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
      buttonStatusOld3 = buttonStatusNew3
     
    end
  
    if(myString == "/" .. name .. "/switch5/sw-on")then    --Compares Received Instruction On Port
      print("switch 5 on")
      ESPStatusNew5 = 1;      --Change New ESP Status To 1 In Recognition That Data Is Received & Asking To Turn ON This Particular Device
      myString = "";          --Empty The String So That It Is Ready For Next String Input From Port
      algorithm (ESPStatusNew5,ESPStatusOld5,buttonStatusNew5,buttonStatusOld5,D7)
      ESPStatusOld5 = ESPStatusNew5   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
      buttonStatusOld5 = buttonStatusNew5
     
    elseif(myString == "/" .. name .. "/switch5/sw-off")then  --Compares Received Instruction On Port
      print("switch 5 off")
      ESPStatusNew5 = 0;    --Change New ESP Status To 0 In Recognition That Data Is Received & Asking To Turn OFF This Particular Device
      myString = "";      --Empty The String So That It Is Ready For Next String Input From Port
      algorithm (ESPStatusNew5,ESPStatusOld5,buttonStatusNew5,buttonStatusOld5,D7)
      ESPStatusOld5 = ESPStatusNew5   --Equates ESP Old & New Status So Now It's Ready To Detect A Change Again
      buttonStatusOld5 = buttonStatusNew5
   
    end
   end
    end) --end of mqtt function

pl = ""
----------
--tmr.alarm(1, 4000, 1, function()
mqtt:connect(link, 1234, 0, function(client) 
print("connection done") 

temp = 1
--tmr.stop(1)


mac=wifi.sta.getmac()
file.close()
name , pass = wifi.ap.getconfig()
print(name)
print(string.len(name))
temp = 1
if temp == 1 then
dofile("fun.lua")
end


--mqtt:subscribe({["/"..name.."/switch2"]=1,["/"..name.."/switch3"]=1,["/"..name.."/switch5"]=1}, function(client) end)
mqtt:subscribe("/"..name.."/switch2",1, function(client)
--mqtt:subscribe("/"..name.."/switch1",1, function(client)
mqtt:subscribe("/"..name.."/switch5",1, function(client)
mqtt:subscribe("/"..name.."updatestatus",1, function(client)
mqtt:subscribe("/"..name.."/switch3",1, function(client)
  end)
  end)
  end)
 -- end)
  end)









end,function(client, reason) print("failed reason: "..reason) end)

--  print("clientected")
  -- subscribe topic with qos = 0
  --name , pass = wifi.ap.getconfig()
  --print(name)
  --print(string.len(name))
  --mqtt:subscribe("/"..name.."/switch1",2, function(client) 
 -- mqtt:subscribe("/"..name.."/switch2",2, function(client)
 -- mqtt:subscribe("/"..name.."/switch3",2, function(client)
 -- mqtt:subscribe("/"..name.."/switch4",2, function(client)
 -- mqtt:subscribe("/"..name.."/switch5",2, function(client)
 -- mqtt:subscribe("/"..name.."/switch6",2, function(client)
 ---- mqtt:subscribe("/"..name.."/updatestatus",2, function(client)
 -- end)
 -- end)
 -- end)
 -- end)
 -- end)
 -- end) 
 -- end)

--end)

