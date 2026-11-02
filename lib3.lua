--og sniper · christmas theme
local cloneref = cloneref or function(object) return object end
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))

local UiLib = {
    Name = "Zelqyn Hub",
    IsTouch = UserInputService.TouchEnabled,
    Theme = {
        bg0 = Color3.fromRGB(9, 12, 12),
        bg1 = Color3.fromRGB(15, 19, 19),
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
        snow = Color3.fromRGB(236, 246, 255),
        accent = Color3.fromRGB(214, 48, 62),
        accentHover = Color3.fromRGB(232, 74, 86),
        accentDeep = Color3.fromRGB(140, 22, 34),
        accentText = Color3.fromRGB(255, 128, 136),
        activeTabText = Color3.fromRGB(246, 249, 248),
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
        tweenNoticeIn = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        tweenNoticeOut = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        rippleAsset = "rbxassetid://266543268",
        backgroundAsset = "rbxassetid://130379359123488",
        backgroundTransparency = 0.94,
        logoAsset = "rbxassetid://0",
        snowfall = true,
        width = 460,
        height = 580,
        cardHeight = 180,
        mobileScaleBase = 500,
        mobileMinScale = 0.6,
        mobileMaxScale = 0.85,
        mobileHeightRatio = 0.82,
    },
    Active = nil,
}

local Theme = UiLib.Theme
local Controller = {}
Controller.__index = Controller
local Card = {}
Card.__index = Card

local Fonts = {
    Regular = Font.new(Theme.fontFamily, Enum.FontWeight.Regular),
    Medium = Font.new(Theme.fontFamily, Enum.FontWeight.Medium),
    SemiBold = Font.new(Theme.fontFamily, Enum.FontWeight.SemiBold),
    Bold = Font.new(Theme.fontFamily, Enum.FontWeight.Bold),
}

local function create(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do object[property] = value end
    object.Parent = parent
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

-- owner is any table with a Connections list (the controller or a card).
local function connect(owner, signal, callback)
    local connection = signal:Connect(callback)
    table.insert(owner.Connections, connection)
    return connection
end

local function disconnectAll(owner)
    for index = #owner.Connections, 1, -1 do
        local connection = owner.Connections[index]
        if connection then connection:Disconnect() end
        owner.Connections[index] = nil
    end
end

local function hoverFill(owner, button, hoverText)
    connect(owner, button.MouseEnter, function()
        TweenService:Create(button, Theme.tweenFast, {
            BackgroundTransparency = 0.55, TextColor3 = hoverText or Theme.textPri,
        }):Play()
    end)
    connect(owner, button.MouseLeave, function()
        TweenService:Create(button, Theme.tweenFast, {
            BackgroundTransparency = 1, TextColor3 = Theme.textMuted,
        }):Play()
    end)
end

local function ripple(owner, button, radius)
    local host = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        BorderSizePixel = 0, ClipsDescendants = true, ZIndex = button.ZIndex,
    }, button)
    corner(host, UDim.new(0, radius or 10))
    connect(owner, button.MouseButton1Down, function(x, y)
        local absolute, size = button.AbsolutePosition, button.AbsoluteSize
        local localX = math.clamp((x or absolute.X + size.X / 2) - absolute.X, 0, size.X)
        local localY = math.clamp((y or absolute.Y + size.Y / 2) - absolute.Y, 0, size.Y)
        local diameter = math.max(size.X, size.Y) * 2.2
        local circle = create("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, localX, 0, localY),
            Size = UDim2.new(), BackgroundTransparency = 1, Image = Theme.rippleAsset,
            ImageColor3 = Color3.new(1, 1, 1), ImageTransparency = 0.86, ZIndex = button.ZIndex + 1,
        }, host)
        local animation = TweenService:Create(circle, TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, diameter, 0, diameter), ImageTransparency = 1,
        })
        animation:Play()
        animation.Completed:Connect(function()
            if circle.Parent then circle:Destroy() end
        end)
    end)
end

local function makeCard(parent, height, order)
    local card = create("Frame", {
        Size = UDim2.new(1, 0, 0, height or 44),
        BackgroundColor3 = Theme.bg2,
        BackgroundTransparency = Theme.cardTransparency,
        BorderSizePixel = 0,
        LayoutOrder = order or 0,
    }, parent)
    corner(card, UDim.new(0, 10))
    stroke(card)
    return card
end

local function makeText(parent, text, properties)
    local values = {
        Size = UDim2.new(1, -24, 1, 0), Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1, FontFace = Fonts.Medium, TextSize = 13,
        TextColor3 = Theme.textPri, TextXAlignment = Enum.TextXAlignment.Left, Text = text or "",
    }
    for key, value in pairs(properties or {}) do values[key] = value end
    return create("TextLabel", values, parent)
end

local function makePillBadge(parent, text, tone, position, height, zIndex, withDot)
    local pill = makeText(parent, text, {
        AnchorPoint = Vector2.new(1, 0.5), Position = position or UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 0, 0, height or 20), AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 0.2, BackgroundColor3 = Theme.bg0,
        FontFace = Fonts.SemiBold, TextSize = 10,
        TextColor3 = withDot and Theme.textPri or (tone or Theme.textMuted),
        TextXAlignment = Enum.TextXAlignment.Center, ZIndex = zIndex or 4,
    })
    corner(pill, UDim.new(1, 0))
    stroke(pill, Theme.border, 1, 0.9)
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

