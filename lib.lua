--v30 horizontal christmas window · tabs/sections/elements api · search · toggle key · reopen button
local cloneref = cloneref or function(object) return object end
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))

local Library = {
    Name = "Zelqyn Hub",
    Version = "30",
    IsTouch = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled,
    Active = nil,
    Theme = {
        bg0 = Color3.fromRGB(9, 12, 12),
        bg1 = Color3.fromRGB(14, 18, 18),
        bg2 = Color3.fromRGB(27, 34, 33),
        bg3 = Color3.fromRGB(19, 25, 24),
        hover = Color3.fromRGB(42, 51, 49),
        sidebar = Color3.fromRGB(11, 15, 15),
        segment = Color3.fromRGB(17, 22, 21),
        segmentActive = Color3.fromRGB(55, 65, 62),
        inputBg = Color3.fromRGB(10, 13, 13),
        border = Color3.fromRGB(255, 255, 255),
        windowTop = Color3.fromRGB(19, 23, 23),
        windowMid = Color3.fromRGB(14, 19, 18),
        windowBottom = Color3.fromRGB(11, 33, 25),
        glow = Color3.fromRGB(28, 110, 72),
        gold = Color3.fromRGB(234, 196, 108),
        goldDeep = Color3.fromRGB(150, 110, 44),
        snow = Color3.fromRGB(236, 246, 255),
        accent = Color3.fromRGB(214, 48, 62),
        accentHover = Color3.fromRGB(232, 74, 86),
        accentDeep = Color3.fromRGB(140, 22, 34),
        accentText = Color3.fromRGB(255, 128, 136),
        activeTabText = Color3.fromRGB(250, 246, 236),
        toggleOff = Color3.fromRGB(55, 64, 62),
        toggleOn = Color3.fromRGB(214, 48, 62),
        knob = Color3.fromRGB(255, 255, 255),
        textPri = Color3.fromRGB(236, 242, 240),
        textMuted = Color3.fromRGB(144, 156, 152),
        textDim = Color3.fromRGB(98, 110, 106),
        success = Color3.fromRGB(86, 214, 140),
        warning = Color3.fromRGB(244, 196, 84),
        danger = Color3.fromRGB(242, 84, 84),
        info = Color3.fromRGB(128, 186, 255),
        cardTransparency = 0.32,
        inputTransparency = 0.18,
        borderTransparency = 0.91,
        fontFamily = "rbxassetid://12187365364",
        tweenFast = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        tweenMed = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        tweenSnap = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        tweenSpring = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        tweenSlide = TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        tweenNoticeIn = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        tweenNoticeOut = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        toggleW = 42,
        toggleH = 22,
        knobSz = 16,
        rippleAsset = "rbxassetid://266543268",
        backgroundAsset = "rbxassetid://130379359123488",
        backgroundTransparency = 0.94,
        backgroundStrengths = { Low = 0.78, Medium = 0.58, High = 0.38 },
        snowfall = true,
        snowDrift = true,
        christmasLights = true,
        lightColors = {
            Color3.fromRGB(255, 70, 82), Color3.fromRGB(255, 204, 90),
            Color3.fromRGB(80, 220, 124), Color3.fromRGB(104, 172, 255),
        },
        candyToggles = true,
        candyWhite = Color3.fromRGB(255, 232, 236),
        tinsel = true,
        headerHeight = 50,
        desktopSize = Vector2.new(660, 440),
        touchSize = Vector2.new(560, 350),
        sidebarWidth = 168,
        compactSidebarWidth = 54,
    },
}

local Theme = Library.Theme
local Window = {}
Window.__index = Window
local Tab = {}
Tab.__index = Tab
local Section = {}
Section.__index = Section

local Fonts = {
    Regular = Font.new(Theme.fontFamily, Enum.FontWeight.Regular),
    Medium = Font.new(Theme.fontFamily, Enum.FontWeight.Medium),
    SemiBold = Font.new(Theme.fontFamily, Enum.FontWeight.SemiBold),
    Bold = Font.new(Theme.fontFamily, Enum.FontWeight.Bold),
}
Library.Fonts = Fonts

local function create(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do object[property] = value end
    if parent then object.Parent = parent end
    return object
end

local function corner(parent, radius)
    return create("UICorner", { CornerRadius = radius or UDim.new(0, 10) }, parent)
end

local function stroke(parent, color, thickness, transparency)
    return create("UIStroke", {
        Color = color or Theme.border,
        Thickness = thickness or 1,
        Transparency = transparency or Theme.borderTransparency,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

local function padding(parent, left, right, top, bottom)
    return create("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0), PaddingRight = UDim.new(0, right or 0),
        PaddingTop = UDim.new(0, top or 0), PaddingBottom = UDim.new(0, bottom or 0),
    }, parent)
end

local function tween(object, info, goal)
    local animation = TweenService:Create(object, info, goal)
    animation:Play()
    return animation
end

local function label(parent, value, properties)
    local values = {
        Size = UDim2.new(1, -24, 1, 0), Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1, FontFace = Fonts.Medium, TextSize = 13,
        TextColor3 = Theme.textPri, TextXAlignment = Enum.TextXAlignment.Left, Text = value or "",
    }
    for key, setting in pairs(properties or {}) do values[key] = setting end
    return create("TextLabel", values, parent)
end

local function colorHex(color)
    return string.format("%02X%02X%02X",
        math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
end

local function escapeRichText(value)
    return (tostring(value or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local LegacyTones = {
    FF8E9D = "danger", B0FFC2 = "success", FFCA5C = "warning", FFD678 = "warning",
    ["51E8FF"] = "info", ["5CCFFF"] = "info", ["15C6FF"] = "info",
    E51FDA = "accentText", A39BCA = "textMuted",
}
local ToneNames = {
    success = "success", warning = "warning", error = "danger", danger = "danger",
    info = "info", muted = "textMuted", accent = "accentText", gold = "gold", text = "textPri",
}

local function resolveTone(tone, fallback)
    if typeof(tone) == "Color3" then
        local key = LegacyTones[colorHex(tone)]
        return key and Theme[key] or tone
    end
    if type(tone) == "string" and ToneNames[tone] then return Theme[ToneNames[tone]] end
    return fallback
end
Library.ResolveTone = resolveTone

local function candyStripes(stripes)
    local points = {}
    for index = 0, stripes - 1 do
        local color = index % 2 == 0 and Theme.accent or Theme.candyWhite
        points[#points + 1] = ColorSequenceKeypoint.new(index == 0 and 0 or index / stripes + 0.001, color)
        points[#points + 1] = ColorSequenceKeypoint.new((index + 1) / stripes, color)
    end
    return ColorSequence.new(points)
end

local function safeCall(callback, ...)
    if type(callback) ~= "function" then return nil end
    local results = table.pack(pcall(callback, ...))
    if not results[1] then
        warn("[" .. Library.Name .. " UI] " .. tostring(results[2]))
        return nil
    end
    return table.unpack(results, 2, results.n)
end

local function guiParent()
    local ok, hui = pcall(function() return gethui and gethui() end)
    if ok and typeof(hui) == "Instance" then return hui end
    local coreOk, core = pcall(function() return cloneref(game:GetService("CoreGui")) end)
    if coreOk and core then
        local writable = pcall(function()
            local probe = Instance.new("Folder")
            probe.Parent = core
            probe:Destroy()
        end)
        if writable then return core end
    end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function viewportSize()
    local camera = workspace.CurrentCamera
    return camera and camera.ViewportSize or Vector2.new(1280, 720)
end

local function connect(window, signal, callback)
    local connection = signal:Connect(callback)
    table.insert(window.Connections, connection)
    return connection
end

local function hoverBackground(window, target, trigger, restColor, hoverColor)
    connect(window, trigger.MouseEnter, function()
        tween(target, Theme.tweenFast, { BackgroundColor3 = hoverColor or Theme.hover })
    end)
    connect(window, trigger.MouseLeave, function()
        tween(target, Theme.tweenFast, { BackgroundColor3 = restColor or Theme.bg2 })
    end)
end

local function ripple(window, button, radius)
    local host = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        BorderSizePixel = 0, ClipsDescendants = true, ZIndex = button.ZIndex,
    }, button)
    corner(host, UDim.new(0, radius or 9))
    connect(window, button.MouseButton1Down, function(x, y)
        local absolute, size = button.AbsolutePosition, button.AbsoluteSize
        local localX = math.clamp((x or absolute.X + size.X / 2) - absolute.X, 0, size.X)
        local localY = math.clamp((y or absolute.Y + size.Y / 2) - absolute.Y, 0, size.Y)
        local diameter = math.max(size.X, size.Y) * 2.2
        local circle = create("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, localX, 0, localY),
            Size = UDim2.new(), BackgroundTransparency = 1, Image = Theme.rippleAsset,
            ImageColor3 = Color3.new(1, 1, 1), ImageTransparency = 0.86, ZIndex = button.ZIndex + 1,
        }, host)
        local animation = tween(circle, TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, diameter, 0, diameter), ImageTransparency = 1,
        })
        animation.Completed:Connect(function()
            if circle.Parent then circle:Destroy() end
        end)
    end)
end

local function makePill(parent, value, tone, position, height, zIndex, withDot)
    local pill = label(parent, value, {
        AnchorPoint = Vector2.new(1, 0.5), Position = position or UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 0, 0, height or 20), AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 0.2, BackgroundColor3 = Theme.bg0,
        FontFace = Fonts.SemiBold, TextSize = 10,
        TextColor3 = withDot and Theme.textPri or (tone or Theme.textMuted),
        TextXAlignment = Enum.TextXAlignment.Center, ZIndex = zIndex or 4,
    })
    corner(pill, UDim.new(1, 0))
    stroke(pill, Theme.border, 1, 0.88)
    padding(pill, withDot and 19 or 9, 9, 0, 0)
    if withDot then
        local dot = create("Frame", {
            Name = "Dot", AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, -12, 0.5, 0),
            Size = UDim2.new(0, 6, 0, 6), BackgroundColor3 = tone or Theme.success,
            BorderSizePixel = 0, ZIndex = pill.ZIndex + 1,
        }, pill)
        corner(dot, UDim.new(1, 0))
    end
    return pill
end

local function setPill(pill, value, tone, textColor)
    if not pill then return end
    pill.Text = value
    local dot = pill:FindFirstChild("Dot")
    if dot then
        dot.BackgroundColor3 = tone
        pill.TextColor3 = textColor or Theme.textPri
    else
        pill.TextColor3 = tone
    end
end

local function iconObject(parent, icon, properties)
    if type(icon) == "string" and icon:find("^rbxasset") then
        return create("ImageLabel", {
            Size = properties.Size, Position = properties.Position, AnchorPoint = properties.AnchorPoint,
            BackgroundTransparency = 1, Image = icon, ImageColor3 = properties.TextColor3 or Theme.textPri,
            ScaleType = Enum.ScaleType.Fit, ZIndex = properties.ZIndex,
        }, parent)
    end
    properties.Text = tostring(icon or "")
    properties.TextXAlignment = Enum.TextXAlignment.Center
    return label(parent, properties.Text, properties)
