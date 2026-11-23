--========================================================
-- UI | ALBAÑIL V0.5
-- Windows 11 inspired | Android + PC
-- No external UI libraries
--========================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local function GetParent()
    local ok, result = pcall(function() return gethui() end)
    if ok and result then return result end
    return CoreGui
end
local Parent = GetParent()

pcall(function()
    local old = Parent:FindFirstChild("ALBANIL_UI_V05")
    if old then old:Destroy() end
end)

local Config = {
    Theme="Midnight", Title="UI", Subtitle="ALBAÑIL V0.5",
    WalkSpeed=100, JumpPower=50, FOV=120, FOVThickness=4,
    FOVEnabled=false, FOVColor={255,255,255}, FOVTransparency=1,
    FOVFilled=false, FOVFollowMouse=false,
    PlayerCircleEnabled=false,
    LineLockEnabled=false, DiamondEnabled=true, TargetLineEnabled=true,
    TargetPart="Cabeza"
}
local Themes = {
    Midnight={13,16,24,22,27,39,105,145,255},
    Dark={16,18,22,27,30,36,125,155,210},
    Graphite={25,28,34,36,41,49,130,165,225},
    Windows={18,27,42,27,39,59,0,120,215},
    Ocean={9,24,36,17,42,59,35,185,220},
    Purple={22,17,35,34,27,52,165,115,255},
    Crimson={29,15,20,45,25,33,255,80,100},
    Emerald={13,27,23,22,44,36,65,205,145},
    Rose={32,20,27,49,31,42,255,125,175},
    Amber={31,25,15,49,39,23,255,185,65},
    Arctic={20,29,39,31,44,58,105,195,255},
    Sakura={35,23,33,52,35,48,255,150,200},
    Neon={11,18,26,20,30,43,0,245,190},
    Slate={25,31,41,38,47,61,125,170,230},
    Carbon={11,12,15,24,25,30,190,195,210},
    Lavender={29,24,43,45,37,63,190,155,255},
    Cherry={35,14,24,54,22,37,255,70,130}
}
local function Palette()
    local t=Themes[Config.Theme] or Themes.Midnight
    return {
        BG=Color3.fromRGB(t[1],t[2],t[3]),
        PANEL=Color3.fromRGB(t[4],t[5],t[6]),
        ACCENT=Color3.fromRGB(t[7],t[8],t[9]),
        TEXT=Color3.fromRGB(240,242,248),
        MUTED=Color3.fromRGB(135,141,155),
        BORDER=Color3.fromRGB(55,59,70),
        OFF=Color3.fromRGB(55,59,70),
        ROW=Color3.fromRGB(math.min(t[1]+7,255),math.min(t[2]+7,255),math.min(t[3]+9,255))
    }
end
local C=Palette()

local function SaveConfig()
    if not (writefile and isfile) then return end
    pcall(function() writefile("AlbanilUI_Config.json",HttpService:JSONEncode(Config)) end)
end
if isfile and readfile then
    pcall(function()
        if isfile("AlbanilUI_Config.json") then
            local data=HttpService:JSONDecode(readfile("AlbanilUI_Config.json"))
            for k,v in pairs(data) do if Config[k]~=nil then Config[k]=v end end
        end
    end)
end
-- Migrate configs from the older raw WalkSpeed setting to percentage scaling.
if type(Config.WalkSpeed)=="number" and Config.WalkSpeed>0 and Config.WalkSpeed<=30 then
    Config.WalkSpeed=100
end
C=Palette()

local function New(class,props,parent)
    local o=Instance.new(class)
    for k,v in pairs(props or {}) do o[k]=v end
    o.Parent=parent
    return o
end
local function Corner(o,r) New("UICorner",{CornerRadius=UDim.new(0,r)},o) end
local function Stroke(o,color,thickness)
    return New("UIStroke",{Color=color or C.BORDER,Thickness=thickness or 1},o)
end
local function Animate(o,props,d)
    local t=TweenService:Create(o,TweenInfo.new(d or .18,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),props)
    t:Play()
    return t
end
local function Label(parent,text,size,color,font)
    return New("TextLabel",{
        BackgroundTransparency=1,Text=text,TextSize=size or 12,
        TextColor3=color or C.TEXT,Font=font or Enum.Font.Gotham,
        TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center
    },parent)
end
local function Button(parent,text,size)
    return New("TextButton",{
        Text=text,TextSize=size or 13,Font=Enum.Font.GothamMedium,
        TextColor3=C.TEXT,BackgroundColor3=C.PANEL,AutoButtonColor=false,
        BorderSizePixel=0
    },parent)
end

local GUI=New("ScreenGui",{Name="ALBANIL_UI_V05",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},Parent)

--========================================================
-- KEY SYSTEM | Pantalla inicial de ALBAÑIL
-- Cambia la clave de demostración por las claves que generes.
-- La validación local es una barrera visual, NO una protección
-- segura contra extracción/decompilación del código cliente.
--========================================================
local VALID_KEYS = {
    ["ALBANIL-2026"] = true
}
local DISCORD_INVITE = "https://discord.gg/frTCyyucE"

local Gate = New("Frame",{
    Name="KeySystem",Size=UDim2.fromOffset(340,255),
    Position=UDim2.fromScale(.5,.5),AnchorPoint=Vector2.new(.5,.5),
    BackgroundColor3=C.BG,BorderSizePixel=0,ClipsDescendants=true
},GUI)
Corner(Gate,9); Stroke(Gate,C.BORDER,1)
local GateScale=New("UIScale",{Scale=1},Gate)
local function UpdateGateScale()
    local viewport=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
    if viewport then GateScale.Scale=math.min(1,viewport.X/370,viewport.Y/285) end
end
UpdateGateScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateGateScale)
end