local function setPill(pill, text, tone, textColor)
    if not pill then return end
    pill.Text = text
    local dot = pill:FindFirstChild("Dot")
    if dot then
        dot.BackgroundColor3 = tone
        pill.TextColor3 = textColor or Theme.textPri
    else
        pill.TextColor3 = tone
    end
end

local function makeChip(parent, text, tone, order)
    local chip = makeText(parent, text, {
        Size = UDim2.new(0, 0, 0, 20), AutomaticSize = Enum.AutomaticSize.X, Position = UDim2.new(),
        BackgroundColor3 = Theme.bg0, BackgroundTransparency = 0.2, LayoutOrder = order or 0,
        FontFace = Fonts.SemiBold, TextSize = 10, TextColor3 = tone,
        TextXAlignment = Enum.TextXAlignment.Center,
    })
    corner(chip, UDim.new(1, 0))
    stroke(chip, tone, 1, 0.7)
    padding(chip, 8, 8, 0, 0)
    return chip
end

local ToneKeys = {
    success = "success", warning = "warning", error = "danger", danger = "danger",
    info = "info", muted = "textMuted", accent = "accent",
}

local function toneColor(tone, fallback)
    if typeof(tone) == "Color3" then return tone end
    local key = ToneKeys[string.lower(tostring(tone or ""))]
    return key and Theme[key] or fallback or Theme.textMuted
end

local function makeButton(owner, parent, options)
    local primary = options.Primary == true
    local card = makeCard(parent, options.Height or 42, options.Order)
    if options.Size then card.Size = options.Size end
    if options.Position then card.Position = options.Position end
    local outline = card:FindFirstChildOfClass("UIStroke")
    local control = {
        Frame = card,
        Text = options.Text or "",
        RestColor = options.Color or (primary and Color3.fromRGB(232, 232, 232) or Theme.bg2),
        RestTextColor = options.TextColor or (primary and Theme.activeTabText or Theme.textPri),
    }
    local hoverColor = primary and Color3.new(1, 1, 1) or Theme.hover
    card.BackgroundColor3 = control.RestColor
    if primary then
        card.BackgroundTransparency = 0
        create("UIGradient", { Color = ColorSequence.new(Theme.accentHover, Theme.accentDeep), Rotation = 90 }, card)
        outline.Color, outline.Transparency = Theme.gold, 0.5
    end
    local restStroke = outline.Transparency
    local button = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, AutoButtonColor = false,
        FontFace = (options.Bold or primary) and Fonts.SemiBold or Fonts.Medium,
        TextSize = options.TextSize or 13, TextColor3 = control.RestTextColor,
        Text = control.Text, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3,
    }, card)
    control.Button = button
    local buttonScale = create("UIScale", {}, button)
    ripple(owner, button, 10)
    connect(owner, button.MouseEnter, function()
        TweenService:Create(card, Theme.tweenFast, { BackgroundColor3 = hoverColor }):Play()
        TweenService:Create(button, Theme.tweenFast, { TextColor3 = control.RestTextColor:Lerp(Color3.new(1, 1, 1), 0.3) }):Play()
        TweenService:Create(outline, Theme.tweenFast, { Transparency = primary and 0.3 or 0.8 }):Play()
    end)
    connect(owner, button.MouseLeave, function()
        TweenService:Create(card, Theme.tweenFast, { BackgroundColor3 = control.RestColor }):Play()
        TweenService:Create(button, Theme.tweenFast, { TextColor3 = control.RestTextColor }):Play()
        TweenService:Create(buttonScale, Theme.tweenFast, { Scale = 1 }):Play()
        TweenService:Create(outline, Theme.tweenFast, { Transparency = restStroke }):Play()
    end)
    connect(owner, button.MouseButton1Down, function()
        TweenService:Create(buttonScale, Theme.tweenSnap, { Scale = 0.96 }):Play()
    end)
    connect(owner, button.MouseButton1Up, function()
        TweenService:Create(buttonScale, Theme.tweenSpring, { Scale = 1 }):Play()
    end)
    if options.Callback then connect(owner, button.Activated, options.Callback) end
    return control
end

-- Size and position of cell `index` in a row split into `columns` equal cells.
local function gridCell(index, columns, gap, height)
    local share = (columns - 1) * gap / columns
    return UDim2.new(1 / columns, -share, 0, height), UDim2.new((index - 1) / columns, (index - 1) * (gap - share), 0, 0)
end

local function glowLayer(window, name, rotation, transparency)
    local layer = create("Frame", {
        Name = name, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.glow,
        BorderSizePixel = 0, ZIndex = 1,
    }, window)
    corner(layer, UDim.new(0, 14))
    create("UIGradient", { Rotation = rotation, Transparency = transparency }, layer)
    return layer
end

local function viewportSize()
    local camera = workspace.CurrentCamera
    return camera and camera.ViewportSize or Vector2.new(1280, 720)
end

-- One scale on touch screens, driven by the short side of the screen.
local function mobileScale(viewport)
    local shortSide = math.min(viewport.X, viewport.Y)
    local fitWidth = (viewport.X - 24) / Theme.width
    return math.clamp(
        math.min(shortSide / Theme.mobileScaleBase, fitWidth, Theme.mobileMaxScale),
        Theme.mobileMinScale, Theme.mobileMaxScale
    )
end

