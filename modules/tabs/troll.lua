local TrollTab = {}
function TrollTab.Mainloop()
--VehicleSlapper
    if Troll.Slapper.Enable.v and (Utils:IsKeyDown(Troll.Slapper.Key.v) and Troll.Slapper.OnKey.v and not v.Chat and not v.Dialog or not Troll.Slapper.OnKey.v) then
        if not Panic.Visuals.v then
            get.NearestVehiclesFromScreen()
            local nearestVehicle = maths.getLowerIn(vehicles.crasher)
            if nearestVehicle and nearestVehicle ~= 65535 then
                get.NearestPlayersFromScreen()
                for i, _ in pairs(players.id) do
                    if not Players:isDriver(Players:getLocalID()) and not Players:Driving(Players:getLocalID()) and Players:isPlayerStreamed(i) and not Players:isPlayerInFilter(i) and not Players:isPlayerAFK(i) then
                        local names = Players:getPlayerName(i)
                        local center = string.len(names) * 4
                        local car = Cars:getCarPosition(nearestVehicle)
                        local   distance = Utils:Get3Ddist(car , Players:getPlayerPosition(Players:getLocalID()))
                        if Utils:isOnScreen(i) and  distance < 5 then
                            local nameToScreen = CVector()
                            local teleportBone = Players:getBonePosition(i, 2)
                            Utils:GameToScreen(teleportBone, nameToScreen)
                            Utils:GameToScreen(teleportBone, vEnScreen)
                            nameToScreen.fX = nameToScreen.fX - center
                            local nearestFromCrosshair = maths.getLowerIn(players.fov)
                            if nearestFromCrosshair and i == nearestFromCrosshair then
                                local carToScreen = CVector()
                                Utils:GameToScreen(car, carToScreen)
                                Render:DrawLine(carToScreen.fX, carToScreen.fY, vEnScreen.fX, vEnScreen.fY, 0xFF000000)
                                Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 10, true, 0x7F0040FF)
                                Render:DrawText( names.."%s ID: "..i, nameToScreen.fX - 25, nameToScreen.fY + 25, Players:getPlayerColor(i))
                                local vEnDriver = Players:isDriver(i)
                                if vEnDriver then
                                    Render:DrawText("DRIVING", nameToScreen.fX - 25, nameToScreen.fY + 45, 0xFF0040FF)
                                end
                                if Utils:IsKeyChecked(2, 0) and Global.KeyDelay == 0 then
                                    local pos = get.PlayerLag(i, -1)
                                    local message = ImBuffer("Slapper - ".. Players:getPlayerName(i) .."(".. i ..")", 155)
                                    set.TextDraw(message, 0xFF8700FF, 2045, 15, 300)
                                    pos.fZ = pos.fZ - maths.randomFloat(1.3, 1.8)
                                    if Troll.Slapper.Type.v == 0 then
                                        send.UnoccupiedSync2(i, nearestVehicle)
                                    else
                                        send.UnoccupiedSync(nearestVehicle, pos.fX, pos.fY, pos.fZ, 0, 0, 10)
                                    end                                                                                        
                                    Global.KeyDelay = 1
                                else
                                    Global.KeyDelay = 0
                                end
                            else
                                Render:DrawText( names.."%s ID: "..i ,nameToScreen.fX - 10, nameToScreen.fY + 10, Players:getPlayerColor(i))
                                Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 5, true, 0x6Ff040FF)
                            end
                        end
                    end
                end
            end
        end
    end
