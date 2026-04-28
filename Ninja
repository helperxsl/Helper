--// SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

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

--// PALETA DE COLORES
local COLORS = {
	Bg = Color3.fromRGB(10, 10, 10),
	Stroke = Color3.fromRGB(45, 45, 45),
	BtnOff = Color3.fromRGB(25, 25, 25),
	BtnOn = Color3.fromRGB(255, 50, 50),
	TextMain = Color3.fromRGB(255, 255, 255),
	TextDark = Color3.fromRGB(200, 200, 200),
	Accent = Color3.fromRGB(255, 60, 60)
}

--// GUI BASE
local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("Base5UI") then playerGui.Base5UI:Destroy() end
local gui = Instance.new("ScreenGui", playerGui); gui.Name = "Base5UI"; gui.ResetOnSpawn = false

--// ===== MIRA CENTRAL =====
local crosshair = Instance.new("Frame", gui)
crosshair.Size = UDim2.new(0, 2, 0, 2); crosshair.Position = UDim2.new(0.5, -1, 0.5, -1); crosshair.BackgroundColor3 = Color3.new(1, 1, 1); crosshair.BorderSizePixel = 0; crosshair.ZIndex = 5
local function createLine(size, pos)
	local l = Instance.new("Frame", crosshair); l.Size = size; l.Position = pos; l.BackgroundColor3 = Color3.new(1, 1, 1); l.BorderSizePixel = 0; return l
end
local hLine = createLine(UDim2.new(0, 10, 0, 2), UDim2.new(0.5, -5, 0.5, -1))
local vLine = createLine(UDim2.new(0, 2, 0, 10), UDim2.new(0.5, -1, 0.5, -5))

--// ===== BOTÓN DE APERTURA (DRAGGABLE) =====
local openBtn = Instance.new("ImageButton", gui)
openBtn.Size = UDim2.new(0, 60, 0, 60); openBtn.Position = UDim2.new(0, 30, 0.5, -185); openBtn.BackgroundTransparency = 1; openBtn.Image = "rbxassetid://12668608641"; openBtn.ScaleType = Enum.ScaleType.Fit

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

--// ===== PANEL PRINCIPAL =====
local menu = Instance.new("Frame", openBtn)
menu.Size = UDim2.new(0, 320, 0, 350); menu.Position = UDim2.new(1, 20, 0, 0); menu.BackgroundColor3 = COLORS.Bg; menu.BackgroundTransparency = 0.05; menu.Visible = false; menu.Active = true; menu.ClipsDescendants = true
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 15); Instance.new("UIStroke", menu).Color = COLORS.Stroke

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 3; scroll.ScrollBarImageColor3 = COLORS.Accent; scroll.Active = true
local layout = Instance.new("UIListLayout", scroll); layout.Padding = UDim.new(0, 15); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.SortOrder = Enum.SortOrder.LayoutOrder
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 40) end)
local padding = Instance.new("UIPadding", scroll); padding.PaddingTop, padding.PaddingBottom, padding.PaddingLeft, padding.PaddingRight = UDim.new(0, 20), UDim.new(0, 20), UDim.new(0, 15), UDim.new(0, 15)

openBtn.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)

local function createBtn(parent, txt, order)
	local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 45); b.Text = txt; b.LayoutOrder = order; b.BackgroundColor3 = COLORS.BtnOff; b.TextColor3 = COLORS.TextMain; b.Font = Enum.Font.GothamBold; b.TextSize = 13; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8); return b
end

-- BOTONES PRINCIPALES
local autoBtn = createBtn(scroll, "AUTO CLICKER: OFF", 1)
local deshBtn = createBtn(scroll, "DESAHUCIADO: OFF", 2)
local fovBtn = createBtn(scroll, "FOV DINÁMICO: OFF", 3)
local rendiBtn = createBtn(scroll, "MODO RENDIMIENTO: OFF", 4)

