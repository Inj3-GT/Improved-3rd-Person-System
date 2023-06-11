--- Script By Inj3
--- Script By Inj3
--- Script By Inj3
---- https://steamcommunity.com/id/Inj3/
local ipr_thirdp_enable, ipr_input_cam_rotate = ipr_thirdp.spawnthirdp

function ipr_thirdp.call()
    return ipr_thirdp_enable
end

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
    ipr_input_cam_rotate = not ipr_thirdp_enable
    
    hook.Call("IprThirdpCustomFunc", nil, ipr_thirdp_enable)
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
            end
            if (ipr_thirdp_enable) then
                if not ipr_thirdp.centercam and not ipr_thirdp.disablecamswap and input.IsKeyDown(ipr_thirdp.inputmovecam) then
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
        if not ipr_thirdp_enable or ipr_check_player(ply) then
            return
        end
        local ipr_angles = (ipr_input_cam_rotate) and angles:RotateAroundAxis( Vector(0,0,1), 175) or angles:Forward() * (65 + ipr_lerp_a) - angles:Right() * (ipr_lerp_c + ipr_angle_move) - angles:Up() * (1 + ipr_lerp_b)
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
        if not ipr_thirdp_enable then
            return
        end
        local ipr_player = LocalPlayer()
        if ipr_check_player(ipr_player) then
            return
        end

        local ipr_realframetime = RealFrameTime() * 2
        ipr_lerp_b = Lerp(ipr_realframetime, ipr_lerp_b, ipr_check_player(ipr_player, true) and 15 or ipr_player:KeyDown(IN_DUCK) and 25 or 0)
        ipr_lerp_a = Lerp(ipr_realframetime, ipr_lerp_a, ipr_player:KeyDown(IN_DUCK) and -30 or ipr_player:KeyDown(IN_JUMP) and -15 or ipr_player:KeyDown(IN_ATTACK2) and -70 or ipr_player:KeyDown(IN_FORWARD) and 20 or ipr_player:KeyDown(IN_FORWARD) and ipr_player:KeyDown(IN_SPEED) and 35 or 0)
        ipr_lerp_c = Lerp(ipr_realframetime, ipr_lerp_c, ipr_player:KeyDown(IN_DUCK) and 25 or ipr_player:KeyDown(IN_MOVERIGHT) and 5 or ipr_player:KeyDown(IN_MOVELEFT) and -5 or 0)
    end)
end

hook.Add("PostDrawTranslucentRenderables", "ipr_thirdp_drawtranslucent", function(bDrawingDepth, bDrawingSkybox, isDraw3DSkybox)
    if not ipr_thirdp.crosshair3denable or not ipr_thirdp_enable then
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

