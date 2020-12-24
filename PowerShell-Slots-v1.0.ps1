#This is free and unencumbered software released into the public domain.
#
#Anyone is free to copy, modify, publish, use, compile, sell, or
#distribute this software, either in source code form or as a compiled
#binary, for any purpose, commercial or non-commercial, and by any
#means.
#
#In jurisdictions that recognize copyright laws, the author or authors
#of this software dedicate any and all copyright interest in the
#software to the public domain. We make this dedication for the benefit
#of the public at large and to the detriment of our heirs and
#successors. We intend this dedication to be an overt act of
#relinquishment in perpetuity of all present and future rights to this
#software under copyright law.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
#OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
#ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#OTHER DEALINGS IN THE SOFTWARE.
#
#For more information, please refer to <https://unlicense.org>
#
#Written by Stephen Kofskie




function get-pausescreen{  #Animated screen for player for a manufactured wait time for the next draw. For both one line, three line, and eight line games.
    param(
        [parameter(mandatory=$true)]$lines
    )
    #static animation strings
    $toplineani  =      ' ╔══♥══♦══♣══♠══♥══♦══♣══╗ '
    $bottomlineani =    ' ╚══♣══♦══♥══♠══♣══♦══♥══╝ '
    $singlelinemiddle = @(' ║                       ║ ', ' ║  █                    ║ ', ' ║           █           ║ ', ' ║                    █  ║ ')
    $multitop =    @(' ║                       ║ ', ' ║                       ║ ', ' ║                       ║ ', ' ║  █                    ║ ', ' ║           █           ║ ', ' ║                    █  ║ ')
    $multimiddle = @(' ║                       ║ ', ' ║                       ║ ', ' ║  █                    ║ ', ' ║           █           ║ ', ' ║                    █  ║ ', ' ║                       ║ ')
    $bottommulti = @(' ║                       ║ ', ' ║  █                    ║ ', ' ║           █           ║ ', ' ║                    █  ║ ', ' ║                       ║ ', ' ║                       ║ ')

    switch($lines){ 
        1{                 #one line game 
            cls
            $loopcount = 0
            do{            #loop goes through 3 times with a delay for half a second to make moving image (granted not that smooth)
                for($i=0; $i -le 3; $i++){
                    "`n"
                    'Drawing Numbers...'
                    "`n"
                    "`n"
                    "`n"
                    $toplineani
                    $singlelinemiddle[$i]
                    $bottomlineani
   
                    start-sleep -Milliseconds 500
                    cls 
                }
            $loopcount++
            }until($loopcount -eq 2)
        }
        3{               #three line game
            cls
            $loopcount = 0
            do{          #loop goes through 3 times with a delay for half a second to make moving image (granted not that smooth)
                for($i=0; $i -le 5; $i++){
                    "`n"
                    'Drawing Numbers...'
                    "`n"
                    "`n"
                    "`n"
                    $toplineani
                    $multitop[$i]
                    $multimiddle[$i]
                    $bottommulti[$i]
                    $bottomlineani
   
                    start-sleep -Milliseconds 500
                    cls 
                }
            $loopcount++
            }until($loopcount -eq 2)
        }
    }
}


function get-draw{  #The function to draw symbols during a one line game. Separated by difficulty. 
    param(
        [parameter(mandatory=$true)]$difficulty
    )
    
    switch($difficulty){
        'easy'{                                       #Easy does not use a zero symbol to give the player a better chance at a good draw.
            $slotchar = @('@','*','6','X','7','f')    #All the available symbols for the draw. An additonal item was added to the array ('f') because the get-random function wouldn't pick the seven symbol ('7'). Same for normal mode.
            $drawcounter = 0
            $drawarray = @()                          #The output from the function without the randomized draw. Same for normal mode.

            do{                                       #Loop goes through 3 times to pick random symbols. Same for normal mode.
                $rando = Get-random -Minimum 0 -Maximum 5
                $filler = $slotchar[$rando]
                $drawarray += $filler
 
                $drawcounter++
            }until($drawcounter -eq 3)

            $drawarray
        }
        'normal'{                                     #Normal uses a zero symbol for added difficulty.
            $slotchar = @('0','@','*','6','X','7','f')
            $drawcounter = 0
            $drawarray = @()

            do{
                $rando = Get-random -Minimum 0 -Maximum 6
                $filler = $slotchar[$rando]
                $drawarray += $filler
 
                $drawcounter++
            }until($drawcounter -eq 3)

            $drawarray
        }
     }
 }