local CardActions = {
    { Name = "Send", Row = 1, Column = 1, Primary = true },
    { Name = "Target", Row = 1, Column = 2, Tone = "accentText" },
    { Name = "Duel", Row = 1, Column = 3, Tone = "info" },
    { Name = "Copy", Row = 2, Column = 1, Tone = "textPri" },
    { Name = "Scan", Row = 2, Column = 2, Tone = "textMuted" },
    { Name = "Blacklist", Row = 2, Column = 3, Tone = "textMuted" },
    { Name = "Track", Row = 2, Column = 4, Tone = "textMuted" },
}

function Card:SetOwner(userId, label)
    if self.Destroyed then return end
    userId = tonumber(userId)
    local claimed = userId ~= nil
    self.Avatar.Image = claimed and ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(userId) or ""
    self.AvatarGlyph.Visible = not claimed
    self.OwnerLabel.Text = claimed and tostring(label or ("User " .. userId)) or "Unclaimed"
    self.OwnerLabel.TextColor3 = claimed and Theme.textMuted or Theme.danger
    self.StatusDot.BackgroundColor3 = claimed and Theme.success or Theme.danger
end

-- state: "loading", "ready" or "unavailable"
function Card:SetModelState(state)
    if self.Destroyed then return end
    self.Fallback.Visible = state ~= "ready"
    self.Fallback.Text = state == "unavailable" and "Model\nunavailable" or "Loading..."
end

function Card:SetActionText(name, text)
    local control = self.Buttons[name]
    if self.Destroyed or not control then return end
    control.Button.Text = tostring(text or control.Text)
end

function Card:ResetActionText(name)
    local control = self.Buttons[name]
    if control then self:SetActionText(name, control.Text) end
end

function Card:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
    disconnectAll(self)
    if self.Frame.Parent then self.Frame:Destroy() end
    local controller = self.Controller
    if controller.Cards[self] then
        controller.Cards[self] = nil
        controller.CardCount = controller.CardCount - 1
        if not controller.Destroyed then controller:RefreshCount() end
    end
end

