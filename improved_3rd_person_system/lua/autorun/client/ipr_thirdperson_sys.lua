--- Script By Inj3
--- Script By Inj3
--- Script By Inj3
---- https://steamcommunity.com/id/Inj3/
local ipr_thirdp_enable, ipr_input_cam_rotate = ipr_thirdp.spawnthirdp and false or not ipr_thirdp.spawnthirdp and true

local function ipr_check_player(ipr_player, ipr_bool)
    if (ipr_bool) then
        if (IsValid(ipr_player:GetActiveWeapon()) and ipr_player:GetActiveWeapon():GetMaxClip1() < 1) then
            return true
        end
    else
        if not ipr_player:Alive() or (ipr_thirdp.blacklistjob and ipr_thirdp.blacklistjob[team.GetName(ipr_player:Team())]) or ipr_player:InVehicle() or (FSpectate and (FSpectate.getSpecEnt() ~= nil)) then
            return true
        end
    end
    return false
end

local function ipr_enable_pass()
    ipr_thirdp_enable = not ipr_thirdp_enable
    if not ipr_thirdp_enable then ipr_input_cam_rotate = false end
    hook.Call("IprThirdpCustomFunc", nil, ipr_thirdp_enable and false or not ipr_thirdp_enable and true)
end
 
local ipr_angle_move = ipr_thirdp.centercam and 5 or 20 do
    local ipr_input_cam_bool
    hook.Add( "PlayerButtonDown", "ipr_thirdp_playerbut_down", function(ply, button)
        local ipr_delay_input = CurTime()
        if ipr_delay_input > (ply.delayinput3rdp or 0) then
            if ipr_check_player(ply) then
                return
            end
            if input.IsKeyDown(ipr_thirdp.inputenable) then
                ipr_enable_pass()
                return
            end
            if not ipr_thirdp_enable then
                if not ipr_thirdp.centercam and not disablecamswap and input.IsKeyDown(ipr_thirdp.inputmovecam) then
                    if not ipr_input_cam_bool then ipr_angle_move = -ipr_angle_move ipr_input_cam_bool = true else ipr_angle_move = ipr_angle_move ipr_input_cam_bool = false end
                end
                if not ipr_thirdp.disablecambhdview and input.IsKeyDown(ipr_thirdp.inputbehindcam) then
                    if not ipr_input_cam_rotate then ipr_input_cam_rotate = true else ipr_input_cam_rotate = false end
                end
            end
            ply.delayinput3rdp = ipr_delay_input + 0.3
        end
    end)
end
    
do
    local ipr_lerp_a, ipr_lerp_b, ipr_lerp_c = 0, 0, 0
    hook.Add("CalcView", "ipr_thirdp_calcview", function(ply, origin, angles, fov, znear, zfar)
        if ipr_thirdp_enable or ipr_check_player(ply) then
            return
        end
        if (ipr_input_cam_rotate) then
            angles:RotateAroundAxis( Vector(0,0,1), 175)
        end
        local ipr_angles = angles:Forward() * (65 + ipr_lerp_a) - angles:Right() * (ipr_lerp_c + ipr_angle_move) - angles:Up() * (1 + ipr_lerp_b)
        local ipr_tracehull = util.TraceHull({
            start = origin,
            endpos = origin - ipr_angles,
            filter = {ply:GetActiveWeapon(), ply},
            mins = Vector( -10, -10, -10 ),
            maxs = Vector( 10, 10, 10 )
        })

        return {
            origin = ipr_tracehull.HitPos,
            angles = angles,
            fov = fov,
            drawviewer = true,
        }
    end)

    hook.Add("InputMouseApply", "ipr_thirdp_inputmouse", function(cmd, x, y, ang)
        if ipr_thirdp_enable then
            return
        end
        local ipr_player = LocalPlayer()
        if ipr_check_player(ipr_player) then
            return
        end

        local ipr_realframetime = RealFrameTime() * 2
        if ipr_check_player(ipr_player, true) then
            ipr_lerp_b = Lerp(ipr_realframetime, ipr_lerp_b, 15)
        end

        if ipr_player:KeyDown(IN_DUCK) then
            ipr_lerp_a = Lerp(ipr_realframetime, ipr_lerp_a, -30)
            ipr_lerp_b = Lerp(ipr_realframetime, ipr_lerp_b, 25)
            ipr_lerp_c = Lerp(ipr_realframetime, ipr_lerp_c, 25)
        end
        if ipr_player:KeyDown(IN_JUMP) then
            ipr_lerp_a = Lerp(ipr_realframetime, ipr_lerp_a, -15)
        end
        if ipr_player:KeyDown(IN_ATTACK2) then
            ipr_lerp_a = Lerp(ipr_realframetime, ipr_lerp_a, -70)
        end
        if ipr_player:KeyDown(IN_FORWARD) then
            ipr_lerp_a = Lerp(ipr_realframetime, ipr_lerp_a, 20)
            if ipr_player:KeyDown(IN_SPEED) then
                ipr_lerp_a = Lerp(ipr_realframetime, ipr_lerp_a, 35)
            end
        end
        if ipr_player:KeyDown(IN_MOVERIGHT) then
            ipr_lerp_c = Lerp(ipr_realframetime, ipr_lerp_c, 5)
        elseif ipr_player:KeyDown(IN_MOVELEFT) then
            ipr_lerp_c = Lerp(ipr_realframetime, ipr_lerp_c, -5)
        end

        ipr_lerp_a = Lerp(ipr_realframetime, ipr_lerp_a, 0)
        ipr_lerp_b = Lerp(ipr_realframetime, ipr_lerp_b, 0)
        ipr_lerp_c = Lerp(ipr_realframetime, ipr_lerp_c, 0)
    end)
end

hook.Add("PostDrawTranslucentRenderables", "ipr_thirdp_drawtranslucent", function(bDrawingDepth, bDrawingSkybox, isDraw3DSkybox)
    if not ipr_thirdp.crosshair3denable or ipr_thirdp_enable then
        return
    end
    local ipr_player = LocalPlayer()
    if ipr_check_player(ipr_player, true) or ipr_check_player(ipr_player) then
        return
    end
    local ipr_eyetrace = ipr_player:GetEyeTrace()
    if ipr_player:GetPos():DistToSqr(ipr_eyetrace.HitPos) > 2000000 then
        return
    end

    render.SetColorMaterial()
    render.DrawSphere(ipr_eyetrace.HitPos + Vector(1, 1, 1) * ipr_eyetrace.HitNormal, 1, 50, 50, ipr_thirdp.crosshair3dcolor)
end)

concommand.Add( "ipr_thirdp", function(ply, cmd, args)
    ipr_enable_pass()
end)

