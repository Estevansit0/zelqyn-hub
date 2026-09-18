--[[
    Zelqyn Hub UI Library
    Visual style based on the supplied reference image.

    The library only builds and manages the interface. Game actions are supplied
    by the caller through callbacks.
]]

local getService = setmetatable({}, {
    __index = function(self, serviceName)
        local service = cloneref(game:GetService(serviceName))
        rawset(self, serviceName, service)
        return service
    end,
})

local Players = getService.Players
local TweenService = getService.TweenService
local UserInputService = getService.UserInputService
local RunService = getService.RunService
local Stats = getService.Stats

local ZelqynHub = {
    Name = "Zelqyn Hub",
    Version = "1.0.0",
}

local Window = {}
Window.__index = Window

local Panel = {}
Panel.__index = Panel

local Page = {}
Page.__index = Page

local DEFAULT_THEME = {
    Background = Color3.fromRGB(4, 15, 28),
    Panel = Color3.fromRGB(6, 22, 39),
    Card = Color3.fromRGB(21, 51, 82),
    CardHover = Color3.fromRGB(27, 69, 108),
    Input = Color3.fromRGB(8, 29, 52),
    Muted = Color3.fromRGB(132, 164, 202),
    Text = Color3.fromRGB(237, 247, 255),
    Cyan = Color3.fromRGB(0, 215, 247),
    Blue = Color3.fromRGB(42, 137, 225),
    Indigo = Color3.fromRGB(91, 87, 255),
    Purple = Color3.fromRGB(132, 31, 238),
    Pink = Color3.fromRGB(236, 11, 220),
    Green = Color3.fromRGB(47, 209, 119),
    Red = Color3.fromRGB(255, 91, 112),
    Radius = 12,
    FastTween = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    MediumTween = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
}

local function shallowCopy(source)
    local result = {}
    for key, value in pairs(source) do
        result[key] = value
    end
    return result
end

local function create(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do
        object[property] = value
    end
    object.Parent = parent
    return object
end

local function addCorner(parent, radius)
    return create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
    }, parent)
end

local function addPadding(parent, left, right, top, bottom)
    return create("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or left or 0),
        PaddingTop = UDim.new(0, top or left or 0),
        PaddingBottom = UDim.new(0, bottom or top or left or 0),
    }, parent)
end

local function addGradient(parent, colors, rotation, transparency)
    local keypoints = {}
    local total = #colors
    for index, color in ipairs(colors) do
        local time = total == 1 and 0 or (index - 1) / (total - 1)
        table.insert(keypoints, ColorSequenceKeypoint.new(time, color))
    end

    return create("UIGradient", {
        Color = ColorSequence.new(keypoints),
        Rotation = rotation or 0,
        Transparency = transparency or NumberSequence.new(0),
    }, parent)
end

local function addAccentStroke(parent, theme, thickness, transparency)
    local outline = create("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = theme.Cyan,
        Thickness = thickness or 1,
        Transparency = transparency or 0.22,
    }, parent)

    addGradient(outline, {
        theme.Cyan,
        theme.Indigo,
        theme.Pink,
        theme.Purple,
    }, 18)

    return outline
end

local function addList(parent, padding)
    return create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, padding or 6),
    }, parent)
end

local function bind(window, signal, callback)
    local connection = signal:Connect(callback)
    table.insert(window.Connections, connection)
    return connection
end

local function tween(window, object, goal, info)
    if not object or not object.Parent then
        return
    end

    local animation = TweenService:Create(
        object,
        info or window.Theme.FastTween,
        goal
    )
    animation:Play()
    return animation
end

local function safeCall(callback, ...)
    if type(callback) ~= "function" then
        return
    end

    local success, message = pcall(callback, ...)
    if not success then
        warn("[Zelqyn Hub] Callback error: " .. tostring(message))
    end
end

local function setTextGradient(label, theme)
    return addGradient(label, {
        theme.Cyan,
        theme.Indigo,
        theme.Pink,
    }, 8)
