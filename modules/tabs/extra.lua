local ExtraTab = {}
function ExtraTab.Mainloop()
--Anti Aim
    if Extra.AntiAim.Enable.v then
        if Extra.AntiAim.Type.v == 0 then
            Extra.AntiAim.Pitch.v = 90.00001
        elseif Extra.AntiAim.Type.v == 1 then
            Extra.AntiAim.Pitch.v = -90.00001
        else
            Extra.AntiAim.Pitch.v = math.random(-90,90) + 0.00001
        end
        Utils:writeMemory(Global.CPlayerData+0x54, Extra.AntiAim.Pitch.v, 4, false)
    end
--noClip
    if Extra.noClip.Enable.v then
        if Extra.noClip.OnKey.v and Utils:IsKeyDown(Extra.noClip.Key.v) or not Extra.noClip.OnKey.v then
            if Extra.noClip.DisableCollision.v then
                local hasbits = Utils:readMemory((Global.CPedST + 0x40) + 0x0, 1, false)
                if not hasBit(hasbits, moveFlag.DisableCollisionForce) then
                    local novoValor = setBit(hasbits, moveFlag.DisableCollisionForce)
                    Utils:writeMemory((Global.CPedST + 0x40) + 0x0, novoValor, 1, false)
                end
                if Players:isDriver(Players:getLocalID()) then
                    hasbits = Utils:readMemory((Global.CVehicleST + 0x40) + 0x0, 1, false)
                    if not hasBit(hasbits, moveFlag.DisableCollisionForce) then
                        local novoValor = setBit(hasbits, moveFlag.DisableCollisionForce)
                        Utils:writeMemory((Global.CVehicleST + 0x40) + 0x0, novoValor, 1, false)
                    end
                end
            else
                local hasbits = Utils:readMemory((Global.CPedST + 0x40) + 0x0, 1, false)
                if hasBit(hasbits, moveFlag.DisableCollisionForce) then
                    local novoValor = clearBit(hasbits, moveFlag.DisableCollisionForce)
                    Utils:writeMemory((Global.CPedST + 0x40) + 0x0, novoValor, 1, false)
                end
                if Players:isDriver(Players:getLocalID()) then
                    hasbits = Utils:readMemory((Global.CVehicleST + 0x40) + 0x0, 1, false)
                    if hasBit(hasbits, moveFlag.DisableCollisionForce) then
                        local novoValor = clearBit(hasbits, moveFlag.DisableCollisionForce)
                        Utils:writeMemory((Global.CVehicleST + 0x40) + 0x0, novoValor, 1, false)
                    end
                end
            end
            local bsData = BitStream()
            local vecAimf1 = CVector()
            vecAimf1.fX =  Utils:readMemory(0xB6F32C, 4, false) 
            vecAimf1.fY =  Utils:readMemory(0xB6F32C + 4, 4, false)
            vecAimf1.fZ =  Utils:readMemory(0xB6F32C + 8, 4, false)
            local bsTransfer = BitStream()
            bsWrap:Write32(bsTransfer, vecAimf1.fX)
            bsWrap:Write32(bsTransfer, vecAimf1.fY)
            bsWrap:Write32(bsTransfer, vecAimf1.fZ)
            vecAimf1.fX = bsWrap:ReadFloat(bsTransfer)
            vecAimf1.fY = bsWrap:ReadFloat(bsTransfer)
            vecAimf1.fZ = bsWrap:ReadFloat(bsTransfer)
            if Utils:IsKeyDown(87) then
                if noClipForward == nil then
                    noClipForward = Timers(10)
                    noClipReset = nil
                    noClipReset = Timers(25)
                end
            end
            if Utils:IsKeyDown(83) then
                if noClipBackward == nil then
                    noClipBackward = Timers(10)
                    noClipReset = nil
                    noClipReset = Timers(25)
                end
            end
            if Utils:IsKeyDown(68) then
                if noClipRight == nil then
                    noClipRight = Timers(10)
                    noClipReset = nil
                    noClipReset = Timers(25)
                end
            end
            if Utils:IsKeyDown(65) then
                if noClipLeft == nil then
                    noClipLeft = Timers(10)
                    noClipReset = nil
                    noClipReset = Timers(25)
                end
            end
                Global.noClipSpeed = CVector(0, 0, 0)
            if noClipReset ~= nil then
                if noClipReset.update(deltaTime) then
                    if Global.noClipSpeed.fX == 0 and Global.noClipSpeed.fY == 0 and Global.noClipSpeed.fZ == 0 then
                        Global.noClipSpeed = CVector(0, 0, 0)
                        noClipReset = nil
                    else
                        Global.noClipSpeed = Global.noClipSpeed * 0.75
                        noClipReset = Timers(25)
                    end
                end
            end
            if noClipForward ~= nil then
                if noClipForward.update(deltaTime) then
                    Global.noClipSpeed = Global.noClipSpeed + (vecAimf1)
                    noClipForward = nil
                end
            end
            if noClipBackward ~= nil then
                if noClipBackward.update(deltaTime) then
                    Global.noClipSpeed = Global.noClipSpeed + ((vecAimf1 * -1))
                    noClipBackward = nil
                end
            end
            if noClipRight ~= nil then
                if noClipRight.update(deltaTime) then
                    Global.noClipSpeed = CVector(Global.noClipSpeed.fX + (vecAimf1.fY * 0.5), Global.noClipSpeed.fY + (-vecAimf1.fX  * 0.5), Global.noClipSpeed.fZ)
                    noClipRight = nil
                end
            end
            if noClipLeft ~= nil then
                if noClipLeft.update(deltaTime) then
                    Global.noClipSpeed = CVector(Global.noClipSpeed.fX + (-vecAimf1.fY * 0.5), Global.noClipSpeed.fY + (vecAimf1.fX * 0.5), Global.noClipSpeed.fZ)
                    noClipLeft = nil
                end
            end
            local choosenspeed = Extra.noClip.Speed.InCar.v
            if not Players:isDriver(Players:getLocalID()) then
                isCar = 1
                choosenspeed = Extra.noClip.Speed.OnFoot.v
            else
                isCar = 1.5
            end
            local Speed = (vecAimf1 * 0.01) + (Global.noClipSpeed * ((0.1 * choosenspeed) * isCar))
            local pData
            if Players:isDriver(Players:getLocalID()) then pData = vMy.ICData else pData = vMy.OFData end
            local deltaX = (vecAimf1.fX-pData.Pos.fX)+pData.Pos.fX
            local deltaY = (vecAimf1.fY-pData.Pos.fY)+pData.Pos.fY
            local deltaZ = (vecAimf1.fZ-pData.Pos.fZ)+pData.Pos.fZ
            local radians = math.atan2(deltaY, deltaX)
            local degrees = (radians * 180) / math.pi - 90
            if Players:isDriver(Players:getLocalID()) then
                --Vehicle FacingAngle
                    bsWrap:Write16(bsData, vMy.ICData.VehicleID) 
                    bsWrap:WriteFloat(bsData, degrees)
                    EmulRPC(160, bsData)
                    bsWrap:Reset(bsData)
                bsWrap:Write8(bsData, 0)
                bsWrap:WriteFloat(bsData, Speed.fX)
                bsWrap:WriteFloat(bsData, Speed.fY)
                bsWrap:WriteFloat(bsData, Speed.fZ*1.125)
                EmulRPC(91,bsData)
                bsWrap:Reset(bsData)
            else
                --Player FacingAngle
                    bsWrap:WriteFloat(bsData, degrees)
                    EmulRPC(19, bsData)
                    bsWrap:Reset(bsData)
                bsWrap:WriteFloat(bsData, Speed.fX)
                bsWrap:WriteFloat(bsData, Speed.fY)
                bsWrap:WriteFloat(bsData, Speed.fZ*1.125)
                EmulRPC(90,bsData)
                bsWrap:Reset(bsData)
            end
        else
            if Extra.noClip.DisableCollision.v then
                local hasbits = Utils:readMemory((Global.CPedST + 0x40) + 0x0, 1, false)
                if hasBit(hasbits, moveFlag.DisableCollisionForce) then
                    local novoValor = clearBit(hasbits, moveFlag.DisableCollisionForce)
                    Utils:writeMemory((Global.CPedST + 0x40) + 0x0, novoValor, 1, false)
                end
                if Players:isDriver(Players:getLocalID()) then
                    hasbits = Utils:readMemory((Global.CVehicleST + 0x40) + 0x0, 1, false)
                    if hasBit(hasbits, moveFlag.DisableCollisionForce) then
                        local novoValor = clearBit(hasbits, moveFlag.DisableCollisionForce)
                        Utils:writeMemory((Global.CVehicleST + 0x40) + 0x0, novoValor, 1, false)
                    end
                end
            end
            noClipForward = nil
            noClipBackward = nil
            noClipReset = nil
        end
    end
--AutoC
    if AimOT.AutoC.Enable.v then
        local vMyWeapon = Players:getPlayerWeapon(Players:getLocalID())
        if vMyWeapon == 24 then
            local Keys = vMy.OFData.sKeys
            
            --if bit.band(Keys, 0x0080) > 0 then
                if bit.band(Keys, 0x0004) == 0 then
                    if autoC == 1 then
                        autoC = Timers(0.01)
                    end
                else
                    autoC = 1
                end
            --end
            if autoCRestore ~= nil and autoCRestore ~= 0 then
                if autoCRestore.update(deltaTime) then
                    if AimOT.AutoC.Type.v == 0 then
                        Utils:writeMemory(0xB6EC2E, 1, 1, false)
                    end
                    autoCRestore = 0
                end
            end
            if autoC ~= nil and autoC ~= 0 and autoC ~= 1 then
                if autoC.update(deltaTime) then 
                    if AimOT.AutoC.Type.v == 0 then
                        Utils:writeMemory(0xB6EC2E, 0, 1, false)
                    end
                    autoCRestore = Timers(0)
                    local animlib = ImBuffer("PYTHON")
                    local animname = ImBuffer("python_crouchfire")
                    set.PlayerAnimation(animlib, animname, true, true, 1)
                    Utils:writeMemory(0xB6F1A8, 4, 4, false)
                    v.EmulateC = 1
                    autoC = 0
                end
            end
        end
    end
