local VehicleTab = {}
function VehicleTab.DriveSync()
--Wheelies Size
     if Vehicle.Wheel.Enable.v then
        local Size = Utils:readMemory(Global.CVehicleST+0x458, 4, false)
        local bsData = BitStream()
        bsWrap:Reset(bsData)
        bsWrap:Write32(bsData, Size)
        Size = bsWrap:ReadFloat(bsData)
        if Size ~= Vehicle.Wheel.Size.v+0.00001 then
            Utils:writeMemory(Global.CVehicleST+0x458, Vehicle.Wheel.Size.v+0.00001, 4, false)
        end
    end
--AntiCarFlip
    if Vehicle.AntiCarFlip.v then
        local Angle = math.atan((vehicles.Quats.w * vehicles.Quats.w) - (vehicles.Quats.x * vehicles.Quats.x) - (vehicles.Quats.y * vehicles.Quats.y) + (vehicles.Quats.z * vehicles.Quats.z))
        memory.CVehicle.Surface = Utils:readMemory(Global.CVehicleST+0x41, 1, false)
        
        if vMy.ICData.VehicleID ~= 0 and Angle < -0.1 and memory.CVehicle.Surface == 2 then
            local deltaX = (vMy.ICData.Speed.fX-vMy.ICData.Pos.fX)+vMy.ICData.Pos.fX
            local deltaY = (vMy.ICData.Speed.fY-vMy.ICData.Pos.fY)+vMy.ICData.Pos.fY
            local radians = math.atan2(deltaY, deltaX)
            local degrees = (radians * 180) / math.pi - 90
            local bsDatas = BitStream()
            bsWrap:Write16(bsDatas, vMy.ICData.VehicleID) 
            bsWrap:WriteFloat(bsDatas, degrees)
            EmulRPC(160, bsDatas)
        end
    end
--FastStop
    if Vehicle.FastStop.Enable.v then
        if Utils:IsKeyDown(Vehicle.FastStop.Key.v) then
            Utils:writeMemory(Global.CVehicleST + 0x44, 0, 4, false)
            Utils:writeMemory(Global.CVehicleST + 0x48, 0, 4, false)
            Utils:writeMemory(Global.CVehicleST + 0x4C, 0, 4, false)
        end
    end
--PerfectHandling
    if Vehicle.PerfectHandling.v then
        memory.CVehicle.PerfectHandling = Utils:readMemory(0x96914C, 1, false)
        if Vehicle.PerfectHandlingOnKey.v then
            if Utils:IsKeyDown(Vehicle.PerfectHandlingKey.v) and not v.Chat and not v.Dialog then
                if memory.CVehicle.PerfectHandling == 0 then
                    Utils:writeMemory(0x96914C, 1, 1, false)
                end
            else
                if memory.CVehicle.PerfectHandling == 1 then
                    Utils:writeMemory(0x96914C, 0, 1, false)
                end
            end
        else
            if memory.CVehicle.PerfectHandling == 0 then
                Utils:writeMemory(0x96914C, 1, 1, false)
            end
        end 
    else
        if memory.CVehicle.PerfectHandling ~= 0 then
            Utils:writeMemory(0x96914C, 0, 1, false)
        end
    end
--InfinityNitrous
    if Vehicle.InfinityNitrous.v then
        local bsData = BitStream()
        if Utils:IsKeyChecked(1, 0) or Utils:IsKeyChecked(17, 0) then
            if Vehicle.InfinityNitrousType.v == 0 then 
                bsWrap:Write16(bsData, 65535)
                bsWrap:Write32(bsData, 2)
                bsWrap:Write32(bsData, Players:getVehicleID(Players:getLocalID()))
                bsWrap:Write32(bsData, 1010)
                EmulRPC(96,bsData)
            else
                Utils:writeMemory(0x969165, 1, 1, false)
            end
        else
            if Utils:IsKeyDown(1) == false and Utils:IsKeyDown(17) == false then
                bsWrap:Write16(bsData, Players:getVehicleID(Players:getLocalID()))
                bsWrap:Write16(bsData, 1010)
                EmulRPC(57,bsData)
                if Vehicle.InfinityNitrousType.v ~= 0 then 
                    Utils:writeMemory(0x969165, 0, 1, false)
                end
            end
        end
    end
