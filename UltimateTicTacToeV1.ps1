<#
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>

Written by Stephen Kofskie


PowerShell Ultimate Tic-Tac-Toe V1.0

As noted from the title of the script, this is the classic game of Tic-Tac-Toe but with the twist of extra game boards within each box. The object of the game is for one player to win strategic mini boards (the mini 
games within the squares of the main board) three in a row on the main to win overall. Player 1 chooses which symbol to use (X or O) and Player 2 gets the symbol not used. For both the mini boards and the 
entire board, players can place their symbol three in a row horizontally, vertically, or diagonally. If a mini board does not have a clear winner, it will not be used to tally the winner of the entire game. It is 
possible to have no winner. 

How to play:
    -As of this version of the script, two players must be at the same console window. No network play...yet.
    -After downloading the script and making sure the console can run unsigned scripts, navigate in a PowerShell console to the place where the script was downloaded & run it my typing .\UltimateTicTacToeV1.ps1.
    -Between the two players, one of them must decide who will be Player 1 as the first screen that appears is a question asking the player what symbol they want to appear as (X or O). Whatever Player 1 chooses, 
    Player 2 will become the symbol not used.
    -After symbol selection, Player 1 will choose where to place their symbol on one of 81 spots of the entire board.
        -Each box of the main board is broken down into nine spots for that section's mini board. It should be represented by the "coordinate" points in each box (e.g. The top left corner mini board has nine 
        coordinates ranging from A1 to A9. The top middle mini board has nine coordinates ranging from B1 to B9. etc.).
        -Player 1 will type the coordinate for where they want their symbol to appear at the bottom of the screen and press the enter key when done.
    -After Player 1 has placed their symbol on the board, Player 2 will be allowed to place their symbol on the board the same way mentioned in the previous bullet point.
    -A player can win a mini game by placing their symbol three times in a row horizontally, vertically, or diagonally.
    -If a player beats the other in one of the mini boards within the main board, that specific mini board change all coordinate points to the winner's symbol and their mini game win is tallied in the section on 
    the right of the console called "Overall Game Board." If there is no clear winner of a mini board, the mini game is not used in the overall game and not reflected by either player's symbol in the "Overall 
    Game Board."
    -A player can win the entirety of the game by winning mini board games horizontally, vertically, or diagonally.
    -If a player wins the entirety of the game, the script will end to congratulate the winning player. If all coordinates on the main board are selected with no clear winner, the script will end notifying that
    there was no winner. 
#>


function Get-BlankBoard{
    <#
    This function calls the blank board for the beginning of the game.
    #>

    Write-Host "`n"
    "   ╔═══════════════════════╦═══════════════════════╦═══════════════════════╗"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  A 1  │  A 2  │  A 3  ║  B 1  │  B 2  │  B 3  ║  C 1  │  C 2  │  C 3  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║───────┼───────┼───────║───────┼───────┼───────║───────┼───────┼───────║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  A 4  │  A 5  │  A 6  ║  B 4  │  B 5  │  B 6  ║  C 4  │  C 5  │  C 6  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║───────┼───────┼───────║───────┼───────┼───────║───────┼───────┼───────║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  A 7  │  A 8  │  A 9  ║  B 7  │  B 8  │  B 9  ║  C 7  │  C 8  │  C 9  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ╠═══════════════════════╬═══════════════════════╬═══════════════════════╣"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  D 1  │  D 2  │  D 3  ║  E 1  │  E 2  │  E 3  ║  F 1  │  F 2  │  F 3  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║───────┼───────┼───────║───────┼───────┼───────║───────┼───────┼───────║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  D 4  │  D 5  │  D 6  ║  E 4  │  E 5  │  E 6  ║  F 4  │  F 5  │  F 6  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║───────┼───────┼───────║───────┼───────┼───────║───────┼───────┼───────║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  D 7  │  D 8  │  D 9  ║  E 7  │  E 8  │  E 9  ║  F 7  │  F 8  │  F 9  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ╠═══════════════════════╬═══════════════════════╬═══════════════════════╣"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  G 1  │  G 2  │  G 3  ║  H 1  │  H 2  │  H 3  ║  I 1  │  I 2  │  I 3  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║───────┼───────┼───────║───────┼───────┼───────║───────┼───────┼───────║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  G 4  │  G 5  │  G 6  ║  H 4  │  H 5  │  H 6  ║  I 4  │  I 5  │  I 6  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║───────┼───────┼───────║───────┼───────┼───────║───────┼───────┼───────║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  G 7  │  G 8  │  G 9  ║  H 7  │  H 8  │  H 9  ║  I 7  │  I 8  │  I 9  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ╚═══════════════════════╩═══════════════════════╩═══════════════════════╝"
}

function Get-UserSymbol{
    <#
    This function asks Player 1 what symbol they want to use during the game. The output from this function is either an 'X' or 'O'
    #>

    $ask = Read-Host -Prompt "Player 1, do you want to be [X] or [O]?"
    while('x','o' -notcontains $ask){
        $ask = Read-Host -Prompt "Player 1, do you want to be [X] or [O]?"
    }
    switch($ask){
        'x'{$symbol = 'X'}
        'o'{$symbol = 'O'}
    }
    $symbol
}