end

local function logColor(message)
    local lower = tostring(message or ""):lower()
    if lower:find("error", 1, true) or lower:find("failed", 1, true) or lower:find("malformed", 1, true) or lower:find("unavailable", 1, true) then
        return Theme.danger
    end
    if lower:find("cancel", 1, true) or lower:find("waiting", 1, true) or lower:find("nothing pending", 1, true) then
        return Theme.warning
    end
    if lower:find("detected", 1, true) or lower:find("scanned", 1, true) or lower:find("question", 1, true) or lower:find("queued", 1, true) then
        return Theme.info
    end
    if lower:find("answer", 1, true) or lower:find("redeemed", 1, true) or lower:find("loaded", 1, true)
        or lower:find("ready", 1, true) or lower:find("enabled", 1, true) or lower:find("sent", 1, true) or lower:find("captured", 1, true)
    then
        return Theme.success
    end
    return Theme.textPri
end

local function windowBaseSize(window)
    return Library.IsTouch and Theme.touchSize or (window.Options.Size or Theme.desktopSize)
end

function Window:_register(section, card, searchText)
    local entry = {
        Card = card, Section = section, Tab = section.Tab, Hidden = false,
        Text = string.lower(tostring(searchText or "")),
    }
    table.insert(self.Searchable, entry)
    table.insert(section.Entries, entry)
    return entry
end

function Window:Clamp(position)
    local viewport = viewportSize()
    local absoluteX = position.X.Scale * viewport.X + position.X.Offset
    local absoluteY = position.Y.Scale * viewport.Y + position.Y.Offset
    local size = self.View.Window.AbsoluteSize
    local maxX = math.max(6, viewport.X - size.X - 6)
    local maxY = math.max(6, viewport.Y - size.Y - 6)
    local x = math.clamp(absoluteX, 6, maxX)
    local y = math.clamp(absoluteY, 6, maxY)
    return UDim2.new(position.X.Scale, x - position.X.Scale * viewport.X, position.Y.Scale, y - position.Y.Scale * viewport.Y)
end

function Window:UpdateScale(instant)
    local viewport = viewportSize()
    local base = windowBaseSize(self)
    local fit = math.min((viewport.X - 16) / base.X, (viewport.Y - 16) / base.Y)
    local preferred = Library.IsTouch and 1 or math.clamp(viewport.Y / 900, 0.72, 1)
    local target = math.clamp(math.min(fit, preferred), 0.42, 1)
    self.ScaleValue = target
    if self.View.NotificationScale then self.View.NotificationScale.Scale = Library.IsTouch and target or 1 end
    if instant then
        self.View.Scale.Scale = target
    else
        tween(self.View.Scale, Theme.tweenMed, { Scale = target })
    end
    return target
end

function Window:_sizeFor(minimized)
    local base = windowBaseSize(self)
    return UDim2.new(0, base.X, 0, minimized and Theme.headerHeight or base.Y)
end

function Window:SetMinimized(value, instant)
    self.Minimized = value == true
    self.View.Body.Visible = not self.Minimized
    self.View.Divider.Visible = not self.Minimized
    self.View.MinimizeButton.Text = self.Minimized and "+" or "—"
    local size = self:_sizeFor(self.Minimized)
    if instant then
        self.View.Window.Size = size
        self.View.Window.Position = self:Clamp(self.View.Window.Position)
    else
        local resize = tween(self.View.Window, Theme.tweenMed, { Size = size })
        resize.Completed:Connect(function()
            if not self.Destroyed then self.View.Window.Position = self:Clamp(self.View.Window.Position) end
        end)
    end
    if not instant then safeCall(self.Options.OnMinimizedChanged, self.Minimized) end
end

function Window:SetVisible(visible)
    self.Visible = visible ~= false
    self.View.Window.Visible = self.Visible
    self.View.Shadow.Visible = self.Visible
    self.View.Reopen.Visible = not self.Visible
end

function Window:Toggle()
    self:SetVisible(not self.Visible)
end

function Window:SelectTab(target, instant)
    local tab = type(target) == "table" and target or self.Tabs[math.clamp(math.floor(tonumber(target) or 1), 1, math.max(1, #self.Tabs))]
    if not tab then return end
    self.ActiveTab = tab
    for _, other in ipairs(self.Tabs) do
        local active = other == tab
        other.Page.Visible = active
        other.Fill.Enabled = active
        other.Bar.Visible = active
        local textColor = active and Theme.activeTabText or (other.Dimmed and Theme.textDim or Theme.textMuted)
        local goal = { BackgroundTransparency = active and 0 or 1 }
        if instant then
            other.Button.BackgroundTransparency = goal.BackgroundTransparency
            other.TitleLabel.TextColor3 = textColor
            if other.IconLabel:IsA("TextLabel") then other.IconLabel.TextColor3 = textColor end
            other.Stroke.Transparency = active and 0.45 or 1
        else
            tween(other.Button, Theme.tweenFast, goal)
            tween(other.TitleLabel, Theme.tweenFast, { TextColor3 = textColor })
            if other.IconLabel:IsA("TextLabel") then tween(other.IconLabel, Theme.tweenFast, { TextColor3 = textColor }) end
            tween(other.Stroke, Theme.tweenFast, { Transparency = active and 0.45 or 1 })
        end
        other.TitleLabel.FontFace = active and Fonts.Bold or Fonts.SemiBold
    end
    self.View.PageTitle.Text = tab.Title
    for _, dropdown in ipairs(self.Dropdowns) do dropdown:SetOpen(false) end
end

function Window:_applySearch(query)
    query = string.lower(tostring(query or "")):match("^%s*(.-)%s*$")
    self.SearchQuery = query
    local hits = {}
    for _, entry in ipairs(self.Searchable) do
        local match = query == "" or entry.Text:find(query, 1, true) ~= nil or entry.Section.SearchTitle:find(query, 1, true) ~= nil
        local shown = match and not entry.Hidden
        entry.Card.Visible = shown
        if shown then hits[entry.Tab] = (hits[entry.Tab] or 0) + 1 end
    end
    for _, tab in ipairs(self.Tabs) do
        for _, section in ipairs(tab.Sections) do
            local any = false
            for _, entry in ipairs(section.Entries) do
                if entry.Card.Visible then any = true break end
            end
            section.Frame.Visible = query == "" or any
            if query ~= "" and any and section.Collapsed then
                section.ExpandedBySearch = true
                section:SetCollapsed(false, true)
            elseif query == "" and section.ExpandedBySearch then
                section.ExpandedBySearch = false
                section:SetCollapsed(true, true)
            end
        end
        tab.Dimmed = query ~= "" and not hits[tab]
    end
    local target = self.ActiveTab
    if query ~= "" and not hits[target] then
        for _, tab in ipairs(self.Tabs) do
            if hits[tab] then target = tab break end
        end
    end
    self:SelectTab(target, true)
end

function Window:SetStatus(text, tone, badge)
    local color = resolveTone(tone, Theme.success)
    setPill(self.View.StatusPill, tostring(badge or text or "Online"), color)
end

function Window:SetSubtitle(text)
    self.View.Subtitle.Text = tostring(text or "")
end

function Window:SetBackground(image, strength)
    local background = self.View.Background
    if self.Destroyed or not background then return end
    if type(image) == "string" and image ~= "" then
        if background.Image ~= image then background.ImageTransparency = 1 end
        background.Image = image
        background.ImageColor3 = Color3.new(1, 1, 1)
        tween(background, Theme.tweenMed, {
            ImageTransparency = Theme.backgroundStrengths[strength] or Theme.backgroundStrengths.Medium,
        })
    else
        background.Image = Theme.backgroundAsset
        background.ImageColor3 = Theme.glow
        background.ImageTransparency = Theme.backgroundTransparency
    end
end

local NoticeGlyphs = { success = "✓", warning = "!", error = "×", info = "i" }

local function noticeOffscreen(window, anchorY)
    local scale = window.View.NotificationScale and window.View.NotificationScale.Scale or 1
    return UDim2.new(0, viewportSize().X / math.max(scale, 0.01), anchorY, 0)
end

function Window:DismissNotification(entry)
    if not entry or entry.Closed then return end
    entry.Closed = true
    for _, connection in ipairs(entry.Connections or {}) do connection:Disconnect() end
    if entry.ProgressTween then entry.ProgressTween:Cancel() end
    if entry.Key and self.NotificationKeys[entry.Key] == entry then self.NotificationKeys[entry.Key] = nil end
    local index = table.find(self.Notifications, entry)
    if index then table.remove(self.Notifications, index) end
    local holder = entry.Holder
    if not holder or not holder.Parent then return end
    if self.Destroyed or not entry.Shown then holder:Destroy() return end
    tween(entry.Card, Theme.tweenNoticeOut, { Position = noticeOffscreen(self, 1) })
    tween(holder, Theme.tweenNoticeOut, { Size = UDim2.new(1, 0, 0, -8) })
    task.delay(Theme.tweenNoticeOut.Time, function()
        if holder.Parent then holder:Destroy() end
    end)
end

function Window:_notificationList()
    if self.View.Notifications then return self.View.Notifications end
    local list = create("Frame", {
        Name = "Notifications", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16),
        Size = UDim2.new(1, -32, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 100,
    }, self.View.Gui)
    create("UISizeConstraint", { MaxSize = Vector2.new(340, math.huge) }, list)
    create("UIListLayout", {
        Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Bottom,
    }, list)
    self.View.NotificationScale = create("UIScale", { Scale = Library.IsTouch and (self.ScaleValue or 1) or 1 }, list)
    self.View.Notifications = list
    return list
end

function Window:Notify(options)
    if self.Destroyed or not self.View.Gui or not self.View.Gui.Parent then return nil end
    options = type(options) == "table" and options or { Content = tostring(options or "") }
    local key = options.Key and tostring(options.Key)
    if key then self:DismissNotification(self.NotificationKeys[key]) end
    while #self.Notifications >= 3 do self:DismissNotification(self.Notifications[1]) end
    local list = self:_notificationList()
    local kind = (options.Type == "success" or options.Type == "warning" or options.Type == "error") and options.Type or "info"
    local tone = Theme[kind == "error" and "danger" or kind]
    local duration = tonumber(options.Duration) or 6
    if duration ~= duration then duration = 6 end
    duration = math.clamp(duration, 2, 15)
    local content = tostring(options.Content or options.Message or "")
    if #content > 240 then content = content:sub(1, 237) .. "..." end
    self.NotificationOrder = self.NotificationOrder + 1

    local holder = create("Frame", {
        Name = "Notice", Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
        LayoutOrder = self.NotificationOrder,
    }, list)
    local card = create("Frame", {
        AnchorPoint = Vector2.new(0, 1), Position = noticeOffscreen(self, 1),
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.bg1, BackgroundTransparency = 0.03, BorderSizePixel = 0, Active = true,
    }, holder)
    corner(card, UDim.new(0, 12))
    stroke(card, Theme.gold, 1, 0.75)
    local wash = create("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = tone, BorderSizePixel = 0, ZIndex = 1 }, card)
    corner(wash, UDim.new(0, 12))
    create("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.82), NumberSequenceKeypoint.new(0.5, 1), NumberSequenceKeypoint.new(1, 1),
        }),
    }, wash)
    local body = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 2,
    }, card)
    padding(body, 12, 12, 12, 11)
    create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }, body)
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 1, ZIndex = 2,
    }, body)
    local icon = create("Frame", {
        Size = UDim2.new(0, 28, 0, 28), BackgroundColor3 = tone, BackgroundTransparency = 0.82, BorderSizePixel = 0, ZIndex = 3,
    }, row)
    corner(icon, UDim.new(1, 0))
    stroke(icon, tone, 1, 0.55)
    label(icon, NoticeGlyphs[kind], {
        Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(), FontFace = Fonts.Bold, TextSize = 14,
        TextColor3 = tone, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 4,
    })
    local column = create("Frame", {
        Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -40, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, ZIndex = 3,
    }, row)
    create("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, column)
    local titleRow = create("Frame", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, LayoutOrder = 1, ZIndex = 3 }, column)
    label(titleRow, tostring(options.Title or Library.Name):sub(1, 100), {
        Size = UDim2.new(1, -66, 1, 0), Position = UDim2.new(), FontFace = Fonts.SemiBold, TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4,
    })
    label(titleRow, os.date("%H:%M"), {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -24, 0, 0), Size = UDim2.new(0, 40, 1, 0),
        TextSize = 10, TextColor3 = Theme.textDim, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 4,
    })
    local close = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 4, 0.5, 0), Size = UDim2.new(0, 22, 0, 22),
        BackgroundColor3 = Theme.hover, BackgroundTransparency = 1, BorderSizePixel = 0, AutoButtonColor = false,
        Text = "×", FontFace = Fonts.Medium, TextSize = 16, TextColor3 = Theme.textMuted, ZIndex = 5,
    }, titleRow)
    corner(close, UDim.new(1, 0))
    if options.Code and tostring(options.Code) ~= "" then
        local chip = label(column, tostring(options.Code):sub(1, 60), {
            Size = UDim2.new(0, 0, 0, 22), AutomaticSize = Enum.AutomaticSize.X, Position = UDim2.new(), LayoutOrder = 2,
            BackgroundColor3 = Theme.bg0, BackgroundTransparency = 0.15, FontFace = Fonts.SemiBold, TextSize = 12,
            TextColor3 = tone, TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4,
        })
        corner(chip, UDim.new(0, 6))
        stroke(chip, tone, 1, 0.7)
        padding(chip, 8, 8, 0, 0)
        create("UISizeConstraint", { MaxSize = Vector2.new(250, 22) }, chip)
    end
    if content ~= "" then
        label(column, content, {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(), LayoutOrder = 3,
            FontFace = Fonts.Regular, TextSize = 12, TextColor3 = Theme.textMuted, TextWrapped = true, RichText = false, ZIndex = 4,
        })
    end
    local track = create("Frame", {
        Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = Theme.border, BackgroundTransparency = 0.92,
        BorderSizePixel = 0, LayoutOrder = 2, ZIndex = 3,
    }, body)
    corner(track, UDim.new(1, 0))
    local fill = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = tone, BackgroundTransparency = 0.1, BorderSizePixel = 0, ZIndex = 4,
    }, track)
    corner(fill, UDim.new(1, 0))

    local entry = { Card = card, Holder = holder, Key = key, Connections = {} }
    table.insert(self.Notifications, entry)
    if key then self.NotificationKeys[key] = entry end
    local function measure()
        local scale = self.View.NotificationScale and self.View.NotificationScale.Scale or 1
        return card.AbsoluteSize.Y / math.max(scale, 0.01)
    end
    entry.ProgressTween = TweenService:Create(fill, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) })
    entry.ProgressTween.Completed:Connect(function(state)
        if state == Enum.PlaybackState.Completed then self:DismissNotification(entry) end
    end)
    table.insert(entry.Connections, close.Activated:Connect(function() self:DismissNotification(entry) end))
    table.insert(entry.Connections, card.MouseEnter:Connect(function()
        if entry.Shown and not entry.Closed then entry.ProgressTween:Pause() end
    end))
    table.insert(entry.Connections, card.MouseLeave:Connect(function()
        if entry.Shown and not entry.Closed then entry.ProgressTween:Play() end
    end))
    table.insert(entry.Connections, card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then self:DismissNotification(entry) end
    end))
    table.insert(entry.Connections, card:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if entry.Shown and not entry.Closed then tween(holder, Theme.tweenFast, { Size = UDim2.new(1, 0, 0, measure()) }) end
    end))
    task.spawn(function()
        task.wait()
        if entry.Closed or not card.Parent then return end
        entry.Shown = true
        tween(holder, Theme.tweenNoticeIn, { Size = UDim2.new(1, 0, 0, measure()) })
        tween(card, Theme.tweenNoticeIn, { Position = UDim2.new(0, 0, 1, 0) })
        entry.ProgressTween:Play()
    end)
    return entry
