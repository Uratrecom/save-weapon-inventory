CreateConVar("swi_sv_save_weapons", "1", {
    FCVAR_NOTIFY,
    FCVAR_ARCHIVE
}, "", 0, 1)

CreateClientConVar("swi_save_weapons", "1", true, true, "", 0, 1)
CreateClientConVar("swi_base_ammo", "1", true, true, "", 0, 1)
CreateClientConVar("swi_select_weapon", "1", true, true, "", 0, 1)

concommand.Add("swi_default_weapons", function(player)
    net.Start("Swi_GiveDefaultSet")
    net.SendToServer()
end)

concommand.Add("swi_cleanup_all_weapons", function(player)
    net.Start("Swi_CleanupAllWeapons")
    net.SendToServer()
end)

concommand.Add("swi_cleanup_active_weapon", function(player)
    net.Start("Swi_CleanupActiveWeapon")
    net.SendToServer()
end)

concommand.Add("swi_cleanup_ammo", function(player)
    net.Start("Swi_CleanupAllAmmo")
    net.SendToServer()
end)

PrintTable(LocalPlayer().ArcCW_AttInv)