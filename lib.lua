--v32 vertical christmas window · top tab bar · auto height · tabs/sections/elements api · search
local cloneref = cloneref or function(object) return object end
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))

local Library = {
    Name = "Zelqyn Hub",
    Version = "32",
    IsTouch = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled,
    Active = nil,
    Theme = {
        bg0 = Color3.fromRGB(9, 12, 12),
        bg1 = Color3.fromRGB(14, 18, 18),
        bg2 = Color3.fromRGB(29, 36, 35),
        bg3 = Color3.fromRGB(20, 26, 25),
        hover = Color3.fromRGB(43, 52, 50),
        segment = Color3.fromRGB(17, 22, 21),
        inputBg = Color3.fromRGB(11, 14, 14),
        border = Color3.fromRGB(255, 255, 255),
        windowTop = Color3.fromRGB(19, 23, 23),
        windowMid = Color3.fromRGB(15, 20, 19),
        windowBottom = Color3.fromRGB(12, 34, 26),
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
        cardTransparency = 0.3,
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
    },
    Profiles = {
        Desktop = {
            Width = 390, MinHeight = 280, MaxHeight = 660, Header = 50, Nav = 46, Row = 44, RowDesc = 54,
            Section = 26, Status = 40, Display = 74, Button = 40, Input = 30, Field = 34, ToggleW = 42, ToggleH = 22, Knob = 16,
            Text = 13, Small = 11, Title = 15, HeaderButton = 28, Gap = 7, Pad = 11, Corner = 10, Compact = false,
        },
        Touch = {
            Width = 346, MinHeight = 260, MaxHeight = 500, Header = 48, Nav = 46, Row = 42, RowDesc = 52,
            Section = 24, Status = 38, Display = 70, Button = 40, Input = 30, Field = 34, ToggleW = 42, ToggleH = 22, Knob = 16,
            Text = 13, Small = 11, Title = 14, HeaderButton = 28, Gap = 6, Pad = 10, Corner = 10, Compact = true,
        },
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
        Color = color or Theme.border, Thickness = thickness or 1,
        Transparency = transparency or Theme.borderTransparency, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
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
    corner(host, UDim.new(0, radius or 10))
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

local function makePill(parent, value, tone, position, height, zIndex, withDot, textSize)
    local pill = label(parent, value, {
        AnchorPoint = Vector2.new(1, 0.5), Position = position or UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 0, 0, height or 20), AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 0.2, BackgroundColor3 = Theme.bg0,
        FontFace = Fonts.SemiBold, TextSize = textSize or 10,
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
    local M = self.M
    local target
    if M.Compact then
        local shortSide = math.min(viewport.X, viewport.Y)
        target = math.clamp(math.min(shortSide / 500, (viewport.X - 24) / M.Width, 0.85), 0.6, 0.85)
    else
        local height = self.CurrentHeight or M.MaxHeight
        local fit = math.min((viewport.X - 20) / M.Width, (viewport.Y - 20) / height)
        target = math.clamp(math.min(fit, math.clamp(viewport.Y / 960, 0.68, 0.9)), 0.58, 0.9)
    end
    self.ScaleValue = target
    if self.View.NotificationScale then self.View.NotificationScale.Scale = M.Compact and target or 1 end
    if instant then
        self.View.Scale.Scale = target
    else
        tween(self.View.Scale, Theme.tweenMed, { Scale = target })
    end
    return target
end

function Window:_maxHeight()
    local M = self.M
    if not M.Compact then return M.MaxHeight end
    local fit = math.floor(viewportSize().Y * 0.82 / math.max(self.ScaleValue or 0.85, 0.01))
    return math.max(M.MinHeight, math.min(M.MaxHeight, fit))
end

function Window:_desiredHeight()
    local M = self.M
    if self.Minimized then return M.Header end
    local tab = self.ActiveTab
    if not tab then return M.MinHeight end
    local scale = math.max(self.View.Scale.Scale, 0.01)
    local content = tab.Layout.AbsoluteContentSize.Y / scale + M.Pad * 2
    local height = M.Header + M.Nav + 2 + content
    return math.clamp(math.floor(height + 0.5), M.MinHeight, self:_maxHeight())
end

function Window:Resize(instant)
    if self.Destroyed then return end
    local height = self:_desiredHeight()
    self.CurrentHeight = height
    local size = UDim2.new(0, self.M.Width, 0, height)
    if instant then
        self.View.Window.Size = size
        self.View.Window.Position = self:Clamp(self.View.Window.Position)
        return
    end
    if self.View.Window.Size == size then return end
    local resize = tween(self.View.Window, Theme.tweenMed, { Size = size })
    resize.Completed:Connect(function()
        if not self.Destroyed then self.View.Window.Position = self:Clamp(self.View.Window.Position) end
    end)
end

function Window:_queueResize()
    if self.ResizeQueued or self.Destroyed then return end
    self.ResizeQueued = true
    task.defer(function()
        self.ResizeQueued = false
        if not self.Destroyed then self:Resize(false) end
    end)
end

function Window:SetMinimized(value, instant)
    self.Minimized = value == true
    self.View.Nav.Visible = not self.Minimized
    self.View.Divider.Visible = not self.Minimized
    self.View.Content.Visible = not self.Minimized
    self.View.MinimizeButton.Text = self.Minimized and "+" or "—"
    self:Resize(instant)
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
    local count = #self.Tabs
    for _, other in ipairs(self.Tabs) do
        local active = other == tab
        other.Page.Visible = active
        local textColor = active and Theme.activeTabText or (other.Dimmed and Theme.textDim or Theme.textMuted)
        for _, part in ipairs(other.Labels) do
            if part:IsA("TextLabel") then
                if instant then part.TextColor3 = textColor else tween(part, Theme.tweenFast, { TextColor3 = textColor }) end
                part.FontFace = active and Fonts.SemiBold or Fonts.Medium
            end
        end
    end
    local position = UDim2.new((tab.Index - 1) / math.max(count, 1), 1, 0, 0)
    self.View.TabHighlight.Size = UDim2.new(1 / math.max(count, 1), -2, 1, 0)
    if instant then
        self.View.TabHighlight.Position = position
    else
        tween(self.View.TabHighlight, Theme.tweenSlide, { Position = position })
    end
    self.View.Mode.Text = tab.Subtitle
    for _, dropdown in ipairs(self.Dropdowns) do dropdown:SetOpen(false) end
    self:Resize(instant)
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
    setPill(self.View.StatusPill, tostring(badge or text or "Online"), resolveTone(tone, Theme.success))
end

function Window:SetSubtitle(text)
    self.Options.Subtitle = tostring(text or "")
    if self.ActiveTab and self.ActiveTab.SubtitleIsDefault then self.View.Mode.Text = self.Options.Subtitle end
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

local function noticeOffscreen(window)
    local scale = window.View.NotificationScale and window.View.NotificationScale.Scale or 1
    return UDim2.new(0, viewportSize().X / math.max(scale, 0.01), 1, 0)
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
    tween(entry.Card, Theme.tweenNoticeOut, { Position = noticeOffscreen(self) })
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
    self.View.NotificationScale = create("UIScale", { Scale = self.M.Compact and (self.ScaleValue or 0.85) or 1 }, list)
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
        AnchorPoint = Vector2.new(0, 1), Position = noticeOffscreen(self),
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.bg1, BackgroundTransparency = 0.03, BorderSizePixel = 0, Active = true,
    }, holder)
    corner(card, UDim.new(0, 12))
    stroke(card, Theme.border, 1, 0.86)
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
    local M = window.M
    local section = setmetatable({
        Window = window, Tab = self, Entries = {}, Order = 0, Collapsed = false,
        SearchTitle = string.lower(tostring(options.Title or "")),
    }, Section)
    local frame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
        BorderSizePixel = 0, LayoutOrder = #self.Sections + 1, ZIndex = 3,
    }, self.Page)
    create("UIListLayout", { Padding = UDim.new(0, M.Gap - 1), SortOrder = Enum.SortOrder.LayoutOrder }, frame)
    local titled = tostring(options.Title or "") ~= ""
    local header = create("TextButton", {
        Size = UDim2.new(1, 0, 0, M.Section), BackgroundTransparency = 1, AutoButtonColor = false, Text = "",
        LayoutOrder = 0, ZIndex = 4, Visible = titled,
    }, frame)
    local bar = create("Frame", {
        Position = UDim2.new(0, 2, 0.5, -7), Size = UDim2.new(0, 3, 0, 14),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 5,
    }, header)
    corner(bar, UDim.new(1, 0))
    create("UIGradient", { Color = ColorSequence.new(Theme.gold, Theme.accent), Rotation = 90 }, bar)
    local titleX = 12
    if options.Icon then
        iconObject(header, options.Icon, {
            Size = UDim2.fromOffset(16, 16), Position = UDim2.new(0, 11, 0.5, -8), TextSize = 12,
            TextColor3 = Theme.gold, ZIndex = 5,
        })
        titleX = 31
    end
    label(header, string.upper(tostring(options.Title or "")), {
        Position = UDim2.new(0, titleX, 0, 0), Size = UDim2.new(1, -(titleX + 30), 1, 0),
        FontFace = Fonts.Bold, TextSize = M.Small + 1, TextColor3 = Theme.gold, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
    })
    local line = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -26, 0.5, 0), Size = UDim2.new(0.28, 0, 0, 1),
        BackgroundColor3 = Theme.gold, BackgroundTransparency = 0.7, BorderSizePixel = 0, ZIndex = 4,
    }, header)
    create("UIGradient", {
        Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }),
    }, line)
    local chevron = label(header, "▲", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -4, 0.5, 0), Size = UDim2.fromOffset(16, 16),
        FontFace = Fonts.Bold, TextSize = 10, TextColor3 = Theme.gold, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 5,
    })
    chevron.Visible = options.Collapsible ~= false
    local content = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 1, ZIndex = 4,
    }, frame)
    create("UIListLayout", { Padding = UDim.new(0, M.Gap), SortOrder = Enum.SortOrder.LayoutOrder }, content)
    section.Frame, section.Content, section.Chevron = frame, content, chevron
    function section:SetCollapsed(collapsed, instant)
        self.Collapsed = collapsed == true
        self.Content.Visible = not self.Collapsed
        self.Chevron.Text = self.Collapsed and "▼" or "▲"
        if not instant then
            self.Chevron.TextTransparency = 0.6
            tween(self.Chevron, Theme.tweenFast, { TextTransparency = 0 })
        end
    end
    if options.Collapsible ~= false and titled then
        connect(window, header.Activated, function()
            section.ExpandedBySearch = false
            section:SetCollapsed(not section.Collapsed)
        end)
    end
    section:SetCollapsed(options.Opened == false and options.Collapsible ~= false and titled, true)
    table.insert(self.Sections, section)
    return section
