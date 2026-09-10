local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))

local UiLib = {
    Name = "Zelqyn Hub",
    IsTouch = UserInputService.TouchEnabled,
    Theme = {
        bg0 = Color3.fromRGB(2, 0, 16),
        bg1 = Color3.fromRGB(7, 3, 31),
        bg2 = Color3.fromRGB(16, 8, 57),
        bg3 = Color3.fromRGB(5, 2, 25),
        hover = Color3.fromRGB(39, 17, 103),
        accent = Color3.fromRGB(119, 47, 255),
        accentDim = Color3.fromRGB(48, 23, 123),
        accentSec = Color3.fromRGB(241, 30, 219),
        accentCyan = Color3.fromRGB(0, 207, 255),
        accentBlue = Color3.fromRGB(48, 82, 255),
        activeTabText = Color3.fromRGB(249, 248, 255),
        toggleOff = Color3.fromRGB(31, 24, 70),
        toggleOn = Color3.fromRGB(180, 29, 246),
        knob = Color3.fromRGB(236, 248, 255),
        textPri = Color3.fromRGB(242, 242, 255),
        textMuted = Color3.fromRGB(137, 128, 187),
        inputBg = Color3.fromRGB(3, 1, 20),
        success = Color3.fromRGB(176, 255, 194),
        warning = Color3.fromRGB(255, 202, 92),
        danger = Color3.fromRGB(255, 142, 157),
        info = Color3.fromRGB(92, 207, 255),
        tweenFast = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        tweenMed = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        tweenSnap = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        tweenSpring = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        toggleW = 40,
        toggleH = 20,
        knobSz = 16,
        rippleAsset = "rbxassetid://266543268",
    },
    Active = nil,
}

local Theme = UiLib.Theme
local Controller = {}
Controller.__index = Controller

local function create(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do object[property] = value end
    object.Parent = parent
    return object
end

local function corner(parent, radius)
    return create("UICorner", { CornerRadius = radius or UDim.new(0, 7) }, parent)
end

local function stroke(parent, color, thickness, transparency)
    local outline = create("UIStroke", {
        Color = color or Theme.accent,
        Thickness = thickness or 1,
        Transparency = transparency or 0.38,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
    create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.accentCyan),
            ColorSequenceKeypoint.new(0.34, Theme.accentBlue),
            ColorSequenceKeypoint.new(0.68, Theme.accentSec),
            ColorSequenceKeypoint.new(1, color or Theme.accent),
        }),
        Rotation = 18,
    }, outline)
    return outline
end

local function surface(parent, rotation)
    return create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.accentCyan),
            ColorSequenceKeypoint.new(0.4, Theme.accentBlue),
            ColorSequenceKeypoint.new(0.72, Theme.accentSec),
            ColorSequenceKeypoint.new(1, Theme.accent),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.04),
            NumberSequenceKeypoint.new(0.5, 0.12),
            NumberSequenceKeypoint.new(1, 0.05),
        }),
        Rotation = rotation or 8,
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

local function gloss(parent, strength)
    local amount = strength or 0.12
    return create("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.48, Color3.new(0.97, 0.97, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1 - amount, 1 - amount, 1)),
        }),
    }, parent)
end

local function ripple(self, button, radius)
    local host = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = button.ZIndex,
    }, button)
    corner(host, UDim.new(0, radius or 7))
    connect(self, button.MouseButton1Down, function(x, y)
        local absolute = button.AbsolutePosition
        local size = button.AbsoluteSize
        local localX = math.clamp((x or absolute.X + size.X / 2) - absolute.X, 0, size.X)
        local localY = math.clamp((y or absolute.Y + size.Y / 2) - absolute.Y, 0, size.Y)
        local diameter = math.max(size.X, size.Y) * 2.2
        local circle = create("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, localX, 0, localY),
            Size = UDim2.new(),
            BackgroundTransparency = 1,
            Image = Theme.rippleAsset,
            ImageColor3 = Theme.accentCyan,
            ImageTransparency = 0.68,
            ZIndex = button.ZIndex + 1,
        }, host)
        local animation = TweenService:Create(circle, TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, diameter, 0, diameter),
            ImageTransparency = 1,
        })
        animation:Play()
        animation.Completed:Connect(function()
            if circle.Parent then circle:Destroy() end
        end)
    end)
end

local function shine(self, target, host)
    local layer = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        BackgroundTransparency = 0,
        ZIndex = math.max(target.ZIndex - 1, 1),
    }, host or target)
    corner(layer, UDim.new(0, 7))
    local gradient = create("UIGradient", {
        Rotation = 18,
        Offset = Vector2.new(-1, 0),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.42, 1),
            NumberSequenceKeypoint.new(0.5, 0.82),
            NumberSequenceKeypoint.new(0.58, 1),
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
        Size = UDim2.new(1, 0, 0, height or 34),
        BackgroundColor3 = Theme.bg2,
        BorderSizePixel = 0,
        LayoutOrder = order or 0,
    }, parent)
    corner(card)
    stroke(card, Theme.accentDim, 1)
    gloss(card, 0.12)
    return card
end