function get-drawcheck{  #The function to check the draw from the function get-draw. This is used to determine what the player earns from their randomized draw. For one line games only and separated by difficulty.
    param (
    [parameter(mandatory=$true)] $inputarray,    #The array from the get-draw function.
    [parameter(mandatory=$true)] $perplay,       #The amount the player loses or gains back if they have a win or lose draw from one of the three arrays.
    [parameter(mandatory=$true)] $difficulty     #The game difficulty.
    )

    switch($difficulty){
    
        'easy'{                                  #Easy does not include the zero symbol ('0'), so it is not evaluated below. 

            $outputcash = 0                      #The output from this function. If the player earns or loses anything from their dray by going through the switch, it will be applied to this variable. The same applies to normal.

            switch($inputarray[0]){              
                                                 #This switch goes through each item in the array that was drawn from the get-draw function. If the first array item satifies the first part of the switch, the second array
                                                 #item is evaluated in the next nest switch. If it satifies that switch, the third array item is evaluated on the last nested switch. The same applies to normal.
                
                "7"{
                    switch($inputarray[1]){
                        "7"{
                            switch($inputarray[2]){
                                "7"{$outputcash += 500}
                                "X"{$outputcash += $perplay}
                                "6"{$outputcash += $perplay}
                                "@"{$outputcash += $perplay}
                                "*"{$outputcash += $perplay}
                            }
                        }
                        "X"{$outputcash -= $perplay}
                        "6"{$outputcash -= $perplay}
                        "@"{$outputcash -= $perplay}
                        "*"{$outputcash -= $perplay}
                    }
                }
                "X"{
                    switch($inputarray[1]){
                        "X"{
                            switch($inputarray[2]){
                                "X"{$outputcash += 250}
                                "7"{$outputcash += $perplay}
                                "6"{$outputcash += $perplay}
                                "@"{$outputcash += $perplay}
                                "*"{$outputcash += $perplay}
                            }
                        }
                        "7"{$outputcash -= $perplay}
                        "6"{$outputcash -= $perplay}
                        "@"{$outputcash -= $perplay}
                        "*"{$outputcash -= $perplay}
                    }
                }
                "6"{
                    switch($inputarray[1]){
                        "6"{
                            switch($inputarray[2]){
                                "6"{$outputcash += 150}
                                "7"{$outputcash += $perplay}
                                "X"{$outputcash += $perplay}
                                "@"{$outputcash += $perplay}
                                "*"{$outputcash += $perplay}
                            }
                        }
                        "7"{$outputcash -= $perplay}
                        "X"{$outputcash -= $perplay}
                        "@"{$outputcash -= $perplay}
                        "*"{$outputcash -= $perplay}
                    }
                }
                "@"{
                    switch($inputarray[1]){
                        "@"{
                            switch($inputarray[2]){
                                "@"{$outputcash += 100}
                                "X"{$outputcash += $perplay}
                                "6"{$outputcash += $perplay}
                                "7"{$outputcash += $perplay}
                                "*"{$outputcash += $perplay}
                            }
                        }
                        "X"{$outputcash -= $perplay}
                        "6"{$outputcash -= $perplay}
                        "7"{$outputcash -= $perplay}
                        "*"{$outputcash -= $perplay}
                    }
                }
                "*"{
                    switch($inputarray[1]){
                        "*"{
                            switch($inputarray[2]){
                                "*"{$outputcash += 100}
                                "X"{$outputcash += $perplay}
                                "6"{$outputcash += $perplay}
                                "7"{$outputcash += $perplay}
                                "@"{$outputcash += $perplay}
                            }
                        }
                        "X"{$outputcash -= $perplay}
                        "6"{$outputcash -= $perplay}
                        "7"{$outputcash -= $perplay}
                        "@"{$outputcash -= $perplay}
                    }
                }
            }
            $outputcash    
        }

        'normal'{                                           #Normal evaluates the zero symbol ('0') within the randomized drawn symbols.

                $outputcash = 0

            switch($inputarray[0]){
                
                "0"{$outputcash -= $perplay}
                "7"{
                    switch($inputarray[1]){
                        "0"{$outputcash -= $perplay}
                        "7"{
                            switch($inputarray[2]){
                                "0"{$outputcash -= $perplay}
                                "7"{$outputcash += 500}
                                "X"{$outputcash += $perplay}
                                "6"{$outputcash += $perplay}
                                "@"{$outputcash += $perplay}
                                "*"{$outputcash += $perplay}
                            }
                        }
                        "X"{$outputcash -= $perplay}
                        "6"{$outputcash -= $perplay}
                        "@"{$outputcash -= $perplay}
                        "*"{$outputcash -= $perplay}
                    }
                }
                "X"{
                    switch($inputarray[1]){
                        "0"{$outputcash -= $perplay}
                        "X"{
                            switch($inputarray[2]){
                                "0"{$outputcash -= $perplay}
                                "X"{$outputcash += 250}
                                "7"{$outputcash += $perplay}
                                "6"{$outputcash += $perplay}
                                "@"{$outputcash += $perplay}
                                "*"{$outputcash += $perplay}
                            }
                        }
                        "7"{$outputcash -= $perplay}
                        "6"{$outputcash -= $perplay}
                        "@"{$outputcash -= $perplay}
                        "*"{$outputcash -= $perplay}
                    }
                }
                "6"{
                    switch($inputarray[1]){
                        "0"{$outputcash -= $perplay}
                        "6"{
                            switch($inputarray[2]){
                                "0"{$outputcash -= $perplay}
                                "6"{$outputcash += 150}
                                "7"{$outputcash += $perplay}
                                "X"{$outputcash += $perplay}
                                "@"{$outputcash += $perplay}
                                "*"{$outputcash += $perplay}
                            }
                        }
                        "7"{$outputcash -= $perplay}
                        "X"{$outputcash -= $perplay}
                        "@"{$outputcash -= $perplay}
                        "*"{$outputcash -= $perplay}
                    }
                }
                "@"{
                    switch($inputarray[1]){
                        "0"{$outputcash -= $perplay}
                        "@"{
                            switch($inputarray[2]){
                                "0"{$outputcash -= $perplay}
                                "@"{$outputcash += 100}
                                "X"{$outputcash += $perplay}
                                "6"{$outputcash += $perplay}
                                "7"{$outputcash += $perplay}
                                "*"{$outputcash += $perplay}
                            }
                        }
                        "X"{$outputcash -= $perplay}
                        "6"{$outputcash -= $perplay}
                        "7"{$outputcash -= $perplay}
                        "*"{$outputcash -= $perplay}
                    }
                }
                "*"{
                    switch($inputarray[1]){
                        "0"{$outputcash -= $perplay}
                        "*"{
                            switch($inputarray[2]){
                                "0"{$outputcash -= $perplay}
                                "*"{$outputcash += 100}
                                "X"{$outputcash += $perplay}
                                "6"{$outputcash += $perplay}
                                "7"{$outputcash += $perplay}
                                "@"{$outputcash += $perplay}
                            }
                        }
                        "X"{$outputcash -= $perplay}
                        "6"{$outputcash -= $perplay}
                        "7"{$outputcash -= $perplay}
                        "@"{$outputcash -= $perplay}
                    }
                }
            }
            $outputcash    
        }    
    }
}

