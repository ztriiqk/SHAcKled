local VisualsTab = {}
function VisualsTab.Visual()
--LagCompWall
    if PingPoint.Enable.v then
        local vEnScreen = CVector()
        get.NearestPlayersFromScreen()
        for i, _ in pairs(players.id) do
            if Players:isPlayerStreamed(i) then
                local vEnLag = get.PlayerLag(i, -1)
                Utils:GameToScreen(vEnLag, vEnScreen)
                if vEnScreen.fZ > 1 then
                    Render:DrawCircle(vEnScreen.fX, vEnScreen.fY-5, 7, true, Players:getPlayerColor(i))
                end
            end
        end
    end
--Filters
    if Filters.Enable.v then
        if v.filteringid ~= -1 then
            local fX = Filters.X.v
            local fY = Filters.Y.v
            local Heigh = 225
            local Height = 125
            if Players:isPlayerStreamed(v.filteringid) then
                Heigh = Heigh + 20
                Height = Height + 15
            end
            local name = Players:getPlayerName(v.filteringid)
            Render:DrawBoxBorder(fX, fY, 100, 20, 0xFF000000, 0x9F8A33FF)
            Render:DrawText("FILTER",fX+10,fY,0xFFFFFFFF)
            Render:DrawBoxBorder(fX, fY+20, Heigh, Height+50, 0xFF000000, 0x9F000000)
            Render:DrawText( name.." (".. v.filteringid ..")",fX+5,fY+25,Players:getPlayerColor(v.filteringid))
            if Players:isPlayerInFilter(v.filteringid) then
                Render:DrawText("Player In Filter",fX+5,fY+50,0xFF00D062)
            else
                Render:DrawText("Press 1 To Add Name to Filter",fX+5,fY+50,0xFFD32213)
            end
            fY = fY + 20 
            if Players:isPlayerStreamed(v.filteringid) then
                if Players:isSkinInFilter(Players:getPlayerSkin(v.filteringid)) then
                    Render:DrawText("Skin In Filter",fX+5,fY+50,0xFF00D062)
                else
                    Render:DrawText("Press 2 To Add Skin ".. Players:getPlayerSkin(v.filteringid) .." to Filter",fX+5,fY+50,0xFFD32213)
                end
                fY = fY + 20 
            end
            if Players:isPlayerInFilter(v.filteringid) == false then
                if Utils:IsKeyChecked(0x31,0) then
                    SHAkMenu.Open = 1
                    v.filterIdtoSHAk = v.filteringid
                    Timer.Configs[2] = 0
                    Utils:AddFilterName(name)
                    filtertimer = Timers(5000)
                end
            end
            if Players:isPlayerStreamed(v.filteringid) then
                if Players:isSkinInFilter(v.filteringid) == false then
                    if Utils:IsKeyChecked(0x32,0) then
                        SHAkMenu.Open = 1
                        v.filterSkintoSHAk = v.filteringid
                        Timer.Configs[2] = 0
                        Utils:AddFilterSkinID(Players:getPlayerSkin(v.filteringid))
                        filtertimer = Timers(5000)
                    end
                end
            end
            Global.PlayerListName = ImBuffer("".. Players:getPlayerName(v.filteringid) ,25)
            if not PlayerList[Global.PlayerListName.v] then
                local SkinID = 0
                if Players:isPlayerStreamed(Global.PlayerListID.v) then
                    SkinID = Players:getPlayerSkin(Global.PlayerListID.v)
                end
                AddPlayer(Global.PlayerListName.v, v.filteringid, Global.PlayerListName.v, Global.PlayerListName.v, Players:getPlayerColor(v.filteringid), SkinID)
            end
            if PlayerList[Global.PlayerListName.v].Ignore.Onfoot.v then
                Render:DrawText("Press 3 To Restore OnFoot data",fX+5,fY+50,0xFF00D062)
            else
                Render:DrawText("Press 3 To Ignore OnFoot data",fX+5,fY+50,0xFFD32213)
            end
            fY = fY + 20 
            if PlayerList[Global.PlayerListName.v].Ignore.Incar.v then
                Render:DrawText("Press 4 To Restore InCar data",fX+5,fY+50,0xFF00D062)
            else
                Render:DrawText("Press 4 To Ignore InCar data",fX+5,fY+50,0xFFD32213)
            end
            fY = fY + 20
            if PlayerList[Global.PlayerListName.v].Ignore.Bullet.v then
                Render:DrawText("Press 5 To Restore Bullet data",fX+5,fY+50,0xFF00D062)
            else
                Render:DrawText("Press 5 To Ignore Bullet data",fX+5,fY+50,0xFFD32213)
            end
            fY = fY + 20
            if PlayerList[Global.PlayerListName.v].HidePlayer.v then
                Render:DrawText("Press 6 To Restore Player",fX+5,fY+50,0xFF00D062)
            else
                Render:DrawText("Press 6 To Hide Player",fX+5,fY+50,0xFFD32213)
            end
            fY = fY + 20
            Render:DrawText("Press 7 To Bring Player",fX+5,fY+50,0xFFD32213)
            fY = fY + 20
            if PlayerList[Global.PlayerListName.v].ChangeColor.v then
                Render:DrawText("Press 8 To Restore Color",fX+5,fY+50,0xFF00D062)
            else
                Render:DrawText("Press 8 To Change Color",fX+5,fY+50,0xFFD32213)
            end
            if Utils:IsKeyChecked(0x33,0) then
                if PlayerList[Global.PlayerListName.v].Ignore.Onfoot.v then
                    PlayerList[Global.PlayerListName.v].Ignore.Onfoot = ImBool(false)
                else
                    PlayerList[Global.PlayerListName.v].Ignore.Onfoot = ImBool(true)
                end
                filtertimer = Timers(5000)
            end
            if Utils:IsKeyChecked(0x34,0) then
                if PlayerList[Global.PlayerListName.v].Ignore.Incar.v then
                    PlayerList[Global.PlayerListName.v].Ignore.Incar = ImBool(false)
                else
                    PlayerList[Global.PlayerListName.v].Ignore.Incar = ImBool(true)
                end
                filtertimer = Timers(5000)
            end
            if Utils:IsKeyChecked(0x35,0) then
                if PlayerList[Global.PlayerListName.v].Ignore.Bullet.v then
                    PlayerList[Global.PlayerListName.v].Ignore.Bullet = ImBool(false)
                else
                    PlayerList[Global.PlayerListName.v].Ignore.Bullet = ImBool(true)
                end
                filtertimer = Timers(5000)
            end
            if Utils:IsKeyChecked(0x36,0) then
                if PlayerList[Global.PlayerListName.v].HidePlayer.v then
                    PlayerList[Global.PlayerListName.v].HidePlayer = ImBool(false)
                    local vMyPos = Players:getPlayerPosition(Players:getLocalID())
                    local bsData = BitStream()
                    bsWrap:Write16(bsData, v.filteringid)
                    bsWrap:Write8(bsData, 0)
                    bsWrap:Write32(bsData, PlayerList[Global.PlayerListName.v].PlayerSkin.v)
                    bsWrap:WriteFloat(bsData, vMyPos.fX-1000000000000)
                    bsWrap:WriteFloat(bsData, vMyPos.fY-1000000000000)
                    bsWrap:WriteFloat(bsData, vMyPos.fZ-10)
                    bsWrap:WriteFloat(bsData, 0)
                    color = tonumber(PlayerList[Global.PlayerListName.v].FirstColor.v)
                    if color == nil or color ~= tonumber(color) or color <= 0 then
                        color = Players:getPlayerColor(v.filteringid)
                        local newcolor = bit.bor(bit.lshift(bit.band(color, 0x00ffffff), 8), bit.rshift(color, 24))
                        color = newcolor
                    end
                    bsWrap:Write32(bsData, color)
                    bsWrap:Write8(bsData, 0)
                    EmulRPC(32, bsData)
                    bsWrap:Reset(bsData)
                else
                    PlayerList[Global.PlayerListName.v].HidePlayer = ImBool(true)
                    local bsData = BitStream()
                    bsWrap:Write16(bsData, v.filteringid)
                    EmulRPC(163, bsData)
                    bsWrap:Reset(bsData)
                end
                filtertimer = Timers(5000)
            end
            if Utils:IsKeyChecked(0x37,0) then
                local vMyPos = Players:getPlayerPosition(Players:getLocalID())
                local bsData = BitStream()
                bsWrap:Write16(bsData, v.filteringid)
                bsWrap:Write8(bsData, 0)
                bsWrap:Write32(bsData, PlayerList[Global.PlayerListName.v].PlayerSkin.v)
                bsWrap:WriteFloat(bsData, vMyPos.fX)
                bsWrap:WriteFloat(bsData, vMyPos.fY)
                bsWrap:WriteFloat(bsData, vMyPos.fZ)
                bsWrap:WriteFloat(bsData, 0)
                color = tonumber(PlayerList[Global.PlayerListName.v].FirstColor.v)
                if color == nil or color ~= tonumber(color) or color <= 0 then
                    color = Players:getPlayerColor(v.filteringid)
                    local newcolor = bit.bor(bit.lshift(bit.band(color, 0x00ffffff), 8), bit.rshift(color, 24))
                    color = newcolor
                end
                bsWrap:Write32(bsData, color)
                bsWrap:Write8(bsData, 0)
                EmulRPC(32, bsData)
                bsWrap:Reset(bsData)
                filtertimer = Timers(5000)
            end
            if Utils:IsKeyChecked(0x38,0) then
                if PlayerList[Global.PlayerListName.v].ChangeColor.v then
                    PlayerList[Global.PlayerListName.v].ChangeColor = ImBool(false)
                else
                    PlayerList[Global.PlayerListName.v].ChangeColor = ImBool(true)
                end
                filtertimer = Timers(5000)
            end
        end
    end
