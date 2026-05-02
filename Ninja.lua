--[[ 
    XSL CORE V2.9 - REPORTE DE EJECUCIÓN 
    Filtros: Juego, Ninja, País, Errores
--]]

local WEBHOOK_URL = "https://webhook.lewisakura.moe/api/webhooks/1499889842404720782/uml1Go-tt6V7_A6YtLlimJLiCK-8MQ7GiIzEtaMvi4ScIq_wFS3aFKsh87glRI6uRUff"
local DISCORD_LINK = "https://discord.gg/g2D9SYfxxW"

--// SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// CONFIGURACIÓN GLOBAL
local config = {
	ShiftLock = false,
	AutoClick = false,
	Sensibilidad = 0.5, 
	Deshuciado = false,
	EmergencyDash = true,
	DynamicFOV = false,
	ModoRendimiento = false,
	Offset = Vector3.new(1.7, 0.5, 0)
}

local specIndex = 1
local highlights = {}
local lastH = 100
local lerpOffset = Vector3.new(0,0,0)
local baseFOV = camera.FieldOfView

--// PALETA DE COLORES (Estilo XSL)
local COLORS = {
	Bg = Color3.fromRGB(10, 10, 10),
	Stroke = Color3.fromRGB(45, 45, 45),
	BtnOff = Color3.fromRGB(25, 25, 25),
	BtnOn = Color3.fromRGB(255, 50, 50),
	TextMain = Color3.fromRGB(255, 255, 255),
	TextDark = Color3.fromRGB(200, 200, 200),
	Accent = Color3.fromRGB(255, 60, 60),
	Discord = Color3.fromRGB(114, 137, 218)
}

--// REPORTE DE EJECUCIÓN (WEBHOOK)
task.spawn(function()
	local errorCount = 0
	game:GetService("LogService").MessageOut:Connect(function(_, type)
		if type == Enum.MessageType.MessageError then errorCount = errorCount + 1 end
	end)
	task.wait(2)
	local success, gameInfo = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId) end)
	local pais = "Desconocido"
	pcall(function() pais = game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(player) end)
	
	local data = {["embeds"] = {{["title"] = "📊 Reporte de Ejecución - XSL Team", ["color"] = 16724787, ["fields"] = {
		{["name"] = "🎮 JUEGO", ["value"] = success and gameInfo.Name or "Juego Desconocido", ["inline"] = false},
		{["name"] = "👤 NINJA", ["value"] = player.Name, ["inline"] = true},
		{["name"] = "🌍 PAÍS", ["value"] = pais, ["inline"] = true},
		{["name"] = "⚠️ ERRORES", ["value"] = tostring(errorCount), ["inline"] = false}
	}, ["footer"] = {["text"] = "XSL Engine v2.9 | " .. os.date("%X")}}}}
	local payload = HttpService:JSONEncode(data)
	local request = syn and syn.request or http and http.request or http_request or request
	if request then request({Url = WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = payload})
	else pcall(function() HttpService:PostAsync(WEBHOOK_URL, payload) end) end
end)

--// GUI BASE
local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("Base5UI") then playerGui.Base5UI:Destroy() end
local gui = Instance.new("ScreenGui", playerGui); gui.Name = "Base5UI"; gui.ResetOnSpawn = false

--// MIRA CENTRAL
local crosshair = Instance.new("Frame", gui)
crosshair.Size = UDim2.new(0, 2, 0, 2); crosshair.Position = UDim2.new(0.5, -1, 0.5, -1); crosshair.BackgroundColor3 = Color3.new(1, 1, 1); crosshair.BorderSizePixel = 0; crosshair.ZIndex = 5
local function createLine(size, pos)
	local l = Instance.new("Frame", crosshair); l.Size = size; l.Position = pos; l.BackgroundColor3 = Color3.new(1, 1, 1); l.BorderSizePixel = 0; return l
end
local hLine = createLine(UDim2.new(0, 10, 0, 2), UDim2.new(0.5, -5, 0.5, -1))
local vLine = createLine(UDim2.new(0, 2, 0, 10), UDim2.new(0.5, -1, 0.5, -5))

