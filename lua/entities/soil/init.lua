//-----------------------------------------------------------------------------------------------
//
//dirt of narcos
//
//@author Deven Ronquillo
//@version 7/20/17
//-----------------------------------------------------------------------------------------------

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.noPocket=true

function ENT:Initialize()

    self:SetModel("models/props_granary/grain_sack.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetModelScale(.5)
    local Phys=self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMass(10)
    self:
    SetUseType(SIMPLE_USE)
end

function ENT:OnTakeDamage(dmg)

    self:TakePhysicsDamage(dmg)
end

function ENT:Think()
    --
end

function ENT:Use(activator)

    activator:PickupObject(self)
end

function ENT:OnRemove()
    --
end