local function makeText(parent, text, properties)
    local values = {
        Size = UDim2.new(1, -24, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Theme.textPri,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = text or "",
    }
    for key, value in pairs(properties or {}) do values[key] = value end
    return create("TextLabel", values, parent)
end

local function escapeRichText(value)
    return tostring(value or "")
        :gsub("&", "&amp;")
        :gsub("<", "&lt;")
        :gsub(">", "&gt;")
end

local function colorHex(color)
    return string.format(
        "%02X%02X%02X",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5)
    )
end

local function logColor(message)
    local lower = tostring(message or ""):lower()
    if lower:find("error", 1, true)
        or lower:find("failed", 1, true)
        or lower:find("malformed", 1, true)
        or lower:find("unavailable", 1, true)
    then
        return Theme.danger
    end
    if lower:find("cancel", 1, true)
        or lower:find("waiting", 1, true)
        or lower:find("nothing pending", 1, true)
    then
        return Theme.warning
    end
    if lower:find("detected", 1, true)
        or lower:find("scanned", 1, true)
        or lower:find("question", 1, true)
        or lower:find("queued", 1, true)
    then
        return Theme.info
    end
    if lower:find("answer", 1, true)
        or lower:find("redeemed", 1, true)
        or lower:find("loaded", 1, true)
        or lower:find("ready", 1, true)
        or lower:find("enabled", 1, true)
        or lower:find("sent", 1, true)
        or lower:find("captured", 1, true)
    then
        return Theme.success
    end
    return Theme.textPri
end

local function makeButton(self, parent, options)
    local card = makeCard(parent, options.Height or 34, options.Order)
    if options.Size then card.Size = options.Size end
    if options.Position then card.Position = options.Position end
    if options.Color then card.BackgroundColor3 = options.Color end
    local button = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Font = options.Bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize = options.TextSize or 12,
        TextColor3 = options.TextColor or Theme.textPri,
        Text = options.Text or "",
        ZIndex = 3,
    }, card)
    local buttonScale = create("UIScale", {}, button)
    local underline = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -1),
        Size = UDim2.new(0, 0, 0, 2),
        BackgroundColor3 = Theme.accentCyan,
        BorderSizePixel = 0,
        ZIndex = 4,
    }, card)
    corner(underline, UDim.new(1, 0))
    surface(underline, 0)
    local outline = card:FindFirstChildOfClass("UIStroke")
    local playShine = shine(self, button, card)
    ripple(self, button, 7)
    local restColor = options.Color or Theme.bg2
    connect(self, button.MouseEnter, function()
        TweenService:Create(card, Theme.tweenFast, { BackgroundColor3 = Theme.hover }):Play()
        TweenService:Create(button, Theme.tweenFast, { TextColor3 = Theme.accentCyan }):Play()
        TweenService:Create(buttonScale, Theme.tweenFast, { Scale = 1.02 }):Play()
        TweenService:Create(underline, Theme.tweenSpring, { Size = UDim2.new(0.52, 0, 0, 2) }):Play()
        if outline then TweenService:Create(outline, Theme.tweenFast, { Transparency = 0.06 }):Play() end
    end)
    connect(self, button.MouseLeave, function()
        TweenService:Create(card, Theme.tweenFast, { BackgroundColor3 = restColor }):Play()
        TweenService:Create(button, Theme.tweenFast, { TextColor3 = options.TextColor or Theme.textPri }):Play()
        TweenService:Create(buttonScale, Theme.tweenFast, { Scale = 1 }):Play()
        TweenService:Create(underline, Theme.tweenFast, { Size = UDim2.new(0, 0, 0, 2) }):Play()
        if outline then TweenService:Create(outline, Theme.tweenFast, { Transparency = 0.38 }):Play() end
    end)
    connect(self, button.MouseButton1Down, function()
        TweenService:Create(buttonScale, Theme.tweenSnap, { Scale = 0.96 }):Play()
    end)
    connect(self, button.MouseButton1Up, function()
        TweenService:Create(buttonScale, Theme.tweenSpring, { Scale = 1.02 }):Play()
        playShine()
    end)
    if options.Callback then
        connect(self, button.Activated, function() emit(self, options.Callback) end)
    end
    return { Frame = card, Button = button }
end

local function setToggle(control, enabled, instant)
    control.Value = enabled == true
    control.Gradient.Color = control.Value
        and ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.accentCyan),
            ColorSequenceKeypoint.new(1, Theme.accentSec),
        })
        or ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(82, 72, 135)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(38, 28, 82)),
        })
    local goalTrack = { BackgroundColor3 = control.Value and Theme.toggleOn or Theme.toggleOff }
    local goalKnob = {
        Position = control.Value
            and UDim2.new(0, Theme.toggleW - Theme.knobSz - 2, 0.5, -Theme.knobSz / 2)
            or UDim2.new(0, 2, 0.5, -Theme.knobSz / 2),
    }
    if instant then
        control.Track.BackgroundColor3 = goalTrack.BackgroundColor3
        control.Knob.Position = goalKnob.Position
        control.KnobScale.Scale = 1
        control.Outline.Color = control.Value and Theme.accentCyan or Theme.accentDim
        control.Outline.Transparency = control.Value and 0.12 or 0.38
    else
        TweenService:Create(control.Track, Theme.tweenFast, goalTrack):Play()
        TweenService:Create(control.Knob, Theme.tweenSpring, goalKnob):Play()
        TweenService:Create(control.Outline, Theme.tweenMed, {
            Color = control.Value and Theme.accentCyan or Theme.accentDim,
            Transparency = control.Value and 0.12 or 0.38,
        }):Play()
        control.KnobScale.Scale = control.Value and 1.16 or 0.88
        TweenService:Create(control.KnobScale, Theme.tweenSpring, { Scale = 1 }):Play()
    end
