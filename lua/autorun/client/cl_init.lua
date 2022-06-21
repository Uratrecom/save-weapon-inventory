if SWIP.selectedLanguage == nil then
    SWIP:setSelectedLanguage("english")
end

hook.Add("InitPostEntity", "playerInit", function()
    chat.AddText(Color(255, 255, 255), SWIP:getPhrase("startInfo", "", true))
end)

hook.Add("PlayerSwitchWeapon", "GetName", function(player, oldWeapon, newWeapon)
    print("WeaponName:", newWeapon:GetClass())
    print("WeaponAmmo1:", player:GetAmmoCount(newWeapon:GetPrimaryAmmoType()), newWeapon:GetPrimaryAmmoType())
    print("WeaponAmmo2:", player:GetAmmoCount(newWeapon:GetSecondaryAmmoType()), newWeapon:GetSecondaryAmmoType())
end)

CreateConVar("swi_admin_save_weapons", "1", {
    FCVAR_SERVER_CAN_EXECUTE,
    FCVAR_CLIENTCMD_CAN_EXECUTE,
    FCVAR_NOTIFY,
    FCVAR_ARCHIVE
}, "", 0, 1)

CreateConVar("swi_admin_allow_sets", "1", {
    FCVAR_SERVER_CAN_EXECUTE, 
    FCVAR_CLIENTCMD_CAN_EXECUTE, 
    FCVAR_NOTIFY,
    FCVAR_ARCHIVE
}, "", 0, 1)

CreateConVar("swi_admin_cleanup_time", "5", {
    FCVAR_SERVER_CAN_EXECUTE,
    FCVAR_CLIENTCMD_CAN_EXECUTE,
    FCVAR_NOTIFY,
    FCVAR_ARCHIVE
}, "", 0, 1440)

CreateClientConVar("swi_save_weapons", "1", true, true, "", 0, 1)
CreateClientConVar("swi_set_cleanup_ammo", "1", true, true, "", 0, 1)
CreateClientConVar("swi_set_cleanup_weapons", "1", true, true, "", 0, 1)
CreateClientConVar("swi_set_base_ammo", "1", true, true, "", 0, 1)
CreateClientConVar("swi_base_ammo", "1", true, true, "", 0, 1)
CreateClientConVar("swi_select_weapon", "1", true, true, "", 0, 1)

concommand.Add("swi_default_weapons", function(player)
    net.Start("GiveDefaultWeapons")
    net.SendToServer()
end)

concommand.Add("swi_default_weapons_with_ammo", function(player)
    net.Start("GiveDefaultWeaponsWithAmmo")
    net.SendToServer()
end)

concommand.Add("swi_cleanup_all_weapons", function(player)
    net.Start("CleanupAllWeapons")
    net.SendToServer()
end)

concommand.Add("swi_cleanup_active_weapon", function(player)
    net.Start("CleanupActiveWeapon")
    net.SendToServer()
end)

concommand.Add("swi_cleanup_ammo", function(player)
    net.Start("CleanupAllAmmo")
    net.SendToServer()
end)

concommand.Add("swi_menu", function(player)
    SWI.Gui.menu()
end)