end

local function makeLogo(window, parent, size, position, zIndex)
    local logoImage = window.Options.LogoImage
    local holder = create("Frame", {
        BackgroundColor3 = window.Theme.Input,
        BorderSizePixel = 0,
        Position = position or UDim2.fromOffset(10, 8),
        Size = UDim2.fromOffset(size or 30, size or 30),
        ZIndex = zIndex or 4,
    }, parent)
    addCorner(holder, math.floor((size or 30) / 2))
    addAccentStroke(holder, window.Theme, 1.25, 0.05)

    if type(logoImage) == "string" and logoImage ~= "" then
        create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = logoImage,
            Name = "DynamicLogoImage",
            Position = UDim2.fromScale(0.12, 0.12),
            Size = UDim2.fromScale(0.76, 0.76),
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = (zIndex or 4) + 1,
        }, holder)
    else
        local fallback = create("TextLabel", {
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.04, -0.02),
            Size = UDim2.fromScale(0.92, 1),
            Text = "Z",
            TextColor3 = Color3.new(1, 1, 1),
            TextScaled = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = (zIndex or 4) + 1,
        }, holder)
        setTextGradient(fallback, window.Theme)
    end

    return holder
end

local function makeDraggable(window, handle, target)
    local dragging = false
    local dragInput
    local dragOrigin
    local startPosition

    bind(window, handle.InputBegan, function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end

        dragging = true
        dragOrigin = input.Position
        startPosition = target.Position

        local ended
        ended = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if ended then
                    ended:Disconnect()
                end
            end
        end)
    end)

    bind(window, handle.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragInput = input
        end
    end)

    bind(window, UserInputService.InputChanged, function(input)
        if not dragging or input ~= dragInput then
            return
        end

        local delta = input.Position - dragOrigin
        target.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)
end

local function makeRipple(window, button, radius)
    bind(window, button.Activated, function()
        local flash = create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = window.Theme.Cyan,
            BackgroundTransparency = 0.72,
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0, 0),
            ZIndex = button.ZIndex + 3,
        }, button)
        addCorner(flash, radius or 8)

        local animation = tween(window, flash, {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1.25, 1.8),
        }, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))

        if animation then
            animation.Completed:Connect(function()
                if flash.Parent then
                    flash:Destroy()
                end
            end)
        end
    end)
end

local function makeSmallButton(window, parent, options)
    local button = create("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = options.Color or window.Theme.Blue,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Position = options.Position,
        Size = options.Size,
        Text = options.Text or "BUTTON",
        TextColor3 = options.TextColor or window.Theme.Text,
        TextSize = options.TextSize or 11,
        ZIndex = options.ZIndex or 5,
    }, parent)
    addCorner(button, options.Radius or 7)
    makeRipple(window, button, options.Radius or 7)

    bind(window, button.MouseEnter, function()
        tween(window, button, { BackgroundColor3 = options.HoverColor or window.Theme.Indigo })
    end)
    bind(window, button.MouseLeave, function()
        tween(window, button, { BackgroundColor3 = options.Color or window.Theme.Blue })
    end)

    return button
end