--Stream WallHack
    if StreamWall.Enable.v then
        local Xw = StreamWall.X.v
        local Yw = StreamWall.Y.v
        local Ww = 150
        local Hw = 20
        local showmax = ImBuffer("",5)
        local passthrumax = 0
        local LimitSW = 0
        if LimitSW > 2 then
            Xw = Xw + 500
        end
        local fX = Utils:getResolutionX() * 0.5
        local fY = Utils:getResolutionY() * 0.5
        
        get.NearestPlayersFromScreen()
        for i, _ in pairs(players.id) do
            if Players:isPlayerStreamed(i) then
                local names = Players:getPlayerName(i)
                local HP = Players:getPlayerHP(i)
                local Armor = Players:getPlayerArmour(i)
                local HPw = 0
                local Armorw = 0
                if StreamWall.AFK.v or StreamWall.AFK.v == false and Players:isPlayerAFK(i) == false then
                    LimitSW = LimitSW + 1
                    if LimitSW < StreamWall.MaxPlayers.v then

                        local buff = ImBuffer("",5)
                        if Players:isPlayerInFilter(i) or Players:isSkinInFilter(i) then
                            buff = ImBuffer("[F] ",5)
                        end

                        Yw = Yw - 15
                        Xfh = Xw
                        Yfh = Yw
                        if StreamWall.HP.v then
                            if Armor == 0 then
                                Yfh = Yw - 2
                            end
                            Volume = 52
                            HPw = HP *0.5
                            Armorw = Armor *0.5
                            if HPw > 50 then
                                HPw = 50
                            end
                            if Armorw > 50 then
                                Armorw = 50
                            end
                            if Players:isPlayerAFK(i) == false and StreamWall.AFK.v == false or StreamWall.AFK.v then
                                if get.isPlayerAlive(i) == true then
                                    Render:DrawBoxBorder(Xw, Yfh+8, Volume, 8, 0xFF000000, 0xFF660000)
                                    Render:DrawBox(Xw+1, Yfh+9, HPw, 6, 0xFFDc0505)    
                                    if Armor > 0 then
                                        Render:DrawBoxBorder(Xw, Yfh+4, Volume, 6, 0xFF000000, 0xFF282429)
                                        Render:DrawBox(Xw+1, Yfh+5, Armorw, 4, 0xFF8d7f90)
                                    end
                                end
                                if get.isPlayerAlive(i) == true then
                                    if HP > 100 or HP < 0 then
                                        Render:DrawText(("GOD"),Xfh+8,Yfh+1,0xFFFFFFFF)
                                    end
                                else
                                    Render:DrawText(("DEAD"),Xfh+8,Yfh+1,0xFF322f2f)
                                end
                            end
                        end
                        if Players:isPlayerAFK(i) then
                            if StreamWall.AFK.v then
                                local vEnPos = Players:getPlayerPosition(i)
                                if Utils:isOnScreen(i) then
                                    if Utils:IsLineOfSightClear(Players:getPlayerPosition(Players:getLocalID()), vEnPos, true, false ,false, true, false, false, false) then
                                        Render:DrawCircle(Xw-13, Yw+10, 5, true, 0xFF00FF00)
                                    else
                                        Render:DrawCircle(Xw-13, Yw+10, 5, true, 0xFF003300)
                                    end
                                else
                                    if Utils:IsLineOfSightClear(Players:getPlayerPosition(Players:getLocalID()), vEnPos, true, false ,false, true, false, false, false) then
                                        Render:DrawCircle(Xw-13, Yw+10, 5, true, 0xFFFF0000)
                                    else
                                        Render:DrawCircle(Xw-13, Yw+10, 5, true, 0xFF96492b)
                                    end
                                end
                                Render:DrawText("[AFK]",Xw+60,Yw,0xFF141414)
                                Render:DrawText(buff.v.. names.."  (".. i ..")",Xw+105,Yw,Players:getPlayerColor(i))
                            else
                                Yw = Yw + 15
                            end
                        else
                            local color 
                            local vEnPos = Players:getPlayerPosition(i)
                            if Utils:isOnScreen(i) then
                                if Utils:IsLineOfSightClear(Players:getPlayerPosition(Players:getLocalID()), vEnPos, true, false ,false, true, false, false, false) then
                                    color = 0xFF00FF00
                                else
                                    color = 0xFF003300
                                end
                            else
                                if Utils:IsLineOfSightClear(Players:getPlayerPosition(Players:getLocalID()), vEnPos, true, false ,false, true, false, false, false) then
                                    color = 0xFFFF0000
                                else
                                    color = 0xFF96492b
                                end
                            end
                            Render:DrawCircle(Xw-13, Yw+10, 5, true, color)
                            local vEnDriver = Players:isDriver(i)
                            local vEnPassenger = false
                            if not vEnDriver then
                                vEnPassenger = Players:Driving(i)
                            end
                            local newX = Xw + 60
                            local newX2 = Xw
                            color = 0xFF5c5c5c
                            local driverpassenger = ImBuffer("",2)

                            if StreamWall.HP.v then
                                if vEnDriver then
                                    driverpassenger = ImBuffer("[DRIVING]",25)
                                    newX2 = newX2 + 60
                                    newX = newX + 75

                                    if Players:isPlayerInFilter(i) or Players:isSkinInFilter(i) then
                                        buff = ImBuffer("[F] ",5)
                                    end
                                elseif vEnPassenger then
                                    color = 0xFFcfc6c6

                                    driverpassenger = ImBuffer("[PASSENGER]",25)

                                    newX2 = newX2 + 60
                                    newX = newX + 100
                                end
                            end
                            Render:DrawText(""..driverpassenger.v, newX2,Yw,color)
                            Render:DrawText(buff.v .. names.."  (".. i ..")",newX,Yw,Players:getPlayerColor(i))
                        end
                    else
                        passthrumax = passthrumax + 1
                    end
                end
            end
        end
        local showmax = ImBuffer("+ ".. passthrumax ,12)
        if passthrumax == 0 then
            showmax = ImBuffer("")
        end
        Yw = Yw - 30
        get.Visuals()
        Render:DrawText("STREAM WALLHACK   "..showmax.v ,Xw,Yw,v.colorShackled)
    end