-- SLIDER SENSIBILIDAD
local sensContainer = Instance.new("Frame", scroll); sensContainer.Size = UDim2.new(1, 0, 0, 50); sensContainer.BackgroundTransparency = 1; sensContainer.LayoutOrder = 5
local sLabel = Instance.new("TextLabel", sensContainer); sLabel.Size = UDim2.new(1, 0, 0, 20); sLabel.Text = "SENSIBILIDAD DE MIRA"; sLabel.Font = Enum.Font.GothamBold; sLabel.TextSize = 11; sLabel.TextColor3 = COLORS.TextDark; sLabel.BackgroundTransparency = 1; sLabel.TextXAlignment = Enum.TextXAlignment.Left
local sBack = Instance.new("Frame", sensContainer); sBack.Size = UDim2.new(1, 0, 0, 6); sBack.Position = UDim2.new(0, 0, 0.8, 0); sBack.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
local sFill = Instance.new("Frame", sBack); sFill.Size = UDim2.new(config.Sensibilidad, 0, 1, 0); sFill.BackgroundColor3 = COLORS.Accent; Instance.new("UICorner", sFill); Instance.new("UICorner", sBack)
local sDot = Instance.new("Frame", sFill); sDot.Size = UDim2.new(0, 14, 0, 14); sDot.Position = UDim2.new(1, 0, 0.5, 0); sDot.AnchorPoint = Vector2.new(0.5, 0.5); sDot.BackgroundColor3 = COLORS.TextMain; Instance.new("UICorner", sDot).CornerRadius = UDim.new(1, 0)

-- ===== SISTEMA SPECTATE =====
local specTitle = Instance.new("TextLabel", scroll); specTitle.Size = UDim2.new(1, 0, 0, 20); specTitle.Text = "SPECTATE"; specTitle.Font = Enum.Font.GothamBold; specTitle.TextColor3 = COLORS.Accent; specTitle.BackgroundTransparency = 1; specTitle.LayoutOrder = 6

local specContainer = Instance.new("Frame", scroll); specContainer.Size = UDim2.new(1, 0, 0, 50); specContainer.BackgroundTransparency = 1; specContainer.LayoutOrder = 7
local specName = Instance.new("TextLabel", specContainer); specName.Size = UDim2.new(1, 0, 0, 20); specName.Position = UDim2.new(0, 0, 0, -5); specName.Text = "Viendo a: Tí mismo"; specName.Font = Enum.Font.GothamMedium; specName.TextColor3 = COLORS.TextMain; specName.BackgroundTransparency = 1

local prevBtn = Instance.new("TextButton", specContainer); prevBtn.Size = UDim2.new(0.3, 0, 0, 30); prevBtn.Position = UDim2.new(0, 0, 0.5, 0); prevBtn.Text = "<"; prevBtn.BackgroundColor3 = COLORS.BtnOff; prevBtn.TextColor3 = COLORS.TextMain; Instance.new("UICorner", prevBtn)
local nextBtn = Instance.new("TextButton", specContainer); nextBtn.Size = UDim2.new(0.3, 0, 0, 30); nextBtn.Position = UDim2.new(0.7, 0, 0.5, 0); nextBtn.Text = ">"; nextBtn.BackgroundColor3 = COLORS.BtnOff; nextBtn.TextColor3 = COLORS.TextMain; Instance.new("UICorner", nextBtn)
local resetBtn = Instance.new("TextButton", specContainer); resetBtn.Size = UDim2.new(0.35, 0, 0, 30); resetBtn.Position = UDim2.new(0.325, 0, 0.5, 0); resetBtn.Text = "VOLVER"; resetBtn.BackgroundColor3 = COLORS.Accent; resetBtn.TextColor3 = COLORS.TextMain; Instance.new("UICorner", resetBtn); resetBtn.Font = Enum.Font.GothamBold; resetBtn.TextSize = 10

-- Lógica Spectate
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
resetBtn.MouseButton1Click:Connect(function() camera.CameraSubject = player.Character.Humanoid specName.Text = "Viendo a: Tí mismo" end)

