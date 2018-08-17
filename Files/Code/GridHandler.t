%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Programmer: Gaurav Sharma
%Program Name: Minesweeper
%Date: 12/9/15
%Course:  ICS3CU1  Final Project 15%
%Teacher:  M. Ianni
%Descriptions:  Minesweeper: the strategy game about using numbers to traverse a minefield
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This class handles all the game logic

%A timer process, that makes the clock tick in case people want to check their times
process Timer
    var minutes : int := 0
    var seconds : int := 0

    loop
	locatexy (maxx - 60, maxy - 20)
	if (seconds <= 9) then
	    put minutes : 2, ":0", seconds ..
	else
	    put minutes : 2, ":", seconds : 2 ..
	end if

	delay (1000)
	seconds += 1

	if (seconds >= 60) then
	    seconds := 0
	    minutes += 1
	end if

	exit when gameOverBoolean
    end loop
end Timer

%plays the games music
process playMusic
    
   loop
	Music.PlayFile ("Sounds/music.mp3")
	exit when gameOverBoolean
    end loop

    Music.SoundOff
end playMusic


%Displays the board
proc display
    cls
    var sky : int := Pic.FileNew ("Images/sky.jpg")
    var skyScaled := Pic.Scale (sky, maxx, maxy)
    Pic.Draw (skyScaled, 0, 0, picCopy)
    Pic.Free (sky)
    Pic.Free (skyScaled)

    for i : 1 .. rows
	for j : 1 .. cols
	    gridArr (i, j) -> draw (difficulty)
	end for
    end for
end display

%Puts the bombs around and numbers for surrounding bombs, but avoiding the given row and col,
%since that is where the played clicked, and they cant lose on the first click
proc handleBombs (ignoreRow, ignoreCol : int)

    var numBombs : int := flags %The number of bombs is always the number of flags initially

    loop
	var randCol, randRow : int %picks a random row and col
	randint (randCol, 1, cols)
	randint (randRow, 1, rows)

	if (gridArr (randRow, randCol) -> isBomb = false and randRow not= ignoreRow and randCol not= ignoreCol) then %checks if this row/col is already a bomb or
	    %part of the ignore row and col
	    gridArr (randRow, randCol) -> setBomb
	    numBombs -= 1

	    for i : randRow - 1 .. randRow + 1 %Searches the perimeter of the cell
		for j : randCol - 1 .. randCol + 1
		    if (i >= 1 and i <= rows and j >= 1 and j <= cols and not (i = randRow and j = randCol)) then
			gridArr (i, j) -> setBombNumber (gridArr (i, j) -> getBombNumber + 1)
		    end if
		end for
	    end for

	end if

	exit when numBombs = 0

    end loop

end handleBombs

%Performs a cascade, which is when multiple squares with no bombs around them reveal themseleves
proc cascade (square : ^Cell)

    var tempCells : array 1 .. 8 of ^Cell
    var currentPos : int := 1

    square -> click
    square -> draw (difficulty)

    for i : square -> getRow - 1 .. square -> getRow + 1
	for j : square -> getCol - 1 .. square -> getCol + 1
	    if (i >= 1 and i <= rows and j >= 1 and j <= cols and not (i = square -> getRow and j = square -> getCol)) then
		tempCells (currentPos) := gridArr (i, j)
		currentPos += 1
	    end if
	end for
    end for

    for i : 1 .. currentPos - 1
	if (tempCells (i) -> getBombNumber = 0 and not tempCells (i) -> isClicked) then
	    cascade (tempCells (i))
	elsif (not tempCells (i) -> isBomb and not tempCells (i) -> isFlagged) then
	    tempCells (i) -> click
	    tempCells (i) -> draw (difficulty)
	end if

    end for

end cascade



% -Check if there is a bomb on the cell that has been clicked. If there is, reveal bomb
%
% -If not bomb, but there are bombs around the 8 box perimeter of the cell, display the number of
%
% bombs near it on the cell

% -If it is not a bomb, and no bombs are near it, trigger a cascade effect i.e. when you click on a
%
% box and it reveals several grey cells with it and multiple number cells at the perimeter.
proc leftClick (x, y : int)

    var selectedRow, selectedCol : int
    grid -> getRowCol (x, y, selectedRow, selectedCol)

    if (selectedRow >= 1 and selectedCol >= 1 and not gridArr (selectedRow, selectedCol) -> isFlagged) then

	if (firstTime) then
	    handleBombs (selectedRow, selectedCol)
	    fork Timer
	    firstTime := false
	end if

	gridArr (selectedRow, selectedCol) -> click

	if (gridArr (selectedRow, selectedCol) -> getBombNumber not= 0 or gridArr (selectedRow, selectedCol) -> isBomb) then
	    gridArr (selectedRow, selectedCol) -> draw (difficulty)
	else
	    cascade (gridArr (selectedRow, selectedCol))
	end if

    end if

end leftClick

%
%  5. If right click
% - Toggle flag on the selected cell
% - updates flag count
proc rightClick (x, y : int)

    var selectedRow, selectedCol : int
    grid -> getRowCol (x, y, selectedRow, selectedCol)

    if (selectedRow >= 1 and selectedCol >= 1 and not gridArr (selectedRow, selectedCol) -> isClicked) then
	gridArr (selectedRow, selectedCol) -> flag
	gridArr (selectedRow, selectedCol) -> draw (difficulty)

	if (gridArr (selectedRow, selectedCol) -> isFlagged) then
	    flags -= 1
	else
	    flags += 1
	end if
    end if

end rightClick

%Checks if the game is over. There are two ways the game can finish, if the player has pressed a bomb, or if the player has flagged all
%the bombs and clicked all the non-bombs
fcn gameOver (x, y : int) : boolean

    var selectedRow, selectedCol : int
    grid -> getRowCol (x, y, selectedRow, selectedCol)

    if (selectedRow >= 1 and selectedCol >= 1 and gridArr (selectedRow, selectedCol) -> isBomb and gridArr (selectedRow, selectedCol) -> isClicked) then
	gameOverBoolean := true
	result true
    end if

    for i : 1 .. rows
	for j : 1 .. cols
	    if ((not gridArr (i, j) -> isClicked and not gridArr (i, j) -> isBomb) or (gridArr (i, j) -> isBomb and not gridArr (i, j) -> isFlagged)) then
		result false
	    end if
	end for
    end for

    gameOverBoolean := true
    result true
end gameOver
