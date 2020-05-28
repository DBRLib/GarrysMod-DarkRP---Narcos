//-----------------------------------------------------------------------
//@Aurhour Deven Ronquillo
//@Version 7/23/17
//
//weed for tnl_narcos
//
//----------------------------------------------------------------------AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
util.AddNetworkString("NetPlayerHigh")

function ENT:Initialize()

    self:SetModel("models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    
    local Phys=self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMass(4)
    self:SetUseType(SIMPLE_USE)
end

function ENT:OnTakeDamage(dmg)

    self:TakePhysicsDamage(dmg)
end

function ENT:Think()
    --
end

function ENT:Use(activator)

    if(activator.isHigh)then
        activator:PickupObject(self)
    else

        activator.isHigh=true
        net.Start("NetPlayerHigh")

            net.WriteBool(activator.isHigh)
        net.Send(activator)

        self:Remove()

        timer.Simple(60,function()

            if(IsValid(activator))then

                activator.isHigh=false
                net.Start("NetPlayerHigh")

                    net.WriteBool(activator.isHigh)
                net.Send(activator)
            end
        end)

        activator:EmitSound("ambient/fire/ignite.wav",60,150)
        local Eff=EffectData()
        Eff:SetOrigin(activator:GetShootPos())
        util.Effect("potsmoke",Eff,true,true)
    end

    self.NoPlant=false
end

function ENT:OnRemove()
    --
end