--Hide Temp Objects 
    local fX = Utils:getResolutionX() * 0.5
    local fY = Utils:getResolutionY() * 0.5
    local ObjScreen = CVector()
    if Extra.RemoveObjectTemp.Enable.v or Global.SaveObjectTimer ~= 0 then
        if not Panic.Visuals.v then
            if Utils:IsKeyDown(Extra.RemoveObjectTemp.Key.v) and not v.Chat and not v.Dialog and not Extra.RemoveObjectTemp.Bullet.v then
                get.NearestObjectsFromScreen()
                local nearestfromcrosshair = maths.getLowerIn(objects.fov)
                if nearestfromcrosshair ~= nil then
                    local ObjectLoc = Objects:getObjectPosition(nearestfromcrosshair)
                    Utils:GameToScreen(ObjectLoc, ObjScreen)
                    vMyScreen = CVector(fX+107, fY-107, 0)
                    if ObjScreen.fZ > 1 then
                        if Global.SaveObjectPos[nearestfromcrosshair] == nil then
                            Render:DrawLine(Utils:getResolutionX()*0.5,Utils:getResolutionY()*0.4,ObjScreen.fX,ObjScreen.fY,0xFF000000)      
                            Render:DrawCircle(ObjScreen.fX, ObjScreen.fY, 10, true, 0x9F0040FF) 
                            local distance = Utils:Get3Ddist(Players:getPlayerPosition(Players:getLocalID()), ObjectLoc)
                            Render:DrawText("Remove Object "..nearestfromcrosshair, ObjScreen.fX,ObjScreen.fY+10,0x9F0040FF)
                            Render:DrawText("(dist: ".. distance .."m)",ObjScreen.fX,ObjScreen.fY+25,0x6F00FF00)
                            if Utils:IsKeyChecked(2, 100) then
                                Global.SaveObjectPos[nearestfromcrosshair] = ObjectLoc
                                local bsData = BitStream()
                                bsWrap:Write16(bsData, nearestfromcrosshair)
                                bsWrap:WriteFloat(bsData, 0)
                                bsWrap:WriteFloat(bsData, 0)
                                bsWrap:WriteFloat(bsData, 122333444455555)
                                EmulRPC(45,bsData)
                                Global.SaveObjectDelay[nearestfromcrosshair] = Timers(Extra.RemoveObjectTemp.Time.v)
                                Global.SaveObjectTimer = 1
                                Utils:emulateGTAKey(2, 0)
                            end
                        end
                    end
                end
            end
        end
        for i = 0, SAMP_MAX_OBJECTS do
            if Global.SaveObjectDelay[i] ~= nil and Global.SaveObjectPos[i] ~= nil then
                if Global.SaveObjectDelay[i].update(deltaTime) then
                    local bsData = BitStream()
                    bsWrap:Write16(bsData, i)
                    bsWrap:WriteFloat(bsData, Global.SaveObjectPos[i].fX)
                    bsWrap:WriteFloat(bsData, Global.SaveObjectPos[i].fY)
                    bsWrap:WriteFloat(bsData, Global.SaveObjectPos[i].fZ)
                    EmulRPC(45,bsData)
                    Global.SaveObjectTimer = 0
                    Global.SaveObjectPos[i] = nil
                    Global.SaveObjectDelay[i] = nil
                end
            end
        end
    end
--Vehicles
    --VehicleSpam
        if Vehicle.Bike.Enable.v or Vehicle.Bicycle.Enable.v then
            if Players:isDriver(Players:getLocalID()) then
                memory.CVehicle.Surface = Utils:readMemory(Global.CVehicleST+0x41, 1, false)
                if memory.CVehicle.Surface ~= 0 then
                    local car = Players:getVehicleID(Players:getLocalID())
                    local vModel = Cars:getCarModel(car)
                    if vehicleInfo[vModel] == nil then
                        get.vehicleInfoFix()
                    else
                        if vehicleInfo[vModel].type == VehicleType.Bike then
                            if Vehicle.Bike.Enable.v and not v.Chat and not v.Dialog then
                                if Vehicle.Bike.OnKey.v and Utils:IsKeyDown(Vehicle.Bike.Key.v) or not Vehicle.Bike.OnKey.v then
                                    if (ms.update(deltaTime)) then
                                        Global.VehicleSpam = Global.VehicleSpam + 1
                                    end
                                    if Global.VehicleSpam > Vehicle.Bike.Delay.v then
                                        Global.VehicleSpam = 0
                                    end
                                    if Global.VehicleSpam < Vehicle.Bike.Delay.v*0.5 then
                                        set.KeyState(0xB72ED6, 0)
                                    else
                                        set.KeyState(0xB72ED6, 255)
                                    end
                                else
                                    if Global.VehicleSpam ~= 1000 then
                                        set.KeyState(0xB72ED6, 0)
                                        Global.VehicleSpam = 1000
                                    end
                                end
                            end
                        else
                            if vehicleInfo[vModel].type == VehicleType.Bicycle then
                                if Vehicle.Bicycle.Enable.v and not v.Chat and not v.Dialog then
                                    if Vehicle.Bicycle.OnKey.v and Utils:IsKeyDown(Vehicle.Bicycle.Key.v) or not Vehicle.Bicycle.OnKey.v then
                                        if (ms.update(deltaTime)) then
                                            Global.VehicleSpam = Global.VehicleSpam + 1
                                        end
                                        if Global.VehicleSpam > Vehicle.Bicycle.Delay.v then
                                            Global.VehicleSpam = 0
                                        end
                                        if Global.VehicleSpam < Vehicle.Bicycle.Delay.v*0.5 then
                                            set.KeyState(0xB72D76, 0)
                                        else
                                            set.KeyState(0xB72D76, 255)
                                        end
                                    else
                                        if Global.VehicleSpam ~= 1000 then
                                            set.KeyState(0xB72D76, 0)
                                            Global.VehicleSpam = 1000
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    if Global.VehicleSpam ~= 1000 then
                        set.KeyState(0xB72ED6, 0)
                        Global.VehicleSpam = 1000
                    end
                end
            end
        end
    --Fix Spam
        if not Players:isDriver(Players:getLocalID()) then 
            if Global.VehicleSpam > Vehicle.Bike.Delay.v*0.5 or Global.VehicleSpam > Vehicle.Bicycle.Delay.v*0.5 then
                set.KeyState(0xB72ED6, 0)
                set.KeyState(0xB72D76, 0)
                Global.VehicleSpam = 0
            end
        end
    --Never Off Engine
        if Vehicle.NeverOffEngine.v then
            if Players:isDriver(Players:getLocalID()) then
                memory.CVehicle.Engine = Utils:readMemory(Global.CVehicleST+0x428, 1, false)
                if memory.CVehicle.Engine ~= 16 then
                    Utils:writeMemory(Global.CVehicleST+0x428, 16, 1, false)
                end
            end
        end
    --No Collision with OtherCars
        if Vehicle.NoCarCollision.v then
            if Utils:IsKeyDown(Vehicle.NoCarCollisionKey.v) and not v.Chat and not v.Dialog then
                local bsData = BitStream()
                bsWrap:WriteBool(bsData, true)
                EmulRPC(167, bsData)
            else
                local bsData = BitStream()
                bsWrap:WriteBool(bsData, false)
                EmulRPC(167, bsData)
            end
        end
    --Car Jump
        if Vehicle.CarJump.v then
            if Utils:IsKeyDown(Vehicle.CarJumpKey.v) and not v.Chat and not v.Dialog then
                if Global.CanJump == 0 then
                    local bsData = BitStream()
                    bsWrap:Write8(bsData, 0)
                    bsWrap:WriteFloat(bsData, vMy.ICData.Speed.fX)
                    bsWrap:WriteFloat(bsData, vMy.ICData.Speed.fY)
                    bsWrap:WriteFloat(bsData, Vehicle.Height.v)
                    EmulRPC(91, bsData)
                    bsWrap:ResetWritePointer(bsData)
                    Global.CanJump = 1
                end
            else
                if Global.CanJump ~= 0 then
                    Global.CanJump = 0
                end
            end
        end
    --Hydra Thrust
        if Vehicle.Hydra.Thrust.Enable.v then
            if Players:isDriver(Players:getLocalID()) then
                local vModel = Cars:getCarModel(Players:getVehicleID(Players:getLocalID()))
                if (vModel == 520) then
                    if Utils:IsKeyChecked(Vehicle.Hydra.Thrust.Key.v, 0) then
                        v.HydraThrustState = not v.HydraThrustState
                        v.ThrustWait = true
                    end
                    if v.ThrustWait == true then
                        if(HydraThrustDelay.update(deltaTime)) then
                            set.HydraThrust()
                        end
                    end
                end
            end
        end
    --FreezeRot
        if Vehicle.FreezeRot.v then
            if Players:isDriver(Players:getLocalID()) then
                local vModel = Cars:getCarModel(Players:getVehicleID(Players:getLocalID()))
                if vehicleInfo[vModel] == nil then
                    get.vehicleInfoFix()
                else
                    if vehicleInfo[vModel].type ~= VehicleType.Heli and vehicleInfo[vModel].type ~= VehicleType.Plane then
                        local ptr2 = Global.CVehicleST + 185
                        local value = Utils:readMemory(ptr2,1,false)
                        if value == 0 then
                            ptr2 = Global.CVehicleST + 0x50
                            ptr3 = ptr2 + 4
                            ptr4 = ptr3 + 4
                            local value1 = Utils:readMemory(ptr2,1,false)
                            local value2 = Utils:readMemory(ptr3,1,false)
                            local value3 = Utils:readMemory(ptr4,1,false)
                            Utils:writeMemory(ptr2,0,4,false)
                            Utils:writeMemory(ptr3,0,4,false)
                            Utils:writeMemory(ptr4,0,4,false)
                        end
                    end
                end
            end
        end
    --LimitVelocity
        if Vehicle.LimitVelocity.v and Vehicle.LimitType.v == 0 then
            if Players:isDriver(Players:getLocalID()) then
                local car = Cars:getCarModel(Players:getVehicleID(Players:getLocalID()))
                local carvelocity = CVector()
                local tofloat1 = Utils:readMemory(Global.CVehicleST + 0x44, 4, false)
                local tofloat2 = Utils:readMemory(Global.CVehicleST + 0x48, 4, false)
                local tofloat3 = Utils:readMemory(Global.CVehicleST + 0x4C, 4, false)
                
                local bsTrans = BitStream()
                bsWrap:Write32(bsTrans, tofloat1)
                bsWrap:Write32(bsTrans, tofloat2)
                bsWrap:Write32(bsTrans, tofloat3)
                carvelocity.fX = bsWrap:ReadFloat(bsTrans)
                carvelocity.fY = bsWrap:ReadFloat(bsTrans)
                carvelocity.fZ = bsWrap:ReadFloat(bsTrans)
                bsWrap:Reset(bsTrans)
                speedf = math.sqrt(((carvelocity.fX*carvelocity.fX)+(carvelocity.fY*carvelocity.fY))+(carvelocity.fZ*carvelocity.fZ)) * 187.666667;
                speed = maths.round(speedf);
                local Surface = Utils:readMemory(Global.CVehicleST+0x41, 1, false)
                local air
                local currentSpeed = speedf
                local speedAdjustmentFactor = 0.8
                local newSpeed = currentSpeed * speedAdjustmentFactor
                if Surface ~= 0 then air = 0 else air = 15 end
                if Vehicle.SmartLimitMaxVelocity.v then
                    if vehicleInfo[car] == nil then
                        get.vehicleInfoFix()
                    else
                        if speed-air < vehicleInfo[car].velocity then
                            if speed > Vehicle.Velocity.v+10 then
                                if Vehicle.LimitVelocityOnKey.v and Utils:IsKeyDown(Vehicle.LimitVelocityKey.v) and not v.Chat and not v.Dialog or not Vehicle.LimitVelocityOnKey.v then
                                    Utils:writeMemory(Global.CVehicleST + 0x44, carvelocity.fX * newSpeed  / currentSpeed, 4, false)
                                    Utils:writeMemory(Global.CVehicleST + 0x48, carvelocity.fY * newSpeed  / currentSpeed, 4, false)
                                end
                            end
                        else
                            if speed > Vehicle.Velocity.v then
                                if Vehicle.LimitVelocityOnKey.v and Utils:IsKeyDown(Vehicle.LimitVelocityKey.v) and not v.Chat and not v.Dialog or not Vehicle.LimitVelocityOnKey.v then
                                    Utils:writeMemory(Global.CVehicleST + 0x44, carvelocity.fX * newSpeed  / currentSpeed, 4, false)
                                    Utils:writeMemory(Global.CVehicleST + 0x48, carvelocity.fY * newSpeed  / currentSpeed, 4, false)
                                else
                                    Utils:writeMemory(Global.CVehicleST + 0x44, carvelocity.fX * newSpeed  / currentSpeed, 4, false)
                                    Utils:writeMemory(Global.CVehicleST + 0x48, carvelocity.fY * newSpeed  / currentSpeed, 4, false)
                                end
                            end
                        end
                    end
                else
                    if speed > Vehicle.Velocity.v then
                        if Vehicle.LimitVelocityOnKey.v and Utils:IsKeyDown(Vehicle.LimitVelocityKey.v) and not v.Chat and not v.Dialog or not Vehicle.LimitVelocityOnKey.v then
                            Utils:writeMemory(Global.CVehicleST + 0x44, carvelocity.fX * newSpeed  / currentSpeed, 4, false)
                            Utils:writeMemory(Global.CVehicleST + 0x48, carvelocity.fY * newSpeed  / currentSpeed, 4, false)
                        end
                    end
                end
            end
        end
    --FastExitLegit
        if Vehicle.FastExit.Enable.v and Vehicle.FastExit.Type.v == 0 and ExitTimer ~= nil then
            if ExitTimer.update(deltaTime) then
                set.ClearPlayerAnimations()
                ExitTimer = nil
            end
        end
    --FastEnter
        if Vehicle.FastEnter.Enable.v and EnterTimer ~= nil then
            if Players:isDriver(Players:getLocalID()) == false and Players:Driving(Players:getLocalID()) == false then
                if(EnterTimer.update(deltaTime)) then
                    if Cars:isCarStreamed(v.VehicleToEnter[0]) and vMy.OFData.SpecialAction == 3 then
                        if v.VehicleToEnter[1] == 1 then
                            local Seat1 = Cars:getHavePassenger(v.VehicleToEnter[0], 1)
                            local Seat2 = Cars:getHavePassenger(v.VehicleToEnter[0], 2)
                            local Seat3 = Cars:getHavePassenger(v.VehicleToEnter[0], 3)
                            local Passenger
                            if Seat1 == false then Passenger = 1
                            elseif Seat2 == false then Passenger = 2 
                            elseif Seat3 == false then Passenger = 3
                            else Passenger = 4 end
                            send.PutPlayerInVehicle(v.VehicleToEnter[0], Passenger)
                        else
                            send.PutPlayerInVehicle(v.VehicleToEnter[0], v.VehicleToEnter[1])
                        end
                    end
                    EnterTimer = nil
                end
            else
                EnterTimer = nil
            end
        end
    --VehicleGod
        if Vehicle.Recovery.v then
            local bsData = BitStream()
            if RepairCar == nil then
                RepairCar = Timers(Vehicle.ChosenTimer.v)
            else
                vMy.ICData = Players:getInCarData(Players:getLocalID())
                if vMy.ICData.HealthCar + Vehicle.HPAmount.v < 999 then
                    if(RepairCar.update(deltaTime)) and vMy.ICData.HealthCar + Vehicle.HPAmount.v < 999 then
                        bsWrap:Write16(bsData, Players:getVehicleID(Players:getLocalID())) 
                        bsWrap:WriteFloat(bsData, vMy.ICData.HealthCar + Vehicle.HPAmount.v) 
                        EmulRPC(147,bsData)
                        bsWrap:ResetWritePointer(bsData)
                        RepairCar = nil
                    end
                else
                    if vMy.ICData.HealthCar < 999 then
                        if (RepairCar.update(deltaTime)) then
                            bsWrap:Write16(bsData, Players:getVehicleID(Players:getLocalID())) 
                            bsWrap:WriteFloat(bsData, 999) 
                            EmulRPC(147,bsData)
                            bsWrap:ResetWritePointer(bsData)
                            RepairCar = nil
                        end
                    else
                        if Vehicle.RecoverParts.v then
                            set.VehicleParts(Players:getVehicleID(Players:getLocalID()), 0, 0, 0, 0)
                        end
                        RepairCar = nil
                    end
                end
            end
            bsWrap:Reset(bsData)
        end
