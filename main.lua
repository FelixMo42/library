::start::

system = setmetatable( {} , { __index = function(self,key) self[key] = {}; return self[key] end } )

system.update.directory = "Users/felixmo/Desktop/library/"
system.update.print = function(self,t)
	love.graphics.print(t , 10 , love.graphics.getHeight() - 10 - love.graphics.getFont():getHeight())
	love.graphics.present()
end
system.update.update = function(self,path)
	local od = os.macDate(system.filesystem:execute( "stat -f %Sm "..(system.update.directory..path):gsub(" ","\\ ") ))
	local ld = os.macDate(system.filesystem:execute( "stat -f %Sm "..(system.filesystem.directory..path):gsub(" ","\\ ") ))

	if ld < od then
		system.update:print("updating "..path)
		for i = #path , 1 , -1 do
			if path:sub(i,i) == "/" then
				os.execute("mkdir "..system.filesystem.directory:gsub(" ","\\ ")..path:sub(1,i-1):gsub(" ","\\ ") )
				break
			end
		end
		system.filesystem:write( path , system.filesystem:read( system.update.directory..path ) )
	end

	return ld < od
end

system.filesystem.directory = love.filesystem.getSource().."/"
system.filesystem.isApp = system.filesystem.directory:find(".love")
system.filesystem.path = function(self,path)
	return path:find("Users") and path or self.directory..path
end
system.filesystem.execute = function(self,cmd)
	local file = io.popen(cmd)
	local r = file:read("*a")
	file:close()
	return r
end
system.filesystem.write = function(self,path,content)
	local file = io.open(self:path(path) , "w")
	file:write(content)
	file:close()
end
system.filesystem.read = function(self,path)
	local file = io.open(self:path(path) , "r")
	local r = file:read("*a")
	file:close()
	return r
end
system.filesystem.getDirectory = function(self,file,ext,hidden)
	if type(ext) == "boolean" then hidden , ext = ext , hidden end
	local path , i , t = self:path(file):gsub(" ","\\ ") , 1 , {}
    local pfile = io.popen('ls -a '..path)
    for filename in pfile:lines() do
        if filename:sub(1,1) ~= "." or hidden then
            if not ext or filename:find(ext) then
                t[i] = filename
                i = i + 1
            end
        end
	end
    pfile:close()
    return t
end
system.filesystem.exist = function(self,path)
	local ok, err, code = os.rename( self:path(path) , self:path(path) )
	if not ok and code == 13 then return true, err end
	return ok, err
end
system.filesystem.isDirectory = function(self,path)
	return self:exist( self:path(path.."/") )
end

os.macDate = function(str)
	local month, day, hour, min, sec, year = str:match("(%a+)%s+(%d*) (%d+):(%d+):(%d+) (%d+)")
	month = ({Jan = 1,Feb = 2,Mar = 3,Apr = 4,May = 5,Jun = 6,Jul = 7,Aug = 8,Sep = 9,Oct = 10,Nov = 11,Dec = 12})[month]
	return os.time({day = day, month = month, year = year, hour = hour, min = min, sec = sec}) + os.time() - os.time(os.date("!*t"))
end

if system.filesystem.isApp then return require("system") end

if system.update:update("main.lua") then
	goto start
end

for i , path in pairs(system.filesystem:getDirectory(system.update.directory.."system/")) do
	if not system.filesystem:isDirectory( system.update.directory.."system/"..path ) then
		system.update:update( "system/"..path )
	end
end

return require "system"