local function buildWindow(self)
    local view = self.View
    local headerHeight = UiLib.IsTouch and 48 or 50
    local barHeight = 44
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    -- PlayerGui, not gethui(): the game's Animals:AttachOnViewport cannot reach
    -- instances inside the hidden UI container, so card models would never load.
    local guiParent = self.Options.Parent or playerGui
    for _, parent in ipairs({ guiParent, playerGui, gethui and gethui() or nil }) do
        local old = parent and parent:FindFirstChild("ZelqynOGSniper")
        if old then old:Destroy() end
    end

    view.Gui = create("ScreenGui", {
        Name = "ZelqynOGSniper", DisplayOrder = 90, ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    if syn and type(syn.protect_gui) == "function" then pcall(syn.protect_gui, view.Gui) end
    view.Gui.Parent = guiParent

    view.Window = create("Frame", {
        Size = self:ExpandedSize(), Position = self.Options.Position or UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Active = true, ClipsDescendants = true,
    }, view.Gui)
    view.Shadow = create("ImageLabel", {
        Name = "ZelqynShadow", BackgroundTransparency = 1, BorderSizePixel = 0,
        Image = "rbxassetid://6014261993", ImageColor3 = Color3.fromRGB(0, 0, 0), ImageTransparency = 0.3,
        ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450), ZIndex = 0,
    }, view.Gui)
    local function syncShadow()
        local position, size = view.Window.Position, view.Window.Size
        local scale = view.Scale and view.Scale.Scale or 1
        view.Shadow.Position = UDim2.new(position.X.Scale, position.X.Offset - 22, position.Y.Scale, position.Y.Offset - 14)
        view.Shadow.Size = UDim2.new(size.X.Scale, size.X.Offset * scale + 44, size.Y.Scale, size.Y.Offset * scale + 52)
    end
    connect(self, view.Window:GetPropertyChangedSignal("Position"), syncShadow)
    connect(self, view.Window:GetPropertyChangedSignal("Size"), syncShadow)
    corner(view.Window, UDim.new(0, 14))
    view.Scale = create("UIScale", { Scale = 0.92 }, view.Window)
    connect(self, view.Scale:GetPropertyChangedSignal("Scale"), syncShadow)
    syncShadow()
    create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.windowTop),
            ColorSequenceKeypoint.new(0.5, Theme.windowMid),
            ColorSequenceKeypoint.new(1, Theme.windowBottom),
        }),
        Rotation = 90,
    }, view.Window)

    glowLayer(view.Window, "GlowRise", 90, NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.35, 0.94),
        NumberSequenceKeypoint.new(1, 0.62),
    }))
    glowLayer(view.Window, "GlowCore", 0, NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.42, 0.9),
        NumberSequenceKeypoint.new(1, 1),
    }))
    local frost = glowLayer(view.Window, "Frost", 90, NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.8, 1),
        NumberSequenceKeypoint.new(1, 0.9),
    }))
    frost.BackgroundColor3 = Theme.snow
    local background = create("ImageLabel", {
        Name = "ZelqynBackground", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        BorderSizePixel = 0, Image = Theme.backgroundAsset, ImageColor3 = Theme.glow,
        ImageTransparency = Theme.backgroundTransparency, ScaleType = Enum.ScaleType.Crop, ZIndex = 1,
    }, view.Window)
    corner(background, UDim.new(0, 14))

    local snowLayer = create("Frame", {
        Name = "Snowfall", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 2,
    }, view.Window)
    view.Snowflakes = {}
    if Theme.snowfall then
        -- { x, y, size (0 = soft snow dot), fall speed, sway, transparency }
        local snowSpecs = {
            { 0.06, -0.10, 16, 0.040, 0.020, 0.30 }, { 0.21, 0.22, 11, 0.028, 0.014, 0.50 },
            { 0.37, -0.34, 19, 0.034, 0.024, 0.28 }, { 0.55, 0.05, 13, 0.044, 0.016, 0.42 },
            { 0.72, -0.24, 17, 0.031, 0.022, 0.34 }, { 0.90, 0.30, 12, 0.039, 0.015, 0.48 },
            { 0.14, 0.58, 14, 0.036, 0.018, 0.40 }, { 0.47, 0.70, 18, 0.042, 0.020, 0.32 },
            { 0.80, 0.52, 15, 0.030, 0.017, 0.38 }, { 0.30, 0.86, 10, 0.026, 0.012, 0.55 },
            { 0.10, 0.36, 0, 0.022, 0.010, 0.45 }, { 0.33, 0.12, 0, 0.025, 0.012, 0.55 },
            { 0.52, 0.44, 0, 0.020, 0.010, 0.50 }, { 0.66, 0.80, 0, 0.027, 0.014, 0.45 },
            { 0.86, 0.06, 0, 0.023, 0.011, 0.55 }, { 0.96, 0.66, 0, 0.021, 0.012, 0.50 },
        }
        for index, spec in ipairs(snowSpecs) do
            local flake
            if spec[3] > 0 then
                flake = create("TextLabel", {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(spec[1], spec[2]),
                    Size = UDim2.fromOffset(spec[3] + 6, spec[3] + 6), BackgroundTransparency = 1,
                    BorderSizePixel = 0, FontFace = Fonts.Regular, Text = "❄",
                    TextSize = spec[3], TextColor3 = Theme.snow, TextTransparency = spec[6], ZIndex = 2,
                }, snowLayer)
            else
                local dotSize = 3 + index % 3
                flake = create("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(spec[1], spec[2]),
                    Size = UDim2.fromOffset(dotSize, dotSize), BackgroundColor3 = Theme.snow,
                    BackgroundTransparency = spec[6], BorderSizePixel = 0, ZIndex = 2,
                }, snowLayer)
                corner(flake, UDim.new(1, 0))
            end
            view.Snowflakes[index] = {
                Object = flake, X = spec[1], Y = spec[2], Speed = spec[4], Sway = spec[5],
                Spin = spec[3] > 0, Phase = index * 0.83,
            }
        end
    end

    local border = create("UIStroke", {
        Color = Color3.new(1, 1, 1), Thickness = 1, Transparency = 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, LineJoinMode = Enum.LineJoinMode.Round,
    }, view.Window)
    view.Glow = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.42, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Theme.gold),
            ColorSequenceKeypoint.new(0.58, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.86), NumberSequenceKeypoint.new(0.4, 0.86),
            NumberSequenceKeypoint.new(0.5, 0.3), NumberSequenceKeypoint.new(0.6, 0.86),
            NumberSequenceKeypoint.new(1, 0.86),
        }),
    }, border)

    view.Header = create("Frame", {
        Size = UDim2.new(1, 0, 0, headerHeight), BackgroundTransparency = 1,
        BorderSizePixel = 0, Active = true, ZIndex = 4,
    }, view.Window)
    local mark = create("Frame", {
        Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(0, 12, 0.5, -15),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 5,
    }, view.Header)
    corner(mark, UDim.new(0, 9))
    stroke(mark, Theme.gold, 1, 0.45)
    create("UIGradient", { Color = ColorSequence.new(Theme.accentHover, Theme.accentDeep), Rotation = 135 }, mark)
    makeText(mark, "Z", {
        Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(), FontFace = Fonts.Bold, TextSize = 16,
        TextColor3 = Theme.activeTabText, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 6,
    })
    create("ImageLabel", {
        Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2),
        BackgroundTransparency = 1, BorderSizePixel = 0, Image = Theme.logoAsset,
        ScaleType = Enum.ScaleType.Fit, ZIndex = 7,
    }, mark)
    makeText(view.Header, UiLib.Name, {
        Size = UDim2.new(0, 190, 0, 18), Position = UDim2.new(0, 52, 0, headerHeight / 2 - 17),
        FontFace = Fonts.SemiBold, TextSize = 15, ZIndex = 5,
    })
    makeText(view.Header, tostring(self.Options.Subtitle or "OG Sniper"), {
        Size = UDim2.new(0, 190, 0, 14), Position = UDim2.new(0, 52, 0, headerHeight / 2 + 2),
        TextSize = 11, TextColor3 = Theme.textMuted, ZIndex = 5,
    })
    view.HeaderPill = makePillBadge(view.Header, "Waiting", Theme.warning, UDim2.new(1, -78, 0.5, 0), 22, 5, true)
    local function headerButton(text, position)
        local button = create("TextButton", {
            Size = UDim2.new(0, 28, 0, 28), AnchorPoint = Vector2.new(1, 0.5), Position = position,
            BackgroundColor3 = Theme.hover, BackgroundTransparency = 1, BorderSizePixel = 0, AutoButtonColor = false,
            FontFace = Fonts.SemiBold, TextSize = 14, TextColor3 = Theme.textMuted, Text = text, ZIndex = 5,
        }, view.Header)
        corner(button, UDim.new(0, 8))
        return button
    end
    view.Minimize = headerButton("—", UDim2.new(1, -42, 0.5, 0))
    view.Close = headerButton("×", UDim2.new(1, -10, 0.5, 0))
    view.Close.TextSize = 18

    view.Bar = create("Frame", {
        Position = UDim2.new(0, 0, 0, headerHeight), Size = UDim2.new(1, 0, 0, barHeight),
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 4,
    }, view.Window)
    local bar = create("Frame", {
        Name = "Status", Position = UDim2.new(0, 10, 0, 3), Size = UDim2.new(1, -20, 1, -8),
        BackgroundColor3 = Theme.segment, BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 4,
    }, view.Bar)
    corner(bar, UDim.new(0, 11))
    stroke(bar, Theme.border, 1, 0.9)
    view.StatusHalo = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 19, 0.5, 0),
        BackgroundColor3 = Theme.warning, BackgroundTransparency = 0.78, BorderSizePixel = 0, ZIndex = 5,
    }, bar)
    corner(view.StatusHalo, UDim.new(1, 0))
    view.StatusDot = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0, 19, 0.5, 0),
        BackgroundColor3 = Theme.warning, BorderSizePixel = 0, ZIndex = 6,
    }, bar)
    corner(view.StatusDot, UDim.new(1, 0))
    view.StatusText = makeText(bar, "", {
        Size = UDim2.new(1, -130, 1, 0), Position = UDim2.new(0, 34, 0, 0),
        FontFace = Fonts.SemiBold, TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 5,
    })
    view.CountPill = makePillBadge(bar, "0 logged", Theme.textMuted, UDim2.new(1, -8, 0.5, 0), 22, 5)

    view.Divider = create("Frame", {
        Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, headerHeight + barHeight),
        BackgroundColor3 = Theme.border, BackgroundTransparency = 0.92, BorderSizePixel = 0, ZIndex = 4,
    }, view.Window)
    view.Content = create("Frame", {
        Position = UDim2.new(0, 0, 0, headerHeight + barHeight + 1),
        Size = UDim2.new(1, 0, 1, -(headerHeight + barHeight + 1)),
        BackgroundTransparency = 1, ZIndex = 3,
    }, view.Window)
    view.List = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.border, ScrollBarImageTransparency = 0.7,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(),
        ScrollingDirection = Enum.ScrollingDirection.Y,
    }, view.Content)
    create("UIListLayout", {
        Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    }, view.List)
    padding(view.List, 11, 11, 8, 10)

    view.Empty = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, -40, 0, 90), BackgroundTransparency = 1, ZIndex = 4,
    }, view.Content)
    makeText(view.Empty, "❄", {
        Position = UDim2.new(), Size = UDim2.new(1, 0, 0, 34), FontFace = Fonts.Regular, TextSize = 28,
        TextColor3 = Theme.snow, TextTransparency = 0.35, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 4,
    })
    makeText(view.Empty, "Waiting for Liveboard entries...", {
        Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(1, 0, 0, 20), FontFace = Fonts.SemiBold, TextSize = 14,
        TextColor3 = Theme.textMuted, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 4,
    })
    makeText(view.Empty, "New OG brainrots appear here as soon as they are logged", {
        Position = UDim2.new(0, 0, 0, 62), Size = UDim2.new(1, 0, 0, 18), TextSize = 12,
        TextColor3 = Theme.textDim, TextXAlignment = Enum.TextXAlignment.Center, TextWrapped = true, ZIndex = 4,
    })
