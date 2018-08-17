%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Programmer:
%Date:
%Course:  ICS3CU1
%Teacher:
%Program Name:
%Descriptions:  Demos how to implement a button and a process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% displays a intro banner




%This procedure does most of the stuff in displayIntroWindow, except the winID things. This is so that it can call itself safely without leadng to winID conflicts
proc displayIntroWindowHelper


    var introBackground : int := Pic.FileNew ("Images/IntroPic.jpg")
    var introBackgroundScaled := Pic.Scale(introBackground, maxx,maxy)  
    Pic.Draw (introBackgroundScaled, 0, 0, picCopy) 
    Pic.Free(introBackground)
    Pic.Free(introBackgroundScaled)

    % create a button
    var quitIntroWindowButtonHard := GUI.CreateButton (maxx - 250, 25, 0, "Hard", QuitIntroWindowButtonPressedHard)
    var quitIntroWindowButtonEasy := GUI.CreateButton (maxx - 450, 25, 0, "Easy", QuitIntroWindowButtonPressedEasy)
    
    locatexy(maxx div 2 - 130, maxy div 2 - 100)
    put "Press i to read instructions"..

    
    
    var chars : array char of boolean
     
    % Window will continue until quit button is pressed
    loop        
	Input.KeyDown (chars)
	
	if chars ('i') or chars ('I') then
	    displayInstructionWindow
	    displayIntroWindowHelper
	end if
    
	exit when GUI.ProcessEvent or isIntroWindowOpen = false  
	
    end loop
    % release the button
    GUI.Dispose (quitIntroWindowButtonEasy)
    GUI.Dispose (quitIntroWindowButtonHard)

end displayIntroWindowHelper


% main procedure to handle the intro window
procedure displayIntroWindow

    % flag that intro screen is open - global var isIntroWindowOpen
    isIntroWindowOpen := true
    % Open the window
    var winID : int
    winID := Window.Open ("position:top;center,graphics:600;400,title:Introduction Window,nocursor")

    displayIntroWindowHelper
    
    %close/release the window
    Window.Close (winID)

end displayIntroWindow
