

Global enemytypecount:Int = 2
Global newline:String = Chr(10)
 
Print(GetWaveData("asset\map\grass_00.ef", "[lvl 5]")[0])
Print(GetWaveData("asset\map\grass_00.ef", "[lvl 5]")[1])

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