function get-drawcheckmulti{                       #The function to check the draw from the function get-draw for multiple drawn arrays. For the three and eight line games separated by difficulty.
    param (
    [parameter(mandatory=$true)] $inputarray1,     #One of the three drawn arrays from the get-draw function. 
    [parameter(mandatory=$true)] $inputarray2,     #One of the three drawn arrays from the get-draw function.
    [parameter(mandatory=$true)] $inputarray3,     #One of the three drawn arrays from the get-draw function.
    [parameter(mandatory=$true)] $perplay,         #The amount the player loses or gains back if they have a win or lose draw from one of the three arrays.
    [parameter(mandatory=$true)] $difficulty
    )


    switch($difficulty){
        'normal'{                                 #The difference between this function and get-drawcheck function is the amount of array items that get checked. This switch in this function handles three arrays and nine array items.
            $outputcash1 = 0                      #This variable collects what the player earned/lost on $inputarray1. 
            $outputcash2 = 0                      #This variable collects what the player earned/lost on $inputarray2.  
            $outputcash3 = 0                      #This variable collects what the player earned/lost on $inputarray3. 
            $outputcasharr = @($outputcash1, $outputcash2, $outputcash3)              #This array is the output from this function. When all three arrays have gone through the switch below, their totals are updated in this array.

            $group = @($inputarray1, $inputarray2, $inputarray3)                      #This array is used for the for loop below that goes through each array item of each array to find matching symbols. This was done so there didn't have
                                                                                      #to be multiple switches for each inputted array.

            #Typical left to right check for each draw
            for($i=0; $i -le 2; $i++){
                switch($group[$i].GetValue(0)){
                                                                                      #This switch goes through each item in the array that was drawn from the get-draw function. If the first array item satifies the first part of the switch, the second array
                                                                                      #item is evaluated in the next nest switch. If it satifies that switch, the third array item is evaluated on the last nested switch. The same applies to hard.
                        "0"{$outputcasharr[$i] -= $perplay}
                        "7"{
                           switch($group[$i].GetValue(1)){
                                "0"{$outputcasharr[$i] -= $perplay}
                                "7"{
                                    switch($group[$i].GetValue(2)){
                                        "0"{$outputcasharr[$i] -= $perplay}
                                        "7"{$outputcasharr[$i] += 500}
                                        "X"{$outputcasharr[$i] += $perplay}
                                        "6"{$outputcasharr[$i] += $perplay}
                                        "@"{$outputcasharr[$i] += $perplay}
                                        "*"{$outputcasharr[$i] += $perplay}
                                    }
                                }
                                "X"{$outputcasharr[$i] -= $perplay}
                                "6"{$outputcasharr[$i] -= $perplay}
                                "@"{$outputcasharr[$i] -= $perplay}
                                "*"{$outputcasharr[$i] -= $perplay}
                           }
                        }
                        "X"{
                            switch($group[$i].GetValue(1)){
                                "0"{$outputcasharr[$i] -= $perplay}
                                "X"{
                                    switch($group[$i].GetValue(2)){
                                        "0"{$outputcasharr[$i] -= $perplay}
                                        "X"{$outputcasharr[$i] += 250}
                                        "7"{$outputcasharr[$i] += $perplay}
                                        "6"{$outputcasharr[$i] += $perplay}
                                        "@"{$outputcasharr[$i] += $perplay}
                                        "*"{$outputcasharr[$i] += $perplay}
                                    }
                                }
                                "7"{$outputcasharr[$i] -= $perplay}
                                "6"{$outputcasharr[$i] -= $perplay}
                                "@"{$outputcasharr[$i] -= $perplay}
                                "*"{$outputcasharr[$i] -= $perplay}
                           }
                        }
                        "6"{
                            switch($group[$i].GetValue(1)){
                                "0"{$outputcasharr[$i] -= $perplay}
                                "6"{
                                    switch($group[$i].GetValue(2)){
                                        "0"{$outputcasharr[$i] -= $perplay}
                                        "6"{$outputcasharr[$i] += 150}
                                        "7"{$outputcasharr[$i] += $perplay}
                                        "X"{$outputcasharr[$i] += $perplay}
                                        "@"{$outputcasharr[$i] += $perplay}
                                        "*"{$outputcasharr[$i] += $perplay}
                                    }
                                }
                                "7"{$outputcasharr[$i] -= $perplay}
                                "X"{$outputcasharr[$i] -= $perplay}
                                "@"{$outputcasharr[$i] -= $perplay}
                                "*"{$outputcasharr[$i] -= $perplay}
                           }
                        }
                        "@"{
                            switch($group[$i].GetValue(1)){
                                "0"{$outputcasharr[$i] -= $perplay}
                                "@"{
                                    switch($group[$i].GetValue(2)){
                                        "0"{$outputcasharr[$i] -= $perplay}
                                        "@"{$outputcasharr[$i] += 100}
                                        "X"{$outputcasharr[$i] += $perplay}
                                        "6"{$outputcasharr[$i] += $perplay}
                                        "7"{$outputcasharr[$i] += $perplay}
                                        "*"{$outputcasharr[$i] += $perplay}
                                    }
                                }
                                "X"{$outputcasharr[$i] -= $perplay}
                                "6"{$outputcasharr[$i] -= $perplay}
                                "7"{$outputcasharr[$i] -= $perplay}
                                "*"{$outputcasharr[$i] -= $perplay}
                           }
                        }
                        "*"{
                           switch($group[$i].GetValue(1)){
                                "0"{$outputcasharr[$i] -= $perplay}
                                "*"{
                                    switch($group[$i].GetValue(2)){
                                        "0"{$outputcasharr[$i] -= $perplay}
                                        "*"{$outputcasharr[$i] += 100}
                                        "X"{$outputcasharr[$i] += $perplay}
                                        "6"{$outputcasharr[$i] += $perplay}
                                        "7"{$outputcasharr[$i] += $perplay}
                                        "@"{$outputcasharr[$i] += $perplay}
                                    }
                                }
                                "X"{$outputcasharr[$i] -= $perplay}
                                "6"{$outputcasharr[$i] -= $perplay}
                                "7"{$outputcasharr[$i] -= $perplay}
                                "@"{$outputcasharr[$i] -= $perplay}
                           }
                        }
                    }
                }
            $outputcasharr
        }
        'hard'{                      #The difference between 'normal' and 'hard' is the amount of array items that get checked. 'Hard' handles eight arrays and 24 array items.          
            $outputcash1 = 0         #This variable collects what the player earned/lost on $inputarray1.
            $outputcash2 = 0         #This variable collects what the player earned/lost on $inputarray2.
            $outputcash3 = 0         #This variable collects what the player earned/lost on $inputarray3.
            $outputcash4 = 0         #This variable collects what the player earned/lost on the first array items of inputarray's 1-3.
            $outputcash5 = 0         #This variable collects what the player earned/lost on the second array items of inputarray's 1-3.
            $outputcash6 = 0         #This variable collects what the player earned/lost on the third array items of inputarray's 1-3.
            $outputcash7 = 0         #This variable collects what the player earned/lost on the array items of $inputarray1[0], $inputarray2[1], and $inputarray3[2].
            $outputcash8 = 0         #This variable collects what the player earned/lost on the array items of $inputarray3[0], $inputarray2[1], and $inputarray1[3].
            $outputcasharr = @($outputcash1, $outputcash2, $outputcash3, $outputcash4, $outputcash5, $outputcash6, $outputcash7, $outputcash8)   #This is the output of this function. Whatever the player earns/loses from all eight arrays
                                                                                                                                                 #is updated here.

            $colarr1 = @($inputarray1[0], $inputarray2[0], $inputarray3[0])   #The fourth array created from elements of the first three inputed arrays.
            $colarr2 = @($inputarray1[1], $inputarray2[1], $inputarray3[1])   #The fifth array created from elements of the first three inputed arrays.
            $colarr3 = @($inputarray1[2], $inputarray2[2], $inputarray3[2])   #The sixth array created from elements of the first three inputed arrays.
            $angarr1 = @($inputarray1[0], $inputarray2[1], $inputarray3[2])   #The seventh array created from elements of the first three inputed arrays.
            $angarr2 = @($inputarray3[0], $inputarray2[1], $inputarray1[2])   #The eighth array created from elements of the first three inputed arrays.
            $group = @($inputarray1, $inputarray2, $inputarray3, $colarr1, $colarr2, $colarr3, $angarr1, $angarr2)      #This array is used for the for loop below that goes through each array item of each array to find matching symbols. This was done so there didn't have
                                                                                                                        #to be multiple switches for each inputted array.
            #Typical left to right check for each draw
            for($i=0; $i -le 7; $i++){
                switch($group[$i].GetValue(0)){
                        "0"{$outputcasharr[$i] -= $perplay}
                        "7"{
                           switch($group[$i].GetValue(1)){
                                "0"{$outputcasharr[$i] -= $perplay}
                                "7"{
                                    switch($group[$i].GetValue(2)){
                                        "0"{$outputcasharr[$i] -= $perplay}
                                        "7"{$outputcasharr[$i] += 500}
                                        "X"{$outputcasharr[$i] += $perplay}
                                        "6"{$outputcasharr[$i] += $perplay}
                                        "@"{$outputcasharr[$i] += $perplay}
                                        "*"{$outputcasharr[$i] += $perplay}
                                    }
                                }
                                "X"{$outputcasharr[$i] -= $perplay}
                                "6"{$outputcasharr[$i] -= $perplay}
                                "@"{$outputcasharr[$i] -= $perplay}
                                "*"{$outputcasharr[$i] -= $perplay}
                           }
                        }
                        "X"{
                            switch($group[$i].GetValue(1)){
                                "0"{$outputcasharr[$i] -= $perplay}
                                "X"{
                                    switch($group[$i].GetValue(2)){
                                        "0"{$outputcasharr[$i] -= $perplay}
                                        "X"{$outputcasharr[$i] += 250}
                                        "7"{$outputcasharr[$i] += $perplay}
                                        "6"{$outputcasharr[$i] += $perplay}
                                        "@"{$outputcasharr[$i] += $perplay}
                                        "*"{$outputcasharr[$i] += $perplay}
                                    }
                                }
                                "7"{$outputcasharr[$i] -= $perplay}
                                "6"{$outputcasharr[$i] -= $perplay}
                                "@"{$outputcasharr[$i] -= $perplay}
                                "*"{$outputcasharr[$i] -= $perplay}
                           }
                        }
                        "6"{
                            switch($group[$i].GetValue(1)){
                                "0"{$outputcasharr[$i] -= $perplay}
                                "6"{
                                    switch($group[$i].GetValue(2)){
                                        "0"{$outputcasharr[$i] -= $perplay}
                                        "6"{$outputcasharr[$i] += 150}
                                        "7"{$outputcasharr[$i] += $perplay}
                                        "X"{$outputcasharr[$i] += $perplay}
                                        "@"{$outputcasharr[$i] += $perplay}
                                        "*"{$outputcasharr[$i] += $perplay}
                                    }
                                }
                                "7"{$outputcasharr[$i] -= $perplay}
                                "X"{$outputcasharr[$i] -= $perplay}
                                "@"{$outputcasharr[$i] -= $perplay}
                                "*"{$outputcasharr[$i] -= $perplay}
                           }
                        }
                        "@"{
                            switch($group[$i].GetValue(1)){
                                "0"{$outputcasharr[$i] -= $perplay}
                                "@"{
                                    switch($group[$i].GetValue(2)){
                                        "0"{$outputcasharr[$i] -= $perplay}
                                        "@"{$outputcasharr[$i] += 100}
                                        "X"{$outputcasharr[$i] += $perplay}
                                        "6"{$outputcasharr[$i] += $perplay}
                                        "7"{$outputcasharr[$i] += $perplay}
                                        "*"{$outputcasharr[$i] += $perplay}
                                    }
                                }
                                "X"{$outputcasharr[$i] -= $perplay}
                                "6"{$outputcasharr[$i] -= $perplay}
                                "7"{$outputcasharr[$i] -= $perplay}
                                "*"{$outputcasharr[$i] -= $perplay}
                           }
                        }
                        "*"{
                           switch($group[$i].GetValue(1)){
                                "0"{$outputcasharr[$i] -= $perplay}
                                "*"{
                                    switch($group[$i].GetValue(2)){
                                        "0"{$outputcasharr[$i] -= $perplay}
                                        "*"{$outputcasharr[$i] += 100}
                                        "X"{$outputcasharr[$i] += $perplay}
                                        "6"{$outputcasharr[$i] += $perplay}
                                        "7"{$outputcasharr[$i] += $perplay}
                                        "@"{$outputcasharr[$i] += $perplay}
                                    }
                                }
                                "X"{$outputcasharr[$i] -= $perplay}
                                "6"{$outputcasharr[$i] -= $perplay}
                                "7"{$outputcasharr[$i] -= $perplay}
                                "@"{$outputcasharr[$i] -= $perplay}
                           }
                        }
                    }
                }
            $outputcasharr
        } 
    }
}

