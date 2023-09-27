Const w = 640
Const h = 480

Graphics w, h

Include "Node2D.bmx"

Global level:Int = 10
Global cash:Int = 250

Global path:TList
Global level_bg:TImage
Global level_path:TImage

Global totalenemies:Int

AutoImageFlags MASKEDIMAGE

AutoMidHandle True

Include "Bullet.bmx"
Include "Tower.bmx"
Include "Creature.bmx"

Global oldtime = MilliSecs()
Global debugmode = False

Global roundStarted = False


Global dt:Float = 0.016
Global fps
Global fpsTimer
Global fpsTicks

InitLevel("grass_00", level)

While Not KeyDown(KEY_ESCAPE)
	If (MilliSecs() - fpsTimer > 1000)
		fpsTimer = MilliSecs()
		fps = fpsTicks
		fpsTicks = 0
	Else
		fpsTicks = fpsTicks + 1
	EndIf

	If fps <> 0 Then dt = 1.0/Float(fps)

	Cls
	
		
	If roundStarted Then
		UpdateEnemies()
		UpdateTowers()
		UpdateBullets()
	EndIf
	
	If MouseHit(1) And cash >= 250 Then
		Local b:tower = New tower("spikes", New SVec2D(MouseX(), MouseY()), 16)
		cash = cash - 250
	EndIf
	
	If KeyHit(KEY_F1) Then debugmode = Not debugmode
	
	If KeyHit(KEY_SPACE) And roundstarted = False Then roundstarted = True
	
	SetColor 255,255,255

	DrawImage level_path,0,0
	DrawImage level_bg,0,0

	DrawTowers()	
	DrawEnemies()
	DrawBullets()
	
	DrawText2 "Cash: "+cash, 10, 20
	
	If debugmode Then DebugDraw()

	Flip
Wend
End

Function InitLevel(levelid:String, lvl:Int)
	AutoMidHandle False
	SetBlend ALPHABLEND
	level_bg = LoadImage("asset\map\"+levelid+"_bg.png", MASKEDIMAGE)
	level_path = LoadImage("asset\map\"+levelid+"_path.png")
	
	path = getpathfromfile("asset\map\"+levelid+".dat")
	
	
	iter = 0
	spawn_timer = MilliSecs()
	
	wavedata = getwavedata("asset\map\"+levelid+".ef","[lvl "+lvl+"]")
	
	totalenemies = sumarray(wavedata)

	roundStarted = False
EndFunction

Function DebugDraw()
	For Local o:Node2D = EachIn path

		If o.nextnode() <> Null Then
			DrawLine Float(o.pos.x),Float(o.pos.y),Float(o.nextnode().pos.x),Float(o.nextnode().pos.y)
		EndIf
	
		DrawText Int(o.pos.x)+", "+Int(o.pos.y),Float(o.pos.x+5),Float(o.pos.y+5)
		DrawOval Float(o.pos.x),Float(o.pos.y),4,4
	Next
	
	DrawText2 "FPS: "+fps, 10, 0
	DrawText MouseX()+", "+MouseY(), MouseX()+10,MouseY()+10
EndFunction

Function GetPathFromFile:TList(url:String)
	Local path:TStream = OpenFile(url)
	
	Local list:TList = New TList
	
	While Not Eof(path)
		Local x:Int
		Local y:Int
		
		Local str:String[] = ReadLine(path).Split(",")
		
		x = Int(str[0])
		y = Int(str[1])
				
		Local n:Node2D = New Node2D
		n.Create(New SVec2D(Double(x),Double(y)),list)
	Wend
	
	CloseStream(path)
	
	Return(list)
EndFunction

Function DrawText2(t:String, x:Float, y:Float)
	SetColor 0,0,0
	DrawText t,x+2,y+2
	SetColor 255,255,255
	DrawText t,x,y
EndFunction

Function sumarray(arr:Int[])
	Local sum = 0
	For Local i = 0 To arr.length-1
		sum = sum + arr[i]
	Next
	
	Return sum
EndFunction

Rem
Function GetEnemyListFromFile:TList(url:String)
	Local path:TStream = OpenFile(url)
	
	Local list:TList = New TList
	
	While Not Eof(path)
		Local str:String[] = ReadLine(path).Split("=")
		
		Local id:String = Right(Left(str[0],Len(str[0])-1), Len(str[0])-2)
		Local n:Int = Int(str[1])
		
		Print(id)
		Print(n)
	Wend
	
	CloseStream(path)
	
	Return(list)
EndFunction
EndRem