end

function Section:_nextOrder()
    self.Order = self.Order + 1
    return self.Order
end

function Section:_card(height)
    local M = self.Window.M
    local card = create("Frame", {
        Size = UDim2.new(1, 0, 0, height or M.Row), BackgroundColor3 = Theme.bg2,
        BackgroundTransparency = Theme.cardTransparency, BorderSizePixel = 0, LayoutOrder = self:_nextOrder(), ZIndex = 4,
    }, self.Content)
    corner(card, UDim.new(0, M.Corner))
    stroke(card)
    return card
end

function Section:_titled(card, options, rightInset)
    local M = self.Window.M
    local description = type(options.Description) == "string" and options.Description ~= "" and options.Description or nil
    local title = label(card, tostring(options.Title or ""), {
        Position = UDim2.new(0, 12, 0, description and 8 or 0),
        Size = UDim2.new(1, -(rightInset + 24), 0, description and 18 or card.Size.Y.Offset),
        FontFace = Fonts.Medium, TextSize = M.Text, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
    })
    local descriptionLabel
    if description then
        descriptionLabel = label(card, description, {
            Position = UDim2.new(0, 12, 0, 27), Size = UDim2.new(1, -(rightInset + 24), 0, 16),
            FontFace = Fonts.Regular, TextSize = M.Small, TextColor3 = Theme.textMuted, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
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

local function hasDescription(options)
    return type(options.Description) == "string" and options.Description ~= ""
end

local function setToggleVisual(control, enabled, instant)
    control.Value = enabled == true
    local on = control.Value
    local trackColor = on and (control.Candy and Color3.new(1, 1, 1) or Theme.toggleOn) or Theme.toggleOff
    if control.Candy and (on or instant) then control.Candy.Enabled = on end
    local knobPosition = on and UDim2.new(0, control.TrackWidth - control.KnobSize - 3, 0.5, -control.KnobSize / 2)
        or UDim2.new(0, 3, 0.5, -control.KnobSize / 2)
    local outlineColor = on and Theme.accent or Theme.border
    local outlineTransparency = on and 0.72 or Theme.borderTransparency
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
    local M = window.M
    local card = self:_card(hasDescription(options) and M.RowDesc or M.Row)
    self:_titled(card, options, M.ToggleW + 10)
    local track = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.new(0, M.ToggleW, 0, M.ToggleH), BackgroundColor3 = Theme.toggleOff, BorderSizePixel = 0, ZIndex = 5,
    }, card)
    corner(track, UDim.new(1, 0))
    local candy = Theme.candyToggles and create("UIGradient", { Color = candyStripes(6), Rotation = 35, Enabled = false }, track) or nil
    stroke(track, Theme.border, 1, 0.9)
    local knob = create("Frame", {
        Size = UDim2.new(0, M.Knob, 0, M.Knob), BackgroundColor3 = Theme.knob, BorderSizePixel = 0, ZIndex = 6,
    }, track)
    corner(knob, UDim.new(1, 0))
    stroke(knob, Color3.new(0, 0, 0), 1, 0.82)
    local button = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, AutoButtonColor = false, Text = "", ZIndex = 7,
    }, card)
    ripple(window, button, M.Corner)
    local entry = window:_register(self, card, tostring(options.Title or "") .. " " .. tostring(options.Description or ""))
    local control = elementBase(entry, card)
    control.Track, control.Knob, control.KnobScale = track, knob, create("UIScale", {}, knob)
    control.Outline, control.Candy = card:FindFirstChildOfClass("UIStroke"), candy
    control.TrackWidth, control.KnobSize = M.ToggleW, M.Knob
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
    local M = window.M
    local variant = options.Variant or (options.Primary and "primary") or "default"
    local primary = variant == "primary"
    local card = create("Frame", {
        Size = options.Size or UDim2.new(1, 0, 0, options.Height or M.Button),
        Position = options.Position or UDim2.new(), BackgroundColor3 = primary and Color3.new(1, 1, 1) or Theme.bg2,
        BackgroundTransparency = primary and 0 or Theme.cardTransparency, BorderSizePixel = 0, LayoutOrder = order or 0, ZIndex = 4,
    }, parent)
    corner(card, UDim.new(0, M.Corner))
    local outline = stroke(card, primary and Theme.gold or Theme.border, 1, primary and 0.5 or Theme.borderTransparency)
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
        FontFace = Fonts.SemiBold, TextSize = options.TextSize or M.Text, TextColor3 = control.RestText,
        Text = tostring(options.Title or ""), TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 6,
    }, card)
    padding(button, 6, 6, 0, 0)
    control.Button = button
    local scale = create("UIScale", {}, button)
    ripple(window, button, M.Corner)
    local hoverColor = primary and Color3.new(1, 1, 1) or Theme.hover
    connect(window, button.MouseEnter, function()
        if not control.Enabled then return end
        tween(card, Theme.tweenFast, { BackgroundColor3 = hoverColor })
        tween(scale, Theme.tweenFast, { Scale = 1.015 })
        tween(outline, Theme.tweenFast, { Transparency = primary and 0.3 or 0.8 })
    end)
    connect(window, button.MouseLeave, function()
        tween(card, Theme.tweenFast, { BackgroundColor3 = control.RestColor })
        tween(scale, Theme.tweenFast, { Scale = 1 })
        tween(outline, Theme.tweenFast, { Transparency = primary and 0.5 or Theme.borderTransparency })
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
        self.Button.Active = self.Enabled
        self.Button.TextTransparency = self.Enabled and 0 or 0.35
    end
    return control
end

function Section:Button(options)
    local window = self.Window
    local control = buttonCard(window, self.Content, options, self:_nextOrder())
    local entry = window:_register(self, control.Frame, options.Title)
    control.SetVisible = elementBase(entry, control.Frame).SetVisible
    return control
end

function Section:Buttons(list)
    local window = self.Window
    local M = window.M
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, M.Button), BackgroundTransparency = 1, LayoutOrder = self:_nextOrder(), ZIndex = 4,
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
    local M = window.M
    local field = create("Frame", {
        AnchorPoint = options.Anchor or Vector2.new(), Position = position, Size = size,
        BackgroundColor3 = Theme.inputBg, BackgroundTransparency = Theme.inputTransparency, BorderSizePixel = 0,
        ClipsDescendants = true, ZIndex = 5,
    }, parent)
    corner(field, UDim.new(0, 8))
    local outline = stroke(field, Theme.border, 1, 0.9)
    local box = create("TextBox", {
        Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -16, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
        ClearTextOnFocus = false, MultiLine = options.MultiLine == true, TextWrapped = options.MultiLine == true,
        FontFace = Fonts.Medium, TextSize = options.TextSize or M.Text, TextColor3 = Theme.textPri,
        PlaceholderText = tostring(options.Placeholder or ""), PlaceholderColor3 = Theme.textDim,
        TextXAlignment = options.Align or Enum.TextXAlignment.Left,
        TextYAlignment = options.MultiLine and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
        Text = tostring(options.Value or ""), ClipsDescendants = true, ZIndex = 6,
    }, field)
    if options.MultiLine then
        padding(box, 2, 2, 8, 8)
    else
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
    local M = window.M
    local stacked = options.Stacked == true
    local described = hasDescription(options)
    local width = options.Width or 96
    local box
    local card
    if stacked then
        local top = described and 46 or 34
        card = self:_card(top + M.Field + 8)
        self:_titled(card, { Title = options.Title, Description = options.Description }, 0)
        for _, child in ipairs(card:GetChildren()) do
            if child:IsA("TextLabel") and child.Text == tostring(options.Title or "") and not described then
                child.Size = UDim2.new(1, -24, 0, 32)
            end
        end
        box = select(2, inputField(window, card, options, UDim2.new(0, 10, 0, top), UDim2.new(1, -20, 0, M.Field)))
    else
        card = self:_card(described and M.RowDesc or M.Row)
        self:_titled(card, options, width + 8)
        options.Anchor = Vector2.new(1, 0.5)
        box = select(2, inputField(window, card, options, UDim2.new(1, -10, 0.5, 0), UDim2.new(0, width, 0, M.Input)))
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
    local M = window.M
    local height = options.Height or 82
    local titled = options.Title and tostring(options.Title) ~= ""
    local card = self:_card(height + (titled and 44 or 20))
    card.ClipsDescendants = true
    if titled then
        label(card, tostring(options.Title), {
            Position = UDim2.new(0, 12, 0, 5), Size = UDim2.new(1, -24, 0, 26),
            FontFace = Fonts.SemiBold, TextSize = M.Text - 1, ZIndex = 5,
        })
    end
    options.MultiLine = true
    local _, box = inputField(window, card, options, UDim2.new(0, 10, 0, titled and 34 or 10), UDim2.new(1, -20, 0, height))
    local entry = window:_register(self, card, options.Title)
    local control = elementBase(entry, card)
    control.TextBox = box
    function control:Set(value) box.Text = tostring(value or "") end
    function control:Get() return box.Text end
    return control