end

local function wireWindow(self)
    local view = self.View
    local dragging, dragStart, startPosition = false, nil, nil
    connect(self, view.Minimize.Activated, function() self:SetMinimized(not self.Minimized) end)
    connect(self, view.Close.Activated, function()
        if type(self.Options.OnClose) == "function" then
            self.Options.OnClose()
        else
            self:Destroy()
        end
    end)
    hoverFill(self, view.Minimize)
    hoverFill(self, view.Close, Theme.danger)
    connect(self, view.Header.InputBegan, function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging, dragStart, startPosition = true, input.Position, view.Window.Position
    end)
    connect(self, UserInputService.InputChanged, function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        view.Window.Position = self:Clamp(UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        ))
    end)
    connect(self, UserInputService.InputEnded, function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = false
    end)
    if workspace.CurrentCamera then
        connect(self, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function()
            if view.Window.Parent then
                view.Window.Size = self.Minimized and self:CollapsedSize() or self:ExpandedSize()
                self:UpdateScale(true)
                view.Window.Position = self:Clamp(view.Window.Position)
            end
        end)
    end
    local animationElapsed = 0
    connect(self, RunService.Heartbeat, function(delta)
        if not view.Gui.Enabled then return end
        animationElapsed = animationElapsed + delta
        if animationElapsed < (UiLib.IsTouch and 0.09 or 0.05) then return end
        local animationDelta = animationElapsed
        animationElapsed = 0
        local now = os.clock()
        for _, flake in ipairs(view.Snowflakes) do
            flake.Y = flake.Y + animationDelta * flake.Speed
            if flake.Y > 1.08 then
                flake.Y = -0.08
                flake.X = 0.03 + ((flake.X + 0.41) % 0.94)
            end
            local drift = math.sin(now * 0.8 + flake.Phase) * flake.Sway
            flake.Object.Position = UDim2.fromScale(flake.X + drift, flake.Y)
            if flake.Spin then flake.Object.Rotation = (now * 22 + flake.Phase * 40) % 360 end
        end
        view.Glow.Rotation = (now * 48) % 360
        view.StatusHalo.BackgroundTransparency = 0.7 + 0.22 * (0.5 + 0.5 * math.sin(now * 3.4))
    end)
end

