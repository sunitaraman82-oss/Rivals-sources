-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("CollectionService")
local v_u_2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v_u_2.Modules.CONSTANTS)
local v_u_5 = require(v_u_2.Modules.ReplicatedClass)
local v_u_6 = require(v_u_2.Modules.Signal)
local v_u_7 = { "FreecamEnabled" }
local v_u_8 = setmetatable({}, v_u_5)
v_u_8.__index = v_u_8
function v_u_8._new() -- name: _new
	-- upvalues: (copy) v_u_5, (copy) v_u_8, (copy) v_u_6
	local v9 = v_u_5.new()
	local v10 = v_u_8
	local v11 = setmetatable(v9, v10)
	v11.BannedPlayersChanged = v_u_6.new()
	v11.BannedPlayers = {}
	v11:_Init()
	return v11
end
function v_u_8.ServerKick(_, p12) -- name: ServerKick
	-- upvalues: (copy) v_u_2
	v_u_2.Remotes.PrivateServer.KickPlayer:FireServer(p12)
end
function v_u_8.ServerBan(_, p13) -- name: ServerBan
	-- upvalues: (copy) v_u_2
	v_u_2.Remotes.PrivateServer.BanPlayer:FireServer(p13)
end
function v_u_8._ObjectAdded(_, p14) -- name: _ObjectAdded
	-- upvalues: (copy) v_u_4
	if not v_u_4.IS_PRIVATE_HUB_SERVER then
		task.defer(p14.Destroy, p14)
	end
end
function v_u_8._SetBannedPlayers(p15, p16) -- name: _SetBannedPlayers
	p15.BannedPlayers = p16
	p15.BannedPlayersChanged:Fire()
end
function v_u_8._FetchBannedPlayers(p17) -- name: _FetchBannedPlayers
	-- upvalues: (copy) v_u_4, (copy) v_u_3, (copy) v_u_2
	if v_u_4.IS_PRIVATE_SERVER_OWNER(v_u_3.LocalPlayer.UserId) then
		local v18, v19 = pcall(v_u_2.Remotes.PrivateServer.FetchBannedPlayers.InvokeServer, v_u_2.Remotes.PrivateServer.FetchBannedPlayers)
		if v18 then
			p17:_SetBannedPlayers(v19)
		end
	else
		return
	end
end
function v_u_8._Setup(p_u_20) -- name: _Setup
	-- upvalues: (copy) v_u_7
	for _, v_u_21 in pairs(v_u_7) do
		workspace:GetAttributeChangedSignal(v_u_21):Connect(function() -- name: update
			-- upvalues: (copy) p_u_20, (copy) v_u_21
			p_u_20:SetReplicate(v_u_21, workspace:GetAttribute(v_u_21))
		end)
		p_u_20:SetReplicate(v_u_21, workspace:GetAttribute(v_u_21))
	end
end
function v_u_8._Init(p_u_22) -- name: _Init
	-- upvalues: (copy) v_u_2, (copy) v_u_1
	v_u_2.Remotes.PrivateServer.ReplicateBannedPlayers.OnClientEvent:Connect(function(p23)
		-- upvalues: (copy) p_u_22
		p_u_22:_SetBannedPlayers(p23)
	end)
	v_u_1:GetInstanceAddedSignal("LobbyPrivateServerOnly"):Connect(function(p24)
		-- upvalues: (copy) p_u_22
		p_u_22:_ObjectAdded(p24)
	end)
	for _, v25 in pairs(v_u_1:GetTagged("LobbyPrivateServerOnly")) do
		task.defer(p_u_22._ObjectAdded, p_u_22, v25)
	end
	p_u_22:_Setup()
	task.defer(p_u_22._FetchBannedPlayers, p_u_22)
end
return v_u_8._new()