end

local function makeToggle(self, parent, options)
    local card = makeCard(parent, 34, options.Order)
    local outline = card:FindFirstChildOfClass("UIStroke")
    makeText(card, options.Text, { Size = UDim2.new(1, -72, 1, 0) })
    local track = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, Theme.toggleW, 0, Theme.toggleH),
        BackgroundColor3 = Theme.toggleOff,
        BorderSizePixel = 0,
    }, card)
    corner(track, UDim.new(1, 0))
    local gradient = create("UIGradient", { Rotation = 15 }, track)
    local knob = create("Frame", {
        Size = UDim2.new(0, Theme.knobSz, 0, Theme.knobSz),
        BackgroundColor3 = Theme.knob,
        BorderSizePixel = 0,
    }, track)
    corner(knob, UDim.new(1, 0))
    gloss(knob, 0.2)
    local knobScale = create("UIScale", {}, knob)
    local button = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Text = "",
        ZIndex = 3,
    }, card)
    ripple(self, button, 7)
    local control = {
        Frame = card,
        Track = track,
        Knob = knob,
        Gradient = gradient,
        KnobScale = knobScale,
        Outline = outline,
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

local function makeInput(self, parent, options)
    local stacked = options.Stacked == true
    local inputWidth = options.InputWidth or 40
    local card = makeCard(parent, options.Height or (stacked and 62 or 34), options.Order)
    makeText(card, options.Text, {
        Size = stacked and UDim2.new(1, -24, 0, 26) or UDim2.new(1, -inputWidth - 32, 1, 0),
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    local field = create("Frame", {
        AnchorPoint = stacked and Vector2.new() or Vector2.new(1, 0.5),
        Position = stacked and UDim2.new(0, 10, 0, 28) or UDim2.new(1, -10, 0.5, 0),
        Size = stacked and UDim2.new(1, -20, 0, 26) or UDim2.new(0, inputWidth, 0, Theme.toggleH),
        BackgroundColor3 = Theme.inputBg,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, card)
    corner(field, UDim.new(0, 5))
    local outline = stroke(field, Theme.accentDim, 1, 0)
    local box = create("TextBox", {
        Position = UDim2.new(0, 6, 0, 0),
        Size = UDim2.new(1, -12, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        MultiLine = false,
        TextWrapped = false,
        Font = Enum.Font.GothamBold,
        TextSize = options.TextSize or 11,
        TextColor3 = Theme.textPri,
        PlaceholderText = options.Placeholder or "",
        PlaceholderColor3 = Theme.textMuted,
        TextXAlignment = options.Align or Enum.TextXAlignment.Center,
        Text = tostring(options.Value or ""),
    }, field)
    clipInput(self, box)
    connect(self, box.Focused, function()
        TweenService:Create(outline, Theme.tweenFast, { Color = Theme.accent }):Play()
    end)
    connect(self, box.FocusLost, function()
        TweenService:Create(outline, Theme.tweenFast, { Color = Theme.accentDim }):Play()
        local replacement = emit(self, options.Callback, box.Text)
        if replacement ~= nil then box.Text = tostring(replacement) end
    end)
    hover(self, card, box)
    return { Frame = card, TextBox = box }
end

local function makeDropdown(self, parent, options)
    local card = makeCard(parent, 62, options.Order)
    card.ZIndex = 20
    makeText(card, options.Text, {
        Size = UDim2.new(1, -24, 0, 26),
        Position = UDim2.new(0, 12, 0, 0),
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 21,
    })
    local head = create("TextButton", {
        Position = UDim2.new(0, 10, 0, 28),
        Size = UDim2.new(1, -20, 0, 26),
        BackgroundColor3 = Theme.inputBg,
        AutoButtonColor = false,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = options.TextColor or Theme.accentSec,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 23,
    }, card)
    corner(head, UDim.new(0, 5))
    stroke(head, Theme.accentDim, 1)
    local menu = create("Frame", {
        Position = UDim2.new(0, 10, 0, 62),
        Size = UDim2.new(1, -20, 0, #options.Items * 30 - 4),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 40,
    }, card)
    local control = { Frame = card, Button = head, Menu = menu, Value = options.Value, Open = false }
    local function display(value)
        for _, item in ipairs(options.Items) do
            if item.Value == value then return item.Text end
        end
        return tostring(value or "")
    end
    function control:SetOpen(open)
        self.Open = open == true
        if self.Open then
            for _, other in ipairs(self.Owner.Dropdowns) do
                if other ~= self and other.Open then other:SetOpen(false) end
            end
        end
        self.Menu.Visible = self.Open
        self.Frame.Size = UDim2.new(1, 0, 0, self.Open and 66 + #options.Items * 30 or 62)
        self.Button.Text = display(self.Value) .. (self.Open and "  ^" or "  v")
    end
    function control:Set(value)
        self.Value = value
        self:SetOpen(false)
    end
    for index, item in ipairs(options.Items) do
        local option = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 26),
            Position = UDim2.new(0, 0, 0, (index - 1) * 30),
            BackgroundColor3 = Theme.inputBg,
            BorderSizePixel = 0,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextColor3 = Theme.textPri,
            Text = item.Text,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 41,
        }, menu)
        corner(option, UDim.new(0, 5))
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
    local card = makeCard(parent, height or 58, order)
    makeText(card, title, {
        Size = UDim2.new(1, -24, 0, 20),
        Position = UDim2.new(0, 12, 0, 6),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Theme.accentSec,
    })
    makeText(card, body, {
        Size = UDim2.new(1, -24, 1, -30),
        Position = UDim2.new(0, 12, 0, 27),
        TextSize = 9,
        TextColor3 = Theme.textMuted,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top,
    })
    return card
end

local TabData = {
    { "HOME", "CODE REDEEMER", 327 },
    { "RULES", "TRIGGER MATRIX", 240 },
    { "AI", "AI ENGINE", 357 },
    { "LOG", "ACTIVITY LOG", 240 },
    { "SENDER", "TEST SENDER", 240 },
    { "AA", "ADMIN ABUSE", 240 },
}

local function makePage(parent, scrolling)
    local page = create(scrolling and "ScrollingFrame" or "Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        ScrollBarThickness = scrolling and 2 or nil,
        ScrollBarImageColor3 = scrolling and Theme.accent or nil,
        AutomaticCanvasSize = scrolling and Enum.AutomaticSize.Y or nil,
        CanvasSize = scrolling and UDim2.new() or nil,
    }, parent)
    if scrolling then page.ScrollingDirection = Enum.ScrollingDirection.Y end
    create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top,
    }, page)
    create("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
    }, page)
    return page
