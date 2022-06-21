include("swi.lua")

if SERVER then
    AddCSLuaFile("swi.lua")
    AddCSLuaFile("phrase.lua")
    AddCSLuaFile("client/cl_init.lua")
    include("server/init.lua")
else
    include("phrase.lua")
    SWI.phrase = PhraseSpace("swi")

    include("client/cl_init.lua")
end