-- Fixed height; on short touch screens it is capped so the window never fills the screen.
function Controller:ExpandedSize()
    if not UiLib.IsTouch then return UDim2.new(0, Theme.width, 0, Theme.height) end
    local viewport = viewportSize()
    local fitHeight = math.max(300, math.floor(viewport.Y * Theme.mobileHeightRatio / mobileScale(viewport)))
    return UDim2.new(0, Theme.width, 0, math.min(Theme.height, fitHeight))
end

function Controller:CollapsedSize()
    return UDim2.new(0, Theme.width, 0, UiLib.IsTouch and 48 or 50)
end

function Controller:Clamp(position)
    local camera = workspace.CurrentCamera
    if not camera then return position end
    local viewport = camera.ViewportSize
    local absoluteX = position.X.Scale * viewport.X + position.X.Offset
    local absoluteY = position.Y.Scale * viewport.Y + position.Y.Offset
    local maxX = math.max(6, viewport.X - self.View.Window.AbsoluteSize.X - 6)
    local maxY = math.max(6, viewport.Y - self.View.Window.AbsoluteSize.Y - 6)
    local x = math.clamp(absoluteX, 6, maxX)
    local y = math.clamp(absoluteY, 6, maxY)
    return UDim2.new(position.X.Scale, x - position.X.Scale * viewport.X, position.Y.Scale, y - position.Y.Scale * viewport.Y)
end

function Controller:UpdateScale(instant)
    local viewport = viewportSize()
    local target
    if UiLib.IsTouch then
        target = mobileScale(viewport)
    else
        local size = self:ExpandedSize()
        local fit = math.min((viewport.X - 20) / size.X.Offset, (viewport.Y - 20) / size.Y.Offset)
        target = math.clamp(math.min(fit, math.clamp(viewport.Y / 960, 0.68, 0.90)), 0.58, 0.90)
    end
    self.ResponsiveScale = target
    if self.View.NotificationScale then self.View.NotificationScale.Scale = UiLib.IsTouch and target or 1 end
    if instant then
        self.View.Scale.Scale = target
    else
        TweenService:Create(self.View.Scale, Theme.tweenMed, { Scale = target }):Play()
    end
    return target
end

function Controller:SetMinimized(value, instant)
    self.Minimized = value == true
    self.View.Bar.Visible = not self.Minimized
    self.View.Divider.Visible = not self.Minimized
    self.View.Content.Visible = not self.Minimized
    self.View.Minimize.Text = self.Minimized and "+" or "—"
    local size = self.Minimized and self:CollapsedSize() or self:ExpandedSize()
    if instant then
        self.View.Window.Size = size
        self.View.Window.Position = self:Clamp(self.View.Window.Position)
        return
    end
    local resize = TweenService:Create(self.View.Window, Theme.tweenMed, { Size = size })
    resize.Completed:Connect(function()
        if not self.Destroyed then self.View.Window.Position = self:Clamp(self.View.Window.Position) end
    end)
    resize:Play()
end

local StatusBadges = { success = "Live", warning = "Waiting", error = "Offline", danger = "Offline", info = "Info", muted = "Idle" }

-- ui:SetStatus("Listening to Liveboard", "success")  tones: success, warning, error, info, muted or a Color3
function Controller:SetStatus(text, tone, badge)
    if self.Destroyed then return end
    local key = type(tone) == "string" and string.lower(tone) or nil
    local color = toneColor(tone, Theme.textPri)
    self.View.StatusText.Text = tostring(text or "")
    self.View.StatusText.TextColor3 = key == "success" and Theme.textPri or color
    self.View.StatusDot.BackgroundColor3 = color
    self.View.StatusHalo.BackgroundColor3 = color
    setPill(self.View.HeaderPill, badge or StatusBadges[key] or "Status", color)
end

function Controller:RefreshCount()
    setPill(self.View.CountPill, self.CardCount .. " logged", self.CardCount > 0 and Theme.textPri or Theme.textMuted)
    self.View.Empty.Visible = self.CardCount == 0
end

