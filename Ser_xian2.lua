local socket = require ("socket.core")
local tcp = socket.tcp()
local host = host or '127.0.0.1'
local port = '8811'
local tcpbind = tcp:bind(host,port)

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

	--获取当前点位置
	if(g == 401) then
		--TOOLDATA("tool1",true,{{0,0,0},{0,{-0,-0,-0}},{1,-0,-0,-0},-0,-0,-0,-0,-0,-0})
		--OBJDATA("wobj1",false,true,""{{-0,-0,-0}.{1,-0,-0}}{{-0,-0,-0}{1,-0,-0,-0}})
		--local databody = GetRobTarget("ROL_L",tool1,wobj1)
		--local fanhui401 = "??????#0401@0024&"..databody.trans.x..databody.trans.y..databody.trans.z..";0000#"
		local sendcli = tcpclient:send('??????#0401@0024&111;0000#')

	--相对位置运动
	elseif(g == 402)then
		--local databody = GetRobTarget("ROL_L",tool1,wobj1)
		--local xx = tonumber(string.sub(s2,23,29))
		--local yy = tonumber(string.sub(s2,31,37))
		--local zz = tonumber(string.sub(s2,39,45))
		--local ss = string.sub(s2,53,55)
		--local speed = "v"..ss

		--ROBTARGET("P20",{databody.trans.x+xx,databody.trans.y+yy,databody.trans.z+zz},{0,0,1,0},{0,0,0,0},{-0,-0,-0,-0,-0,-0,-0},-0)
		--TOOLDATA("tool1",true,{{0,0,0},{0,{-0,-0,-0}},{1,-0,-0,-0},-0,-0,-0,-0,-0,-0})
		--OBJDATA("wobj1",false,true,""{{-0,-0,-0}.{1,-0,-0}}{{-0,-0,-0}{1,-0,-0,-0}})
		--MoveL(0,P20,v500,z10,tool1,wobj1)
		local fanhui402 = "000023#0402@0007&0002,1;0000#"
		local sendcli = tcpclient:send(fanhui402)

	--绝对位置运动
	elseif(g == 403)then
		--local xx = tonumber(string.sub(s3,23,29))
		--local yy = tonumber(string.sub(s3,31,37))
		--local zz = tonumber(string.sub(s3,39,45))
		--local ss = string.sub(s3,53,55)
		--local speed = "v"..ss

		--ROBTARGET("P20",{xx,yy,zz},{0,0,1,0},{0,0,0,0},{-0,-0,-0,-0,-0,-0,-0},-0)
		--TOOLDATA("tool1",true,{{0,0,0},{0,{-0,-0,-0}},{1,-0,-0,-0},-0,-0,-0,-0,-0,-0})
		--WOBJDATA("wobj1",false,true,""{{-0,-0,-0}.{1,-0,-0}}{{-0,-0,-0}{1,-0,-0,-0}})
		--MoveL(0,P20,v500,z10,tool1,wobj1)
		local fanhui403 = "000023#0403@0007&0002,1;0000#"
		local sendcli = tcpclient:send(fanhui403)

	else
		local sendcli = tcpclient:send('wrong message')
	end

	coroutine.resume(thread)
end
