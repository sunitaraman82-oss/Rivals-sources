-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("Players")
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.Tightrope)
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5._new() -- name: _new
	-- upvalues: (copy) v_u_5
	local v6 = v_u_5
	local v7 = setmetatable({}, v6)
	v7.Tightropes = {}
	v7:_Init()
	return v7
end
function v_u_5.GetActiveTightrope(p8) -- name: GetActiveTightrope
	for _, v9 in pairs(p8.Tightropes) do
		if v9.Active then
			return v9
		end
	end
end
function v_u_5.GetTightrope(p10, p11) -- name: GetTightrope
	for v12, v13 in pairs(p10.Tightropes) do
		if v13.Part == p11 then
			return v13, v12
		end
	end
end
function v_u_5.JumpOff(p14) -- name: JumpOff
	for _, v15 in pairs(p14.Tightropes) do
		v15:JumpOff()
	end
end
function v_u_5._ObjectAdded(p16, p17) -- name: _ObjectAdded
	-- upvalues: (copy) v_u_4
	local v18 = v_u_4.new(p16, p17)
	local v19 = p16.Tightropes
	table.insert(v19, v18)
end
function v_u_5._ObjectRemoved(p20, p21) -- name: _ObjectRemoved
	local v22, v23 = p20:GetTightrope(p21)
	if v22 then
		v22:Destroy()
		table.remove(p20.Tightropes, v23)
	end
end
function v_u_5._HookLocalFighter(p_u_24) -- name: _HookLocalFighter
	-- upvalues: (copy) v_u_3
	local v25 = v_u_3:WaitForLocalFighter()
	local function v27(p_u_26) -- name: entity_added
		-- upvalues: (copy) p_u_24
		p_u_26.AirborneChanged:Connect(function()
			-- upvalues: (copy) p_u_26, (ref) p_u_24
			if p_u_26:IsAirborne() then
				p_u_24:JumpOff()
			end
		end)
		p_u_26:GetDataChangedSignal("IsFrozen"):Connect(function()
			-- upvalues: (copy) p_u_26, (ref) p_u_24
			if p_u_26:Get("IsFrozen") then
				p_u_24:JumpOff()
			end
		end)
	end
	v25.EntityAdded:Connect(v27)
	if v25.Entity then
		v27(v25.Entity)
	end
end
function v_u_5._Init(p_u_28) -- name: _Init
	-- upvalues: (copy) v_u_1
	v_u_1:GetInstanceAddedSignal("Tightrope"):Connect(function(p29)
		-- upvalues: (copy) p_u_28
		p_u_28:_ObjectAdded(p29)
	end)
	v_u_1:GetInstanceRemovedSignal("Tightrope"):Connect(function(p30)
		-- upvalues: (copy) p_u_28
		p_u_28:_ObjectRemoved(p30)
	end)
	for _, v31 in pairs(v_u_1:GetTagged("Tightrope")) do
		task.defer(p_u_28._ObjectAdded, p_u_28, v31)
	end
	task.defer(p_u_28._HookLocalFighter, p_u_28)
end
return v_u_5._new()