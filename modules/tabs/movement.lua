local MovementTab = {}
function MovementTab.Mainloop()
--hFist
    if Movement.hFist.Enable.v then 
        if Global.hfistVar == nil then
            Global.hfistVar = 0
        end
        if Movement.hFist.Type.v == 0 then 
            if hFistTimer2 ~= nil then 
                if hFistTimer2.update(deltaTime) then
                    Utils:writeMemory(Global.CPlayerData+0x84, 0, 1, false)
                    hFistTimer2 = nil
                end
            end
            if hFistTimer ~= nil then 
                if hFistTimer.update(deltaTime) then
                    Utils:writeMemory(Global.CPlayerData+0x84, 1, 1, false)
                    hFistTimer2 = Timers(20)
                    hFistTimer = nil
                end
            end
            if Global.hfistVar ~= 53 and camMode == 4 then
                hFistTimer = Timers(75)
            end
            if Global.hfistVar ~= camMode then
                Global.hfistVar = camMode
            end
        elseif Movement.hFist.Type.v == 1 then 
            if hFistTimer ~= nil then 
                if hFistTimer.update(deltaTime) then
                    Utils:writeMemory(Global.CPlayerData+0x84, 0, 1, false)
                    hFistTimer = nil
                end
            end
            if Global.hfistVar < 5 and Global.runstate >= 6 then
                Utils:writeMemory(Global.CPlayerData+0x84, 1, 1, false)
                hFistTimer = Timers(5)
            end
            if Global.hfistVar ~= Global.runstate then
                Global.hfistVar = Global.runstate
            end
        else
            local weaponSlot = Utils:readMemory((0xB7CD98+0x4)+0x20, 1, false)
            if hFistTimer ~= nil then 
                if hFistTimer.update(deltaTime) then
                    Utils:writeMemory(Global.CPlayerData+0x84, 0, 1, false)
                    hFistTimer = nil
                end
            end
            if weaponSlot ~= Global.hfistVar then
                Utils:writeMemory(Global.CPlayerData+0x84, 1, 1, false)
                hFistTimer = Timers(25)
                Global.hfistVar = weaponSlot
            end
        end
    end
--Auto22
    if Movement.Auto22.Enable.v then
        if Movement.Auto22.OnKey.v and Utils:IsKeyDown(Movement.Auto22.Key.v) or not Movement.Auto22.OnKey.v then
            get.PlayerWeapons()
            local Weap = Players:getPlayerWeapon(Players:getLocalID())
            if Movement.Auto22.Type.v == 0 and not Utils:IsKeyDown(0x02) or Movement.Auto22.Type.v ~= 0 then
                if Weap == 26 and weaponInfo[Weap].clipammo < 4 and v.Auto22Saved == 0 then
                    SwitchTo = get.ChangeWeapon(26, false)
                    if Movement.Auto22.Type.v ~= 2 then
                        if weaponInfo[Weap].state == 0 and Movement.Auto22.Type.v == 1 or Movement.Auto22.Type.v ~= 1 then
                            set.ArmedWeapon(SwitchTo)
                            v.Auto22Saved = 1
                        end
                    else
                        v.Auto22Saved = 1
                    end
                end
            end
            if v.Auto22Saved == 1 then
                if Auto22Timer == nil then
                    Auto22Timer = Timers(math.random(tonumber(Movement.Auto22.SwitchVelocity[0].v), tonumber(Movement.Auto22.SwitchVelocity[1].v))+10)
                end
                if Auto22Timer.update(deltaTime) then
                    if Movement.Auto22.Type.v ~= 2 then
                        SwitchTo = get.ChangeWeapon(26, false)
                        set.ArmedWeapon(26)
                    else
                        set.WeaponAmmoClip(26, 4)
                    end
                    v.Auto22Saved = 0
                    Auto22Timer = nil
                end
            end
        end
    end
--NoFall // NoVehicleRam
    if vMy.OFData.sCurrentAnimationID >= 1128 and vMy.OFData.sCurrentAnimationID <= 1130 and vMy.OFData.sCurrentAnimationID ~= 1129 then
         NoFallTimer = -1
    end
--NoVehicleRam
    if Movement.NoRam.Enable.v then
        local vData = vMy.OFData
        if vData.Health ~= 0 then
            if vData.sCurrentAnimationID >= 1208 and vData.sCurrentAnimationID <= 1211 then
                if NoFallTimer == nil then
                    if NoRamTimer ~= nil then
                        if (NoRamTimer.update(deltaTime)) then
                            set.ClearPlayerAnimations()
                            NoRamTimer = nil
                        end
                    else
                        NoRamTimer = Timers(Movement.NoRam.Timer.v)
                    end
                end
            end
        end
    end
--NoFall
    if Movement.NoFall.Nodamage.v and Movement.NoFall.Enable.v then
        if Utils:readMemory(Global.CPedST+0x41, 1, false) ~= 2  then
            Utils:writeMemory(Global.CPedST+0x42, 16, 1, false)
        end
    end
    if vMy.OFData.sCurrentAnimationID == 1208 or vMy.OFData.sCurrentAnimationID == 1129 then
        if NoFallTimer == -1 then
            NoFallTimer = Timers(Movement.NoFall.Timer.v)
        elseif NoFallTimer ~= nil then
            if (NoFallTimer.update(deltaTime)) then
                if Movement.NoFall.Enable.v then
                    set.ClearPlayerAnimations()
                    NoFallTimer = nil
                end
            end
        end
    else
        if NoFallTimer ~= nil and NoFallTimer ~= -1 then NoFallTimer = nil end
    end