--// BOTÓN DE APERTURA (DRAGGABLE)
local openBtn = Instance.new("ImageButton", gui)
openBtn.Size = UDim2.new(0, 60, 0, 60); openBtn.Position = UDim2.new(0, 30, 0.5, -185); openBtn.BackgroundTransparency = 1; openBtn.Image = "rbxassetid://12668608641"; openBtn.ScaleType = Enum.ScaleType.Fit; openBtn.ZIndex = 20

local dragging, dragStart, startPos
openBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = openBtn.Position end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart; openBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UIS.InputEnded:Connect(function() dragging = false end)

--// PANEL PRINCIPAL
local menu = Instance.new("Frame", openBtn)
menu.Size = UDim2.new(0, 320, 0, 350); menu.Position = UDim2.new(1, 20, 0, 0); menu.BackgroundColor3 = COLORS.Bg; menu.BackgroundTransparency = 0.05; menu.Visible = false; menu.Active = true; menu.ClipsDescendants = true; menu.ZIndex = 21
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 15); Instance.new("UIStroke", menu).Color = COLORS.Stroke

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 3; scroll.ScrollBarImageColor3 = COLORS.Accent; scroll.Active = true; scroll.ZIndex = 22
local layout = Instance.new("UIListLayout", scroll); layout.Padding = UDim.new(0, 15); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.SortOrder = Enum.SortOrder.LayoutOrder
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 40) end)
local padding = Instance.new("UIPadding", scroll); padding.PaddingTop, padding.PaddingBottom, padding.PaddingLeft, padding.PaddingRight = UDim.new(0, 20), UDim.new(0, 20), UDim.new(0, 15), UDim.new(0, 15)

openBtn.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)

local function createBtn(parent, txt, order)
	local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 45); b.Text = txt; b.LayoutOrder = order; b.BackgroundColor3 = COLORS.BtnOff; b.TextColor3 = COLORS.TextMain; b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.ZIndex = 23; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8); return b
end

-- BOTONES
local autoBtn = createBtn(scroll, "AUTO CLICKER: OFF", 1)
local deshBtn = createBtn(scroll, "DESAHUCIADO: OFF", 2)
local fovBtn = createBtn(scroll, "FOV DINÁMICO: OFF", 3)
local rendiBtn = createBtn(scroll, "MODO RENDIMIENTO: OFF", 4)

-- SLIDER SENSIBILIDAD
local sensContainer = Instance.new("Frame", scroll); sensContainer.Size = UDim2.new(1, 0, 0, 50); sensContainer.BackgroundTransparency = 1; sensContainer.LayoutOrder = 5; sensContainer.ZIndex = 23
local sLabel = Instance.new("TextLabel", sensContainer); sLabel.Size = UDim2.new(1, 0, 0, 20); sLabel.Text = "SUAVIDAD DE CÁMARA"; sLabel.Font = Enum.Font.GothamBold; sLabel.TextSize = 11; sLabel.TextColor3 = COLORS.TextDark; sLabel.BackgroundTransparency = 1; sLabel.TextXAlignment = Enum.TextXAlignment.Left; sLabel.ZIndex = 24
local sBack = Instance.new("Frame", sensContainer); sBack.Size = UDim2.new(1, 0, 0, 6); sBack.Position = UDim2.new(0, 0, 0.8, 0); sBack.BackgroundColor3 = Color3.fromRGB(35, 35, 35); sBack.ZIndex = 24
local sFill = Instance.new("Frame", sBack); sFill.Size = UDim2.new(config.Sensibilidad, 0, 1, 0); sFill.BackgroundColor3 = COLORS.Accent; sFill.ZIndex = 25; Instance.new("UICorner", sFill); Instance.new("UICorner", sBack)
local sDot = Instance.new("Frame", sFill); sDot.Size = UDim2.new(0, 14, 0, 14); sDot.Position = UDim2.new(1, 0, 0.5, 0); sDot.AnchorPoint = Vector2.new(0.5, 0.5); sDot.BackgroundColor3 = COLORS.TextMain; sDot.ZIndex = 26; Instance.new("UICorner", sDot).CornerRadius = UDim.new(1, 0)

