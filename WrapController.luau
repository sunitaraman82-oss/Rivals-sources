-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("CollectionService")
local v2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("RunService")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v2.Modules.CONSTANTS)
local v_u_6 = require(v2.Modules.CosmeticLibrary)
local v_u_7 = v_u_5.IS_CLIENT and v_u_5.IS_RUNNING
if v_u_7 then
	v_u_7 = v_u_4.LocalPlayer.PlayerScripts.Assets:WaitForChild("WrapTextures")
end
local v_u_8 = v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("WrapGroupObjects")
local v_u_9 = {}
v_u_9.__index = v_u_9
function v_u_9._new() -- name: _new
	-- upvalues: (copy) v_u_9
	local v10 = v_u_9
	local v11 = setmetatable({}, v10)
	v11._wrap_group_callbacks = {}
	v11._wrap_group_classes = {}
	v11._wrap_group_objects = {}
	v11._wrap_group_objects_count = {}
	v11._preloaded_wrap_group_objects = {}
	v11._preload_screen_gui = Instance.new("ScreenGui")
	v11:_Init()
	return v11
end
function v_u_9.RecordOriginalWrapProperties(_, p12) -- name: RecordOriginalWrapProperties
	local v13 = {}
	local v14
	if typeof(p12) == "table" then
		v14 = p12
	else
		v14 = p12:GetDescendants()
		table.insert(v14, p12)
	end
	for _, v15 in pairs(v14) do
		if v15:HasTag("Wrappable") then
			local v16 = nil
			local v17
			if v15:IsA("BasePart") then
				v17 = {
					["Material"] = v15.Material,
					["MaterialVariant"] = v15.MaterialVariant,
					["Color"] = v15.Color,
					["Transparency"] = v15.Transparency,
					["Reflectance"] = v15.Reflectance
				}
				if v15:IsA("MeshPart") then
					v17.TextureID = v15.TextureID
				end
			elseif v15:IsA("Decal") or v15:IsA("Texture") then
				v17 = {
					["Color3"] = v15.Color3,
					["Transparency"] = v15.Transparency
				}
			elseif v15:IsA("Beam") or (v15:IsA("Trail") or v15:IsA("ParticleEmitter")) then
				v17 = {
					["Color"] = v15.Color,
					["Transparency"] = v15.Transparency,
					["LightEmission"] = v15.LightEmission
				}
			elseif v15:IsA("Frame") then
				v17 = {
					["BackgroundColor3"] = v15.BackgroundColor3,
					["BackgroundTransparency"] = v15.BackgroundTransparency
				}
			elseif v15:IsA("ImageLabel") then
				v17 = {
					["ImageColor3"] = v15.ImageColor3,
					["ImageTransparency"] = v15.ImageTransparency
				}
			elseif v15:IsA("Light") then
				v17 = {
					["Color"] = v15.Color,
					["Brightness"] = v15.Brightness
				}
			else
				v17 = (v15:IsA("RopeConstraint") or v15:IsA("SpringConstraint")) and {
					["Color"] = v15.Color
				} or v16
			end
			if v17 then
				v13[v15] = {
					["WrapGroup"] = v15:GetAttribute("WrapGroup"),
					["IgnoreTransparency"] = v15:GetAttribute("IgnoreTransparency"),
					["IgnoreMaterial"] = v15:GetAttribute("IgnoreMaterial"),
					["IgnoreObject"] = v15:GetAttribute("IgnoreObject"),
					["OriginalProperties"] = v17,
					["OriginalChildren"] = {},
					["Cleanup"] = {}
				}
				for _, v18 in pairs(v15:GetChildren()) do
					if v18:IsA("SurfaceAppearance") then
						local v19 = v13[v15].OriginalChildren
						table.insert(v19, v18)
					end
				end
				local v20 = v13[v15].WrapGroup
				if v20 then
					local v21 = v13[v15].WrapGroup
					v20 = typeof(v21) == "number"
				end
				assert(v20, v15:GetFullName())
			end
		end
	end
	return v13