--Godmode
    --SetPlayerHealth
        if Godmode.GiveHealth.Enable.v then 
            if Godmode.GiveHealth.OnKey.v and Utils:IsKeyDown(Godmode.GiveHealth.Key.v) and not v.Chat and not v.Dialog or not Godmode.GiveHealth.OnKey.v then
                if TimerHP == nil then
                    TimerHP = Timers(Godmode.GiveHealth.Delay.v)
                end
                if(TimerHP.update(deltaTime)) then
                    if vMy.Health < Godmode.GiveHealth.Max.v then
                        local Amount = vMy.Health + Godmode.GiveHealth.Amount.v
                        if Amount > Godmode.GiveHealth.Max.v then
                            Amount = Godmode.GiveHealth.Max.v 
                        end
                        if Amount > vMy.Health then
                            local bsData = BitStream()
                            bsWrap:WriteFloat(bsData, Amount)
                            EmulRPC(14, bsData)
                            bsWrap:Reset(bsData)
                            TimerHP = Timers(Godmode.GiveHealth.Delay.v)
                        end
                    end
                end
            end
        end
    --SetPlayerArmour
        if Godmode.GiveArmour.Enable.v then 
            if Godmode.GiveArmour.OnKey.v and Utils:IsKeyDown(Godmode.GiveArmour.Key.v) and not v.Chat and not v.Dialog or not Godmode.GiveArmour.OnKey.v then
                if TimerArmour == nil then
                    TimerArmour = Timers(Godmode.GiveArmour.Delay.v)
                end
                if(TimerArmour.update(deltaTime)) then
                    if vMy.Armour < Godmode.GiveArmour.Max.v then
                        local Amount = vMy.Armour + Godmode.GiveArmour.Amount.v
                        if Amount > Godmode.GiveArmour.Max.v then
                            Amount = Godmode.GiveArmour.Max.v 
                        end
                        if Amount > vMy.Armour then
                            local bsData = BitStream()
                            bsWrap:WriteFloat(bsData, Amount)
                            EmulRPC(66, bsData)
                            bsWrap:Reset(bsData)
                            TimerArmour = Timers(Godmode.GiveArmour.Delay.v)
                        end
                    end
                end
            end
        end
    --Player
        if KeyToggle.GodmodePlayer.v == 1 or Movement.NoFall.Nodamage.v and NoFallTimer == -1 then
            local value = 0
            if KeyToggle.GodmodePlayer.v == 1 and Godmode.Player.Collision.v or Movement.NoFall.Nodamage.v and NoFallTimer == -1 then
                value = value + 16
            end
            if KeyToggle.GodmodePlayer.v == 1 and Godmode.Player.Melee.v then
                value = value + 32
            end
            if KeyToggle.GodmodePlayer.v == 1 and Godmode.Player.Bullet.v then
                value = value + 4
            end
            if KeyToggle.GodmodePlayer.v == 1 and Godmode.Player.Fire.v then
                value = value + 8
            end
            if KeyToggle.GodmodePlayer.v == 1 and Godmode.Player.Explosion.v then
                value = value + 128
            end
            memory.CPed.God = Utils:readMemory(Global.CPedST+0x42, 1, false)
            if memory.CPed.God ~= value then
                Utils:writeMemory(Global.CPedST+0x42, value, 1, false)
            end
        end
    --Vehicle
        if KeyToggle.GodmodeVehicle.v == 1 then
            if Players:isDriver(Players:getLocalID()) then
                local value = 0
                if Godmode.Vehicle.Collision.v then
                    value = value + 16
                end
                if Godmode.Vehicle.Melee.v then
                    value = value + 32
                end
                if Godmode.Vehicle.Bullet.v then
                    value = value + 4
                end
                if Godmode.Vehicle.Fire.v then
                    value = value + 8
                end
                if Godmode.Vehicle.Explosion.v then
                    value = value + 128
                end
                valueGod = Utils:readMemory(Global.CVehicleST+0x42, 1, false)
                if valueGod ~= value then
                    Utils:writeMemory(Global.CVehicleST+0x42, value, 1, false)
                end
            end
        end
--AntiFreeze
    if Extra.AntiFreeze.Enable.v then
        memory.CPed.Movement = Utils:readMemory(Global.CPedST+0x41, 1, false)
        if memory.CPed.Movement == 34 or memory.CPed.Movement == 32 then
            local antifreeze
            if v.interior ~= 2 then
                v.interior = Utils:readMemory(Global.CPedST+0x46C, 1, false)
            end
            if v.interior == 2 then
                if Extra.AntiFreeze.Interior.v then
                    if Utils:readMemory(Global.CPedST+0x42, 1, false) ~= 252 then
                        antifreeze = true
                    end
                end
            elseif v.Animation == 1 then
                if Extra.AntiFreeze.Animation.v then
                    antifreeze = true
                end
            else
                if Extra.AntiFreeze.Others.v then
                    antifreeze = true
                end
            end
            if antifreeze then
                local bsData = BitStream()
                bsWrap:Write8(bsData, 1)
                EmulRPC(15,bsData)
                v.Animation = 0
                v.interior = 0
            end
        else
            if v.Animation ~= 0 then
                v.Animation = 0
            end
        end
    end
--Send CMD
    if CMD.SendCMD.Enable.v and get.isPlayerAlive(Players:getLocalID()) then
        if CMD.SendCMD.HP.v < 100 and vMy.Health < CMD.SendCMD.HP.v or
        CMD.SendCMD.HP.v >= 100 and vMy.Armour < CMD.SendCMD.Armour.v then
            if(SendCMD.update(deltaTime)) and v.SendCMD < CMD.SendCMD.Times.v then
                v.SendCMD = v.SendCMD + 1
                local cmd = CMD.SendCMD.Command.v
                if not string.find(cmd, "/") then
                    cmd = "/" .. cmd
                end
                Utils:SayChat(cmd)
                SendCMD = Timers(CMD.SendCMD.Delay.v)
            end
        else
            v.SendCMD = 0
            SendCMD = Timers(CMD.SendCMD.FirstDelay.v)
        end
    end