--RVanka
    if KeyToggle.RVanka.v == 1 or Global.rVankanEWVAR > 0 then
        if Global.rVankanEWVAR == 0 then
            if(RVankaTimer1.update(deltaTime)) or Global.rVankanEWVAR > 0 then
                get.NearestPlayersFromScreen()
                for i, _ in pairs(players.id) do
                    if Players:isPlayerStreamed(i) then
                        if Players:isPlayerInFilter(i) == false and Players:isPlayerAFK(i) == false then
                            local vEnPos = Players:getPlayerPosition(i)
                            local distance = Utils:Get3Ddist(Players:getPlayerPosition(Players:getLocalID()), vEnPos)
                            if  distance < Troll.RVanka.Distance.v then
                                v.PlayerTimer[i] = (v.PlayerTimer[i] or 0) + 1
                                local vEnOFData = Players:getOnFootData(i)
                                if vEnOFData.sSurfingVehicleID == 65535 or Players:isDriver(i) then
                                    if v.PlayerTimer[i] > Troll.RVanka.Timer.v then
                                        for j = 0, 1003 do
                                            if j ~= i then
                                                v.PlayerTimer[j] = 0
                                            else
                                                local a = math.random(1,6)
                                                local pos = CVector()
                                                local bsData = BitStream()
                                                pos = get.PlayerLag(i, -1)
                                                local vEnPos = Players:getPlayerPosition(i)
                                                local randX = maths.randomFloat(-2, 2)
                                                local randY = maths.randomFloat(-2, 2)
                                                local vMyPos = CVector(pos.fX+randX, pos.fY+randY, pos.fZ)
                                                local vehicle = Players:getVehicleID(Players:getLocalID())
                                                local vModel = Cars:getCarModel(vehicle)
                                                local rVankatype
                                                local qw,qx,qy, qz ,aa = 0
                                                qw, qx, qy, qz = set.PlayerFacing(vMyPos, vEnPos)
                                                local quaternions = {}
                                                quaternions.w = qw
                                                quaternions.x = 0
                                                quaternions.y = 0
                                                quaternions.z = qz
                                                local velocity = {x = 0.02, y = 0.02, z = -0.0000001}
                                                local angle = maths.quaternionToAngle(quaternions)
                                                aa = maths.increaseVelocityByAngle(velocity, angle, Troll.RVanka.Speed.v)
                                                if vModel == 417 or vModel == 425 or vModel == 447 or vModel == 487 or vModel == 488 or vModel == 501 or vModel == 548 or vModel == 563 then
                                                vMyPos = CVector(pos.fX+1.5, pos.fY+1.5, pos.fZ+maths.randomInt(2,4))
                                                aa.x = 0
                                                aa.y = 0
                                                pos.fZ = pos.fZ - 3
                                                rVankatype = "Heli"
                                            elseif vehicle ~= 65535 then
                                                rVankatype = "InCar"
                                            else
                                                rVankatype = "OnFoot"
                                            end                                          
                                            vMyPos = CVector((pos.fX-aa.x)+randX, (pos.fY-aa.y)+randY, pos.fZ)
                                            local message = ImBuffer("RVanka ".. rVankatype .." - ".. Players:getPlayerName(i) .."(".. i ..")",155)
                                            if message then
                                                set.TextDraw(message, 0xFFF300FF, 2045, 15, 305)
                                            end
                                            if Players:isDriver(Players:getLocalID()) then
                                                qx = 0
                                                qy = 0
                                                bsWrap:Write8(bsData, 200) 
                                                bsWrap:Write16(bsData, vMy.ICData.VehicleID)
                                                bsWrap:Write16(bsData, 8)
                                                bsWrap:Write16(bsData, 8)
                                                bsWrap:Write16(bsData, 8)
                                                bsWrap:WriteFloat(bsData, qw)  
                                                bsWrap:WriteFloat(bsData, qx)   
                                                bsWrap:WriteFloat(bsData, qy) 
                                                bsWrap:WriteFloat(bsData, qz)  
                                                bsWrap:WriteFloat(bsData, vMyPos.fX)
                                                bsWrap:WriteFloat(bsData, vMyPos.fY)
                                                bsWrap:WriteFloat(bsData, vMyPos.fZ)
                                                bsWrap:WriteFloat(bsData, aa.x)
                                                bsWrap:WriteFloat(bsData, aa.y)
                                                bsWrap:WriteFloat(bsData, aa.z)
                                                bsWrap:WriteFloat(bsData, vMy.ICData.HealthCar)
                                                bsWrap:Write8(bsData, Players:getPlayerHP(Players:getLocalID()))
                                                bsWrap:Write8(bsData, Players:getPlayerArmour(Players:getLocalID()))
                                                bsWrap:Write8(bsData, 0)
                                                bsWrap:Write8(bsData, 0)
                                                bsWrap:Write8(bsData, 0)
                                                bsWrap:Write8(bsData, 0)
                                                bsWrap:Write8(bsData, 0)
                                                bsWrap:WriteFloat(bsData, 0)
                                                SendPacket(200, bsData)
                                                bsWrap:Reset(bsData) 
                                            else
                                                local vEnData = Players:getOnFootData(i)
                                                if Players:isDriver(i) or Players:Driving(i) then
                                                    vEnData = Players:getInCarData(i)
                                                end
                                                local velocityX = vEnData.Speed.fX
                                                local velocityY = vEnData.Speed.fY
                                                local velocityZ = Troll.RVanka.Speed.v
                                                local ofData = get.onFootData()
                                                OnFootData.lrkey = 8
                                                OnFootData.udkey = 8
                                                OnFootData.keys = 8
                                                OnFootData.X = pos.fX
                                                OnFootData.Y = pos.fY
                                                OnFootData.Z = pos.fZ
                                                OnFootData.quat_w = 0
                                                OnFootData.quat_x = -0.7
                                                OnFootData.quat_y = 0
                                                OnFootData.quat_z = 0
                                                OnFootData.velocity_x = velocityX
                                                OnFootData.velocity_y = velocityY
                                                OnFootData.velocity_z = velocityZ
                                                send.onFootSync(OnFootData)
                                            end
                                            v.PlayerTimer[i] = -1
                                            Global.rVankanEWVAR = 1
                                        end
                                    end
                                end
                            end
                        else
                            v.PlayerTimer[i] = -1
                        end
                    else
                        v.PlayerTimer[i] = -1
                    end
                end
            end
        end
    else
        Global.rVankanEWVAR = Global.rVankanEWVAR + 1
        if Global.rVankanEWVAR > Troll.RVanka.Timer.v*2 then
            Global.rVankanEWVAR = 0
        end
    end
    end