end
function v_u_9.ResetWrap(_, p22) -- name: ResetWrap
	if p22 then
		for v_u_23, v24 in pairs(p22) do
			for v25, v26 in pairs(v24.OriginalProperties) do
				v_u_23[v25] = v26
			end
			for _, v_u_27 in pairs(v24.OriginalChildren) do
				pcall(function()
					-- upvalues: (copy) v_u_27, (copy) v_u_23
					v_u_27.Parent = v_u_23
				end)
			end
			for _, v28 in pairs(v24.Cleanup) do
				v28:Destroy()
			end
			v24.Cleanup = {}
		end
	end
end
function v_u_9.ApplyWrap(p29, p30, p31, p32, p33) -- name: ApplyWrap
	-- upvalues: (copy) v_u_6, (copy) v_u_7
	p29:ResetWrap(p30)
	if p31 and p31.Name ~= "RANDOM_COSMETIC" then
		local v34 = v_u_6.Cosmetics[p31.Name]
		local v35 = p31.Inverted
		for v36, v37 in pairs(p30) do
			if not (p33 and p33[v36]) then
				local v38
				if v35 then
					v38 = v37.WrapGroup == 1 and 2 or (v37.WrapGroup == 2 and 1 or v37.WrapGroup)
				else
					v38 = v37.WrapGroup
				end
				local v39 = v34.WrapGroups[v38] or {}
				local v40 = p32 or v37.IgnoreTransparency
				local v41 = v37.IgnoreMaterial
				local v42 = v37.IgnoreObject
				local v43 = {}
				if v36:IsA("BasePart") then
					v36.Color = v39.Color or v36.Color
					v36.Transparency = not v40 and v39.Transparency or v36.Transparency
					v36.Reflectance = v39.Reflectance or v36.Reflectance
					v36.Material = (not v41 and (not v40 or v39.Material ~= Enum.Material.ForceField) and true or false) and v39.Material or v36.Material
					v36.MaterialVariant = not v41 and v39.MaterialVariant or v36.MaterialVariant
					if v36:IsA("MeshPart") then
						v36.TextureID = ""
					end
					if not v41 then
						for _, v44 in pairs(v39.Textures and (v_u_7[v39.Textures]:GetChildren() or {}) or {}) do
							local v45 = v44:Clone()
							v45.LocalTransparencyModifier = v36.LocalTransparencyModifier
							v45.Parent = v36
							local v46 = v37.Cleanup
							table.insert(v46, v45)
							table.insert(v43, v45)
						end
					end
				elseif v36:IsA("Decal") or v36:IsA("Texture") then
					v36.Color3 = v39.Color3 or v36.Color3
					v36.Transparency = not v40 and v39.Transparency or v36.Transparency
				elseif v36:IsA("Beam") or (v36:IsA("Trail") or v36:IsA("ParticleEmitter")) then
					v36.Color = v39.Color and ColorSequence.new(v39.Color) or v36.Color
				elseif v36:IsA("Frame") then
					v36.BackgroundColor3 = v39.Color or v36.BackgroundColor3
					v36.BackgroundTransparency = not v40 and v39.Transparency or v36.BackgroundTransparency
				elseif v36:IsA("ImageLabel") then
					v36.ImageColor3 = v39.Color or v36.ImageColor3
					v36.ImageTransparency = not v40 and v39.Transparency or v36.ImageTransparency
				elseif v36:IsA("Light") then
					v36.Color = v39.Color or v36.Color
					v36.Brightness = v36.Brightness + (0 - v36.Brightness) * (v40 and 0 or (v39.Transparency or 0))
				elseif v36:IsA("RopeConstraint") or v36:IsA("SpringConstraint") then
					v36.Color = v39.Color and BrickColor.new(v39.Color) or v36.Color
				end
				for _, v_u_47 in pairs(v37.OriginalChildren) do
					pcall(function()
						-- upvalues: (copy) v_u_47
						v_u_47.Parent = nil
					end)
				end
				if not v42 then
					local v48 = p29:_GetWrapGroupObject(v39)
					if v48 then
						local v49 = v48.new(v39.ObjectName, v36, v43)
						local v50 = p29._wrap_group_objects
						table.insert(v50, v49)
						local v51 = v37.Cleanup
						table.insert(v51, v49)
						p29:_IncrementWrapGroupObjectsCount(v49.Name, 1, v49)
					end
				end
			end
		end
	end