end

function Window:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
    while #self.Notifications > 0 do self:DismissNotification(self.Notifications[1]) end
    for index = #self.Connections, 1, -1 do
        local connection = self.Connections[index]
        if connection then connection:Disconnect() end
        self.Connections[index] = nil
    end
    if self.View.Gui and self.View.Gui.Parent then self.View.Gui:Destroy() end
    if Library.Active == self then Library.Active = nil end
end

function Tab:Section(options)
    options = type(options) == "table" and options or { Title = tostring(options or "") }
    local window = self.Window
    local section = setmetatable({
        Window = window, Tab = self, Entries = {}, Order = 0, Collapsed = false,
        SearchTitle = string.lower(tostring(options.Title or "")),
    }, Section)
    local frame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.bg1, BackgroundTransparency = 0.28, BorderSizePixel = 0,
        LayoutOrder = #self.Sections + 1, ZIndex = 3,
    }, self.Page)
    corner(frame, UDim.new(0, 12))
    stroke(frame, Theme.gold, 1, 0.84)
    local header = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, AutoButtonColor = false, Text = "", ZIndex = 4,
    }, frame)
    local bar = create("Frame", {
        Position = UDim2.new(0, 12, 0.5, -10), Size = UDim2.new(0, 3, 0, 20),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 5,
    }, header)
    corner(bar, UDim.new(1, 0))
    create("UIGradient", { Color = ColorSequence.new(Theme.gold, Theme.accent), Rotation = 90 }, bar)
    local titleX = 24
    if options.Icon then
        iconObject(header, options.Icon, {
            Size = UDim2.fromOffset(20, 20), Position = UDim2.new(0, 24, 0.5, -10), TextSize = 15,
            TextColor3 = Theme.gold, ZIndex = 5,
        })
        titleX = 50
    end
    label(header, tostring(options.Title or ""), {
        Position = UDim2.new(0, titleX, 0, 0), Size = UDim2.new(1, -(titleX + 44), 1, 0),
        FontFace = Fonts.Bold, TextSize = 14, TextColor3 = Theme.gold, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
    })
    local chevron = label(header, "▲", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(18, 18),
        FontFace = Fonts.Bold, TextSize = 11, TextColor3 = Theme.gold, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 5,
    })
    chevron.Visible = options.Collapsible ~= false
    local divider = create("Frame", {
        Position = UDim2.new(0, 12, 0, 42), Size = UDim2.new(1, -24, 0, 1),
        BackgroundColor3 = Theme.gold, BackgroundTransparency = 0.82, BorderSizePixel = 0, ZIndex = 4,
    }, frame)
    local content = create("Frame", {
        Position = UDim2.new(0, 0, 0, 43), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, ZIndex = 4,
    }, frame)
    create("UIListLayout", { Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder }, content)
    padding(content, 10, 10, 9, 11)
    section.Frame, section.Content, section.Divider, section.Chevron = frame, content, divider, chevron
    function section:SetCollapsed(collapsed, instant)
        self.Collapsed = collapsed == true
        self.Content.Visible = not self.Collapsed
        self.Divider.Visible = not self.Collapsed
        self.Chevron.Text = self.Collapsed and "▼" or "▲"
        if not instant then
            self.Chevron.TextTransparency = 0.6
            tween(self.Chevron, Theme.tweenFast, { TextTransparency = 0 })
        end
    end
    if options.Collapsible ~= false then
        connect(window, header.Activated, function()
            section.ExpandedBySearch = false
            section:SetCollapsed(not section.Collapsed)
        end)
    end
    section:SetCollapsed(options.Opened == false and options.Collapsible ~= false, true)
    table.insert(self.Sections, section)
    return section
end

function Section:_nextOrder()
    self.Order = self.Order + 1
    return self.Order
end

function Section:_card(height)
    local card = create("Frame", {
        Size = UDim2.new(1, 0, 0, height or 40), BackgroundColor3 = Theme.bg2,
        BackgroundTransparency = Theme.cardTransparency, BorderSizePixel = 0, LayoutOrder = self:_nextOrder(), ZIndex = 4,
    }, self.Content)
    corner(card, UDim.new(0, 9))
    stroke(card)
    return card
end

function Section:_titled(card, options, rightInset)
    local description = type(options.Description) == "string" and options.Description ~= "" and options.Description or nil
    local title = label(card, tostring(options.Title or ""), {
        Position = UDim2.new(0, 12, 0, description and 7 or 0),
        Size = UDim2.new(1, -(rightInset + 24), 0, description and 18 or card.Size.Y.Offset),
        FontFace = Fonts.Medium, TextSize = 13, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
    })
    local descriptionLabel
    if description then
        descriptionLabel = label(card, description, {
            Position = UDim2.new(0, 12, 0, 25), Size = UDim2.new(1, -(rightInset + 24), 0, 18),
            FontFace = Fonts.Regular, TextSize = 11, TextColor3 = Theme.textMuted, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
        })
    end
    return title, descriptionLabel
end

local function elementBase(entry, card)
    return {
        Frame = card,
        SetVisible = function(_, visible)
            entry.Hidden = visible == false
            card.Visible = not entry.Hidden
        end,
    }
end

local function setToggleVisual(control, enabled, instant)
    control.Value = enabled == true
    local on = control.Value
    local trackColor = on and (control.Candy and Color3.new(1, 1, 1) or Theme.toggleOn) or Theme.toggleOff
    if control.Candy and (on or instant) then control.Candy.Enabled = on end
    local knobPosition = on and UDim2.new(0, Theme.toggleW - Theme.knobSz - 3, 0.5, -Theme.knobSz / 2)
        or UDim2.new(0, 3, 0.5, -Theme.knobSz / 2)
    local outlineColor = on and Theme.accent or Theme.border
    local outlineTransparency = on and 0.7 or Theme.borderTransparency
    if instant then
        control.Track.BackgroundColor3 = trackColor
        control.Knob.Position = knobPosition
        control.Outline.Color, control.Outline.Transparency = outlineColor, outlineTransparency
    else
        local trackTween = tween(control.Track, Theme.tweenFast, { BackgroundColor3 = trackColor })
        if control.Candy and not on then
            trackTween.Completed:Connect(function()
                if not control.Value then control.Candy.Enabled = false end
            end)
        end
        tween(control.Knob, Theme.tweenSpring, { Position = knobPosition })
        tween(control.Outline, Theme.tweenMed, { Color = outlineColor, Transparency = outlineTransparency })
        control.KnobScale.Scale = on and 1.15 or 0.88
        tween(control.KnobScale, Theme.tweenSpring, { Scale = 1 })
    end