function ZelqynHub:CreateWindow(options)
    options = options or {}

    local theme = shallowCopy(DEFAULT_THEME)
    for key, value in pairs(options.Theme or {}) do
        theme[key] = value
    end

    local parent = gethui()
    local guiName = options.GuiName or "ZelqynHub"
    local previous = parent:FindFirstChild(guiName)
    if previous then
        previous:Destroy()
    end

    local self = setmetatable({
        Options = options,
        Theme = theme,
        Connections = {},
        Panels = {},
        Widgets = {},
        Visible = true,
    }, Window)

    self.ScreenGui = create("ScreenGui", {
        DisplayOrder = options.DisplayOrder or 90,
        IgnoreGuiInset = true,
        Name = guiName,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, parent)

    self.Root = create("Frame", {
        BackgroundTransparency = 1,
        Name = "Root",
        Size = UDim2.fromScale(1, 1),
    }, self.ScreenGui)

    bind(self, UserInputService.InputBegan, function(input, gameProcessed)
        if gameProcessed then
            return
        end

        if input.KeyCode == (options.ToggleKey or Enum.KeyCode.RightControl) then
            self:SetVisible(not self.Visible)
        end
    end)

    return self
end

function Window:SetVisible(state)
    self.Visible = state == true
    self.Root.Visible = self.Visible
end

function Window:Toggle()
    self:SetVisible(not self.Visible)
end

function Window:Destroy()
    for _, connection in ipairs(self.Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(self.Connections)

    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

function Window:SetLogo(image)
    self.Options.LogoImage = image
    for _, logo in ipairs(self.Root:GetDescendants()) do
        if logo.Name == "DynamicLogoImage" and logo:IsA("ImageLabel") then
            logo.Image = image
        end
    end
end

function Window:CreatePanel(options)
    options = options or {}

    local panelFrame = create("Frame", {
        AnchorPoint = options.AnchorPoint or Vector2.new(0, 0),
        BackgroundColor3 = self.Theme.Panel,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Name = options.Name or "Panel",
        Position = options.Position or UDim2.fromOffset(20, 110),
        Size = options.Size or UDim2.fromOffset(320, 410),
    }, self.Root)
    addCorner(panelFrame, options.Radius or self.Theme.Radius)
    addAccentStroke(panelFrame, self.Theme, 1.2, 0.18)

    local header = create("Frame", {
        Active = true,
        BackgroundTransparency = 1,
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 52),
        ZIndex = 2,
    }, panelFrame)

    if options.ShowLogo then
        makeLogo(self, header, 30, UDim2.fromOffset(10, 10), 4)
    end

    local title = create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(options.ShowLogo and 50 or 16, 9),
        Size = UDim2.new(1, options.ShowLogo and -66 or -32, 0, 25),
        Text = string.upper(options.Title or "ZELQYN HUB"),
        TextColor3 = self.Theme.Text,
        TextSize = options.TitleSize or 20,
        TextXAlignment = options.TitleAlignment or Enum.TextXAlignment.Center,
        ZIndex = 3,
    }, header)

    local underline = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = self.Theme.Cyan,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0, 42),
        Size = UDim2.fromOffset(options.UnderlineWidth or 118, 2),
        ZIndex = 3,
    }, header)
    addCorner(underline, 2)
    addGradient(underline, {
        self.Theme.Cyan,
        self.Theme.Indigo,
        self.Theme.Pink,
    }, 0)

    local body = create("Frame", {
        BackgroundTransparency = 1,
        Name = "Body",
        Position = UDim2.fromOffset(8, 54),
        Size = UDim2.new(1, -16, 1, -62),
    }, panelFrame)

    local panel = setmetatable({
        Window = self,
        Frame = panelFrame,
        Header = header,
        Title = title,
        Body = body,
        Tabs = {},
        ActiveTab = nil,
    }, Panel)

    if options.Draggable ~= false then
        makeDraggable(self, header, panelFrame)
    end

    table.insert(self.Panels, panel)
    return panel
end

function Panel:SetTitle(text)
    self.Title.Text = string.upper(tostring(text or ""))
end

function Panel:SetVisible(state)
    self.Frame.Visible = state == true
end

function Panel:Destroy()
    self.Frame:Destroy()
end

function Panel:_ensureTabBar()
    if self.TabBar then
        return
    end

    self.Header.Size = UDim2.new(1, 0, 0, 82)
    self.Body.Position = UDim2.fromOffset(8, 84)
    self.Body.Size = UDim2.new(1, -16, 1, -92)

    self.TabBar = create("Frame", {
        BackgroundTransparency = 1,
        Name = "TabBar",
        Position = UDim2.fromOffset(8, 50),
        Size = UDim2.new(1, -16, 0, 30),
        ZIndex = 4,
    }, self.Frame)

    self.TabLayout = create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, self.TabBar)