local GateTop=New("Frame",{Size=UDim2.new(1,0,0,43),BackgroundColor3=C.PANEL,BorderSizePixel=0},Gate)
local GateTitle=Label(GateTop,"ALBAÑIL",14,C.TEXT,Enum.Font.GothamBold)
GateTitle.Position=UDim2.fromOffset(15,0); GateTitle.Size=UDim2.new(1,-30,1,0)
local GateSub=Label(Gate,"DISCORD",9,C.MUTED,Enum.Font.GothamMedium)
GateSub.Position=UDim2.fromOffset(18,55); GateSub.Size=UDim2.new(1,-36,0,17)
local KeyBox=New("TextBox",{
    Name="KeyInput",Position=UDim2.fromOffset(18,81),Size=UDim2.new(1,-36,0,39),
    BackgroundColor3=C.ROW,TextColor3=C.TEXT,PlaceholderColor3=C.MUTED,
    PlaceholderText="Introduce tu key",Text="",ClearTextOnFocus=false,
    Font=Enum.Font.Gotham,TextSize=11,BorderSizePixel=0
},Gate)
Corner(KeyBox,6); Stroke(KeyBox,C.BORDER,1)
local Verify=Button(Gate,"VERIFICAR",10)
Verify.Position=UDim2.fromOffset(18,132); Verify.Size=UDim2.new(1,-36,0,36)
Verify.BackgroundColor3=C.ACCENT; Verify.TextColor3=Color3.fromRGB(255,255,255)
Corner(Verify,6)
local CopyDiscord=Button(Gate,"COPIAR DISCORD",10)
CopyDiscord.Position=UDim2.fromOffset(18,178); CopyDiscord.Size=UDim2.new(1,-36,0,34)
CopyDiscord.BackgroundColor3=C.PANEL; Corner(CopyDiscord,6); Stroke(CopyDiscord,C.BORDER,1)
local GateStatus=Label(Gate,"Introduce tu key para continuar",9,C.MUTED)
GateStatus.Position=UDim2.fromOffset(18,220); GateStatus.Size=UDim2.new(1,-36,0,18)
GateStatus.TextXAlignment=Enum.TextXAlignment.Center

local Main=New("Frame",{
    Name="Window",Size=UDim2.fromOffset(520,360),Position=UDim2.fromScale(.5,.5),
    AnchorPoint=Vector2.new(.5,.5),BackgroundColor3=C.BG,BorderSizePixel=0,ClipsDescendants=true,Visible=false
},GUI)
Corner(Main,9); Stroke(Main,C.BORDER,1)

local function SetGateStatus(message,color)
    GateStatus.Text=message
    GateStatus.TextColor3=color or C.MUTED
end
Verify.MouseButton1Click:Connect(function()
    local entered=string.gsub(KeyBox.Text,"%s+","")
    if VALID_KEYS[entered] then
        SetGateStatus("Key correcta. Cargando ALBAÑIL...",Color3.fromRGB(90,220,140))
        Verify.Active=false
        task.delay(.25,function()
            if Gate and Gate.Parent then Gate:Destroy() end
            Main.Visible=true
        end)
    else
        SetGateStatus("Key incorrecta. Inténtalo de nuevo.",Color3.fromRGB(255,90,100))
        KeyBox.Text=""
    end
end)
KeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then Verify:Activate() end
end)
CopyDiscord.MouseButton1Click:Connect(function()
    local copied=false
    if setclipboard then
        copied=pcall(setclipboard,DISCORD_INVITE)
    elseif toclipboard then
        copied=pcall(toclipboard,DISCORD_INVITE)
    end
    if copied then
        SetGateStatus("Discord copiado al portapapeles",Color3.fromRGB(90,220,140))
    else
        SetGateStatus("No se pudo copiar; enlace: "..DISCORD_INVITE,C.TEXT)
    end
end)

local Scale=New("UIScale",{Scale=1},Main)
local function UpdateScale()
    local v=Camera.ViewportSize
    Scale.Scale=math.min(1,v.X/550,v.Y/390)
end
UpdateScale()
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)

-- Header and window controls
local Header=New("Frame",{Size=UDim2.new(1,0,0,43),BackgroundColor3=C.PANEL,BorderSizePixel=0},Main)
local Title=Label(Header,Config.Title,15,C.TEXT,Enum.Font.GothamBold)
Title.Position=UDim2.fromOffset(15,0); Title.Size=UDim2.new(0,145,1,0)
Title.TextTruncate=Enum.TextTruncate.AtEnd
local Subtitle=Label(Header,Config.Subtitle,10,C.MUTED,Enum.Font.GothamMedium)
Subtitle.Position=UDim2.fromOffset(165,1); Subtitle.Size=UDim2.new(1,-245,1,-2)
Subtitle.TextTruncate=Enum.TextTruncate.AtEnd
New("Frame",{Position=UDim2.new(0,0,1,-1),Size=UDim2.new(1,0,0,1),BackgroundColor3=C.BORDER,BorderSizePixel=0},Header)
local function HeaderButton(txt,x)
    local b=Button(Header,txt,17)
    b.Size=UDim2.fromOffset(28,27); b.Position=UDim2.new(1,x,0,8)
    b.BackgroundTransparency=1; b.TextColor3=C.MUTED
    b.Font=Enum.Font.GothamMedium
    b.MouseEnter:Connect(function() Animate(b,{TextColor3=C.TEXT},.1) end)
    b.MouseLeave:Connect(function() Animate(b,{TextColor3=C.MUTED},.1) end)
    return b
end
local Close=HeaderButton("×",-34)
local Minimize=HeaderButton("−",-66)

