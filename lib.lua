--v12 dual AI · lucid theme
local cloneref = cloneref or function(object) return object end
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))

local UiLib = {
    Name = "Zelqyn Hub",
    IsTouch = UserInputService.TouchEnabled,
    DesktopVertical = not UserInputService.TouchEnabled,
    Theme = {
        bg0 = Color3.fromRGB(12, 9, 10),
        bg1 = Color3.fromRGB(20, 16, 17),
        bg2 = Color3.fromRGB(38, 31, 33),
        bg3 = Color3.fromRGB(27, 21, 23),
        hover = Color3.fromRGB(54, 45, 48),
        segment = Color3.fromRGB(22, 17, 19),
        segmentActive = Color3.fromRGB(66, 58, 60),
        inputBg = Color3.fromRGB(15, 11, 12),
        border = Color3.fromRGB(255, 255, 255),
        windowTop = Color3.fromRGB(24, 19, 21),
        windowMid = Color3.fromRGB(21, 15, 17),
        windowBottom = Color3.fromRGB(40, 13, 22),
        glow = Color3.fromRGB(132, 26, 50),
        accent = Color3.fromRGB(232, 74, 102),
        accentHover = Color3.fromRGB(244, 98, 124),
        accentDeep = Color3.fromRGB(160, 34, 62),
        accentText = Color3.fromRGB(255, 140, 160),
        activeTabText = Color3.fromRGB(247, 245, 246),
        toggleOff = Color3.fromRGB(64, 56, 58),
        toggleOn = Color3.fromRGB(232, 74, 102),
        knob = Color3.fromRGB(255, 255, 255),
        textPri = Color3.fromRGB(237, 235, 236),
        textMuted = Color3.fromRGB(152, 145, 148),
        textDim = Color3.fromRGB(106, 99, 102),
        success = Color3.fromRGB(74, 222, 128),
        warning = Color3.fromRGB(250, 191, 64),
        danger = Color3.fromRGB(245, 88, 88),
        info = Color3.fromRGB(125, 178, 255),
        cardTransparency = 0.3,
        inputTransparency = 0.18,
        borderTransparency = 0.91,
        fontFamily = "rbxassetid://12187365364",
        tweenFast = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        tweenMed = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        tweenSnap = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        tweenSpring = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        tweenSlide = TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        toggleW = 42,
        toggleH = 22,
        knobSz = 16,
        rippleAsset = "rbxassetid://266543268",
        backgroundAsset = "rbxassetid://130379359123488",
        backgroundTransparency = 0.94,
        logoAsset = "rbxassetid://0",
        pumpkinRain = true,
        desktopWidth = 390,
        desktopHeight = 620,
        mobileWidth = 346,
        mobileMaxHeight = 500,
    },
    Active = nil,
}

local Theme = UiLib.Theme
local Controller = {}
Controller.__index = Controller

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

local function connect(self, signal, callback)
    local connection = signal:Connect(callback)
    table.insert(self.Connections, connection)
    return connection
end

local function emit(self, name, ...)
    local callback = self.Callbacks[name]
    if callback then return callback(...) end
end

local function hover(self, target, button, normalColor, hoverColor)
    connect(self, button.MouseEnter, function()
        TweenService:Create(target, Theme.tweenFast, { BackgroundColor3 = hoverColor or Theme.hover }):Play()
    end)
    connect(self, button.MouseLeave, function()
        TweenService:Create(target, Theme.tweenFast, { BackgroundColor3 = normalColor or Theme.bg2 }):Play()
    end)
end

local function hoverFill(self, button, restTransparency, hoverTransparency, isActive)
    connect(self, button.MouseEnter, function()
        if isActive and isActive() then return end
        TweenService:Create(button, Theme.tweenFast, {
            BackgroundTransparency = hoverTransparency, TextColor3 = Theme.textPri,
        }):Play()
    end)
    connect(self, button.MouseLeave, function()
        if isActive and isActive() then return end
        TweenService:Create(button, Theme.tweenFast, {
            BackgroundTransparency = restTransparency, TextColor3 = Theme.textMuted,
        }):Play()
    end)
end

local function ripple(self, button, radius)
    local host = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        BorderSizePixel = 0, ClipsDescendants = true, ZIndex = button.ZIndex,
    }, button)
    corner(host, UDim.new(0, radius or 10))
    connect(self, button.MouseButton1Down, function(x, y)
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

local function shine(self, target, host)
    local layer = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0, BackgroundTransparency = 0, ZIndex = math.max(target.ZIndex - 1, 1),
    }, host or target)
    corner(layer, UDim.new(0, 10))
    local gradient = create("UIGradient", {
        Rotation = 18, Offset = Vector2.new(-1, 0),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.42, 1),
            NumberSequenceKeypoint.new(0.5, 0.9), NumberSequenceKeypoint.new(0.58, 1),
            NumberSequenceKeypoint.new(1, 1),
        }),
    }, layer)
    local playing = false
    local function play()
        if playing or not layer.Parent then return end
        playing = true
        gradient.Offset = Vector2.new(-1, 0)
        local animation = TweenService:Create(gradient, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Offset = Vector2.new(1, 0),
        })
        animation:Play()
        animation.Completed:Connect(function() playing = false end)
    end
    connect(self, target.MouseEnter, play)
    return play
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

local function escapeRichText(value)
    return (tostring(value or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function colorHex(color)
    return string.format(
        "%02X%02X%02X",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5)
    )
end

-- Colors hard-coded by callers for the previous palette, remapped to this theme.
local LegacyTones = {
    FF8E9D = "danger", B0FFC2 = "success", FFCA5C = "warning",
    ["51E8FF"] = "info", ["5CCFFF"] = "info", ["15C6FF"] = "info",
    E51FDA = "accentText", A39BCA = "textMuted",
}

local function resolveTone(color, fallback)
    if typeof(color) ~= "Color3" then return fallback end
    local key = LegacyTones[colorHex(color)]
    return key and Theme[key] or color
end

local function statusTone(text, explicitColor)
    local upper = string.upper(tostring(text or "READY"))
    if explicitColor then return resolveTone(explicitColor, Theme.textPri), "Status" end
    if upper:find("COLLECTING", 1, true) or upper:find("WAIT", 1, true) or upper:find("ARMED", 1, true) then
        return Theme.warning, "Listening"
    end
    if upper:find("VERIFYING", 1, true) or upper:find("SOLVING", 1, true) or upper:find("AI", 1, true) then
        return Theme.accent, "AI Active"
    end
    if upper:find("REDEEMED", 1, true) or upper:find("COMPLETE", 1, true) or upper:find("SUBMITTED", 1, true) then
        return Theme.success, "Claimed"
    end
    if upper:find("CANCEL", 1, true) or upper:find("SOLD OUT", 1, true) or upper:find("STOPPED", 1, true) or upper:find("EXPIRED", 1, true) then
        return Theme.danger, "Halted"
    end
    return Theme.success, "Online"
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

local function makeButton(self, parent, options)
    local primary = options.Primary == true
    local card = makeCard(parent, options.Height or 42, options.Order)
    if options.Size then card.Size = options.Size end
    if options.Position then card.Position = options.Position end
    local outline = card:FindFirstChildOfClass("UIStroke")
    local control = {
        Frame = card,
        RestColor = options.Color or (primary and Color3.fromRGB(232, 232, 232) or Theme.bg2),
        RestTextColor = options.TextColor or (primary and Theme.activeTabText or Theme.textPri),
    }
    local hoverColor = options.HoverColor or (primary and Color3.new(1, 1, 1) or Theme.hover)
    card.BackgroundColor3 = control.RestColor
    if primary then
        card.BackgroundTransparency = 0
        create("UIGradient", {
            Color = ColorSequence.new(Theme.accentHover, Theme.accentDeep),
            Rotation = 90,
        }, card)
        outline.Color, outline.Transparency = Theme.accentHover, 0.55
    end
    local restStroke = outline.Transparency
    local button = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1, AutoButtonColor = false,
        FontFace = (options.Bold or primary) and Fonts.SemiBold or Fonts.Medium,
        TextSize = options.TextSize or 13,
        TextColor3 = control.RestTextColor,
        Text = options.Text or "", ZIndex = 3,
    }, card)
    control.Button = button
    local buttonScale = create("UIScale", {}, button)
    local playShine = shine(self, button, card)
    ripple(self, button, 10)
    connect(self, button.MouseEnter, function()
        TweenService:Create(card, Theme.tweenFast, { BackgroundColor3 = hoverColor }):Play()
        TweenService:Create(button, Theme.tweenFast, { TextColor3 = control.RestTextColor:Lerp(Color3.new(1, 1, 1), 0.3) }):Play()
        TweenService:Create(buttonScale, Theme.tweenFast, { Scale = 1.015 }):Play()
        TweenService:Create(outline, Theme.tweenFast, { Transparency = primary and 0.3 or 0.8 }):Play()
    end)
    connect(self, button.MouseLeave, function()
        TweenService:Create(card, Theme.tweenFast, { BackgroundColor3 = control.RestColor }):Play()
        TweenService:Create(button, Theme.tweenFast, { TextColor3 = control.RestTextColor }):Play()
        TweenService:Create(buttonScale, Theme.tweenFast, { Scale = 1 }):Play()
        TweenService:Create(outline, Theme.tweenFast, { Transparency = restStroke }):Play()
    end)
    connect(self, button.MouseButton1Down, function()
        TweenService:Create(buttonScale, Theme.tweenSnap, { Scale = 0.97 }):Play()
    end)
    connect(self, button.MouseButton1Up, function()
        TweenService:Create(buttonScale, Theme.tweenSpring, { Scale = 1.015 }):Play()
        playShine()
    end)
    if options.Callback then
        connect(self, button.Activated, function() emit(self, options.Callback) end)
    end
    return control