end

function Panel:_refreshTabWidths()
    local count = math.max(#self.Tabs, 1)
    local gaps = (count - 1) * 6
    for _, tab in ipairs(self.Tabs) do
        tab.Button.Size = UDim2.new(1 / count, -gaps / count, 1, 0)
    end
end

function Panel:SelectTab(tabToSelect)
    if type(tabToSelect) == "string" then
        for _, tab in ipairs(self.Tabs) do
            if tab.Name == tabToSelect then
                tabToSelect = tab
                break
            end
        end
    end

    if type(tabToSelect) ~= "table" or not tabToSelect.Frame then
        return
    end

    self.ActiveTab = tabToSelect
    for _, tab in ipairs(self.Tabs) do
        local selected = tab == tabToSelect
        tab.Frame.Visible = selected
        tween(self.Window, tab.Button, {
            BackgroundColor3 = selected and self.Window.Theme.Blue or self.Window.Theme.Card,
            TextColor3 = selected and self.Window.Theme.Text or self.Window.Theme.Muted,
        })
    end
end

function Panel:AddTab(name)
    self:_ensureTabBar()

    local button = create("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = self.Window.Theme.Card,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamSemibold,
        LayoutOrder = #self.Tabs + 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = tostring(name or "Tab"),
        TextColor3 = self.Window.Theme.Muted,
        TextSize = 11,
        ZIndex = 5,
    }, self.TabBar)
    addCorner(button, 6)

    local frame = create("ScrollingFrame", {
        Active = true,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(),
        Name = tostring(name or "Tab") .. "Page",
        ScrollBarImageColor3 = self.Window.Theme.Cyan,
        ScrollBarThickness = 2,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
    }, self.Body)
    addPadding(frame, 0, 4, 0, 2)
    addList(frame, 5)

    local page = setmetatable({
        Name = tostring(name or "Tab"),
        Window = self.Window,
        Panel = self,
        Button = button,
        Frame = frame,
        ControlCount = 0,
    }, Page)

    table.insert(self.Tabs, page)
    self:_refreshTabWidths()

    bind(self.Window, button.Activated, function()
        self:SelectTab(page)
    end)

    if #self.Tabs == 1 then
        self:SelectTab(page)
    end

    return page
end

function Page:_makeRow(height)
    self.ControlCount = self.ControlCount + 1

    local row = create("Frame", {
        BackgroundColor3 = self.Window.Theme.Card,
        BorderSizePixel = 0,
        LayoutOrder = self.ControlCount,
        Size = UDim2.new(1, 0, 0, height or 38),
    }, self.Frame)
    addCorner(row, 8)
    addAccentStroke(row, self.Window.Theme, 0.8, 0.48)
    return row
end

function Page:AddLabel(options)
    if type(options) == "string" then
        options = { Text = options }
    end
    options = options or {}

    local row = self:_makeRow(options.Height or 34)
    row.BackgroundTransparency = options.Transparent and 1 or 0

    local label = create("TextLabel", {
        BackgroundTransparency = 1,
        Font = options.Bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        Position = UDim2.fromOffset(12, 0),
        RichText = options.RichText == true,
        Size = UDim2.new(1, -24, 1, 0),
        Text = tostring(options.Text or "Label"),
        TextColor3 = options.Color or self.Window.Theme.Text,
        TextSize = options.TextSize or 11,
        TextWrapped = true,
        TextXAlignment = options.Alignment or Enum.TextXAlignment.Left,
    }, row)

    return {
        Frame = row,
        Label = label,
        Set = function(_, text)
            label.Text = tostring(text or "")
        end,
    }
end