local Body=New("Frame",{Position=UDim2.fromOffset(0,44),Size=UDim2.new(1,0,1,-44),BackgroundTransparency=1},Main)
local Sidebar=New("Frame",{Size=UDim2.new(0,128,1,0),BackgroundColor3=C.PANEL,BorderSizePixel=0},Body)
New("Frame",{Position=UDim2.new(1,-1,0,0),Size=UDim2.new(0,1,1,0),BackgroundColor3=C.BORDER,BorderSizePixel=0},Sidebar)
local TabHolder=New("Frame",{Position=UDim2.fromOffset(0,12),Size=UDim2.new(1,0,1,-24),BackgroundTransparency=1},Sidebar)
New("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},TabHolder)
local Content=New("Frame",{Position=UDim2.fromOffset(129,0),Size=UDim2.new(1,-129,1,0),BackgroundColor3=C.BG,BorderSizePixel=0,ClipsDescendants=true},Body)

-- Simple native vector-style icons
local function Line(p,x,y,w,h,rot,color)
    local f=New("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(x,y),Size=UDim2.fromOffset(w,h),Rotation=rot or 0,BackgroundColor3=color or C.MUTED,BorderSizePixel=0},p)
    Corner(f,5); return f
end
local function Circle(p,x,y,s,color)
    local f=New("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(x,y),Size=UDim2.fromOffset(s,s),BackgroundTransparency=1,BorderSizePixel=0},p)
    Corner(f,50); Stroke(f,color or C.MUTED,1.5); return f
end
local function MakeIcon(parent,name,color)
    local h=New("Frame",{Size=UDim2.fromOffset(20,20),BackgroundTransparency=1},parent)
    local function L(x,y,w,ht,rot)
        return Line(h,x,y,w,ht,rot,color)
    end
    local function Cc(x,y,size)
        return Circle(h,x,y,size,color)
    end

    if name=="Inicio" then -- Lucide: house
        L(.5,.16,2,2,0)
        L(.28,.34,11,2,-42)
        L(.72,.34,11,2,42)
        L(.5,.36,13,2,0)
        L(.22,.64,2,8,0)
        L(.78,.64,2,8,0)
        L(.5,.78,2,6,0)
        L(.5,.93,13,2,0)
    elseif name=="Jugador" then -- Lucide: accessibility
        Cc(.5,.16,4)
        L(.5,.34,2,2,0)
        L(.5,.48,13,2,0)
        L(.5,.48,2,7,0)
        L(.36,.7,2,8,25)
        L(.64,.7,2,8,-25)
        L(.5,.68,2,8,0)
    elseif name=="Visual" then -- Lucide: eye
        Cc(.5,.5,7)
        Cc(.5,.5,3)
        L(.1,.5,2,2,0)
        L(.9,.5,2,2,0)
    elseif name=="Combate" then -- Lucide-style crossed swords
        L(.32,.32,12,2,45)
        L(.68,.32,12,2,-45)
        L(.22,.22,5,2,45)
        L(.78,.22,5,2,-45)
        L(.37,.66,7,2,-45)
        L(.63,.66,7,2,45)
    elseif name=="Car" then -- Lucide-style car front
        L(.5,.28,12,2,0)
        L(.5,.45,16,2,0)
        L(.25,.58,2,6,0)
        L(.75,.58,2,6,0)
        L(.5,.78,14,2,0)
        Cc(.28,.79,4)
        Cc(.72,.79,4)
    else -- Lucide: sliders-horizontal
        L(.5,.25,15,2,0)
        L(.5,.5,15,2,0)
        L(.5,.75,15,2,0)
        Cc(.34,.25,4)
        Cc(.68,.5,4)
        Cc(.42,.75,4)
    end
    return h
end

local Tabs,SelectedTab={},nil
local function SelectTab(name)
    SelectedTab=name
    for n,d in pairs(Tabs) do
        local active=n==name
        d.Page.Visible=active
        d.Button.BackgroundColor3=active and C.ROW or C.PANEL
        d.Text.TextColor3=active and C.TEXT or C.MUTED
        for _,o in ipairs(d.Icon:GetDescendants()) do
            if o:IsA("Frame") then o.BackgroundColor3=active and C.ACCENT or C.MUTED end
            if o:IsA("UIStroke") then o.Color=active and C.ACCENT or C.MUTED end
        end
    end
end
local function CreateTab(name,order)
    local b=Button(TabHolder,"",12)
    b.Size=UDim2.new(1,-16,0,32); b.Position=UDim2.fromOffset(8,0); b.LayoutOrder=order
    Corner(b,6)
    local icon=MakeIcon(b,name,C.MUTED); icon.Size=UDim2.fromOffset(17,17); icon.Position=UDim2.fromOffset(11,7)
    local text=Label(b,name,11,C.MUTED,Enum.Font.GothamMedium)
    text.Position=UDim2.fromOffset(37,0); text.Size=UDim2.new(1,-42,1,0)
    local page=New("ScrollingFrame",{
        Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,
        ScrollBarThickness=3,ScrollBarImageColor3=C.ACCENT,
        AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(0,0,0,0),Visible=false
    },Content)
    New("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},page)
    New("UIPadding",{PaddingTop=UDim.new(0,14),PaddingBottom=UDim.new(0,15),PaddingLeft=UDim.new(0,13),PaddingRight=UDim.new(0,13)},page)
    Tabs[name]={Button=b,Text=text,Icon=icon,Page=page}
    b.MouseButton1Click:Connect(function() SelectTab(name) end)
    return page
end
local HomePage=CreateTab("Inicio",1)
local PlayerPage=CreateTab("Jugador",2)
local CombatPage=CreateTab("Combate",3)
local CarPage=CreateTab("Car",4)
local VisualPage=CreateTab("Visual",5)
local SettingsPage=CreateTab("Ajustes",6)
SelectTab("Inicio")

local function Section(parent,title)
    local f=New("Frame",{Size=UDim2.new(1,0,0,25),BackgroundTransparency=1},parent)
    local l=Label(f,title,11,C.ACCENT,Enum.Font.GothamBold); l.Size=UDim2.new(1,0,1,0)
end
local function Toggle(parent,title,description,default,callback)
    local row=New("Frame",{Size=UDim2.new(1,0,0,54),BackgroundColor3=C.ROW,BorderSizePixel=0},parent)
    Corner(row,6); Stroke(row,C.BORDER,.7)
    local t=Label(row,title,11,C.TEXT,Enum.Font.GothamMedium); t.Position=UDim2.fromOffset(11,5); t.Size=UDim2.new(1,-65,0,20)
    local desc=Label(row,description or "",9,C.MUTED); desc.Position=UDim2.fromOffset(11,25); desc.Size=UDim2.new(1,-65,0,17)
    local sw=New("TextButton",{Size=UDim2.fromOffset(34,19),Position=UDim2.new(1,-45,.5,-9),BackgroundColor3=default and C.ACCENT or C.OFF,Text="",AutoButtonColor=false,BorderSizePixel=0},row)
    Corner(sw,20)
    local knob=New("Frame",{Size=UDim2.fromOffset(13,13),Position=default and UDim2.new(1,-16,0,3) or UDim2.fromOffset(3,3),BackgroundColor3=C.TEXT,BorderSizePixel=0},sw)
    Corner(knob,20)
    local state=default==true
    local function Set(v)
        state=v
        Animate(sw,{BackgroundColor3=state and C.ACCENT or C.OFF},.15)
        Animate(knob,{Position=state and UDim2.new(1,-16,0,3) or UDim2.fromOffset(3,3)},.15)
        if callback then local ok,err=pcall(callback,state); if not ok then warn("[UI Toggle]",err) end end
    end
    sw.MouseButton1Click:Connect(function() Set(not state) end)
    return {Set=Set,Get=function() return state end,Row=row}
end
local function Slider(parent,title,min,max,default,callback)
    local row=New("Frame",{Size=UDim2.new(1,0,0,67),BackgroundColor3=C.ROW,BorderSizePixel=0},parent)
    Corner(row,6); Stroke(row,C.BORDER,.7)
    local name=Label(row,title,11,C.TEXT,Enum.Font.GothamMedium); name.Position=UDim2.fromOffset(11,5); name.Size=UDim2.new(1,-65,0,20)
    local val=Label(row,tostring(default),10,C.ACCENT,Enum.Font.GothamBold); val.Position=UDim2.new(1,-54,0,5); val.Size=UDim2.fromOffset(42,20); val.TextXAlignment=Enum.TextXAlignment.Right
    local bar=New("Frame",{Position=UDim2.fromOffset(11,43),Size=UDim2.new(1,-22,0,5),BackgroundColor3=C.OFF,BorderSizePixel=0},row); Corner(bar,5)
    local ratio=(default-min)/(max-min)
    local fill=New("Frame",{Size=UDim2.new(ratio,0,1,0),BackgroundColor3=C.ACCENT,BorderSizePixel=0},bar); Corner(fill,5)
    local knob=New("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(ratio,0,.5,0),Size=UDim2.fromOffset(13,13),BackgroundColor3=C.TEXT,BorderSizePixel=0},bar); Corner(knob,10)
    local value=default
    local function Set(v)
        value=math.clamp(math.floor(v+.5),min,max)
        local r=(value-min)/(max-min); val.Text=tostring(value); fill.Size=UDim2.new(r,0,1,0); knob.Position=UDim2.new(r,0,.5,0)
        if callback then local ok,err=pcall(callback,value); if not ok then warn("[UI Slider]",err) end end
    end
    local dragging=false
    local function Update(input)
        if bar.AbsoluteSize.X<=0 then return end
        Set(min+(max-min)*math.clamp((input.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1))
    end
    bar.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true; Update(input) end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then Update(input) end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
    return {Set=Set,Get=function() return value end}
end
local function ActionButton(parent,title,callback)
    local b=Button(parent,title,11); b.Size=UDim2.new(1,0,0,35); Corner(b,6); Stroke(b,C.BORDER,1)
    b.MouseEnter:Connect(function() Animate(b,{BackgroundColor3=C.PANEL},.1) end)
    b.MouseButton1Click:Connect(function() if callback then callback() end end)
    return b
end

-- Home
Section(HomePage,"PANEL PRINCIPAL")
local welcome=New("Frame",{Size=UDim2.new(1,0,0,82),BackgroundColor3=C.PANEL,BorderSizePixel=0},HomePage); Corner(welcome,7); Stroke(welcome,C.BORDER,1)
local wl=Label(welcome,"Bienvenido a ALBAÑIL",14,C.TEXT,Enum.Font.GothamBold); wl.Position=UDim2.fromOffset(13,12); wl.Size=UDim2.new(1,-82,0,24)
local wd=Label(welcome,"Sistema iniciado • "..LP.Name,9,C.MUTED); wd.Position=UDim2.fromOffset(13,39); wd.Size=UDim2.new(1,-82,0,20)
local Avatar=New("ImageLabel",{Name="LocalAvatar",Size=UDim2.fromOffset(54,54),Position=UDim2.new(1,-67,.5,-27),BackgroundColor3=C.ROW,BorderSizePixel=0,ScaleType=Enum.ScaleType.Crop},welcome)
Corner(Avatar,27); Stroke(Avatar,C.ACCENT,2)
task.spawn(function()
    local ok,thumb=pcall(function()
        return Players:GetUserThumbnailAsync(LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)
    end)
    if ok and Avatar and Avatar.Parent then Avatar.Image=thumb end
end)
Section(HomePage,"INFORMACIÓN")
local info=New("Frame",{Size=UDim2.new(1,0,0,55),BackgroundColor3=C.ROW,BorderSizePixel=0},HomePage); Corner(info,6)
local pi=Label(info,"Jugador: "..LP.Name,11,C.TEXT); pi.Position=UDim2.fromOffset(12,5); pi.Size=UDim2.new(1,-20,0,20)
local ui=Label(info,"User ID: ••••••••",10,C.MUTED); ui.Position=UDim2.fromOffset(12,27); ui.Size=UDim2.new(1,-20,0,18)

-- Player movement
Section(PlayerPage,"MOVIMIENTO")
local function GetHumanoid()
    local char=LP.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end
local WalkEnabled,JumpEnabled=false,false
local OriginalWalk,OriginalJump=16,50
Slider(PlayerPage,"Velocidad (100 = 1x)",0,300,Config.WalkSpeed,function(v)
    Config.WalkSpeed=v
    if WalkEnabled then
        local h=GetHumanoid()
        if h then h.WalkSpeed=16*(v/100) end
    end
    SaveConfig()
end)
Toggle(PlayerPage,"Activar WalkSpeed","Control local de velocidad",false,function(v)
    WalkEnabled=v
    local h=GetHumanoid()
    if h then if v then OriginalWalk=h.WalkSpeed; h.WalkSpeed=16*(Config.WalkSpeed/100) else h.WalkSpeed=OriginalWalk end end
end)
Slider(PlayerPage,"JumpPower",0,200,Config.JumpPower,function(v)
    Config.JumpPower=v
    local h=GetHumanoid()
    if JumpEnabled and h then h.UseJumpPower=true; h.JumpPower=v end
    SaveConfig()
end)
Toggle(PlayerPage,"Activar JumpPower","Control local de salto",false,function(v)
    JumpEnabled=v
    local h=GetHumanoid()
    if h then if v then OriginalJump=h.JumpPower; h.UseJumpPower=true; h.JumpPower=Config.JumpPower else h.JumpPower=OriginalJump end end
end)
ActionButton(PlayerPage,"Restaurar movimiento",function()
    WalkEnabled=false; JumpEnabled=false
    local h=GetHumanoid()
    if h then h.WalkSpeed=OriginalWalk; h.JumpPower=OriginalJump end
end)
LP.CharacterAdded:Connect(function()
    task.wait(1)
    local h=GetHumanoid()
    if h then
        if WalkEnabled then h.WalkSpeed=16*(Config.WalkSpeed/100) end
        if JumpEnabled then h.UseJumpPower=true; h.JumpPower=Config.JumpPower end
    end
end)

-- Line Lock: marcador visual solamente; no mueve ni fija la cámara.
Section(CombatPage,"LINE LOCK VISUAL")
local CombatInfo=New("Frame",{Size=UDim2.new(1,0,0,55),BackgroundColor3=C.PANEL,BorderSizePixel=0},CombatPage)
Corner(CombatInfo,7); Stroke(CombatInfo,C.BORDER,1)
local CombatTitle=Label(CombatInfo,"Marcado visual dentro del FOV",11,C.TEXT,Enum.Font.GothamBold)
CombatTitle.Position=UDim2.fromOffset(11,5); CombatTitle.Size=UDim2.new(1,-20,0,19)
local CombatDesc=Label(CombatInfo,"No mueve la cámara ni controla al personaje.",9,C.MUTED)
CombatDesc.Position=UDim2.fromOffset(11,26); CombatDesc.Size=UDim2.new(1,-20,0,18)
Toggle(CombatPage,"Activar Line Lock","Selecciona visualmente al jugador más cercano al centro",Config.LineLockEnabled,function(v)
    Config.LineLockEnabled=v; SaveConfig()
end)
Toggle(CombatPage,"Línea roja al objetivo","Mostrar una línea desde el centro inferior",Config.TargetLineEnabled,function(v)
    Config.TargetLineEnabled=v; SaveConfig()
end)
Toggle(CombatPage,"Rombo de 4 líneas","Dibujar un rombo alrededor del objetivo",Config.DiamondEnabled,function(v)
    Config.DiamondEnabled=v; SaveConfig()
end)
local PartRow=New("Frame",{Size=UDim2.new(1,0,0,52),BackgroundColor3=C.ROW,BorderSizePixel=0},CombatPage)
Corner(PartRow,6); Stroke(PartRow,C.BORDER,.7)
local PartLabel=Label(PartRow,"Parte objetivo",11,C.TEXT,Enum.Font.GothamMedium)
PartLabel.Position=UDim2.fromOffset(11,5); PartLabel.Size=UDim2.new(1,-115,0,18)
local PartButton=Button(PartRow,Config.TargetPart,10)
PartButton.Size=UDim2.fromOffset(88,29); PartButton.Position=UDim2.new(1,-99,.5,-14); Corner(PartButton,5); Stroke(PartButton,C.ACCENT,1)
PartButton.MouseButton1Click:Connect(function()
    Config.TargetPart=(Config.TargetPart=="Cabeza") and "Pecho" or "Cabeza"
    PartButton.Text=Config.TargetPart; SaveConfig()
end)

Section(CarPage,"VEHÍCULOS")
local CarInfo=New("Frame",{Size=UDim2.new(1,0,0,62),BackgroundColor3=C.PANEL,BorderSizePixel=0},CarPage)
Corner(CarInfo,7); Stroke(CarInfo,C.BORDER,1)
local CarTitle=Label(CarInfo,"Menú de vehículos",11,C.TEXT,Enum.Font.GothamBold)
CarTitle.Position=UDim2.fromOffset(11,7); CarTitle.Size=UDim2.new(1,-20,0,20)
local CarDesc=Label(CarInfo,"Sección independiente para opciones de vehículos.",9,C.MUTED)
CarDesc.Position=UDim2.fromOffset(11,29); CarDesc.Size=UDim2.new(1,-20,0,20)

-- FOV Drawing (executor)
local FOVCircle
local FOVConnection
local FOVColorChoices = {
    {"Blanco",Color3.fromRGB(255,255,255)}, {"Rojo",Color3.fromRGB(255,65,65)},
    {"Rosa",Color3.fromRGB(255,95,180)}, {"Morado",Color3.fromRGB(170,95,255)},
    {"Azul",Color3.fromRGB(65,145,255)}, {"Celeste",Color3.fromRGB(55,220,255)},
    {"Cian",Color3.fromRGB(0,255,210)}, {"Verde",Color3.fromRGB(65,230,125)},
    {"Lima",Color3.fromRGB(175,255,65)}, {"Amarillo",Color3.fromRGB(255,220,65)},
    {"Naranja",Color3.fromRGB(255,145,55)}, {"Negro",Color3.fromRGB(20,20,20)}
}
local function GetFOVColor()
    local c=Config.FOVColor or {255,255,255}
    return Color3.fromRGB(math.clamp(tonumber(c[1]) or 255,0,255),
        math.clamp(tonumber(c[2]) or 255,0,255),math.clamp(tonumber(c[3]) or 255,0,255))
end
local function CreateDrawingCircle()
    if FOVCircle then return true end
    local ok,obj=pcall(function()
        local circle=Drawing.new("Circle")
        circle.Visible=false
        circle.NumSides=64
        circle.Radius=Config.FOV
        circle.Color=GetFOVColor()
        circle.Thickness=Config.FOVThickness
        circle.Transparency=Config.FOVTransparency
        circle.Filled=Config.FOVFilled
        return circle
    end)
    if ok and obj then FOVCircle=obj; return true end
    warn("[UI] Este executor no ofrece Drawing.new para el FOV.")
    return false
end
local function UpdateFOV()
    if not CreateDrawingCircle() then return end
    pcall(function()
        FOVCircle.Radius=Config.FOV
        FOVCircle.Color=GetFOVColor()
        FOVCircle.Thickness=Config.FOVThickness
        FOVCircle.Transparency=Config.FOVTransparency
        FOVCircle.Filled=Config.FOVFilled
        FOVCircle.Visible=Config.FOVEnabled
    end)
end
local function SetFOVColor(color)
    Config.FOVColor={math.floor(color.R*255+.5),math.floor(color.G*255+.5),math.floor(color.B*255+.5)}
    UpdateFOV()
    SaveConfig()
end

Section(VisualPage,"FOV CIRCLE")
local FOVInfo=New("Frame",{Size=UDim2.new(1,0,0,55),BackgroundColor3=C.PANEL,BorderSizePixel=0},VisualPage)
Corner(FOVInfo,7); Stroke(FOVInfo,C.BORDER,1)
local FOVInfoTitle=Label(FOVInfo,"Círculo de campo de visión",11,C.TEXT,Enum.Font.GothamBold)
FOVInfoTitle.Position=UDim2.fromOffset(11,6); FOVInfoTitle.Size=UDim2.new(1,-20,0,19)
local FOVInfoDesc=Label(FOVInfo,"Drawing API • fijo al centro de pantalla",9,C.MUTED)
FOVInfoDesc.Position=UDim2.fromOffset(11,27); FOVInfoDesc.Size=UDim2.new(1,-20,0,17)

Toggle(VisualPage,"Activar FOV","Mostrar u ocultar el círculo",Config.FOVEnabled,function(v)
    Config.FOVEnabled=v; UpdateFOV(); SaveConfig()
end)
Toggle(VisualPage,"Line Lock visual","Marcar un objetivo dentro del FOV (sin apuntado automático)",Config.LineLockEnabled,function(v)
    Config.LineLockEnabled=v; SaveConfig()
end)
Slider(VisualPage,"Radio",20,500,Config.FOV,function(v)
    Config.FOV=v; UpdateFOV(); SaveConfig()
end)
Slider(VisualPage,"Grosor",1,10,Config.FOVThickness,function(v)
    Config.FOVThickness=v; UpdateFOV(); SaveConfig()
end)

Section(VisualPage,"PALETA DE COLORES")
local PaletteFrame=New("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
    BackgroundColor3=C.ROW,BorderSizePixel=0},VisualPage)
Corner(PaletteFrame,7); Stroke(PaletteFrame,C.BORDER,1)
New("UIPadding",{PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,10),
    PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)},PaletteFrame)
New("UIGridLayout",{CellSize=UDim2.fromOffset(35,35),CellPadding=UDim2.fromOffset(8,8),
    SortOrder=Enum.SortOrder.LayoutOrder},PaletteFrame)
local ColorButtons={}
for i,item in ipairs(FOVColorChoices) do
    local name,color=item[1],item[2]
    local holder=New("Frame",{BackgroundTransparency=1,LayoutOrder=i},PaletteFrame)
    local swatch=Button(holder,"",10)
    swatch.Size=UDim2.fromOffset(29,29); swatch.Position=UDim2.fromOffset(3,3)
    swatch.BackgroundColor3=color; Corner(swatch,15)
    local outline=Stroke(swatch,C.BORDER,1)
    ColorButtons[name]={Button=swatch,Stroke=outline,Color=color}
    swatch.MouseButton1Click:Connect(function()
        SetFOVColor(color)
        for other,data in pairs(ColorButtons) do
            local chosen=other==name
            data.Stroke.Color=chosen and C.TEXT or C.BORDER
            data.Stroke.Thickness=chosen and 2 or 1
        end
    end)
end
local currentHex=GetFOVColor():ToHex()
for _,data in pairs(ColorButtons) do
    if data.Color:ToHex()==currentHex then data.Stroke.Color=C.TEXT; data.Stroke.Thickness=2 end
end

FOVConnection=RunService.RenderStepped:Connect(function()
    if not FOVCircle then return end
    pcall(function()
        local camera=workspace.CurrentCamera
        if Config.FOVFollowMouse then
            FOVCircle.Position=UIS:GetMouseLocation()
        elseif camera then
            FOVCircle.Position=Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2)
        end
    end)
end)
UpdateFOV()

--========================================================
-- LINE LOCK VISUAL: rombo de 4 segmentos + línea roja
-- Selecciona el jugador visible más cercano al centro del FOV.
-- No modifica cámara, mouse ni posición del jugador.
--========================================================
local TargetDrawings = {}
local TargetRenderConnection
local CurrentVisualTarget
local function NewTargetLine(color, thickness)
    local line=Drawing.new("Line")
    line.Visible=false
    line.Color=color
    line.Thickness=thickness
    return line
end
pcall(function()
    for i=1,4 do TargetDrawings[i]=NewTargetLine(Color3.fromRGB(255,255,255),2) end
    TargetDrawings.Red=NewTargetLine(Color3.fromRGB(255,45,55),2)
end)
local function HideTargetDrawings()
    for _,d in pairs(TargetDrawings) do pcall(function() d.Visible=false end) end
    CurrentVisualTarget=nil
end
local function GetTargetPart(character)
    if not character then return nil end
    if Config.TargetPart=="Cabeza" then
        return character:FindFirstChild("Head")
    end
    return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
end
TargetRenderConnection=RunService.RenderStepped:Connect(function()
    if not Config.LineLockEnabled then HideTargetDrawings(); return end
    local camera=workspace.CurrentCamera
    if not camera then HideTargetDrawings(); return end
    local center=Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2)
    local radius=Config.FOVEnabled and Config.FOV or 140
    local best,bestPart,bestPos,bestDistance=nil,nil,nil,math.huge
    for _,player in ipairs(Players:GetPlayers()) do
        if player~=LP and player.Character then
            local hum=player.Character:FindFirstChildOfClass("Humanoid")
            local part=GetTargetPart(player.Character)
            if hum and hum.Health>0 and part then
                local screen,onScreen=camera:WorldToViewportPoint(part.Position)
                if onScreen and screen.Z>0 then
                    local pos=Vector2.new(screen.X,screen.Y)
                    local dist=(pos-center).Magnitude
                    if dist<=radius and dist<bestDistance then
                        best,bestPart,bestPos,bestDistance=player,part,pos,dist
                    end
                end
            end
        end
    end
    if not best then HideTargetDrawings(); return end
    CurrentVisualTarget=best
    local p=bestPos
    local w,h=13,19
    local top=Vector2.new(p.X,p.Y-h)
    local right=Vector2.new(p.X+w,p.Y)
    local bottom=Vector2.new(p.X,p.Y+h)
    local left=Vector2.new(p.X-w,p.Y)
    local points={top,right,bottom,left,top}
    for i=1,4 do
        local d=TargetDrawings[i]
        if d then
            d.From=points[i]; d.To=points[i+1]
            d.Visible=Config.DiamondEnabled
        end
    end
    local red=TargetDrawings.Red
    if red then
        red.From=Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y-45)
        red.To=p
        red.Visible=Config.TargetLineEnabled
    end
end)