end

function Section:Toggle(options)
    local window = self.Window
    local hasDescription = type(options.Description) == "string" and options.Description ~= ""
    local card = self:_card(hasDescription and 52 or 40)
    self:_titled(card, options, Theme.toggleW + 10)
    local track = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.new(0, Theme.toggleW, 0, Theme.toggleH), BackgroundColor3 = Theme.toggleOff, BorderSizePixel = 0, ZIndex = 5,
    }, card)
    corner(track, UDim.new(1, 0))
    local candy = Theme.candyToggles and create("UIGradient", { Color = candyStripes(6), Rotation = 35, Enabled = false }, track) or nil
    stroke(track, Theme.border, 1, 0.9)
    local knob = create("Frame", {
        Size = UDim2.new(0, Theme.knobSz, 0, Theme.knobSz), BackgroundColor3 = Theme.knob, BorderSizePixel = 0, ZIndex = 6,
    }, track)
    corner(knob, UDim.new(1, 0))
    stroke(knob, Color3.new(0, 0, 0), 1, 0.82)
    local button = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, AutoButtonColor = false, Text = "", ZIndex = 7,
    }, card)
    ripple(window, button, 9)
    local entry = window:_register(self, card, tostring(options.Title or "") .. " " .. tostring(options.Description or ""))
    local control = elementBase(entry, card)
    control.Track, control.Knob, control.KnobScale = track, knob, create("UIScale", {}, knob)
    control.Outline, control.Candy = card:FindFirstChildOfClass("UIStroke"), candy
    setToggleVisual(control, options.Value, true)
    function control:Set(value, fire)
        setToggleVisual(self, value, false)
        if fire then safeCall(options.Callback, self.Value) end
    end
    function control:Get() return self.Value end
    connect(window, button.Activated, function() control:Set(not control.Value, true) end)
    hoverBackground(window, card, button)
    return control
end

local function buttonCard(window, parent, options, order)
    local variant = options.Variant or (options.Primary and "primary") or "default"
    local primary = variant == "primary"
    local card = create("Frame", {
        Size = options.Size or UDim2.new(1, 0, 0, options.Height or 40),
        Position = options.Position or UDim2.new(), BackgroundColor3 = primary and Color3.new(1, 1, 1) or Theme.bg2,
        BackgroundTransparency = primary and 0 or Theme.cardTransparency, BorderSizePixel = 0, LayoutOrder = order or 0, ZIndex = 4,
    }, parent)
    corner(card, UDim.new(0, 9))
    local outline = stroke(card, primary and Theme.gold or Theme.border, 1, primary and 0.45 or Theme.borderTransparency)
    if primary then
        create("UIGradient", { Color = ColorSequence.new(Theme.accentHover, Theme.accentDeep), Rotation = 90 }, card)
    end
    local textColors = {
        default = Theme.textPri, primary = Theme.activeTabText, danger = Theme.danger,
        warning = Theme.warning, success = Theme.success, accent = Theme.accentText, gold = Theme.gold,
    }
    local control = {
        Frame = card, Outline = outline, Variant = variant, Enabled = true,
        RestText = resolveTone(options.TextColor, textColors[variant] or Theme.textPri),
        RestColor = primary and Color3.new(1, 1, 1) or Theme.bg2,
    }
    local button = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, AutoButtonColor = false,
        FontFace = Fonts.SemiBold, TextSize = options.TextSize or 13, TextColor3 = control.RestText,
        Text = tostring(options.Title or ""), TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 6,
    }, card)
    padding(button, 8, 8, 0, 0)
    control.Button = button
    local scale = create("UIScale", {}, button)
    ripple(window, button, 9)
    local hoverColor = primary and Color3.new(1, 1, 1) or Theme.hover
    connect(window, button.MouseEnter, function()
        if not control.Enabled then return end
        tween(card, Theme.tweenFast, { BackgroundColor3 = hoverColor })
        tween(scale, Theme.tweenFast, { Scale = 1.015 })
        tween(outline, Theme.tweenFast, { Transparency = primary and 0.2 or 0.75 })
    end)
    connect(window, button.MouseLeave, function()
        tween(card, Theme.tweenFast, { BackgroundColor3 = control.RestColor })
        tween(scale, Theme.tweenFast, { Scale = 1 })
        tween(outline, Theme.tweenFast, { Transparency = primary and 0.45 or Theme.borderTransparency })
    end)
    connect(window, button.MouseButton1Down, function()
        if control.Enabled then tween(scale, Theme.tweenSnap, { Scale = 0.97 }) end
    end)
    connect(window, button.MouseButton1Up, function() tween(scale, Theme.tweenSpring, { Scale = 1 }) end)
    connect(window, button.Activated, function()
        if control.Enabled then safeCall(options.Callback) end
    end)
    function control:SetText(value) self.Button.Text = tostring(value or "") end
    function control:SetTextColor(tone)
        self.RestText = resolveTone(tone, self.RestText)
        self.Button.TextColor3 = self.RestText
    end
    function control:SetEnabled(enabled)
        self.Enabled = enabled ~= false
        self.Button.Active, self.Button.AutoButtonColor = self.Enabled, false
        self.Button.TextTransparency = self.Enabled and 0 or 0.35
    end
    return control
end

function Section:Button(options)
    local window = self.Window
    local control = buttonCard(window, self.Content, options, self:_nextOrder())
    local entry = window:_register(self, control.Frame, options.Title)
    local base = elementBase(entry, control.Frame)
    control.SetVisible = base.SetVisible
    return control
end

