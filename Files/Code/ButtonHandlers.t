% Button File - code to handle button events
% Intro Window Procedures

%This proc handles the Easy button
procedure QuitIntroWindowButtonPressedEasy
    isIntroWindowOpen := false
    difficulty := false  
    GUI.Quit
    GUI.ResetQuit
end QuitIntroWindowButtonPressedEasy

%This proc handles the Hard button
procedure QuitIntroWindowButtonPressedHard
    isIntroWindowOpen := false
    difficulty := true
    GUI.Quit
    GUI.ResetQuit
end QuitIntroWindowButtonPressedHard



