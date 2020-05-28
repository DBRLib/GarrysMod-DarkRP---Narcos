//-----------------------------------------------------------------------------------------------
//
//shared file for the lamp of narcos
//
//@author Deven Ronquillo
//@version 7/23/17
//-----------------------------------------------------------------------------------------------

include("shared.lua")

function ENT:Initialize()
    --
end

local LightMat=Material("sprites/glow01")
LightMat:SetInt("$spriterendermode",7)

local SetYah=false

function ENT:Draw()

    if not(SetYeah)then LightMat:SetInt("$spriterendermode",7);SetYeah=true end

    local Pos=self:GetPos()+self:GetUp()+self:GetForward()*5
    render.SetMaterial(LightMat)
    render.DrawSprite(Pos,100,100,Color(255,230,175,50))
    render.SuppressEngineLighting(true)

    self:DrawModel()
    render.SuppressEngineLighting(false)
     
end

function ENT:Think()
    --
end