end

local function setToggle(control, enabled, instant)
    control.Value = enabled == true
    local on = control.Value
    local trackGoal = { BackgroundColor3 = on and Theme.toggleOn or Theme.toggleOff }
    local knobGoal = {
        Position = on
            and UDim2.new(0, Theme.toggleW - Theme.knobSz - 3, 0.5, -Theme.knobSz / 2)
            or UDim2.new(0, 3, 0.5, -Theme.knobSz / 2),
    }
    local trackStrokeGoal = { Transparency = on and 0.72 or 0.9 }
    local outlineGoal = {
        Color = on and Theme.accent or Theme.border,
        Transparency = on and 0.72 or Theme.borderTransparency,
    }
    if instant then
        control.Track.BackgroundColor3 = trackGoal.BackgroundColor3
        control.Knob.Position = knobGoal.Position
        control.KnobScale.Scale = 1
        control.TrackStroke.Transparency = trackStrokeGoal.Transparency
        control.Outline.Color, control.Outline.Transparency = outlineGoal.Color, outlineGoal.Transparency
    else
        TweenService:Create(control.Track, Theme.tweenFast, trackGoal):Play()
        TweenService:Create(control.Knob, Theme.tweenSpring, knobGoal):Play()
        TweenService:Create(control.TrackStroke, Theme.tweenFast, trackStrokeGoal):Play()
        TweenService:Create(control.Outline, Theme.tweenMed, outlineGoal):Play()
        control.KnobScale.Scale = on and 1.15 or 0.88
        TweenService:Create(control.KnobScale, Theme.tweenSpring, { Scale = 1 }):Play()
    end
end

local function makeToggle(self, parent, options)
    local card = makeCard(parent, 44, options.Order)
    local outline = card:FindFirstChildOfClass("UIStroke")
    makeText(card, tostring(options.Text or ""), {
        Size = UDim2.new(1, -76, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd,
    })
    local track = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.new(0, Theme.toggleW, 0, Theme.toggleH),
        BackgroundColor3 = Theme.toggleOff, BorderSizePixel = 0,
    }, card)
    corner(track, UDim.new(1, 0))
    local trackStroke = stroke(track, Theme.border, 1, 0.9)
    local knob = create("Frame", {
        Size = UDim2.new(0, Theme.knobSz, 0, Theme.knobSz),
        BackgroundColor3 = Theme.knob, BorderSizePixel = 0,
    }, track)
    corner(knob, UDim.new(1, 0))
    stroke(knob, Color3.new(0, 0, 0), 1, 0.82)
    local knobScale = create("UIScale", {}, knob)
    local button = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        AutoButtonColor = false, Text = "", ZIndex = 3,
    }, card)
    ripple(self, button, 10)
    local control = {
        Frame = card, Track = track, TrackStroke = trackStroke,
        Knob = knob, KnobScale = knobScale, Outline = outline,
    }
    setToggle(control, options.Value, true)
    connect(self, button.Activated, function()
        setToggle(control, not control.Value, false)
        emit(self, options.Callback, control.Value)
    end)
    connect(self, button.MouseEnter, function()
        TweenService:Create(card, Theme.tweenFast, { BackgroundColor3 = Theme.hover }):Play()
        TweenService:Create(knobScale, Theme.tweenFast, { Scale = 1.06 }):Play()
    end)
    connect(self, button.MouseLeave, function()
        TweenService:Create(card, Theme.tweenFast, { BackgroundColor3 = Theme.bg2 }):Play()
        TweenService:Create(knobScale, Theme.tweenFast, { Scale = 1 }):Play()
    end)
    control.Set = function(_, value, instant) setToggle(control, value, instant) end
    return control
end

local function clipInput(self, box)
    box.ClipsDescendants = true
    box.RichText = false
    box.TextScaled = false
    box.TextTruncate = Enum.TextTruncate.AtEnd
    connect(self, box.Focused, function()
        box.TextTruncate = Enum.TextTruncate.None
    end)
    connect(self, box.FocusLost, function()
        box.TextTruncate = Enum.TextTruncate.AtEnd
    end)
end

local function focusOutline(self, box, outline, restTransparency)
    connect(self, box.Focused, function()
        TweenService:Create(outline, Theme.tweenFast, { Color = Theme.accent, Transparency = 0.35 }):Play()
    end)
    connect(self, box.FocusLost, function()
        TweenService:Create(outline, Theme.tweenFast, { Color = Theme.border, Transparency = restTransparency }):Play()
    end)
end

