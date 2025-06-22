--[[
bronx.lol-style UI Library for Roblox (Single Loadstring Version)
Author: ChatGPT (2025)
--]]

--===[ CORE LIBRARY ]===

--[[
bronx.lol-style UI Library for Roblox
Author: ChatGPT (2025)
--]]

local Library = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Color palette
local colors = {
    Background = Color3.fromRGB(25, 25, 25),
    Panel = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 162, 255),
    ToggleOn = Color3.fromRGB(0, 200, 0),
    ToggleOff = Color3.fromRGB(50, 50, 50),
    Text = Color3.fromRGB(230, 230, 230),
    Stroke = Color3.fromRGB(50, 50, 50),
    Bar = Color3.fromRGB(30, 30, 30),
    Button = Color3.fromRGB(45, 45, 45),
    Dropdown = Color3.fromRGB(40, 40, 40),
    Slider = Color3.fromRGB(60, 60, 60),
    Card = Color3.fromRGB(40, 40, 40)
}

local SETTINGS_FILE = "Library_Settings.json"

-- Utility functions
local function roundify(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = instance
end

local function strokify(instance, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or colors.Stroke
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
end

-- Dragging function
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Settings saving/loading
local settingsTable = {}
local function saveSettings()
    writefile(SETTINGS_FILE, HttpService:JSONEncode(settingsTable))
end

local function loadSettings()
    if isfile(SETTINGS_FILE) then
        local data = readfile(SETTINGS_FILE)
        settingsTable = HttpService:JSONDecode(data)
    end
end
loadSettings()

-- To be continued in next cell due to size limit...


-- Library constructor (continued)
function Library:Window(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LibraryLibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    MainFrame.BackgroundColor3 = colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    roundify(MainFrame, 10)
    strokify(MainFrame)
    makeDraggable(MainFrame)

    local Header = Instance.new("TextLabel")
    Header.Text = title or "bronx.lol"
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 20
    Header.TextColor3 = colors.Accent
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.TextXAlignment = Enum.TextXAlignment.Center
    Header.Parent = MainFrame

    local Bar = Instance.new("TextLabel")
    Bar.Text = "bronx.lol : booga booga reborn | lifetime"
    Bar.Font = Enum.Font.Gotham
    Bar.TextSize = 12
    Bar.TextColor3 = colors.Text
    Bar.BackgroundColor3 = colors.Bar
    Bar.BorderSizePixel = 0
    Bar.Size = UDim2.new(1, 0, 0, 20)
    Bar.Position = UDim2.new(0, 0, 1, -20)
    Bar.Parent = MainFrame
    roundify(Bar, 0)

    local PageContainer = Instance.new("Folder")
    PageContainer.Name = "Pages"
    PageContainer.Parent = MainFrame

    local API = {}

    function API:Page(name)
        local Page = Instance.new("Frame")
        Page.Name = name
        Page.Size = UDim2.new(1, -20, 1, -80)
        Page.Position = UDim2.new(0, 10, 0, 50)
        Page.BackgroundTransparency = 1
        Page.Visible = true
        Page.Parent = PageContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page

        local PageAPI = {}

        function PageAPI:Section(title)
            local Section = Instance.new("Frame")
            Section.Size = UDim2.new(1, 0, 0, 200)
            Section.BackgroundColor3 = colors.Panel
            Section.BorderSizePixel = 0
            roundify(Section)
            strokify(Section)
            Section.Parent = Page

            local Label = Instance.new("TextLabel")
            Label.Text = title
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 14
            Label.TextColor3 = colors.Text
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, -10, 0, 20)
            Label.Position = UDim2.new(0, 5, 0, 5)
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Section

            local Content = Instance.new("Frame")
            Content.Size = UDim2.new(1, -10, 1, -30)
            Content.Position = UDim2.new(0, 5, 0, 25)
            Content.BackgroundTransparency = 1
            Content.Parent = Section

            local Layout = Instance.new("UIListLayout")
            Layout.Padding = UDim.new(0, 6)
            Layout.SortOrder = Enum.SortOrder.LayoutOrder
            Layout.Parent = Content

            local SectionAPI = {}

            function SectionAPI:Toggle(text, default, callback)
                local Toggle = Instance.new("Frame")
                Toggle.Size = UDim2.new(1, 0, 0, 30)
                Toggle.BackgroundTransparency = 1
                Toggle.Parent = Content

                local Label = Instance.new("TextLabel")
                Label.Text = text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 14
                Label.TextColor3 = colors.Text
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(0.7, 0, 1, 0)
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Toggle

                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(0, 30, 0, 20)
                Button.Position = UDim2.new(1, -35, 0.5, -10)
                Button.BackgroundColor3 = default and colors.ToggleOn or colors.ToggleOff
                Button.Text = ""
                Button.AutoButtonColor = false
                Button.Parent = Toggle
                roundify(Button, 10)

                Button.MouseButton1Click:Connect(function()
                    default = not default
                    Button.BackgroundColor3 = default and colors.ToggleOn or colors.ToggleOff
                    settingsTable[text] = default
                    saveSettings()
                    if callback then callback(default) end
                end)

                if settingsTable[text] ~= nil then
                    default = settingsTable[text]
                    Button.BackgroundColor3 = default and colors.ToggleOn or colors.ToggleOff
                    if callback then callback(default) end
                end
            end

            function SectionAPI:Button(text, callback)
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 0, 30)
                Button.BackgroundColor3 = colors.Button
                Button.Text = text
                Button.Font = Enum.Font.Gotham
                Button.TextColor3 = colors.Text
                Button.TextSize = 14
                Button.AutoButtonColor = true
                Button.Parent = Content
                roundify(Button)
                strokify(Button)

                Button.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
            end

            return SectionAPI
        end

        return PageAPI
    end

    
    -- Inject Slider
    local function registerSlider(api, settingsTable, saveSettings, colors, roundify, strokify, UIS)
        -- SLIDER MODULE HERE
function registerModules(api, settingsTable, saveSettings, colors, roundify, strokify)
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
    end

    -- Inject Dropdowns
    local function registerDropdown(api, settingsTable, saveSettings, colors, roundify, strokify)
        -- DROPDOWN MODULE HERE
function registerDropdowns(api, settingsTable, saveSettings, colors, roundify, strokify)
    -- Dropdown
    end

    local function registerMultiDropdown(api, settingsTable, saveSettings, colors, roundify, strokify)
        -- MULTIDROPDOWN MODULE HERE
MULTIfunction registerDropdowns(api, settingsTable, saveSettings, colors, roundify, strokify)
    -- Dropdown
    end

    -- Inject Card
    local function registerCard(api, settingsTable, saveSettings, colors, roundify, strokify)
        -- CARD MODULE HERE
function registerCard(api, settingsTable, saveSettings, colors, roundify, strokify)
    function api:Card(parent, title, description)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 60)
        Frame.BackgroundColor3 = colors.Card
        Frame.BorderSizePixel = 0
        Frame.Parent = parent
        roundify(Frame, 6)
        strokify(Frame)

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Text = title
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextSize = 14
        TitleLabel.TextColor3 = colors.Text
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Size = UDim2.new(1, -10, 0, 20)
        TitleLabel.Position = UDim2.new(0, 5, 0, 5)
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = Frame

        local DescLabel = Instance.new("TextLabel")
        DescLabel.Text = description
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.TextSize = 12
        DescLabel.TextColor3 = colors.Text
        DescLabel.BackgroundTransparency = 1
        DescLabel.Size = UDim2.new(1, -10, 0, 30)
        DescLabel.Position = UDim2.new(0, 5, 0, 25)
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.TextYAlignment = Enum.TextYAlignment.Top
        DescLabel.TextWrapped = true
        DescLabel.Parent = Frame
    end
