//-----------------------------------------------------------------------
//@Author Deven Ronquillo
//@Version 7/23/17
//
//weed for tnl_narcos
//
//----------------------------------------------------------------------

include("shared.lua")

function ENT:Initialize()
    --
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:Think()
    --
end

net.Receive("NetPlayerHigh",function()
    ply = LocalPlayer()

    ply.isHigh = net.ReadBool()
end)

hook.Add("RenderScreenspaceEffects","WeedEffect",function()

    local ply=LocalPlayer()

    if((ply.isHigh)and(ply:Alive()))then

        DrawBloom(.25,1,1,1,2,1,1,1,1)
        DrawMotionBlur(.03,.5,.01)
    end
end)