local function makeInput(self, parent, options)
    local stacked = options.Stacked == true
    local inputWidth = options.InputWidth or 48
    local card = makeCard(parent, options.Height or (stacked and 78 or 44), options.Order)
    makeText(card, tostring(options.Text or ""), {
        Size = stacked and UDim2.new(1, -24, 0, 32) or UDim2.new(1, -inputWidth - 32, 1, 0),
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    local field = create("Frame", {
        AnchorPoint = stacked and Vector2.new() or Vector2.new(1, 0.5),
        Position = stacked and UDim2.new(0, 10, 0, 36) or UDim2.new(1, -10, 0.5, 0),
        Size = stacked and UDim2.new(1, -20, 0, 34) or UDim2.new(0, inputWidth, 0, 30),
        BackgroundColor3 = Theme.inputBg,
        BackgroundTransparency = Theme.inputTransparency,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, card)
    corner(field, UDim.new(0, 8))
    local outline = stroke(field, Theme.border, 1, 0.9)
    local box = create("TextBox", {
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(1, -16, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        MultiLine = false,
        TextWrapped = false,
        FontFace = Fonts.Medium,
        TextSize = options.TextSize or 13,
        TextColor3 = Theme.textPri,
        PlaceholderText = options.Placeholder or "",
        PlaceholderColor3 = Theme.textDim,
        TextXAlignment = options.Align or Enum.TextXAlignment.Center,
        Text = tostring(options.Value or ""),
    }, field)
    clipInput(self, box)
    focusOutline(self, box, outline, 0.9)
    connect(self, box.FocusLost, function()
        local replacement = emit(self, options.Callback, box.Text)
        if replacement ~= nil then box.Text = tostring(replacement) end
    end)
    hover(self, card, box)
    return { Frame = card, TextBox = box }
end

local function makeDropdown(self, parent, options)
    local baseHeight, labelHeight, headY, headHeight, menuY, optionStep, optionHeight = 74, 32, 35, 32, 74, 38, 34
    local card = makeCard(parent, baseHeight, options.Order)
    card.ZIndex = 20
    makeText(card, tostring(options.Text or ""), {
        Size = UDim2.new(1, -124, 0, labelHeight),
        Position = UDim2.new(0, 12, 0, 0),
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 21,
    })
    makePillBadge(card, tostring(options.Badge or "Recommended"), Theme.warning, UDim2.new(1, -10, 0, 16), 18, 22)
    local head = create("TextButton", {
        Position = UDim2.new(0, 10, 0, headY),
        Size = UDim2.new(1, -20, 0, headHeight),
        BackgroundColor3 = Theme.inputBg,
        BackgroundTransparency = Theme.inputTransparency,
        AutoButtonColor = false,
        FontFace = Fonts.Medium,
        TextSize = 13,
        TextColor3 = options.TextColor or Theme.textPri,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 23,
    }, card)
    corner(head, UDim.new(0, 8))
    stroke(head, Theme.border, 1, 0.9)
    local menu = create("Frame", {
        Position = UDim2.new(0, 10, 0, menuY),
        Size = UDim2.new(1, -20, 0, #options.Items * optionStep - 4),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 40,
    }, card)
    local optionButtons = {}
    local control = { Frame = card, Button = head, Menu = menu, Value = options.Value, Open = false }
    local function display(value)
        for _, item in ipairs(options.Items) do
            if item.Value == value then return item.Text end
        end
        return tostring(value or "")
    end
    local function refreshOptions()
        for index, item in ipairs(options.Items) do
            local opt = optionButtons[index]
            if opt then
                local selected = item.Value == control.Value
                opt.BackgroundColor3 = selected and Theme.hover or Theme.inputBg
                opt.TextColor3 = selected and (options.TextColor or Theme.accentText) or Theme.textPri
            end
        end
    end
    function control:SetOpen(open)
        self.Open = open == true
        if self.Open then
            for _, other in ipairs(self.Owner.Dropdowns) do
                if other ~= self and other.Open then other:SetOpen(false) end
            end
        end
        self.Menu.Visible = self.Open
        self.Frame.Size = UDim2.new(1, 0, 0, self.Open and baseHeight + 4 + #options.Items * optionStep or baseHeight)
        self.Button.Text = display(self.Value) .. (self.Open and "  ▲" or "  ▼")
        refreshOptions()
    end
    function control:Set(value)
        self.Value = value
        self:SetOpen(false)
    end
    for index, item in ipairs(options.Items) do
        local option = create("TextButton", {
            Size = UDim2.new(1, 0, 0, optionHeight),
            Position = UDim2.new(0, 0, 0, (index - 1) * optionStep),
            BackgroundColor3 = Theme.inputBg,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            FontFace = Fonts.Medium,
            TextSize = 13,
            TextColor3 = Theme.textPri,
            Text = item.Text,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 41,
        }, menu)
        corner(option, UDim.new(0, 8))
        stroke(option, Theme.border, 1, 0.92)
        optionButtons[index] = option
        connect(self, option.Activated, function()
            control:Set(item.Value)
            emit(self, options.Callback, item.Value)
        end)
        hover(self, option, option, Theme.inputBg)
    end
    connect(self, head.Activated, function() control:SetOpen(not control.Open) end)
    hover(self, head, head, Theme.inputBg)
    control.Owner = self
    control:SetOpen(false)
    table.insert(self.Dropdowns, control)
    return control
end

local function makeParagraph(parent, title, body, height, order)
    local card = makeCard(parent, height or 74, order)
    local bar = create("Frame", {
        Size = UDim2.new(0, 2, 1, -20), Position = UDim2.new(0, 8, 0, 10),
        BackgroundColor3 = Theme.accent, BorderSizePixel = 0,
    }, card)
    corner(bar, UDim.new(1, 0))
    makeText(card, tostring(title or ""), {
        Size = UDim2.new(1, -30, 0, 20), Position = UDim2.new(0, 18, 0, 8),
        FontFace = Fonts.SemiBold, TextSize = 13,
    })
    makeText(card, body, {
        Size = UDim2.new(1, -30, 1, -34), Position = UDim2.new(0, 18, 0, 29),
        FontFace = Fonts.Regular, TextSize = 12, TextColor3 = Theme.textMuted,
        TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
    })
    return card
end

local function makeStatusCard(parent, text, order)
    local card = makeCard(parent, 42, order)
    card.BackgroundColor3 = Theme.bg3
    local label = makeText(card, text, {
        Size = UDim2.new(1, -24, 1, 0), Position = UDim2.new(0, 12, 0, 0),
        FontFace = Fonts.SemiBold, TextSize = 12, TextColor3 = Theme.textMuted,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    return card, label
end

local TabData = {
    { "Home", "Code Redeemer", 610, 620 },
    { "Rules", "Trigger Matrix", 330, 340 },
    { "AI", "AI Engine", 520, 530 },
    { "Log", "Activity Log", 450, 470 },
    { "Sender", "Test Sender", 345, 355 },
    { "AA", "Admin Abuse", 620, 650 },
}

local function expandedSize(self, index)
    if self.VerticalLayout then
        return UDim2.new(0, Theme.desktopWidth, 0, TabData[index or self.ActiveTab][4])
    end
    return UDim2.new(0, Theme.mobileWidth, 0, math.min(TabData[index or self.ActiveTab][3], Theme.mobileMaxHeight))
end

local function collapsedSize(self)
    return UDim2.new(
        0,
        self.VerticalLayout and Theme.desktopWidth or Theme.mobileWidth,
        0,
        self.VerticalLayout and 50 or 48
    )
end

local function makePage(parent, scrolling, vertical)
    local page = create(scrolling and "ScrollingFrame" or "Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
    }, parent)
    if scrolling then
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = Theme.border
        page.ScrollBarImageTransparency = 0.7
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.CanvasSize = UDim2.new()
        page.ScrollingDirection = Enum.ScrollingDirection.Y
    end
    create("UIListLayout", {
        Padding = UDim.new(0, vertical and 7 or 6), SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Top,
    }, page)
    create("UIPadding", {
        PaddingLeft = UDim.new(0, vertical and 11 or 10), PaddingRight = UDim.new(0, vertical and 11 or 10),
        PaddingTop = UDim.new(0, vertical and 8 or 10), PaddingBottom = UDim.new(0, vertical and 8 or 10),
    }, page)
    return page
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

local function buildWindow(self)
    local view = self.View
    local headerHeight = self.VerticalLayout and 50 or 48
    local navHeight = 44
    local initialTab = math.clamp(math.floor(tonumber(self.Options.ActiveTab) or 1), 1, #TabData)
    local old = gethui():FindFirstChild("zelqynhubAutoCode")
    if old then old:Destroy() end

    view.Gui = create("ScreenGui", {
        Name = "zelqynhubAutoCode", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, gethui())
    view.Window = create("Frame", {
        Size = expandedSize(self, initialTab),
        Position = self.Options.Position or UDim2.new(
            0.5, -(self.VerticalLayout and Theme.desktopWidth or Theme.mobileWidth) / 2,
            0.5, -(self.VerticalLayout and TabData[initialTab][4] or TabData[initialTab][3]) / 2
        ),
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
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
    syncShadow()
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
    view.Background = create("ImageLabel", {
        Name = "ZelqynBackground", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        BorderSizePixel = 0, Image = Theme.backgroundAsset, ImageColor3 = Theme.accentHover,
        ImageTransparency = Theme.backgroundTransparency, ScaleType = Enum.ScaleType.Crop, ZIndex = 1,
    }, view.Window)
    corner(view.Background, UDim.new(0, 14))

    view.PumpkinLayer = create("Frame", {
        Name = "PumpkinRain", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 2,
    }, view.Window)
    view.Pumpkins = {}
    if Theme.pumpkinRain then
        local pumpkinSpecs = {
            { 0.07, -0.12, 19, 0.045 }, { 0.24, 0.18, 15, 0.032 },
            { 0.43, -0.32, 22, 0.039 }, { 0.62, 0.07, 17, 0.049 },
            { 0.82, -0.22, 20, 0.035 }, { 0.94, 0.31, 14, 0.043 },
            { 0.16, 0.55, 18, 0.038 }, { 0.51, 0.72, 16, 0.046 },
            { 0.76, 0.48, 21, 0.034 },
        }
        for index, spec in ipairs(pumpkinSpecs) do
            local label = create("TextLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(spec[1], spec[2]),
                Size = UDim2.fromOffset(spec[3] + 8, spec[3] + 8), BackgroundTransparency = 1,
                BorderSizePixel = 0, FontFace = Fonts.Bold, Text = "🎃",
                TextSize = spec[3], TextTransparency = 0.35, ZIndex = 2,
            }, view.PumpkinLayer)
            view.Pumpkins[index] = { Label = label, X = spec[1], Y = spec[2], Speed = spec[4], Phase = index * 0.71 }
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
            ColorSequenceKeypoint.new(0.5, Theme.accentHover),
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
    stroke(mark, Theme.accentHover, 1, 0.5)
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
    view.Mode = makeText(view.Header, TabData[initialTab][2], {
        Size = UDim2.new(0, 190, 0, 14), Position = UDim2.new(0, 52, 0, headerHeight / 2 + 2),
        TextSize = 11, TextColor3 = Theme.textMuted, ZIndex = 5,
    })
    view.HeaderReady = makePillBadge(view.Header, "Online", Theme.success, UDim2.new(1, -44, 0.5, 0), 22, 5, true)
    view.Minimize = create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
        BackgroundColor3 = Theme.hover, BackgroundTransparency = 1, BorderSizePixel = 0, AutoButtonColor = false,
        FontFace = Fonts.SemiBold, TextSize = 14, TextColor3 = Theme.textMuted, Text = "—", ZIndex = 5,
    }, view.Header)
    corner(view.Minimize, UDim.new(0, 8))

    view.Nav = create("Frame", {
        Position = UDim2.new(0, 0, 0, headerHeight), Size = UDim2.new(1, 0, 0, navHeight),
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 4,
    }, view.Window)
    local segment = create("Frame", {
        Name = "Segment", Position = UDim2.new(0, 10, 0, 3), Size = UDim2.new(1, -20, 1, -8),
        BackgroundColor3 = Theme.segment, BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = 4,
    }, view.Nav)
    corner(segment, UDim.new(0, 11))
    stroke(segment, Theme.border, 1, 0.9)
    padding(segment, 3, 3, 3, 3)
    view.TabHighlight = create("Frame", {
        Name = "Highlight", Size = UDim2.new(1 / #TabData, -2, 1, 0), Position = UDim2.new(0, 1, 0, 0),
        BackgroundColor3 = Theme.segmentActive, BackgroundTransparency = 0.05, BorderSizePixel = 0, ZIndex = 5,
    }, segment)
    corner(view.TabHighlight, UDim.new(0, 8))
    stroke(view.TabHighlight, Theme.border, 1, 0.88)
    create("UIGradient", {
        Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(212, 206, 208)), Rotation = 90,
    }, view.TabHighlight)

    view.Divider = create("Frame", {
        Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, headerHeight + navHeight),
        BackgroundColor3 = Theme.border, BackgroundTransparency = 0.92, BorderSizePixel = 0, ZIndex = 4,
    }, view.Window)
    view.Content = create("Frame", {
        Position = UDim2.new(0, 0, 0, headerHeight + navHeight + 1),
        Size = UDim2.new(1, 0, 1, -(headerHeight + navHeight + 1)),
        BackgroundTransparency = 1, ZIndex = 3,
    }, view.Window)
    for index, tab in ipairs(TabData) do
        local button = create("TextButton", {
            Size = UDim2.new(1 / #TabData, -2, 1, 0), Position = UDim2.new((index - 1) / #TabData, 1, 0, 0),
            BackgroundColor3 = Theme.hover, BackgroundTransparency = 1, BorderSizePixel = 0, AutoButtonColor = false,
            FontFace = Fonts.Medium, TextSize = 12, TextScaled = true,
            TextColor3 = Theme.textMuted, Text = tab[1], ZIndex = 6,
        }, segment)
        create("UITextSizeConstraint", { MinTextSize = 9, MaxTextSize = 12 }, button)
        corner(button, UDim.new(0, 8))
        view.TabButtons[index] = button
        view.Pages[index] = makePage(view.Content, index ~= 4, self.VerticalLayout)
        connect(self, button.Activated, function() self:SetTab(index) end)
        hoverFill(self, button, 1, 0.6, function() return self.ActiveTab == index end)
    end
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

function Controller:UpdateResponsiveScale(instant)
    local camera = workspace.CurrentCamera
    if not camera or not self.View.Window or not self.View.Scale then return 1 end
    local viewport = camera.ViewportSize
    local size = self.Minimized and collapsedSize(self) or expandedSize(self, self.ActiveTab)
    local width, height = math.max(1, size.X.Offset), math.max(1, size.Y.Offset)
    local fit = math.min((viewport.X - 20) / width, (viewport.Y - 20) / height)
    local target
    if UiLib.IsTouch then
        target = math.clamp(math.min(1, fit), 0.58, 1)
    else
        local desktopBase = math.clamp(viewport.Y / 960, 0.68, 0.90)
        target = math.clamp(math.min(fit, desktopBase), 0.58, 0.90)
    end
    self.ResponsiveScale = target
    if instant then
        self.View.Scale.Scale = target
    else
        TweenService:Create(self.View.Scale, Theme.tweenMed, { Scale = target }):Play()
    end
    return target
end

function Controller:SetTab(index, instant)
    index = math.clamp(math.floor(tonumber(index) or 1), 1, #TabData)
    self.ActiveTab = index
    for _, dropdown in ipairs(self.Dropdowns) do dropdown:SetOpen(false) end
    for current = 1, #TabData do
        local active = current == index
        local button = self.View.TabButtons[current]
        self.View.Pages[current].Visible = active
        button.BackgroundTransparency = 1
        button.FontFace = active and Fonts.SemiBold or Fonts.Medium
        local textColor = active and Theme.activeTabText or Theme.textMuted
        if instant then
            button.TextColor3 = textColor
        else
            TweenService:Create(button, Theme.tweenFast, { TextColor3 = textColor }):Play()
        end
    end
    local highlightPosition = UDim2.new((index - 1) / #TabData, 1, 0, 0)
    if instant then
        self.View.TabHighlight.Position = highlightPosition
    else
        TweenService:Create(self.View.TabHighlight, Theme.tweenSlide, { Position = highlightPosition }):Play()
    end
    self.View.Mode.Text = TabData[index][2]
    if not self.Minimized then
        local size = expandedSize(self, index)
        if instant then
            self.View.Window.Size = size
            self:UpdateResponsiveScale(true)
            self.View.Window.Position = self:Clamp(self.View.Window.Position)
        else
            local resize = TweenService:Create(self.View.Window, Theme.tweenMed, { Size = size })
            resize.Completed:Connect(function()
                if not self.Destroyed then
                    self:UpdateResponsiveScale(false)
                    self.View.Window.Position = self:Clamp(self.View.Window.Position)
                end
            end)
            resize:Play()
        end
    end
    if not instant then emit(self, "TabChanged", index) end
end

function Controller:SetMinimized(value, instant)
    self.Minimized = value == true
    self.View.Nav.Visible = not self.Minimized
    self.View.Divider.Visible = not self.Minimized
    self.View.Content.Visible = not self.Minimized
    self.View.Minimize.Text = self.Minimized and "+" or "—"
    local size = self.Minimized and collapsedSize(self) or expandedSize(self, self.ActiveTab)
    if instant then
        self.View.Window.Size = size
        self:UpdateResponsiveScale(true)
        self.View.Window.Position = self:Clamp(self.View.Window.Position)
    else
        local resize = TweenService:Create(self.View.Window, Theme.tweenMed, { Size = size })
        resize.Completed:Connect(function()
            if not self.Destroyed then
                self:UpdateResponsiveScale(false)
                self.View.Window.Position = self:Clamp(self.View.Window.Position)
            end
        end)
        resize:Play()
    end
    if not instant then emit(self, "MinimizedChanged", self.Minimized) end
end

local function wireWindow(self)
    local dragging, dragStart, startPosition = false, nil, nil
    connect(self, self.View.Minimize.Activated, function() self:SetMinimized(not self.Minimized) end)
    hoverFill(self, self.View.Minimize, 1, 0.55)
    connect(self, self.View.Header.InputBegan, function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging, dragStart, startPosition = true, input.Position, self.View.Window.Position
    end)
    connect(self, UserInputService.InputChanged, function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        self.View.Window.Position = self:Clamp(UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        ))
    end)
    connect(self, UserInputService.InputEnded, function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = false
        emit(self, "PositionChanged", self.View.Window.Position)
    end)
    if workspace.CurrentCamera then
        connect(self, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function()
            if self.View.Window.Parent then
                self.View.Window.Size = self.Minimized and collapsedSize(self) or expandedSize(self, self.ActiveTab)
                self:UpdateResponsiveScale(true)
                self.View.Window.Position = self:Clamp(self.View.Window.Position)
            end
        end)
    end
    local animationElapsed = 0
    connect(self, RunService.Heartbeat, function(delta)
        if not self.View.Gui.Enabled then return end
        animationElapsed = animationElapsed + delta
        if animationElapsed < (UiLib.IsTouch and 0.09 or 0.05) then return end
        local animationDelta = animationElapsed
        animationElapsed = 0
        local now = os.clock()
        for _, pumpkin in ipairs(self.View.Pumpkins or {}) do
            pumpkin.Y = pumpkin.Y + animationDelta * pumpkin.Speed
            if pumpkin.Y > 1.12 then
                pumpkin.Y = -0.14
                pumpkin.X = 0.04 + ((pumpkin.X + 0.37) % 0.92)
            end
            pumpkin.Label.Position = UDim2.fromScale(pumpkin.X, pumpkin.Y)
            pumpkin.Label.Rotation = math.sin(now * 0.9 + pumpkin.Phase) * 16
        end
        self.View.Glow.Rotation = (now * 48) % 360
        if self.View.StatusHalo then
            local pulse = 0.5 + 0.5 * math.sin(now * 3.4)
            self.View.StatusHalo.BackgroundTransparency = 0.7 + 0.22 * pulse
        end
    end)
end

local function buildHome(self)
    local page = self.View.Pages[1]
    local statusCard = makeCard(page, 40, 1)
    statusCard.BackgroundColor3 = Theme.bg3
    self.View.StatusHalo = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 19, 0.5, 0),
        BackgroundColor3 = Theme.success, BackgroundTransparency = 0.78, BorderSizePixel = 0,
    }, statusCard)
    corner(self.View.StatusHalo, UDim.new(1, 0))
    self.View.StatusDot = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0, 19, 0.5, 0),
        BackgroundColor3 = Theme.success, BorderSizePixel = 0,
    }, statusCard)
    corner(self.View.StatusDot, UDim.new(1, 0))
    self.View.ScanStatus = makeText(statusCard, "READY  ·  PRESS " .. self.KeyCode.Name .. " TO CLAIM AI", {
        Size = UDim2.new(1, -126, 1, 0), Position = UDim2.new(0, 34, 0, 0),
        FontFace = Fonts.SemiBold, TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd,
    })
    self.View.ScanBadge = makePillBadge(statusCard, "Online", Theme.success, UDim2.new(1, -9, 0.5, 0), 20, 4, true)

    local messageCard = makeCard(page, 74, 2)
    makeText(messageCard, "Last Detected", {
        Size = UDim2.new(1, -110, 0, 18), Position = UDim2.new(0, 12, 0, 6),
        FontFace = Fonts.SemiBold, TextSize = 11, TextColor3 = Theme.textMuted,
    })
    local hasInitialMsg = self.Options.LastMessage and self.Options.LastMessage ~= ""
    self.View.LastDetectedBadge = makePillBadge(
        messageCard, hasInitialMsg and "Captured" or "Standby",
        hasInitialMsg and Theme.success or Theme.textDim,
        UDim2.new(1, -10, 0, 15), 18, 4, true
    )
    if not hasInitialMsg then self.View.LastDetectedBadge.TextColor3 = Theme.textMuted end
    local messageBox = create("Frame", {
        Position = UDim2.new(0, 10, 0, 28), Size = UDim2.new(1, -20, 0, 38),
        BackgroundColor3 = Theme.inputBg, BackgroundTransparency = Theme.inputTransparency,
        BorderSizePixel = 0, ClipsDescendants = true,
    }, messageCard)
    corner(messageBox, UDim.new(0, 8))
    stroke(messageBox, Theme.border, 1, 0.92)
    local msgBar = create("Frame", {
        Size = UDim2.new(0, 2, 1, -14), Position = UDim2.new(0, 8, 0, 7),
        BackgroundColor3 = Theme.accent, BorderSizePixel = 0,
    }, messageBox)
    corner(msgBar, UDim.new(1, 0))
    self.View.LastMessage = makeText(messageBox, hasInitialMsg and self.Options.LastMessage or "Waiting for a notification...", {
        Size = UDim2.new(1, -28, 1, 0), Position = UDim2.new(0, 18, 0, 0),
        TextSize = 13, TextColor3 = hasInitialMsg and Theme.textPri or Theme.textMuted,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })

    local actions = create("Frame", { Size = UDim2.new(1, 0, 0, 86), BackgroundTransparency = 1, LayoutOrder = 3 }, page)
    makeButton(self, actions, {
        Text = "Start Scan", Callback = "StartScan", TextColor = Theme.textPri,
        Size = UDim2.new(0.333, -4, 0, 40), Position = UDim2.new(0, 0, 0, 0),
    })
    makeButton(self, actions, {
        Text = "Force AI", Callback = "ForceAI", TextColor = Theme.accentText,
        Size = UDim2.new(0.333, -4, 0, 40), Position = UDim2.new(0.333, 2, 0, 0),
    })
    makeButton(self, actions, {
        Text = "Cancel All", Callback = "CancelAll", TextColor = Theme.danger,
        Size = UDim2.new(0.334, -4, 0, 40), Position = UDim2.new(0.666, 4, 0, 0),
    })
    makeButton(self, actions, {
        Text = "Claim Last AI", Callback = "ClaimLastAI",
        Bold = true, Primary = true, TextSize = 13,
        Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 46),
    })

    self.Controls.AutoCode = makeToggle(self, page, {
        Text = "Auto Enter Code", Value = self.State.AutoCode, Order = 4, Callback = "AutoCodeChanged",
    })

    local keyCard = makeCard(page, 44, 5)
    makeText(keyCard, "Claim AI Key", { Size = UDim2.new(1, -120, 1, 0) })
    self.View.KeyButton = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -42, 0.5, 0), Size = UDim2.new(0, 66, 0, 28),
        BackgroundColor3 = Theme.inputBg, BackgroundTransparency = Theme.inputTransparency,
        BorderSizePixel = 0, AutoButtonColor = false,
        FontFace = Fonts.SemiBold, TextSize = 12, TextColor3 = Theme.accentText, Text = self.KeyCode.Name,
    }, keyCard)
    corner(self.View.KeyButton, UDim.new(0, 8))
    stroke(self.View.KeyButton, Theme.border, 1, 0.88)
    hover(self, self.View.KeyButton, self.View.KeyButton, Theme.inputBg, Theme.hover)
    local resetKey = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.new(0, 28, 0, 28),
        BackgroundColor3 = Theme.inputBg, BackgroundTransparency = Theme.inputTransparency,
        BorderSizePixel = 0, AutoButtonColor = false,
        FontFace = Fonts.SemiBold, TextSize = 15, TextColor3 = Theme.textMuted, Text = "×",
    }, keyCard)
    corner(resetKey, UDim.new(0, 8))
    stroke(resetKey, Theme.border, 1, 0.9)
    hover(self, resetKey, resetKey, Theme.inputBg, Theme.hover)
    connect(self, self.View.KeyButton.Activated, function()
        self.WaitingForKey = not self.WaitingForKey
        self.View.KeyButton.Text = self.WaitingForKey and "PRESS..." or self.KeyCode.Name
        self.View.KeyButton.TextColor3 = self.WaitingForKey and Theme.warning or Theme.accentText
    end)
    connect(self, resetKey.Activated, function()
        self.WaitingForKey = false
        self.KeyCode = Enum.KeyCode.F6
        self.View.KeyButton.Text = self.KeyCode.Name
        self.View.KeyButton.TextColor3 = Theme.accentText
        if self.View.ScanStatus and self.View.ScanStatus.Text:find("PRESS ", 1, true) then
            self.View.ScanStatus.Text = "READY  ·  PRESS " .. self.KeyCode.Name .. " TO CLAIM AI"
        end
        emit(self, "ClaimKeyChanged", self.KeyCode)
    end)
    connect(self, UserInputService.InputBegan, function(input, processed)
        if self.WaitingForKey then
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            self.WaitingForKey = false
            if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.Unknown then
                self.KeyCode = input.KeyCode
                if self.View.ScanStatus and self.View.ScanStatus.Text:find("PRESS ", 1, true) then
                    self.View.ScanStatus.Text = "READY  ·  PRESS " .. self.KeyCode.Name .. " TO CLAIM AI"
                end
                emit(self, "ClaimKeyChanged", input.KeyCode)
            end
            self.View.KeyButton.Text = self.KeyCode.Name
            self.View.KeyButton.TextColor3 = Theme.accentText
            return
        end
        if processed or UserInputService:GetFocusedTextBox() then return end
        if input.KeyCode == self.KeyCode then emit(self, "ClaimLastAI") end
    end)

    makeButton(self, page, {
        Text = "Copy Discord Invite", Callback = "CopyDiscord", Order = 6,
        TextColor = Theme.textPri, Bold = true, Height = 40,
    })