function Section:Buttons(list)
    local window = self.Window
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = self:_nextOrder(), ZIndex = 4,
    }, self.Content)
    local controls, titles, count, gap = {}, {}, #list, 6
    for index, options in ipairs(list) do
        options.Size = UDim2.new(1 / count, -gap * (count - 1) / count, 1, 0)
        options.Position = UDim2.new((index - 1) / count, (index - 1) * gap / count, 0, 0)
        controls[index] = buttonCard(window, row, options, index)
        titles[#titles + 1] = tostring(options.Title or "")
    end
    local entry = window:_register(self, row, table.concat(titles, " "))
    controls.Frame = row
    controls.SetVisible = elementBase(entry, row).SetVisible
    return controls
end

local function inputField(window, parent, options, position, size)
    local field = create("Frame", {
        AnchorPoint = options.Anchor or Vector2.new(), Position = position, Size = size,
        BackgroundColor3 = Theme.inputBg, BackgroundTransparency = Theme.inputTransparency, BorderSizePixel = 0,
        ClipsDescendants = true, ZIndex = 5,
    }, parent)
    corner(field, UDim.new(0, 8))
    local outline = stroke(field, Theme.border, 1, 0.9)
    local box = create("TextBox", {
        Position = UDim2.new(0, 9, 0, 0), Size = UDim2.new(1, -18, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
        ClearTextOnFocus = false, MultiLine = options.MultiLine == true, TextWrapped = options.MultiLine == true,
        FontFace = Fonts.Medium, TextSize = options.TextSize or 13, TextColor3 = Theme.textPri,
        PlaceholderText = tostring(options.Placeholder or ""), PlaceholderColor3 = Theme.textDim,
        TextXAlignment = options.Align or Enum.TextXAlignment.Left,
        TextYAlignment = options.MultiLine and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
        Text = tostring(options.Value or ""), ClipsDescendants = true, ZIndex = 6,
    }, field)
    if options.MultiLine then padding(box, 0, 0, 8, 8) end
    if not options.MultiLine then
        box.TextTruncate = Enum.TextTruncate.AtEnd
        connect(window, box.Focused, function() box.TextTruncate = Enum.TextTruncate.None end)
        connect(window, box.FocusLost, function() box.TextTruncate = Enum.TextTruncate.AtEnd end)
    end
    connect(window, box.Focused, function()
        tween(outline, Theme.tweenFast, { Color = Theme.accent, Transparency = 0.35 })
    end)
    connect(window, box.FocusLost, function()
        tween(outline, Theme.tweenFast, { Color = Theme.border, Transparency = 0.9 })
    end)
    return field, box
end

function Section:Input(options)
    local window = self.Window
    local stacked = options.Stacked == true
    local hasDescription = type(options.Description) == "string" and options.Description ~= ""
    local width = options.Width or 130
    local card = self:_card(stacked and (hasDescription and 88 or 76) or (hasDescription and 52 or 40))
    local box
    if stacked then
        self:_titled(card, { Title = options.Title, Description = options.Description }, 0)
        for _, child in ipairs(card:GetChildren()) do
            if child:IsA("TextLabel") then child.Size = UDim2.new(1, -24, 0, hasDescription and 18 or 34) end
        end
        local top = hasDescription and 48 or 34
        box = select(2, inputField(window, card, options, UDim2.new(0, 10, 0, top), UDim2.new(1, -20, 0, 32)))
    else
        self:_titled(card, options, width + 8)
        options.Anchor = Vector2.new(1, 0.5)
        box = select(2, inputField(window, card, options, UDim2.new(1, -10, 0.5, 0), UDim2.new(0, width, 0, 28)))
        box.TextXAlignment = options.Align or Enum.TextXAlignment.Center
    end
    local entry = window:_register(self, card, tostring(options.Title or "") .. " " .. tostring(options.Description or ""))
    local control = elementBase(entry, card)
    control.TextBox = box
    function control:Set(value) box.Text = tostring(value or "") end
    function control:Get() return box.Text end
    connect(window, box.FocusLost, function(enterPressed)
        if options.EnterOnly and not enterPressed then return end
        local replacement = safeCall(options.Callback, box.Text, enterPressed)
        if replacement ~= nil then box.Text = tostring(replacement) end
    end)
    if options.Changed then
        connect(window, box:GetPropertyChangedSignal("Text"), function() safeCall(options.Changed, box.Text) end)
    end
    hoverBackground(window, card, box)
    return control
end

function Section:TextArea(options)
    local window = self.Window
    local height = options.Height or 96
    local hasTitle = options.Title and tostring(options.Title) ~= ""
    local card = self:_card(height + (hasTitle and 40 or 18))
    if hasTitle then
        label(card, tostring(options.Title), {
            Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -24, 0, 32),
            FontFace = Fonts.SemiBold, TextSize = 12, ZIndex = 5,
        })
    end
    options.MultiLine = true
    local _, box = inputField(window, card, options, UDim2.new(0, 10, 0, hasTitle and 32 or 9), UDim2.new(1, -20, 0, height))
    local entry = window:_register(self, card, options.Title)
    local control = elementBase(entry, card)
    control.TextBox = box
    function control:Set(value) box.Text = tostring(value or "") end
    function control:Get() return box.Text end
    return control
end

function Section:Segmented(options)
    local window = self.Window
    local items = options.Options or { "Low", "Medium", "High" }
    local width = options.Width or 190
    local card = self:_card(40)
    self:_titled(card, options, width + 8)
    local frame = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -7, 0.5, 0), Size = UDim2.new(0, width, 0, 28),
        BackgroundColor3 = Theme.segment, BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 5,
    }, card)
    corner(frame, UDim.new(0, 9))
    stroke(frame, Theme.border, 1, 0.9)
    padding(frame, 3, 3, 3, 3)
    local highlight = create("Frame", {
        Size = UDim2.new(1 / #items, -2, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 6,
    }, frame)
    corner(highlight, UDim.new(0, 7))
    stroke(highlight, Theme.gold, 1, 0.55)
    create("UIGradient", { Color = ColorSequence.new(Theme.accentHover, Theme.accentDeep), Rotation = 90 }, highlight)
    local entry = window:_register(self, card, tostring(options.Title or "") .. " " .. table.concat(items, " "))
    local control = elementBase(entry, card)
    local buttons = {}
    function control:Set(value, fire, instant)
        local index = table.find(items, value) or 1
        self.Value = items[index]
        for current, button in ipairs(buttons) do
            local active = current == index
            button.FontFace = active and Fonts.SemiBold or Fonts.Medium
            tween(button, Theme.tweenFast, { TextColor3 = active and Theme.activeTabText or Theme.textMuted })
        end
        local position = UDim2.new((index - 1) / #items, 1, 0, 0)
        if instant then highlight.Position = position else tween(highlight, Theme.tweenSlide, { Position = position }) end
        if fire then safeCall(options.Callback, self.Value) end
    end
    function control:Get() return self.Value end
    for index, item in ipairs(items) do
        local button = create("TextButton", {
            Size = UDim2.new(1 / #items, -2, 1, 0), Position = UDim2.new((index - 1) / #items, 1, 0, 0),
            BackgroundTransparency = 1, AutoButtonColor = false, FontFace = Fonts.Medium, TextSize = 12,
            TextColor3 = Theme.textMuted, Text = tostring(item), ZIndex = 7,
        }, frame)
        buttons[index] = button
        connect(window, button.Activated, function()
            if control.Value ~= item then control:Set(item, true) end
        end)
    end
    control:Set(options.Value or items[1], false, true)
    return control
end

function Section:Dropdown(options)
    local window = self.Window
    local items = {}
    for _, item in ipairs(options.Options or {}) do
        items[#items + 1] = type(item) == "table" and { Text = tostring(item.Text or item.Value), Value = item.Value }
            or { Text = tostring(item), Value = item }
    end
    local width, rowHeight = options.Width or 150, 30
    local card = self:_card(40)
    card.ClipsDescendants = true
    self:_titled(card, options, width + 8)
    local head = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 6), Size = UDim2.new(0, width, 0, 28),
        BackgroundColor3 = Theme.inputBg, BackgroundTransparency = Theme.inputTransparency, AutoButtonColor = false,
        FontFace = Fonts.SemiBold, TextSize = 12, TextColor3 = Theme.gold, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 6,
    }, card)
    corner(head, UDim.new(0, 8))
    stroke(head, Theme.border, 1, 0.88)
    local menu = create("Frame", {
        Position = UDim2.new(0, 10, 0, 42), Size = UDim2.new(1, -20, 0, #items * (rowHeight + 4)),
        BackgroundTransparency = 1, Visible = false, ZIndex = 6,
    }, card)
    create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, menu)
    local entryTexts = {}
    for _, item in ipairs(items) do entryTexts[#entryTexts + 1] = item.Text end
    local entry = window:_register(self, card, tostring(options.Title or "") .. " " .. table.concat(entryTexts, " "))
    local control = elementBase(entry, card)
    control.Open = false
    local optionButtons = {}
    local function display(value)
        for _, item in ipairs(items) do
            if item.Value == value then return item.Text end
        end
        return tostring(value or "")
    end
    function control:SetOpen(open)
        self.Open = open == true
        if self.Open then
            for _, other in ipairs(window.Dropdowns) do
                if other ~= self and other.Open then other:SetOpen(false) end
            end
        end
        menu.Visible = self.Open
        card.Size = UDim2.new(1, 0, 0, self.Open and 48 + #items * (rowHeight + 4) or 40)
        head.Text = display(self.Value) .. (self.Open and "  ▲" or "  ▼")
        for index, item in ipairs(items) do
            local button = optionButtons[index]
            local selected = item.Value == self.Value
            button.BackgroundColor3 = selected and Theme.hover or Theme.inputBg
            button.TextColor3 = selected and Theme.gold or Theme.textPri
        end
    end
    function control:Set(value, fire)
        self.Value = value
        self:SetOpen(false)
        if fire then safeCall(options.Callback, value) end
    end
    function control:Get() return self.Value end
    for index, item in ipairs(items) do
        local button = create("TextButton", {
            Size = UDim2.new(1, 0, 0, rowHeight), BackgroundColor3 = Theme.inputBg, BorderSizePixel = 0,
            AutoButtonColor = false, FontFace = Fonts.Medium, TextSize = 12, TextColor3 = Theme.textPri,
            Text = item.Text, LayoutOrder = index, ZIndex = 7,
        }, menu)
        corner(button, UDim.new(0, 7))
        stroke(button, Theme.border, 1, 0.92)
        optionButtons[index] = button
        connect(window, button.Activated, function() control:Set(item.Value, true) end)
        hoverBackground(window, button, button, Theme.inputBg)
    end
    connect(window, head.Activated, function() control:SetOpen(not control.Open) end)
    table.insert(window.Dropdowns, control)
    control.Value = options.Value ~= nil and options.Value or (items[1] and items[1].Value)
    control:SetOpen(false)
    return control
end

function Section:Slider(options)
    local window = self.Window
    local minimum, maximum = tonumber(options.Min) or 0, tonumber(options.Max) or 100
    local step = tonumber(options.Step) or 1
    local card = self:_card(56)
    label(card, tostring(options.Title or ""), {
        Position = UDim2.new(0, 12, 0, 6), Size = UDim2.new(1, -90, 0, 20), FontFace = Fonts.Medium, TextSize = 13, ZIndex = 5,
    })
    local valueLabel = label(card, "", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 6), Size = UDim2.new(0, 70, 0, 20),
        FontFace = Fonts.SemiBold, TextSize = 12, TextColor3 = Theme.gold, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 5,
    })
    local bar = create("Frame", {
        Position = UDim2.new(0, 12, 0, 36), Size = UDim2.new(1, -24, 0, 6), BackgroundColor3 = Theme.toggleOff,
        BorderSizePixel = 0, ZIndex = 5,
    }, card)
    corner(bar, UDim.new(1, 0))
    local fill = create("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 6 }, bar)
    corner(fill, UDim.new(1, 0))
    create("UIGradient", { Color = candyStripes(8), Rotation = 0 }, fill)
    local knob = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Theme.knob, BorderSizePixel = 0, ZIndex = 7,
    }, bar)
    corner(knob, UDim.new(1, 0))
    stroke(knob, Theme.gold, 1, 0.4)
    local hit = create("TextButton", {
        Position = UDim2.new(0, 0, 0, 26), Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Text = "", ZIndex = 8,
    }, card)
    local entry = window:_register(self, card, options.Title)
    local control = elementBase(entry, card)
    local suffix = tostring(options.Suffix or "")
    function control:Set(value, fire)
        value = math.clamp(tonumber(value) or minimum, minimum, maximum)
        value = math.floor((value - minimum) / step + 0.5) * step + minimum
        self.Value = value
        local alpha = maximum > minimum and (value - minimum) / (maximum - minimum) or 0
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        valueLabel.Text = (step < 1 and string.format("%.2f", value) or tostring(math.floor(value + 0.5))) .. suffix
        if fire then safeCall(options.Callback, value) end
    end
    function control:Get() return self.Value end
    local dragging = false
    local function update(x)
        local alpha = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
        control:Set(minimum + alpha * (maximum - minimum), options.Live == true)
    end
    connect(window, hit.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input.Position.X)
        end
    end)
    connect(window, UserInputService.InputChanged, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)
    connect(window, UserInputService.InputEnded, function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            if not options.Live then safeCall(options.Callback, control.Value) end
        end
    end)
    control:Set(options.Value or minimum)
    return control
end

function Section:Keybind(options)
    local window = self.Window
    local card = self:_card(40)
    self:_titled(card, options, 112)
    local keyButton = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -42, 0.5, 0), Size = UDim2.new(0, 70, 0, 28),
        BackgroundColor3 = Theme.inputBg, BackgroundTransparency = Theme.inputTransparency, BorderSizePixel = 0,
        AutoButtonColor = false, FontFace = Fonts.SemiBold, TextSize = 12, TextColor3 = Theme.gold, ZIndex = 6,
    }, card)
    corner(keyButton, UDim.new(0, 8))
    stroke(keyButton, Theme.border, 1, 0.88)
    local reset = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.new(0, 28, 0, 28),
        BackgroundColor3 = Theme.inputBg, BackgroundTransparency = Theme.inputTransparency, BorderSizePixel = 0,
        AutoButtonColor = false, FontFace = Fonts.SemiBold, TextSize = 15, TextColor3 = Theme.textMuted, Text = "×", ZIndex = 6,
    }, card)
    corner(reset, UDim.new(0, 8))
    stroke(reset, Theme.border, 1, 0.9)
    hoverBackground(window, keyButton, keyButton, Theme.inputBg)
    hoverBackground(window, reset, reset, Theme.inputBg)
    local entry = window:_register(self, card, options.Title)
    local control = elementBase(entry, card)
    control.Value = typeof(options.Value) == "EnumItem" and options.Value or Enum.KeyCode.F6
    control.Waiting = false
    local default = typeof(options.Default) == "EnumItem" and options.Default or control.Value
    function control:Set(key, fire)
        self.Value = key
        self.Waiting = false
        keyButton.Text = key.Name
        keyButton.TextColor3 = Theme.gold
        if fire then safeCall(options.Callback, key) end
    end
    function control:Get() return self.Value end
    connect(window, keyButton.Activated, function()
        control.Waiting = not control.Waiting
        keyButton.Text = control.Waiting and "PRESS..." or control.Value.Name
        keyButton.TextColor3 = control.Waiting and Theme.warning or Theme.gold
    end)
    connect(window, reset.Activated, function() control:Set(default, true) end)
    connect(window, UserInputService.InputBegan, function(input, processed)
        if control.Waiting then
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Unknown then
                control:Set(control.Value, false)
            else
                control:Set(input.KeyCode, true)
            end
            return
        end
        if processed or UserInputService:GetFocusedTextBox() then return end
        if input.KeyCode == control.Value then safeCall(options.OnPress) end
    end)
    control:Set(control.Value, false)
    return control