--RequestSpawn
    if Extra.RequestSpawn.v then
        if Extra.RequestSpawnHP.v < 100 and vMy.Health < Extra.RequestSpawnHP.v or
        Extra.RequestSpawnHP.v >= 100 and vMy.Armour < Extra.RequestSpawnArmour.v then
            if RequestSpawnDelay ~= nil then
                if(RequestSpawnDelay.update(deltaTime)) then
                    local bsData = BitStream()
                    SendRPC(129, bsData)
                    SendRPC(52, bsData)
                    bsWrap:Reset(bsData)
                    RequestSpawnDelay = Timers(250)
                end
            else
                RequestSpawnDelay = Timers(0)
            end
        end
    end
--PickUP
    --Normal 
        if Extra.PickUP.Enable.v and get.isPlayerAlive(Players:getLocalID()) then
            if(PickUP.update(deltaTime)) then
                local picking = false
                local vMyPos = Players:getPlayerPosition(Players:getLocalID())
                local poolPtr = get.PickupPool()
                local ptwo = Utils:readMemory(poolPtr, 4, false)
                if ptwo > 0 then
                    ptwo = poolPtr + 0x4
                    local pthree = poolPtr + 0xF004
                    for id = 1, 4096 do
                        local pfive = Utils:readMemory(ptwo + id * 4, 4, false)
                        if pfive < 0 or pfive > 0 then
                            local Model = Utils:readMemory(pthree + id * 20, 4, false)
                            if Model == Extra.PickUP.Model1.v or Model == Extra.PickUP.Model2.v or Model == Extra.PickUP.Model3.v then
                                v.PickupsModel[id] = Model
                                if Extra.PickUP.HP.v < 100 and vMy.Health < Extra.PickUP.HP.v or
                                    Extra.PickUP.HP.v >= 100 and vMy.Armour < Extra.PickUP.Armour.v then
                                    local Dist = 0 
                                    if Extra.PickUP.Dist.v ~= 0 then
                                        local Offset = pthree + id * 20
                                        local Type = Utils:readMemory(Offset + 4, 4, false)
                                        local X = Utils:readMemory(Offset + 8, 4, false)
                                        local Y = Utils:readMemory(Offset + 12, 4, false)
                                        local Z = Utils:readMemory(Offset + 16, 4, false)
                                        local bsData = BitStream()
                                        bsWrap:Write32(bsData, X)
                                        bsWrap:Write32(bsData, Y)
                                        bsWrap:Write32(bsData, Z)
                                        X = bsWrap:ReadFloat(bsData)
                                        Y = bsWrap:ReadFloat(bsData)
                                        Z = bsWrap:ReadFloat(bsData)
                                        bsWrap:Reset(bsData)
                                        local PickUPpos = CVector(X, Y, Z)
                                        local vMyPos = Players:getPlayerPosition(Players:getLocalID())
                                        Dist = Utils:Get3Ddist(vMyPos, PickUPpos)
                                    end
                                    if Dist <= Extra.PickUP.Dist.v then
                                        local bData = BitStream()
                                        bsWrap:Write32(bData, id)
                                        SendRPC(131,bData)
                                        picking = true
                                        break 
                                    end
                                else
                                    PickUP = Timers(Extra.PickUP.Delay.v)
                                end
                            end
                        end
                    end
                end
                if Extra.PickUP.NonStreamed.v then
                    --if not picking then
                        if Extra.PickUP.HP.v < 100 and vMy.Health < Extra.PickUP.HP.v or
                        Extra.PickUP.HP.v >= 100 and vMy.Armour < Extra.PickUP.Armour.v then
                            if v.Pickingup == -1 then
                                v.Pickingup = maths.getLowerIn(v.PickupsID)
                            end
                            if v.Pickingup ~= nil then
                                local min = maths.getLowerIn(v.PickupsID) 
                                local high = maths.getHigherIn(v.PickupsID)
                                for i = min, high do
                                    if v.PickupsID[v.Pickingup] ~= nil then
                                        Model = v.PickupsModel[v.Pickingup]
                                        if Model == Extra.PickUP.Model1.v or Model == Extra.PickUP.Model2.v or Model == Extra.PickUP.Model3.v then
                                            local bData = BitStream()
                                            bsWrap:Write32(bData, v.Pickingup)
                                            SendRPC(131,bData)
                                            if v.Pickingup == high then
                                                v.Pickingup = -1
                                            else
                                                v.Pickingup = v.Pickingup + 1
                                            end
                                            break
                                        end
                                    end
                                    v.Pickingup = v.Pickingup + 1
                                    if v.Pickingup > high then
                                        v.Pickingup = -1
                                    end
                                end
                            else
                                v.Pickingup = -1
                            end
                        else
                            PickUP = Timers(Extra.PickUP.Delay.v)
                            v.Pickingup = -1
                        end
                    --end
                end
            end
        end
    --Range
        if Extra.PickUPRange.Enable.v and Utils:IsKeyDown(Extra.PickUPRange.Key.v) then
            if(Timerss.update(deltaTime)) then
                for id = Extra.PickUPRange.Min.v, Extra.PickUPRange.Max.v do
                    if v.PickUPRange > Extra.PickUPRange.Max.v then
                        v.PickUPRange = Extra.PickUPRange.Min.v 
                    elseif v.PickUPRange < Extra.PickUPRange.Min.v then
                        v.PickUPRange = Extra.PickUPRange.Min.v 
                    end
                    local bData = BitStream()
                    bsWrap:Write32(bData, v.PickUPRange)
                    SendRPC(131,bData)
                    v.PickUPRange = v.PickUPRange + 1
                    break
                end
            end
        end
