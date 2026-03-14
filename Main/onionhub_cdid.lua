	-- Module Script (LIBRARY)

	local Onion = {}

	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local UIS = game:GetService("UserInputService")

	local Player = Players.LocalPlayer
	local PlayerGui = Player:WaitForChild("PlayerGui")

	local Config = {}
	local NotifyGui

	local CurrentMap = {
		[6911148748] = "Lobby",
		[14005966837] = "Jakarta",
		[9233343468] = "Jawa Barat",
		[132986577553100] = "Seasonal (PIK 2)",
		[9508940498] = "Jawa Tengah",
		[110369730911937] = "Jawa Timur",
		[118108582994420] = "Bali"
	}
	local mapName = CurrentMap[game.PlaceId] or "Unknown Map"

	local ScriptUserType = "Free User"

	local function tween(obj, props, time)
		local t = TweenService:Create(obj, TweenInfo.new(time or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
		t:Play()
		return t
	end

	local function applyHover(button, normalColor, hoverColor)
		button.MouseEnter:Connect(function() tween(button, {BackgroundColor3 = hoverColor}, 0.2) end)
		button.MouseLeave:Connect(function() tween(button, {BackgroundColor3 = normalColor}, 0.2) end)
	end

	local function MakeDraggable(topbar, object)
		local dragging, dragInput, dragStart, startPos
		topbar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = object.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then dragging = false end
				end)
			end
		end)
		topbar.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
		end)
		UIS.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local delta = input.Position - dragStart
				object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
	end

	function Onion:SaveConfig(k, v) Config[k] = v end
	function Onion:GetConfig(k) return Config[k] end

	function Onion:Notify(title, text, duration)
		duration = duration or 3

		if not NotifyGui then
			NotifyGui = Instance.new("ScreenGui")
			NotifyGui.Name = "OnionNotify"
			NotifyGui.ResetOnSpawn = false
			NotifyGui.Parent = PlayerGui

			local holder = Instance.new("Frame")
			holder.Name = "Holder"
			holder.AnchorPoint = Vector2.new(1,1)
			holder.Position = UDim2.new(1,-20,1,-20)
			holder.Size = UDim2.new(0,240,1,0)
			holder.BackgroundTransparency = 1
			holder.Parent = NotifyGui

			local layout = Instance.new("UIListLayout")
			layout.Padding = UDim.new(0,8)
			layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
			layout.Parent = holder
		end


		-- container (UIListLayout control)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1,0,0,70)
		frame.BackgroundTransparency = 1
		frame.Parent = NotifyGui.Holder


		-- anim frame (ini yg kita slide)
		local anim = Instance.new("Frame")
		anim.Size = UDim2.new(1,0,1,0)
		anim.Position = UDim2.new(1,40,0,0)
		anim.BackgroundColor3 = Color3.fromRGB(20,20,20)
		anim.BackgroundTransparency = 0.2
		anim.Parent = frame

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0,6)
		corner.Parent = anim

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(180,0,30)
		stroke.Thickness = 1.5
		stroke.Transparency = 0.5
		stroke.Parent = anim


		local titleLbl = Instance.new("TextLabel")
		titleLbl.Size = UDim2.new(1,-20,0,25)
		titleLbl.Position = UDim2.new(0,10,0,5)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = title
		titleLbl.Font = Enum.Font.GothamBold
		titleLbl.TextSize = 14
		titleLbl.TextColor3 = Color3.new(1,1,1)
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		titleLbl.Parent = anim


		local txt = Instance.new("TextLabel")
		txt.Size = UDim2.new(1,-20,0,35)
		txt.Position = UDim2.new(0,10,0,25)
		txt.BackgroundTransparency = 1
		txt.Text = text
		txt.Font = Enum.Font.Gotham
		txt.TextSize = 12
		txt.TextColor3 = Color3.fromRGB(180,180,180)
		txt.TextWrapped = true
		txt.TextXAlignment = Enum.TextXAlignment.Left
		txt.Parent = anim


		-- progress bg
		local barBg = Instance.new("Frame")
		barBg.Size = UDim2.new(1,0,0,3)
		barBg.Position = UDim2.new(0,0,1,-3)
		barBg.BackgroundTransparency = 0.6
		barBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
		barBg.Parent = anim
		Instance.new("UICorner", barBg)


		-- progress bar
		local bar = Instance.new("Frame")
		bar.Size = UDim2.new(0,0,1,0)
		bar.BackgroundColor3 = Color3.fromRGB(3,88,191)
		bar.Parent = barBg
		Instance.new("UICorner", bar)


		-- masuk slide kiri
		tween(anim,{
			Position = UDim2.new(0,0,0,0)
		},0.35)


		-- progress
		tween(bar,{
			Size = UDim2.new(1,0,1,0)
		},duration)


		task.delay(duration,function()

			local t = tween(anim,{
				Position = UDim2.new(1,40,0,0)
			},0.35)

			t.Completed:Wait()
			frame:Destroy()

		end)

	end

	function Onion:Intro()
		local introGui = Instance.new("ScreenGui", PlayerGui)
		introGui.Name = "OnionIntro"
		introGui.IgnoreGuiInset = true 
		introGui.DisplayOrder = 9999 

		local canvas = Instance.new("Frame", introGui)
		canvas.Size = UDim2.new(1, 0, 1, 0)
		canvas.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
		canvas.BorderSizePixel = 0
		canvas.BackgroundTransparency = 0 

		local logo = Instance.new("TextLabel", canvas)
		logo.Size = UDim2.new(0, 0, 0, 0)
		logo.Position = UDim2.new(0.5, 0, 0.5, 0)
		logo.AnchorPoint = Vector2.new(0.5, 0.5)
		logo.BackgroundTransparency = 1
		logo.Text = "🧅 ONION HUB 🧅"
		logo.Font = Enum.Font.GothamBold
		logo.TextColor3 = Color3.fromRGB(180, 0, 30)
		logo.TextSize = 0
		logo.TextTransparency = 1

		-- [1] DURASI MUNCUL: 1.5 biar pelan dan smooth
		tween(logo, {TextSize = 45, TextTransparency = 0}, 1.5).Completed:Wait()

		-- [2] DURASI DIEM: Ganti angka 2 ini kalo mau logo diem lebih lama
		task.wait(2)

		-- [3] DURASI ILANG: 1.0 biar transisi ke main menu nggak kaget
		tween(logo, {TextSize = 80, TextTransparency = 1}, 1.0)
		local fade = tween(canvas, {BackgroundTransparency = 1}, 1.2)

		fade.Completed:Wait()
		introGui:Destroy()
	end

	function Onion:KeySystem(info)
		local key = info.CorrectKey
		local gui = Instance.new("ScreenGui", PlayerGui)

		local frame = Instance.new("Frame", gui)
		frame.Size = UDim2.new(0, 320, 0, 180)
		frame.Position = UDim2.new(0.5, -160, 0.5, -90)
		frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

		local stroke = Instance.new("UIStroke", frame)
		stroke.Color = Color3.fromRGB(180, 0, 30)
		stroke.Thickness = 2

		local title = Instance.new("TextLabel", frame)
		title.Size = UDim2.new(1, 0, 0, 40)
		title.BackgroundTransparency = 1
		title.Text = "🧅 Java Onion Hub 🧅"
		title.Font = Enum.Font.GothamBold
		title.TextSize = 14
		title.TextColor3 = Color3.fromRGB(255, 255, 255)

		local title2 = Instance.new("TextLabel", frame)
		title2.Size = UDim2.new(1, 0, 0, 44)
		title2.AnchorPoint = Vector2.new(0.5, 0)
		title2.Position = UDim2.new(0.5, 0, 0, 30)
		title2.BackgroundTransparency = 1
		title2.Text = "🗝️ KEY SYSTEM 🗝️"
		title2.Font = Enum.Font.GothamBold
		title2.TextSize = 35
		title2.TextColor3 = Color3.fromRGB(255,255,255)

		task.spawn(function()
			while true do
				for i = 0, 1, 0.005 do
					title2.TextColor3 = Color3.fromHSV(i, 1, 1)
					task.wait()
				end
			end
		end)

		local box = Instance.new("TextBox", frame)
		box.Size = UDim2.new(0, 260, 0, 40)
		box.Position = UDim2.new(0.5, -130, 0.5, -1)
		box.PlaceholderText = "Enter key here..."
		box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		box.TextColor3 = Color3.new(1, 1, 1)
		box.Font = Enum.Font.Gotham
		Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
		Instance.new("UIStroke", box).Color = Color3.fromRGB(50, 50, 50)

		local btn = Instance.new("TextButton", frame)
		btn.Size = UDim2.new(0, 140, 0, 35)
		btn.Position = UDim2.new(0.5, -70, 1, -45)
		btn.Text = "VERIFY"
		btn.TextSize = 12
		btn.BackgroundColor3 = Color3.fromRGB(180, 0, 30)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.GothamBold
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		applyHover(btn, Color3.fromRGB(180, 0, 30), Color3.fromRGB(220, 20, 50))

		local passed = false

		btn.MouseButton1Click:Connect(function()
			if box.Text == key then
				passed = true
				tween(frame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3).Completed:Wait()
				gui:Destroy()
			else
				btn.Text = "WRONG KEY"
				tween(btn, {BackgroundColor3 = Color3.fromRGB(255, 0, 0)}, 0.1)
				task.wait(1)
				btn.Text = "VERIFY"
				tween(btn, {BackgroundColor3 = Color3.fromRGB(180, 0, 30)}, 0.2)
			end
		end)

		repeat task.wait() until passed
	end

	function Onion:CreateWindow(title)
		local MainGui = Instance.new("ScreenGui", PlayerGui)
		MainGui.Name = "OnionHub"

		local main = Instance.new("Frame", MainGui)
		main.Size = UDim2.new(0, 600, 0, 380)
		main.Position = UDim2.new(0.5, -300, 0.5, -190)
		main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

		local mainStroke = Instance.new("UIStroke", main)
		mainStroke.Color = Color3.fromRGB(40, 40, 40)
		mainStroke.Thickness = 2

		local top = Instance.new("Frame", main)
		top.Size = UDim2.new(1, 0, 0, 40)
		top.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		top.BorderSizePixel = 0
		Instance.new("UICorner", top).CornerRadius = UDim.new(0, 8)

		local cornerFix = Instance.new("Frame", top)
		cornerFix.Size = UDim2.new(1, 0, 0, 10)
		cornerFix.Position = UDim2.new(0, 0, 1, -10)
		cornerFix.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		cornerFix.BorderSizePixel = 0

		local titleLbl = Instance.new("TextLabel", top)
		titleLbl.Size = UDim2.new(1, -15, 1, 0)
		titleLbl.Position = UDim2.new(0, 15, 0, 0)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = title
		titleLbl.Font = Enum.Font.GothamBold
		titleLbl.TextSize = 16
		titleLbl.TextColor3 = Color3.new(1, 1, 1)
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left

		MakeDraggable(top, main)

		local tabButtons = Instance.new("Frame", main)
		tabButtons.Size = UDim2.new(0, 140, 1, -40)
		tabButtons.Position = UDim2.new(0, 0, 0, 40)
		tabButtons.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		tabButtons.BorderSizePixel = 0

		local tabLayout = Instance.new("UIListLayout", tabButtons)
		tabLayout.Padding = UDim.new(0, 2)
		tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

		local tabPadding = Instance.new("UIPadding", tabButtons)
		tabPadding.PaddingTop = UDim.new(0, 10)

		-- discord style user panel
		local userPanel = Instance.new("Frame", main)
		userPanel.Size = UDim2.new(0,140,0,50)
		userPanel.Position = UDim2.new(0,0,1,-50)
		userPanel.BackgroundColor3 = Color3.fromRGB(22,22,22)
		userPanel.BorderSizePixel = 0

		local avatar = Instance.new("ImageLabel", userPanel)
		avatar.Size = UDim2.new(0,34,0,34)

		avatar.Position = UDim2.new(0,8,0.5,-17)
		avatar.BackgroundTransparency = 1

		local content, isReady = Players:GetUserThumbnailAsync(
			Player.UserId,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size180x180
		)

		avatar.Image = content

		-- rounded avatar
		local avatarCorner = Instance.new("UICorner", avatar)
		avatarCorner.CornerRadius = UDim.new(1,0)

		local name = Instance.new("TextLabel", userPanel)
		name.Size = UDim2.new(1,-50,0,20)
		name.Position = UDim2.new(0,50,0,6)
		name.BackgroundTransparency = 1
		name.Text = Player.DisplayName
		name.Font = Enum.Font.GothamBold
		name.TextSize = 12
		name.TextColor3 = Color3.new(1,1,1)
		name.TextXAlignment = Enum.TextXAlignment.Left

		local userType = Instance.new("TextLabel", userPanel)
		userType.Size = UDim2.new(1,-50,0,16)
		userType.Position = UDim2.new(0,50,0,24)
		userType.BackgroundTransparency = 1
		userType.Text = ScriptUserType
		userType.Font = Enum.Font.Gotham
		userType.TextSize = 10
		userType.TextColor3 = Color3.fromRGB(150,150,150)
		userType.TextXAlignment = Enum.TextXAlignment.Left

		local pages = Instance.new("Frame", main)
		pages.Size = UDim2.new(1, -150, 1, -50)
		pages.Position = UDim2.new(0, 150, 0, 45)
		pages.BackgroundTransparency = 1

		local Window = {}
		local firstTab = true

		function Window:CreateTab(name)
			local btn = Instance.new("TextButton", tabButtons)
			btn.Size = UDim2.new(0, 120, 0, 35)
			btn.Text = name
			btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 13
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

			applyHover(btn, Color3.fromRGB(25, 25, 25), Color3.fromRGB(40, 40, 40))

			local page = Instance.new("ScrollingFrame", pages)
			page.Size = UDim2.new(1, 0, 1, 0)
			page.Visible = firstTab
			page.BackgroundTransparency = 1
			page.AutomaticCanvasSize = Enum.AutomaticSize.Y
			page.ScrollBarThickness = 3
			page.BorderSizePixel = 0
			page.ScrollBarImageColor3 = Color3.fromRGB(180, 0, 30)

			if firstTab then
				btn.BackgroundColor3 = Color3.fromRGB(180, 0, 30)
				applyHover(btn, Color3.fromRGB(180, 0, 30), Color3.fromRGB(220, 20, 50))
				firstTab = false 
			end

			local layout = Instance.new("UIListLayout", page)
			layout.Padding = UDim.new(0, 12)

			btn.MouseButton1Click:Connect(function()
				for _, v in pairs(pages:GetChildren()) do
					if v:IsA("ScrollingFrame") then v.Visible = false end
				end
				for _, v in pairs(tabButtons:GetChildren()) do
					if v:IsA("TextButton") then 
						tween(v, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}, 0.2)
						applyHover(v, Color3.fromRGB(25, 25, 25), Color3.fromRGB(40, 40, 40))
					end
				end
				tween(btn, {BackgroundColor3 = Color3.fromRGB(180, 0, 30)}, 0.2)
				applyHover(btn, Color3.fromRGB(180, 0, 30), Color3.fromRGB(220, 20, 50))
				page.Visible = true
			end)

			local Tab = {}

			function Tab:CreateSection(secName)
				local sec = Instance.new("Frame", page)
				sec.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				sec.AutomaticSize = Enum.AutomaticSize.Y
				sec.Size = UDim2.new(1, -10, 0, 0)
				Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 6)
				Instance.new("UIStroke", sec).Color = Color3.fromRGB(40, 40, 40)

				local lbl = Instance.new("TextLabel", sec)
				lbl.Text = "  " .. secName
				lbl.Size = UDim2.new(1, 0, 0, 30)
				lbl.BackgroundTransparency = 1
				lbl.Font = Enum.Font.GothamBold
				lbl.TextSize = 14
				lbl.TextColor3 = Color3.fromRGB(180, 0, 30)
				lbl.TextXAlignment = Enum.TextXAlignment.Left

				local elements = Instance.new("Frame", sec)
				elements.Position = UDim2.new(0, 10, 0, 35)
				elements.Size = UDim2.new(1, -20, 0, 0)
				elements.AutomaticSize = Enum.AutomaticSize.Y
				elements.BackgroundTransparency = 1

				local elLayout = Instance.new("UIListLayout", elements)
				elLayout.Padding = UDim.new(0, 8)

				local padding = Instance.new("UIPadding", elements)
				padding.PaddingBottom = UDim.new(0, 12)

				local Section = {}

				function Section:Button(text, callback)
					local b = Instance.new("TextButton", elements)
					b.Size = UDim2.new(1, 0, 0, 35)
					b.Text = text
					b.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
					b.TextColor3 = Color3.new(1, 1, 1)
					b.Font = Enum.Font.Gotham
					b.TextSize = 13
					Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
					Instance.new("UIStroke", b).Color = Color3.fromRGB(50, 50, 50)

					applyHover(b, Color3.fromRGB(28, 28, 28), Color3.fromRGB(40, 40, 40))

					b.MouseButton1Down:Connect(function()
						tween(b, {Size = UDim2.new(1, -4, 0, 31), Position = UDim2.new(0, 2, 0, 2)}, 0.1)
					end)
					b.MouseButton1Up:Connect(function()
						tween(b, {Size = UDim2.new(1, 0, 0, 35), Position = UDim2.new(0, 0, 0, 0)}, 0.1)
						callback()
					end)
				end

				function Section:Toggle(text, callback)
					local state = Onion:GetConfig(text) or false

					local tBtn = Instance.new("TextButton", elements)
					tBtn.Size = UDim2.new(1, 0, 0, 35)
					tBtn.Text = "  " .. text
					tBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
					tBtn.TextColor3 = Color3.new(1, 1, 1)
					tBtn.Font = Enum.Font.Gotham
					tBtn.TextSize = 13
					tBtn.TextXAlignment = Enum.TextXAlignment.Left
					Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 6)
					Instance.new("UIStroke", tBtn).Color = Color3.fromRGB(50, 50, 50)

					local indBg = Instance.new("Frame", tBtn)
					indBg.Size = UDim2.new(0, 36, 0, 20)
					indBg.Position = UDim2.new(1, -46, 0.5, -10)
					indBg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
					Instance.new("UICorner", indBg).CornerRadius = UDim.new(1, 0)
					Instance.new("UIStroke", indBg).Color = Color3.fromRGB(60, 60, 60)

					local ind = Instance.new("Frame", indBg)
					ind.Size = UDim2.new(0, 16, 0, 16)
					ind.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
					ind.BackgroundColor3 = state and Color3.fromRGB(180, 0, 30) or Color3.fromRGB(100, 100, 100)
					Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)

					tBtn.MouseButton1Click:Connect(function()
						state = not state
						tween(ind, {
							Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
							BackgroundColor3 = state and Color3.fromRGB(180, 0, 30) or Color3.fromRGB(100, 100, 100)
						}, 0.25)
						tween(indBg, {BackgroundColor3 = state and Color3.fromRGB(40, 10, 15) or Color3.fromRGB(15, 15, 15)}, 0.25)

						Onion:SaveConfig(text, state)
						callback(state)
					end)
				end

				function Section:Dropdown(text, list, callback)
					local dropFrame = Instance.new("Frame", elements)
					dropFrame.Size = UDim2.new(1, 0, 0, 35)
					dropFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
					dropFrame.ClipsDescendants = true
					Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 6)
					Instance.new("UIStroke", dropFrame).Color = Color3.fromRGB(50, 50, 50)

					local dBtn = Instance.new("TextButton", dropFrame)
					dBtn.Size = UDim2.new(1, -20, 0, 35)
					dBtn.Position = UDim2.new(0, 10, 0, 0)
					dBtn.Text = text .. " ▼"
					dBtn.BackgroundTransparency = 1
					dBtn.TextColor3 = Color3.new(1, 1, 1)
					dBtn.Font = Enum.Font.Gotham
					dBtn.TextSize = 13
					dBtn.TextXAlignment = Enum.TextXAlignment.Left

					local optHolder = Instance.new("Frame", dropFrame)
					optHolder.Position = UDim2.new(0, 0, 0, 35)
					optHolder.Size = UDim2.new(1, 0, 1, -35)
					optHolder.BackgroundTransparency = 1

					local optLayout = Instance.new("UIListLayout", optHolder)

					local open = false
					local totalSize = 35 + (#list * 30)

					for _, v in pairs(list) do
						local opt = Instance.new("TextButton", optHolder)
						opt.Size = UDim2.new(1, 0, 0, 30)
						opt.Text = "  " .. v
						opt.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
						opt.TextColor3 = Color3.fromRGB(200, 200, 200)
						opt.Font = Enum.Font.Gotham
						opt.TextSize = 13
						opt.BorderSizePixel = 0
						opt.TextXAlignment = Enum.TextXAlignment.Left

						applyHover(opt, Color3.fromRGB(28, 28, 28), Color3.fromRGB(45, 45, 45))

						opt.MouseButton1Click:Connect(function()
							dBtn.Text = text .. " : " .. v .. " ▼"
							callback(v)
							open = false
							tween(dropFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.25)
						end)
					end

					dBtn.MouseButton1Click:Connect(function()
						open = not open
						if open then
							tween(dropFrame, {Size = UDim2.new(1, 0, 0, totalSize)}, 0.25)
							dBtn.Text = text .. " ▲"
						else
							tween(dropFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.25)
							dBtn.Text = text .. " ▼"
						end
					end)
				end
			function Section:TextBoxString(text, placeholder, callback)

				local frame = Instance.new("Frame", elements)
				frame.Size = UDim2.new(1,0,0,35)
				frame.BackgroundColor3 = Color3.fromRGB(28,28,28)
				Instance.new("UICorner",frame).CornerRadius = UDim.new(0,6)
				Instance.new("UIStroke",frame).Color = Color3.fromRGB(50,50,50)

				local label = Instance.new("TextLabel",frame)
				label.Size = UDim2.new(0.4,0,1,0)
				label.BackgroundTransparency = 1
				label.Text = "  "..text
				label.Font = Enum.Font.Gotham
				label.TextSize = 13
				label.TextColor3 = Color3.new(1,1,1)
				label.TextXAlignment = Enum.TextXAlignment.Left

				local box = Instance.new("TextBox",frame)
				box.Size = UDim2.new(0.6,-10,0,25)
				box.Position = UDim2.new(0.4,5,0.5,-12)
				box.PlaceholderText = placeholder or "enter text..."
				box.BackgroundColor3 = Color3.fromRGB(22,22,22)
				box.TextColor3 = Color3.new(1,1,1)
				box.Font = Enum.Font.Gotham
				box.TextSize = 13
				Instance.new("UICorner",box).CornerRadius = UDim.new(0,4)

				box.FocusLost:Connect(function(enter)
					if enter then
						callback(box.Text)
					end
				end)

			end
				function Section:Embed(info)

					local embedFrame = Instance.new("Frame", elements)
					embedFrame.Size = UDim2.new(1, 0, 0, 0)
					embedFrame.AutomaticSize = Enum.AutomaticSize.Y
					embedFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
					embedFrame.BorderSizePixel = 0
					Instance.new("UICorner", embedFrame).CornerRadius = UDim.new(0, 6)
					Instance.new("UIStroke", embedFrame).Color = Color3.fromRGB(45, 45, 45)

					local content = Instance.new("Frame", embedFrame)
					content.BackgroundTransparency = 1
					content.Size = UDim2.new(1, 0, 0, 0)
					content.AutomaticSize = Enum.AutomaticSize.Y

					local padding = Instance.new("UIPadding", content)
					padding.PaddingTop = UDim.new(0, 10)
					padding.PaddingBottom = UDim.new(0, 10)
					padding.PaddingLeft = UDim.new(0, 10)
					padding.PaddingRight = UDim.new(0, 10)

					local layout = Instance.new("UIListLayout", content)
					layout.Padding = UDim.new(0, 6)
					layout.SortOrder = Enum.SortOrder.LayoutOrder

					local order = 1
					local descLabel

					if info.Title then
						local title = Instance.new("TextLabel", content)
						title.Size = UDim2.new(1, 0, 0, 16)
						title.BackgroundTransparency = 1
						title.Text = info.Title
						title.Font = Enum.Font.GothamBold
						title.TextSize = 13
						title.TextColor3 = Color3.new(1,1,1)
						title.TextXAlignment = Enum.TextXAlignment.Left
						title.LayoutOrder = order
						order += 1
					end

					if info.Description then
						descLabel = Instance.new("TextLabel", content)
						descLabel.Size = UDim2.new(1, 0, 0, 0)
						descLabel.AutomaticSize = Enum.AutomaticSize.Y
						descLabel.BackgroundTransparency = 1
						descLabel.Text = info.Description
						descLabel.Font = Enum.Font.Gotham
						descLabel.TextSize = 12
						descLabel.TextColor3 = Color3.fromRGB(170,170,170)
						descLabel.TextXAlignment = Enum.TextXAlignment.Left
						descLabel.TextWrapped = true
						descLabel.LayoutOrder = order
						order += 1
					end

					local fieldLabels = {}

					if info.Fields then
						local fieldContainer = Instance.new("Frame", content)
						fieldContainer.BackgroundTransparency = 1
						fieldContainer.Size = UDim2.new(1, 0, 0, 0)
						fieldContainer.AutomaticSize = Enum.AutomaticSize.Y
						fieldContainer.LayoutOrder = order

						local fieldLayout = Instance.new("UIListLayout", fieldContainer)
						fieldLayout.Padding = UDim.new(0, 4)
						fieldLayout.SortOrder = Enum.SortOrder.LayoutOrder

						for i, f in ipairs(info.Fields) do
							local fText = Instance.new("TextLabel", fieldContainer)
							fText.Size = UDim2.new(1, 0, 0, 0)
							fText.AutomaticSize = Enum.AutomaticSize.Y
							fText.BackgroundTransparency = 1
							fText.RichText = true
							fText.Text = "<b>"..f.Name.." :</b> "..tostring(f.Value)
							fText.Font = Enum.Font.Gotham
							fText.TextSize = 12
							fText.TextColor3 = Color3.fromRGB(190,190,190)
							fText.TextXAlignment = Enum.TextXAlignment.Left
							fText.TextWrapped = true
							fText.LayoutOrder = i

							fieldLabels[f.Name] = fText
						end
					end

					local EmbedAPI = {}

					function EmbedAPI:UpdateField(name,val)
						if fieldLabels[name] then
							fieldLabels[name].Text = "<b>"..name.." :</b> "..tostring(val)
						end
					end

					function EmbedAPI:UpdateDesc(val)
						if descLabel then
							descLabel.Text = val
						end
					end

					return EmbedAPI

				end
				return Section
			end

			return Tab
		end

		return Window
	end

	-- Main Script

	if mapName == "Lobby" then
		Onion:Notify("❌ Failed Loading Script","Please Join a Map To Load Onion Hub 🔒",5)
		wait(5)
		return
	end

	Onion:KeySystem({
		CorrectKey = "Jntks"
	})

	Onion:Intro()

	-- Player
	local player = game.Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	-- window
	local Window = Onion:CreateWindow("Onion Hub 🧅")

	-- tabs
	local MainTab     = Window:CreateTab("Main")
	local TeleportTab = Window:CreateTab("Teleport")
	local FarmTab     = Window:CreateTab("Farm")
	local MiscTab     = Window:CreateTab("Misc")
	local SettingsTab = Window:CreateTab("Settings")


	-- sections
	local MainInfo = MainTab:CreateSection("Game Information")
	local Main     = MainTab:CreateSection("Main Settings")

	local TeleportTransCDID = TeleportTab:CreateSection("Safe Teleport (Trans CDID)")

	if mapName == "Jawa Tengah" then
		local JatengFarm = FarmTab:CreateSection("Auto Farm")
		-- [Farm Barista]
		JatengFarm:Toggle("Barista Farming (Low Risk, Low Reward)", function(state)
			print("Barista Farm: ",state)
		end)
		-- [Farm Truck]
		JatengFarm:Toggle("Truck Farming (High Risk, High Reward)", function(state)
			print("Truck Farm: ",state)
		end)
	end

	local Misc     = MiscTab:CreateSection("Misc")
	local DangerZone = MiscTab:CreateSection("Danger Zone")

	local Settings = SettingsTab:CreateSection("Main Settings")

	-- player stats embed
	local PlayerStats = MainInfo:Embed({
		Color = Color3.fromRGB(0,180,255),

		Fields = {
			{Name = "Current Map",     Value = mapName},
			{Name = "Game Time",       Value = "N/a (Error/Loading)"},
			{Name = "Currency",        Value = "N/a (Error/Loading)"},
			{Name = "Job",             Value = "N/a (Error/Loading)"},
			{Name = "Current Players", Value = "N/a (Error/Loading)"}
		}
	})


	-- realtime update
	task.spawn(function()
		local timeText = playerGui
			:WaitForChild("ACTUAL NEW PHONE")
			:WaitForChild("Container")
			:WaitForChild("Holder")
			:WaitForChild("Topbar")
			:WaitForChild("Time")
			.Text
		
		task.wait(2)

		PlayerStats:UpdateField("Currency", "$15,000")
		PlayerStats:UpdateField("Job", "Unemployed")
		PlayerStats:UpdateField("Game Time", timeText)
		game.Players.PlayerAdded:Connect(function()
			PlayerStats:UpdateField(
				"Current Players",
				#game.Players:GetPlayers() .. "/" .. game.Players.MaxPlayers
			)
		end)

		game.Players.PlayerRemoving:Connect(function()
			PlayerStats:UpdateField(
				"Current Players",
				#game.Players:GetPlayers()-1 .. "/" .. game.Players.MaxPlayers
			)
		end)
	end)

	Misc:Button("Claim Daily Box", function(state)
		local args = {
			"Claim"
		}
		game:GetService("ReplicatedStorage"):WaitForChild("NetworkContainer"):WaitForChild("RemoteEvents"):WaitForChild("Box"):FireServer(unpack(args))
	end)
	
local MoneyAmount = nil

local function formatRupiah(num)
	num = tonumber(num) or 0
	local formatted = tostring(num)

	while true do
		formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1.%2")
		if k == 0 then break end
	end

	return "Rp. "..formatted
end

DangerZone:TextBoxString(
	"Set Money (Server-Sided)",
	"Enter Amount..",
	function(text)
		MoneyAmount = tonumber(text)
	end
)

DangerZone:Button("Set Money", function()

	if not MoneyAmount then
		warn("Enter Amount..")
		return
	end

	print(formatRupiah(MoneyAmount))

	local player = game:GetService("Players").LocalPlayer
	local label = player
		:WaitForChild("PlayerGui")
		:WaitForChild("Main")
		:WaitForChild("Container")
		:WaitForChild("Hub")
		:WaitForChild("CashFrame")
		:WaitForChild("Frame")
		:WaitForChild("TextLabel")

	label.Text = MoneyAmount
end)
	

	-- main buttons
	Main:Button("Print Hello", function()
		print("hello alex ui udh jalan")
	end)

	local Teleports = {}

	local SelectedTransCDIDTeleport = nil

	if mapName == "Jawa Tengah" then
		Teleports = {
			["Cirebon"] = function()
				SelectedTransCDIDTeleport = "Cirebon"
			end,

			["Palimanan"] = function()
				SelectedTransCDIDTeleport = "Palimanan"
			end,

			["Pekalongan"] = function()
				SelectedTransCDIDTeleport = "Pekalongan"
			end,

			["Rest Area KM 166"] = function()
				SelectedTransCDIDTeleport = "Rest Area KM 166"
			end,

			["Rest Area KM 57"] = function()
				SelectedTransCDIDTeleport = "Rest Area KM 57"
			end,

			["Semarang"] = function()
				SelectedTransCDIDTeleport = "Semarang"
			end,

			["Tegal"] = function()
				SelectedTransCDIDTeleport = "Tegal"
			end,

		}
	end

	local teleportList = {}

	for name,_ in pairs(Teleports) do
		table.insert(teleportList,name)
	end

	TeleportTransCDID:Dropdown(
		"Location",
		teleportList,
		function(v)
			if Teleports[v] then
				Teleports[v]()
			end
		end
	)

	TeleportTransCDID:Button("Teleport", function()
		print("Teleport To: "..SelectedTransCDIDTeleport)
		
		-- Jawa Tengah
		if SelectedTransCDIDTeleport == "Cirebon" then
			local args = {"Cirebon"}
			game:GetService("ReplicatedStorage"):WaitForChild("NetworkContainer"):WaitForChild("RemoteEvents"):WaitForChild("TransEvent"):FireServer(unpack(args))
		end

		if SelectedTransCDIDTeleport == "Palimanan" then
			local args = {"Palimanan"}
			game:GetService("ReplicatedStorage"):WaitForChild("NetworkContainer"):WaitForChild("RemoteEvents"):WaitForChild("TransEvent"):FireServer(unpack(args))
		end

		if SelectedTransCDIDTeleport == "Pekalongan" then
			local args = {"Pekalongan"}
			game:GetService("ReplicatedStorage"):WaitForChild("NetworkContainer"):WaitForChild("RemoteEvents"):WaitForChild("TransEvent"):FireServer(unpack(args))
		end

		if SelectedTransCDIDTeleport == "Rest Area KM 166" then
			local args = {"Rest Area KM 166"}
			game:GetService("ReplicatedStorage"):WaitForChild("NetworkContainer"):WaitForChild("RemoteEvents"):WaitForChild("TransEvent"):FireServer(unpack(args))
		end

		if SelectedTransCDIDTeleport == "Rest Area KM 57" then
			local args = {"Rest Area KM 57"}
			game:GetService("ReplicatedStorage"):WaitForChild("NetworkContainer"):WaitForChild("RemoteEvents"):WaitForChild("TransEvent"):FireServer(unpack(args))
		end

		if SelectedTransCDIDTeleport == "Semarang" then
			local args = {"Semarang"}
			game:GetService("ReplicatedStorage"):WaitForChild("NetworkContainer"):WaitForChild("RemoteEvents"):WaitForChild("TransEvent"):FireServer(unpack(args))
		end

		if SelectedTransCDIDTeleport == "Tegal" then
			local args = {"Tegal"}
			game:GetService("ReplicatedStorage"):WaitForChild("NetworkContainer"):WaitForChild("RemoteEvents"):WaitForChild("TransEvent"):FireServer(unpack(args))
		end
	end)

	-- settings
	Settings:Dropdown(
		"Map",
		{"Jakarta","Jawa Tengah","Bali"},
		function(v)
			print(v)
		end
	)


	-- notify
	Onion:Notify("Loaded","🧅 Onion Hub Loaded",8)

	-- return Onion
