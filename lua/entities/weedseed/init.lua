//-----------------------------------------------------------------------
//@Aurhour Deven Ronquillo
//@Version 7/23/17
//
//weed seed for tnl_narcos
//
//----------------------------------------------------------------------

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/weapons/w_bugbait.mdl")
    
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local Phys=self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMass(2)
    self:SetModelScale(.5)
    self:SetUseType(SIMPLE_USE)
end

function ENT:OnTakeDamage(dmg)

    self:TakePhysicsDamage(dmg)
end

function ENT:Think()
    --
end

function ENT:Use(activator)

    activator:PickupObject(self)
    self.NoPlant=false
end

function ENT:OnRemove()
    --
end