function Page:AddButton(options)
    if type(options) == "string" then
        options = { Name = options }
    end
    options = options or {}

    local row = self:_makeRow(options.Height or 38)
    local label = create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -105, 1, 0),
        Text = tostring(options.Name or "Button"),
        TextColor3 = self.Window.Theme.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local button = makeSmallButton(self.Window, row, {
        Color = options.Color or self.Window.Theme.Blue,
        HoverColor = options.HoverColor or self.Window.Theme.Indigo,
        Position = UDim2.new(1, -84, 0.5, -14),
        Size = UDim2.fromOffset(74, 28),
        Text = string.upper(options.ButtonText or options.Text or "RUN"),
        TextSize = 9,
        ZIndex = 4,
    })

    bind(self.Window, button.Activated, function()
        safeCall(options.Callback)
    end)

    return {
        Frame = row,
        Button = button,
        Label = label,
        Fire = function()
            safeCall(options.Callback)
        end,
    }
end

function Page:AddToggle(options)
    options = options or {}

    local row = self:_makeRow(options.Height or 38)
    local label = create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -105, 1, 0),
        Text = tostring(options.Name or "Toggle"),
        TextColor3 = self.Window.Theme.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local switch = create("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = self.Window.Theme.Card,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Position = UDim2.new(1, -84, 0.5, -14),
        Size = UDim2.fromOffset(74, 28),
        Text = "OFF",
        TextColor3 = self.Window.Theme.Muted,
        TextSize = 9,
        ZIndex = 4,
    }, row)
    addCorner(switch, 7)
    addAccentStroke(switch, self.Window.Theme, 0.8, 0.25)

    local state = false
    local control = {
        Frame = row,
        Button = switch,
        Label = label,
    }

    function control:Set(value, silent)
        state = value == true
        switch.Text = state and "ON" or "OFF"
        tween(self.Window or control.Window, switch, {
            BackgroundColor3 = state and self.Theme.Blue or self.Theme.Card,
            TextColor3 = state and self.Theme.Text or self.Theme.Muted,
        })
        if not silent then
            safeCall(options.Callback, state)
        end
    end

    control.Window = self.Window
    control.Theme = self.Window.Theme

    function control:Get()
        return state
    end

    bind(self.Window, switch.Activated, function()
        control:Set(not state)
    end)

    control:Set(options.Default == true, true)
    return control
end

function Page:AddInput(options)
    options = options or {}
    local row = self:_makeRow(options.Height or 44)

    create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(0.38, -12, 1, 0),
        Text = tostring(options.Name or "Input"),
        TextColor3 = self.Window.Theme.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local box = create("TextBox", {
        BackgroundColor3 = self.Window.Theme.Input,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Font = Enum.Font.Gotham,
        PlaceholderColor3 = self.Window.Theme.Muted,
        PlaceholderText = options.Placeholder or "Type here...",
        Position = UDim2.new(0.38, 0, 0.5, -14),
        Size = UDim2.new(0.62, -10, 0, 28),
        Text = tostring(options.Default or ""),
        TextColor3 = self.Window.Theme.Text,
        TextSize = 10,
    }, row)
    addCorner(box, 7)
    addAccentStroke(box, self.Window.Theme, 0.8, 0.45)

    bind(self.Window, box.FocusLost, function(enterPressed)
        safeCall(options.Callback, box.Text, enterPressed)
    end)

    return {
        Frame = row,
        Input = box,
        Get = function()
            return box.Text
        end,
        Set = function(_, value)
            box.Text = tostring(value or "")
        end,
    }
end