function Enter-Coordinate{
    <#
    This function asks each player for a coordinate on the board to place their symbol. For a parameter, it takes the $usedCoordinates array to check that player's
    inputted coordinate wasn't already used. The inputted coordinate goes through a do-until loop where it has to pass three checks: 
        -A check to make sure the coordinate's first character matches one of the approved letters in the $letters array 
        -a check to make sure the coordinate's second character matches one of the approved numbers in the $numbers array
        -a check to make sure the player's coordinate wasn't already typed in previously
    If all three criteria are matched, the loop ends, and the output is the player's coordinate.
    #>
    param(
        [array]$usedCoordinates
    )
    
    $letters = @('a','b','c','d','e','f','g','h','i')
    $numbers = @('1','2','3','4','5','6','7','8','9')

    do{
        $ask = read-host -Prompt "Enter a coordinate (e.g: E5)"
        $splitCoordinates = $ask.ToCharArray()
        $check = 0
        while($splitCoordinates.Length -ne 2){ #check to make sure only two characters were entered.
            $ask = read-host -Prompt "Two characters only please. Enter a coordinate (e.g: E5)"
            $splitCoordinates = $ask.ToCharArray()
        }

        foreach($letter in $letters){ #First check
            if($splitCoordinates[0] -eq $letter){
                $check++
            }
        }
        
        foreach($number in $numbers){ #Second check
            if($splitCoordinates[1] -eq $number){
                $check++
            }
        }
        
        if($usedCoordinates -contains $ask){ #Third check
             #For some reason, -notcontains was giving me a hangup so I just went with an If-then-else statement.
        }else{
            $check++
        }
    }until($check -eq 3)
    
    $ask
}