end

return registerCard
    end

    -- Register all inline
    registerSlider(API, settingsTable, saveSettings, colors, roundify, strokify, UIS)
    registerDropdown(API, settingsTable, saveSettings, colors, roundify, strokify)
    registerMultiDropdown(API, settingsTable, saveSettings, colors, roundify, strokify)
    registerCard(API, settingsTable, saveSettings, colors, roundify, strokify)

    return API
end

return Library


--===[ EXTENSIONS: SLIDER ]===

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




--===[ EXTENSIONS: DROPDOWN & MULTIDROPDOWN ]===

-- Extra Modules: Dropdown and MultiDropdown

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




--===[ EXTENSIONS: CARD ]===

-- Extra Module: Card

local function registerCard(api, settingsTable, saveSettings, colors, roundify, strokify)
    function api:Card(parent, title, description)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 60)
        Frame.BackgroundColor3 = colors.Card
        Frame.BorderSizePixel = 0
        Frame.Parent = parent
        roundify(Frame, 6)
        strokify(Frame)

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Text = title
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextSize = 14
        TitleLabel.TextColor3 = colors.Text
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Size = UDim2.new(1, -10, 0, 20)
        TitleLabel.Position = UDim2.new(0, 5, 0, 5)
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = Frame

        local DescLabel = Instance.new("TextLabel")
        DescLabel.Text = description
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.TextSize = 12
        DescLabel.TextColor3 = colors.Text
        DescLabel.BackgroundTransparency = 1
        DescLabel.Size = UDim2.new(1, -10, 0, 30)
        DescLabel.Position = UDim2.new(0, 5, 0, 25)
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.TextYAlignment = Enum.TextYAlignment.Top
        DescLabel.TextWrapped = true
        DescLabel.Parent = Frame
    end
end

return Library