function Page:AddDivider(text)
    self.ControlCount = self.ControlCount + 1
    local holder = create("Frame", {
        BackgroundTransparency = 1,
        LayoutOrder = self.ControlCount,
        Size = UDim2.new(1, 0, 0, text and 24 or 12),
    }, self.Frame)

    local line = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Window.Theme.Cyan,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -12, 0, 1),
    }, holder)
    addGradient(line, {
        self.Window.Theme.Cyan,
        self.Window.Theme.Indigo,
        self.Window.Theme.Pink,
    }, 0)

    if text then
        create("TextLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = self.Window.Theme.Panel,
            BackgroundTransparency = 0,
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(math.max(#tostring(text) * 7 + 20, 70), 20),
            Text = string.upper(tostring(text)),
            TextColor3 = self.Window.Theme.Muted,
            TextSize = 9,
        }, holder)
    end

    return holder
end

function Window:CreateServerCard(options)
    options = options or {}

    local frame = create("Frame", {
        AnchorPoint = options.AnchorPoint or Vector2.new(0.5, 0),
        BackgroundColor3 = self.Theme.Panel,
        BorderSizePixel = 0,
        Position = options.Position or UDim2.new(0.5, 0, 0, 2),
        Size = options.Size or UDim2.fromOffset(302, 132),
    }, self.Root)
    addCorner(frame, 12)
    addAccentStroke(frame, self.Theme, 1.2, 0.15)

    local title = create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(12, 5),
        Size = UDim2.new(1, -24, 0, 18),
        Text = string.upper(options.Title or "SERVER JOB ID"),
        TextColor3 = self.Theme.Text,
        TextSize = 14,
    }, frame)

    local line = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = self.Theme.Cyan,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0, 27),
        Size = UDim2.fromOffset(72, 2),
    }, frame)
    addGradient(line, { self.Theme.Cyan, self.Theme.Indigo, self.Theme.Pink }, 0)

    local fieldHolder = create("Frame", {
        BackgroundColor3 = self.Theme.Input,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(12, 34),
        Size = UDim2.new(1, -24, 0, 56),
    }, frame)
    addCorner(fieldHolder, 9)
    addAccentStroke(fieldHolder, self.Theme, 0.9, 0.3)

    local input = create("TextBox", {
        BackgroundColor3 = Color3.fromRGB(7, 25, 47),
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Font = Enum.Font.Code,
        PlaceholderColor3 = self.Theme.Muted,
        PlaceholderText = options.Placeholder or "Paste a server job id...",
        Position = UDim2.fromOffset(6, 5),
        Size = UDim2.new(1, -12, 0, 23),
        Text = tostring(options.Value or ""),
        TextColor3 = self.Theme.Text,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, fieldHolder)
    addCorner(input, 6)

    local copyButton = makeSmallButton(self, fieldHolder, {
        Color = Color3.fromRGB(33, 98, 191),
        Position = UDim2.fromOffset(6, 33),
        Size = UDim2.new(0.5, -9, 0, 18),
        Text = "COPY",
        TextSize = 9,
        Radius = 5,
    })

    local hidden = false
    local hideButton = makeSmallButton(self, fieldHolder, {
        Color = self.Theme.Green,
        Position = UDim2.new(0.5, 3, 0, 33),
        Size = UDim2.new(0.5, -9, 0, 18),
        Text = "HIDE",
        TextSize = 9,
        Radius = 5,
    })

    local namesPill = create("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = self.Theme.Card,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(12, 99),
        Size = UDim2.new(0.5, -17, 0, 18),
        Text = "●   HIDE NAMES OFF",
        TextColor3 = self.Theme.Text,
        TextSize = 8,
    }, frame)
    addCorner(namesPill, 9)

    local numbersPill = create("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = self.Theme.Card,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Position = UDim2.new(0.5, 5, 0, 99),
        Size = UDim2.new(0.5, -17, 0, 18),
        Text = "●   SHOW # OFF",
        TextColor3 = self.Theme.Text,
        TextSize = 8,
    }, frame)
    addCorner(numbersPill, 9)

    local hideNames = false
    local showNumbers = false

    bind(self, copyButton.Activated, function()
        if setclipboard then
            setclipboard(input.Text)
        end
        safeCall(options.OnCopy, input.Text)
    end)

    bind(self, hideButton.Activated, function()
        hidden = not hidden
        input.TextTransparency = hidden and 1 or 0
        input.PlaceholderText = hidden and "••••••••••••••••••••••••" or (options.Placeholder or "Paste a server job id...")
        hideButton.Text = hidden and "SHOW" or "HIDE"
    end)

    bind(self, namesPill.Activated, function()
        hideNames = not hideNames
        namesPill.Text = hideNames and "●   HIDE NAMES ON" or "●   HIDE NAMES OFF"
        namesPill.TextColor3 = hideNames and self.Theme.Cyan or self.Theme.Text
        safeCall(options.OnHideNames, hideNames)
    end)

    bind(self, numbersPill.Activated, function()
        showNumbers = not showNumbers
        numbersPill.Text = showNumbers and "●   SHOW # ON" or "●   SHOW # OFF"
        numbersPill.TextColor3 = showNumbers and self.Theme.Cyan or self.Theme.Text
        safeCall(options.OnShowNumbers, showNumbers)
    end)

    makeDraggable(self, title, frame)

    local widget = {
        Frame = frame,
        Input = input,
        Set = function(_, value)
            input.Text = tostring(value or "")
        end,
        Get = function()
            return input.Text
        end,
    }
    table.insert(self.Widgets, widget)
    return widget