--Teleports
    if Teleport.Enable.v or CMD.Message.TeleportToCheck.v and v.AutoReplyTeleportDelay == 1 then
        if not Panic.Visuals.v then
    --Teleport To Objects
            if Teleport.toObject.v or Global.Teleporting[5] == 1 then
                if Utils:IsKeyDown(Teleport.ObjectKey.v) and not v.Chat and not v.Dialog then
                    local ObjScreen = CVector()
                    get.NearestObjectsFromScreen()
                    local nearestfromcrosshair = maths.getLowerIn(objects.fov)
                    if nearestfromcrosshair ~= nil then
                        vMyScreen = CVector(fX+107, fY-107, 0)
                        for j = 0, SAMP_MAX_OBJECTS do 
                            if Objects:isObjectOnServer(j) then
                                local ObjectLoc = Objects:getObjectPosition(j)
                                Utils:GameToScreen(ObjectLoc, ObjScreen)
                                if ObjScreen.fZ > 1 then
                                    if j == nearestfromcrosshair then
                                        if Global.Object ~= nil then i = Global.Object end
                                        Render:DrawLine(Utils:getResolutionX()*0.5,Utils:getResolutionY()*0.4,ObjScreen.fX,ObjScreen.fY,0xFF000000)      
                                        Render:DrawText("TELEPORT TO OBJECT: ID[".. j .."]",ObjScreen.fX,ObjScreen.fY+60,0x9F0040FF)
                                        Render:DrawCircle(ObjScreen.fX, ObjScreen.fY, 10, true, 0x9F0040FF) 
                                        if Utils:IsKeyChecked(2, 0) and Global.Teleporting[5] ~= 1 then
                                            Global.Object = j
                                            Global.Teleporting[5] = 1
                                        end
                                    else
                                        if Global.Teleporting[5] ~= 1 then
                                            Render:DrawCircle(ObjScreen.fX, ObjScreen.fY, 2, true, 0x6FFF0000) 
                                            Render:DrawText(""..j, ObjScreen.fX,ObjScreen.fY,0x6F00FF00)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if Global.Teleporting[5] == 1 then
                if Utils:IsKeyDown(Teleport.ObjectKey.v) == false then
                    Global.Teleporting[1] = 2
                    local ObjectLoc = Objects:getObjectPosition(Global.Object)
                    TeleportPlayerTo(ObjectLoc)
                else
                    local ObjectLoc = Objects:getObjectPosition(Global.Object)
                    TeleportPlayerTo(ObjectLoc)
                end
            end
        end
    --Attach To Vehicle (Surfing)
        if Teleport.AttachToVehicle.v then
            local vehpos = CVector()
            if not Players:Driving(Players:getLocalID()) then
                if vMy.OFData.sSurfingVehicleID ~= 0 then
                    if not Utils:IsKeyDown(87) and not Utils:IsKeyDown(83) and not Utils:IsKeyDown(65) and not Utils:IsKeyDown(68) then
                        Global.AttachToVehicleID = vMy.OFData.sSurfingVehicleID
                        vehpos = Cars:getCarPosition(Global.AttachToVehicleID)
                        vehpos.fZ = vehpos.fZ + 1
                        Global.Attached = 1
                        if vehpos.fZ > Players:getPlayerPosition(Players:getLocalID()).fZ+3 then 
                            Players:setPosition(vehpos)
                        end
                    else
                        Global.Attached = 0
                    end
                else
                    if Global.Attached == 1 then
                        if Utils:IsKeyDown(87) or Utils:IsKeyDown(83) or Utils:IsKeyDown(65) or Utils:IsKeyDown(68) then
                            Global.Attached = 0
                        end
                        local passenger = Cars:getHavePassenger(Global.AttachToVehicleID,0)
                        vehpos = Cars:getCarPosition(Global.AttachToVehicleID)
                        vehpos.fZ = vehpos.fZ + math.random(1,2)
                        if passenger == true then
                            Players:setPosition(vehpos)
                        else
                            Global.Attached = 0
                        end
                    end
                end
            else
                Global.Attached = 0
            end
        end        
    --Teleport To Players
        if Teleport.toPlayer.v and Utils:IsKeyDown(Teleport.toPlayerKey.v) and not v.Chat and not v.Dialog or Global.Teleporting[3] == 1 then 
            if not Panic.Visuals.v then
                get.NearestPlayersFromScreen()
                local nearestfromcrosshair = maths.getLowerIn(players.fov)
                if nearestfromcrosshair ~= nil then
                    for i, _ in pairs(players.id) do
                        if Players:isPlayerStreamed(i) then
                            local names = Players:getPlayerName(i)
                            local center = string.len(names) * 4
                            if Utils:isOnScreen(i) then
                                local TeleportBone = Players:getBonePosition(i, 2)
                                local NameToScreen = CVector()
                                Utils:GameToScreen(TeleportBone, NameToScreen)
                                NameToScreen.fX = NameToScreen.fX - center
                                Utils:GameToScreen(TeleportBone, vEnScreen)
                                if Utils:IsKeyDown(Teleport.toPlayerKey.v) or Global.Teleporting[3] == 1 then
                                    if i == nearestfromcrosshair or i == nearestfromcrosshair and Global.Teleporting[3] == 1 then  
                                        Render:DrawLine(Utils:getResolutionX()*0.5,Utils:getResolutionY()*0.4,vEnScreen.fX,vEnScreen.fY,0xFF000000)      
                                        Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 10, true, 0x7F0040FF) 
                                        Render:DrawText( names.." ("..i..")", NameToScreen.fX-25,NameToScreen.fY+25,Players:getPlayerColor(i))

                                        local vEnDriver = Players:isDriver(i)
                                        if vEnDriver then
                                            Render:DrawText("DRIVING",NameToScreen.fX-25,NameToScreen.fY+45,0xFF0040FF)
                                        end  
                                        if Utils:IsKeyChecked(2, 0) and Global.Teleporting[3] ~= 1 then
                                            Global.Player = i
                                            Global.Teleporting[3] = 1
                                        end
                                    else   
                                        if Global.Teleporting[3] ~= 1 then
                                            Render:DrawText( names.." ("..i..")", NameToScreen.fX-10,NameToScreen.fY+10,Players:getPlayerColor(i))
                                            Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 5, true, 0x6Ff040FF) 
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if Global.Teleporting[3] == 1 then
                        if Utils:IsKeyDown(Teleport.toPlayerKey.v) == false then
                            Global.Teleporting[1] = 2
                            TeleportPlayerTo(LastPosPlayer)
                        elseif Players:isPlayerStreamed(Global.Player) then
                            LastPosPlayer = Players:getPlayerPosition(Global.Player)
                            TeleportPlayerTo(LastPosPlayer)
                        else
                            Global.Teleporting[1] = 2
                            TeleportPlayerTo(LastPosPlayer)
                        end
                    end
                end
            end
        end
    --Teleport to Vehicles
        if Teleport.toVehicle.v and Utils:IsKeyDown(Teleport.toVehicleKey.v) and not v.Chat and not v.Dialog or Global.Teleporting[6] == 1 then
            if not Panic.Visuals.v then
                get.NearestVehiclesFromScreen()
                local nearestfromcrosshair = maths.getLowerIn(vehicles.fov)
                if nearestfromcrosshair ~= nil then
                    if vehicleInfo[411] == nil then
                        get.vehicleInfoFix()
                    else
                        for i = 1, SAMP_MAX_VEHICLES do
                            if Cars:isCarStreamed(i) then
                                local model = Cars:getCarModel(i)  
                                local center = string.len(vehicleInfo[model].name) * 3
                                local carHP = Cars:getCarHP(i)  
                                local Car = Cars:getCarPosition(i)
                                Utils:GameToScreen(Car, vEnScreen)
                                if vEnScreen.fZ > 1 then
                                    local NameToScreen = CVector()
                                    Utils:GameToScreen(Car, NameToScreen)
                                    NameToScreen.fX = NameToScreen.fX - center
                                    local nearestCar = nearestfromcrosshair
                                    if Utils:IsKeyDown(Teleport.toVehicleKey.v) or Global.Teleporting[6] == 1 then
                                        if i == nearestCar or i == nearestCar and Global.Teleporting[6] == 1 then
                                            local isSeatAvailable = Cars:getHavePassenger(nearestCar,0)
                                            local seat
                                            if Teleport.toVehicleDriver.v and nearestCar ~= Players:getVehicleID(Players:getLocalID()) or not isSeatAvailable then
                                                seat = " [ Driver ] "
                                            else
                                                seat = " [ Passenger ] "
                                            end
                                            Render:DrawText( vehicleInfo[model].name.." (".. model ..") "..seat, NameToScreen.fX-25,NameToScreen.fY+25,0xFF0040FF)
                                            Render:DrawLine(Utils:getResolutionX()*0.5,Utils:getResolutionY()*0.4,vEnScreen.fX,vEnScreen.fY,0xFF000000)      
                                            Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 10, true, 0xFF0040FF)
                                            if Utils:IsKeyChecked(2, 0) then
                                                if Global.SaveVehicle == 0 and Global.Teleporting[6] ~= 1 then
                                                    Global.Vehicle = nearestCar
                                                    Global.Teleporting[6] = 1
                                                end
                                                Global.SaveVehicle = 1
                                            else
                                                Global.SaveVehicle = 0
                                            end
                                        else
                                            if Global.Teleporting[6] ~= 1 then
                                                Render:DrawText(vehicleInfo[model].name.." (".. model ..")",NameToScreen.fX-25,NameToScreen.fY+10,0x9Ff040FF)
                                                Render:DrawCircle(vEnScreen.fX, vEnScreen.fY, 5, true, 0x8Ff040FF) 
                                            end
                                        end
                                    else
                                        if Utils:IsKeyDown(Teleport.toVehicleKey.v) == false then
                                            Global.SaveVehicle = 0
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if Global.Teleporting[6] == 1 then
                        if Utils:IsKeyDown(Teleport.toVehicleKey.v) == false then
                            local pos = Cars:getCarPosition(Global.Vehicle)
                            Global.Teleporting[1] = 2
                            TeleportPlayerTo(pos)
                        elseif Cars:isCarStreamed(Global.Vehicle) then
                            local pos = Cars:getCarPosition(Global.Vehicle)
                            TeleportPlayerTo(pos)
                        else
                            Global.Teleporting[1] = 2
                            TeleportPlayerTo(pos)
                        end
                    end
                end
            end
        else
            if Utils:IsKeyDown(Teleport.toVehicleKey.v) == false then
                Global.SaveVehicle = 0
            end
        end
    --Rage Teleport (HVH)
        if Teleport.HvH.v then
            get.NearestPlayersFromScreen()
            for i, _ in pairs(players.id) do
                if Players:isPlayerStreamed(i) then
                    if Utils:IsKeyDown(Teleport.HvHKey.v) and not v.Chat and not v.Dialog then
                        if Players:isPlayerInFilter(i) == false and Players:isSkinInFilter(i) == false then
                            Global.HvHid[i] = i
                            local HvHHealth = Players:getPlayerHP(Global.HvHid[i])
                            if Teleport.HVHDeath.v and HvHHealth > 0 or Teleport.HVHDeath.v == false then
                                if Teleport.HVHAFK.v and Players:isPlayerAFK(Global.HvHid[i]) == false or Teleport.HVHAFK.v == false then
                                    if Global.HVHSavePos == 0 then
                                        Global.HVHSavePos = Players:getPlayerPosition(Players:getLocalID())
                                    end
                                    if Global.HVHWaitW[i] == nil or Global.HVHWaitW[i] == NULL then
                                        Global.HVHWaitW[i] = -1
                                    end
                                    Global.HVHWaitW[i] = Global.HVHWaitW[i] + 1 
                                    v.Wait = v.Wait + 1 
                                    if Global.HVHWaitW[i] > Teleport.HVHWait.v and v.Wait > Teleport.HVHWait.v then
                                        Global.HvHpos[i] = Players:getPlayerPosition(Global.HvHid[i])
                                        if Players:Driving(Global.HvHid[i]) then
                                            Global.HvHpos[i].fZ = Global.HvHpos[i].fZ + 4
                                        end
                                        Players:setPosition(Global.HvHpos[i])
                                        v.Wait = 0
                                        Global.HVHWaitW[i] = -1
                                    end
                                end
                            end
                        end
                    else
                        if Global.HVHSavePos ~= 0 then
                            Players:setPosition(Global.HVHSavePos)
                            if Players:Driving(Players:getLocalID()) then
                                set.VehicleZAngle(0)
                            end
                            Global.HVHSavePos = 0
                        end
                        Global.HVHWaitW[i] = 0
                        v.Wait = 0
                        Global.HVHSavePos = 0
                    end
                end
            end
        end
    --Checkpoint
        if Teleport.toCheckpoint.v or CMD.Message.TeleportToCheck.v and v.AutoReplyTeleportDelay == 1 then
            if Global.CheckpointSave ~= 0.0 then 
                if Teleport.toCheckpoint.v and Utils:IsKeyDown(Teleport.CheckpointKey.v) or CMD.Message.TeleportToCheck.v and v.AutoReplyTeleportDelay == 1 then 
                    Global.Teleporting[4] = 1
                    TeleportPlayerTo(Global.CheckpointSave)
                else
                    if Global.Teleporting[4] == 1 then
                        if CMD.Message.TeleportToCheck.v and v.AutoReplyTeleportDelay ~= 1 or Teleport.toCheckpoint.v and not Utils:IsKeyDown(Teleport.CheckpointKey.v) then
                            Global.Teleporting[1] = 2
                            TeleportPlayerTo(Global.CheckpointSave)
                        end
                    end
                end
            end
        end
    --Saved Pos
    for i, _ in pairs(Teleport.DelSaveTeleports) do
            if Teleport.DelSaveTeleports[i] ~= nil and Teleport.DelSaveTeleports[i].v == true then
                Teleport.SavedPos[i] = CVector()
                Teleport.PosToScreen[i].fZ = 0
                Teleport.DelSaveTeleports[i].v = false
            end
            if Teleport.SaveTeleports[i] ~= nil and Teleport.SaveTeleports[i].v == true then
                Teleport.SavedPos[i] = Players:getPlayerPosition(Players:getLocalID())
                Teleport.SaveTeleports[i].v = false
            end
            if Teleport.LoadTeleports[i] ~= nil and Teleport.LoadTeleports[i].v == true then
                TeleportPlayerTo(Teleport.SavedPos[i])
            end
            if Teleport.ShowSaveTeleports.v and Teleport.SavedPos[i].fX ~= 0.0 then
                Utils:GameToScreen(Teleport.SavedPos[i], Teleport.PosToScreen[i])
            end
        end
    end
--Hide Object Aiming Sniper
    if AimOT.HideObjectWhileAiming.v then
        if camMode == 7 then
            if m_offsets.m_samp_info[v.SampVer] ~= 0 then
                local sampInfo = Utils:readMemory(v.SampAdr + m_offsets.m_samp_info[v.SampVer], 4, false)
                local pools = Utils:readMemory(sampInfo + m_offsets.m_pools[v.SampVer], 4, false)
                local playerpools = Utils:readMemory(pools + m_offsets.m_player[v.SampVer], 4, false)
                local localplayer = Utils:readMemory(playerpools + m_offsets.m_localplayer[v.SampVer], 4, false)
                local actor = Utils:readMemory(localplayer + m_offsets.m_actor[v.SampVer], 4, false)
                for i = 0, 10 do
                    local id = i * 4
                    local doesobjectExist = Utils:readMemory(actor + (id + 0x4C), 4, false)
                    if doesobjectExist > 0 then
                        local temp = Utils:readMemory(actor + (id + 0x27C), 1, false)
                        if temp > 0 then
                            local objectStruct = Utils:readMemory(actor + (id + 0x27C), 4, false)
                            if objectStruct > 0 then
                                local objectStructOffset = Utils:readMemory(objectStruct + 0x40, 4, false)
                                if objectStructOffset > 0 then
                                    local objectVector = Utils:readMemory(objectStructOffset + 0x14, 4, false)
                                    if objectVector > 0 then
                                        Utils:writeMemory(objectVector + 0x38, 0.001, 4, false)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
