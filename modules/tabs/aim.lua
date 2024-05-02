local AimTab = {}
function AimTab.Mainloop()
--Silent
    if KeyToggle.Silent.v == 1 then
        --Settings
            if SilentStuff.ShotsCounter >= SilentStuff.Shots then
                SilentStuff.FirstShots = 0
            else
                if SilentStuff.FirstShots ~= 1 then
                    SilentStuff.FirstShots = 1
                end
            end
            if v.lastweapon ~= Players:getPlayerWeapon(Players:getLocalID()) then
                get.SilentConfig(Players:getPlayerWeapon(Players:getLocalID()), Cars:getCarModel(Players:getVehicleID(Players:getLocalID())))
                SilentStuff.ShotsCounter = 0
                v.lastweapon = Players:getPlayerWeapon(Players:getLocalID())
            elseif Players:getVehicleID(Players:getLocalID()) == 432 and v.lastweapon ~= Players:getVehicleID(Players:getLocalID()) then
                get.SilentConfig(Players:getPlayerWeapon(Players:getLocalID()), Cars:getCarModel(Players:getVehicleID(Players:getLocalID())))
                v.lastweapon = Players:getVehicleID(Players:getLocalID())
            end
    end
    if KeyToggle.Silent.v == 0 then
        if SilentStuff.ShotsCounter ~= 0 then
            SilentStuff.ShotsCounter = 0
        end
    end
--Triggerbot
    if KeyToggle.Triggerbot.v == 1 then
        get.NearestPlayersFromScreen()
        local vMyPos = Players:getPlayerPosition(Players:getLocalID())
        for i, _ in pairs(players.id) do
            if Players:isPlayerStreamed(i) then
                if Players:isPlayerInFilter(i) == false and Players:isSkinInFilter(i) == false then
                    local vEnPos = Players:getPlayerPosition(i)
                    if get.isPlayerAlive(i) and Utils:IsLineOfSightClear(vMyPos, vEnPos, true, false, false, false, false, false, false) then
                        local Distance = Utils:Get3Ddist(vMyPos, vEnPos)
                        local PlayerDist = weaponInfo[Players:getPlayerWeapon(Players:getLocalID())].distance
                        if Distance < PlayerDist then
                            if Triggerbot.CList.v and Players:getPlayerColor(i) ~= Players:getPlayerColor(Players:getLocalID()) or Triggerbot.CList.v == false then
                                local getbones = {}
                                getbones[8] = Players:getBonePosition(i,8)
                                getbones[3] = Players:getBonePosition(i,3)
                                getbones[2] = Players:getBonePosition(i,2)
                                getbones[33] = Players:getBonePosition(i,33)
                                getbones[23] = Players:getBonePosition(i,23)
                                getbones[42] = Players:getBonePosition(i,42)
                                getbones[52] = Players:getBonePosition(i,52)
                                for j = 0, 52 do
                                    if getbones[j] ~= nil then 
                                        Utils:GameToScreen(getbones[j], vEnScreen)
                                        local fov = Utils:Get2Ddist(SilentCrosshair, vEnScreen)
                                        if fov < Triggerbot.Offset.v then
                                            if triggertimer == nil then
                                                triggertimer = Timers(Triggerbot.Delay.v)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if triggertimer ~= nil then
            if triggertimer.update(deltaTime) then
                Utils:emulateGTAKey(4, 255)
                triggertimer = nil
            end
        end
    elseif triggertimer ~= nil then
        triggertimer = nil 
    end
--AimAssist
    if KeyToggle.AimAssist.v == 1 then
            if Utils:IsKeyDown(2) and not v.Chat and not v.Dialog then
                Global.AimAssistAiming = 1
            else
                Global.AimAssistAiming = 0
            end
        if Global.AimAssist ~= nil then
            if Players:isPlayerStreamed(Global.AimAssist) == false then
                Global.AimAssist = nil
            end
            Global.AimAssistDelay = Global.AimAssistDelay + 1
            if Global.AimAssistDelay > 500 or get.isPlayerAlive(Global.AimAssist) == false then
                Global.AimAssist = nil
                Global.AimAssistDelay = 0
            end
        end
        local vMyPos = Players:getPlayerPosition(Players:getLocalID())
        local target 
        if Global.AimAssist ~= nil and AimAssist.ForceWhoDamaged.v or Global.AimAssist2 ~= nil or Global.AimAssist3 ~= nil then
            local maxfov = AimAssist.FOVType.v
            if Global.AimAssist == nil then 
                if Global.AimAssist2 == nil then
                    target = Global.AimAssist3
                else
                    target = Global.AimAssist2  
                end
            else 
                target = Global.AimAssist 
                maxfov = 1
            end
            if target ~= nil then 
                if Players:isPlayerStreamed(target) then
                    if AimAssist.FOVType.v == 1 or AimAssist.FOVType.v == 0 and Utils:isOnScreen(target) then
                        if AimAssist.CList.v and Players:getPlayerColor(target) ~= Players:getPlayerColor(Players:getLocalID()) or AimAssist.CList.v == false then
                            local vEnPos = Players:getPlayerPosition(target)
                            Utils:GameToScreen(vEnPos, vEnScreen)
                            local vEnPostoSight = vEnPos 
                            vEnPostoSight.fZ = vEnPostoSight.fZ + 0.5
                            local vMyPosPostoSight = vMyPos 
                            vMyPosPostoSight.fZ = vMyPosPostoSight.fZ + 0.5
                            if Utils:IsLineOfSightClear(vMyPosPostoSight, vEnPostoSight, true, true, false, true, false, false, false) then
                                if AimAssist.IgnoreDeath.v and get.isPlayerAlive(i) == true or AimAssist.IgnoreDeath.v == false then
                                    if AimAssist.IgnoreAFK.v and Players:isPlayerAFK(i) == false or AimAssist.IgnoreAFK.v == false then
                                        local Distance = Utils:Get3Ddist(vMyPos , vEnPos)
                                        local WeaponDist = weaponInfo[Players:getPlayerWeapon(Players:getLocalID())].distance
                                        local fov = Utils:Get3Ddist(vecCrosshair,vEnScreen)
                                        if maxfov == 0 and fov < AimAssist.FOV.v*20 or maxfov == 1 then
                                            local distance = Utils:Get2Ddist(SilentCrosshair , vEnScreen)
                                            if distance > AimAssist.DeadZone.v*20 then
                                                if AimAssist.DrawFOV.v and not Panic.Visuals.v then
                                                    Render:DrawLine(vecCrosshair.fX,vecCrosshair.fY,vEnScreen.fX,vEnScreen.fY,Players:getPlayerColor(target))
                                                    Render:DrawCircle(vecCrosshair.fX, vecCrosshair.fY, 3, true, Players:getPlayerColor(target))
                                                end
                                                --if vMy.OFData.sCurrentAnimationID > 1157 and vMy.OFData.sCurrentAnimationID < 1165 or --vMy.OFData.sCurrentAnimationID == 1167 or
                                                --vMy.OFData.sCurrentAnimationID == 363 then
                                                    if Distance < WeaponDist then
                                                        local distance = Utils:Get2Ddist(SilentCrosshair , vEnScreen)
                                                        if Global.AimAssistAiming == 1 then
                                                            local camX = Utils:readMemory(0xB6F9CC, 4, false)
                                                            local camY = Utils:readMemory(0xB6F9D0, 4, false)
                                                            local bsTrans = BitStream()
                                                            bsWrap:Write32(bsTrans, camX)
                                                            bsWrap:Write32(bsTrans, camY)
                                                            camX = bsWrap:ReadFloat(bsTrans)
                                                            camY = bsWrap:ReadFloat(bsTrans)
                                                            local Aa = math.abs(camX - vEnPos.fX)
                                                            local Ab = math.abs(camY - vEnPos.fY)
                                                            local Ac = math.sqrt(Aa * Aa + Ab * Ab)
                                                            local alpha = math.asin(Aa / Ac)
                                                            local beta = math.acos(Aa / Ac)
                                                            if vMyPos.fX > vEnPos.fX and vMyPos.fY < vEnPos.fY then
                                                                beta = -beta -- 1st part
                                                            end
                                                            if vMyPos.fX > vEnPos.fX and vMyPos.fY > vEnPos.fY then
                                                                beta = beta -- 2nd part
                                                            end
                                                            if vMyPos.fX < vEnPos.fX and vMyPos.fY > vEnPos.fY then
                                                                beta = alpha + 1.5707 -- 3rd part
                                                            end
                                                            if vMyPos.fX < vEnPos.fX and vMyPos.fY < vEnPos.fY then
                                                                beta = -alpha - 1.5707 -- 4th part
                                                            end
                                                            Utils:writeMemory(0xB6F258, beta+0.0389, 4, false)
                                                        end
                                                    end
                                            -- end
                                            end
                                        end
                                    end
                                else
                                    Global.AimAssist = nil
                                    target = nil
                                    Global.AimAssist2 = nil
                                end
                            else
                                Global.AimAssist = nil
                                target = nil
                                Global.AimAssist2 = nil
                            end
                        end
                    end
                else
                    target = nil
                    Global.AimAssist = nil
                    Global.AimAssist2 = nil
                end
            end
        end
        if AimAssist.DrawFOV.v then
            local color = 0
            local FOV = AimAssist.FOV.v*20
            local FOV2 = AimAssist.DeadZone.v*20
            if target ~= nil then
                color = Players:getPlayerColor(target)
            end
            if AimAssist.FOVType.v == 1 then
                FOV = 1200
            end
            if not Panic.Visuals.v then
                Render:DrawCircle(vecCrosshair.fX, vecCrosshair.fY, FOV, false, color)
                Render:DrawCircle(vecCrosshair.fX, vecCrosshair.fY, FOV, true, 0x199966f0)
                Render:DrawCircle(vecCrosshair.fX, vecCrosshair.fY, FOV2, true, 0x1F9966f0)
            end
        end
        if Global.AimAssist == nil then
            local vMyCam = Utils:getCameraPosition()
            get.NearestPlayersFromScreen()
            for i, _ in pairs(players.id) do
                if Players:isPlayerStreamed(i) then
                    if Players:isPlayerInFilter(i) == false and Players:isSkinInFilter(i) == false then
                        local vEnPos = Players:getPlayerPosition(i)
                        if get.isPlayerAlive(i) and Utils:IsLineOfSightClear(vMyPos, vEnPos, true, false, false, false, false, false, false) then
                            Utils:GameToScreen(vEnPos, vEnScreen)
                            local Distance = Utils:Get3Ddist(vMyPos , vEnPos)
                            local PlayerDist = weaponInfo[Players:getPlayerWeapon(Players:getLocalID())].distance
                            local fov = Utils:Get3Ddist(vecCrosshair,vEnScreen)
                            if Distance < PlayerDist then
                                if AimAssist.CList.v and Players:getPlayerColor(i) ~= Players:getPlayerColor(Players:getLocalID()) or AimAssist.CList.v == false then
                                    if AimAssist.FOVType.v == 1 or AimAssist.FOVType.v == 0 and fov < AimAssist.FOV.v*20 then
                                        if Utils:isOnScreen(i) then
                                            Global.AimAssistTarget[i] = Utils:Get3Ddist(vecCrosshair, vEnScreen)
                                            Global.AimAssist2 = maths.getLowerIn(Global.AimAssistTarget)
                                        else
                                            if Global.AimAssist2 == nil then
                                                if AimAssist.FOVType.v == 1 then
                                                    local isvisible = get.PlayersFromCameraToTarget(vMyPos, vEnPos, vMyCam)
                                                    tableto[i] = isvisible
                                                    Global.AimAssist3 = maths.getHigherIn( tableto)
                                                end
                                            end
                                        end
                                    else
                                        Global.AimAssistTarget[i] = nil
                                    end
                                else
                                    Global.AimAssistTarget[i] = nil
                                end
                            else
                                Global.AimAssistTarget[i] = nil
                            end
                        else
                            Global.AimAssistTarget[i] = nil
                        end
                    else
                        Global.AimAssistTarget[i] = nil
                    end
                else
                    Global.AimAssistTarget[i] = nil
                end
            end
        end
    end