--========================================================
-- CÍRCULO DEL PERSONAJE LOCAL (debajo de quien usa la UI)
--========================================================
local PlayerCirclePart
local PlayerCircleConnection

local function CreatePlayerCircle()
    if PlayerCirclePart then return end

    local part = Instance.new("Part")
    part.Name = "ALBANIL_LocalPlayerCircle"
    part.Shape = Enum.PartType.Cylinder
    part.Size = Vector3.new(0.10, 7.5, 7.5)
    part.Material = Enum.Material.Neon
    part.Color = C.ACCENT
    part.Transparency = 0.38
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CastShadow = false
    part.Locked = true
    part.Parent = workspace

    PlayerCirclePart = part

    PlayerCircleConnection = RunService.RenderStepped:Connect(function()
        if not Config.PlayerCircleEnabled or not PlayerCirclePart then return end

        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if root and humanoid and humanoid.Health > 0 then
            local groundOffset = humanoid.HipHeight + (root.Size.Y * 0.5) + 0.05
            local position = root.Position - Vector3.new(0, groundOffset, 0)
            PlayerCirclePart.CFrame =
                CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
            PlayerCirclePart.Color = C.ACCENT
            PlayerCirclePart.Transparency = 0.38
        else
            PlayerCirclePart.Transparency = 1
        end
    end)