--Slide
    if Players:Driving(Players:getLocalID()) or Players:isDriver(Players:getLocalID()) then
        Global.canSlide = 0
    else
        if vMy.Health <= 0 then
            Timer.Slide[0] = 0
            Timer.Slide[1] = 0
            Global.Switch = -2
            Global.canSlide = 0
            if Global.Duration ~= 0 then
                Utils:writeMemory(0xB7CB64, 1.000001, 4, false)
                Global.Duration = 0
            end
        else
            local weap = Players:getPlayerWeapon(Players:getLocalID())
            if camMode ~= 4 then
                Global.FiredGun = weap
                Global.SlideWeapon = get.ChangeWeapon(Global.FiredGun, Movement.Slide.SearchForBestGun.v)
                Timer.Slide[0] = -1
            end
            local currentAnimationID = vMy.OFData.sCurrentAnimationID
            if (Movement.Slide.DesertEagle.v and Global.FiredGun == 24) or
                (Movement.Slide.SilencedPistol.v and Global.FiredGun == 23) or
                (Movement.Slide.Shotgun.v and Global.FiredGun == 25) or
                (Movement.Slide.CombatShotgun.v and Global.FiredGun == 27) or
                (Movement.Slide.Mp5.v and Global.FiredGun == 29) or
                (Movement.Slide.Ak47.v and Global.FiredGun == 30) or
                (Movement.Slide.M4.v and Global.FiredGun == 31) or
                (Movement.Slide.CountryRifle.v and Global.FiredGun == 33) or
                (Movement.Slide.SniperRifle.v and Global.FiredGun == 34) or
                (Movement.Slide.PerWeap.v == false)
            then
                if Timer.Slide[0] == -1 then
                    if Movement.Slide.AutoC.v then
                        if oldcam == nil then
                            oldcam = camMode
                        end
                        if oldcam ~= 4 and camMode == 4 then
                            Timer.GunC = 1
                        end
                        if Timer.GunC == 1 then
                            local crouch = Utils:readMemory(Global.CPedST + 0x46F, 1, false)
                            if crouch ~= 128 then
                                Timer.GunC = 0
                            end
                            if Movement.Slide.OnKey.v and Utils:IsKeyDown(Movement.Slide.Key.v) or not Movement.Slide.OnKey.v and Utils:readMemory(0xB73478, 1, false) == 255 then
                                Utils:emulateGTAKey(18, 255)
                                Timer.GunC = 0
                            end
                        end
                        if oldcam ~= camMode then
                            oldcam = camMode
                        end
                    end
                    if oldstate == nil then
                        oldstate = Global.runstate
                    end
                    if oldstate <= 4 and Global.runstate >= 6 then
                        Global.canSlide = 1
                    end
                    if oldstate ~= Global.runstate then
                        oldstate = Global.runstate
                    end
                end
            else
                Timer.Slide[0] = 0
                Timer.Slide[1] = 0
                Global.Switch = -2
                Global.canSlide = 0
            end
        end
    end
    if Movement.Slide.Enable.v then  
        if Global.canSlide == 1 then
            if Movement.Slide.OnKey.v and Utils:IsKeyDown(Movement.Slide.Key.v) or not Movement.Slide.OnKey.v then
                if not v.Chat and not v.Dialog then
                    if Timer.Slide[2] ~= 1 and Timer.Slide[0] < 2 then
                        if Movement.Slide.PerWeap.v and (Global.FiredGun == 25 or Global.FiredGun == 27 or Global.FiredGun == 30 or Global.FiredGun == 31 or Global.FiredGun == 33 or Global.FiredGun == 34) then
                            Global.SwitchVelocity[0] = math.random(tonumber(Movement.Slide.SwitchVelocity[2].v), tonumber(Movement.Slide.SwitchVelocity[3].v))
                            Global.SwitchVelocity[1] = Global.SwitchVelocity[0] + tonumber(Movement.Slide.SwitchVelocity[2].v) + math.random(2, 4)
                        else
                            Global.SwitchVelocity[0] = math.random(tonumber(Movement.Slide.SwitchVelocity[0].v), tonumber(Movement.Slide.SwitchVelocity[1].v))
                        end
                        Timer.Slide[2] = 1
                    end
                    if Global.canSlide == 1 then
                        Timer.Slide[0] = Timer.Slide[0] + 1
                    end
                end
            end
        end
        if Timer.Slide[0] > 1 then
            if not Players:Driving(Players:getLocalID()) and not Players:isDriver(Players:getLocalID()) then
                if Movement.Slide.SpeedEnable.v then
                    if SpeedChance == nil or SpeedChance ~= true and SpeedChance ~= false then
                        SpeedChance = maths.Chance(Movement.Slide.SpeedChance.v)
                    end
                    if Global.Duration < Movement.Slide.SpeedDuration.v and SpeedChance == true and get.isPlayerAlive(Players:getLocalID()) ~= false then
                        if (ms.update(deltaTime)) then
                            Global.Duration = Global.Duration + 1
                        end
                    end
                    if Global.Duration ~= 0 and Global.Duration < Movement.Slide.SpeedDuration.v and SpeedChance == true then
                        if Global.runstate == 4 or Global.runstate == 6 or Global.runstate == 7 then
                            Global.Speed = 1
                            if Movement.Slide.SpeedGameSpeed.v == 0 then
                                Utils:writeMemory(0xB7CB64, Movement.Slide.Speed.v+0.00001, 4, false)
                            else
                                Utils:writeMemory(0xB7CDB8, 10+Movement.Slide.Speed.v+0.00001, 4, false)
                            end
                        end
                    end
                end
                Global.canSlide = 0
                if (ms.update(deltaTime)) then
                    Global.Switch = Global.Switch + 1
                end
                if not Movement.Slide.OnKey.v and oldstate ~= 6 and oldstate ~= 7 or Movement.Slide.OnKey.v and not Utils:IsKeyDown(Movement.Slide.Key.v) then
                    if Global.Switch < Global.SwitchVelocity[0] then
                        Global.SwitchVelocity[0] = Global.Switch
                        Global.SwitchVelocity[1] = Global.SwitchVelocity[0] + 1
                    else
                        if Global.Switch < Global.SwitchVelocity[1] then
                            Global.SwitchVelocity[1] = Global.Switch + 1
                            v.cefini = Global.SwitchVelocity[1]
                        end
                    end
                end
                if Global.Switch > -1 and Global.Switch < 1 or 
                Global.Switch == Global.SwitchVelocity[1]+2 and weaponInfo[Global.FiredGun].twohanded and Movement.Slide.TripleSwitch.v then
                    Global.SlideWeapon = get.ChangeWeapon(Global.FiredGun, Movement.Slide.SearchForBestGun.v)
                    if Global.SlideWeapon ~= nil then
                        if Movement.Slide.PrioritizeFist1handedgun.v and not weaponInfo[Global.FiredGun].twohanded or
                        Movement.Slide.PrioritizeFist2handedgun.v and weaponInfo[Global.FiredGun].twohanded then
                            if Movement.Slide.SearchForBestGun.v then
                                set.ArmedWeapon(0)
                            else
                                Utils:emulateGTAKey(7, 255)
                            end
                        else
                            if Movement.Slide.SearchForBestGun.v then
                                set.ArmedWeapon(Global.SlideWeapon)
                            else
                                Utils:emulateGTAKey(7, 255)
                            end
                        end
                    end
                end
                if Global.Switch == Global.SwitchVelocity[0]+1 then
                    if Global.SlideWeapon ~= nil then
                        if Movement.Slide.SearchForBestGun.v == false then
                            Utils:emulateGTAKey(5, 255)
                        else
                            set.ArmedWeapon(Global.FiredGun)
                        end
                    end
                    if Movement.Slide.AnimBreaker.Enable.v then
                        FakeSlide = Timers(Movement.Slide.AnimBreaker.Duration.v)
                        for _, id in pairs(v.AnimBreaker) do
                            Utils:writeMemory(id.mem, 0x90, id.readsize, false)
                        end
                        Utils:writeMemory(Global.CPedST+0x470, 3, 1, false)
                    end
                end
                if Global.Switch > Global.SwitchVelocity[1]+5 then
                    Global.canSlide = 0
                    Timer.Slide[0] = 0
                end
                if Timer.Slide[1] == 1 then
                    Global.SwitchVelocity[0] = v.cefini;
                    v.cefini = 0;
                    Timer.Slide[1] = 0
                end
                Timer.Slide[2] = 0
            end
        else
            Global.Duration = 0
            if Global.Switch ~= -2 then
                Global.Switch = -2
            end
            if Timer.Slide[1] == 1 then
                if Global.SwitchVelocity[0] ~= v.cefini then
                    Global.SwitchVelocity[0] = v.cefini
                end
                if v.cefini ~= 0 then
                    v.cefini = 0
                end
                if Timer.Slide[1] ~= 0 then
                    Timer.Slide[1] = 0
                end
                Global.SpeedSlide = 0
            end
            Global.Duration = 0
            SpeedChance = -1
        end
    end
    if FakeSlide ~= nil then
        if (FakeSlide.update(deltaTime)) then
            for _, id in pairs(v.AnimBreaker) do
                Utils:writeMemory(id.mem, id.value, id.readsize, false)
            end
        end
    end