end

function Window:CreateProgress(options)
    options = options or {}

    local frame = create("Frame", {
        AnchorPoint = options.AnchorPoint or Vector2.new(0.5, 1),
        BackgroundColor3 = self.Theme.Panel,
        BorderSizePixel = 0,
        Position = options.Position or UDim2.new(0.5, 0, 1, -176),
        Size = options.Size or UDim2.fromOffset(284, 78),
    }, self.Root)
    addCorner(frame, 12)
    addAccentStroke(frame, self.Theme, 1.2, 0.12)

    local status = create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(10, 7),
        Size = UDim2.new(1, -20, 0, 18),
        Text = options.Text or "Searching...",
        TextColor3 = self.Theme.Text,
        TextSize = 11,
    }, frame)

    local track = create("Frame", {
        BackgroundColor3 = self.Theme.Input,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.fromOffset(8, 34),
        Size = UDim2.new(1, -16, 0, 31),
    }, frame)
    addCorner(track, 9)
    addAccentStroke(track, self.Theme, 0.9, 0.3)

    local fill = create("Frame", {
        BackgroundColor3 = self.Theme.Cyan,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(math.clamp(options.Value or 0, 0, 1), 1),
    }, track)
    addCorner(fill, 8)
    addGradient(fill, {
        self.Theme.Cyan,
        self.Theme.Indigo,
        self.Theme.Pink,
    }, 0)

    local percentage = create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Size = UDim2.fromScale(1, 1),
        Text = string.format("%d%%", math.floor(math.clamp(options.Value or 0, 0, 1) * 100 + 0.5)),
        TextColor3 = self.Theme.Text,
        TextSize = 11,
        ZIndex = 3,
    }, track)

    local widget = {
        Frame = frame,
        Status = status,
        Fill = fill,
        Percentage = percentage,
        Value = math.clamp(options.Value or 0, 0, 1),
    }

    function widget:Set(value, text)
        self.Value = math.clamp(tonumber(value) or 0, 0, 1)
        if text ~= nil then
            status.Text = tostring(text)
        end
        percentage.Text = string.format("%d%%", math.floor(self.Value * 100 + 0.5))
        tween(self.Window, fill, { Size = UDim2.fromScale(self.Value, 1) })
    end

    widget.Window = self
    makeDraggable(self, status, frame)
    table.insert(self.Widgets, widget)
    return widget
end

