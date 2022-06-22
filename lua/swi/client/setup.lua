CreateConVar("swi_sv_save_weapons", "1", {
    FCVAR_NOTIFY,
    FCVAR_ARCHIVE
}, "", 0, 1)

CreateClientConVar("swi_save_weapons", "1", true, true, "", 0, 1)
CreateClientConVar("swi_base_ammo", "0", true, true, "", 0, 1)
CreateClientConVar("swi_select_weapon", "1", true, true, "", 0, 1)
CreateClientConVar("swi_hide_history", "1", true, true, "", 0, 1)

local function SetHistory(hide) 
    if tobool(hide) then
        hook.Add("HUDDrawPickupHistory", "swi_hide_history", function()
            return true
        end)
    else
        hook.Remove("HUDDrawPickupHistory", "swi_hide_history")
    end
end

SetHistory(GetConVar("swi_hide_history"):GetBool())

cvars.AddChangeCallback("swi_hide_history", function(_, old, new)
    SetHistory(new)
end)

concommand.Add("swi_cleanup_all", function()
    net.Start("swi_cleanup_all")
    net.SendToServer()
end)

concommand.Add("swi_cleanup_all_weapons", function()
    net.Start("swi_cleanup_all_weapons")
    net.SendToServer()
end)

concommand.Add("swi_cleanup_all_ammo", function()
    net.Start("swi_cleanup_all_ammo")
    net.SendToServer()
end)

concommand.Add("swi_cleanup_active_weapon", function()
    net.Start("swi_cleanup_active_weapon")
    net.SendToServer()
end)

concommand.Add("swi_cleanup_active_ammo", function()
    net.Start("swi_cleanup_active_ammo")
    net.SendToServer()
end)