-- ui:AddCard({ Name, Mutation, IsLocalServer }, { Send = fn, Target = fn, Duel = fn, Copy = fn, Scan = fn, Blacklist = fn, Track = fn })
-- Returns a card with :SetOwner(userId, label), :SetModelState(state), :SetActionText(name, text),
-- :ResetActionText(name), :Destroy() and a .Viewport for the brainrot model. Newest cards go on top.
function Controller:AddCard(data, actions)
    if self.Destroyed then return nil end
    data, actions = data or {}, actions or {}
    self.CardCounter = self.CardCounter + 1
    local card = setmetatable({ Controller = self, Connections = {}, Buttons = {}, Destroyed = false }, Card)
    local frame = makeCard(self.View.List, Theme.cardHeight, -self.CardCounter)
    card.Frame = frame

    local avatarHolder = create("Frame", {
        Position = UDim2.new(0, 12, 0, 12), Size = UDim2.fromOffset(52, 52),
        BackgroundColor3 = Theme.inputBg, BackgroundTransparency = Theme.inputTransparency, BorderSizePixel = 0,
    }, frame)
    corner(avatarHolder, UDim.new(1, 0))
    stroke(avatarHolder, Theme.border, 1, 0.85)
    card.Avatar = create("ImageLabel", {
        Position = UDim2.fromOffset(3, 3), Size = UDim2.new(1, -6, 1, -6),
        BackgroundTransparency = 1, Image = "", ScaleType = Enum.ScaleType.Crop,
    }, avatarHolder)
    corner(card.Avatar, UDim.new(1, 0))
    card.AvatarGlyph = makeText(avatarHolder, "?", {
        Position = UDim2.new(), Size = UDim2.fromScale(1, 1), FontFace = Fonts.SemiBold, TextSize = 18,
        TextColor3 = Theme.textDim, TextXAlignment = Enum.TextXAlignment.Center,
    })
    card.StatusDot = create("Frame", {
        AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 1, 1, 1), Size = UDim2.fromOffset(13, 13),
        BackgroundColor3 = Theme.danger, BorderSizePixel = 0, ZIndex = 3,
    }, avatarHolder)
    corner(card.StatusDot, UDim.new(1, 0))
    stroke(card.StatusDot, Theme.bg1, 2, 0)

    makeText(frame, tostring(data.Name or "Unknown"), {
        Position = UDim2.new(0, 76, 0, 12), Size = UDim2.new(1, -184, 0, 20),
        FontFace = Fonts.SemiBold, TextSize = 15, TextTruncate = Enum.TextTruncate.AtEnd,
    })
    local chips = create("Frame", {
        Position = UDim2.new(0, 76, 0, 38), Size = UDim2.new(1, -184, 0, 20), BackgroundTransparency = 1,
    }, frame)
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center,
    }, chips)
    local mutation = tostring(data.Mutation or "Normal")
    local mutated = string.lower(mutation) ~= "normal"
    makeChip(chips, mutation, mutated and Theme.gold or Theme.textMuted, 1)
    makeChip(chips, data.IsLocalServer and "Server" or "Global", data.IsLocalServer and Theme.success or Theme.info, 2)
    card.OwnerLabel = makeText(frame, "Unclaimed", {
        Position = UDim2.new(0, 76, 0, 64), Size = UDim2.new(1, -184, 0, 18),
        TextSize = 12, TextColor3 = Theme.danger, TextTruncate = Enum.TextTruncate.AtEnd,
    })

    local modelHolder = create("Frame", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 12), Size = UDim2.fromOffset(84, 84),
        BackgroundColor3 = Theme.inputBg, BackgroundTransparency = Theme.inputTransparency,
        BorderSizePixel = 0, ClipsDescendants = true,
    }, frame)
    corner(modelHolder, UDim.new(0, 12))
    stroke(modelHolder, Theme.border, 1, 0.88)
    card.Viewport = create("ViewportFrame", {
        Ambient = Color3.fromRGB(210, 215, 220), LightColor = Color3.new(1, 1, 1),
        LightDirection = Vector3.new(-1, -1, -1), BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1), ZIndex = 2,
    }, modelHolder)
    corner(card.Viewport, UDim.new(0, 12))
    card.Fallback = makeText(modelHolder, "Loading...", {
        Position = UDim2.new(), Size = UDim2.fromScale(1, 1), TextSize = 10, TextColor3 = Theme.textDim,
        TextXAlignment = Enum.TextXAlignment.Center, TextWrapped = true,
    })

    local actionArea = create("Frame", {
        Position = UDim2.new(0, 12, 0, 106), Size = UDim2.new(1, -24, 0, 62), BackgroundTransparency = 1,
    }, frame)
    local rows = {
        create("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1 }, actionArea),
        create("Frame", { Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1 }, actionArea),
    }
    for _, action in ipairs(CardActions) do
        local columns = action.Row == 1 and 3 or 4
        local height = action.Row == 1 and 30 or 26
        local size, position = gridCell(action.Column, columns, 6, height)
        local callback = actions[action.Name]
        card.Buttons[action.Name] = makeButton(card, rows[action.Row], {
            Text = action.Name, Primary = action.Primary, Bold = action.Row == 1,
            TextColor = action.Tone and Theme[action.Tone] or nil, TextSize = action.Row == 1 and 12 or 11,
            Height = height, Size = size, Position = position,
            Callback = callback and function() callback(card) end or nil,
        })
    end

    self.Cards[card] = true
    self.CardCount = self.CardCount + 1
    self:RefreshCount()
    card:SetOwner(nil)
    local pop = create("UIScale", { Scale = 0.96 }, frame)
    TweenService:Create(pop, Theme.tweenSpring, { Scale = 1 }):Play()
    return card
end

local NoticeGlyphs = { success = "✓", warning = "!", error = "×", info = "i" }

local function noticeOffscreen(self, anchorY)
    local scale = self.View.NotificationScale and self.View.NotificationScale.Scale or 1
    return UDim2.new(0, viewportSize().X / math.max(scale, 0.01), anchorY, 0)
end

function Controller:DismissNotification(entry)
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
    TweenService:Create(entry.Card, Theme.tweenNoticeOut, { Position = noticeOffscreen(self, 1) }):Play()
    TweenService:Create(holder, Theme.tweenNoticeOut, { Size = UDim2.new(1, 0, 0, -8) }):Play()
    task.delay(Theme.tweenNoticeOut.Time, function()
        if holder.Parent then holder:Destroy() end
    end)
end

function Controller:NotificationList()
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
    self.View.NotificationScale = create("UIScale", {
        Scale = UiLib.IsTouch and (self.ResponsiveScale or Theme.mobileMaxScale) or 1,
    }, list)
    self.View.Notifications = list
    return list
end

-- ui:Notify({ Title = "Copied", Content = "@user", Type = "success", Duration = 6, Key = "optional" })
function Controller:Notify(options)
    if self.Destroyed or not self.View.Gui or not self.View.Gui.Parent then return end
    options = type(options) == "table" and options or { Content = tostring(options or "") }
    local key = options.Key and tostring(options.Key)
    if key then self:DismissNotification(self.NotificationKeys[key]) end
    while #self.Notifications >= 3 do self:DismissNotification(self.Notifications[1]) end
    local list = self:NotificationList()
    local kind = (options.Type == "success" or options.Type == "warning" or options.Type == "error") and options.Type or "info"
    local tone = Theme[kind == "error" and "danger" or kind]
    local duration = tonumber(options.Duration) or 5
    if duration ~= duration then duration = 5 end
    duration = math.clamp(duration, 2, 15)
    local content = tostring(options.Content or options.Message or "")
    if #content > 240 then content = content:sub(1, 237) .. "..." end
    self.NotificationOrder = (self.NotificationOrder or 0) + 1

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
    stroke(card, Theme.border, 1, 0.86)
    local wash = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = tone, BorderSizePixel = 0, ZIndex = 1,
    }, card)
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
    makeText(icon, NoticeGlyphs[kind], {
        Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(), FontFace = Fonts.Bold, TextSize = 14,
        TextColor3 = tone, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 4,
    })
    local column = create("Frame", {
        Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -40, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, ZIndex = 3,
    }, row)
    create("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, column)
    local titleRow = create("Frame", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, LayoutOrder = 1, ZIndex = 3 }, column)
    makeText(titleRow, tostring(options.Title or "OG Sniper"):sub(1, 100), {
        Size = UDim2.new(1, -66, 1, 0), Position = UDim2.new(), FontFace = Fonts.SemiBold, TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4,
    })
    makeText(titleRow, os.date("%H:%M"), {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -24, 0, 0), Size = UDim2.new(0, 40, 1, 0),
        TextSize = 10, TextColor3 = Theme.textDim, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 4,
    })
    local close = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 4, 0.5, 0), Size = UDim2.new(0, 22, 0, 22),
        BackgroundColor3 = Theme.hover, BackgroundTransparency = 1, BorderSizePixel = 0, AutoButtonColor = false,
        Text = "×", FontFace = Fonts.Medium, TextSize = 16, TextColor3 = Theme.textMuted, ZIndex = 5,
    }, titleRow)
    corner(close, UDim.new(1, 0))
    if content ~= "" then
        makeText(column, content, {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(), LayoutOrder = 2,
            FontFace = Fonts.Regular, TextSize = 12, TextColor3 = Theme.textMuted,
            TextWrapped = true, RichText = false, ZIndex = 4,
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
    table.insert(entry.Connections, close.MouseEnter:Connect(function()
        TweenService:Create(close, Theme.tweenFast, { BackgroundTransparency = 0.5, TextColor3 = Theme.textPri }):Play()
    end))
    table.insert(entry.Connections, close.MouseLeave:Connect(function()
        TweenService:Create(close, Theme.tweenFast, { BackgroundTransparency = 1, TextColor3 = Theme.textMuted }):Play()
    end))
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
        if entry.Shown and not entry.Closed then
            TweenService:Create(holder, Theme.tweenFast, { Size = UDim2.new(1, 0, 0, measure()) }):Play()
        end
    end))
    task.spawn(function()
        task.wait()
        if entry.Closed or not card.Parent then return end
        entry.Shown = true
        TweenService:Create(holder, Theme.tweenNoticeIn, { Size = UDim2.new(1, 0, 0, measure()) }):Play()
        TweenService:Create(card, Theme.tweenNoticeIn, { Position = UDim2.new(0, 0, 1, 0) }):Play()
        entry.ProgressTween:Play()
    end)
    return entry