end
function MovementTab.PlayerSync()
--Sprinthook
    if Movement.Sprinthook.Enable.v then
        if(Timerss.update(deltaTime)) and not v.Chat and not v.Dialog and Global.runstate >= 4 then
            if Movement.Sprinthook.OnKey.v and Utils:IsKeyDown(Movement.Sprinthook.Key.v) or not Movement.Sprinthook.OnKey.v then
                if Global.Duration == 0 or Global.Duration >= Movement.Slide.SpeedDuration.v then
                    Utils:writeMemory(0xB7CDB8, Movement.Sprinthook.Velocity.v+0.00001, 4, false)
                end
            end
        end
    end
--Macro Run
    if KeyToggle.MacroRun.v == 1 then
        if not Players:Driving(Players:getLocalID()) and not Players:isDriver(Players:getLocalID()) or Global.Timer[0] > 1 then
            local hp = Players:getPlayerHP(Players:getLocalID())
            if Global.runstate == 7 then
                Global.IndTimer = Global.Timer[0]
            end
            if vMy.OFData.SpecialAction ~= 2 then
                if(Macro.update(deltaTime)) then
                    Global.Timer[0] = Global.Timer[0] + 1
                end
                if Movement.MacroRun.SpeedBasedOnHp.v then
                    if Global.Timer[0] > Global.RandSpeed then
                        if Movement.MacroRun.Key.v == 32 and Movement.MacroRun.OnKey.v or Utils:IsKeyDown(32) then
                            set.KeyState(0xB72D08, 255)
                            set.KeyState(0xb731e8, 255)
                        else
                            Utils:emulateGTAKey(16, 255)
                        end
                        if hp > 75 then
                            Global.RandSpeed = math.random(28,32)
                        end
                        if hp > 50 and hp < 75 then
                            Global.RandSpeed = math.random(20,28)
                        end
                        if hp > 25 and hp < 50 then
                            Global.RandSpeed = math.random(10,20)
                        end
                        if hp > 0 and hp < 25 then
                            Global.RandSpeed = math.random(1,10)
                        end
                        Global.Timer[0] = 0
                    else
                        if Movement.MacroRun.Key.v == 32 and Movement.MacroRun.OnKey.v or Utils:IsKeyDown(32) then
                            set.KeyState(0xB72D08, 0)
                            set.KeyState(0xb731e8, 0)
                        end
                    end
                end
                if Movement.MacroRun.Legit.v then
                    if Global.Timer[0] > Global.RandSpeed then
                        if Movement.MacroRun.Key.v == 32 and Movement.MacroRun.OnKey.v or Utils:IsKeyDown(32) then
                            set.KeyState(0xB72D08, 255)
                            set.KeyState(0xb731e8, 255)
                        else
                            Utils:emulateGTAKey(16, 255)
                        end
                        if Global.RandSpeed >= 1 and Global.RandSpeed <= 5 then
                            Global.RandSpeed = math.random(10,15)
                        elseif Global.RandSpeed >= 10 and Global.RandSpeed <= 15 then
                            Global.RandSpeed = math.random(1,5)
                        end
                        Global.Timer[0] = 0
                    else
                        if Movement.MacroRun.Key.v == 32 and Movement.MacroRun.OnKey.v or Utils:IsKeyDown(32) then
                            set.KeyState(0xB72D08, 0)
                            set.KeyState(0xb731e8, 0)
                        end
                    end
                end
                if Movement.MacroRun.Legit.v == false and Movement.MacroRun.SpeedBasedOnHp.v == false then
                    if Global.Timer[0] > Movement.MacroRun.Speed.v then
                        if Movement.MacroRun.Key.v == 32 and Movement.MacroRun.OnKey.v or Utils:IsKeyDown(32) then
                            set.KeyState(0xB72D08, 255)
                            set.KeyState(0xb731e8, 255)
                        else
                            Utils:emulateGTAKey(16, 255)
                        end
                        Global.Timer[0] = 0
                    else
                        if Movement.MacroRun.Key.v == 32 and Movement.MacroRun.OnKey.v or Utils:IsKeyDown(32) then
                            set.KeyState(0xB72D08, 0)
                            set.KeyState(0xb731e8, 0)
                        end
                    end
                end
            end
        end
    end