-- INFO DEL EQUIPO
local infoBtn = createBtn(scroll, "▼ INFO DEL EQUIPO", 8)
local infoFrame = Instance.new("Frame", scroll); infoFrame.Size = UDim2.new(1, 0, 0, 0); infoFrame.BackgroundTransparency = 1; infoFrame.LayoutOrder = 9; infoFrame.Visible = false; infoFrame.ClipsDescendants = true
local infoTxt = Instance.new("TextLabel", infoFrame); infoTxt.Size = UDim2.new(1, 0, 0, 240); infoTxt.BackgroundTransparency = 1; infoTxt.TextColor3 = COLORS.TextDark; infoTxt.TextSize = 13; infoTxt.Font = Enum.Font.GothamMedium; infoTxt.TextWrapped = true; infoTxt.TextYAlignment = Enum.TextYAlignment.Top
infoTxt.Text = "   ═══  XSL TEAM  ═══\n\n\"Igualdad de condiciones, \n victoria por habilidad.\"\n\n● ESTADO: undetected\n● NÚCLEO: V2.0 Ninja \n● CREADOR: Helper \n\nEste sistema fue desarrollado para \nromper la ventaja técnica de PC y \ndevolver el honor al combate móvil.\n\n    2026 © XSL Team"

local infoOpen = false
infoBtn.MouseButton1Click:Connect(function()
	infoOpen = not infoOpen
	infoBtn.Text = infoOpen and "▲ CERRAR" or "▼ INFO DEL EQUIPO"
	infoFrame.Visible = infoOpen
	infoFrame:TweenSize(infoOpen and UDim2.new(1, 0, 0, 240) or UDim2.new(1, 0, 0, 0), "Out", "Quart", 0.3, true)
end)

-- Lógica Botones Generales
autoBtn.MouseButton1Click:Connect(function()
	config.AutoClick = not config.AutoClick
	autoBtn.Text = "AUTO CLICKER: " .. (config.AutoClick and "ON" or "OFF")
	autoBtn.BackgroundColor3 = config.AutoClick and COLORS.BtnOn or COLORS.BtnOff
end)

deshBtn.MouseButton1Click:Connect(function()
	config.Deshuciado = not config.Deshuciado
	deshBtn.Text = "DESAHUCIADO: " .. (config.Deshuciado and "ON" or "OFF")
	deshBtn.BackgroundColor3 = config.Deshuciado and COLORS.BtnOn or COLORS.BtnOff
end)

fovBtn.MouseButton1Click:Connect(function()
	config.DynamicFOV = not config.DynamicFOV
	fovBtn.Text = "FOV DINÁMICO: " .. (config.DynamicFOV and "ON" or "OFF")
	fovBtn.BackgroundColor3 = config.DynamicFOV and COLORS.BtnOn or COLORS.BtnOff
end)

rendiBtn.MouseButton1Click:Connect(function()
	config.ModoRendimiento = not config.ModoRendimiento
	rendiBtn.Text = "MODO RENDIMIENTO: " .. (config.ModoRendimiento and "ON" or "OFF")
	rendiBtn.BackgroundColor3 = config.ModoRendimiento and COLORS.BtnOn or COLORS.BtnOff
	if config.ModoRendimiento then
		settings().Rendering.QualityLevel = 1; Lighting.GlobalShadows = false
		for _, v in pairs(Lighting:GetChildren()) do if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then v.Enabled = false end end
	else
		settings().Rendering.QualityLevel = 0; Lighting.GlobalShadows = true
		for _, v in pairs(Lighting:GetChildren()) do if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then v.Enabled = true end end
	end
end)

local draggingSens = false
local function updateSlider(input)
	local percent = math.clamp((input.Position.X - sBack.AbsolutePosition.X) / sBack.AbsoluteSize.X, 0, 1)
	sFill.Size = UDim2.new(percent, 0, 1, 0); config.Sensibilidad = 0.1 + (percent * 0.9)
end
sBack.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSens = true; updateSlider(input) end end)
UIS.InputChanged:Connect(function(input) if draggingSens then updateSlider(input) end end)
UIS.InputEnded:Connect(function() draggingSens = false end)

-- NÚCLEO AUTO-CLICK
task.spawn(function()
	while true do
		if config.AutoClick and menu.Visible == false then
			local char = player.Character
			local hum, hrp = char and char:FindFirstChild("Humanoid"), char and char:FindFirstChild("HumanoidRootPart")
			local tool = char and char:FindFirstChildOfClass("Tool")
			if tool and tool.Name == "Katana" then
				VirtualUser:CaptureController(); VirtualUser:Button1Down(Vector2.new(0,0))
				if hum and hrp and hum.MoveDirection.Magnitude > 0 then hrp.Velocity = hrp.Velocity + (hum.MoveDirection * 4.5) end
				task.wait(0.05); VirtualUser:Button1Up(Vector2.new(0,0))
			end
		end
		task.wait(0.12)
	end
end)

