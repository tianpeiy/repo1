local socket = require ("socket.core")
local tcp = socket.tcp()
local host = '192.168.89.125'
local port = '8899'
local tcpbind = tcp:bind(host,port)

local speed = {v_tcp = 10, v_ori = 500, v_leax = 5000, v_reax = 1000 }

function  child_thread_func()

	while(1) do

	local e = tcp:listen()
	if (e and e == 1) then
		print('listen ok')

	else
		print('listen error')
	end
	print('waiting connect cli')

	coroutine.yield()
	end
end

thread = coroutine.create(child_thread_func)
coroutine.resume(thread)

while (1)
do

	local tcpclient = tcp:accept()
	if(tcpclient ~= nil)then
		print('access success')

	else
		print('accept err')
	end

	local revbuff = tcpclient:receive(61)
	print('revbuff:'..revbuff)

	local h = string.sub(revbuff,9,11)
	g = tonumber(h)

	--位置输出
	--local sendcli = tcpc	
	if(g == 401) then
		--TOOLDATA("tool1",true,{{0,0,0},{0,{-0,-0,-0}},{1,-0,-0,-0},-0,-0,-0,-0,-0,-0})
		--OBJDATA("wobj1",false,true,""{{-0,-0,-0}.{1,-0,-0}}{{-0,-0,-0}{1,-0,-0,-0}})
		local P10 = GetRobTarget("ROB_1",tool0,wobj0)
		local x1 = tostring(P10.trans.x)
		local y1 = tostring(P10.trans.y)
		local z1 = tostring(P10.trans.z)
		local fanhui401 = "??????#0401@0024&"..x1..","..y1..","..z1..";0000#"
		tcpclient:send(fanhui401)

	--相对运动
	elseif(g == 402)then
		local P20 = GetRobTarget("ROB_1",tool0,wobj0)
		local xx = tonumber(string.sub(revbuff,23,29))
		local yy = tonumber(string.sub(revbuff,31,37))
		local zz = tonumber(string.sub(revbuff,39,45))
		
		local ss = tonumber(string.sub(revbuff,52,55))
		--local sss = tostring(ss)
		--local speed = "v"..sss
		speed.v_tcp = ss
		MoveL(Offs(P20,xx,yy,zz),speed,z10,tool0,wobj0,load0)
		
		local fanhui402 = "000023#0402@0007&0002,1;0000#"
		local sendcli = tcpclient:send(fanhui402)

	--绝对运动
	elseif(g == 403)then
		local P30 = GetRobTarget("ROB_1",tool0,wobj0)
		local xxx = tonumber(string.sub(revbuff,23,29))
		local yyy = tonumber(string.sub(revbuff,31,37))
		local zzz = tonumber(string.sub(revbuff,39,45))
		
		local ss = tonumber(string.sub(revbuff,52,55))
		--local sss = tostring(ss)
		--local speed = "v"..sss
		speed.v_tcp = ss
		
		MoveL(Offs(P30,xxx-P30.trans.x,yyy-P30.trans.y,zzz-P30.trans.z),speed,z10,tool0,wobj0,load0)
		local fanhui403 = "000023#0403@0007&0002,1;0000#"
		local sendcli = tcpclient:send(fanhui403)
	else
		local sendcli = tcpclient:send('wrong message')
	end

	coroutine.resume(thread)
end