function Confirm-MiniGame{
    <#
    This function checks the individual games within the whole board for a win from one of the players. The function is run after the Enter-Coordinate function has
    finished. For parameters, it uses $PlayersCoordinates (coordinates each player has entered) and $PreviousWins (any minigame wins each player has won). The 
    function takes each coordinate from $PlayersCoordinates and places them in arrays corresponding to their position (ex: positon i3 and i5 go into array $iSpots.).
    After each position is organized, each organized array is placed into another array called $gameCoordinatesCollection. The $gameCoordinatesCollection array is placed into a 
    foreach loop that finds the first character of each individual spots array to use in arrays $1 through $8. Arrays $1 though $8 are the ways to win each 
    minigame on the board (ex: using 'a' as the $foundletter, $1 = (("a1"),("a2"),("a3"))). Arrays $1 through $8 are then placed in a separate array called 
    $matchArrays (the arrays for the players' coordinates to match). $matchArrays is placed into a nested foreach loop and using each individual coordinate from the 
    parent loop, it checks each spots array (e.g. $aSpots, $bSpots, etc.) against each matching array (e.g. $1, $2, etc.) for a match. If a match is found, the 
    character for that minigame is placed in the $foundWins array. After the two foreach loops are done, the items in the $foundWins array are compared to the items 
    in the $PreviousWins array. If an item in $foundWins matches an item in $PreviousWins, there is no output from this function. If an item in $foundWins does not 
    match any of the items in $PreviousWins, the items in $foundWins are placed in a variable called $officalWins and that becomes the output from this function.
    #>
    param(
        [array]$PlayersCoordinates,  #Coordinates entered by one of the players
        [array]$PreviousWins         #Previous minigame wins by one of the players
    )

    $foundWins = @()
    $aSpots = @();$bSpots = @();$cSpots = @();$dSpots = @();$eSpots = @();
    $fSpots = @();$gSpots = @();$hSpots = @();$iSpots = @()

    #Organize Player spots into separate arrays.
    foreach($i in $PlayersCoordinates){
        if($i[0] -eq 'a'){
            $aSpots += $i
        }elseif($i[0] -eq 'b'){
            $bSpots += $i
        }elseif($i[0] -eq 'c'){
            $cSpots += $i
        }elseif($i[0] -eq 'd'){
            $dSpots += $i
        }elseif($i[0] -eq 'e'){
            $eSpots += $i
        }elseif($i[0] -eq 'f'){
            $fSpots += $i
        }elseif($i[0] -eq 'g'){
            $gSpots += $i
        }elseif($i[0] -eq 'h'){
            $hSpots += $i
        }elseif($i[0] -eq 'i'){
            $iSpots += $i
        }
    }

    $gameCoordinatesCollection = @($aSpots,$bSpots,$cSpots,$dSpots,$eSpots,$fSpots,$gSpots,$hSpots,$iSpots)

    #Find the first letter in each array to place into arrays $1 through $8
    foreach($i in $gameCoordinatesCollection){
        if($i.Count -gt 2){
            $split = $i[0] -split ""
            switch($split){
                'a'{$foundletter = 'a'}
                'b'{$foundletter = 'b'}
                'c'{$foundletter = 'c'}
                'd'{$foundletter = 'd'}
                'e'{$foundletter = 'e'}
                'f'{$foundletter = 'f'}
                'g'{$foundletter = 'g'}
                'h'{$foundletter = 'h'}
                'i'{$foundletter = 'i'}
            }

            $1 = (($foundletter +'1'),($foundletter +'2'),($foundletter +'3'))
            $2 = (($foundletter +'1'),($foundletter +'5'),($foundletter +'9'))
            $3 = (($foundletter +'1'),($foundletter +'4'),($foundletter +'7'))
            $4 = (($foundletter +'2'),($foundletter +'5'),($foundletter +'8'))
            $5 = (($foundletter +'3'),($foundletter +'5'),($foundletter +'7'))
            $6 = (($foundletter +'3'),($foundletter +'6'),($foundletter +'9'))
            $7 = (($foundletter +'4'),($foundletter +'5'),($foundletter +'6'))
            $8 = (($foundletter +'7'),($foundletter +'8'),($foundletter +'9'))
            $matchArrays = @($1,$2,$3,$4,$5,$6,$7,$8)

            #Check each spots array ($gameCoordinatesCollection) against each match array ($matchArrays)
            foreach($x in $matchArrays){
               $trial =  0..2 | ForEach-Object{$i -contains $x[$_]}

               if($trial[0] -eq 'True'){
                    if($trial[1] -eq 'True'){
                        if($trial[2] -eq 'True'){
                            $foundWins += $foundletter
                        }
                    }
               }
            }
        }
    }

    #Check to make sure the found win wasn't already recorded for the player.
    foreach($i in $foundWins){
        if($PreviousWins -notcontains $i){
            $officalWins += $i
        }
    }
    
    $officalWins
}

function Resolve-TiedGame{
    <#
    This function checks to see if there are any games where neither player won. This function is run after Confirm-MiniGame is finished. For parameters it uses 
    the $gamesDone array (games already completed), $usedCoordinates array (coordinates entered by both players), $player1MiniWins array (minigames won by Player 1),
    and $player2MiniWins array (minigames won by Player 2). In a foreach loop for each letter in array $letters, a letter is placed in the array $unigroup to make an 
    array of all possible positions in a minigame (ex: if letter 'a' is used, $unigroup would consist of positions 'a1' through 'a9'). Statement $check is used to see
    if each item of $unigroup appears in $usedCoordinates. This check will give $check an output of 9 True or False items. If all items in $check are true, a second 
    check is performed ($check2) to make sure the character does not appear in $player1MiniWins. If $check2 passes, a third check is performed ($check3) to make sure 
    the character does not appear in $player2MiniWins. If $check3 passes, one last check is performed ($check4) to make sure the character wasn't already added to the 
    $gamesDone array. The output is the letter of a game that neither Player 1 or Player 2 won.
    #>
    param(
        [array]$gamesDone,       #The minigames already finished by both players.
        [array]$usedCoordinates, #The coordinates used by both Player 1 and Player 2.
        [array]$player1MiniWins, #The minigames Player 1 won.
        [array]$player2MiniWins  #The minigames Player 2 won.
    )

    if($usedCoordinates.Count -gt 2){
            $letters = @('a','b','c','d','e','f','g','h','i')
            foreach($letter in $letters){
                $unigroup = @(($letter +'1'),($letter +'2'),($letter +'3'),($letter +'4'),($letter +'5'),($letter +'6'),($letter +'7'),($letter +'8'),($letter +'9'))
                $check = 0..$uniGroup.Count | ForEach-Object{$usedCoordinates -contains $uniGroup[$_]}  #First check to make sure all coordinates for minigame used
                if($check[0] -eq 'True'){
                    if($check[1] -eq 'True'){
                        if($check[2] -eq 'True'){
                            if($check[3] -eq 'True'){
                                if($check[4] -eq 'True'){
                                    if($check[5] -eq 'True'){
                                        if($check[6] -eq 'True'){
                                            if($check[7] -eq 'True'){
                                                if($check[8] -eq 'True'){
                                                    $check2 = $player1MiniWins -contains $letter   #Second check to see if character not in $player1MiniWins
                                                    if($check2 -eq $false){
                                                        $check3 = $player2MiniWins -contains $letter  #Third check to see if character not in $player2MiniWins
                                                        if($check3 -eq $false){
                                                            $check4 = $gamesDone -contains $letter   #Fourth check to see if character not in $gamesDone
                                                            if($check4 -eq $false){
                                                                $output = $letter
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    $output
}

function Confirm-EndGame{
    <#
    This function is used to check if the entire game has offically been won by one of the players. This function is run after Resolve-TiedGame is finished. For a
    parameter, $MiniWins is used (the minigames a player has won). Arrays $1 through $8 are ways a player can win the full game. Each array is placed in another 
    array, $arraylist. A foreach loop is run on each array in $arraylist to compare each $array against $MiniWins. If it finds that the items in $MiniWins contain
    a match to one of the arrays in $arraylist, the output is $true. Otherwise, no output is given. 
    #>
    param(
        [array]$MiniWins
    )
    $count = 0
    if($MiniWins.Count -gt 2){
        $1 = @('a','b','c')
        $2 = @('a','e','i')
        $3 = @('a','d','g')
        $4 = @('b','e','h')
        $5 = @('c','e','g')
        $6 = @('c','f','i')
        $7 = @('d','e','f')
        $8 = @('g','h','i')
        $arraylist = @($1,$2,$3,$4,$5,$6,$7,$8)

        foreach($x in $arraylist){    #Comparing each array item in $arraylist against the entirety of $MiniWins.
           $trial = 0..2 | ForEach-Object{$MiniWins -contains $x[$_]}
           if($trial[0] -eq 'True'){
                if($trial[1] -eq 'True'){
                    if($trial[2] -eq 'True'){
                        $count++
                    }
                }
           }
        }
    }
    if($count -gt 0){
        $true
    }    
}

function Update-Board{
    <#
    This function updates the game board after a user enters a new coordinate, wins a minigame, and/or outright wins the entire game. It is run after the function
    Confirm-Endgame is finished during the game and post game. For parameters it uses $Player1Coordinates (an array that contains all the entries Player 1 has entered 
    into the game), $Player2Coordinates (an array that contains all the entries Player 2 has entered into the game), $Player1Symbol (the symbol Player 1 chose at the 
    beginning of the game), $Player2Symbol (the symbol Player 2 was assigned after Player 1), $Player1MiniWins (the mingame wins that Player 1 has accumulated over the 
    entire game), and $Player2MiniWins (the minigame wins that Player 2 has accumulated over the entire game). Using set characters for each position of the game grid 
    (e.g. A1, A2, etc.), a foreach loop is set up for each players' coordinates that takes each coordinate and replaces the set corrdinate with their symbol (ex: 
    Position A1 was entered by player 1 using the symbol 'O' and will now be replaced with the players symbol instead the the set characters 'A 1.') A second foreach 
    loop is set up for each players miniwins where if they are accredited with a minigame win, all positions on that part of the board are switched to the winning 
    player's symbol ignoring the opposing player's symbols. A third foreach loop is setup for each players' minigame wins on the small, overall board to represent what 
    parts of the board they cover. 
    #>
    param(
        [array]$Player1Coordinates,     #an array that contains all the entries Player 1 has entered into the game
        [array]$Player2Coordinates,     #an array that contains all the entries Player 2 has entered into the game
        $Player1Symbol,                 #the symbol Player 1 chose at the beginning of the game
        $Player2Symbol,                 #the symbol Player 2 was assigned after Player 1
        [array]$Player1MiniWins,        #the minigame wins that Player 1 has accumulated over the entire game
        [array]$Player2MiniWins         #the minigame wins that Player 2 has accumulated over the entire game
    )
    
    #Set characters for the main board
    $a1 = 'A 1'; $a2 = 'A 2'; $a3 = 'A 3'; $a4 = 'A 4'; $a5 = 'A 5'; $a6 = 'A 6'; $a7 = 'A 7'; $a8 = 'A 8'; $a9 = 'A 9';
    $b1 = 'B 1'; $b2 = 'B 2'; $b3 = 'B 3'; $b4 = 'B 4'; $b5 = 'B 5'; $b6 = 'B 6'; $b7 = 'B 7'; $b8 = 'B 8'; $b9 = 'B 9';
    $c1 = 'C 1'; $c2 = 'C 2'; $c3 = 'C 3'; $c4 = 'C 4'; $c5 = 'C 5'; $c6 = 'C 6'; $c7 = 'C 7'; $c8 = 'C 8'; $c9 = 'C 9';
    $d1 = 'D 1'; $d2 = 'D 2'; $d3 = 'D 3'; $d4 = 'D 4'; $d5 = 'D 5'; $d6 = 'D 6'; $d7 = 'D 7'; $d8 = 'D 8'; $d9 = 'D 9';
    $e1 = 'E 1'; $e2 = 'E 2'; $e3 = 'E 3'; $e4 = 'E 4'; $e5 = 'E 5'; $e6 = 'E 6'; $e7 = 'E 7'; $e8 = 'E 8'; $e9 = 'E 9';
    $f1 = 'F 1'; $f2 = 'F 2'; $f3 = 'F 3'; $f4 = 'F 4'; $f5 = 'F 5'; $f6 = 'F 6'; $f7 = 'F 7'; $f8 = 'F 8'; $f9 = 'F 9';
    $g1 = 'G 1'; $g2 = 'G 2'; $g3 = 'G 3'; $g4 = 'G 4'; $g5 = 'G 5'; $g6 = 'G 6'; $g7 = 'G 7'; $g8 = 'G 8'; $g9 = 'G 9';
    $h1 = 'H 1'; $h2 = 'H 2'; $h3 = 'H 3'; $h4 = 'H 4'; $h5 = 'H 5'; $h6 = 'H 6'; $h7 = 'H 7'; $h8 = 'H 8'; $h9 = 'H 9';
    $i1 = 'I 1'; $i2 = 'I 2'; $i3 = 'I 3'; $i4 = 'I 4'; $i5 = 'I 5'; $i6 = 'I 6'; $i7 = 'I 7'; $i8 = 'I 8'; $i9 = 'I 9';

    #Player 1 Coordinates
    foreach($i in $Player1Coordinates){
        $userSymbol = $Player1Symbol

        #switch that goes through the first and second character of each coordinate to replace each set character.
        switch($i[0]){
            'a'{
                switch($i[1]){
                    1{$a1 = " $userSymbol "}
                    2{$a2 = " $userSymbol "}
                    3{$a3 = " $userSymbol "}
                    4{$a4 = " $userSymbol "}
                    5{$a5 = " $userSymbol "}
                    6{$a6 = " $userSymbol "}
                    7{$a7 = " $userSymbol "}
                    8{$a8 = " $userSymbol "}
                    9{$a9 = " $userSymbol "}
                }
            }
            'b'{
                switch($i[1]){
                    1{$b1 = " $userSymbol "}
                    2{$b2 = " $userSymbol "}
                    3{$b3 = " $userSymbol "}
                    4{$b4 = " $userSymbol "}
                    5{$b5 = " $userSymbol "}
                    6{$b6 = " $userSymbol "}
                    7{$b7 = " $userSymbol "}
                    8{$b8 = " $userSymbol "}
                    9{$b9 = " $userSymbol "}
                }
            }
            'c'{
                switch($i[1]){
                    1{$c1 = " $userSymbol "}
                    2{$c2 = " $userSymbol "}
                    3{$c3 = " $userSymbol "}
                    4{$c4 = " $userSymbol "}
                    5{$c5 = " $userSymbol "}
                    6{$c6 = " $userSymbol "}
                    7{$c7 = " $userSymbol "}
                    8{$c8 = " $userSymbol "}
                    9{$c9 = " $userSymbol "}
                }
            }
            'd'{
                switch($i[1]){
                    1{$d1 = " $userSymbol "}
                    2{$d2 = " $userSymbol "}
                    3{$d3 = " $userSymbol "}
                    4{$d4 = " $userSymbol "}
                    5{$d5 = " $userSymbol "}
                    6{$d6 = " $userSymbol "}
                    7{$d7 = " $userSymbol "}
                    8{$d8 = " $userSymbol "}
                    9{$d9 = " $userSymbol "}
                }
            }
            'e'{
                switch($i[1]){
                    1{$e1 = " $userSymbol "}
                    2{$e2 = " $userSymbol "}
                    3{$e3 = " $userSymbol "}
                    4{$e4 = " $userSymbol "}
                    5{$e5 = " $userSymbol "}
                    6{$e6 = " $userSymbol "}
                    7{$e7 = " $userSymbol "}
                    8{$e8 = " $userSymbol "}
                    9{$e9 = " $userSymbol "}
                }
            }
            'f'{
                switch($i[1]){
                    1{$f1 = " $userSymbol "}
                    2{$f2 = " $userSymbol "}
                    3{$f3 = " $userSymbol "}
                    4{$f4 = " $userSymbol "}
                    5{$f5 = " $userSymbol "}
                    6{$f6 = " $userSymbol "}
                    7{$f7 = " $userSymbol "}
                    8{$f8 = " $userSymbol "}
                    9{$f9 = " $userSymbol "}
                }
            }
            'g'{
                switch($i[1]){
                    1{$g1 = " $userSymbol "}
                    2{$g2 = " $userSymbol "}
                    3{$g3 = " $userSymbol "}
                    4{$g4 = " $userSymbol "}
                    5{$g5 = " $userSymbol "}
                    6{$g6 = " $userSymbol "}
                    7{$g7 = " $userSymbol "}
                    8{$g8 = " $userSymbol "}
                    9{$g9 = " $userSymbol "}
                }
            }
            'h'{
                switch($i[1]){
                    1{$h1 = " $userSymbol "}
                    2{$h2 = " $userSymbol "}
                    3{$h3 = " $userSymbol "}
                    4{$h4 = " $userSymbol "}
                    5{$h5 = " $userSymbol "}
                    6{$h6 = " $userSymbol "}
                    7{$h7 = " $userSymbol "}
                    8{$h8 = " $userSymbol "}
                    9{$h9 = " $userSymbol "}
                }
            }
            'i'{
                switch($i[1]){
                    1{$i1 = " $userSymbol "}
                    2{$i2 = " $userSymbol "}
                    3{$i3 = " $userSymbol "}
                    4{$i4 = " $userSymbol "}
                    5{$i5 = " $userSymbol "}
                    6{$i6 = " $userSymbol "}
                    7{$i7 = " $userSymbol "}
                    8{$i8 = " $userSymbol "}
                    9{$i9 = " $userSymbol "}
                }
            }
        }
    }

    #Player 2 Coordinates
    foreach($i in $Player2Coordinates){
        $userSymbol = $Player2Symbol
    
        #switch that goes through the first and second character of each coordinate to replace each set character.
        switch($i[0]){
            'a'{
                switch($i[1]){
                    1{$a1 = " $userSymbol "}
                    2{$a2 = " $userSymbol "}
                    3{$a3 = " $userSymbol "}
                    4{$a4 = " $userSymbol "}
                    5{$a5 = " $userSymbol "}
                    6{$a6 = " $userSymbol "}
                    7{$a7 = " $userSymbol "}
                    8{$a8 = " $userSymbol "}
                    9{$a9 = " $userSymbol "}
                }
            }
            'b'{
                switch($i[1]){
                    1{$b1 = " $userSymbol "}
                    2{$b2 = " $userSymbol "}
                    3{$b3 = " $userSymbol "}
                    4{$b4 = " $userSymbol "}
                    5{$b5 = " $userSymbol "}
                    6{$b6 = " $userSymbol "}
                    7{$b7 = " $userSymbol "}
                    8{$b8 = " $userSymbol "}
                    9{$b9 = " $userSymbol "}
                }
            }
            'c'{
                switch($i[1]){
                    1{$c1 = " $userSymbol "}
                    2{$c2 = " $userSymbol "}
                    3{$c3 = " $userSymbol "}
                    4{$c4 = " $userSymbol "}
                    5{$c5 = " $userSymbol "}
                    6{$c6 = " $userSymbol "}
                    7{$c7 = " $userSymbol "}
                    8{$c8 = " $userSymbol "}
                    9{$c9 = " $userSymbol "}
                }
            }
            'd'{
                switch($i[1]){
                    1{$d1 = " $userSymbol "}
                    2{$d2 = " $userSymbol "}
                    3{$d3 = " $userSymbol "}
                    4{$d4 = " $userSymbol "}
                    5{$d5 = " $userSymbol "}
                    6{$d6 = " $userSymbol "}
                    7{$d7 = " $userSymbol "}
                    8{$d8 = " $userSymbol "}
                    9{$d9 = " $userSymbol "}
                }
            }
            'e'{
                switch($i[1]){
                    1{$e1 = " $userSymbol "}
                    2{$e2 = " $userSymbol "}
                    3{$e3 = " $userSymbol "}
                    4{$e4 = " $userSymbol "}
                    5{$e5 = " $userSymbol "}
                    6{$e6 = " $userSymbol "}
                    7{$e7 = " $userSymbol "}
                    8{$e8 = " $userSymbol "}
                    9{$e9 = " $userSymbol "}
                }
            }
            'f'{
                switch($i[1]){
                    1{$f1 = " $userSymbol "}
                    2{$f2 = " $userSymbol "}
                    3{$f3 = " $userSymbol "}
                    4{$f4 = " $userSymbol "}
                    5{$f5 = " $userSymbol "}
                    6{$f6 = " $userSymbol "}
                    7{$f7 = " $userSymbol "}
                    8{$f8 = " $userSymbol "}
                    9{$f9 = " $userSymbol "}
                }
            }
            'g'{
                switch($i[1]){
                    1{$g1 = " $userSymbol "}
                    2{$g2 = " $userSymbol "}
                    3{$g3 = " $userSymbol "}
                    4{$g4 = " $userSymbol "}
                    5{$g5 = " $userSymbol "}
                    6{$g6 = " $userSymbol "}
                    7{$g7 = " $userSymbol "}
                    8{$g8 = " $userSymbol "}
                    9{$g9 = " $userSymbol "}
                }
            }
            'h'{
                switch($i[1]){
                    1{$h1 = " $userSymbol "}
                    2{$h2 = " $userSymbol "}
                    3{$h3 = " $userSymbol "}
                    4{$h4 = " $userSymbol "}
                    5{$h5 = " $userSymbol "}
                    6{$h6 = " $userSymbol "}
                    7{$h7 = " $userSymbol "}
                    8{$h8 = " $userSymbol "}
                    9{$h9 = " $userSymbol "}
                }
            }
            'i'{
                switch($i[1]){
                    1{$i1 = " $userSymbol "}
                    2{$i2 = " $userSymbol "}
                    3{$i3 = " $userSymbol "}
                    4{$i4 = " $userSymbol "}
                    5{$i5 = " $userSymbol "}
                    6{$i6 = " $userSymbol "}
                    7{$i7 = " $userSymbol "}
                    8{$i8 = " $userSymbol "}
                    9{$i9 = " $userSymbol "}
                }
            }
        }
    
    }

    #Player 1 Wins Spot Replacement
    foreach($xo in $Player1MiniWins){
        $userSymbol = $Player1Symbol
        #switch that goes takes each minigame win and replaces all symbols and set characters on that part of the board with the player's symbol.
        switch($xo){
            'a'{$a1 = " $userSymbol "; $a2 = " $userSymbol "; $a3 = " $userSymbol "; $a4 = " $userSymbol "; $a5 = " $userSymbol "; $a6 = " $userSymbol "; $a7 = " $userSymbol "; $a8 = " $userSymbol "; $a9 = " $userSymbol ";}
            'b'{$b1 = " $userSymbol "; $b2 = " $userSymbol "; $b3 = " $userSymbol "; $b4 = " $userSymbol "; $b5 = " $userSymbol "; $b6 = " $userSymbol "; $b7 = " $userSymbol "; $b8 = " $userSymbol "; $b9 = " $userSymbol ";}
            'c'{$c1 = " $userSymbol "; $c2 = " $userSymbol "; $c3 = " $userSymbol "; $c4 = " $userSymbol "; $c5 = " $userSymbol "; $c6 = " $userSymbol "; $c7 = " $userSymbol "; $c8 = " $userSymbol "; $c9 = " $userSymbol ";}
            'd'{$d1 = " $userSymbol "; $d2 = " $userSymbol "; $d3 = " $userSymbol "; $d4 = " $userSymbol "; $d5 = " $userSymbol "; $d6 = " $userSymbol "; $d7 = " $userSymbol "; $d8 = " $userSymbol "; $d9 = " $userSymbol ";}
            'e'{$e1 = " $userSymbol "; $e2 = " $userSymbol "; $e3 = " $userSymbol "; $e4 = " $userSymbol "; $e5 = " $userSymbol "; $e6 = " $userSymbol "; $e7 = " $userSymbol "; $e8 = " $userSymbol "; $e9 = " $userSymbol ";}
            'f'{$f1 = " $userSymbol "; $f2 = " $userSymbol "; $f3 = " $userSymbol "; $f4 = " $userSymbol "; $f5 = " $userSymbol "; $f6 = " $userSymbol "; $f7 = " $userSymbol "; $f8 = " $userSymbol "; $f9 = " $userSymbol ";}
            'g'{$g1 = " $userSymbol "; $g2 = " $userSymbol "; $g3 = " $userSymbol "; $g4 = " $userSymbol "; $g5 = " $userSymbol "; $g6 = " $userSymbol "; $g7 = " $userSymbol "; $g8 = " $userSymbol "; $g9 = " $userSymbol ";}
            'h'{$h1 = " $userSymbol "; $h2 = " $userSymbol "; $h3 = " $userSymbol "; $h4 = " $userSymbol "; $h5 = " $userSymbol "; $h6 = " $userSymbol "; $h7 = " $userSymbol "; $h8 = " $userSymbol "; $h9 = " $userSymbol ";}
            'i'{$i1 = " $userSymbol "; $i2 = " $userSymbol "; $i3 = " $userSymbol "; $i4 = " $userSymbol "; $i5 = " $userSymbol "; $i6 = " $userSymbol "; $i7 = " $userSymbol "; $i8 = " $userSymbol "; $i9 = " $userSymbol ";}
        }
    }

    #Player 2 Wins Spot Replacement
    foreach($xo in $Player2MiniWins){
        $userSymbol = $Player2Symbol
        #switch that goes takes each minigame win and replaces all symbols and set characters on that part of the board with the player's symbol.
        switch($xo){
            'a'{$a1 = " $userSymbol "; $a2 = " $userSymbol "; $a3 = " $userSymbol "; $a4 = " $userSymbol "; $a5 = " $userSymbol "; $a6 = " $userSymbol "; $a7 = " $userSymbol "; $a8 = " $userSymbol "; $a9 = " $userSymbol ";}
            'b'{$b1 = " $userSymbol "; $b2 = " $userSymbol "; $b3 = " $userSymbol "; $b4 = " $userSymbol "; $b5 = " $userSymbol "; $b6 = " $userSymbol "; $b7 = " $userSymbol "; $b8 = " $userSymbol "; $b9 = " $userSymbol ";}
            'c'{$c1 = " $userSymbol "; $c2 = " $userSymbol "; $c3 = " $userSymbol "; $c4 = " $userSymbol "; $c5 = " $userSymbol "; $c6 = " $userSymbol "; $c7 = " $userSymbol "; $c8 = " $userSymbol "; $c9 = " $userSymbol ";}
            'd'{$d1 = " $userSymbol "; $d2 = " $userSymbol "; $d3 = " $userSymbol "; $d4 = " $userSymbol "; $d5 = " $userSymbol "; $d6 = " $userSymbol "; $d7 = " $userSymbol "; $d8 = " $userSymbol "; $d9 = " $userSymbol ";}
            'e'{$e1 = " $userSymbol "; $e2 = " $userSymbol "; $e3 = " $userSymbol "; $e4 = " $userSymbol "; $e5 = " $userSymbol "; $e6 = " $userSymbol "; $e7 = " $userSymbol "; $e8 = " $userSymbol "; $e9 = " $userSymbol ";}
            'f'{$f1 = " $userSymbol "; $f2 = " $userSymbol "; $f3 = " $userSymbol "; $f4 = " $userSymbol "; $f5 = " $userSymbol "; $f6 = " $userSymbol "; $f7 = " $userSymbol "; $f8 = " $userSymbol "; $f9 = " $userSymbol ";}
            'g'{$g1 = " $userSymbol "; $g2 = " $userSymbol "; $g3 = " $userSymbol "; $g4 = " $userSymbol "; $g5 = " $userSymbol "; $g6 = " $userSymbol "; $g7 = " $userSymbol "; $g8 = " $userSymbol "; $g9 = " $userSymbol ";}
            'h'{$h1 = " $userSymbol "; $h2 = " $userSymbol "; $h3 = " $userSymbol "; $h4 = " $userSymbol "; $h5 = " $userSymbol "; $h6 = " $userSymbol "; $h7 = " $userSymbol "; $h8 = " $userSymbol "; $h9 = " $userSymbol ";}
            'i'{$i1 = " $userSymbol "; $i2 = " $userSymbol "; $i3 = " $userSymbol "; $i4 = " $userSymbol "; $i5 = " $userSymbol "; $i6 = " $userSymbol "; $i7 = " $userSymbol "; $i8 = " $userSymbol "; $i9 = " $userSymbol ";}
        }
    }

    #Overall Board
    $A = " "; $B = " "; $C = " "; $D = " "; $E = " "; $F = " "; $G = " "; $H = " "; $I = " "; #set spaces for the overall board

    #Player 1 Minigame wins on overall board
    foreach($xx in $Player1MiniWins){
        $userSymbol = $Player1Symbol
        #switch that takes each minigame win and replaces the set space with the player's symbol
        switch($xx){
            'a'{$A = $userSymbol}
            'b'{$B = $userSymbol}
            'c'{$C = $userSymbol}
            'd'{$D = $userSymbol}
            'e'{$E = $userSymbol}
            'f'{$F = $userSymbol}
            'g'{$G = $userSymbol}
            'h'{$H = $userSymbol}
            'i'{$I = $userSymbol}
        }
    }

    #Player 2 Minigame wins on overall board
    foreach($xx in $Player2MiniWins){
        $userSymbol = $Player2Symbol
        #switch that takes each minigame win and replaces the set space with the player's symbol
        switch($xx){
            'a'{$A = $userSymbol}
            'b'{$B = $userSymbol}
            'c'{$C = $userSymbol}
            'd'{$D = $userSymbol}
            'e'{$E = $userSymbol}
            'f'{$F = $userSymbol}
            'g'{$G = $userSymbol}
            'h'{$H = $userSymbol}
            'i'{$I = $userSymbol}
        }
    }

    #Output board to screen
    Clear-Host
    "`n"

    "   ╔═══════════════════════╦═══════════════════════╦═══════════════════════╗"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  $a1  │  $a2  │  $a3  ║  $b1  │  $b2  │  $b3  ║  $c1  │  $c2  │  $c3  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║───────┼───────┼───────║───────┼───────┼───────║───────┼───────┼───────║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  $a4  │  $a5  │  $a6  ║  $b4  │  $b5  │  $b6  ║  $c4  │  $c5  │  $c6  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║───────┼───────┼───────║───────┼───────┼───────║───────┼───────┼───────║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  $a7  │  $a8  │  $a9  ║  $b7  │  $b8  │  $b9  ║  $c7  │  $c8  │  $c9  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ╠═══════════════════════╬═══════════════════════╬═══════════════════════╣"
    "   ║       │       │       ║       │       │       ║       │       │       ║    OVERALL GAME BOARD:"
    "   ║  $d1  │  $d2  │  $d3  ║  $e1  │  $e2  │  $e3  ║  $f1  │  $f2  │  $f3  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║       $A │ $B │ $C "
    "   ║───────┼───────┼───────║───────┼───────┼───────║───────┼───────┼───────║      ───┼───┼───"
    "   ║       │       │       ║       │       │       ║       │       │       ║       $D │ $E │ $F "
    "   ║  $d4  │  $d5  │  $d6  ║  $e4  │  $e5  │  $e6  ║  $f4  │  $f5  │  $f6  ║      ───┼───┼───"
    "   ║       │       │       ║       │       │       ║       │       │       ║       $G │ $H │ $I "
    "   ║───────┼───────┼───────║───────┼───────┼───────║───────┼───────┼───────║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  $d7  │  $d8  │  $d9  ║  $e7  │  $e8  │  $e9  ║  $f7  │  $f8  │  $f9  ║      Player 1 = $Player1Symbol"
    "   ║       │       │       ║       │       │       ║       │       │       ║      Player 2 = $Player2Symbol"
    "   ╠═══════════════════════╬═══════════════════════╬═══════════════════════╣"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  $g1  │  $g2  │  $g3  ║  $h1  │  $h2  │  $h3  ║  $i1  │  $i2  │  $i3  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║───────┼───────┼───────║───────┼───────┼───────║───────┼───────┼───────║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  $g4  │  $g5  │  $g6  ║  $h4  │  $h5  │  $h6  ║  $i4  │  $i5  │  $i6  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║───────┼───────┼───────║───────┼───────┼───────║───────┼───────┼───────║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ║  $g7  │  $g8  │  $g9  ║  $h7  │  $h8  │  $h9  ║  $i7  │  $i8  │  $i9  ║"
    "   ║       │       │       ║       │       │       ║       │       │       ║"
    "   ╚═══════════════════════╩═══════════════════════╩═══════════════════════╝"

}

$winner = $null                 #The overall winner of the game
$usedCoordinates = @()          #The coordinates used by both players
$player1UsedCoordinates = @()   #The coordinates entered by Player 1
$player1MiniWins = @()          #The minigames Player 1 won
$player2MiniWins = @()          #The minigames Player 2 won
$player2UsedCoordinates = @()   #The coordinates entered by Player 2
$gamesDone = @()                #The minigames completed throughout the game


#Game Start

#Asking Player 1 what symbol they want to appear as.
Clear-Host
Write-Host "`n"
$userSymbol = Get-UserSymbol
switch($userSymbol){           #Switch to get what 
    'X'{$Player2Symbol = 'O'}
    'O'{$Player2Symbol = 'X'}
}

Clear-Host
Get-BlankBoard

do{

    #Player 1
    Write-host "`n"
    Write-Host "Player 1"
    $grabCoordinate = Enter-Coordinate -usedCoordinates $usedCoordinates   #asks player where to place symbol on board
    $usedCoordinates += $grabCoordinate
    $player1UsedCoordinates += $grabCoordinate

    #check to see if player won minigame
    $player1Check = Confirm-MiniGame -PlayersCoordinates $player1UsedCoordinates -PreviousWins $player1MiniWins
    if($player1Check){
        $player1MiniWins += $player1Check
        $uniGroup = @(($player1Check +'1'),($player1Check +'2'),($player1Check +'3'),($player1Check +'4'),($player1Check +'5'),($player1Check +'6'),($player1Check +'7'),($player1Check +'8'),($player1Check +'9'))
        $usedCoordinates += $uniGroup
        $gamesDone += $player1Check
    }

    #Check to see if there is a tied minigame
    $tiedCheck1 = Resolve-TiedGame -gamesDone $gamesDone -usedCoordinates $usedCoordinates -player1MiniWins $player1MiniWins -player2MiniWins $player2MiniWins
    if($null -ne $tiedCheck1){
        $gamesDone += $tiedCheck1
    }

    #Check to see if the player won the overall game
    $player1EndgameCheck = Confirm-EndGame -MiniWins $player1MiniWins
    if($player1EndgameCheck -eq $true){
        $winner = 'Player 1'
        Break
    
    }elseif($gamesDone.Count -ge 9){  #if no clear winner and tied
        Break
    }else{  #update the board for the next player
        Update-Board -Player1Coordinates $player1UsedCoordinates -Player2Coordinates $player2UsedCoordinates -Player1Symbol $userSymbol -Player2Symbol $Player2Symbol -Player1MiniWins $player1MiniWins -Player2MiniWins $player2MiniWins
    }


    #Player 2
    Write-host "`n"
    Write-Host "Player 2"
    $grabCoordinate = Enter-Coordinate -usedCoordinates $usedCoordinates   #asks player where to place symbol on board
    $usedCoordinates += $grabCoordinate
    $player2UsedCoordinates += $grabCoordinate

    #check to see if player won minigame
    $player2Check = Confirm-MiniGame -PlayersCoordinates $player2UsedCoordinates -PreviousWins $player2MiniWins
    if($player2Check){
       $player2MiniWins += $player2Check
       $uniGroup = @(($player2Check +'1'),($player2Check +'2'),($player2Check +'3'),($player2Check +'4'),($player2Check +'5'),($player2Check +'6'),($player2Check +'7'),($player2Check +'8'),($player2Check +'9'))
       $usedCoordinates += $uniGroup
       $gamesDone += $player2Check
    }

    #Check to see if there is a tied minigame
    $tiedCheck2 = Resolve-TiedGame -gamesDone $gamesDone -usedCoordinates $usedCoordinates -player1MiniWins $player1MiniWins -player2MiniWins $player2MiniWins
    if($null -ne $tiedCheck2){
        $gamesDone += $tiedCheck2
    }

    #Check to see if the player won the overall game
    $player2EndgameCheck = Confirm-EndGame -MiniWins $player2MiniWins
    if($player2EndgameCheck -eq $true){
        $winner = 'Player 2'
        Break
    }elseif($gamesDone.Count -ge 9){   #if no clear winner and tied
        Break
    }else{   #update the board for the next player
        Update-Board -Player1Coordinates $player1UsedCoordinates -Player2Coordinates $player2UsedCoordinates -Player1Symbol $userSymbol -Player2Symbol $Player2Symbol -Player1MiniWins $player1MiniWins -Player2MiniWins $player2MiniWins
    }

}until($gamesDone.count -ge 9)

#Endgame Screens
if($null -ne $winner){  #if the game had a winner
    Update-Board -Player1Coordinates $player1UsedCoordinates -Player2Coordinates $player2UsedCoordinates -Player1Symbol $userSymbol -Player2Symbol $Player2Symbol -Player1MiniWins $player1MiniWins -Player2MiniWins $player2MiniWins
    Write-host "`n"
    Write-Host "$winner is the winner of the game! Thanks for playing."
    Write-host "`n"
}else{   #if the game ended in a tie
    Update-Board -Player1Coordinates $player1UsedCoordinates -Player2Coordinates $player2UsedCoordinates -Player1Symbol $userSymbol -Player2Symbol $Player2Symbol -Player1MiniWins $player1MiniWins -Player2MiniWins $player2MiniWins
    Write-host "`n"
    Write-Host "No winners here today. Better luck next time."
    Write-host "`n"
}