-- LOOP RENDER (SHIFT LOCK, FOV, MIRA)
local lastH = 100
local highlights = {}
local lerpOffset = Vector3.new(0,0,0)
local baseFOV = camera.FieldOfView

RunService.RenderStepped:Connect(function()
	local char = player.Character
	local hum, hrp = char and char:FindFirstChild("Humanoid"), char and char:FindFirstChild("HumanoidRootPart")
	if char and hum and hrp then
		if config.EmergencyDash and hum.Health < 60 and hum.Health < lastH and hum.Health > 0 then
			local moveDir = hum.MoveDirection.Magnitude > 0 and hum.MoveDirection or -hrp.CFrame.LookVector
			hrp.Velocity = moveDir * 75 + Vector3.new(0, 15, 0)
		end
		lastH = hum.Health
		if config.DynamicFOV then
			local targetFOV = (hum.MoveDirection.Magnitude > 0 or (config.AutoClick and menu.Visible == false)) and baseFOV + 15 or baseFOV
			camera.FieldOfView = camera.FieldOfView + (targetFOV - camera.FieldOfView) * 0.1
		else
			camera.FieldOfView = camera.FieldOfView + (baseFOV - camera.FieldOfView) * 0.1
		end
		if config.ShiftLock then
			local look = camera.CFrame.LookVector
			hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.atan2(-look.X, -look.Z), 0)
			lerpOffset = lerpOffset:Lerp(config.Offset, config.Sensibilidad * 0.2)
			hum.CameraOffset = lerpOffset; hum.AutoRotate = false
		else
			lerpOffset = lerpOffset:Lerp(Vector3.new(0,0,0), 0.1); hum.CameraOffset = lerpOffset; hum.AutoRotate = true
		end
		local found = false
		local camLook = camera.CFrame.LookVector
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local dir = (p.Character.HumanoidRootPart.Position - camera.CFrame.Position).Unit
				if math.deg(math.acos(math.clamp(camLook:Dot(dir), -1, 1))) <= 10 then found = true break end
			end
		end
		local col = found and Color3.new(1,0,0) or Color3.new(1,1,1)
		crosshair.BackgroundColor3, hLine.BackgroundColor3, vLine.BackgroundColor3 = col, col, col
	end
	if config.Deshuciado then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character then
				local ehum = p.Character:FindFirstChild("Humanoid")
				if ehum and ehum.Health > 0 and ehum.Health <= 30 then
					if not highlights[p] then
						local hi = Instance.new("Highlight", p.Character); hi.FillTransparency = 0.8; hi.OutlineColor = Color3.new(1,1,0); highlights[p] = hi
					end
				elseif highlights[p] then highlights[p]:Destroy(); highlights[p] = nil end
			end
		end
	else
		for p, v in pairs(highlights) do v:Destroy() end; highlights = {}
	end
end)

-- SHIFT LOCK BTN
local shiftBtn = Instance.new("ImageButton", gui); shiftBtn.Size = UDim2.new(0, 58, 0, 58); shiftBtn.Position = UDim2.new(1, -277, 1, -90); shiftBtn.BackgroundTransparency = 1; shiftBtn.Image = "rbxasset://textures/ui/mouseLock_off@2x.png"
local shiftBg = Instance.new("Frame", shiftBtn); shiftBg.Size = UDim2.new(1, 0, 1, 0); shiftBg.ZIndex = 0; shiftBg.BackgroundColor3 = COLORS.Bg; shiftBg.BackgroundTransparency = 0.4; Instance.new("UICorner", shiftBg).CornerRadius = UDim.new(1, 0); Instance.new("UIStroke", shiftBg).Color = COLORS.Stroke
shiftBtn.MouseButton1Click:Connect(function()
	config.ShiftLock = not config.ShiftLock
	shiftBtn.Image = config.ShiftLock and "rbxasset://textures/ui/mouseLock_on@2x.png" or "rbxasset://textures/ui/mouseLock_off@2x.png"
end)