--Crouchhook
    if AimOT.Crouchhook.Enable.v then
        local CrouchKey = 0 
        local AimKey = 0 
        if AimOT.Crouchhook.NotCrouching.v then
            CrouchKey = Utils:readMemory(0xB7347C, 1, false)
        end
        if AimOT.Crouchhook.NotAiming.v then
            AimKey = Utils:readMemory(0xB73464, 1, false)
        end
        if CrouchKey == 0 and AimKey == 0 then
            local crouch = Utils:readMemory(Global.CPedST + 0x46F, 1, false)
            if crouch ~= 128 then
                if AimOT.Crouchhook.OnKey.v and Utils:IsKeyDown(AimOT.Crouchhook.Key.v) or not AimOT.Crouchhook.OnKey.v then
                    Utils:writeMemory(Global.CPedST + 0x46F, 128, 1, false)
                    if AimOT.NoReloadCbug.v then
                        local CWeapon = Global.CPedST + 0x5A0
                        local vMyWeapon = Players:getPlayerWeapon(Players:getLocalID())
                        local current_cweapon = CWeapon + (weaponInfo[vMyWeapon].slot) * 0x1C
                        Utils:writeMemory(current_cweapon + 4, 0, 4, false)
                    end
                    if AimOT.Crouchhook.HideCrosshair.v then
                        if AimOT.Crouchhook.RestoreCamera.v then
                            Utils:writeMemory(0xB6EC2E, 0, 1, false)
                        end
                        Utils:writeMemory(0x8D2E64, 0, 4, false)
                        Utils:writeMemory(0xB6F1A8, 4, 1, false)
                    end
                    if Utils:IsKeyDown(2) then
                        set.KeyState(0xB72D08, 255)
                        set.KeyState(0xb731e8, 255)
                        Utils:emulateGTAKey(16, 255)
                        set.KeyState(0xB72D08, 0)
                        set.KeyState(0xb731e8, 0)
                    end
                    RestoreCrouchhook = Timers(100)
                end
            end
        end
        if RestoreCrouchhook ~= nil then
            if(RestoreCrouchhook.update(deltaTime)) then
                Utils:writeMemory(0xB6EC2E, 1, 1, false)
                Utils:writeMemory(0x8D2E64, v.spread, 4, false)
                set.KeyState(0xB72D08, 0)
                set.KeyState(0xb731e8, 0)
                RestoreCrouchhook = nil
            end
        end
    end