end

local function buildRules(self)
    local page = self.View.Pages[2]
    local card = makeCard(page, 212, 1)
    makeText(card, "Normal Triggers", { Size = UDim2.new(1, -130, 0, 36), FontFace = Fonts.SemiBold, TextSize = 13 })
    makePillBadge(card, "Blank = None", Theme.textMuted, UDim2.new(1, -10, 0, 18), 18, 4)
    create("Frame", {
        Size = UDim2.new(1, -16, 0, 1), Position = UDim2.new(0, 8, 0, 36),
        BackgroundColor3 = Theme.border, BackgroundTransparency = 0.92, BorderSizePixel = 0,
    }, card)
    local scroll = create("ScrollingFrame", {
        Size = UDim2.new(1, -12, 0, 162), Position = UDim2.new(0, 6, 0, 42),
        BackgroundColor3 = Theme.bg0, BackgroundTransparency = 0.35,
        BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.border,
        ScrollBarImageTransparency = 0.75,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ClipsDescendants = true,
    }, card)
    corner(scroll, UDim.new(0, 8))
    create("UIListLayout", {
        Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    }, scroll)
    padding(scroll, 6, 6, 6, 6)
    for index = 1, 10 do
        local slot = create("Frame", {
            Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.inputBg,
            BackgroundTransparency = Theme.inputTransparency, BorderSizePixel = 0,
            LayoutOrder = index, ClipsDescendants = true,
        }, scroll)
        corner(slot, UDim.new(0, 7))
        local outline = stroke(slot, Theme.border, 1, 0.92)
        local badge = makeText(slot, string.format("%02d", index), {
            Size = UDim2.new(0, 22, 0, 20), Position = UDim2.new(0, 6, 0.5, -10),
            BackgroundTransparency = 0.2, BackgroundColor3 = Theme.bg2,
            FontFace = Fonts.SemiBold, TextSize = 10, TextColor3 = Theme.textMuted,
            TextXAlignment = Enum.TextXAlignment.Center,
        })
        corner(badge, UDim.new(0, 6))
        local box = create("TextBox", {
            Size = UDim2.new(1, -40, 1, -4), Position = UDim2.new(0, 34, 0, 2),
            BackgroundTransparency = 1, BorderSizePixel = 0, ClearTextOnFocus = false,
            FontFace = Fonts.Medium, TextSize = 13, TextColor3 = Theme.textPri,
            PlaceholderText = "keyword " .. index, PlaceholderColor3 = Theme.textDim,
            TextXAlignment = Enum.TextXAlignment.Left, Text = (self.Options.Keywords or {})[index] or "",
        }, slot)
        clipInput(self, box)
        focusOutline(self, box, outline, 0.92)
        connect(self, box.FocusLost, function()
            emit(self, "KeywordChanged", index, box.Text)
        end)
        connect(self, box:GetPropertyChangedSignal("Text"), function() emit(self, "KeywordEdited", index, box.Text) end)
    end