end
function v_u_9.Update(p52, p53) -- name: Update
	-- upvalues: (copy) v_u_5
	for v54 = #p52._wrap_group_objects, 1, -1 do
		local v55 = p52._wrap_group_objects[v54]
		if v55.IsDestroyed then
			table.remove(p52._wrap_group_objects, v54)
			p52:_IncrementWrapGroupObjectsCount(v55.Name, -1, v55)
		elseif v55.Update and v55:IsActive() then
			if v_u_5.IS_STUDIO then
				v55:Update(p53)
			else
				pcall(v55.Update, v55, p53)
			end
		end
	end
end
function v_u_9._IncrementWrapGroupObjectsCount(p56, p57, p58, p59) -- name: _IncrementWrapGroupObjectsCount
	local v60 = (p56._wrap_group_objects_count[p57] or 0) + p58
	local v61 = p56._wrap_group_objects_count
	local v62
	if v60 <= 0 then
		v62 = nil
	else
		v62 = v60
	end
	v61[p57] = v62
	if v60 == 1 then
		local v63 = p59.GetPreloadedImageIDs
		if v63 then
			v63 = p59:GetPreloadedImageIDs()
		end
		if v63 and #v63 ~= 0 then
			p56._preloaded_wrap_group_objects[p57] = p56._preloaded_wrap_group_objects[p57] or {}
			p56._preloaded_wrap_group_objects[p57].Textures = p56._preloaded_wrap_group_objects[p57].Textures or {}
			for v64, v65 in pairs(v63) do
				local v66 = Instance.new("ImageLabel")
				v66.BackgroundTransparency = 1
				v66.Active = false
				v66.Size = UDim2.new(0, 1, 0, 1)
				v66.ImageTransparency = 0.99
				v66.Image = v65
				v66.Name = p57 .. " - " .. v64
				v66.Parent = p56._preload_screen_gui
				local v67 = p56._preloaded_wrap_group_objects[p57].Textures
				table.insert(v67, v66)
			end
		end
	else
		if not v60 then
			for _, v68 in pairs(p56._preloaded_wrap_group_objects[p57] and (p56._preloaded_wrap_group_objects[p57].Textures or {}) or {}) do
				task.defer(v68.Destroy, v68)
			end
			p56._preloaded_wrap_group_objects[p57] = nil
		end
		return
	end
end
function v_u_9._GetWrapGroupObject(p69, p70) -- name: _GetWrapGroupObject
	-- upvalues: (copy) v_u_8
	if p70.ObjectName then
		if not p69._wrap_group_classes[p70.ObjectName] then
			p69._wrap_group_classes[p70.ObjectName] = require(v_u_8:WaitForChild(p70.ObjectName))
		end
		return p69._wrap_group_classes[p70.ObjectName]
	end
end
function v_u_9._WrapThis(p71, p72) -- name: _WrapThis
	p71:ApplyWrap(p71:RecordOriginalWrapProperties(p72), {
		["Name"] = p72:GetAttribute("WrapName")
	})
end
function v_u_9._Setup(p73) -- name: _Setup
	-- upvalues: (copy) v_u_4
	p73._preload_screen_gui.Name = "PreloadedWrapTextures"
	p73._preload_screen_gui.ResetOnSpawn = false
	p73._preload_screen_gui.Parent = v_u_4.LocalPlayer.PlayerGui
end
function v_u_9._Init(p_u_74) -- name: _Init
	-- upvalues: (copy) v_u_3, (copy) v_u_1
	v_u_3:BindToRenderStep("WrapController", Enum.RenderPriority.Camera.Value + 1, function(p75)
		-- upvalues: (copy) p_u_74
		p_u_74:Update(p75)
	end)
	v_u_1:GetInstanceAddedSignal("WrapThis"):Connect(function(p76)
		-- upvalues: (copy) p_u_74
		p_u_74:_WrapThis(p76)
	end)
	for _, v77 in pairs(v_u_1:GetTagged("WrapThis")) do
		task.defer(p_u_74._WrapThis, p_u_74, v77)
	end
	p_u_74:_Setup()
end
return v_u_9._new()