--Double Jump
    if Doublejump.Enable.v then
        if Doublejump.OnKey.v and Utils:IsKeyDown(Doublejump.Key.v) or Doublejump.OnKey.v == false and Utils:IsKeyDown(16) then
            if not v.Chat and not v.Dialog then
                if Global.KeyPressed == 0 then
                    local bsData = BitStream()
                    bsWrap:WriteFloat(bsData, vMy.OFData.Speed.fX)
                    bsWrap:WriteFloat(bsData, vMy.OFData.Speed.fY)
                    bsWrap:WriteFloat(bsData, Doublejump.Height.v)
                    EmulRPC(90, bsData)
                    bsWrap:ResetWritePointer(bsData)
                    Global.KeyPressed = 1
                end
            end
        else
            if Global.KeyPressed ~= 0 then
                Global.KeyPressed = 0
            end
        end
    end
--AntiStun
    if Movement.AntiStun.Enable.v then
        if AntiStunTimer ~= nil then
            if (AntiStunTimer.update(deltaTime)) then
                v.KBDraw1 = 1
                v.StunCount = Movement.AntiStun.MinChance.v
                v.SmartStunCount = 0
            end
        end
        if Movement.AntiStun.AFK.v then
            if(vMy.OFData.Speed.fX == 0 and vMy.OFData.Speed.fY == 0 and vMy.OFData.Speed.fZ == 0) then
                Timer.AFK = Timers(500)
            else
                Timer.AFK = nil
            end
            if Timer.AFK ~= nil then
                if (Timer.AFK.update(deltaTime)) then
                    v.SniperProt = 1
                    Movement.AntiStun.On = 0
                end
            else
                v.SniperProt = 0
            end
        else
            v.SniperProt = 0
        end
        if(vMy.OFData.sCurrentAnimationID > 1070) and (vMy.OFData.sCurrentAnimationID < 1087) or (vMy.OFData.sCurrentAnimationID > 1172) and (vMy.OFData.sCurrentAnimationID < 1179 ) then
            if(v.StunTimer == 0) then
                if v.SniperProt ~= 1 then
                    v.KBDraw2 = 1
                    v.StunCount = v.StunCount + Movement.AntiStun.IncreaseMinChance.v
                    v.SmartStunCount = 0
                    v.StunTimer = 1
                    Movement.AntiStun.On = 0
                    AntiStunTimer = Timers(Movement.AntiStun.Timer.v)
                end
            end
        else
            v.StunTimer = 0
        end
        if(v.SniperProt == 1) then
            if v.SniperProtEnable ~= 1 then v.SniperProtEnable = 1 end
        else
            if v.SniperProtEnable ~= 0 then v.SniperProtEnable = 0 end
        end
        Timer.Indicator1 = Timer.Indicator1 + 1
        Timer.Indicator2 = Timer.Indicator2 + 1
        if Timer.Indicator1 > 250 then
            v.KBDraw1 = 0
            Timer.Indicator1 = 0
        end
        if Timer.Indicator2 > 250 then
            v.KBDraw2 = 0
            Timer.Indicator2 = 0
        end
        if v.StunCount > 99 then
            v.StunCount = 100
        end
        if v.StunCount > Movement.AntiStun.MinChance.v then
            v.SmartStunCount = v.SmartStunCount + 1
        end
        if v.StunCount < Movement.AntiStun.MinChance.v then
            v.StunCount = Movement.AntiStun.MinChance.v
        end
        if Movement.AntiStun.Chance == true and v.SniperProt ~= 1 then
            Movement.AntiStun.SaveDamageHP = vMy.OFData.Health
            Movement.AntiStun.SaveDamageAR = vMy.OFData.Armor
            if KeyToggle.GodmodePlayer.v == 1 or KeyToggle.GodmodePlayer.v == 1 and Godmode.Player.Bullet.v == false then
                if Movement.AntiStun.On == 0 then  
                    memory.CPed.God = Utils:readMemory(Global.CPedST+0x42, 1, false)
                    Utils:writeMemory(Global.CPedST+0x42, memory.CPed.God+4, 1, false)
                    Movement.AntiStun.On = 1
                end
            end
        else
            if KeyToggle.GodmodePlayer.v == 1 or KeyToggle.GodmodePlayer.v == 1 and Godmode.Player.Bullet.v == false then
                if Movement.AntiStun.On == 1 then
                    memory.CPed.God = Utils:readMemory(Global.CPedST+0x42, 1, false)
                    Utils:writeMemory(Global.CPedST+0x42, memory.CPed.God-4, 1, false)
                    Movement.AntiStun.On = 0
                end
            end
        end
    end
