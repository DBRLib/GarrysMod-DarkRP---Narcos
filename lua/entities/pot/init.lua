//-----------------------------------------------------------------------------------------------
//
//shared file for the pot of narcos
//
//@author Deven Ronquillo
//@version 7/20/17
//-----------------------------------------------------------------------------------------------

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.uprightCarry = "y"
ENT.noPocket = true

function ENT:Initialize()

    self:SetModel("models/nater/weedplant_pot.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local Phys = self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMaterial("grass")
    Phys:SetMass(15)
    self.NextThink=0
    self:SetUseType(SIMPLE_USE)
    self:SetPlantHealth(100)
    self:SetHydration(50)
    self:SetStage(0)
    self:SetPlantLight(.5)
end

function ENT:OnTakeDamage(dmg)

    self:TakePhysicsDamage(dmg)
    if((dmg:IsDamageType(DMG_BURN))or(dmg:IsDamageType(DMG_PLASMA)))then self:Ignite(30) end
    if(self:GetStage()<=10)then
        self:Break()
    else
        self:Deteriorate(dmg:GetDamage()*2)
    end
end

function ENT:PhysicsCollide(dat,ent)

    local Class,Stage=dat.HitEntity:GetClass(),self:GetStage()

    if((Class=="soil")and(Stage<10))then

        self:Soil(dat.HitEntity)
    elseif((Class=="weedseed")and(Stage>=10)and(Stage<20))then

        self:Plant(dat.HitEntity)
    elseif((Class=="water")and (self:GetHydration() < 100)) then

        self:Water(dat.HitEntity)
    end

    local Spd=(dat.OurOldVelocity-dat.TheirOldVelocity):Length()
    if((Spd>100)and(dat.DeltaTime>.2))then self:EmitSound("Pottery.ImpactHard") end
    if((Spd>750)and not(self:IsPlayerHolding()))then self:Break() end
end

function ENT:Think()

    if(self:GetStage()>=20)then

        self:Light()

        if(self:CanGrow())then
            if(self:GetPlantHealth()>=70)then
                self:Grow(math.Rand(.1,.3)*self:GetPlantLight())
                self:Dehydrate(math.Rand(.15,.3)*self:GetPlantLight())
            else
                self:Repair(math.Rand(.4,.6)*self:GetPlantLight())
                self:Dehydrate(math.Rand(.2,.3)*self:GetPlantLight())
            end
        else
            self:Deteriorate(math.Rand(.2,.4))
        end
    end
   self:NextThink(CurTime() + .3)
    return true
end

function ENT:Use(activator)

    if(self:GetStage()>90)then
        self:Harvest(activator)
    else
        activator:PickupObject(self)
    end
end
function ENT:OnRemove()
    --
end

function ENT:CanGrow()

    if((self:GetHydration()>0)and(self:GetUp().z>.25))then
        local PConts=util.PointContents(self:GetPos())
        if((PConts==CONTENTS_TESTFOGVOLUME)or(PConts==CONTENTS_EMPTY))then
            for key,item in pairs(ents.FindInSphere(self:GetPos(),120*self.Params.LampDistance))do
                if((item:GetClass()=="lamp")and(self:Visible(item)))then

                    return true
                end
            end
        end
    end
    return false
end

function ENT:Harvest(ply)

    local SeedNum,WeedNum,Pos,Vel=math.Round(math.Rand(0,2.5)*self.Params.SeedYield),math.Round(math.Rand(2,4)*self.Params.CropYield),self:GetPos()+self:GetUp()*20,self:GetPhysicsObject():GetVelocity()
    for i=0,SeedNum do
        local Seed=ents.Create("weedseed")
        Seed.NoPlant=true
        Seed:SetPos(Pos+VectorRand()*math.random(1,10))
        Seed:SetAngles(VectorRand():Angle())
        Seed:Spawn()
        Seed:Activate()
        Seed:GetPhysicsObject():SetVelocity(Vel+Vector(0,0,math.random(10,60)))
    end
    for i=0,WeedNum do
        local Seed=ents.Create("weed")
        Seed:SetPos(Pos+VectorRand()*math.random(1,10))
        Seed:SetAngles(VectorRand():Angle())
        Seed:Spawn()
        Seed:Activate()
        Seed:GetPhysicsObject():SetVelocity(Vel+Vector(0,0,math.random(10,60)))
    end
    self:EmitSound("Grass.StepLeft")
    self:EmitSound("Grass.StepRight")
    self:DispatchEffect("potbust")
    if(math.random(1,5*self.Params.SoilLongevity)==1)then
        self:SetStage(0)
        self:SetModel("models/nater/weedplant_pot.mdl")

        local children = self:GetChildren()
        children[1]:Remove()
    else
        self:Die()
    end
end
function ENT:Light()

    for key,item in pairs(ents.FindInSphere(self:GetPos(),120*self.Params.LampDistance))do
        if((item:GetClass()=="lamp")and(self:Visible(item)))then

            self:SetPlantLight(   ((120*self.Params.LampDistance - self:GetPos():Distance(item:GetPos())) / 120*self.Params.LampDistance) +.5 )
        end
    end
end

function ENT:Soil(soil)

    SafeRemoveEntity(soil)
    self:SetStage(10)
    self:SetHydration(50)
    self:EmitSound("Dirt.Impact")

    local Pos,Ang,Vel=self:GetPos(),self:GetAngles(),self:GetPhysicsObject():GetVelocity()

    self:SetModel("models/nater/weedplant_pot_dirt.mdl")
    self:SetPos(Pos)
    self:SetAngles(Ang)
    self:GetPhysicsObject():SetVelocity(Vel)
end

function ENT:Plant(seed)

    seed:Remove()
    self:SetStage(20)
    self:SetPlantHealth(100)
    self:EmitSound("Dirt.Impact")
    
    createChildWeedPlant(self)
end

function createChildWeedPlant(ent)
    
    childWeedPlant = ents.Create( "prop_dynamic" )
    childWeedPlant:SetModel("models/rottweiler/drugs/cannabis_flowering.mdl" )
    childWeedPlant:SetPos(ent:GetPos()+Vector(0,0,10))
    childWeedPlant:SetAngles(ent:GetAngles())
    childWeedPlant:SetParent(ent)
    childWeedPlant:SetModelScale(0)

    ent:DeleteOnRemove(childWeedPlant)

    childWeedPlant:Spawn()
end



function ENT:Grow(amt)

    local children = self:GetChildren()

    local newStage = math.Clamp(self:GetStage()+amt*self.Params.GrowthRate,20,100)
    

    children[1]:SetModelScale(Lerp(5*FrameTime(), .01*(self:GetStage() - 20), .01*(newStage)))
    self:SetStage(newStage)
end

function ENT:Repair(amt)

    if (self:GetPlantHealth()>=90) then
        self:SetPlantHealth(math.Clamp(self:GetPlantHealth()+amt*self.Params.GrowthRate,0,100))
    end
end

function ENT:Water(water)

    SafeRemoveEntity(water)
    self:SetHydration(math.Clamp(self:GetHydration() + 35,0,100))
end

function ENT:Dehydrate(amt)

    self:SetHydration(math.Clamp(self:GetHydration()-amt*self.Params.WaterNeed,0,100))
end

function ENT:Deteriorate(amt)

    self:SetPlantHealth(math.Clamp(self:GetPlantHealth()-amt/self.Params.Hardiness,0,100))
    if(self:GetPlantHealth()<=0)then self:Die() end
end

function ENT:Die()

    local children = self:GetChildren()

    self:SetStage(10)
    children:Remove()
end

function ENT:Break()

    self:EmitSound("Pottery.Break")
    self:DispatchEffect("potbreak")
    if(self:GetStage()>=30)then
        self:EmitSound("Grass.StepLeft")
        self:EmitSound("Grass.StepRight")
        self:DispatchEffect("potbust")
    end
    self:Remove()
end

function ENT:DispatchEffect(eff)

    local EffDat=EffectData()
    EffDat:SetOrigin(self:GetPos()+self:GetUp()*10)
    util.Effect(eff,EffDat,true,true)
end

hook.Add("GetPreferredCarryAngles","potCarry",function(ent)
    if(ent.uprightCarry)then
        local Angel=Angle(0,0,0)
        Angel[ent.uprightCarry]=0
        return Angel
    end
end)