#The actual game itself

#Menu screen
do{
    cls
    "`n"         
    ' ╔═♥═♦═♣═♠══╦════╗  '
    ' ║POWERSHELL║  @ ║  '
    ' ╠══════════╣  │ ║  '
    ' ║ $  $  $  ║  │ ║  '
    ' ╠══════════╣  │ ║  '
    ' ║  SLOTS   ║  O ║  '
    ' ╚═♠═♣═♦═♥══╩════╝  '
    "`n"
    'Try your luck with $500 dollars on the Powershell Slot Machine!'
    "`n"
    "`n"
    "Enter a number and press enter."
    "`n"
    "1 - Play One Line Game on Easy"
    "2 - Play One Line Game on Normal"
    "3 - Play Three Line Game on Normal"
    "4 - Play Three Line Game on Hard"
    "5 - Game Rules"
    "6 - Exit"

    [string]$menuoption = read-host -Prompt "Choose a number"
    while('1','2','3','4','5','6' -notcontains $menuoption){
        [string]$menuoption = read-host -Prompt "Invalid input. Choose a number"
    }

    switch($menuoption){
        '1'{
            cls
        }
        '2'{
            cls
        }
        '3'{
            cls
        }
        '4'{
            cls
        }
        '5'{
            cls
            "`n"
            'RULES:'
	        '   -General'
		    '      -Each turn on the slots for all game types costs $25.'
		    '      -The player is initially given $500 to use on the slots for all game modes.'
		    '      -Symbols used in order of least to most value: 0, *, @, 6, X, 7'
		    '      -A zero symbol (0) in any column of any game mode will make you automatically lose cash.'
		    '      -Two like symbols in the first two columns will give back the $25 cost.'
		    '      -Three like symbols in a row will earn the player cash in the following order:'
		    '         -7 = $500'
		    '         -X = $250'
		    '         -6 = $150'
		    '         -@ = $100'
		    '         -* = $100'
		    '      -A freeplay draw is given to the player after 10 consecutives draws on the slots.'
		    '      -No money is lost in freeplay if the player does not have any matching symbols.'
		    '      -No cash is earned from two symbols ina row in freeplay.'
	        '   -One Line Games'
		    '      -Easy'
			'         -Easy mode does not use the zero symbol (0) in draws.'
			'         -If the player has less than $25, the game ends.'
		    '      -Normal'
			'         -Normal mode uses all symbols in draws.'
			'         -If the player has less than $25, the game ends.'
	        '   -Three Line Games'
		    '      -Normal'
			'         -Normal mode uses all symbols in draws.'
			'         -Three lines of symbols are drawn and cost $25 each, $75 total.'
			'         -If the player has less than $75, the game ends.'
			'         -Draws are counted left to right, no other direction.'
		    '      -Hard'
			'         -Hard mode uses all symbols in draws.'
			'         -Three lines of symbols are drawn and eight lines are judged from the following '
			'         directions and symbols per line:'
		    '            -Left to right of all symbols of Line 1.'
		    '            -Left to right of all symbols of Line 2.'
		    '            -Left to right of all symbols of Line 3.'
			'            -Top to bottom of the first symbols in Lines 1-3.'
			'            -Top to bottom of the second symbols in Lines 1-3.'
		    '            -Top to bottom of the third symbols in Lines 1-3.'
		    '            -Diagonal down of the Line 1 symbol 1, Line 2 symbol 2, and Line 3 symbol 3.'
		    '            -Diagonal up of the Line 3 symbol 1, Line 2 symbol 2, and Line 1 symbol 3.'
			'         -All eight draws cost $25 each, $200 total.'
			'         -If the player has less than $200, the game ends.'
            "`n"
            pause
            
            cls
        }
        '6'{
            cls
            Return
        }
    }
}until($menuoption -eq '1' -or $menuoption -eq '2' -or $menuoption -eq '3' -or $menuoption -eq '4')