end
function VehicleTab.Menu()
    if SHAkMenu.Menu.v == 3 then
        SHAkMenu.resetMenuTimer(SHAkMenu.Menu.v)
        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+3,SHAkMenu.menutransitor+3) 
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:Button("| Set Hydraulics |") then
                local vehicleid = Players:getVehicleID(Players:getLocalID())
                local bsData = BitStream()
                bsWrap:Reset(bsData)
                bsWrap:Write16(bsData, 65535)
                bsWrap:Write32(bsData, 2)
                bsWrap:Write32(bsData, vehicleid)
                bsWrap:Write32(bsData, 1087)
                EmulRPC(96,bsData)
            end
            --if Players:isDriver(Players:getLocalID()) then
                local Car = Cars:getCarModel(Players:getVehicleID(Players:getLocalID()))
                if Car == nil then
                    Car = 0
                end
                if Car ~= 0 then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:Button("| Change Model |") then
                        local vehicleId = Players:getVehicleID(Players:getLocalID())
                        send.CreateVehicle(vehicleId, Vehicle.Model.v, Players:getPlayerPosition(Players:getLocalID()).fX, Players:getPlayerPosition(Players:getLocalID()).fY, Players:getPlayerPosition(Players:getLocalID()).fZ, math.random(0, 255), math.random(0, 255))
                    end
                end
                if Vehicle.Model.v == 0 then
                    Vehicle.Model.v = Car
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:Text("VehicleID: "..Car)
                if Car ~= 0 then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Text("Name: "..vehicleInfo[Car].name)

                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("ID",Vehicle.Model, 400, 611)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:Text("Name: "..vehicleInfo[Vehicle.Model.v].name)
                end

            --else
            --    Vehicle.Model.v = 0
            --end


            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Drive No License", Vehicle.DriveNoLicense)
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Dont Send EnterVehicle", Vehicle.DriveNoLicenseFakeData)
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Fast Exit", Vehicle.FastExit.Enable)
            if Vehicle.FastExit.Enable.v then
                if Vehicle.FastExit.Type.v == 0 then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderInt("Delay##23",Vehicle.FastExit.Delay, 100, 1000)
                end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:Combo("Exit Type##23",Vehicle.FastExit.Type,"Legit\0Faster\0\0",25) 
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Fast Enter", Vehicle.FastEnter.Enable)
            if Vehicle.FastEnter.Enable.v then
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderInt("Delay##24",Vehicle.FastEnter.Delay, 100, 1000)
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Fast Stop", Vehicle.FastStop.Enable)
            if Vehicle.FastStop.Enable.v then
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                       ", Vehicle.FastStop.Key, 200, 20)
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Change Wheel Size", Vehicle.Wheel.Enable)
            if Vehicle.Wheel.Enable.v then
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+95,SHAkMenu.menutransitorstaticreversed+95) Menu:SliderFloat("Size",Vehicle.Wheel.Size, 0, 5)
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Hydra Thrust", Vehicle.Hydra.Thrust.Enable)
            if Vehicle.Hydra.Thrust.Enable.v then
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("##2323 ", Vehicle.Hydra.Thrust.Key, 200, 20)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15)Menu:SliderInt("Speed##22", Vehicle.Hydra.Thrust.Speed, 1, 1000)
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Hydra Fast Lock On", Vehicle.Hydra.FastLock.Lock) then
                set.HydraLockOnDelay(Vehicle.Hydra.FastLock.Lock.v, Vehicle.Hydra.FastLock.Visual.v)
            end
            if Vehicle.Hydra.FastLock.Lock.v then
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+95,SHAkMenu.menutransitorstaticreversed+95) if Menu:SliderInt("Delay##33", Vehicle.Hydra.FastLock.LockDelay, 1, 1000) then
                    set.HydraLockOnDelay(Vehicle.Hydra.FastLock.Lock.v, Vehicle.Hydra.FastLock.Visual.v)
                end
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Hydra Fast Lock On Visual", Vehicle.Hydra.FastLock.Visual) then
                set.HydraLockOnDelay(Vehicle.Hydra.FastLock.Lock.v, Vehicle.Hydra.FastLock.Visual.v)
            end
            if Vehicle.Hydra.FastLock.Visual.v then
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+95,SHAkMenu.menutransitorstaticreversed+95) if Menu:SliderInt("Delay##44", Vehicle.Hydra.FastLock.VisualDelay, 1, 1000) then
                    set.HydraLockOnDelay(Vehicle.Hydra.FastLock.Lock.v, Vehicle.Hydra.FastLock.Visual.v)
                end
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Anti CarJack", Vehicle.AntiCarJack)
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Anti Flip", Vehicle.AntiCarFlip)
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Anti Fire Explosion", Vehicle.AntiFireExplosion) then
                set.FireExplosionState()
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Never Pop Tires", Vehicle.NeverPopTire.Enable) then
                set.VehicleTiresNop()
            end
            if Vehicle.NeverPopTire.Enable.v then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) if Menu:CheckBox2("Bullets", Vehicle.NeverPopTire.Bullets) then
                    set.VehicleTiresNop()
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Server UpdateVehicleDamage", Vehicle.NeverPopTire.Server)
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Infinity Nitrous", Vehicle.InfinityNitrous)
            if Vehicle.InfinityNitrous.v then
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Nitrous Type",Vehicle.InfinityNitrousType,"Normal\0Invisible\0\0",25) 
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Boat Fly", Vehicle.BoatFly) then
                if Vehicle.BoatFly.v then
                    Utils:writeMemory(0x969153, 1, 1, false)
                    Utils:writeMemory(0x969160, 1, 1, false)
                else
                    Utils:writeMemory(0x969153, 0, 1, false)
                    Utils:writeMemory(0x969160, 0, 1, false)
                end
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Potato Cars", Vehicle.PotatoCars) then
                if Vehicle.PotatoCars.v then
                    if Vehicle.PotatoType.v == 0 then
                        Utils:writeMemory(0x52C9EE, 1, 1, false)
                        Utils:writeMemory(0x96914B, 0, 1, false)
                    else
                        Utils:writeMemory(0x96914B, 1, 1, false)
                        Utils:writeMemory(0x52C9EE, 0, 1, false)
                    end
                else
                    Utils:writeMemory(0x96914B, 0, 1, false)
                    Utils:writeMemory(0x52C9EE, 0, 1, false)
                end
            end
            if Vehicle.PotatoCars.v then
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("CarType",Vehicle.PotatoType,"Potato\0Only Wheels\0\0",25)
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Perfect Handling", Vehicle.PerfectHandling)
            if Vehicle.PerfectHandling.v then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("On Key##2", Vehicle.PerfectHandlingOnKey)
                if Vehicle.PerfectHandlingKey.v then 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                      ", Vehicle.PerfectHandlingKey, 200, 20)
                end
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Anti Deattach Trailer", Vehicle.AutoAttachTrailer)
            if Vehicle.AutoAttachTrailer.v then
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+75,SHAkMenu.menutransitorstaticreversed+75) Menu:SliderInt("Delay##231", Vehicle.AutoAttachDelay, 1, 10000)
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Freeze Rotation", Vehicle.FreezeRot)
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Bicycle Spam", Vehicle.Bicycle.Enable)
            if Vehicle.Bicycle.Enable.v then
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65)Menu:SliderInt("Delay##2", Vehicle.Bicycle.Delay, 1, 20)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey ##12313", Vehicle.Bicycle.OnKey)
                if Vehicle.Bicycle.OnKey.v then 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                     ", Vehicle.Bicycle.Key, 200, 20) 
                end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                if Menu:Button("(?)") then
                    reindirectbutton = not reindirectbutton
                end
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Bike Spam", Vehicle.Bike.Enable)
            if Vehicle.Bike.Enable.v then
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65)Menu:SliderInt("Delay##3", Vehicle.Bike.Delay, 1, 20)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey ##12312", Vehicle.Bike.OnKey)
                if Vehicle.Bike.OnKey.v then 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                      ", Vehicle.Bike.Key, 200, 20) 
                end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                if Menu:Button("(?) ") then
                    reindirectbutton = not reindirectbutton
                end
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Auto Unlock Vehicles", Vehicle.Unlock)
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Never Off Engine", Vehicle.NeverOffEngine)
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("No Collision To Other Vehicles (With Players)", Vehicle.NoCarCollision)
            if Vehicle.NoCarCollision.v then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                    ", Vehicle.NoCarCollisionKey, 200, 20)
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Recover Over Time", Vehicle.Recovery)
            if Vehicle.Recovery.v then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Recover Parts at Max HP", Vehicle.RecoverParts)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15)Menu:SliderInt("Delay", Vehicle.ChosenTimer, 1, 1000)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15)Menu:SliderFloat("HP Amount", Vehicle.HPAmount, 1, 200.0)
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Limit Velocity", Vehicle.LimitVelocity)
            if Vehicle.LimitVelocity.v then
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:Combo("Type##2",Vehicle.LimitType,"ClientSide\0ServerSide\0\0",6)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Limit at Vehicle Top Speed", Vehicle.SmartLimitMaxVelocity)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:SliderInt("Velocity KM/H", Vehicle.Velocity, 0, 300)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("On Key##4", Vehicle.LimitVelocityOnKey)
                if Vehicle.LimitVelocityOnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                   ", Vehicle.LimitVelocityKey, 200, 20) end
            end
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Car Jump", Vehicle.CarJump)
            if Vehicle.CarJump.v then
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                  ", Vehicle.CarJumpKey, 200, 20)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:SliderFloat("Height", Vehicle.Height, 0.1, 1)
            end
    end
end
return VehicleTab