--VehicleTroll
    if Troll.VehicleTroll.v and Troll.VehicleTrollType.v ~= 0 then
        for i = 1, SAMP_MAX_VEHICLES do
            if Cars:isCarStreamed(i) then
                local vCarPos = Cars:getCarPosition(i)
                local   distance = Utils:Get3Ddist(Players:getPlayerPosition(Players:getLocalID()), vCarPos)
                if Cars:getHavePassenger(i,0) == false then
                        if v.fuckerpertimer[i] == nil or v.fuckerpertimer[i] == NULL then
                            v.fuckerpertimer[i] = 0
                        end
                        v.fuckerpertimer[i] = v.fuckerpertimer[i] + 1
                        if v.fuckerpertimer[i] > 3 then
                            for j = 1, SAMP_MAX_VEHICLES do
                                if j ~= i then
                                    v.fuckerpertimer[j] = 0
                                end
                            end
                            send.vehiclefucker(i, Player)
                            fuckerTimer = 0;
                            v.fuckerpertimer[i] = 0
                        end
                else
                    if v.fuckerpertimer[i] ~= 0 then v.fuckerpertimer[i] = 0 end
                end
            else
                if v.fuckerpertimer[i] ~= 0 then v.fuckerpertimer[i] = 0 end
            end
        end
    end
--Throw Driver
    if Troll.RainCars.v then
        local bsData = BitStream()
        local stop = 0
        local Player = {}
        local Drivers = {}
        local PlayerID = -1 
        
        if Utils:IsKeyDown(2) and not v.Chat and not v.Dialog then
            get.NearestPlayersFromScreen()
            for i, _ in pairs(players.id) do
                if Players:isPlayerStreamed(i) then
                    local vEnDriver = Players:isDriver(i)
                    if vEnDriver then
                        local vEnPos = Players:getPlayerPosition(i)
                        Drivers[i] = i
                        Utils:GameToScreen(vEnPos, vEnScreen)
                        Player[i] = Utils:Get2Ddist(vecCrosshair,vEnScreen)
                        PlayerID = maths.getLowerIn(Player)
                    else
                        Player[i] = nil
                        Drivers[i] = nil
                    end
                else
                    Player[i] = nil
                    Drivers[i] = nil
                end
            end
            if Player[PlayerID] ~= nil and PlayerID ~= -1 then
                local vEnPos = Players:getPlayerPosition(PlayerID)
                local Target = vEnPos
                Utils:GameToScreen(Target, vEnScreen)
                if vEnScreen.fZ > 1 then
                    Render:DrawLine(vecCrosshair.fX,vecCrosshair.fY,vEnScreen.fX,vEnScreen.fY,0xFF9966f0)
                    if Utils:IsKeyChecked(66, 300) and stop == 0 then
                        local veh = Players:getVehicleID(PlayerID)
                        send.Vehicle(veh)
                        stop = 1
                    else
                        if stop ~= 0 then
                            stop = 0
                        end
                    end
                end
            end
        end
    end   
--Anti Troller / Troller
    if v.DrivingPlayerID ~= -1 then
        if Players:isPlayerStreamed(v.DrivingPlayerID) == false then
            v.DrivingPlayerID = -1
        end
    end
    if v.Troller ~= -1 then
        if Players:isPlayerStreamed(v.Troller) == false then
            v.Troller = -1
        end
    end