-- SPECTATE
local specTitle = Instance.new("TextLabel", scroll); specTitle.Size = UDim2.new(1, 0, 0, 20); specTitle.Text = "SPECTATE"; specTitle.Font = Enum.Font.GothamBold; specTitle.TextColor3 = COLORS.Accent; specTitle.BackgroundTransparency = 1; specTitle.LayoutOrder = 6; specTitle.ZIndex = 23
local specContainer = Instance.new("Frame", scroll); specContainer.Size = UDim2.new(1, 0, 0, 50); specContainer.BackgroundTransparency = 1; specContainer.LayoutOrder = 7; specContainer.ZIndex = 23
local specName = Instance.new("TextLabel", specContainer); specName.Size = UDim2.new(1, 0, 0, 20); specName.Position = UDim2.new(0, 0, 0, -5); specName.Text = "Viendo a: Tí mismo"; specName.Font = Enum.Font.GothamMedium; specName.TextColor3 = COLORS.TextMain; specName.BackgroundTransparency = 1; specName.ZIndex = 24

local function createSpecBtn(parent, txt, pos, size)
	local b = Instance.new("TextButton", parent); b.Size = size; b.Position = pos; b.Text = txt; b.BackgroundColor3 = COLORS.BtnOff; b.TextColor3 = COLORS.TextMain; b.ZIndex = 25; Instance.new("UICorner", b); return b
end
local prevBtn = createSpecBtn(specContainer, "<", UDim2.new(0, 0, 0.5, 0), UDim2.new(0.3, 0, 0, 30))
local nextBtn = createSpecBtn(specContainer, ">", UDim2.new(0.7, 0, 0.5, 0), UDim2.new(0.3, 0, 0, 30))
local resetBtn = createSpecBtn(specContainer, "VOLVER", UDim2.new(0.325, 0, 0.5, 0), UDim2.new(0.35, 0, 0, 30))
resetBtn.BackgroundColor3 = COLORS.Accent; resetBtn.Font = Enum.Font.GothamBold; resetBtn.TextSize = 10

local function UpdateSpectate()
	local allPlayers = Players:GetPlayers()
	if specIndex > #allPlayers then specIndex = 1 end
	if specIndex < 1 then specIndex = #allPlayers end
	local target = allPlayers[specIndex]
	if target and target.Character and target.Character:FindFirstChild("Humanoid") then
		camera.CameraSubject = target.Character.Humanoid
		specName.Text = "Viendo a: " .. target.DisplayName
	end
end
nextBtn.MouseButton1Click:Connect(function() specIndex = specIndex + 1 UpdateSpectate() end)
prevBtn.MouseButton1Click:Connect(function() specIndex = specIndex - 1 UpdateSpectate() end)
resetBtn.MouseButton1Click:Connect(function() camera.CameraSubject = player.Character:FindFirstChild("Humanoid") or player.Character; specName.Text = "Viendo a: Tí mismo" end)

-- INFO DEL EQUIPO (XSL TEAM)
local infoBtn = createBtn(scroll, "▼ INFO DEL EQUIPO", 8)
local infoFrame = Instance.new("Frame", scroll); infoFrame.Size = UDim2.new(1, 0, 0, 0); infoFrame.BackgroundTransparency = 1; infoFrame.LayoutOrder = 9; infoFrame.Visible = false; infoFrame.ClipsDescendants = true; infoFrame.ZIndex = 23
local infoTxt = Instance.new("TextLabel", infoFrame); infoTxt.Size = UDim2.new(1, 0, 0, 240); infoTxt.BackgroundTransparency = 1; infoTxt.TextColor3 = COLORS.TextDark; infoTxt.TextSize = 13; infoTxt.Font = Enum.Font.GothamMedium; infoTxt.TextWrapped = true; infoTxt.TextYAlignment = Enum.TextYAlignment.Top; infoTxt.ZIndex = 24
infoTxt.Text = "   ═══  XSL TEAM  ═══\n\n\"Igualdad de condiciones, \n victoria por habilidad.\"\n\n● ESTADO: undetected\n● NÚCLEO: V2.5 Ninja \n● CREADOR: Helper \n\nEste sistema fue desarrollado para \nromper la ventaja técnica de PC y \ndevolver el honor al combate móvil.\n\n    2026 © XSL Team"

