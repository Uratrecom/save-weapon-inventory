Swi = {}

for _, f in pairs(file.Find("swi/shared/*", "LUA")) do
    AddCSLuaFile("swi/shared/" .. f)
    include("swi/shared/" .. f)
end

for _, f in pairs(file.Find("swi/client/*", "LUA")) do
    AddCSLuaFile("swi/client/" .. f)
    if CLIENT then include("swi/client/" .. f) end
end

if SERVER or game.SinglePlayer() then
    for _, f in pairs(file.Find("swi/server/*", "LUA")) do
        include("swi/server/" .. f)
    end
end