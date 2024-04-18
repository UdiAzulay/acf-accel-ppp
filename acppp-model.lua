local mymodule = {}
modelfunctions = require("modelfunctions")

local processname = "accel-pppd"
local configfile = "/etc/accel-ppp.conf"
local chapfile = "/etc/ppp/chap-secrets"
local sessionscolumns = "sid,ifname,username,calling-sid,ip,type,comp,state,uptime,rx-bytes,tx-bytes"
local ipupfile = "/etc/ppp/ip-up"
local ipdownfile = "/etc/ppp/ip-down"

function mymodule.extractlinrs(data)
	local lines = {}
	local prefix = ""
	for s in data:gmatch("[^\r\n]+") do
        _, _, key, value = string.find(s, "%s*([^:]-):%s?(.*)$")
	    if (value and value ~= "") then table.insert(lines, cfe({ label = prefix .. " " .. key, value = value }))
		else prefix = key end 
	end
	return lines
end

function mymodule.getstatus()
	return modelfunctions.getstatus(processname, "accel-ppp", "Accel-PPP Status")
end

function mymodule.get_startstop(self, clientdata)
    return modelfunctions.get_startstop(processname)
end

function mymodule.startstop_service(self, startstop, action)
    return modelfunctions.startstop_service(startstop, action)
end

function mymodule.getstatusinfo()
	local info = { type = "group", label = "Service info" }
	info.value = mymodule.extractlinrs(modelfunctions.run_executable({ "accel-cmd", "show", "stat" }, false))
	return info
end 

function mymodule.list_peers()
	local ret = modelfunctions.run_executable({ "accel-cmd", "show", "sessions", sessionscolumns }, true)
	local lines = {}
	for s in ret:gmatch("[^\r\n]+") do
		if nil == (string.match(s, "^-") or string.match(s,"^$")) then 
			local line = {}
			for c in string.gmatch(s, "[^|]+") do line[#line + 1] = c end
			lines[#lines + 1] = line 
		end
	end
	return cfe({ type="list", value=lines, label="Peers" })
end

function mymodule.disconnect(sid)
	return modelfunctions.run_executable({ "accel-cmd", "terminate", "sid",  sid}, true)
end

function mymodule.read_config()
	return modelfunctions.getfiledetails(configfile)
end

function mymodule.update_config(self, filedetails)
	local retval = modelfunctions.setfiledetails(self, filedetails, {configfile})
	posix.chmod(configfile, "rw-------")
	return retval
end

function mymodule.read_events()
	local value = {}
	value.ipup = modelfunctions.getfiledetails(ipupfile)
	value.ipdown = modelfunctions.getfiledetails(ipdownfile)
	return { type = "group", label = "files", value = value }
end

function mymodule.update_events(self, filedetails)
	local value = {}
	value.ipup = modelfunctions.setfiledetails(self, filedetails.value.ipup, {ipupfile})
	posix.chmod(ipupfile, "rw-------")
	value.ipdown = modelfunctions.setfiledetails(self, filedetails.value.ipdown, {ipdownfile})
	posix.chmod(ipdownfile, "rw-------")
	return { type = "group", label = "files", value = value }
end

function mymodule.read_chap()
	return modelfunctions.getfiledetails(chapfile)
end

function mymodule.update_chap(self, filedetails)
	local retval = modelfunctions.setfiledetails(self, filedetails, {chapfile})
	posix.chmod(chapfile, "rw-------")
	return retval
end

return mymodule