end

function Section:Paragraph(options)
    local window = self.Window
    local card = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.bg3,
        BackgroundTransparency = 0.35, BorderSizePixel = 0, LayoutOrder = self:_nextOrder(), ZIndex = 4,
    }, self.Content)
    corner(card, UDim.new(0, 9))
    stroke(card)
    padding(card, 14, 12, 9, 10)
    create("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }, card)
    local title = label(card, tostring(options.Title or ""), {
        Position = UDim2.new(), Size = UDim2.new(1, 0, 0, 18), FontFace = Fonts.SemiBold, TextSize = 13,
        TextColor3 = Theme.textPri, LayoutOrder = 1, ZIndex = 5,
    })
    title.Visible = title.Text ~= ""
    local body = label(card, tostring(options.Content or ""), {
        Position = UDim2.new(), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        FontFace = Fonts.Regular, TextSize = 12, TextColor3 = Theme.textMuted, TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = 2, ZIndex = 5,
    })
    local entry = window:_register(self, card, tostring(options.Title or "") .. " " .. tostring(options.Content or ""))
    local control = elementBase(entry, card)
    function control:Set(newTitle, newContent)
        if newTitle ~= nil then title.Text = tostring(newTitle); title.Visible = title.Text ~= "" end
        if newContent ~= nil then body.Text = tostring(newContent) end
    end
    return control
end

function Section:Status(options)
    options = type(options) == "table" and options or { Text = tostring(options or "") }
    local window = self.Window
    local card = self:_card(36)
    card.BackgroundColor3 = Theme.bg3
    local text = label(card, tostring(options.Text or ""), {
        Size = UDim2.new(1, -24, 1, 0), FontFace = Fonts.SemiBold, TextSize = 12,
        TextColor3 = resolveTone(options.Tone, Theme.textMuted), TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
    })
    local entry = window:_register(self, card, options.Title or options.Text)
    local control = elementBase(entry, card)
    control.Label = text
    function control:Set(value, tone)
        text.Text = tostring(value or "")
        text.TextColor3 = resolveTone(tone, Theme.textMuted)
    end
    function control:Get() return text.Text end
    return control
end

function Section:Display(options)
    local window = self.Window
    local card = self:_card(76)
    label(card, tostring(options.Title or ""), {
        Position = UDim2.new(0, 12, 0, 6), Size = UDim2.new(1, -120, 0, 18),
        FontFace = Fonts.SemiBold, TextSize = 11, TextColor3 = Theme.textMuted, ZIndex = 5,
    })
    local badge = makePill(card, tostring(options.Badge or ""), Theme.textDim, UDim2.new(1, -10, 0, 15), 18, 6, true)
    badge.Visible = options.Badge ~= nil
    local box = create("Frame", {
        Position = UDim2.new(0, 10, 0, 28), Size = UDim2.new(1, -20, 0, 38), BackgroundColor3 = Theme.inputBg,
        BackgroundTransparency = Theme.inputTransparency, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 5,
    }, card)
    corner(box, UDim.new(0, 8))
    stroke(box, Theme.border, 1, 0.92)
    local bar = create("Frame", {
        Size = UDim2.new(0, 2, 1, -14), Position = UDim2.new(0, 8, 0, 7), BackgroundColor3 = Theme.accent, BorderSizePixel = 0, ZIndex = 6,
    }, box)
    corner(bar, UDim.new(1, 0))
    local message = label(box, "", {
        Size = UDim2.new(1, -28, 1, 0), Position = UDim2.new(0, 18, 0, 0), TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 6,
    })
    local entry = window:_register(self, card, options.Title)
    local control = elementBase(entry, card)
    local placeholder = tostring(options.Placeholder or "")
    function control:Set(value, badgeText, tone)
        value = tostring(value or "")
        local has = value ~= ""
        message.Text = has and value or placeholder
        message.TextColor3 = has and Theme.textPri or Theme.textMuted
        if badgeText then
            badge.Visible = true
            setPill(badge, tostring(badgeText), resolveTone(tone, Theme.textDim), has and Theme.textPri or Theme.textMuted)
        end
    end
    control:Set(options.Text, options.Badge, options.BadgeTone)
    return control
end

function Section:Log(options)
    options = options or {}
    local window = self.Window
    local height = options.Height or 250
    local card = self:_card(height + 40)
    label(card, tostring(options.Title or "Activity Log"), {
        Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -110, 0, 32), FontFace = Fonts.SemiBold, TextSize = 12, ZIndex = 5,
    })
    local count = label(card, "0 lines", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 0), Size = UDim2.new(0, 90, 0, 32),
        TextSize = 11, TextColor3 = Theme.textDim, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 5,
    })
    local scroll = create("ScrollingFrame", {
        Position = UDim2.new(0, 8, 0, 32), Size = UDim2.new(1, -16, 0, height),
        BackgroundColor3 = Theme.bg0, BackgroundTransparency = 0.3, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.gold, ScrollBarImageTransparency = 0.55,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ClipsDescendants = true, ZIndex = 5,
    }, card)
    corner(scroll, UDim.new(0, 8))
    stroke(scroll)
    create("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }, scroll)
    padding(scroll, 9, 9, 7, 7)
    local entry = window:_register(self, card, tostring(options.Title or "Activity Log"))
    local control = elementBase(entry, card)
    control.Labels, control.Max = {}, options.MaxLines or (Library.IsTouch and 80 or 140)
    local scrollPending, order = false, 0
    function control:Add(raw)
        raw = tostring(raw or "")
        local timestamp, message = raw:match("^%[([^%]]+)%]%s*(.*)$")
        timestamp, message = timestamp or "--:--:--", message or raw
        message = message:gsub("(" .. string.rep("%x", 8) .. ")" .. string.rep("%x", 24) .. "%x*", "%1…")
        order = order + 1
        local line = label(scroll, string.format('<font color="#%s">%s</font>   <font color="#%s">%s</font>',
            colorHex(Theme.textDim), escapeRichText(timestamp), colorHex(logColor(message)), escapeRichText(message)), {
            Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(),
            FontFace = Fonts.Medium, TextSize = 12, TextWrapped = true, RichText = true, LayoutOrder = order, ZIndex = 6,
        })
        table.insert(self.Labels, line)
        while #self.Labels > self.Max do
            local oldest = table.remove(self.Labels, 1)
            if oldest and oldest.Parent then oldest:Destroy() end
        end
        count.Text = #self.Labels .. " lines"
        if scrollPending then return end
        scrollPending = true
        task.defer(function()
            scrollPending = false
            if scroll.Parent then scroll.CanvasPosition = Vector2.new(0, math.huge) end
        end)
    end
    function control:Clear()
        for _, line in ipairs(self.Labels) do
            if line.Parent then line:Destroy() end
        end
        self.Labels = {}
        count.Text = "0 lines"
    end
    function control:Count() return #self.Labels end
    return control
end

function Window:Tab(options)
    options = type(options) == "table" and options or { Title = tostring(options or "") }
    local index = #self.Tabs + 1
    local tab = setmetatable({ Window = self, Index = index, Title = tostring(options.Title or ("Tab " .. index)), Sections = {} }, Tab)
    local compact = self.Compact
    local button = create("TextButton", {
        Size = UDim2.new(1, 0, 0, compact and 36 or 40), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1,
        AutoButtonColor = false, Text = "", LayoutOrder = index, ZIndex = 5,
    }, self.View.TabList)
    corner(button, UDim.new(0, 10))
    tab.Stroke = stroke(button, Theme.gold, 1, 1)
    tab.Fill = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.accentHover), ColorSequenceKeypoint.new(0.55, Theme.accent),
            ColorSequenceKeypoint.new(1, Theme.accentDeep),
        }),
        Rotation = 90, Enabled = false,
    }, button)
    tab.Bar = create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, -7, 0.5, 0), Size = UDim2.new(0, 3, 0.55, 0),
        BackgroundColor3 = Theme.gold, BorderSizePixel = 0, Visible = false, ZIndex = 6,
    }, button)
    corner(tab.Bar, UDim.new(1, 0))
    tab.IconLabel = iconObject(button, options.Icon or "•", {
        Size = UDim2.fromOffset(22, 22), Position = compact and UDim2.new(0.5, -11, 0.5, -11) or UDim2.new(0, 12, 0.5, -11),
        TextSize = 15, TextColor3 = Theme.textMuted, ZIndex = 6,
    })
    tab.TitleLabel = label(button, tab.Title, {
        Position = UDim2.new(0, 42, 0, 0), Size = UDim2.new(1, -48, 1, 0), FontFace = Fonts.SemiBold, TextSize = 13,
        TextColor3 = Theme.textMuted, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 6, Visible = not compact,
    })
    tab.Button = button
    tab.Page = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
        ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.gold, ScrollBarImageTransparency = 0.5,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 3,
    }, self.View.Pages)
    create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center }, tab.Page)
    padding(tab.Page, 2, 10, 2, 12)
    connect(self, button.Activated, function()
        if self.ActiveTab == tab then return end
        self:SelectTab(tab)
        safeCall(self.Options.OnTabChanged, tab.Index, tab.Title)
    end)
    connect(self, button.MouseEnter, function()
        if self.ActiveTab ~= tab then tween(button, Theme.tweenFast, { BackgroundTransparency = 0.94 }) end
    end)
    connect(self, button.MouseLeave, function()
        if self.ActiveTab ~= tab then tween(button, Theme.tweenFast, { BackgroundTransparency = 1 }) end
    end)
    table.insert(self.Tabs, tab)
    if index == 1 then self:SelectTab(tab, true) end
    return tab
end

local function headerButton(window, parent, text, order)
    local button = create("TextButton", {
        Size = UDim2.fromOffset(32, 32), BackgroundColor3 = Theme.bg2, BackgroundTransparency = 0.25,
        BorderSizePixel = 0, AutoButtonColor = false, FontFace = Fonts.SemiBold, TextSize = 14,
        TextColor3 = Theme.gold, Text = text, LayoutOrder = order, ZIndex = 6,
    }, parent)
    corner(button, UDim.new(0, 9))
    stroke(button, Theme.gold, 1, 0.7)
    hoverBackground(window, button, button, Theme.bg2, Theme.hover)
    return button
end