end

function Section:Segmented(options)
    local window = self.Window
    local M = window.M
    local items = options.Options or { "Low", "Medium", "High" }
    local width = options.Width or 186
    local card = self:_card(M.Row)
    self:_titled(card, options, width + 8)
    local frame = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.new(0, width, 0, M.Row - 14),
        BackgroundColor3 = Theme.segment, BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 5,
    }, card)
    corner(frame, UDim.new(0, 10))
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
    local M = window.M
    local items = {}
    for _, item in ipairs(options.Options or {}) do
        items[#items + 1] = type(item) == "table" and { Text = tostring(item.Text or item.Value), Value = item.Value }
            or { Text = tostring(item), Value = item }
    end
    local width, rowHeight = options.Width or 150, 32
    local card = self:_card(M.Row)
    card.ClipsDescendants = true
    self:_titled(card, options, width + 8)
    local head = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, (M.Row - M.Input) / 2), Size = UDim2.new(0, width, 0, M.Input),
        BackgroundColor3 = Theme.inputBg, BackgroundTransparency = Theme.inputTransparency, AutoButtonColor = false,
        FontFace = Fonts.SemiBold, TextSize = 12, TextColor3 = Theme.gold, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 6,
    }, card)
    corner(head, UDim.new(0, 8))
    stroke(head, Theme.border, 1, 0.88)
    local menu = create("Frame", {
        Position = UDim2.new(0, 10, 0, M.Row + 2), Size = UDim2.new(1, -20, 0, #items * (rowHeight + 4)),
        BackgroundTransparency = 1, Visible = false, ZIndex = 6,
    }, card)
    create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, menu)
    local texts = {}
    for _, item in ipairs(items) do texts[#texts + 1] = item.Text end
    local entry = window:_register(self, card, tostring(options.Title or "") .. " " .. table.concat(texts, " "))
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
        card.Size = UDim2.new(1, 0, 0, self.Open and M.Row + 8 + #items * (rowHeight + 4) or M.Row)
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
        corner(button, UDim.new(0, 8))
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
    local M = window.M
    local minimum, maximum = tonumber(options.Min) or 0, tonumber(options.Max) or 100
    local step = tonumber(options.Step) or 1
    local card = self:_card(M.Row + 14)
    label(card, tostring(options.Title or ""), {
        Position = UDim2.new(0, 12, 0, 6), Size = UDim2.new(1, -90, 0, 20), FontFace = Fonts.Medium, TextSize = M.Text, ZIndex = 5,
    })
    local valueLabel = label(card, "", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 6), Size = UDim2.new(0, 70, 0, 20),
        FontFace = Fonts.SemiBold, TextSize = 12, TextColor3 = Theme.gold, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 5,
    })
    local bar = create("Frame", {
        Position = UDim2.new(0, 12, 0, M.Row - 6), Size = UDim2.new(1, -24, 0, 6), BackgroundColor3 = Theme.toggleOff,
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
        Position = UDim2.new(0, 0, 0, M.Row - 16), Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Text = "", ZIndex = 8,
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
    local M = window.M
    local card = self:_card(hasDescription(options) and M.RowDesc or M.Row)
    self:_titled(card, options, 112)
    local keyButton = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -42, 0.5, 0), Size = UDim2.new(0, 66, 0, 28),
        BackgroundColor3 = Theme.inputBg, BackgroundTransparency = Theme.inputTransparency, BorderSizePixel = 0,
        AutoButtonColor = false, FontFace = Fonts.SemiBold, TextSize = 12, TextColor3 = Theme.accentText, ZIndex = 6,
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
        keyButton.TextColor3 = Theme.accentText
        if fire then safeCall(options.Callback, key) end
    end
    function control:Get() return self.Value end
    connect(window, keyButton.Activated, function()
        control.Waiting = not control.Waiting
        keyButton.Text = control.Waiting and "PRESS..." or control.Value.Name
        keyButton.TextColor3 = control.Waiting and Theme.warning or Theme.accentText
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
    local M = window.M
    local card = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.bg2,
        BackgroundTransparency = Theme.cardTransparency, BorderSizePixel = 0, LayoutOrder = self:_nextOrder(), ZIndex = 4,
    }, self.Content)
    corner(card, UDim.new(0, M.Corner))
    stroke(card)
    padding(card, 18, 12, 9, 10)
    local bar = create("Frame", {
        Size = UDim2.new(0, 2, 1, -2), Position = UDim2.new(0, -10, 0, 1),
        BackgroundColor3 = Theme.accent, BorderSizePixel = 0, ZIndex = 5,
    }, card)
    corner(bar, UDim.new(1, 0))
    local column = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 5,
    }, card)
    create("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }, column)
    local title = label(column, tostring(options.Title or ""), {
        Position = UDim2.new(), Size = UDim2.new(1, 0, 0, 18), FontFace = Fonts.SemiBold, TextSize = M.Text,
        LayoutOrder = 1, ZIndex = 5,
    })
    title.Visible = title.Text ~= ""
    local body = label(column, tostring(options.Content or ""), {
        Position = UDim2.new(), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        FontFace = Fonts.Regular, TextSize = M.Small + 1, TextColor3 = Theme.textMuted, TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = 2, ZIndex = 5,
    })
    local entry = window:_register(self, card, tostring(options.Title or "") .. " " .. tostring(options.Content or ""))
    local control = elementBase(entry, card)
    function control:Set(newTitle, newContent)
        if newTitle ~= nil then
            title.Text = tostring(newTitle)
            title.Visible = title.Text ~= ""
        end
        if newContent ~= nil then body.Text = tostring(newContent) end
    end
    return control
end

function Section:Status(options)
    options = type(options) == "table" and options or { Text = tostring(options or "") }
    local window = self.Window
    local M = window.M
    local card = self:_card(M.Status)
    card.BackgroundColor3 = Theme.bg3
    local text = label(card, tostring(options.Text or ""), {
        FontFace = Fonts.SemiBold, TextSize = 12,
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
    local M = window.M
    local card = self:_card(M.Display)
    label(card, tostring(options.Title or ""), {
        Position = UDim2.new(0, 12, 0, 6), Size = UDim2.new(1, -110, 0, 18),
        FontFace = Fonts.SemiBold, TextSize = 11, TextColor3 = Theme.textMuted, ZIndex = 5,
    })
    local badge = makePill(card, tostring(options.Badge or ""), Theme.textDim, UDim2.new(1, -10, 0, 15), 18, 6, true)
    badge.Visible = options.Badge ~= nil
    local box = create("Frame", {
        Position = UDim2.new(0, 10, 0, 28), Size = UDim2.new(1, -20, 0, M.Display - 36), BackgroundColor3 = Theme.inputBg,
        BackgroundTransparency = Theme.inputTransparency, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 5,
    }, card)
    corner(box, UDim.new(0, 8))
    stroke(box, Theme.border, 1, 0.92)
    local bar = create("Frame", {
        Size = UDim2.new(0, 2, 1, -14), Position = UDim2.new(0, 8, 0, 7), BackgroundColor3 = Theme.accent, BorderSizePixel = 0, ZIndex = 6,
    }, box)
    corner(bar, UDim.new(1, 0))
    local message = label(box, "", {
        Size = UDim2.new(1, -28, 1, 0), Position = UDim2.new(0, 18, 0, 0), TextSize = M.Text,
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
    local M = window.M
    local height = options.Height or 260
    local card = self:_card(height + 36)
    label(card, tostring(options.Title or "Activity Log"), {
        Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -110, 0, 30), FontFace = Fonts.SemiBold, TextSize = 12, ZIndex = 5,
    })
    local count = label(card, "0 lines", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 0), Size = UDim2.new(0, 90, 0, 30),
        TextSize = 11, TextColor3 = Theme.textDim, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 5,
    })
    local scroll = create("ScrollingFrame", {
        Position = UDim2.new(0, 8, 0, 30), Size = UDim2.new(1, -16, 0, height),
        BackgroundColor3 = Theme.bg0, BackgroundTransparency = 0.3, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.border, ScrollBarImageTransparency = 0.72,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ClipsDescendants = true, ZIndex = 5,
    }, card)
    corner(scroll, UDim.new(0, 8))
    stroke(scroll)
    create("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }, scroll)
    padding(scroll, 10, 10, 8, 8)
    local entry = window:_register(self, card, tostring(options.Title or "Activity Log"))
    local control = elementBase(entry, card)
    control.Labels, control.Max = {}, options.MaxLines or (M.Compact and 80 or 140)
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
    local M = self.M
    local index = #self.Tabs + 1
    local tab = setmetatable({
        Window = self, Index = index, Title = tostring(options.Title or ("Tab " .. index)), Sections = {}, Labels = {},
        Subtitle = tostring(options.Subtitle or options.Title or ""), SubtitleIsDefault = options.Subtitle == nil,
    }, Tab)
    local button = create("TextButton", {
        BackgroundTransparency = 1, BorderSizePixel = 0, AutoButtonColor = false, Text = "", ZIndex = 7,
    }, self.View.Segment)
    tab.Button = button
    local short = tostring(options.Short or tab.Title)
    if options.Icon then
        tab.Labels[#tab.Labels + 1] = iconObject(button, options.Icon, {
            Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 0, 3), TextSize = 13, TextColor3 = Theme.textMuted, ZIndex = 8,
        })
        local text = label(button, short, {
            Size = UDim2.new(1, -4, 0, 13), Position = UDim2.new(0, 2, 1, -16), FontFace = Fonts.Medium, TextScaled = true,
            TextColor3 = Theme.textMuted, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 8,
        })
        create("UITextSizeConstraint", { MinTextSize = 7, MaxTextSize = 10 }, text)
        tab.Labels[#tab.Labels + 1] = text
    else
        local text = label(button, short, {
            Size = UDim2.new(1, -4, 1, 0), Position = UDim2.new(0, 2, 0, 0), FontFace = Fonts.Medium, TextScaled = true,
            TextColor3 = Theme.textMuted, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 8,
        })
        create("UITextSizeConstraint", { MinTextSize = 8, MaxTextSize = 12 }, text)
        tab.Labels[#tab.Labels + 1] = text
    end
    tab.Page = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
        ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.border, ScrollBarImageTransparency = 0.7,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 3,
    }, self.View.Content)
    tab.Layout = create("UIListLayout", {
        Padding = UDim.new(0, M.Gap + 3), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center,
    }, tab.Page)
    padding(tab.Page, M.Pad, M.Pad, M.Pad - 2, M.Pad)
    connect(self, tab.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        if self.ActiveTab == tab then self:_queueResize() end
    end)
    connect(self, button.Activated, function()
        if self.ActiveTab == tab then return end
        self:SelectTab(tab)
        safeCall(self.Options.OnTabChanged, tab.Index, tab.Title)
    end)
    connect(self, button.MouseEnter, function()
        if self.ActiveTab ~= tab then
            for _, part in ipairs(tab.Labels) do
                if part:IsA("TextLabel") then tween(part, Theme.tweenFast, { TextColor3 = Theme.textPri }) end
            end
        end
    end)
    connect(self, button.MouseLeave, function()
        if self.ActiveTab ~= tab then
            for _, part in ipairs(tab.Labels) do
                if part:IsA("TextLabel") then tween(part, Theme.tweenFast, { TextColor3 = tab.Dimmed and Theme.textDim or Theme.textMuted }) end
            end
        end
    end)
    table.insert(self.Tabs, tab)
    local count = #self.Tabs
    for position, other in ipairs(self.Tabs) do
        other.Button.Size = UDim2.new(1 / count, -2, 1, 0)
        other.Button.Position = UDim2.new((position - 1) / count, 1, 0, 0)
    end
    if index == 1 then
        self:SelectTab(tab, true)
    else
        self:SelectTab(self.ActiveTab, true)
    end
    return tab
end

local function headerButton(window, parent, text, order)
    local M = window.M
    local button = create("TextButton", {
        Size = UDim2.fromOffset(M.HeaderButton, M.HeaderButton), BackgroundColor3 = Theme.hover, BackgroundTransparency = 1,
        BorderSizePixel = 0, AutoButtonColor = false, FontFace = Fonts.SemiBold, TextSize = 14,
        TextColor3 = Theme.textMuted, Text = text, LayoutOrder = order, ZIndex = 6,
    }, parent)
    corner(button, UDim.new(0, 8))
    connect(window, button.MouseEnter, function()
        tween(button, Theme.tweenFast, { BackgroundTransparency = 0.55, TextColor3 = Theme.textPri })
    end)
    connect(window, button.MouseLeave, function()
        tween(button, Theme.tweenFast, { BackgroundTransparency = 1, TextColor3 = Theme.textMuted })
    end)
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
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.42, 0.9), NumberSequenceKeypoint.new(1, 1),
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
            { 0.06, -0.10, 16, 0.040, 0.020, 0.30 }, { 0.21, 0.22, 11, 0.028, 0.014, 0.50 },
            { 0.37, -0.34, 19, 0.034, 0.024, 0.28 }, { 0.55, 0.05, 13, 0.044, 0.016, 0.42 },
            { 0.72, -0.24, 17, 0.031, 0.022, 0.34 }, { 0.90, 0.30, 12, 0.039, 0.015, 0.48 },
            { 0.14, 0.58, 14, 0.036, 0.018, 0.40 }, { 0.47, 0.70, 18, 0.042, 0.020, 0.32 },
            { 0.80, 0.52, 15, 0.030, 0.017, 0.38 }, { 0.30, 0.86, 10, 0.026, 0.012, 0.55 },
            { 0.10, 0.36, 0, 0.022, 0.010, 0.45 }, { 0.33, 0.12, 0, 0.025, 0.012, 0.55 },
            { 0.52, 0.44, 0, 0.020, 0.010, 0.50 }, { 0.66, 0.80, 0, 0.027, 0.014, 0.45 },
            { 0.86, 0.06, 0, 0.023, 0.011, 0.55 }, { 0.96, 0.66, 0, 0.021, 0.012, 0.50 },
            { 0.62, 0.26, 14, 0.033, 0.019, 0.36 }, { 0.04, 0.78, 0, 0.024, 0.011, 0.50 },
            { 0.42, 0.94, 0, 0.026, 0.013, 0.48 }, { 0.75, 0.40, 0, 0.022, 0.010, 0.52 },
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
            { 0.12, 58, 16, 0.80 }, { 0.27, 74, 20, 0.84 }, { 0.43, 54, 14, 0.80 }, { 0.58, 80, 22, 0.85 },
            { 0.74, 60, 16, 0.81 }, { 0.88, 50, 14, 0.83 },
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
            BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 3,
        }, view.Window)
        create("Frame", {
            Name = "Wire", Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 1),
            BackgroundColor3 = Color3.fromRGB(52, 98, 68), BorderSizePixel = 0, ZIndex = 3,
        }, garland)
        local count = window.M.Compact and 14 or 16
        for index = 1, count do
            local color = Theme.lightColors[(index - 1) % #Theme.lightColors + 1]
            local drop = index % 2 == 0 and 2 or 0
            local x = (index - 0.5) / count
            create("Frame", {
                Name = "Socket", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(x, 0, 0, 1),
                Size = UDim2.fromOffset(2, drop + 2), BackgroundColor3 = Color3.fromRGB(52, 98, 68), BorderSizePixel = 0, ZIndex = 3,
            }, garland)
            local bulb = create("Frame", {
                Name = "Bulb", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(x, 0, 0, 2 + drop),
                Size = UDim2.fromOffset(5, 7), BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3,
            }, garland)
            corner(bulb, UDim.new(1, 0))
            view.Lights[index] = { Bulb = bulb, Glow = stroke(bulb, color, 2, 0.45), Phase = index * 1.9, Rate = 1.6 + (index % 3) * 0.55 }
        end
    end
    local border = create("UIStroke", {
        Color = Color3.new(1, 1, 1), Thickness = 1, Transparency = 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, LineJoinMode = Enum.LineJoinMode.Round,
    }, view.Window)
    view.Glow = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.42, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Theme.gold), ColorSequenceKeypoint.new(0.58, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.86), NumberSequenceKeypoint.new(0.4, 0.86),
            NumberSequenceKeypoint.new(0.5, 0.3), NumberSequenceKeypoint.new(0.6, 0.86), NumberSequenceKeypoint.new(1, 0.86),
        }),
    }, border)