end

local function buildWindow(self)
    local view = self.View
    local old = gethui():FindFirstChild("zelqynhubAutoCode")
    if old then old:Destroy() end

    view.Gui = create("ScreenGui", {
        Name = "zelqynhubAutoCode",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, gethui())
    view.Window = create("Frame", {
        Size = UDim2.new(0, 310, 0, 327),
        Position = self.Options.Position or UDim2.new(0.5, -120, 0.5, -120),
        BackgroundColor3 = Theme.bg1,
        BackgroundTransparency = 0.02,
        BorderSizePixel = 0,
        Active = true,
        ClipsDescendants = true,
    }, view.Gui)
    corner(view.Window, UDim.new(0, 12))
    stroke(view.Window, Theme.accentDim, 1)
    create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 7, 54)),
            ColorSequenceKeypoint.new(0.48, Theme.bg1),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 2, 31)),
        }),
        Rotation = 125,
    }, view.Window)

    local glowStroke = create("UIStroke", {
        Color = Theme.accentSec,
        Thickness = 2,
        Transparency = 0.08,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        LineJoinMode = Enum.LineJoinMode.Round,
    }, view.Window)
    view.Glow = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.accentCyan),
            ColorSequenceKeypoint.new(0.35, Theme.accentBlue),
            ColorSequenceKeypoint.new(0.5, Theme.activeTabText),
            ColorSequenceKeypoint.new(0.66, Theme.accentSec),
            ColorSequenceKeypoint.new(1, Theme.accent),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.92),
            NumberSequenceKeypoint.new(0.39, 0.88),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(0.61, 0.88),
            NumberSequenceKeypoint.new(1, 0.92),
        }),
    }, glowStroke)
    local auraStroke = create("UIStroke", {
        Color = Theme.accent,
        Thickness = 5,
        Transparency = 0.58,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        LineJoinMode = Enum.LineJoinMode.Round,
    }, view.Window)
    view.Aura = view.Glow:Clone()
    view.Aura.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.4, 0.96),
        NumberSequenceKeypoint.new(0.5, 0.46),
        NumberSequenceKeypoint.new(0.6, 0.96),
        NumberSequenceKeypoint.new(1, 1),
    })
    view.Aura.Parent = auraStroke

    view.Header = create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Theme.bg0,
        BorderSizePixel = 0,
        Active = true,
        Selectable = true,
    }, view.Window)
    create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 16, 76)),
            ColorSequenceKeypoint.new(0.52, Color3.fromRGB(12, 5, 47)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 2, 42)),
        }),
        Rotation = 12,
    }, view.Header)
    local mark = create("TextLabel", {
        Size = UDim2.new(0, 30, 0, 28),
        Position = UDim2.new(0, 8, 0.5, -14),
        BackgroundColor3 = Color3.fromRGB(10, 5, 43),
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBlack,
        TextSize = 20,
        TextColor3 = Theme.activeTabText,
        Text = "Z",
    }, view.Header)
    corner(mark, UDim.new(0, 8))
    stroke(mark, Theme.accentSec, 1)
    surface(mark, 25)
    local title = makeText(view.Header, string.upper(UiLib.Name), {
        Size = UDim2.new(0, 150, 0, 17),
        Position = UDim2.new(0, 42, 0, 5),
        Font = Enum.Font.GothamBlack,
        TextSize = 13,
    })
    surface(title, 0)
    view.Mode = makeText(view.Header, "CODE REDEEMER", {
        Size = UDim2.new(0, 150, 0, 13),
        Position = UDim2.new(0, 42, 0, 22),
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        TextColor3 = Theme.textMuted,
    })
    local ready = makeText(view.Header, "READY", {
        Size = UDim2.new(0, 38, 0, 17),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -43, 0.5, 0),
        BackgroundTransparency = 0,
        BackgroundColor3 = Theme.bg2,
        Font = Enum.Font.GothamBold,
        TextSize = 8,
        TextColor3 = Theme.accentCyan,
        TextXAlignment = Enum.TextXAlignment.Center,
    })
    corner(ready, UDim.new(0, 7))
    surface(ready, 12)
    view.AccentLine = create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = Theme.accent,
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
    }, view.Header)
    view.AccentGradient = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.accentCyan),
            ColorSequenceKeypoint.new(0.35, Theme.accentBlue),
            ColorSequenceKeypoint.new(0.5, Theme.activeTabText),
            ColorSequenceKeypoint.new(0.65, Theme.accentSec),
            ColorSequenceKeypoint.new(1, Theme.accent),
        }),
        Offset = Vector2.new(-0.82, 0),
    }, view.AccentLine)
    view.Minimize = create("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -9, 0.5, 0),
        BackgroundColor3 = Theme.bg2,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Theme.textPri,
        Text = "-",
    }, view.Header)
    corner(view.Minimize, UDim.new(0, 7))
    stroke(view.Minimize, Theme.accentDim, 1)
    surface(view.Minimize, 15)

    view.Nav = create("Frame", {
        Position = UDim2.new(0, 0, 0, 42),
        Size = UDim2.new(0, 64, 1, -42),
        BackgroundColor3 = Theme.bg0,
        BackgroundTransparency = 0.18,
        BorderSizePixel = 0,
    }, view.Window)
    surface(view.Nav, 90)
    create("UIPadding", {
        PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
        PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
    }, view.Nav)
    create("UIListLayout", {
        Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    }, view.Nav)
    view.Divider = create("Frame", {
        Size = UDim2.new(0, 1, 1, -42),
        Position = UDim2.new(0, 64, 0, 42),
        BackgroundColor3 = Theme.accentDim,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
    }, view.Window)
    view.Content = create("Frame", {
        Position = UDim2.new(0, 65, 0, 42),
        Size = UDim2.new(1, -65, 1, -42),
        BackgroundTransparency = 1,
    }, view.Window)
    for index, tab in ipairs(TabData) do
        local button = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 28),
            LayoutOrder = index,
            BackgroundColor3 = Theme.bg0,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextColor3 = Theme.textMuted,
            Text = tab[1],
        }, view.Nav)
        corner(button)
        surface(button, 12)
        local indicator = create("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0, 2, 0, 18),
            BackgroundColor3 = Theme.accentSec,
            BorderSizePixel = 0,
            Visible = false,
        }, button)
        corner(indicator, UDim.new(1, 0))
        view.TabButtons[index] = button
        view.Indicators[index] = indicator
        view.Pages[index] = makePage(view.Content, index == 1 or index == 3)
        connect(self, button.Activated, function() self:SetTab(index) end)
        connect(self, button.MouseEnter, function()
            if self.ActiveTab ~= index then TweenService:Create(button, Theme.tweenFast, { BackgroundColor3 = Theme.hover }):Play() end
        end)
        connect(self, button.MouseLeave, function()
            if self.ActiveTab ~= index then TweenService:Create(button, Theme.tweenFast, { BackgroundColor3 = Theme.bg0 }):Play() end
        end)
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

