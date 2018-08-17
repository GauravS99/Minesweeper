%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Programmer: Gaurav Sharma
%Date: 12/7
%Course:  ICS3CU1
%Teacher: Ianni
%Program Name: Minesweeper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   MyGlobalVars.t
%   All global variables are coded in this file.
%   These will have FILE scope.
%   These must be document thoroughly - Descriptive name,
%   where used and for what purpose

%Introduction Window
var isIntroWindowOpen : boolean % Flag for Introduction Window state open or closed

%sets the game difficulty. if false, 10 x 10 board with 15 mines. If true, 16 x 30 board with 75 bombs. This is used also to draw the cells, since they need to know
%what size they are, which depends on the difficulty.
%Note: this boolean is set in the intro widow buttonHandlers since it is decided there.
var difficulty : boolean

%A number of things only happen the first time the player left clicks, such as the bomb generation and the timer starting, and this boolean is used to check if
%it is the first time or not.
var firstTime : boolean

%This boolean is needed only to stop the timer, since it is a process and needs to know if the game is over or not to stop. True if game is over, false otherwise
var gameOverBoolean : boolean := false

%This information is for the grid class, as a number of the procedures in that require this information. Rows and Cols variables also mean easy 2d array traversal
var rows, cols, cellLength, startx, starty, flags : int

%These ints are to make the mouse work with the program. buttonNum and upDown are for nothing except to make the Mouse.ButtonWait procedure to work. THe values they
%get are not used in the program
var mousex, mousey, buttonNum, upDown : int

%I wish there was set the array dimensions later, but the must be set immediately upon the creation of the array. Therefore, the dimensions here are 16x30
%so that the same array can be used for both a 10x10 grid of 16x30 grid. It is a little wasteful if the grid is 10x10, but it can't be helped
var gridArr : array 1 .. 16, 1 .. 30 of ^Cell

%sets up the Grid class. This class is nothing but a few useful procedures.
var grid : pointer to Grid
new grid

%This must be done prior to using the Mouse, so that both the left click and right click may be used
Mouse.ButtonChoose ("multibutton")

proc setInitialGameValues
    %Sets some defaults
    gameOverBoolean := false
    isIntroWindowOpen := false
    mousex := maxx
    mousey := maxy
    firstTime := true

    %Sets some values according to difficulty
    if (difficulty) then
	flags := 75
	setscreen ("graphics:1000;700,title:Minesweeper,nocursor")
	rows := 16
	cols := 30
	cellLength := 30
	startx := 50
	starty := 100
    else
	flags := 15
	setscreen ("graphics:800;800,title:Minesweeper,nocursor")
	rows := 10
	cols := 10
	cellLength := 60
	startx := 100
	starty := 100
    end if

    %makes the grid object
    grid -> setGrid (startx, starty, rows, cols, cellLength, cellLength, black)

    %sets up all the Cells in the array. 
    for i : 1 .. rows
	for j : 1 .. cols
	    new gridArr (i, j)
	    gridArr (i, j) -> setCell (i, j)
	end for
    end for

end setInitialGameValues