local function buildDecorations(window)
    local view = window.View
    local function glowLayer(name, rotation, transparency, color)
        local layer = create("Frame", {
            Name = name, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = color or Theme.glow, BorderSizePixel = 0, ZIndex = 1,
        }, view.Window)
        corner(layer, UDim.new(0, 14))
        create("UIGradient", { Rotation = rotation, Transparency = transparency }, layer)
        return layer
    end
    glowLayer("GlowRise", 90, NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.35, 0.94), NumberSequenceKeypoint.new(1, 0.62),
    }))
    glowLayer("GlowCore", 0, NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.9), NumberSequenceKeypoint.new(1, 1),
    }))
    glowLayer("Frost", 90, NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.8, 1), NumberSequenceKeypoint.new(1, 0.9),
    }), Theme.snow)
    view.Background = create("ImageLabel", {
        Name = "Background", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
        Image = Theme.backgroundAsset, ImageColor3 = Theme.glow, ImageTransparency = Theme.backgroundTransparency,
        ScaleType = Enum.ScaleType.Crop, ZIndex = 1,
    }, view.Window)
    corner(view.Background, UDim.new(0, 14))
    view.SnowLayer = create("Frame", {
        Name = "Snowfall", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
        ClipsDescendants = true, ZIndex = 2,
    }, view.Window)
    view.Snowflakes = {}
    if Theme.snowfall then
        local specs = {
            { 0.04, -0.10, 16, 0.040, 0.020, 0.30 }, { 0.16, 0.22, 11, 0.028, 0.014, 0.50 },
            { 0.28, -0.34, 19, 0.034, 0.024, 0.28 }, { 0.41, 0.05, 13, 0.044, 0.016, 0.42 },
            { 0.55, -0.24, 17, 0.031, 0.022, 0.34 }, { 0.68, 0.30, 12, 0.039, 0.015, 0.48 },
            { 0.82, 0.58, 14, 0.036, 0.018, 0.40 }, { 0.94, 0.70, 18, 0.042, 0.020, 0.32 },
            { 0.36, 0.52, 15, 0.030, 0.017, 0.38 }, { 0.75, 0.86, 10, 0.026, 0.012, 0.55 },
            { 0.10, 0.36, 0, 0.022, 0.010, 0.45 }, { 0.23, 0.12, 0, 0.025, 0.012, 0.55 },
            { 0.47, 0.44, 0, 0.020, 0.010, 0.50 }, { 0.61, 0.80, 0, 0.027, 0.014, 0.45 },
            { 0.86, 0.06, 0, 0.023, 0.011, 0.55 }, { 0.97, 0.66, 0, 0.021, 0.012, 0.50 },
            { 0.52, 0.26, 14, 0.033, 0.019, 0.36 }, { 0.06, 0.78, 0, 0.024, 0.011, 0.50 },
            { 0.32, 0.94, 0, 0.026, 0.013, 0.48 }, { 0.71, 0.40, 0, 0.022, 0.010, 0.52 },
            { 0.89, 0.18, 12, 0.035, 0.016, 0.44 }, { 0.19, 0.64, 0, 0.023, 0.012, 0.52 },
        }
        for index, spec in ipairs(specs) do
            local transparency = math.max(0.14, spec[6] - 0.1)
            local flake
            if spec[3] > 0 then
                flake = label(view.SnowLayer, "❄", {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(spec[1], spec[2]),
                    Size = UDim2.fromOffset(spec[3] + 6, spec[3] + 6), FontFace = Fonts.Regular,
                    TextSize = spec[3], TextColor3 = Theme.snow, TextTransparency = transparency,
                    TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 2,
                })
            else
                local dot = 3 + index % 3
                flake = create("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(spec[1], spec[2]),
                    Size = UDim2.fromOffset(dot, dot), BackgroundColor3 = Theme.snow,
                    BackgroundTransparency = transparency, BorderSizePixel = 0, ZIndex = 2,
                }, view.SnowLayer)
                corner(flake, UDim.new(1, 0))
            end
            view.Snowflakes[index] = { Object = flake, X = spec[1], Y = spec[2], Speed = spec[4], Sway = spec[5], Spin = spec[3] > 0, Phase = index * 0.83 }
        end
    end
    if Theme.snowDrift then
        for _, drift in ipairs({
            { 0.08, 70, 16, 0.82 }, { 0.2, 90, 20, 0.85 }, { 0.33, 64, 14, 0.81 }, { 0.47, 96, 22, 0.86 },
            { 0.61, 72, 16, 0.82 }, { 0.74, 88, 18, 0.85 }, { 0.88, 66, 15, 0.82 },
        }) do
            local mound = create("Frame", {
                Name = "SnowDrift", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(drift[1], 0, 1, 2),
                Size = UDim2.fromOffset(drift[2], drift[3]), BackgroundColor3 = Theme.snow,
                BackgroundTransparency = drift[4], BorderSizePixel = 0, ZIndex = 2,
            }, view.SnowLayer)
            corner(mound, UDim.new(1, 0))
        end
    end
    view.Lights = {}
    if Theme.christmasLights then
        local garland = create("Frame", {
            Name = "ChristmasLights", Size = UDim2.new(1, -36, 0, 12), Position = UDim2.new(0, 18, 0, 0),
            BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 7,
        }, view.Window)
        create("Frame", {
            Name = "Wire", Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 1),
            BackgroundColor3 = Color3.fromRGB(52, 98, 68), BorderSizePixel = 0, ZIndex = 7,
        }, garland)
        local count = 22
        for index = 1, count do
            local color = Theme.lightColors[(index - 1) % #Theme.lightColors + 1]
            local drop = index % 2 == 0 and 2 or 0
            local x = (index - 0.5) / count
            create("Frame", {
                Name = "Socket", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(x, 0, 0, 1),
                Size = UDim2.fromOffset(2, drop + 2), BackgroundColor3 = Color3.fromRGB(52, 98, 68), BorderSizePixel = 0, ZIndex = 7,
            }, garland)
            local bulb = create("Frame", {
                Name = "Bulb", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(x, 0, 0, 2 + drop),
                Size = UDim2.fromOffset(5, 7), BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 7,
            }, garland)
            corner(bulb, UDim.new(1, 0))
            view.Lights[index] = { Bulb = bulb, Glow = stroke(bulb, color, 2, 0.45), Phase = index * 1.9, Rate = 1.6 + (index % 3) * 0.55 }
        end
    end
    local border = create("UIStroke", {
        Color = Color3.new(1, 1, 1), Thickness = 1.2, Transparency = 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, LineJoinMode = Enum.LineJoinMode.Round,
    }, view.Window)
    view.Glow = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.goldDeep), ColorSequenceKeypoint.new(0.42, Theme.goldDeep),
            ColorSequenceKeypoint.new(0.5, Theme.gold), ColorSequenceKeypoint.new(0.58, Theme.goldDeep),
            ColorSequenceKeypoint.new(1, Theme.goldDeep),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(0.4, 0.55),
            NumberSequenceKeypoint.new(0.5, 0.05), NumberSequenceKeypoint.new(0.6, 0.55), NumberSequenceKeypoint.new(1, 0.55),
        }),
    }, border)
end

