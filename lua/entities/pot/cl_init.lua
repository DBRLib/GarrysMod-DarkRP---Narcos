//-----------------------------------------------------------------------------------------------
//
//shared file for the pot of narcos
//
//@author Deven Ronquillo
//@version 7/20/17
//-----------------------------------------------------------------------------------------------

include("shared.lua")

surface.CreateFont( "PotFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 200,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "SmolPotFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 50,
	weight = 550,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


function ENT:Initialize()
    --
end

local Leaf=surface.GetTextureID("mat_jack_job_potleaf")
ENT.plantWaterWidth = 700
ENT.plantHealthWidth = 700
ENT.plantLightWidth = 700

function ENT:Draw()

    self:DrawModel()

    if LocalPlayer():GetPos():Distance(self:GetPos()) <= 500 then

    	if(self:GetStage()>=20)then

        	local OrigR,OrigG,OrigB=render.GetColorModulation()
        	local SelfPos,Up,Right,Forward,Ang=self:GetPos(),self:GetUp(),self:GetRight(),self:GetForward(),self:GetAngles()
        	Ang:RotateAroundAxis(Ang:Right(),90)
        	Ang:RotateAroundAxis(Ang:Up(),-90)


        	cam.Start3D2D(SelfPos-Forward*8+Up*10+Right*-4,Ang,.01)

        	draw.RoundedBox(0,0,0,1000,890,string.ToColor(GetConVar("cl_colorZone1"):GetString()))
        	draw.RoundedBox(0,30,230,940,630,string.ToColor(GetConVar("cl_colorZone2"):GetString()))
        	draw.RoundedBox(0,30,30,230,200,string.ToColor(GetConVar("cl_colorZone2"):GetString()))

        	draw.RoundedBox(0,60,460,170,170,string.ToColor(GetConVar("cl_colorZone3"):GetString()))
        	draw.RoundedBox(0,60,260,170,170,string.ToColor(GetConVar("cl_colorZone3"):GetString()))
        	draw.RoundedBox(0,60,60,170,170,string.ToColor(GetConVar("cl_colorZone3"):GetString()))
        	draw.RoundedBox(0,60,660,170,170,string.ToColor(GetConVar("cl_colorZone3"):GetString()))

        	draw.RoundedBox(0,240,660,720,170,string.ToColor(GetConVar("cl_colorZone3"):GetString()))
        	draw.RoundedBox(0,240,260,720,170,string.ToColor(GetConVar("cl_colorZone3"):GetString()))
        	draw.RoundedBox(0,240,460,720,170,string.ToColor(GetConVar("cl_colorZone3"):GetString()))

        	draw.RoundedBox(0,250,470,700,150,string.ToColor(GetConVar("cl_colorZone2"):GetString()))
        	draw.RoundedBox(0,250,270,700,150,string.ToColor(GetConVar("cl_colorZone2"):GetString()))
        	draw.RoundedBox(0,250,670,700,150,string.ToColor(GetConVar("cl_colorZone2"):GetString()))

        	draw.SimpleText("Ready?","PotFont",460,130,Color(255,255,255),1,1)
        	draw.SimpleText("Noh.","SmolPotFont",690,160,Color(255,255,255),1,1)

        	surface.SetMaterial(Material("materials/icons/health.png"))
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect( 70, 670, 150, 150)

			surface.SetMaterial(Material("materials/icons/water.png"))
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect( 25, 430, 250, 250)

			surface.SetMaterial(Material("materials/icons/light.png"))
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect( -5, 210, 300, 300)



        	------lerp lighhhhtt--------

        	self.plantLightWidth = Lerp(10 * FrameTime(), self.plantLightWidth, math.Clamp(700 *((self:GetPlantLight() -.5) / 1),0,700))
        	draw.RoundedBox(0,250, 270, self.plantLightWidth, 150,Color(0, 255, 0, 120))

        	-------waterrrr lerppp-------

        	self.plantWaterWidth = Lerp(10 * FrameTime(), self.plantWaterWidth, 700 * (self:GetHydration() / 100))
        	draw.RoundedBox(0,250,470, self.plantWaterWidth, 150,Color(0, 0, 255, 120))

        	-----lerpHealth-----

        	self.plantHealthWidth = Lerp(10 * FrameTime(), self.plantHealthWidth, 700 * (self:GetPlantHealth() / 100))
        	draw.RoundedBox(0,250,670, self.plantHealthWidth, 150 ,Color(255, 0, 0, 120))

			if(self:GetStage()>=90)then
				surface.SetMaterial(Material("materials/icons/checkmark.png"))
				surface.SetDrawColor(Color(255,255,255,255))
				surface.DrawTexturedRect(70,70,150,150)
			end
		
        	cam.End3D2D()
    	end
	end
end