--RadarHack
    if RadarHack.Enable.v then
        local vMyPos
        if RadarHack.LinkedToChar.v then
            vMyPos = Players:getBonePosition(Players:getLocalID(),RadarHack.Bone.v)
        else
            vMyPos = Players:getPlayerPosition(Players:getLocalID())
        end
        Utils:GameToScreen(vMyPos, vMyScreen)
        get.NearestPlayersFromScreen()
        for i, _ in pairs(players.id) do
            if Players:isPlayerStreamed(i) then
                if Global.AfterDamageDelayPer[i] ~= nil and Global.AfterDamageDelayPer[i] > 1500 then
                    Global.AfterDamage[i] = nil
                    Global.AfterDamageDelayPer[i] = 0
                end
                if Global.AfterDamage[i] ~= nil and RadarHack.AfterDamage.v or 
                RadarHack.AfterDamage.v == false then
                    get.PlayerToRadar(i, vMyPos)
                    if RadarHack.PlayerPos[i] ~= nil then
                        if RadarHack.AfterDamage.v then
                            if Global.AfterDamageDelayPer[i] == nil then
                                Global.AfterDamageDelayPer[i] = 0
                            end
                            Global.AfterDamageDelayPer[i] = Global.AfterDamageDelayPer[i] + 1
                            if Global.AfterDamageDelayPer[i] > 2000 then
                                Global.AfterDamage[i] = nil
                                Global.AfterDamageName[i] = nil
                                Global.AfterDamageDelayPer[i] = 0
                            end
                        end
                        local vEnNormalPos = Players:getPlayerPosition(i)
                        local vEnPos = RadarHack.PlayerPos[i]
                        Utils:GameToScreen(vEnPos, vEnScreen)
                        local zground = Utils:FindGroundZForCoord(vEnNormalPos.fX,vEnNormalPos.fY)
                        
                        local LimitRH = 0
                        local maxLength = RadarHack.maxDistance.v
                        local Distance3d = Utils:Get2Ddist(vMyPos, vEnNormalPos)
                        if Distance3d > RadarHack.lowDistance.v and Distance3d < RadarHack.maxDistance.v then
                            local visiblecheck = true
                            if RadarHack.Onlyoutofview.v then
                                if Utils:isOnScreen(i) then
                                    if Utils:IsLineOfSightClear(vMyPos, vEnPos, true, false ,false, true, false, false, false) then
                                        visiblecheck = false
                                    end
                                end
                            end
                            if visiblecheck == true then
                                LimitRH = LimitRH + 1
                                if LimitRH < RadarHack.MaxPlayers.v then
                                    if RadarHack.ShowLine.v then
                                        Render:DrawLine(vMyScreen.fX+RadarHack.X.v,vMyScreen.fY+RadarHack.Y.v,vEnScreen.fX+RadarHack.X.v,vEnScreen.fY+RadarHack.Y.v,0x2FFFFFFF)
                                    end
                                    if Utils:isOnScreen(i) then
                                        if Utils:IsLineOfSightClear(vMyPos, vEnNormalPos, true, false ,false, true, false, false, false) then
                                            Render:DrawCircle(vEnScreen.fX+RadarHack.X.v,vEnScreen.fY+RadarHack.Y.v, 3, true, 0xFF00FF00)
                                        else
                                            Render:DrawCircle(vEnScreen.fX+RadarHack.X.v,vEnScreen.fY+RadarHack.Y.v, 3, true, 0xFF003300)
                                        end
                                    else
                                        if Utils:IsLineOfSightClear(vMyPos, vEnNormalPos, true, false ,false, true, false, false, false) then
                                            Render:DrawCircle(vEnScreen.fX+RadarHack.X.v,vEnScreen.fY+RadarHack.Y.v, 3, true, 0xFFFF0000)
                                        else
                                            Render:DrawCircle(vEnScreen.fX+RadarHack.X.v,vEnScreen.fY+RadarHack.Y.v, 3, true, 0xFF96492b)
                                        end
                                    end
                                    if RadarHack.ShowHP.v then
                                        if vEnScreen.fZ > 1 then
                                            vEnScreen.fY = vEnScreen.fY - RadarHack.HPHeight.v + 5
                                        else
                                            vEnScreen.fY = vEnScreen.fY + RadarHack.HPHeight.v - 10
                                        end
                                    end
                                    local bufname = ImBuffer(" ",1)
                                    local buffriend = ImBuffer("",0)
                                    if Players:isPlayerInFilter(i) or Players:isSkinInFilter(i) then
                                        buffriend = ImBuffer("[F] ",4)
                                    end
                                    if RadarHack.ShowName.v then
                                        bufname = ImBuffer( Players:getPlayerName(i).." ",25)
                                    end
                                    Render:DrawText(buffriend.v .. bufname.v.."(".. i ..")",vEnScreen.fX+RadarHack.X.v,vEnScreen.fY+RadarHack.Y.v-20,Players:getPlayerColor(i))
                                            
                                    if zground + 3 < vEnNormalPos.fZ then
                                        Render:DrawBox(vEnScreen.fX+RadarHack.X.v-7, vEnScreen.fY+RadarHack.Y.v-3, 15, 2, 0xFFFFFFFF)  
                                    end
                                    Render:DrawCircle(vMyScreen.fX+RadarHack.X.v,vMyScreen.fY+RadarHack.Y.v, 2, true, 0xFFFFFFFF)
                                    if RadarHack.ShowHP.v then
                                        local HPRh = Players:getPlayerHP(i)
                                        local ArmorRh = Players:getPlayerArmour(i)
                                        if vEnScreen.fZ > 1 and ArmorRh > 0 then 
                                            vEnScreen.fY = vEnScreen.fY + 5
                                        end
                                        vEnScreen.fY = vEnScreen.fY + RadarHack.Y.v - 15
                                        vEnScreen.fX = vEnScreen.fX + RadarHack.X.v + 8
                                        
                                        VolumeRh = RadarHack.HPSize.v
                                        
                                        HPRh =  (RadarHack.HPSize.v * 0.01) * HPRh
                                        ArmorRh = (RadarHack.HPSize.v * 0.01) * ArmorRh
                                        if HPRh > VolumeRh then
                                            HPRh = VolumeRh - 2
                                        end
                                        if ArmorRh > VolumeRh then
                                            ArmorRh = VolumeRh - 2
                                        end
                                        Render:DrawBoxBorder(vEnScreen.fX-3, vEnScreen.fY+16, VolumeRh, RadarHack.HPHeight.v, 0xFF000000, 0xFF660000)
                                        Render:DrawBox(vEnScreen.fX-2, vEnScreen.fY+17, HPRh-2, RadarHack.HPHeight.v-2, 0xFFE70606)    
                                        if ArmorRh > 0 then
                                            Render:DrawBoxBorder(vEnScreen.fX-3, vEnScreen.fY+16-RadarHack.HPHeight.v, VolumeRh, RadarHack.HPHeight.v, 0xFF000000, 0xFF282429)
                                            Render:DrawBox(vEnScreen.fX-2, vEnScreen.fY+17-RadarHack.HPHeight.v, ArmorRh-2, RadarHack.HPHeight.v-2, 0xFF8d7f90)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                if Global.AfterDamage[i] ~= nil then
                    if Players:isPlayerOnServer(i) then
                        if Global.AfterDamageName[i] ~= Players:getPlayerName(i) then
                            Global.AfterDamage[i] = nil
                            Global.AfterDamageName[i] = nil
                        end
                    end
                end
            end
        end
    end
