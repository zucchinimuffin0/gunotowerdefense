Type Timer
	Field t:Int
	
	Method New()
		Self.t = MilliSecs()
	EndMethod
EndType

Type creature
	Field pos:SVec2D
	Field speed:Double
	Field health:Int
	Field t:Double
	Field id:String
	Field rotation:Double
	Field img:TImage
	Field node:Node2D
	Field delaytime:Int
	Field timing:timer
	
	Method New(id:String = "guno", pos:SVec2D, rotation:Double = 0, node:Node2D)
		Self.id = id
		Self.rotation = rotation
		Self.node = node
		Self.pos = node.pos
		Self.speed = Double(load_float("asset\enemy\"+id+".dat","speed"))
		Self.health = load_int("asset\enemy\"+id+".dat","health")
		
		AutoMidHandle True
		Self.img = LoadImage(load_string("asset\enemy\"+id+".dat","sprite"))
		
		Self.delaytime = Int(load_float("asset\enemy\"+id+".dat","delay")*1000)
		
		Local t:timer = New timer
		Self.timing = t
		
		creatures.addlast(Self)
	EndMethod
	
	Method draw()
		SetRotation Float(Self.rotation)
		DrawImage Self.img, Float(Self.pos.x), Float(Self.pos.y)
		
		SetRotation 0
	EndMethod

	Method update()
		If MilliSecs() - Self.timing.t < Self.delaytime Then Return
		If Self.node.nextnode() = Null Then Self.kill; Return
		
		Local xpos:Double = Self.pos.x
		Local ypos:Double = Self.pos.y
					
		Local p1:SVec2D = Self.node.pos
		Local p2:SVec2D = Self.node.nextnode().pos
	
		xpos = lerp(p1.x, p2.x, Self.t)
		ypos = lerp(p1.y, p2.y, Self.t)
		
		Self.t = Self.t + (Self.speed/p1.DistanceTo(p2))*dt
				
		If t >= 1.0 Then
			t = 0
			
			Self.node = Self.node.nextnode()
		EndIf
		
		Self.pos = New SVec2D(xpos,ypos)
		
		If Self.health <= 0 Then Self.kill()
	EndMethod
	
	Method kill()
		creatures.remove(Self)
	EndMethod
EndType


Global spawn_delay:Int = 1000
Global spawn_timer:Int = MilliSecs()


Global enemytypecount:Int = 3
Global iter:Int = 0
Global wavedata:Int[enemytypecount]


Global enemyIDs:String[enemytypecount]
enemyIDs[0] = "guno"
enemyIDs[1] = "grummuce"
enemyIDs[2] = "groggis"

Global creatures:TList = New TList

Function UpdateEnemies()
	If iter < enemytypecount Then
		If MilliSecs()-spawn_timer > spawn_delay Then
			If wavedata[iter] > 0 Then
				Local c:creature = New creature(enemyIDs[iter], New SVec2D(w/2,h/2), 0, Node2D(path.valueatindex(0)))
				wavedata[iter] = wavedata[iter] - 1
			Else
				iter = iter + 1
			EndIf
			
			spawn_timer = MilliSecs()
		EndIf
	EndIf

	For Local e:creature = EachIn creatures
		e.update()
	Next
EndFunction

Function DrawEnemies()
	For Local e:creature = EachIn creatures
		e.draw()
	Next
EndFunction


Function load_int:Int(url:String, variable:String)
	Local path:TStream = OpenFile(url)
	Local toreturn:Int
	
	If Not path Then RuntimeError("Could not find file at "+url)
	
	While Not Eof(path)		
		Local line:String[] = ReadLine(path).Split("=")
		
		If line[0] = variable Then
			toreturn = Int(line[1])
			
			CloseFile(path)
			Return(toreturn)
		EndIf
	Wend
	
	Print("Could not find property '"+variable+"'")
EndFunction



Function load_float:Float(url:String, variable:String)
	Local path:TStream = OpenFile(url)
	Local toreturn:Float

	If Not path Then RuntimeError("Could not find file at "+url)
	

	While Not Eof(path)
		Local line:String[] = ReadLine(path).Split("=")

		If line[0] = variable Then
			toreturn = Float(line[1])
			
			CloseFile(path)
			Return(toreturn)
		EndIf
	Wend
	
	Print("Could not find property '"+variable+"'")
EndFunction



Function load_string:String(url:String, variable:String)
	Local path:TStream = OpenFile(url)
	Local toreturn:String

	If Not path Then RuntimeError("Could not find file at "+url)	
	
	While Not Eof(path)
		Local line:String[] = ReadLine(path).Split("=")
		
		If line[0] = variable Then
			toreturn = String(line[1])
			
			CloseFile(path)
			Return(toreturn)
		EndIf
	Wend
	
	Print("Could not find property '"+variable+"'")
EndFunction

Function GetWaveData:Int[](url:String, header:String)
	Local file:TStream = OpenStream(url)
	Local array:Int[enemytypecount]
	
	If Not file Then
		Print("File not found at "+url)
		Return
	EndIf
	
	While Not Eof(file)
		Local line:String = ReadLine(file)
		
		If line = header Then
			For Local i = 0 To enemytypecount - 1				
				Local split:String[] = ReadLine(file).Split("=")
				
				array[i] = Int(split[1])
			Next
			Exit
		EndIf
	Wend
	
	
	Return(array)
	
	CloseStream file
EndFunction