end

local function buildWindow(window)
    local view, options, M = window.View, window.Options, window.M
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
    local startHeight = math.floor((M.MinHeight + M.MaxHeight) / 2)
    window.CurrentHeight = startHeight
    view.Window = create("Frame", {
        Name = "Window", Size = UDim2.new(0, M.Width, 0, startHeight),
        Position = options.Position or UDim2.new(0.5, -M.Width / 2, 0.5, -startHeight / 2),
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

    local headerHeight = M.Header
    view.Header = create("Frame", {
        Size = UDim2.new(1, 0, 0, headerHeight), BackgroundTransparency = 1, BorderSizePixel = 0, Active = true, ZIndex = 4,
    }, view.Window)
    local mark = create("Frame", {
        Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(0, 12, 0.5, -15),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 5,
    }, view.Header)
    corner(mark, UDim.new(0, 9))
    stroke(mark, Theme.gold, 1, 0.45)
    create("UIGradient", { Color = ColorSequence.new(Theme.accentHover, Theme.accentDeep), Rotation = 135 }, mark)
    if type(options.Logo) == "string" and options.Logo:find("^rbxasset") then
        create("ImageLabel", {
            Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2), BackgroundTransparency = 1,
            Image = options.Logo, ScaleType = Enum.ScaleType.Fit, ZIndex = 6,
        }, mark)
    else
        label(mark, tostring(options.Logo or "Z"), {
            Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(), FontFace = Fonts.Bold, TextSize = 16,
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
    view.TitleBlock = create("Frame", {
        Position = UDim2.new(0, 52, 0, 0), Size = UDim2.new(0, 190, 1, 0), BackgroundTransparency = 1, ZIndex = 5,
    }, view.Header)
    view.Title = label(view.TitleBlock, tostring(options.Title or Library.Name) .. "  🎄", {
        Position = UDim2.new(0, 0, 0, headerHeight / 2 - 17), Size = UDim2.new(1, 0, 0, 18),
        FontFace = Fonts.SemiBold, TextSize = M.Title, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
    })
    view.Mode = label(view.TitleBlock, tostring(options.Subtitle or ""), {
        Position = UDim2.new(0, 0, 0, headerHeight / 2 + 2), Size = UDim2.new(1, 0, 0, 14),
        TextSize = 11, TextColor3 = Theme.textMuted, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
    })
    view.SearchBox = create("TextBox", {
        Position = UDim2.new(0, 52, 0.5, -15), Size = UDim2.new(0, 0, 0, 30), BackgroundColor3 = Theme.inputBg,
        BackgroundTransparency = 0.15, BorderSizePixel = 0, ClearTextOnFocus = false, FontFace = Fonts.Medium, TextSize = 13,
        TextColor3 = Theme.textPri, Text = "", PlaceholderText = "Search...", PlaceholderColor3 = Theme.textDim,
        TextXAlignment = Enum.TextXAlignment.Left, Visible = false, ClipsDescendants = true, ZIndex = 6,
    }, view.Header)
    corner(view.SearchBox, UDim.new(0, 8))
    stroke(view.SearchBox, Theme.gold, 1, 0.6)
    padding(view.SearchBox, 10, 10, 0, 0)

    local controls = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.new(0, 0, 0, M.HeaderButton),
        AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, ZIndex = 5,
    }, view.Header)
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center, HorizontalAlignment = Enum.HorizontalAlignment.Right,
    }, controls)
    view.Controls = controls
    view.StatusPill = makePill(controls, "Online", Theme.success, nil, 22, 6, true)
    view.StatusPill.AnchorPoint = Vector2.new()
    view.StatusPill.LayoutOrder = 0
    view.StatusPill.Visible = not M.Compact
    create("Frame", { Size = UDim2.fromOffset(4, 1), BackgroundTransparency = 1, LayoutOrder = 1 }, controls)
    view.SearchButton = headerButton(window, controls, "🔍", 2)
    view.SearchButton.TextSize = 12
    if options.OnDiscord then view.DiscordButton = headerButton(window, controls, "💬", 3) end
    view.MinimizeButton = headerButton(window, controls, "—", 4)
    view.CloseButton = headerButton(window, controls, "×", 5)
    view.CloseButton.TextSize = 17

    view.Nav = create("Frame", {
        Position = UDim2.new(0, 0, 0, headerHeight), Size = UDim2.new(1, 0, 0, M.Nav),
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 4,
    }, view.Window)
    view.Segment = create("Frame", {
        Name = "Segment", Position = UDim2.new(0, 10, 0, 3), Size = UDim2.new(1, -20, 1, -8),
        BackgroundColor3 = Theme.segment, BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 4,
    }, view.Nav)
    corner(view.Segment, UDim.new(0, 11))
    stroke(view.Segment, Theme.border, 1, 0.9)
    padding(view.Segment, 3, 3, 3, 3)
    view.TabHighlight = create("Frame", {
        Name = "Highlight", Size = UDim2.new(1, -2, 1, 0), Position = UDim2.new(0, 1, 0, 0),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 5,
    }, view.Segment)
    corner(view.TabHighlight, UDim.new(0, 8))
    stroke(view.TabHighlight, Theme.gold, 1, 0.5)
    create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.accentHover), ColorSequenceKeypoint.new(0.55, Theme.accent),
            ColorSequenceKeypoint.new(1, Theme.accentDeep),
        }),
        Rotation = 90,
    }, view.TabHighlight)

    view.Divider = create("Frame", {
        Size = UDim2.new(1, -20, 0, 2), Position = UDim2.new(0, 10, 0, headerHeight + M.Nav),
        BackgroundColor3 = Theme.border, BackgroundTransparency = Theme.tinsel and 0.35 or 0.92, BorderSizePixel = 0, ZIndex = 4,
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
    view.Content = create("Frame", {
        Position = UDim2.new(0, 0, 0, headerHeight + M.Nav + 2), Size = UDim2.new(1, 0, 1, -(headerHeight + M.Nav + 2)),
        BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 3,
    }, view.Window)

    view.Reopen = create("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 12), Size = UDim2.fromOffset(44, 44),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, AutoButtonColor = false, Text = "🎄",
        FontFace = Fonts.Bold, TextSize = 21, Visible = false, ZIndex = 20,
    }, view.Gui)
    corner(view.Reopen, UDim.new(1, 0))
    stroke(view.Reopen, Theme.gold, 1.5, 0.2)
    create("UIGradient", { Color = ColorSequence.new(Theme.accentHover, Theme.accentDeep), Rotation = 135 }, view.Reopen)
end

local function wireWindow(window)
    local view, options, M = window.View, window.Options, window.M
    connect(window, view.MinimizeButton.Activated, function() window:SetMinimized(not window.Minimized) end)
    connect(window, view.SearchButton.Activated, function()
        local open = not view.SearchBox.Visible
        view.SearchBox.Visible = open
        view.TitleBlock.Visible = not open
        view.StatusPill.Visible = not open and not M.Compact
        local controlsWidth = view.Controls.AbsoluteSize.X / math.max(view.Scale.Scale, 0.01)
        local width = math.max(90, M.Width - 52 - controlsWidth - 18)
        tween(view.SearchBox, Theme.tweenFast, { Size = UDim2.new(0, open and width or 0, 0, 30) })
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
                    view.CloseButton.TextColor3 = Theme.textMuted
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
                window:Resize(true)
            end
        end)
    end
    local elapsed = 0
    connect(window, RunService.Heartbeat, function(delta)
        if not view.Gui.Enabled or not view.Window.Visible then return end
        elapsed = elapsed + delta
        if elapsed < (M.Compact and 0.09 or 0.05) then return end
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
    local compact = Library.IsTouch or options.Compact == true
    local window = setmetatable({
        Options = options, Connections = {}, Tabs = {}, Dropdowns = {}, Searchable = {},
        Notifications = {}, NotificationKeys = {}, NotificationOrder = 0,
        View = {}, Minimized = false, Visible = true, Destroyed = false, SearchQuery = "",
        M = compact and Library.Profiles.Touch or Library.Profiles.Desktop,
    }, Window)
    Library.Active = window
    buildWindow(window)
    wireWindow(window)
    local target = window:UpdateScale(true)
    window.View.Scale.Scale = target * 0.92
    window.View.Window.Position = window:Clamp(window.View.Window.Position)
    tween(window.View.Scale, Theme.tweenSpring, { Scale = target })
    window.Gui = window.View.Gui
    window.Frame = window.View.Window
    return window
end

function Window:Ready(options)
    options = type(options) == "table" and options or {}
    if options.ActiveTab then self:SelectTab(options.ActiveTab, true) end
    if options.Minimized then self:SetMinimized(true, true) end
    task.defer(function()
        if self.Destroyed then return end
        self:UpdateScale(false)
        self:Resize(true)
        self.View.Window.Position = self:Clamp(self.View.Window.Position)
    end)
    return self
end

function Library.destroy()
    if Library.Active then Library.Active:Destroy() end
end

return Library