--Indicators
    if Indicator.Enable.v then
        get.Visuals()
        local X = Indicator.X.v
        local Y = Indicator.Y.v
        local W = 76
        local H = 20
        local W2 = 162
        local H2 = 35
        local Hww = 150
        local Hww3 = 0
        local Hww4 = 0
        local Hww5 = 0
        local Hww6 = 0
        local Hww7 = 0
        if Indicator.MacroRun.v and KeyToggle.MacroRun.v == 1 and Global.runstate == 7 and Panic.EveryThingExceptVisuals.v == false then
            H2 = H2 + 18
        end
        if Indicator.Damager.v and KeyToggle.Damager.v == 1 and Panic.EveryThingExceptVisuals.v == false then
            H2 = H2 + 32
        end
        if Indicator.Silent.v and KeyToggle.Silent.v == 1 and Panic.EveryThingExceptVisuals.v == false then
            H2 = H2 + 32
        end
        local slide = 0
        if Movement.Slide.PerWeap.v == false then slide = 1 
        elseif Movement.Slide.SilencedPistol.v and Players:getPlayerWeapon(Players:getLocalID()) == 23 then slide = 1
        elseif Movement.Slide.DesertEagle.v and Players:getPlayerWeapon(Players:getLocalID()) == 24 then slide = 1 
        elseif Movement.Slide.Shotgun.v and Players:getPlayerWeapon(Players:getLocalID()) == 25 then slide = 1 
        elseif Movement.Slide.CombatShotgun.v and Players:getPlayerWeapon(Players:getLocalID()) == 27 then slide = 1 
        elseif Movement.Slide.Mp5.v and Players:getPlayerWeapon(Players:getLocalID()) == 29 then slide = 1 
        elseif Movement.Slide.Ak47.v and Players:getPlayerWeapon(Players:getLocalID()) == 30 then slide = 1 
        elseif Movement.Slide.M4.v and Players:getPlayerWeapon(Players:getLocalID()) == 31 then slide = 1 
        elseif Movement.Slide.CountryRifle.v and Players:getPlayerWeapon(Players:getLocalID()) == 33 then slide = 1 
        elseif Movement.Slide.SniperRifle.v and Players:getPlayerWeapon(Players:getLocalID()) == 34 then slide = 1 end
        
        if Indicator.Slide.v and slide == 1 and Movement.Slide.Enable.v and Panic.EveryThingExceptVisuals.v == false then
            H2 = H2 + 18
        end
        if Indicator.FakeLagPeek.v and v.shooting == 0 and Global.DesyncTimer > 0 and Panic.EveryThingExceptVisuals.v == false then
            H2 = H2 + 18
        end
        if Indicator.SlideSpeed.v and slide == 1 and Movement.Slide.Enable.v and Movement.Slide.SpeedEnable.v and Panic.EveryThingExceptVisuals.v == false then
            H2 = H2 + 9
        end
        local car = Players:getVehicleID(Players:getLocalID())
        local vModel = Cars:getCarModel(car)
        if vehicleInfo[vModel] == nil then
            get.vehicleInfoFix()
        else
            if Indicator.Bike.v and Panic.EveryThingExceptVisuals.v == false then
                if Players:isDriver(Players:getLocalID()) and vehicleInfo[vModel].type == VehicleType.Bike then
                    if Vehicle.Bike.OnKey.v and Utils:IsKeyDown(Vehicle.Bike.Key.v) and not v.Chat and not v.Dialog or not Vehicle.Bike.OnKey.v then
                        H2 = H2 + 18
                    end
                end
            end
            if Indicator.Bicycle.v and Panic.EveryThingExceptVisuals.v == false then
                if Players:isDriver(Players:getLocalID()) and vehicleInfo[vModel].type == VehicleType.Bicycle then
                    if Vehicle.Bicycle.OnKey.v and Utils:IsKeyDown(Vehicle.Bicycle.Key.v) and not v.Chat and not v.Dialog or not Vehicle.Bicycle.OnKey.v then
                        H2 = H2 + 18
                    end
                end
            end 
        end
        if Indicator.Sprinthook.v and Movement.Sprinthook.Enable.v and Panic.EveryThingExceptVisuals.v == false  then
            if Movement.Sprinthook.OnKey.v and Utils:IsKeyDown(Movement.Sprinthook.Key.v) and not v.Chat and not v.Dialog or not Movement.Sprinthook.OnKey.v then
                H2 = H2 + 18
            end
        end
        if Indicator.DamageMultiplier.v and KeyToggle.DDamage.v == 1 and Panic.EveryThingExceptVisuals.v == false then
            H2 = H2 + 18
        end
        if Indicator.AntiStun.v and Movement.AntiStun.Enable.v and Panic.EveryThingExceptVisuals.v == false then
            H2 = H2 + 18
        end
        if Indicator.Godmode.v and KeyToggle.GodmodePlayer.v == 1 and Panic.EveryThingExceptVisuals.v == false then
            H2 = H2 + 18
        end
        if Indicator.Godmode.v and KeyToggle.GodmodeVehicle.v == 1 and Panic.EveryThingExceptVisuals.v == false then
            H2 = H2 + 18
        end
        
        if Panic.EveryThingExceptVisuals.v == false then
            if Indicator.Damager.v and KeyToggle.Damager.v == 1 or 
            Indicator.Silent.v and KeyToggle.Silent.v == 1 or Global.Menu == 1 or
            Indicator.MacroRun.v and KeyToggle.MacroRun.v == 1 and Global.runstate == 7 or 
            Indicator.Sprinthook.v and Movement.Sprinthook.Enable.v and Movement.Sprinthook.OnKey.v and Utils:IsKeyDown(Movement.Sprinthook.Key.v) or
            Indicator.Sprinthook.v and not Movement.Sprinthook.OnKey.v or
            Indicator.Slide.v and slide == 1 and Movement.Slide.Enable.v  or
            Indicator.FakeLagPeek.v and v.shooting == 0 and Global.DesyncTimer > 0 or
            Indicator.SlideSpeed.v and slide == 1 and Movement.Slide.Enable.v or Indicator.AntiStun.v and Movement.AntiStun.Enable.v or 
            Indicator.Bicycle.v and Vehicle.Bicycle.Enable.v and Vehicle.Bicycle.OnKey.v and Utils:IsKeyDown(Vehicle.Bicycle.Key.v) and Players:isDriver(Players:getLocalID()) and vehicleInfo[vModel].type == VehicleType.Bicycle or
            Indicator.Bicycle.v and Vehicle.Bicycle.Enable.v and not Vehicle.Bicycle.OnKey.v and Players:isDriver(Players:getLocalID()) and vehicleInfo[vModel].type == VehicleType.Bicycle or
            Indicator.Bike.v and Vehicle.Bike.Enable.v and Vehicle.Bike.OnKey.v and Utils:IsKeyDown(Vehicle.Bike.Key.v) and Players:isDriver(Players:getLocalID()) and vehicleInfo[vModel].type == VehicleType.Bike or
            Indicator.Bike.v and Vehicle.Bike.Enable.v and not Vehicle.Bike.OnKey.v and Players:isDriver(Players:getLocalID()) and vehicleInfo[vModel].type == VehicleType.Bike or
            Indicator.DamageMultiplier.v and KeyToggle.DDamage.v == 1 or
            Indicator.Godmode.v and KeyToggle.GodmodePlayer.v == 1 or Indicator.Godmode.v and KeyToggle.GodmodeVehicle.v == 1
            then
                indicatorX = X
                if X > Utils:getResolutionX() * 0.5 then
                    indicatorX = indicatorX + 90
                end
                Render:DrawBox(X-5, Y, W2, H2, 0x8F3a3d3b)
                Render:DrawBoxBorder(X-5, Y, W2, H2, v.colorBorder1, 0x00000000)
                Render:DrawBoxBorder(indicatorX-5, Y, W2, H, v.colorBorder1, 0)
                Render:DrawText("".. v.BuffShackled ,indicatorX,Y,v.colorShackled)

                X = Indicator.X.v
                Y = Indicator.Y.v
            end
        end
    --Damager
        if Indicator.Damager.v and KeyToggle.Damager.v == 1 and Panic.EveryThingExceptVisuals.v == false then
            Y = Y + 17
            local color = 0xFF000000 
            Y = Y + 15
            Hww6 = (Damager.Delay.v * 0.148)
            if Hww6 > 148 then
                Hww6 = 148
            end
            Render:DrawBoxBorder(X, Y+5, Hww, 10, color, 0x2FFFA533)
            get.doColor(252, 198, 91, 0, 255)
            if v.colorsIndicator[0] ~= nil then 
                Render:DrawBox(X+1, Y+6, Hww6, 8, v.colorsIndicator[0])
            end
            Y = Y + 7
            Hww6 = (Damager.Chance.v * 1.49)
            if Hww6 > 148 then
                Hww6 = 148
            end

            Render:DrawBoxBorder(X, Y+8.5, Hww, 10, color, 0x4fA975C7)
            get.doColor(251, 141, 226, 1, 255)
            if v.colorsIndicator[1] ~= nil then 
                Render:DrawBox(X+1, Y+9.7, Hww6, 8, v.colorsIndicator[1])
            end
            
            get.doColor(252, 91, 123, 2, 255)
            if v.colorsIndicator[2] ~= nil then 
                Render:DrawText(("Delay"),X+53,Y-6.7,v.colorsIndicator[2])
            end
            get.doColor(255, 63, 162, 3, 255)
            if v.colorsIndicator[3] ~= nil then 
                Render:DrawText(("Chance"),X+48,Y+3.7,v.colorsIndicator[3])
            end
            Y = Y + 7
        else
            if Indicator.Damager.v == false or KeyToggle.Damager.v == 0 then
                Y = Y + 10
            end
        end
    --Silent
            if Indicator.Silent.v and KeyToggle.Silent.v == 1 and Panic.EveryThingExceptVisuals.v == false then
                local color = 0xFF000000 
                Y = Y + 17
                if SilentStuff.FirstShots == 0 then
                    Hww6 = (SilentStuff.Fov*0.05 * 2.5)
                else
                    Hww6 = (SilentStuff.Fov2*0.05 * 2.5)
                end
                if Hww6 > 148 then
                    Hww6 = 148
                end
                Render:DrawBoxBorder(X, Y+5, Hww, 10, color, 0x2F00898F)
                
                get.doColor(240, 137, 248, 4, 255)
                if v.colorsIndicator[4] ~= nil then 
                    Render:DrawBox(X+1, Y+6, Hww6, 8, v.colorsIndicator[4])
                end
                Y = Y + 7
                if SilentStuff.FirstShots == 0 then
                    Hww6 = (SilentStuff.Chance * 1.49)
                else
                    Hww6 = (SilentStuff.Chance2 * 1.49)
                end
                if Hww6 > 148 then
                    Hww6 = 148
                end
                
                get.doColor(100, 201, 135, 5, 255)
                Render:DrawBoxBorder(X, Y+8.5, Hww, 10, color, 0x4f64c987)
                if v.colorsIndicator[5] ~= nil then 
                    Render:DrawBox(X+1, Y+9.7, Hww6, 8, v.colorsIndicator[5]) 
                end
                
                get.doColor(89, 255, 0, 6, 255)
                if v.colorsIndicator[6] ~= nil then 
                    Render:DrawText(("Fov"),X+59,Y-6.7,v.colorsIndicator[6])
                end
                get.doColor(250, 250, 110, 7, 255)
                if v.colorsIndicator[7] ~= nil then 
                    Render:DrawText(("Chance"),X+48,Y+3.7,v.colorsIndicator[7])
                end
                Y = Y + 7
            end
    --MacroRun
            if Indicator.MacroRun.v and KeyToggle.MacroRun.v == 1 and Panic.EveryThingExceptVisuals.v == false then
                if Global.runstate == 7 then
                    Y = Y + 18
                    local color = 0xFF00FF00
                    local color2 = 0xFF000000
                    Render:DrawBoxBorder(X, Y+5, Hww, 10, color2, 0x3F24464a)
                    if KeyToggle.MacroRun.v == 1 then
                        if Global.IndTimer == 1 then
                            Hww5 = 147
                        else
                            if Global.IndTimer == 0 then
                                Hww5 = 0
                            else
                                Hww5 = 149 - (Global.IndTimer) * 4.8
                            end
                        end
                        if Hww5 > 147 then
                            Hww5 = 147
                        end
                    else
                        Hww5 = 0
                    end
                    get.doColor(77, 166, 255, 8, 255)
                    Render:DrawBoxBorder(X, Y+5, Hww, 10, color2, 0x002b62FF)
                    if v.colorsIndicator[8] ~= nil then 
                        Render:DrawBox(X+1, Y+6, Hww5, 8, v.colorsIndicator[8])
                    end
                    get.doColor(43, 98, 255, 9, 255)
                    if v.colorsIndicator[8] ~= nil then 
                        Render:DrawText(("Run"),X+59,Y,v.colorsIndicator[9])
                    end
                end
            end
    --Sprinhook
        if Indicator.Sprinthook.v and Movement.Sprinthook.Enable.v then
            if Movement.Sprinthook.OnKey.v and Utils:IsKeyDown(Movement.Sprinthook.Key.v) and not v.Chat and not v.Dialog or not Movement.Sprinthook.OnKey.v then
                Y = Y + 18
                local color = 0xFF00FF00
                local color2 = 0xFF000000
                Render:DrawBoxBorder(X, Y+5, Hww, 10, color2, 0x3F24464a)
                Render:DrawBoxBorder(X, Y+5, Hww, 10, color2, 0x002b62FF)
                
                local velocity = Utils:readMemory(0xB7CDB8, 4, false)
                local store = BitStream()
                bsWrap:Write32(store, velocity)
                velocity = bsWrap:ReadFloat(store)
                bsWrap:Reset(store)
                Hww5 = (velocity) * 2.96
                if Hww5 > 148 then
                    Hww5 = 148
                end
                get.doColor(43, 98, 255, 10, 255)
                if v.colorsIndicator[10] ~= nil then 
                    Render:DrawBox(X+1, Y+6, Hww5, 8, v.colorsIndicator[10])
                end
                get.doColor(77, 166, 255, 11, 255)
                if v.colorsIndicator[11] ~= nil then 
                    Render:DrawText(("Sprinthook"),X+38,Y,v.colorsIndicator[11])
                end
            end
        end
    --Slide
        if Indicator.Slide.v and slide == 1 and Movement.Slide.Enable.v and Panic.EveryThingExceptVisuals.v == false then
            Y = Y + 18
            if Global.SwitchVelocity[0] == 10 then
                if v.Hww2 ~= 3 then v.Hww2 = math.random(1,5) end
            end
            if Global.SwitchVelocity[0] == 9 then
                if v.Hww2 ~= 19 then v.Hww2 = math.random(16,22) end
            end
            if Global.SwitchVelocity[0] == 8 then
                if v.Hww2 ~= 35 then v.Hww2 = math.random(30,40) end
            end
            if Global.SwitchVelocity[0] == 7 then
                if v.Hww2 ~= 51 then v.Hww2 = math.random(45,61) end
            end
            if Global.SwitchVelocity[0] == 6 then
                if v.Hww2 ~= 67 then v.Hww2 = math.random(66,76) end
            end
            if Global.SwitchVelocity[0] == 5 then
                if v.Hww2 ~= 83 then v.Hww2 = math.random(82,93) end
            end
            if Global.SwitchVelocity[0] == 4 then
                if v.Hww2 ~= 99 then v.Hww2 = math.random(97,110) end
            end
            if Global.SwitchVelocity[0] == 3 then
                if v.Hww2 ~= 115 then v.Hww2 = math.random(113,125) end
            end
            if Global.SwitchVelocity[0] == 2 then
                if v.Hww2 ~= 131 then v.Hww2 = math.random(128,135) end
            end
            if Global.SwitchVelocity[0] == 1 then
                if v.Hww2 ~= 147 then v.Hww2 = math.random(136,148) end
            end
            if Global.SwitchVelocity[0] == 0 then
                if v.Hww2 ~= 147 then v.Hww2 = math.random(145,148) end
            end
            if v.Hww2 > 147 then
                v.Hww2 = 147
            end
            get.doColor(255, 193, 153, 12, 255)
            Render:DrawBoxBorder(X, Y+5, Hww, 10, 0xFF000000, 0x3Fb34700)
            if v.colorsIndicator[12] ~= nil then
                Render:DrawBox(X+1, Y+6, v.Hww2, 8, v.colorsIndicator[12])
            end
            get.doColor(220, 117, 49, 13, 255)
            if v.colorsIndicator[13] ~= nil then 
                Render:DrawText(("Slide"),X+56,Y,v.colorsIndicator[13])
            end
        end
    --SlideSpeed
        if Indicator.SlideSpeed.v and slide == 1 and Movement.Slide.Enable.v and Movement.Slide.SpeedEnable.v and Panic.EveryThingExceptVisuals.v == false then
            if Indicator.Slide.v and slide == 1 and Movement.Slide.Enable.v then
                Y = Y + 9
            else
                Y = Y + 18
            end
            GSSpeedometer = ImFloat(1)
            if Global.SpeedSlide ~= 0 and Global.Switch < Movement.Slide.SpeedDuration.v/0.2 and Global.Switch > 0 and Global.Switch < 50 then
                if Movement.Slide.Speed.v then
                    GSSpeedometer = (Movement.Slide.Speed.v - 1) * 36.5
                end
                if GSSpeedometer > 146 then
                    GSSpeedometer = 147
                end
            else
                GSSpeedometer = 0
            end
            Render:DrawBoxBorder(X, Y+5, Hww, 10, 0xFF000000, 0x7F3c5232)
            get.doColor(95, 141, 75, 14, 255)
            if v.colorsIndicator[14] ~= nil then 
                Render:DrawBox(X+1, Y+6, GSSpeedometer, 8, v.colorsIndicator[14])
            end
            get.doColor(115, 236, 62, 15, 255)
            if v.colorsIndicator[15] ~= nil then 
                Render:DrawText(("Speed"),X+53,Y+1,v.colorsIndicator[15])
            end
        end
    --FakeLagPeek
        if Indicator.FakeLagPeek.v and v.shooting == 0 and Global.DesyncTimer > 0 and Panic.EveryThingExceptVisuals.v == false then
            Y = Y + 18
            Render:DrawBoxBorder(X, Y+5, Hww, 10, 0xFF000000, 0x3F800033)
            
            Hww7 = 149 - (Global.DesyncDelay) * 3.35
            --Hww7 = (147 - (147 / Movement.FakeLagPeek.Delay.v)) - Global.DesyncDelay
            if Hww7 > 146 then
                Hww7 = 147
            end
            get.doColor(255, 0, 102, 16, 255)
            if v.colorsIndicator[16] ~= nil then
                Render:DrawBox(X+1, Y+6, Hww7, 8, v.colorsIndicator[16])
            end
            get.doColor(214, 42, 110, 17, 255)
            if v.colorsIndicator[17] ~= nil then 
                Render:DrawText(("FakeLag"),X+45,Y,v.colorsIndicator[17])
            end
        end   
    --DamageMultiplier
        if Indicator.DamageMultiplier.v and KeyToggle.DDamage.v == 1 then
            Y = Y + 18
            Render:DrawBoxBorder(X, Y+5, Hww, 10, 0xFF000000, 0x3F15354F)
            local MultiplierPerWeap
            local weap = Players:getPlayerWeapon(Players:getLocalID())
            if weaponInfo[weap].slot == 0 or weaponInfo[weap].slot == 1 then
                MultiplierPerWeap = DamageMultiplier.Melees.Multiplier.v 
            elseif weaponInfo[weap].slot == 2 then
                MultiplierPerWeap = DamageMultiplier.Pistols.Multiplier.v 
            elseif weaponInfo[weap].slot == 3 then
                MultiplierPerWeap = DamageMultiplier.Shotguns.Multiplier.v 
            elseif weaponInfo[weap].slot == 4 then
                MultiplierPerWeap = DamageMultiplier.Smgs.Multiplier.v 
            elseif weaponInfo[weap].slot == 5 then
                MultiplierPerWeap = DamageMultiplier.Rifles.Multiplier.v 
            elseif weaponInfo[weap].slot == 6 then
                MultiplierPerWeap = DamageMultiplier.Snipers.Multiplier.v 
            else 
                MultiplierPerWeap = DamageMultiplier.Others.Multiplier.v 
            end
            Hww7 = (MultiplierPerWeap) * 10.6
            if Hww7 > 148 then
                Hww7 = 148
            end
            get.doColor(0, 143, 255, 18, 255)
            if v.colorsIndicator[18] ~= nil then
                Render:DrawBox(X+1, Y+6, Hww7, 8, v.colorsIndicator[18])
            end
            get.doColor(177, 199, 216, 19, 255)
            if v.colorsIndicator[19] ~= nil then 
                Render:DrawText(("Multiplier"),X+40,Y,v.colorsIndicator[19])
            end
        end 
    --BikeSpam
        if Indicator.Bike.v and Players:isDriver(Players:getLocalID()) and Vehicle.Bike.Enable.v then
            if vehicleInfo[vModel] == nil then
                get.vehicleInfoFix()
            else
                if vehicleInfo[vModel].type == VehicleType.Bike then
                    if Vehicle.Bicycle.OnKey.v and Utils:IsKeyDown(Vehicle.Bicycle.Key.v) and not v.Chat and not v.Dialog or not Vehicle.Bicycle.OnKey.v then
                        Y = Y + 18
                        Render:DrawBoxBorder(X, Y+5, Hww, 10, 0xFF000000, 0x3F416A3B)
                        Hww7 = 148 - (Vehicle.Bike.Delay.v - 1) * 7.4
                        if Hww7 > 148 then
                            Hww7 = 148
                        end
                        get.doColor(35, 255, 0, 20, 255)
                        if v.colorsIndicator[20] ~= nil then
                            Render:DrawBox(X+1, Y+6, Hww7, 8, v.colorsIndicator[20])
                        end
                        get.doColor(251, 255, 0, 21, 255)
                        if v.colorsIndicator[21] ~= nil then 
                            Render:DrawText(("Bike"),X+55,Y,v.colorsIndicator[21])
                        end
                    end
                end
            end
        end 
    --Bicycle
        if Indicator.Bicycle.v and Players:isDriver(Players:getLocalID()) and Vehicle.Bicycle.Enable.v then
            if vehicleInfo[vModel] == nil then
                get.vehicleInfoFix()
            else
                if vehicleInfo[vModel].type == VehicleType.Bicycle then
                    if Vehicle.Bicycle.OnKey.v and Utils:IsKeyDown(Vehicle.Bicycle.Key.v) and not v.Chat and not v.Dialog or not Vehicle.Bicycle.OnKey.v then
                        Y = Y + 18
                        Render:DrawBoxBorder(X, Y+5, Hww, 10, 0xFF000000, 0x3F416A3B)
                        Hww7 = 148 - (Vehicle.Bicycle.Delay.v - 1) * 7.4
                        if Hww7 > 148 then
                            Hww7 = 148
                        end
                        get.doColor(35, 255, 0, 20, 255)
                        if v.colorsIndicator[20] ~= nil then
                            Render:DrawBox(X+1, Y+6, Hww7, 8, v.colorsIndicator[20])
                        end
                        get.doColor(251, 255, 0, 21, 255)
                        if v.colorsIndicator[21] ~= nil then 
                            Render:DrawText(("Bicycle"),X+50,Y,v.colorsIndicator[21])
                        end
                    end
                end
            end
        end 
    --AntiStun
        if Indicator.AntiStun.v and Panic.EveryThingExceptVisuals.v == false then
            if Movement.AntiStun.Enable.v then
                Y = Y + 20
                if v.SniperProtEnable == 1 then
                    Hww4 = 0
                else
                    Hww4 = v.StunCount * 1.48
                end
                Render:DrawBoxBorder(X, Y+5, Hww, 10, 0xFF000000, 0x3F5a4d2f)
                get.doColor(162, 141, 91, 22, 255)
                if v.colorsIndicator[22] ~= nil then
                    Render:DrawBox(X+1, Y+6, Hww4, 8, v.colorsIndicator[22])
                end
                get.doColor(204, 159, 52, 23, 255)
                if v.colorsIndicator[23] ~= nil then 
                    Render:DrawText(("Stun"),X+58,Y,v.colorsIndicator[23])
                end
            end
        end
    --Godmode
        if Indicator.Godmode.v and Panic.EveryThingExceptVisuals.v == false then
            if KeyToggle.GodmodePlayer.v == 1 then
                Y = Y + 20
                X = X + 15
                Render:DrawText(("Godmode"),X,Y,0xFF00FF00)
                if Godmode.Player.Collision.v then
                    Render:DrawText(("I"),X+75,Y,0xFF00FF00)
                else
                    Render:DrawText(("0"),X+75,Y,0xFFFF0000)
                end
                if Godmode.Player.Melee.v then
                    Render:DrawText(("I"),X+85,Y,0xFF00FF00)
                else
                    Render:DrawText(("0"),X+85,Y,0xFFFF0000)
                end
                if Godmode.Player.Bullet.v then
                    Render:DrawText(("I"),X+95,Y,0xFF00FF00)
                else
                    Render:DrawText(("0"),X+95,Y,0xFFFF0000)
                end
                if Godmode.Player.Fire.v then
                    Render:DrawText(("I"),X+105,Y,0xFF00FF00)
                else
                    Render:DrawText(("0"),X+105,Y,0xFFFF0000)
                end
                if Godmode.Player.Explosion.v then
                    Render:DrawText(("I"),X+115,Y,0xFF00FF00)
                else
                    Render:DrawText(("0"),X+115,Y,0xFFFF0000)
                end
            end
            if KeyToggle.GodmodeVehicle.v == 1 then
                if KeyToggle.GodmodePlayer.v == 0 then
                    X = X + 15
                end
                Y = Y + 15
                Render:DrawText(("Godcar"),X,Y,0xFF00FF00)
                if Godmode.Vehicle.Collision.v then
                    Render:DrawText(("I"),X+75,Y,0xFF00FF00)
                else
                    Render:DrawText(("0"),X+75,Y,0xFFFF0000)
                end
                if Godmode.Vehicle.Melee.v then
                    Render:DrawText(("I"),X+85,Y,0xFF00FF00)
                else
                    Render:DrawText(("0"),X+85,Y,0xFFFF0000)
                end
                if Godmode.Vehicle.Bullet.v then
                    Render:DrawText(("I"),X+95,Y,0xFF00FF00)
                else
                    Render:DrawText(("0"),X+95,Y,0xFFFF0000)
                end
                if Godmode.Vehicle.Fire.v then
                    Render:DrawText(("I"),X+105,Y,0xFF00FF00)
                else
                    Render:DrawText(("0"),X+105,Y,0xFFFF0000)
                end
                if Godmode.Vehicle.Explosion.v then
                    Render:DrawText(("I"),X+115,Y,0xFF00FF00)
                else
                    Render:DrawText(("0"),X+115,Y,0xFFFF0000)
                end
            end
        end  
        end