function Controller:SetTab(index, instant)
    index = math.clamp(math.floor(tonumber(index) or 1), 1, #TabData)
    self.ActiveTab = index
    for _, dropdown in ipairs(self.Dropdowns) do dropdown:SetOpen(false) end
    for current = 1, #TabData do
        local active = current == index
        self.View.Pages[current].Visible = active
        self.View.TabButtons[current].BackgroundColor3 = active and Theme.bg2 or Theme.bg0
        self.View.TabButtons[current].TextColor3 = active and Theme.activeTabText or Theme.textMuted
        self.View.Indicators[current].Visible = active
    end
    self.View.Mode.Text = TabData[index][2]
    if not self.Minimized then
        local size = UDim2.new(0, 310, 0, TabData[index][3])
        if instant then self.View.Window.Size = size else TweenService:Create(self.View.Window, Theme.tweenMed, { Size = size }):Play() end
    end
    if not instant then emit(self, "TabChanged", index) end
end

function Controller:SetMinimized(value, instant)
    self.Minimized = value == true
    self.View.Nav.Visible = not self.Minimized
    self.View.Divider.Visible = not self.Minimized
    self.View.Content.Visible = not self.Minimized
    self.View.Minimize.Text = self.Minimized and "+" or "-"
    local height = self.Minimized and 42 or TabData[self.ActiveTab][3]
    local size = UDim2.new(0, 310, 0, height)
    if instant then self.View.Window.Size = size else TweenService:Create(self.View.Window, Theme.tweenMed, { Size = size }):Play() end
    if not instant then emit(self, "MinimizedChanged", self.Minimized) end
end

local function wireWindow(self)
    local dragging, dragStart, startPosition = false, nil, nil
    connect(self, self.View.Minimize.Activated, function() self:SetMinimized(not self.Minimized) end)
    hover(self, self.View.Minimize, self.View.Minimize)
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
            if self.View.Window.Parent then self.View.Window.Position = self:Clamp(self.View.Window.Position) end
        end)
    end
    connect(self, RunService.RenderStepped, function()
        local now = os.clock()
        local rotation = (now * 85.7142857) % 360
        self.View.Glow.Rotation = rotation
        self.View.Aura.Rotation = rotation
        local phase = (now / 3.2) % 1
        self.View.AccentGradient.Offset = Vector2.new(-0.82 + 1.64 * phase, 0)
        local edge = math.min(phase, 1 - phase) * 2
        self.View.AccentLine.BackgroundTransparency = 0.08 + 0.92 * (1 - math.clamp(edge / 0.13, 0, 1))
    end)
