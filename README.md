# Improved-3rd-Person-System
- Path for Config file : improved_3rd_person_system\lua\autorun\ipr_thirdperson_sys_config.lua

- Activate with the F1 key on your keyboard.
- Change the shoulder camera with the P key on your keyboard.
- Rotate the camera to look behind you with the O key on your keyboard.
- Dynamic, smooth and fluid third person camera.
- The camera does not cross the wall when you are close.
- The camera moves dynamically according to your movements.
- Configure whether players should appear in 1st, or 3rd person view.
- Crosshair 3d2d included (active only in 3rd person).
- Console command: ipr_thirdp
- Optimized code, no FPS IMPACT ! 

For developers (client) :

-- You can use this hook to find out the status of the 3rd person.
Example : 
hook.Add("IprThirdpCustomFunc", "UniqueName_Hook", function(status)
    if (status) then
        hook.Remove("HUDPaint", "My_CrossHair")
    else
        hook.Add("HUDPaint", "My_CrossHair", My_CrossHair)
    end
end)
-- or you can use this function allows you to return the status of the 3rd person.
ipr_thirdp.call() 