--Damager
    if KeyToggle.Damager.v == 1 then
        if(DMGTimer.update(deltaTime)) or v.DamagerPlayerID == -1 then
            local amount
            local hittype
            local weapon = Players:getPlayerWeapon(Players:getLocalID())
            if Damager.CurrentWeapon.v == false then
                if Damager.Weapon.v == 51 then
                    weapon = math.random(0, 38)
                else 
                    weapon = Damager.Weapon.v
                end
            end
            if Damager.ChangeDamage.v then
                amount = weapon
            else
                amount = weaponInfo[weapon].damage
            end
            if Damager.SyncBullet.Type.v == 0 then
                hittype = 1
            else
                hittype = 0
            end
            local DamagerPlayer
        --Get Damager Target
            local nearestplayer = {}
            get.NearestPlayersFromScreen()
            for i, _ in pairs(players.id) do
                if Damager.OnlyStreamed.v then
                    if Players:isPlayerStreamed(i) then
                        local vEnPos = Players:getPlayerPosition(i)
                        local Distance = Utils:Get3Ddist(vEnPos, Players:getPlayerPosition(Players:getLocalID()))
                        local PlayerDist
                        if Damager.DistanceEnable.v then
                            PlayerDist = Damager.Distance.v
                        else
                            PlayerDist = weaponInfo[weapon].distance
                        end
                        if Distance < PlayerDist then
                            local PlayerSkin = Players:getPlayerSkin(i)
                            local vMyColor = Players:getPlayerColor(Players:getLocalID())
                            local vEnColor = Players:getPlayerColor(i)
                            if Damager.CList.v and vMyColor ~= vEnColor or Damager.CList.v == false then  
                                if Damager.Force.v == false and Players:isPlayerInFilter(i) == false and Players:isSkinInFilter(PlayerSkin) == false or Damager.Force.v and Players:isPlayerInFilter(i) == true or Damager.Force.v and Players:isSkinInFilter(PlayerSkin) == true then
                                    if Damager.AFK.v and Players:isPlayerAFK(i) == false or Damager.AFK.v == false then
                                        if Damager.Death.v and get.isPlayerAlive(i) == true or Damager.Death.v == false then
                                            local distance = Utils:Get3Ddist(Players:getPlayerPosition(Players:getLocalID()), vEnPos)
                                            local cancontinue = false
                                            if Damager.Bone.v == 8 then
                                                local getbones = {}
                                                getbones[8] = Players:getBonePosition(i,8)
                                                getbones[3] = Players:getBonePosition(i,3)
                                                getbones[2] = Players:getBonePosition(i,2)
                                                getbones[33] = Players:getBonePosition(i,33)
                                                getbones[23] = Players:getBonePosition(i,23)
                                                getbones[42] = Players:getBonePosition(i,42)
                                                getbones[52] = Players:getBonePosition(i,52)
                                                local bonesDist = {}
                                                local dist = {}
                                                for j = 0, 52 do
                                                    if getbones[j] ~= nil then
                                                        if Damager.VisibleChecks.v and Utils:IsLineOfSightClear(Players:getBonePosition(Players:getLocalID(),8), getbones[j], true, Damager.VisibleCheck.Vehicles.v, false, Damager.VisibleCheck.Objects.v, false, false, false) or Damager.VisibleChecks.v == false then
                                                            Utils:GameToScreen(getbones[j], vEnScreen)
                                                            local fov = Utils:Get2Ddist(SilentCrosshair, vEnScreen)
                                                            if fov < Damager.Fov.v*20 and Damager.TargetType.v == 2 and Utils:isOnScreen(i) or Damager.TargetType.v ~= 2 then
                                                                nearestplayer[i] = fov
                                                                bonesDist[j] = fov
                                                            end
                                                            cancontinue = true
                                                        end
                                                    end
                                                end
                                                local nearestPlayerID = maths.getLowerIn(nearestplayer)
                                                if nearestPlayerID ~= nil then
                                                    nearestBone = maths.getLowerIn(bonesDist)
                                                    Global.damagerBone[i] = get.GameBoneFromCheat(nearestBone)
                                                end
                                            end
                                            if Damager.VisibleChecks.v and Utils:IsLineOfSightClear(Players:getBonePosition(Players:getLocalID(),8), vEnPos, true, Damager.VisibleCheck.Vehicles.v, false, Damager.VisibleCheck.Objects.v, false, false, false) or cancontinue or Damager.VisibleChecks.v == false then
                                                if Damager.TargetType.v == 0 then
                                                    nearestplayer[i] = distance
                                                elseif Damager.TargetType.v == 1 then
                                                    nearestplayer[i] = (Players:getPlayerHP(i) + Players:getPlayerArmour(i))
                                                elseif Damager.TargetType.v == 2 then
                                                    Utils:GameToScreen(vEnPos, vEnScreen)
                                                    local fov = Utils:Get2Ddist(SilentCrosshair, vEnScreen)
                                                    if fov < Damager.Fov.v*20 and Utils:isOnScreen(i) then
                                                        nearestplayer[i] = fov
                                                    end
                                                else
                                                    nearestplayer[i] = i
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    if Damager.gtdID.v ~= -1 then
                        i = Damager.gtdID.v
                    end
                    if Players:isPlayerOnServer(i) then
                        local vMyColor = Players:getPlayerColor(Players:getLocalID())
                        local vEnColor = Players:getPlayerColor(i)
                        if Damager.CList.v and vMyColor ~= vEnColor or Damager.CList.v == false then 
                            if Damager.Force.v == false and Players:isPlayerInFilter(i) == false or Damager.Force.v and Players:isPlayerInFilter(i) == true then
                                nearestplayer[i] = i
                            end
                        end
                    end
                end
                if nearestplayer[i] == nil and v.DamagerPlayerID == i then
                    v.DamagerPlayerID = -1
                end
            end
            local DamagerPlayer
            if Damager.OnlyStreamed.v then
                if Damager.TargetType.v == 0 or Damager.TargetType.v == 1 or Damager.TargetType.v == 2 then
                    DamagerPlayer = maths.getLowerIn(nearestplayer)
                elseif Damager.TargetType.v == 3 then
                    local validValues = {}
                    for _, value in pairs(nearestplayer) do
                        if value ~= nil then
                            table.insert(validValues, value)
                        end
                    end
                    if #validValues > 0 then
                        DamagerPlayer = validValues[math.random(#validValues)]
                    end
                end
            else
                local validValues = {}
                for _, value in pairs(nearestplayer) do
                    if value ~= nil then
                        table.insert(validValues, value)
                    end
                end
                if #validValues > 0 then
                    DamagerPlayer = validValues[math.random(#validValues)]
                end
            end
            if DamagerPlayer ~= nil then
                DamagerDelayed = nil
                v.DamagerPlayerID = DamagerPlayer
                v.DamagerDelayed = 1
                send.DamagerBullet()
            end
        end
    end
end
function AimTab.PlayerSync()
--Extra WS
    if KeyToggle.ExtraWS.v == 1 then
        if AimOT.ExtraWS.Type.v == 1 then
            memory.ExtraWS.v1 = Utils:readMemory(0x5109AC, 1, false)
            memory.ExtraWS.v2 = Utils:readMemory(0x5109C5, 1, false)
            memory.ExtraWS.v3 = Utils:readMemory(0x5231A6, 1, false)
            memory.ExtraWS.v4 = Utils:readMemory(0x52322D, 1, false)
            memory.ExtraWS.v5 = Utils:readMemory(0x5233BA, 1, false)
            if AimOT.ExtraWS.X.v or AimOT.ExtraWS.Y.v then
                if AimOT.ExtraWS.PerCategory.Enable.v and AimOT.ExtraWS.PerCategory.Pistols.v and weaponInfo[Players:getPlayerWeapon(Players:getLocalID())].slot == 2 or
                AimOT.ExtraWS.PerCategory.Enable.v and AimOT.ExtraWS.PerCategory.Shotguns.v and weaponInfo[Players:getPlayerWeapon(Players:getLocalID())].slot == 3 or 
                AimOT.ExtraWS.PerCategory.Enable.v and AimOT.ExtraWS.PerCategory.SMGs.v and weaponInfo[Players:getPlayerWeapon(Players:getLocalID())].slot == 4 or 
                AimOT.ExtraWS.PerCategory.Enable.v and AimOT.ExtraWS.PerCategory.Rifles.v and weaponInfo[Players:getPlayerWeapon(Players:getLocalID())].slot == 5 or
                AimOT.ExtraWS.PerCategory.Enable.v and AimOT.ExtraWS.PerCategory.Snipers.v and weaponInfo[Players:getPlayerWeapon(Players:getLocalID())].slot == 6 or 
                AimOT.ExtraWS.PerCategory.Enable.v == false then
                    if AimOT.ExtraWS.X.v and AimOT.ExtraWS.Y.v then
                        if memory.ExtraWS.v1 ~= 235 then Utils:writeMemory(0x5109AC, 235, 1, false) end 
                        if memory.ExtraWS.v2 ~= 235 then Utils:writeMemory(0x5109C5, 235, 1, false) end
                        if memory.ExtraWS.v3 ~= 235 then Utils:writeMemory(0x5231A6, 235, 1, false) end
                        if memory.ExtraWS.v4 ~= 235 then Utils:writeMemory(0x52322D, 235, 1, false) end
                        if memory.ExtraWS.v5 ~= 235 then Utils:writeMemory(0x5233BA, 235, 1, false) end
                    elseif AimOT.ExtraWS.X.v then
                        if memory.ExtraWS.v1 ~= 235 then Utils:writeMemory(0x5109AC, 235, 1, false) end 
                        if memory.ExtraWS.v2 ~= 235 then Utils:writeMemory(0x5109C5, 235, 1, false) end
                        if memory.ExtraWS.v3 ~= 235 then Utils:writeMemory(0x5231A6, 235, 1, false) end
                        if memory.ExtraWS.v4 == 235 then Utils:writeMemory(0x52322D, 0x75, 1, false) end
                        if memory.ExtraWS.v5 == 235 then Utils:writeMemory(0x5233BA, 0x75, 1, false) end
                    elseif AimOT.ExtraWS.Y.v then
                        if memory.ExtraWS.v1 ~= 235 then Utils:writeMemory(0x5109AC, 235, 1, false) end 
                        if memory.ExtraWS.v2 == 235 then Utils:writeMemory(0x5109C5, 0x7a, 1, false) end
                        if memory.ExtraWS.v3 == 235 then Utils:writeMemory(0x5231A6, 0x75, 1, false) end
                        if memory.ExtraWS.v4 ~= 235 then Utils:writeMemory(0x52322D, 235, 1, false) end
                        if memory.ExtraWS.v5 ~= 235 then Utils:writeMemory(0x5233BA, 235, 1, false) end
                    end
                else
                    if memory.ExtraWS.v1 == 235 then Utils:writeMemory(0x5109AC, 0x7a, 1, false) end
                    if memory.ExtraWS.v2 == 235 then Utils:writeMemory(0x5109C5, 0x7a, 1, false) end
                    if memory.ExtraWS.v3 == 235 then Utils:writeMemory(0x5231A6, 0x75, 1, false) end
                    if memory.ExtraWS.v4 == 235 then Utils:writeMemory(0x52322D, 0x75, 1, false) end
                    if memory.ExtraWS.v5 == 235 then Utils:writeMemory(0x5233BA, 0x75, 1, false) end
                end
            else
                if memory.ExtraWS.v1 == 235 then Utils:writeMemory(0x5109AC, 0x7a, 1, false) end
                if memory.ExtraWS.v2 == 235 then Utils:writeMemory(0x5109C5, 0x7a, 1, false) end
                if memory.ExtraWS.v3 == 235 then Utils:writeMemory(0x5231A6, 0x75, 1, false) end
                if memory.ExtraWS.v4 == 235 then Utils:writeMemory(0x52322D, 0x75, 1, false) end
                if memory.ExtraWS.v5 == 235 then Utils:writeMemory(0x5233BA, 0x75, 1, false) end
            end
        else
            if AimOT.ExtraWS.PerCategory.Enable.v and AimOT.ExtraWS.PerCategory.Pistols.v and weaponInfo[Players:getPlayerWeapon(Players:getLocalID())].slot == 2 or
            AimOT.ExtraWS.PerCategory.Enable.v and AimOT.ExtraWS.PerCategory.Shotguns.v and weaponInfo[Players:getPlayerWeapon(Players:getLocalID())].slot == 3 or 
            AimOT.ExtraWS.PerCategory.Enable.v and AimOT.ExtraWS.PerCategory.SMGs.v and weaponInfo[Players:getPlayerWeapon(Players:getLocalID())].slot == 4 or 
            AimOT.ExtraWS.PerCategory.Enable.v and AimOT.ExtraWS.PerCategory.Rifles.v and weaponInfo[Players:getPlayerWeapon(Players:getLocalID())].slot == 5 or
            AimOT.ExtraWS.PerCategory.Enable.v and AimOT.ExtraWS.PerCategory.Snipers.v and weaponInfo[Players:getPlayerWeapon(Players:getLocalID())].slot == 6 or 
            AimOT.ExtraWS.PerCategory.Enable.v == false then
                local camMode = Utils:readMemory(0xB6F1A8, 4, false)
                if camMode == 53 then
                    Global.saveCamY = Utils:readMemory(0xB6F248, 4, false)
                    local bsTrans = BitStream()
                    bsWrap:Write32(bsTrans, Global.saveCamY)
                    Global.saveCamY = bsWrap:ReadFloat(bsTrans)
                    Global.Stable = 1
                elseif Global.Stable == 1 then
                    if AimOT.ExtraWS.X.v then
                        local camX = Utils:readMemory(0xB6F258, 4, false)
                        local bsTrans = BitStream()
                        bsWrap:Write32(bsTrans, camX)
                        camX = bsWrap:ReadFloat(bsTrans)
                        Utils:writeMemory(0xB6F258, camX+(0.0912 / (AimOT.ExtraWS.Smooth.X.v + 0.0000001)), 4, false)
                    end
                    if AimOT.ExtraWS.Y.v then
                        local camY = Utils:readMemory(0xB6F248, 4, false)
                        local bsTrans = BitStream()
                        bsWrap:Write32(bsTrans, camY)
                        camY = bsWrap:ReadFloat(bsTrans)
                        Utils:writeMemory(0xB6F248, camY-(camY-Global.saveCamY / (AimOT.ExtraWS.Smooth.Y.v + 0.0000001)), 4, false)
                    end
                    Global.Stable = 0
                end
            end
        end
    else
        if memory.ExtraWS.v1 == 235 then Utils:writeMemory(0x5109AC, 0x7a, 1, false) end
        if memory.ExtraWS.v2 == 235 then Utils:writeMemory(0x5109C5, 0x7a, 1, false) end
        if memory.ExtraWS.v3 == 235 then Utils:writeMemory(0x5231A6, 0x75, 1, false) end
        if memory.ExtraWS.v4 == 235 then Utils:writeMemory(0x52322D, 0x75, 1, false) end
        if memory.ExtraWS.v5 == 235 then Utils:writeMemory(0x5233BA, 0x75, 1, false) end
    end
--Fast Aim
    if AimOT.FastAim.v then
        local aim = Utils:readMemory(Global.CPlayerData+0x84, 1, false)
        if Utils:IsKeyDown(2) then
            if aim == 0 then Utils:writeMemory(Global.CPlayerData+0x84, 1, 1, false) end
        else
            if aim ~= 0 then Utils:writeMemory(Global.CPlayerData+0x84, 0, 1, false) end
        end
    end
end
function AimTab.Visual()
--Damager 
    if KeyToggle.Damager.v == 1 and Damager.OnlyStreamed.v then
        if Damager.ShowHitPos.v and Global.damagerhitEnPos ~= 0 then
            Utils:GameToScreen(Global.damagerhitEnPos, vEnScreenToDamager)
            if vEnScreenToDamager.fZ > 0 and v.DamagerPlayerID ~= -1 then
                Render:DrawCircle(vEnScreenToDamager.fX, vEnScreenToDamager.fY, 5, true, Players:getPlayerColor( v.DamagerPlayerID))
                Render:DrawLine(SilentCrosshair.fX,SilentCrosshair.fY,vEnScreenToDamager.fX,vEnScreenToDamager.fY,Players:getPlayerColor( v.DamagerPlayerID))
            end
        end
        if Damager.DrawFov.v and Damager.OnlyStreamed.v and Damager.TargetType.v == 2 then
            local fov = Damager.Fov.v*20
            Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, fov, false, Players:getPlayerColor(v.DamagerPlayerID))
            Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, fov, true, 0x14FF00C1)
        end
    end
--Silent DrawFov
    if KeyToggle.Silent.v == 1 then
        if Silent.ShowHitPos.v and Global.silenthitEnPos ~= 0 then
            Utils:GameToScreen(Global.silenthitEnPos, vEnScreenToSilent)
            Utils:GameToScreen(Global.silentoriginEnPos, vMyScreenToSilent)
            if vEnScreenToSilent.fZ > 0 then
                Render:DrawCircle(vEnScreenToSilent.fX, vEnScreenToSilent.fY, 3, true, 0xFFFF00C1)
                Render:DrawLine(vMyScreenToSilent.fX,vMyScreenToSilent.fY,vEnScreenToSilent.fX,vEnScreenToSilent.fY,0x8FFF00C1)
            end
        end
        local aim 
        if SilentStuff.FirstShots == 0 then
            aim = SilentStuff.Fov
        else
            aim = SilentStuff.Fov2
        end
        if SilentStuff.BoneHead == true or SilentStuff.BoneChest == true or SilentStuff.BoneStomach == true or SilentStuff.BoneLeftA == true or 
        SilentStuff.BoneRightA == true or SilentStuff.BoneLeftL == true or SilentStuff.BoneRightL == true then
            local CFGBone = players.bone[v.SilentPlayerID]
            if v.SilentPlayerID ~= -1 then
                if Players:isPlayerStreamed(v.SilentPlayerID) then
                    local vEnBone = Players:getBonePosition(v.SilentPlayerID, CFGBone)
                    local vEnScreen2 = CVector()
                    if SHAkMenu.Lagshot.v then
                        vEnBone2 = get.PlayerLag(v.SilentPlayerID, CFGBone)
                        Utils:GameToScreen(vEnBone2, vEnScreen2)
                    else
                        Utils:GameToScreen(vEnBone, vEnScreen2)
                    end
                    Utils:GameToScreen(vEnBone, vEnScreen)
                    local fov = Utils:Get2Ddist(SilentCrosshair,vEnScreen)
                    if KeyToggle.Silent.v == 1 then
                        if fov < aim  then 
                            if Silent.DrawFov.v then
                                Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, aim, false, Players:getPlayerColor(v.SilentPlayerID))
                                Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, aim, true, 0x199966f0)
                                Render:DrawLine(SilentCrosshair.fX,SilentCrosshair.fY,vEnScreen2.fX,vEnScreen2.fY,Players:getPlayerColor(v.SilentPlayerID))
                                Render:DrawCircle(vEnScreen2.fX, vEnScreen2.fY, 3, true, Players:getPlayerColor(v.SilentPlayerID))
                            end
                        else
                            v.SilentPlayerID = -1
                        end
                    else
                        v.SilentPlayerID = -1
                        if Silent.DrawFov.v then
                            Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, false, 0xFF9966f0)
                            Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, true, 0x2F9966f0)
                        end
                    end
                else
                    v.SilentPlayerID = -1
                    if Silent.DrawFov.v then
                        Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, false, 0xFF9966f0)
                        Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, true, 0x2F9966f0)
                    end
                end
            else
                if Silent.DrawFov.v then
                    Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, false, 0xFF9966f0)
                    Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, true, 0x2F9966f0)
                end
            end
        else
            if Silent.DrawFov.v then
                Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, false, 0xFF9966f0)
                Render:DrawCircle(SilentCrosshair.fX, SilentCrosshair.fY, aim, true, 0x2F9966f0)
            end
            v.SilentPlayerID = -1
        end
    end