end

local function buildHome(self)
    local page = self.View.Pages[1]
    local actions = create("Frame", {
        Size = UDim2.new(1, 0, 0, 74),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
    }, page)
    makeButton(self, actions, {
        Text = "Start Scan", Callback = "StartScan", TextColor = Theme.accentCyan,
        Size = UDim2.new(0.5, -3, 0, 34), Position = UDim2.new(0, 0, 0, 0),
    })
    makeButton(self, actions, {
        Text = "Force AI", Callback = "ForceAI", TextColor = Theme.accentSec,
        Size = UDim2.new(0.5, -3, 0, 34), Position = UDim2.new(0.5, 3, 0, 0),
    })
    makeButton(self, actions, {
        Text = "Cancel All", Callback = "CancelAll", TextColor = Theme.accentSec,
        Size = UDim2.new(0.5, -3, 0, 34), Position = UDim2.new(0, 0, 0, 40),
    })
    makeButton(self, actions, {
        Text = "Claim Last AI", Callback = "ClaimLastAI", TextColor = Theme.accentSec, Bold = true,
        Size = UDim2.new(0.5, -3, 0, 34), Position = UDim2.new(0.5, 3, 0, 40),
    })

    local messageCard = makeCard(page, 46, 2)
    makeText(messageCard, "LAST DETECTED", {
        Size = UDim2.new(1, -80, 0, 14),
        Position = UDim2.new(0, 16, 0, 5),
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = Theme.accentSec,
    })
    create("Frame", {
        Size = UDim2.new(0, 3, 1, -12), Position = UDim2.new(0, 7, 0, 6),
        BackgroundColor3 = Theme.accent, BorderSizePixel = 0,
    }, messageCard)
    self.View.LastMessage = makeText(messageCard, self.Options.LastMessage ~= "" and self.Options.LastMessage or "Waiting for a notification...", {
        Size = UDim2.new(1, -28, 0, 18),
        Position = UDim2.new(0, 16, 0, 21),
        TextSize = 10,
        TextColor3 = Theme.textMuted,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    self.View.KeyButton = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -8, 0, 5),
        Size = UDim2.new(0, 48, 0, 16),
        BackgroundColor3 = Theme.bg2,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = Theme.accentSec,
        Text = self.KeyCode.Name,
    }, messageCard)
    corner(self.View.KeyButton, UDim.new(0, 6))
    stroke(self.View.KeyButton, Theme.accentDim, 1)
    connect(self, self.View.KeyButton.Activated, function()
        self.WaitingForKey = not self.WaitingForKey
        self.View.KeyButton.Text = self.WaitingForKey and "PRESS" or self.KeyCode.Name
    end)
    connect(self, UserInputService.InputBegan, function(input, processed)
        if self.WaitingForKey then
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            self.WaitingForKey = false
            if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.Unknown then
                self.KeyCode = input.KeyCode
                emit(self, "ClaimKeyChanged", input.KeyCode)
            end
            self.View.KeyButton.Text = self.KeyCode.Name
            return
        end
        if processed or UserInputService:GetFocusedTextBox() then return end
        if input.KeyCode == self.KeyCode then emit(self, "ClaimLastAI") end
    end)

    self.Controls.AutoCode = makeToggle(self, page, {
        Text = "Auto Enter Code", Value = self.State.AutoCode, Order = 3, Callback = "AutoCodeChanged",
    })
    self.Controls.RedeemMethod = makeDropdown(self, page, {
        Text = "Redeem Method", Value = self.State.RedeemMethod, Order = 4,
        TextColor = Theme.accentCyan, Callback = "RedeemMethodChanged",
        Items = {
            { Text = "FireSignal", Value = "FireSignal" },
            { Text = "Remote", Value = "Remote" },
        },
    })
    self.Controls.CaptureCount = makeInput(self, page, {
        Text = "Submit Code After", Value = self.State.CaptureCount > 0 and self.State.CaptureCount or "",
        Placeholder = "0", Order = 5, Callback = "CaptureCountChanged",
    })
    self.Controls.AutoDetect = makeToggle(self, page, {
        Text = "Auto Detect (Beta)", Value = self.State.AutoDetect, Order = 6, Callback = "AutoDetectChanged",
    })
    makeButton(self, page, { Text = "Copy Discord", Callback = "CopyDiscord", Order = 7 })
