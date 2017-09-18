temp2 =0
sv=net.createServer(net.TCP) 
sv:listen(325,function(c)
      c:on("receive", function(ab, pl)
      print("pl")
      hub = string.find(pl,"ASDFG");
      ch = string.find(pl,"ABCDE");
      na = string.find(pl,"QWERT");
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
         tmr.alarm(1, 2000, 0, function()    
             ipap,snap,gwap= wifi.ap.getip()
             mac=wifi.sta.getmac()
             c:send(mac)
              
             tmr.delay(500000)
          end) 
         temp2 = 1
         wifi.sta.disconnect()
         
         wifi.sta.config(UN,PW)   
         wifi.sta.connect()
         ip = wifi.sta.getip()
         print(ip)
       if(ip == nil)then  
      tmr.alarm(0,250, 1, function() 
       ip2 , s , g = wifi.sta.getip()
       print(ip2,s,g)
        if(ip2 ~= nil)then
     
       SOS = 1     
      tmr.stop(0) 
     
  
    
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
       --node.restart()
      end
      end) 
      elseif(ip ~= nil) then
      --print(ip)           
end
        
 elseif((ch ~= 1) and (na ~= 1) and (hub ~= 1))then 
         
         R1 = string.find(pl,"R");
        if(R1 == 1)then
        node.restart()
        elseif(R1 ~= 1)then
        end
  elseif((na == 1) and (ch ~= 1) and (hub ~= 1))then
 
     v1 = string.find(pl,"\n")
     l1 = string.len (pl) 
         pass = string.sub (pl, v1+1 , l1-1)
         name = string.sub (pl, 6 ,v1-1)
        
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
         
         hubip = string.sub (pl, 6 ,end1-1)
         
         print(string.len (hubip))
         hubUN = string.sub (pl, end1 +1 ,end2-1)
        
         print(string.len (hubUN))
         hubPW = string.sub (pl, end2+1 ,end3-1)
         
         print(string.len (hubPW))
         file.open("mqtt-config.lua", "w+")
         file.writeline(hubip)
         file.writeline(hubUN)
         file.writeline(hubPW)
         file.close()
        -- if temp == 1 then
     --   close = mqtt:close()
     ----    print(close)
      --   node.restart()
        -- elseif temp == 0 then
         --node.restart()
        if check1 == 1 then
        check1 = 0
        dofile("m1.lua")
        end
        if tact == 0 then
        dofile("m1.lua")
        end
        if temp == 1 then
        checkclose = m:close()
       if checkclose == true then
        checkclose = nil
        dofile("m1.lua")
       -- end
        end
      end
      
 
end   
end)
end)