end
function AimTab.Menu()
    if SHAkMenu.Menu.v == 1 then
        SHAkMenu.resetMenuTimer(SHAkMenu.Menu.v)
        --AimAssist
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-10,SHAkMenu.menutransitor-2) 
            if Menu:Button("| Aim Assist |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                AimAssists = not AimAssists
                SHAkMenu.menuOpened = 0
            end
            if AimAssists == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("AimAssist", AimAssist.Enable)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey", AimAssist.OnKey)
                if AimAssist.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("   ", AimAssist.Key, 200, 20) end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                    if Menu:Button("(?)##1") then
                        reindirectbutton = not reindirectbutton
                    end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Draw Fov", AimAssist.DrawFOV)
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type", AimAssist.FOVType,"FOV\0.360º\0\0",6)
                if AimAssist.FOVType.v == 0 then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("FOV", AimAssist.FOV, 0, 60)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("Dead Zone", AimAssist.DeadZone, 0, 60)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Force who you damaged", AimAssist.ForceWhoDamaged)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore same Color##5", AimAssist.CList)
            end
        --Silent
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+8,SHAkMenu.menutransitor+8) 
            if Menu:Button("| Silent |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                SilentList = not SilentList
                SHAkMenu.menuOpened = 0
            end
            if SilentList == true then
                get.FovfromConfig()
                get.SilentConfig(Players:getPlayerWeapon(Players:getLocalID()), Cars:getCarModel(Players:getVehicleID(Players:getLocalID())))
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Silent", Silent.Enable)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##23", Silent.OnKey)
                if Silent.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("     ", Silent.Key, 200, 20) end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                    if Menu:Button("(?)##2") then
                        reindirectbutton = not reindirectbutton
                    end
                Menu:Separator()
                if Silent.WeaponClass.v > 5 then
                    Silent.WeaponClass = 5
                end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Weapon Class",Silent.WeaponClass,"Pistols\0Shotguns\0SMG\0Rifles\0Snipers\0Rockets\0\0",9)
                    
                local FirstShots, Fov, Fov2, Chance, Chance2, Bullets, DistanceEnable, Distance, DamageEnable, Damage, VisibleCheck, Vehicles, Objects, minspread, maxspread
                local bones = {}
                if Silent.WeaponClass.v == 0 then -- Pistols
                    FirstShots = Silent.Pistols.FirstShots.Shots
                    Fov = Silent.Pistols.Fov
                    Fov2 = Silent.Pistols.FirstShots.Fov
                    Chance = Silent.Pistols.Chance
                    Chance2 = Silent.Pistols.FirstShots.Chance
                    Bullets = Silent.Pistols.Bullets
                    DistanceEnable = Silent.Pistols.DistanceEnable
                    Distance = Silent.Pistols.Distance 
                    DamageEnable = Silent.Pistols.ChangeDamage
                    Damage = Silent.Pistols.Damage
                    VisibleCheck = Silent.Pistols.VisibleCheck.Buildings
                    Vehicles = Silent.Pistols.VisibleCheck.Vehicles
                    Objects = Silent.Pistols.VisibleCheck.Objects
                    bones.head = Silent.Pistols.Bones.Head
                    bones.chest = Silent.Pistols.Bones.Chest
                    bones.stomach = Silent.Pistols.Bones.Stomach
                    bones.lefta = Silent.Pistols.Bones.LeftArm
                    bones.righta = Silent.Pistols.Bones.RightArm
                    bones.leftl = Silent.Pistols.Bones.LeftLeg
                    bones.rightl = Silent.Pistols.Bones.RightLeg
                    minspread = Silent.Pistols.Spread.Min
                    maxspread = Silent.Pistols.Spread.Max
                end
                if Silent.WeaponClass.v == 1 then -- Shotguns
                    FirstShots = Silent.Shotguns.FirstShots.Shots
                    Fov = Silent.Shotguns.Fov
                    Fov2 = Silent.Shotguns.FirstShots.Fov
                    Chance = Silent.Shotguns.Chance
                    Chance2 = Silent.Shotguns.FirstShots.Chance
                    Bullets = Silent.Shotguns.Bullets
                    DistanceEnable = Silent.Shotguns.DistanceEnable
                    Distance = Silent.Shotguns.Distance 
                    DamageEnable = Silent.Shotguns.ChangeDamage
                    Damage = Silent.Shotguns.Damage
                    VisibleCheck = Silent.Shotguns.VisibleCheck.Buildings
                    Vehicles = Silent.Shotguns.VisibleCheck.Vehicles
                    Objects = Silent.Shotguns.VisibleCheck.Objects
                    bones.head = Silent.Shotguns.Bones.Head
                    bones.chest = Silent.Shotguns.Bones.Chest
                    bones.stomach = Silent.Shotguns.Bones.Stomach
                    bones.lefta = Silent.Shotguns.Bones.LeftArm
                    bones.righta = Silent.Shotguns.Bones.RightArm
                    bones.leftl = Silent.Shotguns.Bones.LeftLeg
                    bones.rightl = Silent.Shotguns.Bones.RightLeg
                    minspread = Silent.Shotguns.Spread.Min
                    maxspread = Silent.Shotguns.Spread.Max
                end
                if Silent.WeaponClass.v == 2 then -- SMG
                    FirstShots = Silent.Smgs.FirstShots.Shots
                    Fov = Silent.Smgs.Fov
                    Fov2 = Silent.Smgs.FirstShots.Fov
                    Chance = Silent.Smgs.Chance
                    Chance2 = Silent.Smgs.FirstShots.Chance
                    Bullets = Silent.Smgs.Bullets
                    DistanceEnable = Silent.Smgs.DistanceEnable
                    Distance = Silent.Smgs.Distance 
                    DamageEnable = Silent.Smgs.ChangeDamage
                    Damage = Silent.Smgs.Damage
                    VisibleCheck = Silent.Smgs.VisibleCheck.Buildings
                    Vehicles = Silent.Smgs.VisibleCheck.Vehicles
                    Objects = Silent.Smgs.VisibleCheck.Objects
                    bones.head = Silent.Smgs.Bones.Head
                    bones.chest = Silent.Smgs.Bones.Chest
                    bones.stomach = Silent.Smgs.Bones.Stomach
                    bones.lefta = Silent.Smgs.Bones.LeftArm
                    bones.righta = Silent.Smgs.Bones.RightArm
                    bones.leftl = Silent.Smgs.Bones.LeftLeg
                    bones.rightl = Silent.Smgs.Bones.RightLeg
                    minspread = Silent.Smgs.Spread.Min
                    maxspread = Silent.Smgs.Spread.Max
                end
                if Silent.WeaponClass.v == 3 then -- Rifles
                    FirstShots = Silent.Rifles.FirstShots.Shots
                    Fov = Silent.Rifles.Fov
                    Fov2 = Silent.Rifles.FirstShots.Fov
                    Chance = Silent.Rifles.Chance
                    Chance2 = Silent.Rifles.FirstShots.Chance
                    Bullets = Silent.Rifles.Bullets
                    DistanceEnable = Silent.Rifles.DistanceEnable
                    Distance = Silent.Rifles.Distance 
                    DamageEnable = Silent.Rifles.ChangeDamage
                    Damage = Silent.Rifles.Damage
                    VisibleCheck = Silent.Rifles.VisibleCheck.Buildings
                    Vehicles = Silent.Rifles.VisibleCheck.Vehicles
                    Objects = Silent.Rifles.VisibleCheck.Objects
                    bones.head = Silent.Rifles.Bones.Head
                    bones.chest = Silent.Rifles.Bones.Chest
                    bones.stomach = Silent.Rifles.Bones.Stomach
                    bones.lefta = Silent.Rifles.Bones.LeftArm
                    bones.righta = Silent.Rifles.Bones.RightArm
                    bones.leftl = Silent.Rifles.Bones.LeftLeg
                    bones.rightl = Silent.Rifles.Bones.RightLeg
                    minspread = Silent.Rifles.Spread.Min
                    maxspread = Silent.Rifles.Spread.Max
                end
                if Silent.WeaponClass.v == 4 then -- Snipers
                    FirstShots = Silent.Snipers.FirstShots.Shots
                    Fov = Silent.Snipers.Fov
                    Fov2 = Silent.Snipers.FirstShots.Fov
                    Chance = Silent.Snipers.Chance
                    Chance2 = Silent.Snipers.FirstShots.Chance
                    Bullets = Silent.Snipers.Bullets
                    DistanceEnable = Silent.Snipers.DistanceEnable
                    Distance = Silent.Snipers.Distance 
                    DamageEnable = Silent.Snipers.ChangeDamage
                    Damage = Silent.Snipers.Damage
                    VisibleCheck = Silent.Snipers.VisibleCheck.Buildings
                    Vehicles = Silent.Snipers.VisibleCheck.Vehicles
                    Objects = Silent.Snipers.VisibleCheck.Objects
                    bones.head = Silent.Snipers.Bones.Head
                    bones.chest = Silent.Snipers.Bones.Chest
                    bones.stomach = Silent.Snipers.Bones.Stomach
                    bones.lefta = Silent.Snipers.Bones.LeftArm
                    bones.righta = Silent.Snipers.Bones.RightArm
                    bones.leftl = Silent.Snipers.Bones.LeftLeg
                    bones.rightl = Silent.Snipers.Bones.RightLeg
                    minspread = Silent.Snipers.Spread.Min
                    maxspread = Silent.Snipers.Spread.Max
                end
                if Silent.WeaponClass.v == 5 then -- Rockets
                    FirstShots = Silent.Rockets.FirstShots.Shots
                    Fov = Silent.Rockets.Fov
                    Fov2 = Silent.Rockets.FirstShots.Fov
                    Chance = Silent.Rockets.Chance
                    Chance2 = Silent.Rockets.FirstShots.Chance
                    Bullets = Silent.Rockets.Bullets
                    DistanceEnable = Silent.Rockets.DistanceEnable
                    Distance = Silent.Rockets.Distance 
                    DamageEnable = Silent.Rockets.ChangeDamage
                    Damage = Silent.Rockets.Damage
                    VisibleCheck = Silent.Rockets.VisibleCheck.Buildings
                    Vehicles = Silent.Rockets.VisibleCheck.Vehicles
                    Objects = Silent.Rockets.VisibleCheck.Objects
                    bones.head = Silent.Rockets.Bones.Head
                    bones.chest = Silent.Rockets.Bones.Chest
                    bones.stomach = Silent.Rockets.Bones.Stomach
                    bones.lefta = Silent.Rockets.Bones.LeftArm
                    bones.righta = Silent.Rockets.Bones.RightArm
                    bones.leftl = Silent.Rockets.Bones.LeftLeg
                    bones.rightl = Silent.Rockets.Bones.RightLeg
                    minspread = Silent.Rockets.Spread.Min
                    maxspread = Silent.Rockets.Spread.Max
                end
                
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Wall Shot", Silent.WallShot)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Draw Fov", Silent.DrawFov)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Show HitPos", Silent.ShowHitPos)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+13, SHAkMenu.menutransitorstaticreversed+13) Menu:Text("Min Spread")
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+90, SHAkMenu.menutransitorstaticreversed+90) Menu:Text("Max Spread")
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5, SHAkMenu.menutransitorstaticreversed+5) Menu:SliderFloat("##24", minspread, -0.15, 0)
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+82, SHAkMenu.menutransitorstaticreversed+82) Menu:SliderFloat("###54", maxspread, 0, 0.15)
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+25, SHAkMenu.menutransitorstaticreversed+30) Menu:Text("| FOV |") 
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+95, SHAkMenu.menutransitorstaticreversed+95) Menu:Text("| CHANCE |") 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("##2323", Fov, 0, 60.0)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+85,SHAkMenu.menutransitorstaticreversed+85) Menu:SliderInt("##2", Chance, 0, 100)
                    
                if FirstShots.v > 0 then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+50, SHAkMenu.menutransitorstaticreversed+45) Menu:Text("| FIRST SHOTS |") 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("##32131", Fov2, 0, 60)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+85,SHAkMenu.menutransitorstaticreversed+85) Menu:SliderInt("##4", Chance2, 0, 100)
                    
                else
                    Menu:Separator()
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15, SHAkMenu.menutransitorstaticreversed+15) Menu:SliderInt("First Shots##23", FirstShots, 0, 40)
                if FirstShots.v > 0 then   
                    Menu:Separator()
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5, SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Send Bullets##23", Bullets, 1, 100)
                
                if DistanceEnable.v == false and DamageEnable.v == false then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| ------- BONES ------- |")
                end
                Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Change Distance##323", DistanceEnable)
                if DistanceEnable.v == true then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+85, SHAkMenu.menutransitorstaticreversed+85) Menu:SliderInt("Distance##323", Distance, 0, 350.0)
                else
                    if DamageEnable.v == false then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Head", bones.head)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Modified Damage##231", DamageEnable)
                if DistanceEnable.v == true then
                    if DamageEnable.v == false then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| ------- BONES ------- |")
                    end
                else
                    if DamageEnable.v == false then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Chest", bones.chest)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    end
                end
                if DamageEnable.v == true then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+85, SHAkMenu.menutransitorstaticreversed+85) Menu:SliderFloat("Damage##3", Damage, 0, 2000)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Visible Check##3", VisibleCheck)
                if DamageEnable.v == true then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| ------- BONES ------- |")
                else
                    if DistanceEnable.v == false then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Stomach", bones.stomach)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    else
                        if DistanceEnable.v == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Head", bones.head)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        end
                    end
                end
                if VisibleCheck.v == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Vehicles##33", Vehicles)
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Head", bones.head)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    else
                        if DistanceEnable.v == false then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Arm", bones.lefta)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        else
                            if DistanceEnable.v == true then
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Chest", bones.chest)
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                            end
                        end
                    end 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Objects##3", Objects)
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Chest", bones.chest)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    else
                        if DistanceEnable.v == false then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Arm", bones.righta)
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        else
                            if DistanceEnable.v == true then
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Stomach", bones.stomach)
                                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                            end
                        end
                    end
                end

                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore same Color", Silent.CList)
                
                if VisibleCheck.v == true then
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Stomach", bones.stomach)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    elseif DistanceEnable.v == false then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Leg", bones.leftl)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    else
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Arm", bones.lefta)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    end
                else
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Head", bones.head)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    elseif DistanceEnable.v == false then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Arm", bones.lefta)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    else
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Chest", bones.chest)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore AFK", Silent.AFK)
                
                if VisibleCheck.v == true then
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Arm", bones.lefta)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    elseif DistanceEnable.v == false then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Leg", bones.rightl)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    else
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Arm", bones.righta)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    end
                else
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Chest", bones.chest)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    elseif DistanceEnable.v == false then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Arm", bones.righta)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    else
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Stomach", bones.stomach)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore Death", Silent.Death)
                
                if VisibleCheck.v == true then
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Arm", bones.righta)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    elseif DistanceEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Leg", bones.leftl)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    else
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| --------------------------- |")
                    end
                else
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Stomach", bones.stomach)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    elseif DistanceEnable.v == false then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Leg", bones.leftl)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    else
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Arm", bones.lefta)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore InVehicle", Silent.InVehicle)
                
                if VisibleCheck.v == true then
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Leg", bones.leftl)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    elseif DistanceEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Leg", bones.rightl)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        
                    end
                else
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Arm", bones.lefta)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    elseif DistanceEnable.v == false then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Leg", bones.rightl)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    else
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Arm", bones.righta)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Force Players/Skins In Filters", Silent.Force)
                if VisibleCheck.v == true then
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Leg", bones.rightl)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    elseif DistanceEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| --------------------------- |")
                    end
                else
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Arm", bones.righta)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    elseif DistanceEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Leg", bones.leftl)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    else
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| --------------------------- |")
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Sync Rotation", Silent.SyncRotation)
                if VisibleCheck.v == true then
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| --------------------------- |")
                    end
                else
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Left Leg", bones.leftl)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    elseif DistanceEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Leg", bones.rightl)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Sync Z Angle", Silent.SyncAim)
                if VisibleCheck.v == true then
                else
                    if DamageEnable.v == true then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+107,SHAkMenu.menutransitorstaticreversed+107) Menu:Text("|") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+115,SHAkMenu.menutransitorstaticreversed+115) Menu:CheckBox("Right Leg", bones.rightl)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+160,SHAkMenu.menutransitorstaticreversed+160) Menu:Text("|") 
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| --------------------------- |")
                    elseif DistanceEnable.v == true then
                         Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Button("| --------------------------- |")
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Exploit WeaponConfig include (Distance Hack)", Silent.Exploit)
                if Silent.Exploit.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:Combo("Hit Type##3",Silent.ExploitType,"Target\0Current HitPos\0\0",25)
                end
            end
        --TriggerBot
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-2,SHAkMenu.menutransitor-10) 
            if Menu:Button("| TriggerBot |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                TriggerBotList = not TriggerBotList
                SHAkMenu.menuOpened = 0
            end
            if TriggerBotList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Triggerbot", Triggerbot.Enable)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##123123", Triggerbot.OnKey)
                if Triggerbot.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("   ##123123", Triggerbot.Key, 200, 20) end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                    if Menu:Button("(?)##234234") then
                        reindirectbutton = not reindirectbutton
                    end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Delay ##12312", Triggerbot.Delay, 0, 1000)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Offset ", Triggerbot.Offset, 1, 60)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore same Color##123123123", Triggerbot.CList)
            end
        --Damager
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-2,SHAkMenu.menutransitor-2) 
            if Menu:Button("| Damager |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                DamagerList = not DamagerList
                SHAkMenu.menuOpened = 0
            end
            if DamagerList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Damager", Damager.Enable)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##9", Damager.OnKey)
                if Damager.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("  ", Damager.Key, 200, 20) end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                    if Menu:Button("(?)##4") then
                        reindirectbutton = not reindirectbutton
                    end
                if Damager.OnlyStreamed.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Target",Damager.TargetType,"Nearest\0Lowest HP\0Fov\0Random\0\0",20)
                    if Damager.TargetType.v == 2 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderFloat("Fov##2", Damager.Fov, 0, 60)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Draw Fov##9", Damager.DrawFov)
                    end
                end
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Only Streamed", Damager.OnlyStreamed)
                if Damager.OnlyStreamed.v == false then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("PlayerID", Damager.gtdID, -1, 1004)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:SliderInt("Delay",Damager.Delay, 1, 1000) then
                    get.ScriptTimers()
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Chance##2", Damager.Chance, 1, 100)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Current Weapon", Damager.CurrentWeapon)
                if Damager.CurrentWeapon.v == false then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Weapon",Damager.Weapon, fWeaponName,20)
                end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Damage Type",Damager.DamageType, "Give\0Take\0\0",20)
                if Damager.DamageType.v == 1 then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Send DeathNotification", Damager.DeathNotification)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Send Spawn", Damager.Spawn)
                end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Bone",Damager.Bone,"Chest\0Stomach\0Left Arm\0Right Arm\0Left Leg\0Right Leg\0Head\0Random\0Nearest\0\0",20)
                if Damager.OnlyStreamed.v and Damager.DamageType.v == false then     
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:Combo("Bullet Type",Damager.SyncBullet.Type,"Normal\0Bypass WeaponConfig\0Dont Send\0\0",20)
                    if Damager.SyncBullet.Type.v ~= 2 then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Send Bullets",Damager.Bullets, 0, 10)
                        if Damager.Bullets.v > 1 then   
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+76,SHAkMenu.menutransitorstaticreversed+76) Menu:SliderInt("Delay Per Bullet",Damager.DelayperBullet, 0, Damager.Delay.v/Damager.Bullets.v)
                        end
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Send OnFoot Sync", Damager.SyncOnfootData)
                    if Damager.SyncOnfootData.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Emulate CBug", Damager.EmulCbug)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Sync Rotation##2", Damager.SyncRotation)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Send Position to Player", Damager.SyncPos)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Send Aim##2", Damager.SyncAim)
                    if Damager.SyncAim.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Sync Z Angle##2", Damager.SyncAimZ)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Send RPC", Damager.SyncRPC)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Send Weapon Sync", Damager.SyncWeapon)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Visible Check", Damager.VisibleChecks)
                    if Damager.VisibleChecks.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Vehicles", Damager.VisibleCheck.Vehicles)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Objects", Damager.VisibleCheck.Objects)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)  Menu:CheckBox2("Ignore same Color##2", Damager.CList)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore AFK##2", Damager.AFK)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore Death##2", Damager.Death)
                end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Force Players/Skins In Filters##2", Damager.Force)
                if Damager.OnlyStreamed.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Change Distance##2", Damager.DistanceEnable)
                    if Damager.DistanceEnable.v then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+85,SHAkMenu.menutransitorstaticreversed+85) Menu:SliderInt("Distance##2",Damager.Distance, 0, 350)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Show Hit Pos", Damager.ShowHitPos)
                end
                if Damager.SyncRPC.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Modified Damage##2", Damager.ChangeDamage)
                    if Damager.ChangeDamage.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("Damage##2",Damager.Damage, 0, 2000)
                    end
                end
            end
        --DamageMultiplier
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-30,SHAkMenu.menutransitor-25) 
            if Menu:Button("| Damage Multiplier |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                DDamagerList = not DDamagerList
                SHAkMenu.menuOpened = 0
            end
            if DDamagerList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Damage Multiplier", DamageMultiplier.Enable)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##666", DamageMultiplier.OnKey)
                if DamageMultiplier.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("  ##66666", DamageMultiplier.Key, 200, 20) end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                if Menu:Button("(?)##3") then
                    reindirectbutton = not reindirectbutton
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore same Color##3", DamageMultiplier.CList)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:Button("| Melees |") then slot0 = not slot0 end
                if slot0 then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Chance ##1222", DamageMultiplier.Melees.Chance, 0, 100)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Multiplier", DamageMultiplier.Melees.Multiplier, 0, 15)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Delay ##12222", DamageMultiplier.Melees.Delay, 0, 1000) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("All Streamed Player", DamageMultiplier.Melees.AllStreamedPlayer) end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:Button("| Pistols |") then slot1 = not slot1 end
                if slot1 then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Chance ##1223", DamageMultiplier.Pistols.Chance, 0, 100)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Multiplier ##3", DamageMultiplier.Pistols.Multiplier, 0, 15)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Delay ##12223", DamageMultiplier.Pistols.Delay, 0, 1000) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("All Streamed Player##3", DamageMultiplier.Pistols.AllStreamedPlayer) end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:Button("| Shotguns |") then slot2 = not slot2 end
                if slot2 then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Chance ##1224", DamageMultiplier.Shotguns.Chance, 0, 100)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Multiplier ##4", DamageMultiplier.Shotguns.Multiplier, 0, 15)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Delay ##12224", DamageMultiplier.Shotguns.Delay, 0, 1000) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("All Streamed Player##4", DamageMultiplier.Shotguns.AllStreamedPlayer) end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:Button("| SMGs |") then slot3 = not slot3 end
                if slot3 then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Chance ##1225", DamageMultiplier.Smgs.Chance, 0, 100)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Multiplier ##5", DamageMultiplier.Smgs.Multiplier, 0, 15)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Delay ##12225", DamageMultiplier.Smgs.Delay, 0, 1000) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("All Streamed Player##5", DamageMultiplier.Smgs.AllStreamedPlayer) end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:Button("| Rifles |") then slot4 = not slot4 end
                if slot4 then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Chance ##1226", DamageMultiplier.Rifles.Chance, 0, 100)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Multiplier ##6", DamageMultiplier.Rifles.Multiplier, 0, 15)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Delay ##12226", DamageMultiplier.Rifles.Delay, 0, 1000) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("All Streamed Player##6", DamageMultiplier.Rifles.AllStreamedPlayer) end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:Button("| Snipers |") then slot5 = not slot5 end
                if slot5 then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Chance ##1227", DamageMultiplier.Snipers.Chance, 0, 100)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Multiplier ##7", DamageMultiplier.Snipers.Multiplier, 0, 15)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Delay ##12227", DamageMultiplier.Snipers.Delay, 0, 1000) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("All Streamed Player##7", DamageMultiplier.Snipers.AllStreamedPlayer) end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:Button("| Others |") then slot6 = not slot6 end
                if slot6 then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Chance ##1228", DamageMultiplier.Others.Chance, 0, 100)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Multiplier ##8", DamageMultiplier.Others.Multiplier, 0, 15)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Delay ##12228", DamageMultiplier.Others.Delay, 0, 1000) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("All Streamed Player##8", DamageMultiplier.Others.AllStreamedPlayer) end
            end
        --DamageChanger
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-25,SHAkMenu.menutransitor-25) 
            if Menu:Button("| Damage Changer |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                DamageChangerList = not DamageChangerList
                SHAkMenu.menuOpened = 0
            end
            if DamageChangerList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Damage Changer", DamageChanger.Enable)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##234", DamageChanger.OnKey)
                if DamageChanger.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("  ", DamageChanger.Key, 200, 20) end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                if Menu:Button("(?)##5") then
                    reindirectbutton = not reindirectbutton
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Give Damage")
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Pistols", DamageChanger.Give.Pistols.Enable)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##11",DamageChanger.Give.Pistols.DMG, 0, 2000)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Shotguns", DamageChanger.Give.Shotguns.Enable)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##22",DamageChanger.Give.Shotguns.DMG, 0, 2000)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("SMGs", DamageChanger.Give.SMGs.Enable)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##33",DamageChanger.Give.SMGs.DMG, 0, 2000)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Rifles", DamageChanger.Give.Rifles.Enable)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##44",DamageChanger.Give.Rifles.DMG, 0, 2000)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Snipers", DamageChanger.Give.Snipers.Enable)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##55",DamageChanger.Give.Snipers.DMG, 0, 2000)
                Menu:Text("")    
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Take Damage")
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Pistols ##1", DamageChanger.Take.Pistols.Enable)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##111",DamageChanger.Take.Pistols.DMG, 0, 2000)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Shotguns ##1", DamageChanger.Take.Shotguns.Enable)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##221",DamageChanger.Take.Shotguns.DMG, 0, 2000)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("SMGs ##1", DamageChanger.Take.SMGs.Enable)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##331",DamageChanger.Take.SMGs.DMG, 0, 2000)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Rifles ##1", DamageChanger.Take.Rifles.Enable)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##441",DamageChanger.Take.Rifles.DMG, 0, 2000)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Snipers ##1", DamageChanger.Take.Snipers.Enable)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderFloat("Damage##551",DamageChanger.Take.Snipers.DMG, 0, 2000)

                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:Button("| Get Current Weapon Max DMG |") then
                    WeaponDAMAGE = not WeaponDAMAGE
                end
                if WeaponDAMAGE == true  then
                    local WeaponID = Players:getPlayerWeapon(Players:getLocalID())
                    if WeaponID >= 22 and WeaponID <= 24 then 
                        DamageChanger.Give.Pistols.DMG.v = weaponInfo[WeaponID].damage
                        DamageChanger.Take.Pistols.DMG.v = weaponInfo[WeaponID].damage
                    elseif WeaponID >= 25 and WeaponID <= 27 then 
                        DamageChanger.Give.Shotguns.DMG.v = weaponInfo[WeaponID].damage
                        DamageChanger.Take.Shotguns.DMG.v = weaponInfo[WeaponID].damage
                    elseif WeaponID >= 28 and WeaponID <= 29 or WeaponID == 32 then 
                        DamageChanger.Give.SMGs.DMG.v = weaponInfo[WeaponID].damage
                        DamageChanger.Take.SMGs.DMG.v = weaponInfo[WeaponID].damage
                    elseif WeaponID >= 30 and WeaponID <= 31 then 
                        DamageChanger.Give.Rifles.DMG.v = weaponInfo[WeaponID].damage
                        DamageChanger.Take.Rifles.DMG.v = weaponInfo[WeaponID].damage
                    elseif WeaponID >= 33 and WeaponID <= 34 then 
                        DamageChanger.Give.Snipers.DMG.v = weaponInfo[WeaponID].damage
                        DamageChanger.Take.Snipers.DMG.v = weaponInfo[WeaponID].damage
                    elseif WeaponID >= 35 and WeaponID <= 38 then 
                        DamageChanger.Give.Rifles.DMG.v = weaponInfo[WeaponID].damage
                        DamageChanger.Take.Rifles.DMG.v = weaponInfo[WeaponID].damage
                    end
                    WeaponDAMAGE = false
                end
            end
        --Bullet Rebuff
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-13,SHAkMenu.menutransitor-13) 
            if Menu:Button("| Bullet Rebuff |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                Rebuff = not Rebuff
                SHAkMenu.menuOpened = 0
            end
            if Rebuff == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Rebuff", BulletRebuff.Enable)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Copy Weapon Category", BulletRebuff.SameWeapon)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Send Weapon Sync", BulletRebuff.SyncWeapon)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:SliderInt("Multiply Bullets", BulletRebuff.Bullets, 0, 10)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Ignore same Color##4", BulletRebuff.CList)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Force Players/Skins In Filters", BulletRebuff.Force)
            end
        --Others
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+5,SHAkMenu.menutransitor+2) 
            if Menu:Button("| Others |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                Others = not Others
                SHAkMenu.menuOpened = 0
            end
            if Others == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Auto +C", AimOT.AutoC.Enable)
                if AimOT.AutoC.Enable.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:Combo("C Type", AimOT.AutoC.Type, "Normal\0Don't Restore\0", 600)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Always Head", AimOT.AlwaysHead)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Fast Aim", AimOT.FastAim)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("NoReload CBug", AimOT.NoReloadCbug)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Crouchhook", AimOT.Crouchhook.Enable)
                if AimOT.Crouchhook.Enable.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##2213", AimOT.Crouchhook.OnKey)
                    if AimOT.Crouchhook.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                                ", AimOT.Crouchhook.Key, 200, 20) end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Hide Crosshair", AimOT.Crouchhook.HideCrosshair)
                    if AimOT.Crouchhook.HideCrosshair.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Restore Camera", AimOT.Crouchhook.RestoreCamera)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Not Crouching", AimOT.Crouchhook.NotCrouching)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Not Aiming", AimOT.Crouchhook.NotAiming)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Extra WS", AimOT.ExtraWS.Enable)
                if AimOT.ExtraWS.Enable.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey", AimOT.ExtraWS.OnKey)
                    if AimOT.ExtraWS.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("         ", AimOT.ExtraWS.Key, 200, 20) end
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                    if Menu:Button("(?)") then
                        reindirectbutton = not reindirectbutton
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:Combo("Type", AimOT.ExtraWS.Type, "Legit\0Normal\0", 600) then
                        Utils:writeMemory(0x5109AC, 0x7a, 1, false)
                        Utils:writeMemory(0x5109C5, 0x7a, 1, false)
                        Utils:writeMemory(0x5231A6, 0x75, 1, false)
                        Utils:writeMemory(0x52322D, 0x75, 1, false)
                        Utils:writeMemory(0x5233BA, 0x75, 1, false)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("X##2", AimOT.ExtraWS.X)
                    if AimOT.ExtraWS.Type.v == 0 then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+35,SHAkMenu.menutransitorstaticreversed+35) Menu:SliderFloat("Smooth ##232", AimOT.ExtraWS.Smooth.X, 1, 10)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Y##2", AimOT.ExtraWS.Y)
                    if AimOT.ExtraWS.Type.v == 0 then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+35,SHAkMenu.menutransitorstaticreversed+35) Menu:SliderFloat("Smooth  ", AimOT.ExtraWS.Smooth.Y, 1, 10)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Per Weapon Category", AimOT.ExtraWS.PerCategory.Enable)
                    if AimOT.ExtraWS.PerCategory.Enable.v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Pistols", AimOT.ExtraWS.PerCategory.Pistols)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Shotguns", AimOT.ExtraWS.PerCategory.Shotguns)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("SMGs", AimOT.ExtraWS.PerCategory.SMGs)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Rifles", AimOT.ExtraWS.PerCategory.Rifles)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Snipers", AimOT.ExtraWS.PerCategory.Snipers)
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Hide AttachObject While Sniper Aiming", AimOT.HideObjectWhileAiming)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Weapon Skill", AimOT.SetWeaponSkill) then
                    set.PlayerWeaponSkill()
                end
                if AimOT.SetWeaponSkill.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) if Menu:SliderInt("Level", AimOT.SetWeaponSkillLevel, 0, 999) then
                        set.PlayerWeaponSkill()
                    end
                end
            end
            Menu:Separator()
    else
        SilentList, DamagerList, Rebuff, AimAssists, DamageChangerList, Others = false
    end
end
return AimTab
    