--FakeLag Peek
    if Movement.FakeLagPeek.Enable.v then
        local vMyPos = Players:getBonePosition(Players:getLocalID(), 8)
        vMy.NearestWall4FakeLag = get.nearwall(vMyPos, Movement.FakeLagPeek.DistanceFromWall.v)
        if Movement.FakeLagPeek.AtTarget.v then 
            get.NearestPlayersFromScreen()
            for i, _ in pairs(players.id) do
                if Players:isPlayerStreamed(i) then
                    if Players:getPlayerTarget(Movement.FakeLagPeek.Fov.v*20) == i then
                        local vEnPos = Players:getPlayerPosition(i)
                        if Utils:IsLineOfSightClear(vMyPos, vEnPos, true, true ,false, true, false, false, false) == false then
                            if vMy.NearestWall4FakeLag then
                                if v.TargetFakeLag == i then
                                    Global.DesyncDelay = 0
                                    Global.DesyncTimer = 0
                                    Movement.FakeLagPeek.Ready[i] = -1
                                    v.TargetFakeLag = -1
                                else
                                    Movement.FakeLagPeek.Ready[i] = i
                                end
                            end
                        else
                            if Movement.FakeLagPeek.Ready[i] == i then
                                if Global.DesyncTimer == 0 then
                                    FakeLagTimer = Timers(Movement.FakeLagPeek.Time.v)
                                    FakeLagDelay = Timers(Movement.FakeLagPeek.Delay.v)
                                    Global.DesyncTimer = 1
                                    Global.DesyncDelay = 1
                                    v.TargetFakeLag = i
                                end
                                Movement.FakeLagPeek.Ready[i] = -1
                            end
                        end
                    else
                        if Players:getPlayerTarget(Movement.FakeLagPeek.Fov.v*20) == -1 then
                            Global.DrawWall = 0
                            v.TargetFakeLag = 1
                            Global.DesyncTimer = 0
                            Global.DesyncDelay = 0
                            
                            Movement.FakeLagPeek.Ready[i] = -1
                        end
                    end
                end
            end
        else
            if vMy.NearestWall4FakeLag == true then
                if v.TargetFakeLag ~= 1 then  v.TargetFakeLag = 1 end
                if Global.DesyncTimer ~= 0 then Global.DesyncTimer = 0 end
                if Global.DesyncDelay ~= 0 then Global.DesyncDelay = 0 end
            else
                if v.TargetFakeLag == 1 then
                    if Global.DesyncTimer == 0 then
                        Global.DesyncTimer = 1
                        Global.DesyncDelay = 1
                        FakeLagTimer = Timers(Movement.FakeLagPeek.Time.v)
                        FakeLagDelay = Timers(Movement.FakeLagPeek.Delay.v)
                    end
                    if v.TargetFakeLag ~= -1 then v.TargetFakeLag = -1 end
                end
            end
        end
    end
--Skin
    if Movement.ForceSkin.Enable.v and Movement.ForceSkin.Skin.v ~= Players:getPlayerSkin(Players:getLocalID()) then
        set.ClearPlayerAnimations()
        set.PlayerSkin(Movement.ForceSkin.Skin.v)
        set.ClearPlayerAnimations()
    end 
end
function MovementTab.Visual()
--Draw Fakelag Wall
    if Movement.FakeLagPeek.Enable.v and not Players:Driving(Players:getLocalID()) and not Players:isDriver(Players:getLocalID()) then
        if Movement.FakeLagPeek.DrawWalls.v then
            if Global.DrawWall ~= 0 and v.WaitForPickLag == 0 then
                local vMyPos = Players:getBonePosition(Players:getLocalID(), 8)
                Utils:GameToScreen(vMyPos, vMyScreen)
                Utils:GameToScreen(Global.DrawWall, vEnScreen)
                if vEnScreen.fZ > 1 then
                    Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 20, true, 0x899966f0)
                    Render:DrawLine(vMyScreen.fX,vMyScreen.fY,vEnScreen.fX,vEnScreen.fY,0xF99966f0)
                end
                if Movement.FakeLagPeek.AtTarget.v then
                    Render:DrawCircle(vecCrosshair.fX, vecCrosshair.fY, Movement.FakeLagPeek.Fov.v*20, true, 0x299966f0)
                end
            end
        end
    end