end

local function buildAI(self)
    local page = self.View.Pages[3]
    self.Controls.AIAnswers = makeToggle(self, page, {
        Text = "Use AI Answers", Value = self.State.AIAnswers, Order = 1, Callback = "AIAnswersChanged",
    })
    self.Controls.AITriggers = makeInput(self, page, {
        Text = "AI Triggers", Value = table.concat(self.State.AITriggers or {}, ", "),
        Placeholder = "Question, riddle", Stacked = true, Align = Enum.TextXAlignment.Left,
        Order = 2, Callback = "AITriggersChanged",
    })
    self.Controls.MinCharacters = makeInput(self, page, {
        Text = "Min Characters", Value = self.State.MinCharacters, Order = 3, Callback = "MinCharactersChanged",
    })
    self.Controls.MinSpaces = makeInput(self, page, {
        Text = "Min Spaces", Value = self.State.MinSpaces, Order = 4, Callback = "MinSpacesChanged",
    })
    makeParagraph(page, "Dual AI Engine", "Gemini Flash Lite + GPT-oss/Cerebras run together. Each distinct answer is redeemed as soon as it arrives; matching answers are sent once.", 96, 5)
end

local function buildLog(self)
    local page = self.View.Pages[4]
    for _, child in ipairs(page:GetChildren()) do child:Destroy() end
    self.View.LogScroll = create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -62), Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Theme.bg0, BackgroundTransparency = 0.3,
        BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.border,
        ScrollBarImageTransparency = 0.72,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ClipsDescendants = true,
    }, page)
    corner(self.View.LogScroll, UDim.new(0, 10))
    stroke(self.View.LogScroll)
    create("UIListLayout", {
        Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Left,
    }, self.View.LogScroll)
    padding(self.View.LogScroll, 10, 10, 8, 8)
    local clear = makeButton(self, page, {
        Text = "Clear Activity Log", Bold = true,
        Size = UDim2.new(1, -20, 0, 38), Position = UDim2.new(0, 10, 1, -48),
    })
    self.View.LogCount = makeText(clear.Frame, "0 lines", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0, 80, 0, 16),
        TextSize = 11, TextColor3 = Theme.textDim, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 4,
    })
    connect(self, clear.Button.Activated, function()
        self:ClearLog()
        emit(self, "ClearLog")
    end)