end

function VisualsTab.Menu()
    if SHAkMenu.Menu.v == 5 then
        SHAkMenu.resetMenuTimer(SHAkMenu.Menu.v)
        --Indicators
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-4,SHAkMenu.menutransitor-4) 
            if Menu:Button("| Indicators |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                IndicatorsList = not IndicatorsList
                SHAkMenu.menuOpened = 0
            end
            if IndicatorsList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Indicators", Indicator.Enable)
                if Indicator.Enable.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Silent", Indicator.Silent)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Damager", Indicator.Damager)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Macro Run", Indicator.MacroRun)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Sprinthook", Indicator.Sprinthook)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Slide-Master", Indicator.Slide)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Slide-Master Speed", Indicator.SlideSpeed)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show FakeLag Peek", Indicator.FakeLagPeek)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Damage Multiplier", Indicator.DamageMultiplier)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Bike Spam", Indicator.Bike)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Bicycle Spam", Indicator.Bicycle)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Smart AntiStun", Indicator.AntiStun)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Godmode", Indicator.Godmode)
                    Menu:Text("") Menu:SameLine(0, 0) Menu:Text("    X") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10)
                    if Menu:SliderFloat("         ", Indicator.X, 0, Utils:getResolutionX()) then
                        Global.Menu = 1
                    end
                    Menu:Text("") Menu:SameLine(0, 0) Menu:Text("    Y") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) 
                    if Menu:SliderFloat("       ", Indicator.Y, 0, Utils:getResolutionY()) then
                        Global.Menu = 1
                    end
                end
            end
        --WallHack
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-15,SHAkMenu.menutransitor-15) 
            if Menu:Button("| Lag WallHack |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                WallHackList = not WallHackList
                SHAkMenu.menuOpened = 0
            end
            if WallHackList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed)Menu:CheckBox("Lagshot Wallhack", PingPoint.Enable)
            end
        --Stream
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+3,SHAkMenu.menutransitor+3) 
            if Menu:Button("| Stream |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                StreamList = not StreamList
                SHAkMenu.menuOpened = 0
            end
            if StreamList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed)Menu:CheckBox("Stream Wallhack", StreamWall.Enable)
                if StreamWall.Enable.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show HP/Armor Bar", StreamWall.HP)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("AFK Players", StreamWall.AFK)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:SliderInt("Max Players", StreamWall.MaxPlayers, 0, 1004)
                    Menu:Text("    X") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("                    ", StreamWall.X, 0, Utils:getResolutionX())
                    Menu:Text("    Y") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("                              ", StreamWall.Y, 0, Utils:getResolutionY())
                end
            end
        --Radar
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+6,SHAkMenu.menutransitor+7) 
            if Menu:Button("| Radar |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                RadarList = not RadarList
                SHAkMenu.menuOpened = 0
            end
            if RadarList == true then
                if m_offsets.m_samp_info[v.SampVer] ~= 0 then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox("Show Player Markers", RadarHack.PlayerMarkers) then
                        set.RadarHacks()
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed)Menu:CheckBox("3D Radar", RadarHack.Enable)
                if RadarHack.Enable.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Only Who Damaged you", RadarHack.AfterDamage)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Only Out Of View", RadarHack.Onlyoutofview)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Line", RadarHack.ShowLine)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show Name", RadarHack.ShowName)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Show HP/Armor Bar ", RadarHack.ShowHP)
                    if RadarHack.ShowHP.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10)Menu:SliderInt("Bar Size", RadarHack.HPSize, 10, 52)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10)Menu:SliderInt("Bar Height", RadarHack.HPHeight, 3, 10)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Link To Bone", RadarHack.LinkedToChar)
                    if RadarHack.LinkedToChar.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10)Menu:SliderInt("Bone ID", RadarHack.Bone, 1, 54)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:SliderInt("Max Players ", RadarHack.MaxPlayers, 0, 1004)
                    Menu:Text("    Radar Distance")
                    Menu:Separator()
                    Menu:Text("    Low Distance") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+50, SHAkMenu.menutransitorstaticreversed+50) Menu:SliderInt("                          ", RadarHack.lowDistance, 0, 350)
                    Menu:Text("    High Distance") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+50, SHAkMenu.menutransitorstaticreversed+50) Menu:SliderInt("                       ", RadarHack.maxDistance, 1, 350)
                    Menu:Separator()
                    Menu:Text("    Radar Size") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+40, SHAkMenu.menutransitorstaticreversed+40) Menu:SliderFloat("                            ", RadarHack.maxLength, 0, 30)
                    Menu:Text("    X") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("                ", RadarHack.X, 0-Utils:getResolutionX()*0.5, Utils:getResolutionX()*0.5)
                    Menu:Text("    Y") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("                 ", RadarHack.Y, 0-Utils:getResolutionY()*0.5, Utils:getResolutionY()*0.5)
                end
            end
            Menu:Separator()
    else
        FiltersList, IndicatorsList, WallHackList, StreamList, RadarList = false
    end
end
return VisualsTab