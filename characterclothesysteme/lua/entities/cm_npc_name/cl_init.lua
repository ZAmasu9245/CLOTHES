include("shared.lua")

local nsize = 150

function ENT:Draw()
	self:DrawModel()
	
	local dist = LocalPlayer():GetPos():Distance(self:GetPos())
	
	if dist > 500 then return end
	
	local ang = Angle(0, LocalPlayer():EyeAngles().y-90, 90)
	
	local angle = self:GetAngles()	
	
	local boneid = self:LookupBone( "ValveBiped.Bip01_Head1" )
	local bonepos = self:GetBonePosition( boneid )	
	
	local position = bonepos + angle:Up() * 12
	
	angle:RotateAroundAxis(angle:Forward(), 0)
	angle:RotateAroundAxis(angle:Right(),0)
	angle:RotateAroundAxis(angle:Up(), 90)
	-- angle:Right()*0+angle:Up()*( math.sin(CurTime() * 2) * 2.5 + 78 )
	cam.Start3D2D(position, ang, 0.1)
		
		draw.RoundedBox( 0, -nsize/2, -25, nsize, 50, Color(40,40,40, 200 ) )
		local width = draw.SimpleTextOutlined( CLOTHESMOD.Config.Sentences[63][CLOTHESMOD.Config.Lang], "Bariol25" ,0,0, Color(255,255,255,500-dist), 1, 1, 1, Color(0,0,0))
		
		nsize = width + 20
		
	cam.End3D2D()
end

local blur = Material("pp/blurscreen")

local function DrawBlur( p, a, d )


	local x, y = p:LocalToScreen(0, 0)
	
	surface.SetDrawColor( 255, 255, 255 )
	
	surface.SetMaterial( blur )
	
	for i = 1, d do
	
	
		blur:SetFloat( "$blur", (i / d ) * ( a ) )
		
		blur:Recompute()
		
		render.UpdateScreenEffectTexture()
		
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
		
		
	end
	
	
end

function ENT:OpenNameMenu( ent )
	
	local errInfos = ""
	local infos = LocalPlayer():CM_GetInfos()
	local ent = ent or NULL
	
	local sizex = 430
	local sizey = 250
	
	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetPos( (ScrW()-sizex)/2, (ScrH()-sizey)/2 )
	DermaPanel:SetSize( sizex, sizey )
	DermaPanel:SetTitle( "" )
	DermaPanel:SetDraggable( false )
	DermaPanel:ShowCloseButton( false )
	DermaPanel:MakePopup()
	DermaPanel.Paint = function( pnl, w, h )
		DrawBlur( pnl, 3, 4 )
		draw.RoundedBox(0,0,0, w, h, Color(0, 0, 0,150))
		draw.RoundedBox(0,0,0, 2, h, Color(0, 0, 0))
		draw.RoundedBox(0,0,0, w, 2, Color(0, 0, 0))
		draw.RoundedBox(0,0,h-2, w, 2, Color(0, 0, 0))
		draw.RoundedBox(0,w-2,0, 2, h, Color(0, 0, 0))
		
		if errInfos and errInfos ~= "" then
			draw.SimpleText( errInfos, "Bariol15",w/2,70+40+40+35,Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
		end
		
	end
	
	local Panel = vgui.Create( "DPanel", DermaPanel )
	Panel:SetPos( 2, 2 )
	Panel:SetSize( sizex-4, 40 )
	Panel.Paint = function( pnl, w, h )
		draw.RoundedBox(0,0,0, w, h, Color(0, 0, 0,150))
		draw.SimpleText( CLOTHESMOD.Config.Sentences[63][CLOTHESMOD.Config.Lang], "Bariol25", 10,7.5, Color(255,255,255) )
	end
	
	local DermaButtonClose = vgui.Create( "DButton", DermaPanel )
	DermaButtonClose:SetText( "" )
	DermaButtonClose:SetPos( sizex-42, 2 )
	DermaButtonClose:SetSize( 40, 40 )
	DermaButtonClose.DoClick = function()
		DermaPanel:Close()
	end	
	DermaButtonClose.Paint = function( pnl, w , h )
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,120 ) )
		draw.SimpleText( "X", "Bariol25", w/2, h/2, Color(255,255,255),1,1 )
		
	end
	
	local DLabel = vgui.Create( "DLabel", DermaPanel )
	DLabel:SetPos( 20, 40+10 )
	DLabel:SetSize( sizex-40, 50 )
	DLabel:SetFont( "Bariol25" )
	DLabel:SetWrap( true )
	DLabel:SetText(CLOTHESMOD.Config.Sentences[64][CLOTHESMOD.Config.Lang].." "..CLOTHESMOD.Config.Sentences[56][CLOTHESMOD.Config.Lang].." "..CLOTHESMOD.Config.PriceChangingName..""..CLOTHESMOD.Config.MoneyUnit..".")

	local TextEntry = vgui.Create( "DTextEntry", DermaPanel ) -- create the form as a child of frame
	TextEntry:SetPos( sizex/2-100, 70 + 40 )
	TextEntry:SetSize( 200, 30 )
	TextEntry:SetText( infos.name )
	TextEntry.OnTextChanged = function( self )
		txt = self:GetValue()
		local amt = string.len(txt)
		if amt > 15 then
			self.OldText = self.OldText or infos.name
			self:SetText(self.OldText)
			self:SetValue(self.OldText)
		else
			self.OldText = txt
		end
		-- infos.name = TextEntry:GetValue()
	end
	
	local TextEntry2 = vgui.Create( "DTextEntry", DermaPanel ) -- create the form as a child of frame
	TextEntry2:SetPos( sizex/2-100, 70 + 40 * 2 )
	TextEntry2:SetSize( 200, 30 )
	TextEntry2:SetText(  infos.surname )
	TextEntry2.OnTextChanged = function( self )
		txt = self:GetValue()
		local amt = string.len(txt)
		if amt > 15 then
			self.OldText = self.OldText or infos.surname
			self:SetText(self.OldText)
			self:SetValue(self.OldText)
		else
			self.OldText = txt
		end
		-- infos.surname = TextEntry2:GetValue()
	end
	
	local ButtonAccept = vgui.Create( "DButton", DermaPanel )
	ButtonAccept:SetText( "" )
	ButtonAccept:SetPos( 0, sizey-40 )
	ButtonAccept:SetSize( sizex, 40 )
	ButtonAccept.DoClick = function()
		if string.len( TextEntry:GetValue() ) < 3 or string.len( TextEntry2:GetValue() ) < 3 then
			errInfos = CLOTHESMOD.Config.Sentences[68][CLOTHESMOD.Config.Lang]
		else
			DermaPanel:Close()
			net.Start("ClothesMod:ChangeName")
				net.WriteString(TextEntry:GetValue())
				net.WriteString(TextEntry2:GetValue())
				net.WriteEntity(self)
			net.SendToServer()
		end
	end	
	ButtonAccept.Paint = function( pnl, w , h )
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,120 ) )
		draw.SimpleText( CLOTHESMOD.Config.Sentences[65][CLOTHESMOD.Config.Lang], "Bariol25", w/2, h/2, Color(255,255,255),1,1 )
		
	end
	
end