end

local function buildSender(self)
    local page = self.View.Pages[5]
    local inputCard = makeCard(page, 126, 1)
    inputCard.ClipsDescendants = true
    makeText(inputCard, "Notification Message", {
        Size = UDim2.new(1, -110, 0, 26), Position = UDim2.new(0, 12, 0, 5),
        FontFace = Fonts.SemiBold, TextSize = 12,
    })
    makePillBadge(inputCard, "Test Feed", Theme.textMuted, UDim2.new(1, -10, 0, 18), 18, 4)
    self.View.SenderBox = create("TextBox", {
        Size = UDim2.new(1, -20, 0, 82), Position = UDim2.new(0, 10, 0, 34),
        BackgroundColor3 = Theme.inputBg, BackgroundTransparency = Theme.inputTransparency,
        BorderSizePixel = 0, ClearTextOnFocus = false,
        MultiLine = true, FontFace = Fonts.Medium, TextSize = 13,
        PlaceholderText = "Type a notification message to simulate...", PlaceholderColor3 = Theme.textDim,
        Text = "", TextColor3 = Theme.textPri, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
    }, inputCard)
    clipInput(self, self.View.SenderBox)
    corner(self.View.SenderBox, UDim.new(0, 8))
    padding(self.View.SenderBox, 10, 10, 8, 8)
    focusOutline(self, self.View.SenderBox, stroke(self.View.SenderBox, Theme.border, 1, 0.9), 0.9)
    local send = makeButton(self, page, { Text = "Send Notification", Bold = true, Primary = true, Order = 2 })
    connect(self, send.Button.Activated, function()
        local message = self.View.SenderBox.Text:match("^%s*(.-)%s*$")
        local ok, status = emit(self, "SendNotification", message)
        self:SetSenderStatus(status, ok)
    end)
    local _, senderStatus = makeStatusCard(page, self.State.NotificationReady and "Remote ready" or "Remote unavailable", 3)
    senderStatus.TextColor3 = self.State.NotificationReady and Theme.success or Theme.textMuted
    self.View.SenderStatus = senderStatus