end

Section(VisualPage,"JUGADOR LOCAL")
local PlayerCircleInfo = New("Frame",{
    Size=UDim2.new(1,0,0,53), BackgroundColor3=C.PANEL, BorderSizePixel=0
},VisualPage)
Corner(PlayerCircleInfo,7); Stroke(PlayerCircleInfo,C.BORDER,1)
local PlayerCircleTitle = Label(PlayerCircleInfo,"Círculo bajo tu personaje",11,C.TEXT,Enum.Font.GothamBold)
PlayerCircleTitle.Position=UDim2.fromOffset(11,5)
PlayerCircleTitle.Size=UDim2.new(1,-20,0,19)
local PlayerCircleDesc = Label(PlayerCircleInfo,"Sigue al personaje que está usando la UI.",9,C.MUTED)
PlayerCircleDesc.Position=UDim2.fromOffset(11,26)
PlayerCircleDesc.Size=UDim2.new(1,-20,0,17)

Toggle(VisualPage,"Mostrar círculo del jugador","Círculo local debajo de tu personaje",Config.PlayerCircleEnabled,function(v)
    Config.PlayerCircleEnabled=v
    if v then
        CreatePlayerCircle()
    elseif PlayerCirclePart then
        PlayerCirclePart.Transparency=1
    end
    SaveConfig()
end)

