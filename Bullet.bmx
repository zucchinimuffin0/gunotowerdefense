Global bullet_img:TImage = LoadImage("asset\tower\bullet.png")

Type bullet
	Field pos:SVec2D
	Field rot:Double
	Field speed:Double
	Field img:TImage
	
	Method New(pos:SVec2D, rot:Double, speed:Double = 3)
		Self.pos = pos
		Self.rot = rot
		Self.speed = speed
		Self.img = bullet_img
		bullets.addlast(Self)
		
	EndMethod
	
	Method draw()
		DrawImage bullet_img, Float(Self.pos.x), Float(Self.pos.y)
	EndMethod
	
	Method update()
		Self.pos = New SVec2D(Self.pos.x + Self.speed*Cos(Self.rot), Self.pos.y + Self.speed*Sin(Self.rot))
		
		For Local e:creature = EachIn creatures
			If ImagesCollide(Self.img,Int(Self.pos.x),Int(Self.pos.y),0,e.img,Int(e.pos.x),Int(e.pos.y),0) Then
				e.health = e.health - 25
				cash = cash + 25
				bullets.remove(Self)
			EndIf
		Next
		
		If Self.pos.x > w Or Self.pos.x < 0 Or Self.pos.y > h Or Self.pos.y < 0 Then
			bullets.remove(Self)
		EndIf
	EndMethod
EndType

Global bullets:TList = New TList

Function UpdateBullets()
	For Local b:bullet = EachIn bullets
		b.update()
	Next
EndFunction

Function DrawBullets()
	For Local b:bullet = EachIn bullets
		b.draw()
	Next
EndFunction