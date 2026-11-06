-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.CONSTANTS)
require(v1.Modules.GameplayUtility)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = require(v2.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_7 = require(v2.LocalPlayer.PlayerScripts.Controllers.EnemyController)
local v_u_8 = Color3.fromRGB(255, 255, 255)
local v_u_9 = Color3.fromRGB(255, 50, 50)
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10._new() -- name: _new
	-- upvalues: (copy) v_u_10
	local v11 = v_u_10
	local v12 = setmetatable({}, v11)
	v12._hurt_effect_enabled = false
	v12._hurt_effect_outline_only = false
	v12:_Init()
	return v12
end
function v_u_10.GetScreenPoints(_, p13, p14) -- name: GetScreenPoints
	-- upvalues: (copy) v_u_7, (copy) v_u_6, (copy) v_u_3
	local v15 = {}
	for _, v16 in pairs({ v_u_7.Objects, v_u_6:GetEntities() }) do
		for _, v17 in pairs(v16) do
			if not (p14 and v17.AimAssistBlacklist) and p13:IsValidTarget(v17) then
				local v18, v19 = v17:GetScreenPoint()
				if v19 and v18.Z < v_u_3.RENDER_DISTANCE then
					v15[v17] = v18
				end
			end
		end
	end
	return v15
end
function v_u_10._UpdateSetting(p20) -- name: _UpdateSetting
	-- upvalues: (copy) v_u_5
	local v21 = v_u_5:GetSetting("Damage Flashing")
	p20._hurt_effect_enabled = v21 ~= "Disabled"
	p20._hurt_effect_outline_only = v21 == "Outline"
end
function v_u_10._SetupHurtEffect(p_u_22, p_u_23) -- name: _SetupHurtEffect
	-- upvalues: (copy) v_u_4, (copy) v_u_8, (copy) v_u_9
	local v24
	if typeof(p_u_23) == "Instance" then
		v24 = p_u_23:IsA("Model")
	else
		v24 = false
	end
	assert(v24, "Argument 1 invalid, expected a Model")
	p_u_23:SetAttribute("PlayHurtEffect", 0)
	local v_u_25 = nil
	p_u_23:GetAttributeChangedSignal("PlayHurtEffect"):Connect(function()
		-- upvalues: (copy) p_u_22, (ref) v_u_25, (copy) p_u_23, (ref) v_u_4, (ref) v_u_8, (ref) v_u_9
		if p_u_22._hurt_effect_enabled then
			if v_u_25 then
				v_u_25:Destroy()
				v_u_25 = nil
			end
			local v_u_26 = Instance.new("Highlight")
			v_u_26.Name = "HurtEffect"
			v_u_26.FillColor = Color3.fromRGB(255, 255, 255)
			v_u_26.OutlineColor = Color3.fromRGB(255, 100, 100)
			v_u_26.DepthMode = Enum.HighlightDepthMode.Occluded
			v_u_26.Adornee = p_u_23
			v_u_26.Parent = p_u_23
			v_u_25 = v_u_26
			v_u_4:RenderstepForLoop(0, 100, 1, function(p27)
				-- upvalues: (copy) v_u_26, (ref) v_u_25, (ref) v_u_8, (ref) v_u_9, (ref) p_u_22
				if v_u_26 ~= v_u_25 then
					return true
				end
				local v28 = 1 - (1 - p27 / 100) ^ 5
				local v29 = v_u_8
				local v30 = v_u_9
				local v31 = p27 / 5
				local v32 = v29:Lerp(v30, (math.min(1, v31)))
				v_u_26.FillColor = v32
				v_u_26.FillTransparency = p_u_22._hurt_effect_outline_only and 1 or v28
				v_u_26.OutlineTransparency = v28
				local v33 = v_u_26
				if not p_u_22._hurt_effect_outline_only then
					v32 = v_u_9
				end
				v33.OutlineColor = v32
			end)
			v_u_26:Destroy()
		end
	end)
end
function v_u_10._SetupHurtEffects(p34) -- name: _SetupHurtEffects
	local v35 = Instance.new("Model")
	v35.Name = "HurtEffect"
	v35.Parent = workspace
	p34:_SetupHurtEffect(v35)
	p34:_SetupHurtEffect(workspace:WaitForChild("ViewModels"):WaitForChild("FirstPerson"))
end
function v_u_10._Init(p_u_36) -- name: _Init
	-- upvalues: (copy) v_u_5
	v_u_5:GetSettingChangedSignal("Damage Flashing"):Connect(function()
		-- upvalues: (copy) p_u_36
		p_u_36:_UpdateSetting()
	end)
	task.spawn(p_u_36._SetupHurtEffects, p_u_36)
	p_u_36:_UpdateSetting()
end
return v_u_10._new()