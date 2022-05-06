--- Script By Inj3
--- Script By Inj3
--- Script By Inj3
---- https://steamcommunity.com/id/Inj3/
if SERVER then
    return
end
ipr_thirdp = ipr_thirdp or {}

----- Configuration
ipr_thirdp.spawnthirdp = false --- true = Activate the 3rd person camera at the first spawn / false = You will appear at the first spawn in first person view.
ipr_thirdp.inputenable = KEY_F1 --- Input - Enable 3rd person camera (https://wiki.facepunch.com/gmod/Enums/KEY).
ipr_thirdp.inputmovecam = KEY_P --- Input - Shoulder camera movement (https://wiki.facepunch.com/gmod/Enums/KEY).
ipr_thirdp.inputbehindcam = KEY_O --- Input - Look behind you (https://wiki.facepunch.com/gmod/Enums/KEY).
ipr_thirdp.disablecamswap = false --- Disable shoulder camera movement.
ipr_thirdp.disablecambhdview = false --- Disable camera behind view.
ipr_thirdp.centercam = true --- Center the camera on the playermodel but disable shoulder camera movement
ipr_thirdp.blacklistjob = { --- Blacklisted jobs will not be able to access the 3rd person camera.
    ["Araignee"] = true,
    ["Mouette"] = true,
    ["Pigeon"] = true,
    ["Chien"] = true,
}
ipr_thirdp.crosshair3denable = true --- Crosshair when 3rd person camera is enabled.
ipr_thirdp.crosshair3dcolor = Color(192, 57, 43) --- Color crosshair.