end
function MovementTab.Menu()
    if SHAkMenu.Menu.v == 2 then
        SHAkMenu.resetMenuTimer(SHAkMenu.Menu.v)
        --Player
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+7,SHAkMenu.menutransitor+7) 
            if Menu:Button("| Player |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                Playerss = not Playerss
                SHAkMenu.menuOpened = 0
            end
            if Playerss == true then
                if m_offsets.m_samp_info[v.SampVer] ~= 0 then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("bUseCJWalk", Movement.bUseCJWalk) then
                        set.CJWalk()
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("RunningPatch", Movement.RunEverywhere) then
                    if Movement.RunEverywhere.v then
                        Utils:writeMemory(0x55E874, 4, 2, false)
                    else
                        Utils:writeMemory(0x55E874, 1165, 2, false)
                    end
                end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+55,SHAkMenu.menutransitorstaticreversed+55) 
                if Menu:Button("(?)") then
                    InfoButton = not InfoButton
                end
                if InfoButton == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                    Menu:Text("Able to run in any surface")
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Heavy Fist undetected", Movement.hFist.Enable)
                if Movement.hFist.Enable.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:Combo("        ",Movement.hFist.Type,"CamMode Change\0Start run\0Weapon Change\0\0",8) then
                        Utils:writeMemory(Global.CPlayerData+0x84, 1, 1, false)
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Force Skin", Movement.ForceSkin.Enable)
                if Movement.ForceSkin.Enable.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderInt("ID", Movement.ForceSkin.Skin, 0, 311)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("No Vehicle Ram", Movement.NoRam.Enable)
                if Movement.NoRam.Enable.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderInt("Timer##0", Movement.NoRam.Timer, 1, 1000)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("No Fall", Movement.NoFall.Enable)
                if Movement.NoFall.Enable.v then
                     Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderInt("Timer##1", Movement.NoFall.Timer, 1, 1000)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("No Damage", Movement.NoFall.Nodamage)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Sprinthook", Movement.Sprinthook.Enable)
                if Movement.Sprinthook.Enable.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey", Movement.Sprinthook.OnKey)
                    if Movement.Sprinthook.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                           ", Movement.Sprinthook.Key, 200, 20) end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("Velocity", Movement.Sprinthook.Velocity, 0.1, 50)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Change Fight Style", Movement.Fight)
                if Movement.Fight.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:Combo("  ",Movement.FightStyle,"NORMAL\0BOXING\0KUNGFU\0KNEEHEAD\0GRABKICK\0ELBOW\0\0",8)
                    if Movement.Fight.v then
                        set.FightStyle()
                    end
                end
            else
                InfoButton = false
            end
        --Macros
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+5,SHAkMenu.menutransitor+2) 
            if Menu:Button("| Macros |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                MacrosList = not MacrosList
                SHAkMenu.menuOpened = 0
            end
            if MacrosList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                Menu:CheckBox("Macro Run", Movement.MacroRun.Enable)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey ##12312", Movement.MacroRun.OnKey)
                if Movement.MacroRun.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                          ", Movement.MacroRun.Key, 200, 20) end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                if Menu:Button("(?)") then
                    reindirectbutton = not reindirectbutton
                end
                if Movement.MacroRun.SpeedBasedOnHp.v == false then 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)  Menu:CheckBox2("Run Legit", Movement.MacroRun.Legit)
                end
                if Movement.MacroRun.Legit.v and Movement.MacroRun.SpeedBasedOnHp.v then
                    Movement.MacroRun.Legit.v = false Movement.MacroRun.SpeedBasedOnHp.v = false 
                end
                if Movement.MacroRun.Legit.v == false and Movement.MacroRun.SpeedBasedOnHp.v == false then
                    Menu:PushItemWidth(125)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+20,SHAkMenu.menutransitorstaticreversed+20) Menu:Text("  Run Velocity")
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) if Menu:SliderInt("                                                        ", Movement.MacroRun.Speed, 1, 500) then
                        get.ScriptTimers()
                    end
                end
                if Movement.MacroRun.Legit.v == false then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) 
                    Menu:CheckBox2("Velocity Based on HP", Movement.MacroRun.SpeedBasedOnHp)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)  Menu:CheckBox2("Bypass",Movement.MacroRun.Bypass)
            end
        --Auto 2-2
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+2,SHAkMenu.menutransitor) 
            if Menu:Button("| Auto 2-2 |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                auto22 = not auto22
                SHAkMenu.menuOpened = 0
            end
            if auto22 == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Auto 2-2", Movement.Auto22.Enable)
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type##25",Movement.Auto22.Type,"Legit\0Faster\0Dont Switch\0\0",25) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey ##2131", Movement.Auto22.OnKey)
                if Movement.Auto22.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                         ", Movement.Auto22.Key, 200, 20) end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                if Menu:Button("(?)") then
                    reindirectbutton = not reindirectbutton
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:Text("      Min. Velocity") 
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+67, SHAkMenu.menutransitorstaticreversed+66) Menu:Text("  Max. Velocity")
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("  ##55556", Movement.Auto22.SwitchVelocity[0], 0, Movement.Auto22.SwitchVelocity[1].v) 
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65, SHAkMenu.menutransitorstaticreversed+65) Menu:SliderInt("   ##5555", Movement.Auto22.SwitchVelocity[1], Movement.Auto22.SwitchVelocity[0].v, 200)
                if Movement.Auto22.SwitchVelocity[0].v > Movement.Auto22.SwitchVelocity[1].v then
                    Movement.Auto22.SwitchVelocity[0].v = Movement.Auto22.SwitchVelocity[1].v
                end
            end
        --Slide
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+12,SHAkMenu.menutransitor+9) 
            if Menu:Button("| Slide |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                SlideList = not SlideList
                SHAkMenu.menuOpened = 0
            end
            if SlideList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Slide-Master", Movement.Slide.Enable)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey", Movement.Slide.OnKey)
                if Movement.Slide.OnKey.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                        ", Movement.Slide.Key, 200, 20)
                end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+50,SHAkMenu.menutransitorstaticreversed+50) 
                if Menu:Button("(?)") then
                    reindirectbutton = not reindirectbutton
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Search For Best Gun ##2131", Movement.Slide.SearchForBestGun)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) 
                Menu:CheckBox2("Weapon Detection",Movement.Slide.PerWeap)
                if Movement.Slide.PerWeap.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10)
                    if Menu:Button("| Weapon List |") then
                        WeaponList = not WeaponList
                    end
                    if WeaponList == true then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Silenced-Pistol",Movement.Slide.SilencedPistol)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Desert-Eagle",Movement.Slide.DesertEagle)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Shotgun",Movement.Slide.Shotgun)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Combat Shotgun",Movement.Slide.CombatShotgun)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("MP5",Movement.Slide.Mp5)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("AK47",Movement.Slide.Ak47)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("M4",Movement.Slide.M4)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Country Rifle",Movement.Slide.CountryRifle)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Sniper Rifle",Movement.Slide.SniperRifle)
                    end
                else
                    WeaponList = false
                end
                Menu:PushItemWidth(100)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)
                    if Movement.Slide.PerWeap.v then
                        if Menu:Button("| One Handed Gun |") then
                            handedgun = not handedgun
                        end
                    end
                    if handedgun == true or Movement.Slide.PerWeap.v == false then
                        if Movement.Slide.SearchForBestGun.v then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Prioritize Fist ##1", Movement.Slide.PrioritizeFist1handedgun)
                        end
                        if handedgun == true or Movement.Slide.PerWeap.v == false then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:Text("     Min. Velocity") 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+67, SHAkMenu.menutransitorstaticreversed+66) Menu:Text("  Max. Velocity")
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("  ", Movement.Slide.SwitchVelocity[0], 0, Movement.Slide.SwitchVelocity[1].v) 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65, SHAkMenu.menutransitorstaticreversed+65) Menu:SliderInt("   ", Movement.Slide.SwitchVelocity[1], Movement.Slide.SwitchVelocity[0].v, 10)
                            if Movement.Slide.SwitchVelocity[0].v > Movement.Slide.SwitchVelocity[1].v then
                                Movement.Slide.SwitchVelocity[0].v = Movement.Slide.SwitchVelocity[1].v
                            end
                        end
                    end
                if Movement.Slide.PerWeap.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)
                    if Menu:Button("| Two Handed Gun |") then
                        handedsgun = not handedsgun
                    end 
                    if handedsgun == true then
                        if Movement.Slide.SearchForBestGun.v then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Prioritize Fist ##2", Movement.Slide.PrioritizeFist2handedgun)
                        end
                        if handedsgun == true then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:Text("     Min. Velocity")
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+67, SHAkMenu.menutransitorstaticreversed+66) Menu:Text("  Max. Velocity")
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10, SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("     ", Movement.Slide.SwitchVelocity[2], 0, Movement.Slide.SwitchVelocity[3].v) 
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65, SHAkMenu.menutransitorstaticreversed+65) Menu:SliderInt("      ", Movement.Slide.SwitchVelocity[3], Movement.Slide.SwitchVelocity[2].v, 10)
                            if Movement.Slide.SwitchVelocity[2].v > Movement.Slide.SwitchVelocity[3].v then
                                Movement.Slide.SwitchVelocity[2].v = Movement.Slide.SwitchVelocity[3].v
                            end
                        end
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Triple Switch (Heavy Guns)", Movement.Slide.TripleSwitch)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Auto C", Movement.Slide.AutoC)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Slide Speed", Movement.Slide.SpeedEnable)
                if Movement.Slide.SpeedEnable.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Fake Sync", Movement.Slide.SpeedFakeSync)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("Speed", Movement.Slide.Speed, 1.000, 5)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Chance", Movement.Slide.SpeedChance, 1, 100)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Duration", Movement.Slide.SpeedDuration, 5, 50)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:Combo("Type",Movement.Slide.SpeedGameSpeed,"Gamespeed\0FastRun\0\0",1)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Anim Breaker", Movement.Slide.AnimBreaker.Enable)
                if Movement.Slide.AnimBreaker.Enable.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Duration ", Movement.Slide.AnimBreaker.Duration, 100, 400)
                end
            end
        --FakeLag
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor,SHAkMenu.menutransitor) 
            if Menu:Button("| FakeLag |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                FakeLagList = not FakeLagList
                SHAkMenu.menuOpened = 0
            end
            if FakeLagList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("FakeLag On Peek", Movement.FakeLagPeek.Enable)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:SliderInt("Distance From Wall", Movement.FakeLagPeek.DistanceFromWall, 1, 5)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("At Target", Movement.FakeLagPeek.AtTarget)
                if Movement.FakeLagPeek.AtTarget.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10)Menu:SliderFloat("Field Of View", Movement.FakeLagPeek.Fov, 0, 60) 
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:SliderInt("Desync Delay", Movement.FakeLagPeek.Delay, 1, 500)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:SliderInt("FakeLag Time", Movement.FakeLagPeek.Time, 1, 500)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:CheckBox2("Draw Wall", Movement.FakeLagPeek.DrawWalls)
            end
        --AntiStun
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor,SHAkMenu.menutransitor) 
            if Menu:Button("| AntiStun |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                AntiStunList = not AntiStunList
                SHAkMenu.menuOpened = 0
            end
            if AntiStunList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Smart AntiStun", Movement.AntiStun.Enable)
                Menu:PushItemWidth(100)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed-5, SHAkMenu.menutransitorstaticreversed) Menu:Text("  Minimum Chance") 
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+116, SHAkMenu.menutransitorstaticreversed) Menu:Text("  Reset After Time")
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+237, SHAkMenu.menutransitorstaticreversed) Menu:Text("Increase After Stun")
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed, SHAkMenu.menutransitorstaticreversed) if Menu:SliderInt("       ", Movement.AntiStun.MinChance, 0, 100) then
                    v.StunCount = Movement.AntiStun.MinChance.v
                end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60, SHAkMenu.menutransitorstaticreversed+60) Menu:SliderInt("        ", Movement.AntiStun.Timer, 1, 10000)
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+120, SHAkMenu.menutransitorstaticreversed+120) Menu:SliderInt("             ", Movement.AntiStun.IncreaseMinChance, 0, 100)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("AntiStun AFK Check", Movement.AntiStun.AFK)
            end
        --Jump
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+9,SHAkMenu.menutransitor+7) 
            if Menu:Button("| Jump |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                JumpList = not JumpList
                SHAkMenu.menuOpened = 0
            end
            if JumpList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Jump", Doublejump.Enable)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey ##198233", Doublejump.OnKey)
                if Doublejump.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("  ", Doublejump.Key, 200, 20) end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:SliderFloat("Height", Doublejump.Height, 0.1, 1)
            end
            Menu:Separator()
    else
        AntiStunList, FakeLagList, SlideList, MacrosList, JumpList, Playerss = false
    end
end
return MovementTab