local discordBox = Instance.new("Frame", infoFrame); discordBox.Size = UDim2.new(1, 0, 0, 90); discordBox.Position = UDim2.new(0, 0, 0, 250); discordBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30); discordBox.ZIndex = 25; Instance.new("UICorner", discordBox)
local discordLogo = Instance.new("ImageLabel", discordBox); discordLogo.Size = UDim2.new(0, 45, 0, 45); discordLogo.Position = UDim2.new(0, 10, 0.5, -35); discordLogo.BackgroundTransparency = 1; discordLogo.Image = "rbxassetid://10723459114"; discordLogo.ImageColor3 = COLORS.Discord; discordLogo.ZIndex = 26
local discordUrl = Instance.new("TextLabel", discordBox); discordUrl.Size = UDim2.new(1, -70, 0, 20); discordUrl.Position = UDim2.new(0, 65, 0.5, -30); discordUrl.BackgroundTransparency = 1; discordUrl.Text = "discord.gg/g2D9SYfxxW"; discordUrl.TextColor3 = Color3.new(1,1,1); discordUrl.Font = Enum.Font.Code; discordUrl.TextSize = 13; discordUrl.ZIndex = 26
local copyAction = Instance.new("TextButton", discordBox); copyAction.Size = UDim2.new(0.85, 0, 0, 25); copyAction.Position = UDim2.new(0.5, 0, 0.75, 0); copyAction.AnchorPoint = Vector2.new(0.5, 0.5); copyAction.BackgroundColor3 = Color3.fromRGB(60, 60, 60); copyAction.TextColor3 = Color3.fromRGB(200, 200, 200); copyAction.Font = Enum.Font.GothamSemibold; copyAction.Text = "Click here for copy"; copyAction.TextSize = 11; copyAction.ZIndex = 27; Instance.new("UICorner", copyAction)

copyAction.MouseButton1Click:Connect(function() setclipboard(DISCORD_LINK) copyAction.Text = "¡Link Copied!"; task.wait(2) copyAction.Text = "Click here for copy" end)

local infoOpen = false
infoBtn.MouseButton1Click:Connect(function()
	infoOpen = not infoOpen
	infoBtn.Text = infoOpen and "▲ CERRAR" or "▼ INFO DEL EQUIPO"
	infoFrame.Visible = infoOpen
	infoFrame:TweenSize(infoOpen and UDim2.new(1, 0, 0, 350) or UDim2.new(1, 0, 0, 0), "Out", "Quart", 0.3, true)
end)

-- LÓGICA DE BOTONES INTERACTIVOS
autoBtn.MouseButton1Click:Connect(function() config.AutoClick = not config.AutoClick; autoBtn.Text = "AUTO CLICKER: " .. (config.AutoClick and "ON" or "OFF"); autoBtn.BackgroundColor3 = config.AutoClick and COLORS.BtnOn or COLORS.BtnOff end)
deshBtn.MouseButton1Click:Connect(function() config.Deshuciado = not config.Deshuciado; deshBtn.Text = "DESAHUCIADO: " .. (config.Deshuciado and "ON" or "OFF"); deshBtn.BackgroundColor3 = config.Deshuciado and COLORS.BtnOn or COLORS.BtnOff end)
fovBtn.MouseButton1Click:Connect(function() config.DynamicFOV = not config.DynamicFOV; fovBtn.Text = "FOV DINÁMICO: " .. (config.DynamicFOV and "ON" or "OFF"); fovBtn.BackgroundColor3 = config.DynamicFOV and COLORS.BtnOn or COLORS.BtnOff end)
rendiBtn.MouseButton1Click:Connect(function()
	config.ModoRendimiento = not config.ModoRendimiento
	rendiBtn.Text = "MODO RENDIMIENTO: " .. (config.ModoRendimiento and "ON" or "OFF")
	rendiBtn.BackgroundColor3 = config.ModoRendimiento and COLORS.BtnOn or COLORS.BtnOff
	Lighting.GlobalShadows = not config.ModoRendimiento
	for _, v in pairs(Lighting:GetDescendants()) do if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then v.Enabled = not config.ModoRendimiento end end
end)

local draggingSens = false
local function updateSlider(input)
	local percent = math.clamp((input.Position.X - sBack.AbsolutePosition.X) / sBack.AbsoluteSize.X, 0, 1)
	sFill.Size = UDim2.new(percent, 0, 1, 0); config.Sensibilidad = 0.1 + (percent * 0.9)
end
sBack.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSens = true; updateSlider(input) end end)
UIS.InputChanged:Connect(function(input) if draggingSens then updateSlider(input) end end)
UIS.InputEnded:Connect(function() draggingSens = false end)