end

local function buildRules(self)
    local page = self.View.Pages[2]
    local card = makeCard(page, 147, 1)
    makeText(card, "Triggers  (blank = all)", { Size = UDim2.new(1, -24, 0, 34) })
    create("Frame", {
        Size = UDim2.new(1, -16, 0, 1), Position = UDim2.new(0, 8, 0, 34),
        BackgroundColor3 = Theme.accentDim, BorderSizePixel = 0,
    }, card)
    local scroll = create("ScrollingFrame", {
        Size = UDim2.new(1, -8, 0, 100), Position = UDim2.new(0, 4, 0, 39),
        BackgroundColor3 = Theme.bg3, BackgroundTransparency = 0.2,
        BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.accentSec,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ClipsDescendants = true,
    }, card)
    corner(scroll, UDim.new(0, 5))
    create("UIListLayout", {
        Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    }, scroll)
    create("UIPadding", {
        PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5),
    }, scroll)
    for index = 1, 10 do
        local slot = create("Frame", {
            Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = Theme.inputBg,
            BackgroundTransparency = 0.2, BorderSizePixel = 0, LayoutOrder = index,
            ClipsDescendants = true,
        }, scroll)
        corner(slot, UDim.new(0, 4))
        local outline = stroke(slot, Theme.accentDim, 1, 0)
        makeText(slot, tostring(index), {
            Size = UDim2.new(0, 14, 1, 0), Position = UDim2.new(0, 4, 0, 0),
            Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = Theme.textMuted,
            TextXAlignment = Enum.TextXAlignment.Center,
        })
        local box = create("TextBox", {
            Size = UDim2.new(1, -22, 1, -4), Position = UDim2.new(0, 20, 0, 2),
            BackgroundTransparency = 1, BorderSizePixel = 0, ClearTextOnFocus = false,
            Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.textPri,
            PlaceholderText = "keyword " .. index, PlaceholderColor3 = Theme.textMuted,
            TextXAlignment = Enum.TextXAlignment.Left, Text = (self.Options.Keywords or {})[index] or "",
        }, slot)
        clipInput(self, box)
        connect(self, box.Focused, function()
            TweenService:Create(outline, Theme.tweenFast, { Color = Theme.accent }):Play()
        end)
        connect(self, box.FocusLost, function()
            TweenService:Create(outline, Theme.tweenFast, { Color = Theme.accentDim }):Play()
            emit(self, "KeywordChanged", index, box.Text)
        end)
        connect(self, box:GetPropertyChangedSignal("Text"), function()
            emit(self, "KeywordEdited", index, box.Text)
        end)
    end
end

local function buildAI(self)
    local page = self.View.Pages[3]
    self.Controls.AIAnswers = makeToggle(self, page, {
        Text = "Use AI Answers", Value = self.State.AIAnswers, Order = 1, Callback = "AIAnswersChanged",
    })
    self.Controls.AIModel = makeDropdown(self, page, {
        Text = "AI Model", Value = self.State.AIModel, Order = 2, Callback = "AIModelChanged",
        Items = {
            { Text = "3.5 Flash Lite", Value = "google/gemini-3.5-flash-lite" },
            { Text = "3.7 Flash", Value = "google/gemini-3.7-flash" },
        },
    })
    self.Controls.AITriggers = makeInput(self, page, {
        Text = "AI Triggers", Value = table.concat(self.State.AITriggers, ", "),
        Placeholder = "Question, riddle", Stacked = true, Align = Enum.TextXAlignment.Left,
        Order = 3, Callback = "AITriggersChanged",
    })
    self.Controls.MinCharacters = makeInput(self, page, {
        Text = "Min Characters", Value = self.State.MinCharacters, Order = 4,
        Callback = "MinCharactersChanged",
    })
    self.Controls.MinSpaces = makeInput(self, page, {
        Text = "Min Spaces", Value = self.State.MinSpaces, Order = 5,
        Callback = "MinSpacesChanged",
    })
    makeParagraph(
        page,
        "AI RESPONSE ENGINE",
        "Uses live SAB, Snap and brainrot context for code-ready answers.",
        64,
        6
    )
end

local function buildLog(self)
    local page = self.View.Pages[4]
    for _, child in ipairs(page:GetChildren()) do child:Destroy() end
    self.View.LogScroll = create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -54), Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Theme.bg3, BackgroundTransparency = 0.2,
        BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.accentCyan,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ClipsDescendants = true,
    }, page)
    corner(self.View.LogScroll, UDim.new(0, 5))
    stroke(self.View.LogScroll, Theme.accentDim, 1)
    create("UIListLayout", {
        Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
    }, self.View.LogScroll)
    create("UIPadding", {
        PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4),
        PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4),
    }, self.View.LogScroll)
    local clear = create("TextButton", {
        Size = UDim2.new(1, -20, 0, 28), Position = UDim2.new(0, 10, 1, -38),
        BackgroundColor3 = Theme.bg2, BorderSizePixel = 0,
        Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.textMuted,
        Text = "Clear Log",
    }, page)
    corner(clear, UDim.new(0, 6))
    stroke(clear, Theme.accentDim, 1)
    surface(clear, 8)
    connect(self, clear.Activated, function()
        self:ClearLog()
        emit(self, "ClearLog")
    end)
    hover(self, clear, clear)
