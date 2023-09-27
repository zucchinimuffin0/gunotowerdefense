Type Node2D
	Field pos:SVec2D
	Field group:TList
	
	Method Create(pos:SVec2D,group:TList)
		Self.pos = pos
		Self.group = group
		Self.group.addlast(Self)
	EndMethod
	
	Method nextNode:Node2D()
		Local i:TLink = Self.group.findlink(Self)

		If i.nextlink() <> Null Then
			Return(Node2D(i.nextlink().value()))
		Else
			Return(Null)
		EndIf
	EndMethod
	
	Method prevNode:Node2D()
		Local i:TLink = Self.group.findlink(Self)
		
		If i.prevlink() <> Null Then
			Return(Node2D(i.prevlink().value()))
		Else
			Return(Null)
		EndIf
	EndMethod
EndType

Function lerp:Double(v0:Double, v1:Double, t:Double)
	Return(v0 + t*(v1-v0))
EndFunction