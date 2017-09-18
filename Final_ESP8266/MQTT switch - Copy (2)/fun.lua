mac=wifi.sta.getmac()

name , pass = wifi.ap.getconfig()
print(name)
print(string.len(name))
print("status called")
-- ("gpio.write(" .. pinout .. ", gpio.HIGH)"
file.open("switch2.lua", "r")
stat1 = file.readline()
--print(stat1)
 if string.find(stat1,"HIGH") ~= nil then
 m:publish("/"..mac.."/".. name .."/switch2/status","sw-off", 1, 1, function(client)
            --print("message published")
        end)--publisher end
 end
  if string.find(stat1,"LOW") ~= nil then
 m:publish("/"..mac.."/".. name .."/switch2/status","sw-on", 1, 1, function(client)
           -- print("message published")
        end)--publisher end
 end
file.close()
file.open("switch3.lua", "r")
stat1 = file.readline()
 if string.find(stat1,"HIGH") ~= nil then
 m:publish("/"..mac.."/".. name .."/switch3/status","sw-off", 1, 1, function(client)
           -- print("message published")
        end)--publisher end
 end
  if string.find(stat1,"LOW") ~= nil then
 m:publish("/"..mac.."/".. name .."/switch3/status","sw-on", 1, 1, function(client)
   --         print("message published")
        end)--publisher end
 end
file.close()
file.open("switch5.lua", "r")
stat1 = file.readline()
 if string.find(stat1,"HIGH") ~= nil then
 m:publish("/"..mac.."/".. name .."/switch5/status","sw-off", 1, 1, function(client)
   --         print("message published")
        end)--publisher end
 end
  if string.find(stat1,"LOW") ~= nil then
 m:publish("/"..mac.."/".. name .."/switch5/status","sw-on", 1, 1, function(client)
   --         print("message published")
        end)--publisher end
 end