end

function Controller:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
    while #self.Notifications > 0 do self:DismissNotification(self.Notifications[1]) end
    for card in pairs(self.Cards) do
        card.Destroyed = true
        disconnectAll(card)
    end
    table.clear(self.Cards)
    disconnectAll(self)
    if self.View.Gui and self.View.Gui.Parent then self.View.Gui:Destroy() end
    if UiLib.Active == self then UiLib.Active = nil end
end

-- UiLib.CreateSniper({ Subtitle = "OG Sniper", Status = "Starting...", StatusTone = "warning", OnClose = fn })
function UiLib.CreateSniper(options)
    if UiLib.Active then UiLib.Active:Destroy() end
    local self = setmetatable({
        Options = options or {},
        Connections = {},
        Cards = {},
        CardCount = 0,
        CardCounter = 0,
        Notifications = {},
        NotificationKeys = {},
        View = {},
        Minimized = false,
        Destroyed = false,
    }, Controller)
    UiLib.Active = self
    buildWindow(self)
    wireWindow(self)
    self:SetStatus(self.Options.Status or "Starting...", self.Options.StatusTone or "warning")
    self:RefreshCount()
    local targetScale = self:UpdateScale(true)
    if not self.Options.Position then
        local size = self.View.Window.Size
        self.View.Window.Position = UDim2.new(
            0.5, -size.X.Offset * targetScale / 2,
            0.5, -size.Y.Offset * targetScale / 2
        )
    end
    self:SetMinimized(self.Options.Minimized, true)
    self.View.Scale.Scale = targetScale * 0.92
    task.defer(function()
        if not self.Destroyed and self.View.Window.Parent then
            self.View.Window.Position = self:Clamp(self.View.Window.Position)
        end
    end)
    TweenService:Create(self.View.Scale, Theme.tweenSpring, { Scale = targetScale }):Play()
    return self
end

function UiLib.destroy()
    if UiLib.Active then UiLib.Active:Destroy() end
end

return UiLib