function Window:CreateFooter(options)
    options = options or {}

    local frame = create("Frame", {
        AnchorPoint = options.AnchorPoint or Vector2.new(0.5, 1),
        BackgroundColor3 = self.Theme.Panel,
        BorderSizePixel = 0,
        Position = options.Position or UDim2.new(0.5, 0, 1, -84),
        Size = options.Size or UDim2.fromOffset(628, 56),
    }, self.Root)
    addCorner(frame, 12)
    addAccentStroke(frame, self.Theme, 1.15, 0.14)

    local dot = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.Cyan,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(16, 28),
        Size = UDim2.fromOffset(9, 9),
    }, frame)
    addCorner(dot, 9)

    local brand = create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        Position = UDim2.fromOffset(30, 0),
        Size = UDim2.fromOffset(184, 56),
        Text = string.upper(options.Brand or "ZELQYN HUB"),
        TextColor3 = self.Theme.Cyan,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, frame)
    setTextGradient(brand, self.Theme)

    local dividerOne = create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = self.Theme.Cyan,
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(224, 28),
        Size = UDim2.fromOffset(1, 34),
    }, frame)

    create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(242, 0),
        Size = UDim2.fromOffset(220, 56),
        Text = options.Invite or "discord.gg/zelqyn",
        TextColor3 = self.Theme.Muted,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, frame)

    local dividerTwo = dividerOne:Clone()
    dividerTwo.Position = UDim2.fromOffset(472, 28)
    dividerTwo.Parent = frame

    local fpsLabel = create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(486, 4),
        Size = UDim2.fromOffset(55, 48),
        Text = "FPS\n--",
        TextColor3 = self.Theme.Green,
        TextSize = 10,
    }, frame)

    local dividerThree = dividerOne:Clone()
    dividerThree.Position = UDim2.fromOffset(548, 28)
    dividerThree.Parent = frame

    local pingLabel = create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(558, 4),
        Size = UDim2.fromOffset(62, 48),
        Text = "PING\n--ms",
        TextColor3 = self.Theme.Green,
        TextSize = 10,
    }, frame)

    local frames = 0
    local elapsed = 0
    bind(self, RunService.RenderStepped, function(deltaTime)
        frames = frames + 1
        elapsed = elapsed + deltaTime
        if elapsed < 1 then
            return
        end

        local fps = math.floor(frames / elapsed + 0.5)
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
        end)

        fpsLabel.Text = "FPS\n" .. tostring(fps)
        pingLabel.Text = "PING\n" .. tostring(ping) .. "ms"
        frames = 0
        elapsed = 0
    end)

    makeDraggable(self, brand, frame)

    local widget = {
        Frame = frame,
        Brand = brand,
        Fps = fpsLabel,
        Ping = pingLabel,
    }
    table.insert(self.Widgets, widget)
    return widget
end

function Window:Notify(options)
    if type(options) == "string" then
        options = { Text = options }
    end
    options = options or {}

    local holder = self.NotificationHolder
    if not holder then
        holder = create("Frame", {
            AnchorPoint = Vector2.new(1, 1),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -18, 1, -18),
            Size = UDim2.fromOffset(310, 300),
        }, self.Root)
        local layout = addList(holder, 8)
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        self.NotificationHolder = holder
    end

    local card = create("Frame", {
        BackgroundColor3 = self.Theme.Panel,
        BorderSizePixel = 0,
        LayoutOrder = math.floor(os.clock() * 1000),
        Size = UDim2.fromOffset(310, 64),
    }, holder)
    addCorner(card, 10)
    addAccentStroke(card, self.Theme, 1, 0.14)

    makeLogo(self, card, 36, UDim2.fromOffset(10, 14), 4)
    create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Position = UDim2.fromOffset(58, 7),
        Size = UDim2.new(1, -70, 0, 20),
        Text = options.Title or "Zelqyn Hub",
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Position = UDim2.fromOffset(58, 26),
        Size = UDim2.new(1, -70, 0, 30),
        Text = tostring(options.Text or "Notification"),
        TextColor3 = self.Theme.Muted,
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    card.Position = UDim2.fromOffset(330, 0)
    tween(self, card, { Position = UDim2.fromOffset(0, 0) }, self.Theme.MediumTween)

    task.delay(options.Duration or 3.5, function()
        if not card.Parent then
            return
        end
        local animation = tween(self, card, {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(330, 0),
        }, self.Theme.MediumTween)
        if animation then
            animation.Completed:Wait()
        end
        if card.Parent then
            card:Destroy()
        end
    end)

    return card
end

return ZelqynHub