#Initial slot screen for the beginning of any game.
$top =    ' ╔══♥══♦══♣══♠══♥══♦══♣══╗ '
$line1 =  ' ║  $        $        $  ║ '
$line2 =  ' ║  $        $        $  ║ '
$line3 =  ' ║  $        $        $  ║ '
$bottom = ' ╚══♣══♦══♥══♠══♣══♦══♥══╝ '


switch($menuoption){
    '1'{   #One line game 'Easy'

        $turn = 0             #Used to find out if the player actually started a game.
        $playfee = 25         #The fee the slot takes per draw
        $freeplay = 10        #The counter that keeps track of the player's free play status. The number goes down each time the player runs the slots.
        $money = 500          #The initial amount of money the player has for the game. 

        "`n"
        "Press 1 and Enter to run the slot machine. Good Luck!"
        "`n"
        $top
        $line1
        $bottom
        "`n"

        #The prompt for the user to either run the slot or end the game.
        do{
            
            $question = read-host -prompt "Do you want to run the slot [1] or walk away [2]?"
            while(1,2 -notcontains $question){
                $question = read-host -prompt "Answer must be a 1 or a 2. Do you want to run the slot [1] or walk away [2]?"
            }

            switch($question){
                1{
                    $turn = 1

                    #The freeplay portion of the game. This section is used when $freeplay reaches zero. Only difference between this and the normal section is $playfee is zero and $freeplay is reset back to 10.
                    if($freeplay -eq 0){
        
                        $freeplay = 10
                        $freeplaydraw = get-draw -difficulty 'easy'
                        $freeplaycheck = get-drawcheck -inputarray $freeplaydraw -perplay 0 -difficulty 'easy'
                
                        $num1 = $freeplaydraw[0]
                        $num2 = $freeplaydraw[1]
                        $num3 = $freeplaydraw[2]

                        $line1 = " ║  $num1        $num2        $num3  ║ "        #The array items drawn from $freeplaydraw displayed here.

                        $money += $freeplaycheck


                        #animation pause screen
                        get-pausescreen -lines 1

                        cls
                        "`n"
                        "Turns left until free play: " + $freeplay
                        "`n"
                        'Current money left: $' + $money
                        "`n"
                        $top
                        $line1
                        $bottom
                        "`n"
                        "Money gained/lost during turn: " + $freeplaycheck
                        "`n"
                
                                
                     }else{
                        #Normal portion of the game without freeplay. If the player has less than 25 dollars, the game ends. 
                        if($money -ge 25){

                            $freeplay -= 1
                            $normaldraw = get-draw -difficulty 'easy'
                            $normaldrawcheck = get-drawcheck -inputarray $normaldraw -perplay $playfee -difficulty 'easy'
                    
                            $num1 = $normaldraw[0]
                            $num2 = $normaldraw[1]
                            $num3 = $normaldraw[2]   
                    
                            $line1 = " ║  $num1        $num2        $num3  ║ "  #The array items drawn from $normaldraw displayed here.
                    
                            $money += $normaldrawcheck


                            #Animation pause screen
                            get-pausescreen -lines 1

                            if($freeplay -eq 0){  #Screen displayed to player if $freeplay has reached zero.
                                cls
                                "`n"
                                "YOU'VE EARNED YOURSELF A FREEPLAY ON THE SLOT!"
                                "`n"
                                'Current money left: $' + $money
                                "`n"
                                $top
                                $line1
                                $bottom
                                "`n"
                                "Money gained/lost during turn: " + $normaldrawcheck
                                "`n"
                            }else{  #Normal play screen
                                cls
                                "`n"
                                "Turns left until free play: " + $freeplay
                                "`n"
                                'Current money left: $' + $money
                                "`n"
                                $top
                                $line1
                                $bottom
                                "`n"
                                "Money gained/lost during turn: " + $normaldrawcheck
                                "`n"
                            }
                         }else{  #End screen if the player has less than 25 dollars.
                            cls
                            "`n"
                            "GAME OVER"
                            "`n"
                            "You're broke!"
                            "`n"
                            "You tried your best but it wasn't enough."
                            "`n"
                            "Come back next time when you have more money!"
                            "`n"
                            pause
                            Return
                          }
                      }
                  }
           }
      }until($question -eq 2)

    }
    '2'{   #One line game 'Normal'
        $turn = 0       #Used to find out if the player actually started a game.
        $playfee = 25   #The fee the slot takes per draw
        $freeplay = 10  #The counter that keeps track of the player's free play status. The number goes down each time the player runs the slots.
        $money = 500    #The initial amount of money the player has for the game. 

        "`n"
        "Press 1 and Enter to run the slot machine. Good Luck!"
        "`n"
        $top
        $line1
        $bottom
        "`n"

        do{
    
            $question = read-host -prompt "Do you want to run the slot [1] or walk away [2]?"
            while(1,2 -notcontains $question){
                $question = read-host -prompt "Answer must be a 1 or a 2. Do you want to run the slot [1] or walk away [2]?"
            }

            switch($question){
                1{
                    $turn = 1
                    if($freeplay -eq 0){
        
                        $freeplay = 10
                        $freeplaydraw = get-draw -difficulty 'normal'
                        $freeplaycheck = get-drawcheck -inputarray $freeplaydraw -perplay 0 -difficulty 'normal'
                
                        $num1 = $freeplaydraw[0]
                        $num2 = $freeplaydraw[1]
                        $num3 = $freeplaydraw[2]

                        $line1 = " ║  $num1        $num2        $num3  ║ "     #The array items drawn from $freeplaydraw displayed here.

                        $money += $freeplaycheck


                        #animation pause screen
                        get-pausescreen -lines 1

                        cls
                        "`n"
                        "Turns left until free play: " + $freeplay
                        "`n"
                        'Current money left: $' + $money
                        "`n"
                        $top
                        $line1
                        $bottom
                        "`n"
                        "Money gained/lost during turn: " + $freeplaycheck
                        "`n"
                
                                
                     }else{
                        if($money -ge 25){

                            $freeplay -= 1
                            $normaldraw = get-draw -difficulty 'normal'
                            $normaldrawcheck = get-drawcheck -inputarray $normaldraw -perplay $playfee -difficulty 'normal'
                    
                            $num1 = $normaldraw[0]
                            $num2 = $normaldraw[1]
                            $num3 = $normaldraw[2]   
                    
                            $line1 = " ║  $num1        $num2        $num3  ║ " 
                    
                            $money += $normaldrawcheck


                            #Animation pause screen
                            get-pausescreen -lines 1

                            if($freeplay -eq 0){
                                cls
                                "`n"
                                "YOU'VE EARNED YOURSELF A FREEPLAY ON THE SLOT!"
                                "`n"
                                'Current money left: $' + $money
                                "`n"
                                $top
                                $line1
                                $bottom
                                "`n"
                                "Money gained/lost during turn: " + $normaldrawcheck
                                "`n"
                            }else{
                                cls
                                "`n"
                                "Turns left until free play: " + $freeplay
                                "`n"
                                'Current money left: $' + $money
                                "`n"
                                $top
                                $line1
                                $bottom
                                "`n"
                                "Money gained/lost during turn: " + $normaldrawcheck
                                "`n"
                            }
                         }else{
                            cls
                            "`n"
                            "GAME OVER"
                            "`n"
                            "You're broke!"
                            "`n"
                            "You tried your best but it wasn't enough."
                            "`n"
                            "Come back next time when you have more money!"
                            "`n"
                            pause
                            Return
                          }
                      }
                  }
           }
      }until($question -eq 2)

    }
    '3'{   #Three line game 'Normal'
        $turn = 0       #Used to find out if the player actually started a game.
        $playfee = 25   #The fee the slot takes per draw
        $freeplay = 10  #The counter that keeps track of the player's free play status. The number goes down each time the player runs the slots.
        $money = 500    #The initial amount of money the player has for the game. 

        "`n"
        "Hit enter to run the slot machine. Good Luck!"
        "`n"
        $top
        $line1
        $line2
        $line3
        $bottom
        "`n"

        do{
    
            $question = read-host -prompt "Do you want to run the slot [1] or walk away [2]?"
            while(1,2 -notcontains $question){
                $question = read-host -prompt "Answer must be a 1 or a 2. Do you want to run the slot [1] or walk away [2]?"
            }

            switch($question){
                1{
                    $turn = 1
                    if($freeplay -eq 0){
        
                        $freeplay = 10
                        $freeplaydraw1 = get-draw -difficulty 'normal'
                        $freeplaydraw2 = get-draw -difficulty 'normal'
                        $freeplaydraw3 = get-draw -difficulty 'normal'
                        $freeplaycheck = get-drawcheckmulti -inputarray1 $freeplaydraw1 -inputarray2 $freeplaydraw2 -inputarray3 $freeplaydraw3 -perplay 0 -difficulty 'normal'
                
                        $num1 = $freeplaydraw1[0]
                        $num2 = $freeplaydraw1[1]
                        $num3 = $freeplaydraw1[2]
                        $num4 = $freeplaydraw2[0]
                        $num5 = $freeplaydraw2[1]
                        $num6 = $freeplaydraw2[2]
                        $num7 = $freeplaydraw3[0]
                        $num8 = $freeplaydraw3[1]
                        $num9 = $freeplaydraw3[2]

                        $line1 = " ║  $num1        $num2        $num3  ║ "
                        $line2 = " ║  $num4        $num5        $num6  ║ "
                        $line3 = " ║  $num7        $num8        $num9  ║ " 

                        $totalmoneyfreeplay = ($freeplaycheck[0] + $freeplaycheck[1] + $freeplaycheck[2])
                        $money += $totalmoneyfreeplay

                        get-pausescreen -lines 3

                        cls
                        "`n"
                        "Turns left until free play: " + $freeplay
                        "`n"
                        'Current money left: $' + $money
                        "`n"
                        $top 
                        $line1 + "     Horizontal 1: " + $freeplaycheck[0]
                        $line2 + "     Horizontal 2: " + $freeplaycheck[1]
                        $line3 + "     Horizontal 3: " + $freeplaycheck[2]
                        $bottom
                        "`n"
                        "Money gained/lost during turn: " + $totalmoneyfreeplay
                        "`n"
                
                                
                     }else{
                        if($money -ge 75){

                            $freeplay -= 1
                            $normaldraw1 = get-draw -difficulty 'normal'
                            $normaldraw2 = get-draw -difficulty 'normal'
                            $normaldraw3 = get-draw -difficulty 'normal'
                            $normaldrawcheck = get-drawcheckmulti -inputarray1 $normaldraw1 -inputarray2 $normaldraw2 -inputarray3 $normaldraw3  -perplay $playfee -difficulty 'normal'
                    
                            $num1 = $normaldraw1[0]
                            $num2 = $normaldraw1[1]
                            $num3 = $normaldraw1[2]
                            $num4 = $normaldraw2[0]
                            $num5 = $normaldraw2[1]
                            $num6 = $normaldraw2[2]
                            $num7 = $normaldraw3[0]
                            $num8 = $normaldraw3[1]
                            $num9 = $normaldraw3[2]   
                    
                            $line1 = " ║  $num1        $num2        $num3  ║ "
                            $line2 = " ║  $num4        $num5        $num6  ║ "
                            $line3 = " ║  $num7        $num8        $num9  ║ "  
                    
                            $totalmoneynormaldraw = ($normaldrawcheck[0] + $normaldrawcheck[1] + $normaldrawcheck[2])
                            $money += $totalmoneynormaldraw
                            
                            get-pausescreen -lines 3

                            if($freeplay -eq 0){
                                cls
                                "`n"
                                "YOU'VE EARNED YOURSELF A FREEPLAY ON THE SLOT!"
                                "`n"
                                'Current money left: $' + $money
                                "`n"
                                $top
                                $line1 + "     Horizontal 1: " + $normaldrawcheck[0] 
                                $line2 + "     Horizontal 2: " + $normaldrawcheck[1] 
                                $line3 + "     Horizontal 3: " + $normaldrawcheck[2] 
                                $bottom
                                "`n"
                                "Money gained/lost during turn: " + $totalmoneynormaldraw
                                "`n"
                            }else{
                                cls
                                "`n"
                                "Turns left until free play: " + $freeplay
                                "`n"
                                'Current money left: $' + $money
                                "`n"
                                $top
                                $line1 + "     Horizontal 1: " + $normaldrawcheck[0] 
                                $line2 + "     Horizontal 2: " + $normaldrawcheck[1]
                                $line3 + "     Horizontal 3: " + $normaldrawcheck[2]
                                $bottom
                                "`n"
                                "Money gained/lost during turn: " + $totalmoneynormaldraw
                                "`n"
                            }
                         }else{
                            cls
                            "`n"
                            "GAME OVER"
                            "`n"
                            "You don't have enough to play!!!"
                            "`n"
                            "You tried your best but it wasn't enough."
                            "`n"
                            "Come back next time when you have more money!"
                            "`n"
                            pause
                            Return
                          }
                      }
                  }
           }
      }until($question -eq 2)
    }
    '4'{   #Eight line game 'Hard'
        
        $turn = 0
        $playfee = 25
        $freeplay = 10
        $money = 500

        "`n"
        "Hit enter to run the slot machine. Good Luck!"
        "`n"
        $top
        $line1
        $line2
        $line3
        $bottom
        "`n"

        do{
            $question = read-host -prompt "Do you want to run the slot [1] or walk away [2]?"
            while(1,2 -notcontains $question){
                $question = read-host -prompt "Answer must be a 1 or a 2. Do you want to run the slot [1] or walk away [2]?"
            }

            switch($question){
                1{
                    $turn = 1
                    if($freeplay -eq 0){
        
                        $freeplay = 10
                        $freeplaydraw1 = get-draw -difficulty 'normal'
                        $freeplaydraw2 = get-draw -difficulty 'normal'
                        $freeplaydraw3 = get-draw -difficulty 'normal'
                        $freeplaycheck = get-drawcheckmulti -inputarray1 $freeplaydraw1 -inputarray2 $freeplaydraw2 -inputarray3 $freeplaydraw3 -perplay 0 -difficulty 'hard'
                
                        $num1 = $freeplaydraw1[0]
                        $num2 = $freeplaydraw1[1]
                        $num3 = $freeplaydraw1[2]
                        $num4 = $freeplaydraw2[0]
                        $num5 = $freeplaydraw2[1]
                        $num6 = $freeplaydraw2[2]
                        $num7 = $freeplaydraw3[0]
                        $num8 = $freeplaydraw3[1]
                        $num9 = $freeplaydraw3[2]

                        $line1 = " ║  $num1        $num2        $num3  ║ "
                        $line2 = " ║  $num4        $num5        $num6  ║ "
                        $line3 = " ║  $num7        $num8        $num9  ║ " 

                        $totalmoneyfreeplay = ($freeplaycheck[0] + $freeplaycheck[1] + $freeplaycheck[2] + $freeplaycheck[3] + $freeplaycheck[4] + $freeplaycheck[5] + $freeplaycheck[6] + $freeplaycheck[7])
                        $money += $totalmoneyfreeplay

                        get-pausescreen -lines 3

                        cls
                        "`n"
                        "Turns left until free play: " + $freeplay
                        "`n"
                        'Current money left: $' + $money
                        "`n"
                        $top 
                        $line1 + "     Horizontal 1: " + $freeplaycheck[0] + "   Horizontal 2: " + $freeplaycheck[1] 
                        $line2 + "     Horizontal 3: " + $freeplaycheck[2] + "   Column 1:     " + $freeplaycheck[3]
                        $line3 + "     Column 2:     " + $freeplaycheck[4] + "   Column 3:     " + $freeplaycheck[5]
                        $bottom + "     Upper Diag:   " + $freeplaycheck[6] + "   Lower Diag:   " + $freeplaycheck[7]
                        "`n"
                        "Money gained/lost during turn: " + $totalmoneyfreeplay
                        "`n"
                
                                
                     }else{
                        if($money -ge 200){

                            $freeplay -= 1
                            $normaldraw1 = get-draw -difficulty 'normal'
                            $normaldraw2 = get-draw -difficulty 'normal'
                            $normaldraw3 = get-draw -difficulty 'normal'
                            $normaldrawcheck = get-drawcheckmulti -inputarray1 $normaldraw1 -inputarray2 $normaldraw2 -inputarray3 $normaldraw3  -perplay $playfee -difficulty 'hard'
                    
                            $num1 = $normaldraw1[0]
                            $num2 = $normaldraw1[1]
                            $num3 = $normaldraw1[2]
                            $num4 = $normaldraw2[0]
                            $num5 = $normaldraw2[1]
                            $num6 = $normaldraw2[2]
                            $num7 = $normaldraw3[0]
                            $num8 = $normaldraw3[1]
                            $num9 = $normaldraw3[2]   
                    
                            $line1 = " ║  $num1        $num2        $num3  ║ "
                            $line2 = " ║  $num4        $num5        $num6  ║ "
                            $line3 = " ║  $num7        $num8        $num9  ║ "  
                    
                            $totalmoneynormaldraw = ($normaldrawcheck[0] + $normaldrawcheck[1] + $normaldrawcheck[2] + $normaldrawcheck[3] + $normaldrawcheck[4] + $normaldrawcheck[5] + $normaldrawcheck[6] + $normaldrawcheck[7])
                            $money += $totalmoneynormaldraw
                            
                            get-pausescreen -lines 3

                            if($freeplay -eq 0){
                                cls
                                "`n"
                                "YOU'VE EARNED YOURSELF A FREEPLAY ON THE SLOT!"
                                "`n"
                                'Current money left: $' + $money
                                "`n"
                                $top
                                $line1 + "     Horizontal 1: " + $normaldrawcheck[0] + "   Horizontal 2: " + $normaldrawcheck[1] 
                                $line2 + "     Horizontal 3: " + $normaldrawcheck[2] + "   Column 1:     " + $normaldrawcheck[3]
                                $line3 + "     Column 2:     " + $normaldrawcheck[4] + "   Column 3:     " + $normaldrawcheck[5]
                                $bottom + "     Upper Diag:   " + $normaldrawcheck[6] + "   Lower Diag:   " + $normaldrawcheck[7]
                                "`n"
                                "Money gained/lost during turn: " + $totalmoneynormaldraw
                                "`n"
                            }else{
                                cls
                                "`n"
                                "Turns left until free play: " + $freeplay
                                "`n"
                                'Current money left: $' + $money
                                "`n"
                                $top
                                $line1 + "     Horizontal 1: " + $normaldrawcheck[0] + "   Horizontal 2: " + $normaldrawcheck[1] 
                                $line2 + "     Horizontal 3: " + $normaldrawcheck[2] + "   Column 1:     " + $normaldrawcheck[3]
                                $line3 + "     Column 2:     " + $normaldrawcheck[4] + "   Column 3:     " + $normaldrawcheck[5]
                                $bottom + "     Upper Diag:   " + $normaldrawcheck[6] + "   Lower Diag:   " + $normaldrawcheck[7]
                                "`n"
                                "Money gained/lost during turn: " + $totalmoneynormaldraw
                                "`n"
                            }
                         }else{
                            cls
                            "`n"
                            "GAME OVER"
                            "`n"
                            "You don't have enough to play!!!"
                            "`n"
                            "You tried your best but it wasn't enough."
                            "`n"
                            "Come back next time when you have more money!"
                            "`n"
                            pause
                            Return
                          }
                      }
                  }
           }
      }until($question -eq 2)

    }

}