end

local function buildSender(self)
    local page = self.View.Pages[5]
    local inputCard = makeCard(page, 94, 1)
    inputCard.ClipsDescendants = true
    makeText(inputCard, "Notification Message", {
        Size = UDim2.new(1, -20, 0, 24), Position = UDim2.new(0, 10, 0, 3),
        Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.accentSec,
    })
    self.View.SenderBox = create("TextBox", {
        Size = UDim2.new(1, -16, 0, 56), Position = UDim2.new(0, 8, 0, 29),
        BackgroundColor3 = Theme.inputBg, BorderSizePixel = 0, ClearTextOnFocus = false,
        MultiLine = true, Font = Enum.Font.Gotham, TextSize = 11,
        PlaceholderText = "Type a notification message...", PlaceholderColor3 = Theme.textMuted,
        Text = "", TextColor3 = Theme.textPri, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
    }, inputCard)
    clipInput(self, self.View.SenderBox)
    corner(self.View.SenderBox, UDim.new(0, 5))
    stroke(self.View.SenderBox, Theme.accentDim, 1, 0)
    local send = makeButton(self, page, {
        Text = "SEND NOTIFICATION", Bold = true, Order = 2,
    })
    connect(self, send.Button.Activated, function()
        local message = self.View.SenderBox.Text:match("^%s*(.-)%s*$")
        local ok, status = emit(self, "SendNotification", message)
        self:SetSenderStatus(status, ok)
    end)
    self.View.SenderStatus = makeText(makeCard(page, 34, 3), self.State.NotificationReady and "Remote ready" or "Remote unavailable", {
        Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
        TextSize = 10, TextColor3 = self.State.NotificationReady and Theme.accentSec or Theme.textMuted,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
end

local function buildAA(self)
    local page = self.View.Pages[6]
    self.Controls.Anchor = makeToggle(self, page, {
        Text = "Anchor", Value = self.State.Anchor, Order = 1, Callback = "AnchorChanged",
    })
    self.Controls.AutoPurchase = makeToggle(self, page, {
        Text = "Auto Purchase", Value = self.State.AutoPurchase, Order = 2, Callback = "AutoPurchaseChanged",
    })
    makeParagraph(page, "Admin Abuse", "Purchases the nearest brainrot at 10 studs or less.", 58, 3)
    self.View.AAStatus = makeText(makeCard(page, 34, 4), "Ready", {
        Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
        TextSize = 10, TextColor3 = Theme.textMuted, TextTruncate = Enum.TextTruncate.AtEnd,
    })
end

function Controller:SetLastMessage(text)
    if self.View.LastMessage then self.View.LastMessage.Text = tostring(text or "") end
end

function Controller:SetAAStates(anchorEnabled, purchaseEnabled)
    if self.Controls.Anchor then self.Controls.Anchor:Set(anchorEnabled, false) end
    if self.Controls.AutoPurchase then self.Controls.AutoPurchase:Set(purchaseEnabled, false) end
end

function Controller:SetAAStatus(text, color)
    if not self.View.AAStatus then return end
    self.View.AAStatus.Text = tostring(text or "Ready")
    self.View.AAStatus.TextColor3 = color or Theme.textMuted
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
    local timestamp, message = raw:match("^(%[[^%]]+%])%s*(.*)$")
    timestamp = timestamp or "[--:--:--]"
    message = message or raw
    local formatted = string.format(
        '<font color="#%s">%s</font> <font color="#%s">%s</font>',
        colorHex(Theme.textMuted),
        escapeRichText(timestamp),
        colorHex(logColor(message)),
        escapeRichText(message)
    )
    local label = makeText(self.View.LogScroll, formatted, {
        Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.new(), Font = Enum.Font.Code, TextSize = 10,
        TextColor3 = Theme.textPri, TextWrapped = true, RichText = true,
    })
    label.TextTransparency = 1
    TweenService:Create(label, Theme.tweenFast, { TextTransparency = 0 }):Play()
    table.insert(self.LogLabels, label)
    if #self.LogLabels > self.MaxLogEntries then
        local oldest = table.remove(self.LogLabels, 1)
        if oldest and oldest.Parent then oldest:Destroy() end
    end
    task.defer(function()
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
end

function Controller:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
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
        MaxLogEntries = (options and options.MaxLogEntries) or (UiLib.IsTouch and 80 or 140),
        View = { Pages = {}, TabButtons = {}, Indicators = {} },
        ActiveTab = 1,
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
    wireWindow(self)
    self:SetTab(self.Options.ActiveTab or 1, true)
    self:SetMinimized(self.Options.Minimized, true)
    self.View.Window.Position = self:Clamp(self.View.Window.Position)
    for _, entry in ipairs(self.Options.Logs or {}) do self:Log(entry) end
    return self
end

function UiLib.destroy()
    if UiLib.Active then UiLib.Active:Destroy() end
end

return UiLib