end
function TrollTab.Menu()
    if SHAkMenu.Menu.v == 6 then
        SHAkMenu.resetMenuTimer(SHAkMenu.Menu.v)
        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
        if Menu:Button("| Troll |") then
            SHAkMenu.resetMenuTimerStaticReversed()
            TrollList = not TrollList
            SHAkMenu.menuOpened = 0
        end
        if TrollList == true then
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Throw Driver", Troll.RainCars)
            Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
            if Menu:Button("(?)##123") then
                ThrowDrivermenu = not ThrowDrivermenu
            end
            if ThrowDrivermenu == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                Menu:Text("Throw Vehicle with Driver to the sky (Key B)")
                Menu:Separator()
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Fake Pos", Troll.FakePos.Enable)
            Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
            if Menu:Button("(?)##1") then
                FakePoSHAkMenu = not FakePoSHAkMenu
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("On Foot", Troll.FakePos.OnFoot)
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("In Car", Troll.FakePos.InCar)
            if Troll.FakePos.Enable.v and Troll.FakePos.OnFoot.v or Troll.FakePos.Enable.v and Troll.FakePos.InCar.v then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox("Randomize Pos", Troll.FakePos.RandomPos)
                if Troll.FakePos.RandomPos.v == false then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("X##999", Troll.FakePos.X, -10.0, 10.0) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("Y##999", Troll.FakePos.Y, -10.0, 10.0)
                end
            end 
            if FakePoSHAkMenu == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                Menu:Text("Send InCar/OnFoot position + the Fake Pos Slider")
                Menu:Separator()
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Quaternion Fucker",Troll.FuckSync)
            Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
            if Menu:Button("(?)##2") then
                FuckSyncmenu = not FuckSyncmenu
            end
            if FuckSyncmenu == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                Menu:Text("Send InCar/OnFoot data about quaternions wrong")
                Menu:Separator()
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Parachute Walk",Troll.TrollWalk)
            Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
            if Menu:Button("(?)##3") then
                TrollWalkmenu = not TrollWalkmenu
            end
            if TrollWalkmenu == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                Menu:Text("Send OnFoot stretched parachute animation")
                Menu:Separator()
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Vehicle Slapper",Troll.Slapper.Enable)
            Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
            if Menu:Button("(?)##4") then
                VehicleSlappermenu = not VehicleSlappermenu
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##1", Troll.Slapper.OnKey)
            if Troll.Slapper.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("  ", Troll.Slapper.Key, 200, 20) end
            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type##545",Troll.Slapper.Type,"Bayblade\0Stretch\0\0",9)
            if VehicleSlappermenu == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                Menu:Text("Send Unoccupied Sync to slap player")
                Menu:Separator()
            end
            if VehicleSlapperTrollmenu == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                Menu:Text("Send Unoccupied Sync to make car disappear")
                Menu:Separator()
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Fuck Unoccupied",Troll.VehicleTroll)
            Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
            if Menu:Button("(?)##5") then
                VehicleTrollmenu = not VehicleTrollmenu
            end
            if Troll.VehicleTroll.v then
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type",Troll.VehicleTrollType,"OnSend\0Normal\0Hardcore\0\0",6)
            end
            if VehicleTrollmenu == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                Menu:Text("Send Unoccupied Sync to make cars go crazy")
                Menu:Separator()
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("RVanka",Troll.RVanka.Enable)
            Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
            if Menu:Button("(?)##6") then
                RVankamenu = not RVankamenu
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##2", Troll.RVanka.OnKey)
            if Troll.RVanka.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("    ", Troll.RVanka.Key, 200, 20) end
            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
            if Menu:Button("(?)") then
                reindirectbutton = not reindirectbutton
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("Speed##9555",Troll.RVanka.Speed, 0.0, 10)
            Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
            if Menu:Button("(?)##565") then
                RVankaSpeed = not RVankaSpeed
            end
            if RVankaSpeed == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                Menu:Text("Speed will only work OnFoot and InCar, doesn't affect Heli")
                Menu:Separator()
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Distance##2323", Troll.RVanka.Distance, 10, 300) 
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) if Menu:SliderInt("Delay##2323", Troll.RVanka.Timer, 1, 50) then
                get.ScriptTimers()
            end
            
            if RVankamenu == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                Menu:Text("Send InCar/OnFoot data to go to players and Slap them")
            end
            --Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Detonator Crasher",Troll.Crasher.Detonator)
        end
        Menu:Separator()
    else
        ThrowDrivermenu, FakePoSHAkMenu, FuckSyncmenu, TrollWalkmenu, VehicleSlappermenu, RVankamenu, VehicleTrollmenu, TrollList = false
    end
end
return TrollTab