local function buildWindow(window)
    local view, options = window.View, window.Options
    local base = windowBaseSize(window)
    local parent = guiParent()
    local guiName = tostring(options.GuiName or "ZelqynHubWindow")
    local old = parent:FindFirstChild(guiName)
    if old then old:Destroy() end
    view.Gui = create("ScreenGui", {
        Name = guiName, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true,
        DisplayOrder = 50,
    }, parent)
    view.Shadow = create("ImageLabel", {
        Name = "Shadow", BackgroundTransparency = 1, BorderSizePixel = 0, Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.new(0, 0, 0), ImageTransparency = 0.3, ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450), ZIndex = 0,
    }, view.Gui)
    view.Window = create("Frame", {
        Name = "Window", Size = window:_sizeFor(false),
        Position = options.Position or UDim2.new(0.5, -base.X / 2, 0.5, -base.Y / 2),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Active = true, ClipsDescendants = true, ZIndex = 1,
    }, view.Gui)
    corner(view.Window, UDim.new(0, 14))
    view.Scale = create("UIScale", { Scale = 0.92 }, view.Window)
    create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.windowTop), ColorSequenceKeypoint.new(0.5, Theme.windowMid),
            ColorSequenceKeypoint.new(1, Theme.windowBottom),
        }),
        Rotation = 90,
    }, view.Window)
    local function syncShadow()
        local position, size = view.Window.Position, view.Window.Size
        local scale = view.Scale.Scale
        view.Shadow.Position = UDim2.new(position.X.Scale, position.X.Offset - 22, position.Y.Scale, position.Y.Offset - 14)
        view.Shadow.Size = UDim2.new(0, size.X.Offset * scale + 44, 0, size.Y.Offset * scale + 52)
    end
    connect(window, view.Window:GetPropertyChangedSignal("Position"), syncShadow)
    connect(window, view.Window:GetPropertyChangedSignal("Size"), syncShadow)
    connect(window, view.Scale:GetPropertyChangedSignal("Scale"), syncShadow)
    syncShadow()
    buildDecorations(window)

    local headerHeight = Theme.headerHeight
    view.Header = create("Frame", {
        Size = UDim2.new(1, 0, 0, headerHeight), BackgroundTransparency = 1, BorderSizePixel = 0, Active = true, ZIndex = 4,
    }, view.Window)
    local mark = create("Frame", {
        Size = UDim2.fromOffset(32, 32), Position = UDim2.new(0, 14, 0.5, -15),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 5,
    }, view.Header)
    corner(mark, UDim.new(0, 9))
    stroke(mark, Theme.gold, 1, 0.35)
    create("UIGradient", { Color = ColorSequence.new(Theme.accentHover, Theme.accentDeep), Rotation = 135 }, mark)
    if type(options.Logo) == "string" and options.Logo:find("^rbxasset") then
        create("ImageLabel", {
            Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2), BackgroundTransparency = 1,
            Image = options.Logo, ScaleType = Enum.ScaleType.Fit, ZIndex = 6,
        }, mark)
    else
        label(mark, tostring(options.Logo or "Z"), {
            Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(), FontFace = Fonts.Bold, TextSize = 17,
            TextColor3 = Theme.activeTabText, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 6,
        })
    end
    for _, cap in ipairs({ { 0.24, 13, 7 }, { 0.52, 17, 8 }, { 0.8, 12, 6 } }) do
        local blob = create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(cap[1], 0, 0, 1), Size = UDim2.fromOffset(cap[2], cap[3]),
            BackgroundColor3 = Theme.snow, BorderSizePixel = 0, ZIndex = 7,
        }, mark)
        corner(blob, UDim.new(1, 0))
    end
    view.Title = label(view.Header, string.upper(tostring(options.Title or Library.Name)) .. "  🎄", {
        Position = UDim2.new(0, 56, 0, 0), Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
        FontFace = Fonts.Bold, TextSize = 16, TextColor3 = Theme.gold, ZIndex = 5,
    })
    create("UISizeConstraint", { MaxSize = Vector2.new(260, headerHeight) }, view.Title)
    view.Subtitle = label(view.Header, tostring(options.Subtitle or ""), {
        Position = UDim2.new(0, 0, 0.5, -11), Size = UDim2.new(0, 0, 0, 22), AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Theme.bg0, BackgroundTransparency = 0.25, FontFace = Fonts.SemiBold, TextSize = 11,
        TextColor3 = Theme.textMuted, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 5,
    })
    corner(view.Subtitle, UDim.new(1, 0))
    stroke(view.Subtitle, Theme.gold, 1, 0.75)
    padding(view.Subtitle, 10, 10, 0, 0)
    view.Subtitle.Visible = view.Subtitle.Text ~= "" and not Library.IsTouch
    local function placeSubtitle()
        view.Subtitle.Position = UDim2.new(0, 56 + view.Title.AbsoluteSize.X / math.max(view.Scale.Scale, 0.01) + 10, 0.5, -11)
    end
    connect(window, view.Title:GetPropertyChangedSignal("AbsoluteSize"), placeSubtitle)
    task.defer(placeSubtitle)

    local controls = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0, 0, 0, 32),
        AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, ZIndex = 5,
    }, view.Header)
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center, HorizontalAlignment = Enum.HorizontalAlignment.Right,
    }, controls)
    view.StatusPill = makePill(controls, "Online", Theme.success, nil, 22, 6, true)
    view.StatusPill.AnchorPoint = Vector2.new()
    view.StatusPill.LayoutOrder = 0
    view.StatusPill.Visible = not Library.IsTouch
    view.SearchBox = create("TextBox", {
        Size = UDim2.fromOffset(0, 32), BackgroundColor3 = Theme.inputBg, BackgroundTransparency = 0.15, BorderSizePixel = 0,
        ClearTextOnFocus = false, FontFace = Fonts.Medium, TextSize = 13, TextColor3 = Theme.textPri, Text = "",
        PlaceholderText = "Search...", PlaceholderColor3 = Theme.textDim, TextXAlignment = Enum.TextXAlignment.Left,
        Visible = false, LayoutOrder = 1, ClipsDescendants = true, ZIndex = 6,
    }, controls)
    corner(view.SearchBox, UDim.new(0, 9))
    stroke(view.SearchBox, Theme.gold, 1, 0.6)
    padding(view.SearchBox, 10, 10, 0, 0)
    view.SearchButton = headerButton(window, controls, "🔍", 2)
    if options.OnDiscord then view.DiscordButton = headerButton(window, controls, "💬", 3) end
    view.MinimizeButton = headerButton(window, controls, "—", 4)
    view.CloseButton = headerButton(window, controls, "×", 5)
    view.CloseButton.TextSize = 18

    view.Divider = create("Frame", {
        Size = UDim2.new(1, -24, 0, 2), Position = UDim2.new(0, 12, 0, headerHeight),
        BackgroundColor3 = Theme.border, BackgroundTransparency = Theme.tinsel and 0.35 or 0.9, BorderSizePixel = 0, ZIndex = 4,
    }, view.Window)
    if Theme.tinsel then
        view.Tinsel = create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Theme.accent), ColorSequenceKeypoint.new(0.25, Theme.gold),
                ColorSequenceKeypoint.new(0.5, Theme.lightColors[3]), ColorSequenceKeypoint.new(0.75, Theme.gold),
                ColorSequenceKeypoint.new(1, Theme.accent),
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(0.5, 0.1), NumberSequenceKeypoint.new(1, 0.7),
            }),
        }, view.Divider)
    end

    local sidebarWidth = window.Compact and Theme.compactSidebarWidth or Theme.sidebarWidth
    view.Body = create("Frame", {
        Position = UDim2.new(0, 0, 0, headerHeight + 2), Size = UDim2.new(1, 0, 1, -(headerHeight + 2)),
        BackgroundTransparency = 1, ZIndex = 3,
    }, view.Window)
    view.Sidebar = create("Frame", {
        Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(0, sidebarWidth, 1, -20),
        BackgroundColor3 = Theme.sidebar, BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = 3,
    }, view.Body)
    corner(view.Sidebar, UDim.new(0, 12))
    stroke(view.Sidebar, Theme.gold, 1, 0.86)
    view.TabList = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ZIndex = 4,
    }, view.Sidebar)
    create("UIListLayout", { Padding = UDim.new(0, window.Compact and 5 or 6), SortOrder = Enum.SortOrder.LayoutOrder }, view.TabList)
    padding(view.TabList, window.Compact and 6 or 9, window.Compact and 6 or 9, window.Compact and 7 or 9, window.Compact and 7 or 9)
    view.Content = create("Frame", {
        Position = UDim2.new(0, sidebarWidth + 20, 0, 6), Size = UDim2.new(1, -(sidebarWidth + 28), 1, -12),
        BackgroundTransparency = 1, ZIndex = 3,
    }, view.Body)
    view.PageTitle = label(view.Content, "", {
        Position = UDim2.new(0, 4, 0, 0), Size = UDim2.new(1, -8, 0, 26), FontFace = Fonts.Bold, TextSize = 13,
        TextColor3 = Theme.textMuted, Visible = false, ZIndex = 4,
    })
    view.Pages = create("Frame", {
        Position = UDim2.new(0, 0, 0, 4), Size = UDim2.new(1, 0, 1, -4), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 3,
    }, view.Content)

    view.Reopen = create("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 12), Size = UDim2.fromOffset(46, 46),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, AutoButtonColor = false, Text = "🎄",
        FontFace = Fonts.Bold, TextSize = 22, Visible = false, ZIndex = 20,
    }, view.Gui)
    corner(view.Reopen, UDim.new(1, 0))
    stroke(view.Reopen, Theme.gold, 1.5, 0.2)
    create("UIGradient", { Color = ColorSequence.new(Theme.accentHover, Theme.accentDeep), Rotation = 135 }, view.Reopen)
end

local function wireWindow(window)
    local view, options = window.View, window.Options
    connect(window, view.MinimizeButton.Activated, function() window:SetMinimized(not window.Minimized) end)
    connect(window, view.SearchButton.Activated, function()
        local open = not view.SearchBox.Visible
        view.SearchBox.Visible = open
        view.Title.Visible = not (open and Library.IsTouch)
        view.Subtitle.Visible = not open and view.Subtitle.Text ~= "" and not Library.IsTouch
        view.StatusPill.Visible = not open and not Library.IsTouch
        tween(view.SearchBox, Theme.tweenFast, { Size = UDim2.fromOffset(open and (Library.IsTouch and 130 or 170) or 0, 32) })
        if open then
            if window.Minimized then window:SetMinimized(false) end
            view.SearchBox:CaptureFocus()
        else
            view.SearchBox.Text = ""
            window:_applySearch("")
        end
    end)
    connect(window, view.SearchBox:GetPropertyChangedSignal("Text"), function() window:_applySearch(view.SearchBox.Text) end)
    if view.DiscordButton then
        connect(window, view.DiscordButton.Activated, function() safeCall(options.OnDiscord) end)
    end
    local closeArmed = false
    connect(window, view.CloseButton.Activated, function()
        if not closeArmed then
            closeArmed = true
            view.CloseButton.Text = "?"
            view.CloseButton.TextColor3 = Theme.danger
            task.delay(2.5, function()
                if not window.Destroyed and closeArmed then
                    closeArmed = false
                    view.CloseButton.Text = "×"
                    view.CloseButton.TextColor3 = Theme.gold
                end
            end)
            return
        end
        closeArmed = false
        if options.OnClose then safeCall(options.OnClose) else window:Destroy() end
    end)
    connect(window, view.Reopen.Activated, function() window:SetVisible(true) end)
    local dragging, dragStart, startPosition = false, nil, nil
    connect(window, view.Header.InputBegan, function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging, dragStart, startPosition = true, input.Position, view.Window.Position
    end)
    connect(window, UserInputService.InputChanged, function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        view.Window.Position = window:Clamp(UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y))
    end)
    connect(window, UserInputService.InputEnded, function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = false
        safeCall(options.OnPositionChanged, view.Window.Position)
    end)
    local toggleKey = options.ToggleKey
    if typeof(toggleKey) == "EnumItem" then
        connect(window, UserInputService.InputBegan, function(input, processed)
            if processed or UserInputService:GetFocusedTextBox() then return end
            if input.KeyCode == toggleKey then window:Toggle() end
        end)
    end
    if workspace.CurrentCamera then
        connect(window, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function()
            if view.Window.Parent then
                window:UpdateScale(true)
                view.Window.Position = window:Clamp(view.Window.Position)
            end
        end)
    end
    local elapsed = 0
    connect(window, RunService.Heartbeat, function(delta)
        if not view.Gui.Enabled or not view.Window.Visible then return end
        elapsed = elapsed + delta
        if elapsed < (Library.IsTouch and 0.09 or 0.05) then return end
        local step = elapsed
        elapsed = 0
        local now = os.clock()
        for _, flake in ipairs(view.Snowflakes) do
            flake.Y = flake.Y + step * flake.Speed
            if flake.Y > 1.08 then
                flake.Y = -0.08
                flake.X = 0.03 + ((flake.X + 0.41) % 0.94)
            end
            flake.Object.Position = UDim2.fromScale(flake.X + math.sin(now * 0.8 + flake.Phase) * flake.Sway, flake.Y)
            if flake.Spin then flake.Object.Rotation = (now * 22 + flake.Phase * 40) % 360 end
        end
        for _, light in ipairs(view.Lights) do
            local dim = 0.5 - 0.5 * math.sin(now * light.Rate + light.Phase)
            light.Bulb.BackgroundTransparency = 0.5 * dim
            light.Glow.Transparency = 0.3 + 0.65 * dim
        end
        if view.Tinsel then view.Tinsel.Offset = Vector2.new(math.sin(now * 0.7) * 0.4, 0) end
        view.Glow.Rotation = (now * 48) % 360
        local dot = view.StatusPill:FindFirstChild("Dot")
        if dot then dot.BackgroundTransparency = 0.15 + 0.35 * (0.5 + 0.5 * math.sin(now * 3.4)) end
    end)
end

function Library.CreateWindow(options)
    if Library.Active then Library.Active:Destroy() end
    options = type(options) == "table" and options or {}
    local window = setmetatable({
        Options = options, Connections = {}, Tabs = {}, Dropdowns = {}, Searchable = {},
        Notifications = {}, NotificationKeys = {}, NotificationOrder = 0,
        View = {}, Minimized = false, Visible = true, Destroyed = false, SearchQuery = "",
        Compact = Library.IsTouch or options.Compact == true,
    }, Window)
    Library.Active = window
    buildWindow(window)
    wireWindow(window)
    local target = window:UpdateScale(true)
    window.View.Scale.Scale = target * 0.92
    window.View.Window.Position = window:Clamp(window.View.Window.Position)
    task.defer(function()
        if not window.Destroyed and window.View.Window.Parent then
            window.View.Window.Position = window:Clamp(window.View.Window.Position)
        end
    end)
    tween(window.View.Scale, Theme.tweenSpring, { Scale = target })
    window.Gui = window.View.Gui
    window.Frame = window.View.Window
    return window
end

function Window:Ready(options)
    options = type(options) == "table" and options or {}
    if options.ActiveTab then self:SelectTab(options.ActiveTab, true) end
    if options.Minimized then self:SetMinimized(true, true) end
    return self
end

function Library.destroy()
    if Library.Active then Library.Active:Destroy() end
end

return Library
