
-- Extra Modules: Slider, Dropdown, MultiDropdown, Card
-- These would typically be required from separate ModuleScripts.
-- Here we define them inline to keep the library single-file.

local function registerModules(api, settingsTable, saveSettings, colors, roundify, strokify)
    -- Slider
    function api:Slider(parent, text, min, max, default, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 40)
        Frame.BackgroundTransparency = 1
        Frame.Parent = parent

        local Label = Instance.new("TextLabel")
        Label.Text = text .. ": " .. tostring(default)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextColor3 = colors.Text
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local SliderBack = Instance.new("Frame")
        SliderBack.Size = UDim2.new(1, -10, 0, 8)
        SliderBack.Position = UDim2.new(0, 5, 0, 25)
        SliderBack.BackgroundColor3 = colors.Slider
        SliderBack.Parent = Frame
        roundify(SliderBack, 4)

        local SliderFill = Instance.new("Frame")
        SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = colors.Accent
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBack
        roundify(SliderFill, 4)

        local dragging = false
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            local value = math.floor((min + (max - min) * pos) + 0.5)
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            Label.Text = text .. ": " .. tostring(value)
            settingsTable[text] = value
            saveSettings()
            if callback then callback(value) end
        end

        SliderBack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)

        SliderBack.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)

        if settingsTable[text] ~= nil then
            default = settingsTable[text]
            local pos = (default - min) / (max - min)
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            Label.Text = text .. ": " .. tostring(default)
            if callback then callback(default) end
        end
    end
end

return registerModules

local function registerDropdowns(api, settingsTable, saveSettings, colors, roundify, strokify)
    -- Dropdown
    function api:Dropdown(parent, text, options, default, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 40)
        Frame.BackgroundTransparency = 1
        Frame.Parent = parent

        local Label = Instance.new("TextLabel")
        Label.Text = text .. ": " .. tostring(default or options[1])
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextColor3 = colors.Text
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local DropButton = Instance.new("TextButton")
        DropButton.Size = UDim2.new(1, -10, 0, 20)
        DropButton.Position = UDim2.new(0, 5, 0, 20)
        DropButton.BackgroundColor3 = colors.Dropdown
        DropButton.Text = default or options[1]
        DropButton.Font = Enum.Font.Gotham
        DropButton.TextSize = 14
        DropButton.TextColor3 = colors.Text
        DropButton.Parent = Frame
        roundify(DropButton, 4)
        strokify(DropButton)

        local function selectOption(value)
            DropButton.Text = value
            Label.Text = text .. ": " .. value
            settingsTable[text] = value
            saveSettings()
            if callback then callback(value) end
        end

        DropButton.MouseButton1Click:Connect(function()
            for _, option in ipairs(options) do
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, -10, 0, 20)
                Button.Position = UDim2.new(0, 5, 0, 40)
                Button.BackgroundColor3 = colors.Panel
                Button.Text = option
                Button.Font = Enum.Font.Gotham
                Button.TextSize = 14
                Button.TextColor3 = colors.Text
                Button.Parent = Frame
                roundify(Button, 4)
                strokify(Button)

                Button.MouseButton1Click:Connect(function()
                    selectOption(option)
                    for _, child in ipairs(Frame:GetChildren()) do
                        if child:IsA("TextButton") and child ~= DropButton then
                            child:Destroy()
                        end
                    end
                end)
            end
        end)

        if settingsTable[text] then
            selectOption(settingsTable[text])
        end
    end

    -- MultiDropdown
    function api:MultiDropdown(parent, text, options, default, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 60)
        Frame.BackgroundTransparency = 1
        Frame.Parent = parent

        local Label = Instance.new("TextLabel")
        Label.Text = text
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextColor3 = colors.Text
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Selected = {}
        if type(default) == "table" then
            for _, val in ipairs(default) do
                Selected[val] = true
            end
        end

        local function updateLabel()
            local selectedList = {}
            for val, state in pairs(Selected) do
                if state then table.insert(selectedList, val) end
            end
            Label.Text = text .. ": " .. table.concat(selectedList, ", ")
            settingsTable[text] = selectedList
            saveSettings()
            if callback then callback(selectedList) end
        end

        for i, option in ipairs(options) do
            local Toggle = Instance.new("TextButton")
            Toggle.Size = UDim2.new(1, -10, 0, 20)
            Toggle.Position = UDim2.new(0, 5, 0, 20 + (i-1) * 22)
            Toggle.BackgroundColor3 = Selected[option] and colors.ToggleOn or colors.ToggleOff
            Toggle.Text = option
            Toggle.Font = Enum.Font.Gotham
            Toggle.TextSize = 14
            Toggle.TextColor3 = colors.Text
            Toggle.Parent = Frame
            roundify(Toggle, 4)
            strokify(Toggle)

            Toggle.MouseButton1Click:Connect(function()
                Selected[option] = not Selected[option]
                Toggle.BackgroundColor3 = Selected[option] and colors.ToggleOn or colors.ToggleOff
                updateLabel()
            end)
        end

        if settingsTable[text] then
            for _, val in ipairs(settingsTable[text]) do
                Selected[val] = true
            end
            updateLabel()
        end
    end
end

return registerDropdowns