#End game screen with various endings.
$defaultendingtext = "Unfortunately this is a powershell script, not a casino. Good luck getting your money."
switch($turn){
    0{
        cls
        "`n"
        "GAME OVER"
        "`n"
        "Game earnings: $money"
        "`n"
        "Wow. Walking away without even trying. Who taught you how to have fun?"
        "`n"
        $defaultendingtext
        "`n"
        pause
        return
    }
    1{
      if($money -lt 500){
        cls
        "`n"
        "GAME OVER"
        "`n"
        "Game earnings: $money"
        "`n"
        "Well, at least you walked away before going completely broke!"
        "`n"
        $defaultendingtext
        "`n"
        pause
        return
      }elseif($money -ge 500 -and $money -lt 1000){
        cls
        "`n"
        "GAME OVER"
        "`n"
        "Game earnings: $money"
        "`n"
        "Hey, you walked out with what you came in and maybe a little bit more. Good for you!"
        "`n"
        $defaultendingtext
        "`n"
        pause
        return
      }elseif($money -ge 1000 -and $money -lt 1500){
        cls
        "`n"
        "GAME OVER"
        "`n"
        "Game earnings: $money"
        "`n"
        "Hey, you doubled you money and then some! Go get your girlfriend something nice. Maybe your wife too!"
        "`n"
        $defaultendingtext
        "`n"
        pause
        return
      }elseif($money -ge 1500 -and $money -lt 10000){
        cls
        "`n"
        "GAME OVER"
        "`n"
        "Game earnings: $money"
        "`n"
        'Wow, you put in the time and walked away with a lot more than $500. Congratulations, Post Malone would be proud of you.'
        "`n"
        $defaultendingtext
        "`n"
        pause
        return
      }elseif($money -ge 50000){
        cls
        "`n"
        "GAME OVER"
        "`n"
        "Game earnings: $money"
        "`n"
        'Well, either the script is broken, you played with some of the variables, or you are really slacking off at work to reach this score.'
        "`n"
        $defaultendingtext
        "`n"
        pause
        return
      }  
    }
}