end

local function buildAA(self)
    local page = self.View.Pages[6]
    self.Controls.Anchor = makeToggle(self, page, { Text = "Anchor", Value = self.State.Anchor, Order = 1, Callback = "AnchorChanged" })
    self.Controls.MaxBrainrotPrice = makeInput(self, page, {
        Text = "Buy / Sell Max Price", Value = self.State.MaxBrainrotPrice or "5m",
        Placeholder = "5m", InputWidth = 96, Order = 2, Callback = "MaxBrainrotPriceChanged",
    })
    self.Controls.AutoPurchase = makeToggle(self, page, {
        Text = "Auto Purchase", Value = self.State.AutoPurchase, Order = 3, Callback = "AutoPurchaseChanged",
    })
    makeParagraph(page, "Auto Purchase", "Purchases the nearest brainrot at 10 studs or less only when its base Price is at or below the limit.", 76, 4)
    local _, aaStatus = makeStatusCard(page, "Ready", 5)
    self.View.AAStatus = aaStatus
    self.Controls.AutoSell = makeToggle(self, page, {
        Text = "Auto Sell", Value = self.State.AutoSell, Order = 6, Callback = "AutoSellChanged",
    })
    makeParagraph(page, "Auto Sell", "Sells only your own plot's brainrots whose base Price is at or below the same limit. Higher-priced brainrots stay safe.", 76, 7)
    local _, aaSellStatus = makeStatusCard(page, "Auto Sell disabled", 8)
    self.View.AASellStatus = aaSellStatus
    self.Controls.Optimizer = makeButton(self, page, {
        Text = "Optimize Game (One-Way)", Order = 9, Callback = "OptimizeGame", TextColor = Theme.warning, Bold = true,
    })
    makeParagraph(page, "Optimizer", "Permanently removes heavy client-side effects, textures and non-player cosmetics for this server session. Rejoin to restore them.", 76, 10)
    local _, optimizerStatus = makeStatusCard(page, "Not optimized", 11)
    self.View.OptimizerStatus = optimizerStatus
end

function Controller:SetLastMessage(text)
    if not self.View.LastMessage then return end
    local value = tostring(text or "")
    local hasMsg = value ~= ""
    self.View.LastMessage.Text = hasMsg and value or "Waiting for a notification..."
    self.View.LastMessage.TextColor3 = hasMsg and Theme.textPri or Theme.textMuted
    setPill(
        self.View.LastDetectedBadge, hasMsg and "Captured" or "Standby",
        hasMsg and Theme.success or Theme.textDim, hasMsg and Theme.textPri or Theme.textMuted
    )
end

function Controller:SetScanStatus(text, color)
    if not self.View.ScanStatus then return end
    local tone, badgeLabel = statusTone(text, color)
    self.View.ScanStatus.Text = tostring(text or "READY")
    self.View.ScanStatus.TextColor3 = badgeLabel == "Online" and Theme.textPri or tone
    if self.View.StatusDot then self.View.StatusDot.BackgroundColor3 = tone end
    if self.View.StatusHalo then self.View.StatusHalo.BackgroundColor3 = tone end
    setPill(self.View.ScanBadge, badgeLabel, tone)
    setPill(self.View.HeaderReady, badgeLabel, tone)
end

function Controller:DismissNotification(entry)
    if not entry or entry.Closed then return end
    entry.Closed = true
    if entry.Timer then pcall(task.cancel, entry.Timer); entry.Timer = nil end
    if entry.Connection then entry.Connection:Disconnect() end
    if entry.ProgressTween then entry.ProgressTween:Cancel() end
    if entry.Card.Parent then entry.Card:Destroy() end
    if entry.Key and self.NotificationKeys[entry.Key] == entry then self.NotificationKeys[entry.Key] = nil end
    local index = table.find(self.Notifications, entry)
    if index then table.remove(self.Notifications, index) end
end

-- ui:Notify({Title="Notice", Content="Message", Type="success", Duration=6, Key="optional"})
function Controller:Notify(options)
    if self.Destroyed or not self.View.Gui or not self.View.Gui.Parent then return end
    options = type(options) == "table" and options or { Content = tostring(options or "") }
    self.Notifications, self.NotificationKeys = self.Notifications or {}, self.NotificationKeys or {}
    local key = options.Key and tostring(options.Key)
    if key then self:DismissNotification(self.NotificationKeys[key]) end
    while #self.Notifications >= 3 do self:DismissNotification(self.Notifications[1]) end
    if not self.View.Notifications then
        self.View.Notifications = create("Frame", {
            Name = "Notifications", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16),
            Size = UDim2.new(1, -32, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 100,
        }, self.View.Gui)
        create("UISizeConstraint", { MaxSize = Vector2.new(340, math.huge) }, self.View.Notifications)
        create("UIListLayout", {
            Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Bottom,
        }, self.View.Notifications)
    end
    local tone = options.Type == "success" and Theme.success or options.Type == "warning" and Theme.warning
        or options.Type == "error" and Theme.danger or Theme.info
    local duration = tonumber(options.Duration) or 6
    if duration ~= duration then duration = 6 end
    duration = math.clamp(duration, 2, 15)
    self.NotificationOrder = (self.NotificationOrder or 0) + 1
    local card = create("Frame", {
        Name = "Notice", Size = UDim2.new(1, 0, 0, 110), BackgroundColor3 = Theme.bg1,
        BackgroundTransparency = 0.04, BorderSizePixel = 0, ClipsDescendants = true,
        LayoutOrder = self.NotificationOrder, ZIndex = 100,
    }, self.View.Notifications)
    corner(card, UDim.new(0, 12))
    stroke(card, Theme.border, 1, 0.86)
    local wash = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = tone, BorderSizePixel = 0, ZIndex = 100,
    }, card)
    corner(wash, UDim.new(0, 12))
    create("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.84), NumberSequenceKeypoint.new(0.55, 1), NumberSequenceKeypoint.new(1, 1),
        }),
    }, wash)
    local halo = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 20, 0, 20), Size = UDim2.new(0, 16, 0, 16),
        BackgroundColor3 = tone, BackgroundTransparency = 0.78, BorderSizePixel = 0, ZIndex = 101,
    }, card)
    corner(halo, UDim.new(1, 0))
    local dot = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 7, 0, 7),
        BackgroundColor3 = tone, BorderSizePixel = 0, ZIndex = 102,
    }, halo)
    corner(dot, UDim.new(1, 0))
    makeText(card, tostring(options.Title or "Zelqyn Hub"):sub(1, 100), {
        Position = UDim2.new(0, 34, 0, 9), Size = UDim2.new(1, -70, 0, 22),
        FontFace = Fonts.SemiBold, TextSize = 13, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 102,
    })
    makeText(card, tostring(options.Content or options.Message or ""):sub(1, 500), {
        Position = UDim2.new(0, 14, 0, 36), Size = UDim2.new(1, -28, 0, 60),
        FontFace = Fonts.Regular, TextSize = 12, TextColor3 = Theme.textMuted,
        TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, TextTruncate = Enum.TextTruncate.AtEnd,
        RichText = false, ZIndex = 102,
    })
    local close = create("TextButton", {
        Position = UDim2.new(1, -32, 0, 5), Size = UDim2.new(0, 28, 0, 28), BackgroundTransparency = 1,
        Text = "×", FontFace = Fonts.Medium, TextSize = 20, TextColor3 = Theme.textMuted, ZIndex = 103,
    }, card)
    local progress = create("Frame", {
        Position = UDim2.new(0, 0, 1, -2), Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = tone,
        BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 102,
    }, card)
    local entry = { Card = card, Key = key }
    table.insert(self.Notifications, entry)
    if key then self.NotificationKeys[key] = entry end
    entry.Connection = close.Activated:Connect(function() self:DismissNotification(entry) end)
    entry.ProgressTween = TweenService:Create(progress, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 0, 2) })
    entry.ProgressTween:Play()
    entry.Timer = task.delay(duration, function() entry.Timer = nil; self:DismissNotification(entry) end)
    local scale = create("UIScale", { Scale = 0.94 }, card)
    TweenService:Create(scale, Theme.tweenSpring, { Scale = 1 }):Play()
    return entry
