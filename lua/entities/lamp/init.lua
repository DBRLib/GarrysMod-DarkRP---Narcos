//-----------------------------------------------------------------------------------------------
//
//shared file for the lamp of narcos
//
//@author Deven Ronquillo
//@version 7/23/17
//-----------------------------------------------------------------------------------------------

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.uprightCarry = "y"
ENT.noPocket = true

function ENT:Initialize()

    self:SetModel("models/props_c17/light_decklight01_on.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local Phys=self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMass(40)
    self:SetUseType(SIMPLE_USE)
    -- wow, darkrp's item spawning interface is supremely shitty
    self:SetPos(self:GetPos()+Vector(0,0,25))
end

function ENT:OnTakeDamage(dmg)

    self:TakePhysicsDamage(dmg)
end

function ENT:Use(activator)

    activator:PickupObject(self)
end

function ENT:OnRemove()
    --
end