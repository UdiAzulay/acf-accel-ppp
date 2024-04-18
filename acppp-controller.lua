local mymodule = {}
mymodule.default_action = "status"

function mymodule.status(self)
	return self.model.getstatus()
end

function mymodule.startstop(self)
	return self.handle_form(self, self.model.get_startstop, self.model.startstop_service, self.clientdata)
end

function mymodule.statusinfo(self)
	return self.model.getstatusinfo()
end

function mymodule.peers(self)
	return self.model.list_peers()
end

function mymodule.disconnect(self)
	self.model.disconnect(self.clientdata.sid)
	return self.redirect(self, "peers")
end

function mymodule.editconf(self)
	return self.handle_form(self, self.model.read_config, self.model.update_config, self.clientdata, "Save", "Edit Config", "Configuration Set")
end

function mymodule.editchap(self)
	return self.handle_form(self, self.model.read_chap, self.model.update_chap, self.clientdata, "Save", "Edit Users", "Configuration Set")
end

return mymodule