end

-- ui:NotifyRedeem(code, "success" or "sold_out", invokeMessage)
function Controller:NotifyRedeem(code, status, message)
    if status == "valid" then status = "success" end
    if status ~= "success" and status ~= "sold_out" then return end
    local key = "redeem:" .. tostring(code):lower()
    local previous = self.NotificationKeys and self.NotificationKeys[key]
    if previous and previous.RedeemStatus == "success" then return previous end
    local plain = tostring(message or ""):gsub("<[^>]+>", ""):match("^%s*(.-)%s*$")
    local entry = self:Notify({
        Title = status == "success" and "Code Redeemed" or "Code Sold Out",
        Content = tostring(code) .. (plain ~= "" and "\n" .. plain or ""),
        Type = status == "success" and "success" or "warning", Duration = 7, Key = key,
    })
    if entry then entry.RedeemStatus = status end
    return entry
end

function Controller:SetAAStates(anchorEnabled, purchaseEnabled, sellEnabled)
    if self.Controls.Anchor then self.Controls.Anchor:Set(anchorEnabled, false) end
    if self.Controls.AutoPurchase then self.Controls.AutoPurchase:Set(purchaseEnabled, false) end
    if self.Controls.AutoSell then self.Controls.AutoSell:Set(sellEnabled, false) end
end

function Controller:SetAAStatus(text, color)
    if not self.View.AAStatus then return end
    self.View.AAStatus.Text, self.View.AAStatus.TextColor3 = tostring(text or "Ready"), resolveTone(color, Theme.textMuted)
end

function Controller:SetAASellStatus(text, color)
    if not self.View.AASellStatus then return end
    self.View.AASellStatus.Text, self.View.AASellStatus.TextColor3 = tostring(text or "Auto Sell disabled"), resolveTone(color, Theme.textMuted)
end

function Controller:SetOptimizerStatus(text, color)
    if not self.View.OptimizerStatus then return end
    self.View.OptimizerStatus.Text, self.View.OptimizerStatus.TextColor3 = tostring(text or "Not optimized"), resolveTone(color, Theme.textMuted)
end

function Controller:SetOptimizerApplied(applied)
    local control = self.Controls.Optimizer; if not control then return end
    applied = applied == true
    control.Button.Active, control.Button.Selectable = not applied, not applied
    control.Button.Text = applied and "Optimized · Rejoin to Restore" or "Optimize Game (One-Way)"
    control.RestTextColor = applied and Theme.success or Theme.warning
    control.RestColor = applied and Theme.bg3 or Theme.bg2
    control.Button.TextColor3 = control.RestTextColor
    control.Frame.BackgroundColor3 = control.RestColor
end

function Controller:SetSenderStatus(text, successful)
    if not self.View.SenderStatus then return end
    self.View.SenderStatus.Text = tostring(text or "Ready")
    self.View.SenderStatus.TextColor3 = successful == true and Theme.success
        or successful == false and Theme.danger
        or Theme.textMuted
end

function Controller:Log(entry)
    if not self.View.LogScroll then return end
    local raw = tostring(entry or "")
    local timestamp, message = raw:match("^%[([^%]]+)%]%s*(.*)$")
    timestamp, message = timestamp or "--:--:--", message or raw
    local formatted = string.format(
        '<font color="#%s">%s</font>   <font color="#%s">%s</font>',
        colorHex(Theme.textDim), escapeRichText(timestamp),
        colorHex(logColor(message)), escapeRichText(message)
    )
    local label = makeText(self.View.LogScroll, formatted, {
        Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.new(), FontFace = Fonts.Medium, TextSize = 12,
        TextWrapped = true, RichText = true,
    })
    if not UiLib.IsTouch then
        label.TextTransparency = 1
        TweenService:Create(label, Theme.tweenFast, { TextTransparency = 0 }):Play()
    end
    table.insert(self.LogLabels, label)
    if #self.LogLabels > self.MaxLogEntries then
        local oldest = table.remove(self.LogLabels, 1)
        if oldest and oldest.Parent then oldest:Destroy() end
    end
    if self.View.LogCount then self.View.LogCount.Text = #self.LogLabels .. " lines" end
    if self.LogScrollPending then return end
    self.LogScrollPending = true
    task.defer(function()
        self.LogScrollPending = false
        if self.View.LogScroll and self.View.LogScroll.Parent then
            self.View.LogScroll.CanvasPosition = Vector2.new(0, math.huge)
        end
    end)
end

function Controller:ClearLog()
    for _, label in ipairs(self.LogLabels) do
        if label.Parent then label:Destroy() end
    end
    self.LogLabels = {}
    if self.View.LogCount then self.View.LogCount.Text = "0 lines" end
end

function Controller:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
    while self.Notifications and #self.Notifications > 0 do self:DismissNotification(self.Notifications[1]) end
    for index = #self.Connections, 1, -1 do
        local connection = self.Connections[index]
        if connection then connection:Disconnect() end
        self.Connections[index] = nil
    end
    if self.View.Gui and self.View.Gui.Parent then self.View.Gui:Destroy() end
    if UiLib.Active == self then UiLib.Active = nil end
end

function UiLib.CreateRedeemer(options)
    if UiLib.Active then UiLib.Active:Destroy() end
    local self = setmetatable({
        Options = options or {},
        State = (options and options.State) or {},
        Callbacks = (options and options.Callbacks) or {},
        Connections = {},
        Dropdowns = {},
        Controls = {},
        LogLabels = {},
        Notifications = {},
        NotificationKeys = {},
        MaxLogEntries = (options and options.MaxLogEntries) or (UiLib.IsTouch and 80 or 140),
        View = { Pages = {}, TabButtons = {}, TabStrokes = {}, Indicators = {} },
        ActiveTab = 1,
        VerticalLayout = UiLib.DesktopVertical,
        Minimized = false,
        WaitingForKey = false,
        KeyCode = (options and options.KeyCode) or Enum.KeyCode.F6,
        Destroyed = false,
    }, Controller)
    UiLib.Active = self
    buildWindow(self)
    buildHome(self)
    buildRules(self)
    buildAI(self)
    buildLog(self)
    buildSender(self)
    buildAA(self)
    self:SetOptimizerApplied(self.State.OptimizerApplied == true)
    wireWindow(self)
    self:SetTab(self.Options.ActiveTab or 1, true)
    self:SetMinimized(self.Options.Minimized, true)
    local targetScale = self:UpdateResponsiveScale(true)
    self.View.Scale.Scale = targetScale * 0.92
    self.View.Window.Position = self:Clamp(self.View.Window.Position)
    task.defer(function()
        if not self.Destroyed and self.View.Window.Parent then
            self.View.Window.Position = self:Clamp(self.View.Window.Position)
        end
    end)
    for _, entry in ipairs(self.Options.Logs or {}) do self:Log(entry) end
    TweenService:Create(self.View.Scale, Theme.tweenSpring, { Scale = targetScale }):Play()
    return self
end

function UiLib.destroy()
    if UiLib.Active then UiLib.Active:Destroy() end
end

return UiLib
