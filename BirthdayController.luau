-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("CollectionService")
local v_u_2 = game:GetService("ReplicatedStorage")
local v3 = game:GetService("Players")
local v_u_4 = require(v_u_2.Modules.BirthdayLibrary)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6._new() -- name: _new
	-- upvalues: (copy) v_u_6
	local v7 = v_u_6
	local v8 = setmetatable({}, v7)
	v8:_Init()
	return v8
end
function v_u_6._ObjectAdded(_, p9) -- name: _ObjectAdded
	-- upvalues: (copy) v_u_5, (copy) v_u_4, (copy) v_u_2
	p9.Triggered:Connect(function()
		-- upvalues: (ref) v_u_5, (ref) v_u_4, (ref) v_u_2
		if not v_u_5:Get("BirthdaysWitnessed")[v_u_4.CURRENT_BIRTHDAY_STRING] then
			v_u_2.Remotes.Data.TakeCake:FireServer()
		end
	end)
end
function v_u_6._Init(p_u_10) -- name: _Init
	-- upvalues: (copy) v_u_1
	v_u_1:GetInstanceAddedSignal("BirthdayCakePrompt"):Connect(function(p11)
		-- upvalues: (copy) p_u_10
		p_u_10:_ObjectAdded(p11)
	end)
	for _, v12 in pairs(v_u_1:GetTagged("BirthdayCakePrompt")) do
		task.defer(p_u_10._ObjectAdded, p_u_10, v12)
	end
end
return v_u_6._new()