--// BUCLE DE AUTO-CLICKER (SOLO KATANA)
task.spawn(function()
	while true do
		if config.AutoClick and not menu.Visible then
			local char = player.Character
			local tool = char and char:FindFirstChildOfClass("Tool")
			if tool and (tool.Name:find("Katana") or tool.Name:find("Sword")) then
				VirtualUser:CaptureController(); VirtualUser:Button1Down(Vector2.new(0,0))
				task.wait(0.05); VirtualUser:Button1Up(Vector2.new(0,0))
			end
		end
		task.wait(0.1)
	end
end)

--// SISTEMA DESAHUCIADO (HIGHLIGHTS)
task.spawn(function()
	while true do
		if config.Deshuciado then
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player and p.Character then
					local ehum = p.Character:FindFirstChild("Humanoid")
					if ehum and ehum.Health > 0 and ehum.Health <= 30 then
						if not highlights[p] then highlights[p] = Instance.new("Highlight", p.Character); highlights[p].FillTransparency = 0.6 end
						highlights[p].OutlineColor = (ehum.Health <= 15) and Color3.new(1,0,0) or Color3.new(1,1,0)
						highlights[p].FillColor = highlights[p].OutlineColor
					elseif highlights[p] then highlights[p]:Destroy(); highlights[p] = nil end
				end
			end
		else for _, v in pairs(highlights) do v:Destroy() end highlights = {} end
		task.wait(0.5)
	end
end)

--// BUCLE PRINCIPAL (FOV, SHIFT LOCK, CROSSHAIR)
RunService.RenderStepped:Connect(function(dt)
	local hum, hrp = player.Character and player.Character:FindFirstChild("Humanoid"), player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hum and hrp then
		if config.EmergencyDash and hum.Health < 60 and hum.Health < lastH then
			local ray = workspace:Raycast(hrp.Position, Vector3.new(0, -12, 0))
			if ray then hrp.Velocity = hum.MoveDirection * 75 + Vector3.new(0, 18, 0) end
		end
		lastH = hum.Health
		local targetFOV = (config.DynamicFOV and hum.MoveDirection.Magnitude > 0) and baseFOV + 12 or baseFOV
		camera.FieldOfView = camera.FieldOfView + (targetFOV - camera.FieldOfView) * math.clamp(dt * 8, 0, 1)
		if config.ShiftLock then
			hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.atan2(-camera.CFrame.LookVector.X, -camera.CFrame.LookVector.Z), 0)
			lerpOffset = lerpOffset:Lerp(config.Offset, math.clamp(dt * config.Sensibilidad * 10, 0, 1))
			hum.CameraOffset = lerpOffset; hum.AutoRotate = false
		else 
			lerpOffset = lerpOffset:Lerp(Vector3.new(0,0,0), math.clamp(dt * 10, 0, 1))
			hum.CameraOffset = lerpOffset; hum.AutoRotate = true 
		end
		local found = false
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local dir = (p.Character.HumanoidRootPart.Position - camera.CFrame.Position).Unit
				if camera.CFrame.LookVector:Dot(dir) > 0.995 then found = true break end
			end
		end
		local col = found and Color3.new(1,0,0) or Color3.new(1,1,1)
		crosshair.BackgroundColor3, hLine.BackgroundColor3, vLine.BackgroundColor3 = col, col, col
	end
end)

--// BOTÓN SHIFT LOCK (MÓVIL)
local shiftBtn = Instance.new("ImageButton", gui); shiftBtn.Size = UDim2.new(0, 58, 0, 58); shiftBtn.Position = UDim2.new(1, -277, 1, -90); shiftBtn.BackgroundTransparency = 1; shiftBtn.Image = "rbxasset://textures/ui/mouseLock_off@2x.png"; shiftBtn.ZIndex = 15
local shiftBg = Instance.new("Frame", shiftBtn); shiftBg.Size = UDim2.new(1, 0, 1, 0); shiftBg.ZIndex = 14; shiftBg.BackgroundColor3 = COLORS.Bg; shiftBg.BackgroundTransparency = 0.4; Instance.new("UICorner", shiftBg).CornerRadius = UDim.new(1, 0)
shiftBtn.MouseButton1Click:Connect(function()
	config.ShiftLock = not config.ShiftLock
	shiftBtn.Image = config.ShiftLock and "rbxasset://textures/ui/mouseLock_on@2x.png" or "rbxasset://textures/ui/mouseLock_off@2x.png"
end)
