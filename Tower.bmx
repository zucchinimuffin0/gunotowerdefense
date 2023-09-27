Global turret_00_base_img:TImage = LoadImage("asset\tower\turret_00_base.png")
Global turret_00_gun_img:TImage = LoadImage("asset\tower\turret_00_gun.png")

Global spikes_img:TImage = LoadImage("asset\tower\spikes.png")

Global shoot_0_sfx:TSound = LoadSound("asset\sfx\shoot_0.wav")

Type tower
	Field pos:SVec2D
	Field rot:Double
	Field id:String
	Field range:Int
	Field timer:Int
	Field delaytime:Int
	
	Method New(id:String = "turret", pos:SVec2D, range = 75)
		Self.id = id
		Self.pos = pos
		Self.range = range
		Self.timer = MilliSecs()
		Self.delaytime = 2000
		towers.addlast(Self)
	EndMethod
	
	Method draw()		
		If debugmode Then
			DrawOval Float(Self.pos.x - Self.range), Float(Self.pos.y - Self.range), Self.range*2, Self.range*2
		EndIf
			
		Select Self.id
			Case "turret"
				DrawImage turret_00_base_img, Float(Self.pos.x), Float(Self.pos.y)
				
				SetRotation Float(Self.rot)
				DrawImage turret_00_gun_img, Float(Self.pos.x), Float(Self.pos.y)
			Case "spikes"
				DrawImage spikes_img, Float(Self.pos.x), Float(Self.pos.y)
		EndSelect
		

		SetRotation 0
	EndMethod
	
	Method update()	
		For Local e:creature = EachIn creatures
			Select Self.id
				Case "turret"
					If Self.pos.distanceto(e.pos) <= Self.range Then
						Self.rot = ATan2(e.pos.y - Self.pos.y, e.pos.x - Self.pos.x)
						
						If MilliSecs() - Self.timer >= Self.delaytime Then
							PlaySound(shoot_0_sfx)
							Local b:bullet = New bullet(Self.pos, Self.rot)
							
							Self.timer = MilliSecs()
						EndIf
					EndIf
				Case "spikes"
					If Self.pos.distanceto(e.pos) <= Self.range Then
						e.health = e.health - 25
						
						towers.remove(Self)
					EndIf				
			EndSelect
		Next
	EndMethod
EndType

Global towers:TList = New TList

Function UpdateTowers()
	For Local t:tower = EachIn towers
		t.update()
	Next
EndFunction

Function DrawTowers()
	For Local t:tower = EachIn towers
		t.draw()
	Next
EndFunction
