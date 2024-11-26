task.spawn(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()
end)

local httpService = game:GetService("HttpService")
local plev = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("placeTower")
local sel = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("RemoveTower")
local up = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("UpgradeTower")
local af = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("ChangeTowerTargetMode")
local ws = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("waveSkip")
local rp = game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("ReplayCore")
local rd = game:GetService("ReplicatedStorage"):WaitForChild("GAME_START"):WaitForChild("readyButton")
local times = game:GetService("ReplicatedStorage").Game.Clock

local F = {}

function Save(data)
	local fullPath = "TDM.json"
	local success, encoded = pcall(httpService.JSONEncode, httpService, data)
	if not success then
		return false
	end
	print(encoded)
	writefile(fullPath, encoded)
	return true
end

function Load()
	local file = "TDM.json"
	if not isfile(file) then return false end

	local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
	if not success then return false end
	return decoded
end

local function AddF(event,args)
	if event == plev then
		local tower = tostring(args[1])
		local placeCframe = tostring(args[2])
		local idkblon = tostring(args[3])
		F[tostring(times.Value)] = {event.Name,tower,placeCframe,idkblon}
	elseif (event == sel or event == up or event == af)  then
		local towerID = tostring(args[1])
		F[tostring(times.Value)] = {event.Name,towerID}
	elseif event == ws then
		local blon = tostring(args[1])
		F[tostring(times.Value)] = {event.Name,blon}
	end
end

local hook; hook = hookmetamethod(game,"__namecall",function(self,...)
	local method = getnamecallmethod():lower()
	if tostring(method) == "fireserver" then
		if self == plev then --放置塔
			local args = {...}
			AddF(plev,args)
		elseif self == sel then --售卖塔
			local args = {...}
			AddF(sel,args)
		elseif self == up then --升级塔
			local args = {...}
			AddF(up,args)
		elseif self == af then --更改攻击方式
			local args = {...}
			AddF(af,args)
		elseif self == ws then --跳过波
			local args = {...}
			AddF(ws,args)
		elseif self == rp then
			table.sort(F, function(a, b)
				return tonumber(a) < tonumber(b)
			end)
			Save(F)
		elseif self == rd then
			print("玩家准备")
		end
	end
	return hook(self,...)
end)
loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