-- Settings and themes
Section(SettingsPage,"APARIENCIA")
local ThemeLabel=Label(SettingsPage,"Tema actual: "..Config.Theme,10,C.MUTED); ThemeLabel.Size=UDim2.new(1,0,0,20)
local ThemeButtons=New("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},SettingsPage)
New("UIGridLayout",{CellSize=UDim2.new(0,103,0,30),CellPadding=UDim2.fromOffset(6,6),SortOrder=Enum.SortOrder.LayoutOrder},ThemeButtons)
local function ApplyTheme(name)
    if not Themes[name] then return end
    local old=C
    Config.Theme=name
    C=Palette()

    local function same(a,b)
        return a and b and math.abs(a.R-b.R)<0.002 and math.abs(a.G-b.G)<0.002 and math.abs(a.B-b.B)<0.002
    end
    local replacements={
        {old.BG,C.BG},{old.PANEL,C.PANEL},{old.ROW,C.ROW},
        {old.ACCENT,C.ACCENT},{old.TEXT,C.TEXT},{old.MUTED,C.MUTED},
        {old.BORDER,C.BORDER},{old.OFF,C.OFF}
    }
    for _,o in ipairs(GUI:GetDescendants()) do
        if o:IsA("GuiObject") then
            for _,pair in ipairs(replacements) do
                if same(o.BackgroundColor3,pair[1]) then o.BackgroundColor3=pair[2] end
            end
            if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then
                for _,pair in ipairs(replacements) do
                    if same(o.TextColor3,pair[1]) then o.TextColor3=pair[2] end
                end
            end
        elseif o:IsA("UIStroke") then
            for _,pair in ipairs(replacements) do
                if same(o.Color,pair[1]) then o.Color=pair[2] end
            end
        end
    end
    Main.BackgroundColor3=C.BG
    Header.BackgroundColor3=C.PANEL
    Sidebar.BackgroundColor3=C.PANEL
    Content.BackgroundColor3=C.BG
    for n,d in pairs(Tabs) do
        local active=n==SelectedTab
        d.Button.BackgroundColor3=active and C.ROW or C.PANEL
        d.Text.TextColor3=active and C.TEXT or C.MUTED
        for _,o in ipairs(d.Icon:GetDescendants()) do
            if o:IsA("Frame") then o.BackgroundColor3=active and C.ACCENT or C.MUTED end
            if o:IsA("UIStroke") then o.Color=active and C.ACCENT or C.MUTED end
        end
    end
    ThemeLabel.Text="Tema actual: "..name
    UpdateFOV()
    if PlayerCirclePart then PlayerCirclePart.Color=C.ACCENT end
    SaveConfig()
end
local themeNames={}
for name in pairs(Themes) do table.insert(themeNames,name) end
table.sort(themeNames)
for _,name in ipairs(themeNames) do
    local b=Button(ThemeButtons,name,9); Corner(b,5); Stroke(b,C.BORDER,1)
    b.MouseButton1Click:Connect(function() ApplyTheme(name) end)
end
Section(SettingsPage,"TÍTULO")
local TitleInput=New("TextBox",{
    Size=UDim2.new(1,0,0,34),BackgroundColor3=C.ROW,TextColor3=C.TEXT,
    PlaceholderText="Nombre de la UI",Text=Config.Title,Font=Enum.Font.Gotham,
    TextSize=11,ClearTextOnFocus=false,BorderSizePixel=0
},SettingsPage); Corner(TitleInput,5)
TitleInput.FocusLost:Connect(function()
    Config.Title=TitleInput.Text~="" and TitleInput.Text or "UI"
    Title.Text=Config.Title; SaveConfig()
end)
local SubtitleInput=New("TextBox",{
    Size=UDim2.new(1,0,0,34),BackgroundColor3=C.ROW,TextColor3=C.TEXT,
    PlaceholderText="Subtítulo",Text=Config.Subtitle,Font=Enum.Font.Gotham,
    TextSize=11,ClearTextOnFocus=false,BorderSizePixel=0
},SettingsPage); Corner(SubtitleInput,5)
SubtitleInput.FocusLost:Connect(function()
    Config.Subtitle=SubtitleInput.Text; Subtitle.Text=Config.Subtitle; SaveConfig()
end)
ActionButton(SettingsPage,"Guardar configuración",SaveConfig)

-- Minimize / close (controles simples: − y ×)
local OpenButton=Button(GUI,"UI",13)
OpenButton.Size=UDim2.fromOffset(46,46); OpenButton.Position=UDim2.new(0,18,.5,-23)
OpenButton.BackgroundColor3=C.PANEL; OpenButton.Visible=false
OpenButton.Font=Enum.Font.GothamBold; Corner(OpenButton,14); Stroke(OpenButton,C.ACCENT,1.5)
Minimize.MouseButton1Click:Connect(function() Main.Visible=false; OpenButton.Visible=true end)
OpenButton.MouseButton1Click:Connect(function() Main.Visible=true; OpenButton.Visible=false end)
Close.MouseButton1Click:Connect(function() GUI:Destroy() end)

-- Drag window (mouse and touch)
local dragging,dragStart,startPos=false,nil,nil
Header.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true; dragStart=input.Position; startPos=Main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local delta=input.Position-dragStart
        local v=Camera.ViewportSize
        local w,h=Main.AbsoluteSize.X,Main.AbsoluteSize.Y
        local x=math.clamp(startPos.X.Offset+delta.X,0,math.max(0,v.X-w))
        local y=math.clamp(startPos.Y.Offset+delta.Y,0,math.max(0,v.Y-h))
        Main.AnchorPoint=Vector2.zero
        Main.Position=UDim2.fromOffset(x,y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)

GUI.Destroying:Connect(function()
    if FOVConnection then FOVConnection:Disconnect() end
    if TargetRenderConnection then TargetRenderConnection:Disconnect(); TargetRenderConnection=nil end
    for _,d in pairs(TargetDrawings) do pcall(function() d:Remove() end) end
    table.clear(TargetDrawings)
    if FOVCircle then pcall(function() FOVCircle:Remove() end); FOVCircle=nil end
    if PlayerCircleConnection then PlayerCircleConnection:Disconnect(); PlayerCircleConnection=nil end
    if PlayerCirclePart then PlayerCirclePart:Destroy(); PlayerCirclePart=nil end
end)

ApplyTheme(Config.Theme)
Title.Text=Config.Title
Subtitle.Text=Config.Subtitle
UpdateFOV()
print("[UI] ALBAÑIL V0.5 iniciado")