--AutoAttach
    if Vehicle.AutoAttachWaiting == 1 and Vehicle.AutoAttachTrailer.v then
        if Vehicle.SaveTrailer ~= -1 and vMy.ICData.VehicleID == Vehicle.TrailerToVehicle then
            if AttachDelay ~= nil then
                if(AttachDelay.update(deltaTime)) then
                    local bsDatas = BitStream()
                    local vMyPos = Players:getPlayerPosition(Players:getLocalID())
                    bsWrap:Write16(bsDatas, Vehicle.SaveTrailer) 
                    bsWrap:Write16(bsDatas, Vehicle.TrailerToVehicle)
                    EmulRPC(148, bsDatas)
                    bsWrap:Reset(bsDatas)
                    bsWrap:Write16(bsDatas, Vehicle.SaveTrailer)
                    bsWrap:WriteFloat(bsDatas, 1000)
                    EmulRPC(147, bsDatas)
                    Vehicle.AutoAttachWaiting = 0
                    AttachDelay = nil
                end
            end
        end
    end
end
function ExtraTab.Visual()
--SavedPos Position
    if Teleport.ShowSaveTeleports.v then
        for i = 0, 3 do
            if Teleport.PosToScreen[i].fZ > 1 then
                Render:DrawCircle(Teleport.PosToScreen[i].fX, Teleport.PosToScreen[i].fY, 10, true, 0x7F0040FF) 
                Render:DrawText("Pos ("..i..")" ,Teleport.PosToScreen[i].fX-25,Teleport.PosToScreen[i].fY+25,0xFF0040FF)
            end
        end
    end
