%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Programmer: Gaurav Sharma
%Program Name: Minesweeper
%Date: 12/4/15
%Course:  ICS3CU1  Final Project 15%
%Teacher:  M. Ianni
%Descriptions:  Minesweeper: the strategy game about using numbers to traverse a minefield
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% files/code folder
include "files/code/includes.t"

fork playMusic

displayIntroWindow

loop
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % procedure to set all initial global variable with file scope
    % even if already set (located in MyGlobalVars.t)
    setInitialGameValues
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %Display board
    display

    loop
	%Displays flags
	locatexy (20, maxy - 20)
	put "Flags: ", flags : 2 ..
	% 2. Wait for a mouse click
	% 3. Check if click is on a cell. If it is, proceed. Otherwise go back to step 2

	Mouse.ButtonWait ("down", mousex, mousey, buttonNum, upDown)
	% 4. If left click:
	%
	% -Check if there is a bomb on the cell that has been clicked. If there is, reveal bomb
	%
	% -If not bomb, but there are bombs around the 8 box perimeter of the cell, display the number of
	%
	% bombs near it on the cell

	% -If it is not a bomb, and no bombs are near it, trigger a cascade effect i.e. when you click on a
	%
	% box and it reveals several grey cells with it and multiple number cells at the perimeter.

	if (buttonNum = 1) then
	    leftClick (mousex, mousey)
	end if

	%
	%  5. If right click
	% - Toggle flag on the selected cell

	if (buttonNum = 3) then
	    rightClick (mousex, mousey)
	end if
	%
	% 6.   After the click, check if a bomb has been revealed or if all the non-bomb cells have been
	%
	% revealed. Either way game over and the user is asked to play again or not


	if (gameOver (mousex, mousey)) then
	    delay (1000)
	    exit
	end if

    end loop


    % 7. If user wants to play again, go back to step 1.
    cls
    var key : string (1)
    put "Play Again? (y/n) " ..
    getch (key)
    exit when key = "N" or key = "n"

end loop