end
function ExtraTab.Menu()
    if SHAkMenu.Menu.v == 4 then
        SHAkMenu.resetMenuTimer(SHAkMenu.Menu.v)
        --Godmode
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor-4,SHAkMenu.menutransitor-4) 
            if Menu:Button("| Godmode |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                GodmodeList = not GodmodeList
                SHAkMenu.menuOpened = 0
            end
            if GodmodeList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Give Health", Godmode.GiveHealth.Enable) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##23123123123", Godmode.GiveHealth.OnKey)
                if Godmode.GiveHealth.OnKey.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                                           ",  Godmode.GiveHealth.Key, 200, 20)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Max Health", Godmode.GiveHealth.Max, 0, 100)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Amount ##232323", Godmode.GiveHealth.Amount, 0, 100)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Delay ##232323", Godmode.GiveHealth.Delay, 0, 1000)
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Give Armour", Godmode.GiveArmour.Enable) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##323232323232",  Godmode.GiveArmour.OnKey)
                if Godmode.GiveArmour.OnKey.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                                            ",  Godmode.GiveArmour.Key, 200, 20)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Max Armour ##232323", Godmode.GiveArmour.Max, 0, 100)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Amount ##23232323", Godmode.GiveArmour.Amount, 0, 100)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Delay ##23232323", Godmode.GiveArmour.Delay, 0, 1000)
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Godmode", Godmode.Player.Enable) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##666", Godmode.Player.OnKey)
                if Godmode.Player.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                 ", Godmode.Player.Key, 200, 20) end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                if Menu:Button("(?)") then
                    reindirectbutton = not reindirectbutton
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Collision Proof", Godmode.Player.Collision) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Melee Proof", Godmode.Player.Melee) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Bullet Proof", Godmode.Player.Bullet) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Fire Proof", Godmode.Player.Fire) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Explosion Proof", Godmode.Player.Explosion) 
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("GodCar", Godmode.Vehicle.Enable)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey##777", Godmode.Vehicle.OnKey)
                if Godmode.Vehicle.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                ", Godmode.Vehicle.Key, 200, 20) end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+45,SHAkMenu.menutransitorstaticreversed+45) 
                if Menu:Button("(?)") then
                    reindirectbutton = not reindirectbutton
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Collision Proof##2", Godmode.Vehicle.Collision) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Melee Proof##2", Godmode.Vehicle.Melee)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Bullet Proof##2", Godmode.Vehicle.Bullet)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Fire Proof##2", Godmode.Vehicle.Fire) 
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Explosion Proof##2", Godmode.Vehicle.Explosion)
            end   
        --Teleport
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor,SHAkMenu.menutransitor) 
            if Menu:Button("| Teleport |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                TeleportList = not TeleportList
                SHAkMenu.menuOpened = 0
            end
            if TeleportList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox("Teleport", Teleport.Enable)
                Menu:Separator()
                
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("From Ground", Teleport.FromGround)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+35,SHAkMenu.menutransitorstaticreversed+35) Menu:Text("Teleport Speed")
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("OnFoot Velocity", Teleport.OnFootVelocity, 0.1, 1000)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("InCar Velocity", Teleport.InCarVelocity, 0.1, 1000)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Teleports before triggering AC Delay", Teleport.PersonalDelay, 1, 200)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("AC Delay", Teleport.ACDelay, 1, 5000)
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("To Player", Teleport.toPlayer)
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("               ", Teleport.toPlayerKey, 200, 20)
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("To Vehicle", Teleport.toVehicle)
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                               ", Teleport.toVehicleKey, 200, 20)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox("PutPlayerInVehicle", Teleport.toInside)
                if Teleport.toInside.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox("as Driver", Teleport.toVehicleDriver)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:Combo("Type##92",Teleport.toVehicleType,"Send EnterVehicle\0Invisible\0\0",6)
                end
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("To Object", Teleport.toObject)
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("             ", Teleport.ObjectKey, 200, 20)
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("To Checkpoint", Teleport.toCheckpoint)
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("            ", Teleport.CheckpointKey, 200, 20)
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("Rage (HvH)", Teleport.HvH)
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("           ", Teleport.HvHKey, 200, 20)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Ignore Dead", Teleport.HVHDeath)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Ignore AFK", Teleport.HVHAFK)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:SliderInt("##23", Teleport.HVHWait, 1, 200)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("No PlayerSync", Teleport.HvHAntiKick)
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox("Attach To Vehicle", Teleport.AttachToVehicle)
                Menu:SameLine(SHAkMenu.menutransitor+11,SHAkMenu.menutransitor+11) 
                if Menu:Button("(?)") then
                    AttachToVehiclemenu = not AttachToVehiclemenu
                end
                if AttachToVehiclemenu == true then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                    Menu:Text("Keep teleporting back to vehicle that you are surfing")
                end
                Menu:Separator()
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Position (1)")
                if Teleport.SavedPos[0].fX == 0 then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Save Pos", Teleport.SaveTeleports[0])
                else
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Load Pos", Teleport.LoadTeleports[0]) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Delete Pos", Teleport.DelSaveTeleports[0])
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Position (2)")
                if Teleport.SavedPos[1].fX == 0 then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Save Pos ", Teleport.SaveTeleports[1])
                else
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Load Pos ", Teleport.LoadTeleports[1]) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Delete Pos ", Teleport.DelSaveTeleports[1])
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Position (3)")
                if Teleport.SavedPos[2].fX == 0 then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Save Pos  ", Teleport.SaveTeleports[2])
                else
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Load Pos  ", Teleport.LoadTeleports[2]) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Delete Pos  ", Teleport.DelSaveTeleports[2])
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Text("Position (4)")
                if Teleport.SavedPos[3].fX == 0 then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Save Pos   ", Teleport.SaveTeleports[3])
                else
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Load Pos   ", Teleport.LoadTeleports[3])
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("Delete Pos   ", Teleport.DelSaveTeleports[3])
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+40,SHAkMenu.menutransitorstaticreversed+40) Menu:CheckBox2("Show Pos Position ", Teleport.ShowSaveTeleports) 
            end
        --Extra
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+10,SHAkMenu.menutransitor+8) 
            if Menu:Button("| Extra |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                ExtraList = not ExtraList
                SHAkMenu.menuOpened = 0
            end
            if ExtraList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("noClip", Extra.noClip.Enable)
                if Extra.noClip.Enable.v then 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey         ", Extra.noClip.OnKey)
                    if Extra.noClip.OnKey.v then Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("              ", Extra.noClip.Key, 200, 20) end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Disable Collision", Extra.noClip.DisableCollision)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("OnFoot Speed  ", Extra.noClip.Speed.OnFoot, 1, 100) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("InCar Speed  ", Extra.noClip.Speed.InCar, 1, 100) 
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Auto Reconnect", Extra.Recon.Enable)
                if Extra.Recon.Enable.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderInt("Time", Extra.Recon.Time, 1, 10) 
                    Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:InputText("Nick", v.ReconName)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Hide Temp Object", Extra.RemoveObjectTemp.Enable)
                if Extra.RemoveObjectTemp.Enable.v then 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("On Bullet Impact", Extra.RemoveObjectTemp.Bullet)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("         ", Extra.RemoveObjectTemp.Key, 200, 20) 
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5)Menu:SliderInt("Time to add the object back", Extra.RemoveObjectTemp.Time, 200, 5000)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Fuck KeyStrokes", Extra.fuckKeyStrokes.Enable)
                if Extra.fuckKeyStrokes.Enable.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Per Weapon Slot", Extra.fuckKeyStrokes.PerWeaponSlot)
                    if not Extra.fuckKeyStrokes.PerWeaponSlot.v then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Mode   ",Extra.fuckKeyStrokes.Slot[1].Mode,"Don't Send\0Always pressed\0Random Press\0",600) 
                        if Extra.fuckKeyStrokes.Slot[1].Mode.v ~= 2 then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+15)
                            if Menu:Button("| Key List |") then
                                v.KeyList[0] = not v.KeyList[0]
                            end
                            if v.KeyList[0] == true then
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Fire",Extra.fuckKeyStrokes.Slot[1].Key.fire)
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Aim",Extra.fuckKeyStrokes.Slot[1].Key.aim)
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Crouch",Extra.fuckKeyStrokes.Slot[1].Key.horn_crouch)
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Enter Vehicle",Extra.fuckKeyStrokes.Slot[1].Key.enterExitCar)
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Sprint",Extra.fuckKeyStrokes.Slot[1].Key.sprint)
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Walk",Extra.fuckKeyStrokes.Slot[1].Key.walk)
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Jump",Extra.fuckKeyStrokes.Slot[1].Key.jump)
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Lookback",Extra.fuckKeyStrokes.Slot[1].Key.landingGear_lookback)
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Tab",Extra.fuckKeyStrokes.Slot[1].Key.tab)
                            end
                        end
                    else
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+10)
                        if Menu:Button("| Slot 2 |") then
                            v.SlotList[1] = not v.SlotList[1]
                        end
                        if v.SlotList[1] == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Mode ##2",Extra.fuckKeyStrokes.Slot[2].Mode,"Don't Send\0Always pressed\0Random Press\0",600) 
                            if Extra.fuckKeyStrokes.Slot[2].Mode.v ~= 2 then
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+15)
                                if Menu:Button("| Key List |##2") then
                                    v.KeyList[1] = not v.KeyList[1]
                                end
                                if v.KeyList[1] == true then
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Fire",Extra.fuckKeyStrokes.Slot[2].Key.fire)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Aim",Extra.fuckKeyStrokes.Slot[2].Key.aim)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Crouch",Extra.fuckKeyStrokes.Slot[2].Key.horn_crouch)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Enter Vehicle",Extra.fuckKeyStrokes.Slot[2].Key.enterExitCar)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Sprint",Extra.fuckKeyStrokes.Slot[2].Key.sprint)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Walk",Extra.fuckKeyStrokes.Slot[2].Key.walk)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Jump",Extra.fuckKeyStrokes.Slot[2].Key.jump)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Lookback",Extra.fuckKeyStrokes.Slot[2].Key.landingGear_lookback)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Tab",Extra.fuckKeyStrokes.Slot[2].Key.tab)
                                end
                            end
                        end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+10)
                        if Menu:Button("| Slot 3 |") then
                            v.SlotList[2] = not v.SlotList[2]
                        end
                        if v.SlotList[2] == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Mode ##3",Extra.fuckKeyStrokes.Slot[3].Mode,"Don't Send\0Always pressed\0Random Press\0",600) 
                            if Extra.fuckKeyStrokes.Slot[3].Mode.v ~= 2 then
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+15)
                                if Menu:Button("| Key List |##3") then
                                    v.KeyList[2] = not v.KeyList[2]
                                end
                                if v.KeyList[2] == true then
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Fire",Extra.fuckKeyStrokes.Slot[3].Key.fire)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Aim",Extra.fuckKeyStrokes.Slot[3].Key.aim)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Crouch",Extra.fuckKeyStrokes.Slot[3].Key.horn_crouch)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Enter Vehicle",Extra.fuckKeyStrokes.Slot[3].Key.enterExitCar)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Sprint",Extra.fuckKeyStrokes.Slot[3].Key.sprint)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Walk",Extra.fuckKeyStrokes.Slot[3].Key.walk)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Jump",Extra.fuckKeyStrokes.Slot[3].Key.jump)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Lookback",Extra.fuckKeyStrokes.Slot[3].Key.landingGear_lookback)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Tab",Extra.fuckKeyStrokes.Slot[3].Key.tab)
                                end
                            end
                        end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+10)
                        if Menu:Button("| Slot 4 |") then
                            v.SlotList[3] = not v.SlotList[3]
                        end
                        if v.SlotList[3] == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Mode ##4",Extra.fuckKeyStrokes.Slot[4].Mode,"Don't Send\0Always pressed\0Random Press\0",600) 
                            if Extra.fuckKeyStrokes.Slot[4].Mode.v ~= 2 then
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+15)
                                if Menu:Button("| Key List |##4") then
                                    v.KeyList[3] = not v.KeyList[3]
                                end
                                if v.KeyList[3] == true then
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Fire",Extra.fuckKeyStrokes.Slot[4].Key.fire)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Aim",Extra.fuckKeyStrokes.Slot[4].Key.aim)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Crouch",Extra.fuckKeyStrokes.Slot[4].Key.horn_crouch)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Enter Vehicle",Extra.fuckKeyStrokes.Slot[4].Key.enterExitCar)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Sprint",Extra.fuckKeyStrokes.Slot[4].Key.sprint)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Walk",Extra.fuckKeyStrokes.Slot[4].Key.walk)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Jump",Extra.fuckKeyStrokes.Slot[4].Key.jump)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Lookback",Extra.fuckKeyStrokes.Slot[4].Key.landingGear_lookback)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Tab",Extra.fuckKeyStrokes.Slot[4].Key.tab)
                                end
                            end
                        end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+10)
                        if Menu:Button("| Slot 5 |") then
                            v.SlotList[4] = not v.SlotList[4]
                        end
                        if v.SlotList[4] == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Mode ##5",Extra.fuckKeyStrokes.Slot[5].Mode,"Don't Send\0Always pressed\0Random Press\0",600) 
                            if Extra.fuckKeyStrokes.Slot[5].Mode.v ~= 2 then
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+15)
                                if Menu:Button("| Key List |##5") then
                                    v.KeyList[4] = not v.KeyList[4]
                                end
                                if v.KeyList[4] == true then
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Fire",Extra.fuckKeyStrokes.Slot[5].Key.fire)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Aim",Extra.fuckKeyStrokes.Slot[5].Key.aim)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Crouch",Extra.fuckKeyStrokes.Slot[5].Key.horn_crouch)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Enter Vehicle",Extra.fuckKeyStrokes.Slot[5].Key.enterExitCar)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Sprint",Extra.fuckKeyStrokes.Slot[5].Key.sprint)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Walk",Extra.fuckKeyStrokes.Slot[5].Key.walk)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Jump",Extra.fuckKeyStrokes.Slot[5].Key.jump)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Lookback",Extra.fuckKeyStrokes.Slot[5].Key.landingGear_lookback)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Tab",Extra.fuckKeyStrokes.Slot[5].Key.tab)
                                end
                            end
                        end
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+10)
                        if Menu:Button("| Slot 6 |") then
                            v.SlotList[5] = not v.SlotList[5]
                        end
                        if v.SlotList[5] == true then
                            Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Mode ##6",Extra.fuckKeyStrokes.Slot[6].Mode,"Don't Send\0Always pressed\0Random Press\0",600) 
                            if Extra.fuckKeyStrokes.Slot[6].Mode.v ~= 2 then
                                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+15)
                                if Menu:Button("| Key List |##6") then
                                    v.KeyList[5] = not v.KeyList[5]
                                end
                                if v.KeyList[5] == true then
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Fire",Extra.fuckKeyStrokes.Slot[6].Key.fire)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Aim",Extra.fuckKeyStrokes.Slot[6].Key.aim)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Crouch",Extra.fuckKeyStrokes.Slot[6].Key.horn_crouch)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Enter Vehicle",Extra.fuckKeyStrokes.Slot[6].Key.enterExitCar)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Sprint",Extra.fuckKeyStrokes.Slot[6].Key.sprint)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Walk",Extra.fuckKeyStrokes.Slot[6].Key.walk)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Jump",Extra.fuckKeyStrokes.Slot[6].Key.jump)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Lookback",Extra.fuckKeyStrokes.Slot[6].Key.landingGear_lookback)
                                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Tab",Extra.fuckKeyStrokes.Slot[6].Key.tab)
                                end
                            end
                        end
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Fake Mobile", Extra.Mobile) then
                    set.MobileRecon()
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Request Spawn", Extra.RequestSpawn)
                if Extra.RequestSpawn.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:SliderInt("Health", Extra.RequestSpawnHP, 0, 100)
                    if Extra.RequestSpawnHP.v >= 100 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:SliderInt("Armour", Extra.RequestSpawnArmour, 0, 99)
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Pick PickUP", Extra.PickUP.Enable)
                if Extra.PickUP.Enable.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Pick Non Streamed", Extra.PickUP.NonStreamed)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Health##5", Extra.PickUP.HP, 0, 100)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+95,SHAkMenu.menutransitorstaticreversed+95) Menu:SliderInt("PickUP##111",Extra.PickUP.Model1, 0, 19832)
                        
                    if Extra.PickUP.HP.v >= 100 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Armour##678", Extra.PickUP.Armour, 0, 99)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+95,SHAkMenu.menutransitorstaticreversed+95) Menu:SliderInt("PickUP##222",Extra.PickUP.Model2, 0, 19832)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) if Menu:SliderInt("Delay##678", Extra.PickUP.Delay, 0, 20000) then
                        get.ScriptTimers()
                    end
                    if Extra.PickUP.HP.v < 100 then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+95,SHAkMenu.menutransitorstaticreversed+95) Menu:SliderInt("PickUP##222",Extra.PickUP.Model2, 0, 19832)
                    end
                    if Extra.PickUP.HP.v < 100 then
                        Menu:Text("") 
                    end
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+95,SHAkMenu.menutransitorstaticreversed+95) Menu:SliderInt("PickUP##780",Extra.PickUP.Model3, 0, 19832)
                    if Extra.PickUP.HP.v == 100 then
                        Menu:Text("") 
                    end
                    if not Extra.PickUP.NonStreamed.v then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderFloat("Distance##678", Extra.PickUP.Dist, 0, 350)
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Pick PickUP Range", Extra.PickUPRange.Enable)
                if Extra.PickUPRange.Enable.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("                                 ", Extra.PickUPRange.Key, 200, 20)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Min Pickup",Extra.PickUPRange.Min, 0, Extra.PickUPRange.Max.v)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Max Pickup",Extra.PickUPRange.Max, Extra.PickUPRange.Min.v, 4096)
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Anti Sniper", Extra.AntiSniper.Enable) 
                if Extra.AntiSniper.Enable.v then
                    if Extra.AntiSniper.OnKey.v then 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:Hotkey(" ##213123123123233233", Extra.AntiSniper.Key, 200, 20) 
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("OnKey ##2131231231233", Extra.AntiSniper.OnKey) 
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:SliderInt("Chance ##102", Extra.AntiSniper.Chance, 0, 100)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Type ##2",Extra.AntiSniper.TypeMode,"SpecialAction\0Surf\0\0",25) 
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Anti Aim", Extra.AntiAim.Enable)
                if Extra.AntiAim.Enable.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Pitch",Extra.AntiAim.Type,"Down\0UP\0Random\0\0",25) 
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Force Gravity", Extra.ForceGravity)
                if Extra.ForceGravity.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:SliderFloat("Gravity", Extra.GravityFloat, 0.001, 0.010)
                    set.PlayerGravity()
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Ignore Water Physic", Extra.IgnoreWater) then
                    if Extra.IgnoreWater.v then
                        Utils:writeMemory(0x6C2759, 1, 1, true)
                    else
                        Utils:writeMemory(0x6C2759, 0, 1, true)
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("NOP Weapons Update", Extra.NOPWeapons)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("No Apply Animations", Movement.NoAnimations)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Anti Slapper", Extra.AntiSlapper)
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Anti Freeze", Extra.AntiFreeze.Enable)
                if Extra.AntiFreeze.Enable.v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Interior Change", Extra.AntiFreeze.Interior)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("After Animation", Extra.AntiFreeze.Animation)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:CheckBox2("Others", Extra.AntiFreeze.Others)
                end

                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) if Menu:CheckBox2("Anti AFK", Extra.AntiAFK) then
                    set.EscState()
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10)
                if Menu:Button("| Auto Weapon Deletion |") then
                    WeaponList = not WeaponList
                end
                if WeaponList == true then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:Combo("Slot",Global.WeaponSlotCombo,"All Slots\0Slot 0\0Slot 1\0Slot 2\0Slot 3\0Slot 4\0Slot 5\0Slot 6\0Slot 7\0Slot 8\0Slot 9\0Slot 10\0Slot 11\0Slot 12\0\0",25) 
                    if Global.WeaponSlotCombo.v == 1 or Global.WeaponSlotCombo.v == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Brass Knuckles",Extra.AutoDeleteWeapon.Slot0.brassknuckles)
                    end
                    if Global.WeaponSlotCombo.v == 2 or Global.WeaponSlotCombo.v == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Gold Club",Extra.AutoDeleteWeapon.Slot1.golf)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Night Stick",Extra.AutoDeleteWeapon.Slot1.nitestick)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Knife",Extra.AutoDeleteWeapon.Slot1.knife)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Bat",Extra.AutoDeleteWeapon.Slot1.bat)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Shovel",Extra.AutoDeleteWeapon.Slot1.shovel)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Pool Cue",Extra.AutoDeleteWeapon.Slot1.pool)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Katana",Extra.AutoDeleteWeapon.Slot1.katana)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Chainsaw",Extra.AutoDeleteWeapon.Slot1.chainsaw)
                    end
                    if Global.WeaponSlotCombo.v == 3 or Global.WeaponSlotCombo.v == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Colt 9mm",Extra.AutoDeleteWeapon.Slot2.colt)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Silenced 9mm",Extra.AutoDeleteWeapon.Slot2.silenced)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Desert Eagle",Extra.AutoDeleteWeapon.Slot2.desert)
                    end
                    if Global.WeaponSlotCombo.v == 4 or Global.WeaponSlotCombo.v == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Shotgun",Extra.AutoDeleteWeapon.Slot3.shotgun)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Sawnoff",Extra.AutoDeleteWeapon.Slot3.sawnoff)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Combat",Extra.AutoDeleteWeapon.Slot3.spas)
                    end
                    if Global.WeaponSlotCombo.v == 5 or Global.WeaponSlotCombo.v == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Micro SMG/Uzi",Extra.AutoDeleteWeapon.Slot4.uzi)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("MP5",Extra.AutoDeleteWeapon.Slot4.mp5)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Tec-9",Extra.AutoDeleteWeapon.Slot4.tec9)
                    end
                    if Global.WeaponSlotCombo.v == 6 or Global.WeaponSlotCombo.v == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("AK-47",Extra.AutoDeleteWeapon.Slot5.ak47)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("m4",Extra.AutoDeleteWeapon.Slot5.m4)
                    end
                    if Global.WeaponSlotCombo.v == 7 or Global.WeaponSlotCombo.v == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Country-Rifle",Extra.AutoDeleteWeapon.Slot6.countryrifle)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Sniper-Rifle",Extra.AutoDeleteWeapon.Slot6.sniper)
                    end
                    if Global.WeaponSlotCombo.v == 8 or Global.WeaponSlotCombo.v == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Rocket Launcher",Extra.AutoDeleteWeapon.Slot7.rocketlauncher)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Heatseeker",Extra.AutoDeleteWeapon.Slot7.heatseeker)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Flamethrower",Extra.AutoDeleteWeapon.Slot7.flamethrower)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Minigun",Extra.AutoDeleteWeapon.Slot7.minigun)
                    end
                    if Global.WeaponSlotCombo.v == 9 or Global.WeaponSlotCombo.v == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Satchel Charge",Extra.AutoDeleteWeapon.Slot8.satchel)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Grenade",Extra.AutoDeleteWeapon.Slot8.grenade)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Tear Gas",Extra.AutoDeleteWeapon.Slot8.teargas)
                    end
                    if Global.WeaponSlotCombo.v == 10 or Global.WeaponSlotCombo.v == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Spray Can",Extra.AutoDeleteWeapon.Slot9.spraycan)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Fire Extinguisher",Extra.AutoDeleteWeapon.Slot9.extinguisher)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Camera",Extra.AutoDeleteWeapon.Slot9.camera)
                    end
                    if Global.WeaponSlotCombo.v == 11 or Global.WeaponSlotCombo.v == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Purple Dildo",Extra.AutoDeleteWeapon.Slot10.purpledildo)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Dildo",Extra.AutoDeleteWeapon.Slot10.dildo)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Vibrator",Extra.AutoDeleteWeapon.Slot10.vibrator)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Silver Vibrator",Extra.AutoDeleteWeapon.Slot10.silvervibrator)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Flowers",Extra.AutoDeleteWeapon.Slot10.flowers)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Cane",Extra.AutoDeleteWeapon.Slot10.cane)
                    end
                    if Global.WeaponSlotCombo.v == 12 or Global.WeaponSlotCombo.v == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Night Vision",Extra.AutoDeleteWeapon.Slot11.nightvision)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Thermal Vision",Extra.AutoDeleteWeapon.Slot11.thermalvision)
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Parachute",Extra.AutoDeleteWeapon.Slot11.Parachute)
                    end
                    if Global.WeaponSlotCombo.v == 13 or Global.WeaponSlotCombo.v == 0 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+15,SHAkMenu.menutransitorstaticreversed+15) Menu:CheckBox2("Detonator",Extra.AutoDeleteWeapon.Slot12.detonator)
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) if Menu:Button("| SpecialAction |") then
                    local SpecialACT = 0
                    if Extra.SpecialAction.v == 0 then SpecialACT = 0 end
                    if Extra.SpecialAction.v == 1 then SpecialACT = 2 end
                    if Extra.SpecialAction.v == 2 then SpecialACT = 5 end
                    if Extra.SpecialAction.v == 3 then SpecialACT = 6 end
                    if Extra.SpecialAction.v == 4 then SpecialACT = 7 end
                    if Extra.SpecialAction.v == 5 then SpecialACT = 8 end
                    if Extra.SpecialAction.v == 6 then SpecialACT = 10 end
                    if Extra.SpecialAction.v == 7 then SpecialACT = 11 end
                    if Extra.SpecialAction.v == 8 then SpecialACT = 13 end
                    if Extra.SpecialAction.v == 9 then SpecialACT = 20 end
                    if Extra.SpecialAction.v == 10 then SpecialACT = 21 end
                    if Extra.SpecialAction.v == 11 then SpecialACT = 22 end
                    if Extra.SpecialAction.v == 12 then SpecialACT = 23 end
                    if Extra.SpecialAction.v == 13 then SpecialACT = 68 end
                    if Extra.SpecialAction.v == 14 then SpecialACT = 24 end
                    if Extra.SpecialAction.v == 15 then SpecialACT = 25 end
                    if Jetpack == true then
                        Jetpack = false
                        local bsData = BitStream()
                        bsWrap:Write8(bsData, SpecialACT) 
                        EmulRPC(88,bsData)
                    else
                        Jetpack = true
                    end
                end
                Menu:SameLine(SHAkMenu.menutransitorstaticreversed+60,SHAkMenu.menutransitorstaticreversed+60) Menu:Combo("    ",Extra.SpecialAction,
                "NONE\0JETPACK\0DANCE1\0DANCE2\0DANCE3\0DANCE4\0HANDSUP\0CELLPHONE\0STOPCELLPHONE\0DRINK_BEER\0SMOKE_CIGGY\0DRINK_WINE\0DRINK_SPRUNK\0PISSING\0CUFFED\0CARRY\0\0",21)
            end
        --Chat
            Menu:Separator()
            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitor+10,SHAkMenu.menutransitor+10) 
            if Menu:Button("| Chat |") then
                SHAkMenu.resetMenuTimerStaticReversed()
                ChatList = not ChatList
                SHAkMenu.menuOpened = 0
            end
            if ChatList == true then
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Send CMD", CMD.SendCMD.Enable)
                if CMD.SendCMD.Enable.v then
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderInt("Health##2", CMD.SendCMD.HP, 0, 100)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:InputText("Message:##2",CMD.SendCMD.Command)
                    if CMD.SendCMD.HP.v >= 100 then
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:SliderInt("Armour##2", CMD.SendCMD.Armour, 0, 99)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Times##2", CMD.SendCMD.Times, 1, 20)
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("First Delay##2", CMD.SendCMD.FirstDelay, 0, 20000)
                    if CMD.SendCMD.Times.v > 1 then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:SliderInt("Delay##2", CMD.SendCMD.Delay, 0, 20000)
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+80,SHAkMenu.menutransitorstaticreversed+80) 
                        if Menu:Button("(?)##192") then
                            InfoButton2 = not InfoButton2
                        end
                        if InfoButton2 == true then
                            Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) 
                            Menu:Text("Delay for the next Time (First one will be instant)")
                        end
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Auto Reply", CMD.AutoReply[0])
                if CMD.AutoReply[0].v then
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("To Message", CMD.AutoReply[1])
                    if CMD.AutoReply[1].v then
                        Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+20,SHAkMenu.menutransitorstaticreversed+20) Menu:Text("  Message: ") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Text("  Reply With: ") 
                        Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:InputText("##1", CMD.Message[1])
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:InputText("##2", CMD.Reply[1])
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("TP To Checkpoint", CMD.Message.TeleportToCheck)
                    end
                    Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:CheckBox2("To TextDraw", CMD.AutoReply[2])
                    if CMD.AutoReply[2].v then
                        Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed+20,SHAkMenu.menutransitorstaticreversed+20) Menu:Text("  Message: ") 
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:Text("  Reply With: ") 
                        Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+10,SHAkMenu.menutransitorstaticreversed+10) Menu:InputText("##4", CMD.Message[2])
                        Menu:SameLine(SHAkMenu.menutransitorstaticreversed+105,SHAkMenu.menutransitorstaticreversed+105) Menu:InputText("##3", CMD.Reply[2])
                    end
                end
                Menu:Text("") Menu:SameLine(SHAkMenu.menutransitorstaticreversed,SHAkMenu.menutransitorstaticreversed) Menu:CheckBox2("Chat", CMD.Chat.Enable)
                --if CMD.Chat.Enable.v then
                    Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:InputText("  ##1", CMD.Chat.Chat0.Chat)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("   ", CMD.Chat.Chat0.Key, 200, 20)
                    Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:InputText("  ##2", CMD.Chat.Chat1.Chat)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("    ", CMD.Chat.Chat1.Key, 200, 20)
                    Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:InputText("  ##3", CMD.Chat.Chat2.Chat)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("     ", CMD.Chat.Chat2.Key, 200, 20)
                    Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:InputText("  ##4", CMD.Chat.Chat3.Chat)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("      ", CMD.Chat.Chat3.Key, 200, 20)
                    Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:InputText("  ##5", CMD.Chat.Chat4.Chat)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("       ", CMD.Chat.Chat4.Key, 200, 20)
                    Menu:Text("")Menu:SameLine(SHAkMenu.menutransitorstaticreversed+5,SHAkMenu.menutransitorstaticreversed+5) Menu:InputText("  ##6", CMD.Chat.Chat5.Chat)
                    Menu:SameLine(SHAkMenu.menutransitorstaticreversed+65,SHAkMenu.menutransitorstaticreversed+65) Menu:Hotkey("        ", CMD.Chat.Chat5.Key, 200, 20)
                --end
            end
    else
        AttachToVehiclemenu, TeleportList, GodmodeList, VehicleList, ExtraList, InfoButton2 = false
    end
end
return ExtraTab