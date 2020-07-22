#This is free and unencumbered software released into the public domain.

#Anyone is free to copy, modify, publish, use, compile, sell, or
#distribute this software, either in source code form or as a compiled
#binary, for any purpose, commercial or non-commercial, and by any
#means.

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

#For more information, please refer to <https://unlicense.org>

#Written by Stephen Kofskie



$LevelCount = 1   #The initial level count.
$min = 1          #The initial minimum number for the get-random function. 
$max = 10         #The initial maximim number for the get-random function. 
$pause = 2        #The initial time in seconds the start-sleep function for the player to view number.

#Inspirational quotes at the end of the game.
$quotes = @(
            'Pain teaches you more than pleasure. Failure teaches you more than success. Poverty teaches you more than prosperity. Adversity teaches you more than comfort.  -Matshona Dhliwayo',
            'Because failure works double time, to get success, work triple time.  -Matshona Dhliwayo',
            'Step up your game and success will step up to you.  -Matshona Dhliwayo',
            'Failure is not the falling down, but the staying down.  -Mary Pickford',
            'Failure will never overtake me if my determination to succeed is strong enough.  -Og Mandino',
            'Our greatest glory is not in never falling, but in rising every time we fall.  -Confucius',
            'Many of lifes faliures are people who did not realize how close they were to success when then gave up.  -Thomas A. Edison',
            'I dont believe in failure. It is not failure if you enjoyed the process.  -Oprah Winfrey',
            'It is hard to fail, but it is worse never to have tried to succeed.  -Theodore Roosevelt',
            'You miss 100% of the shots you dont take.  -Wayne Gretzky  -Michael Scott'
)

#Introduction Text
cls
"`n"
"Random Number Memory Test"
"`n"
"Test your memory and see what the longest chain of numbers you can memorize!"
"`n"
pause

#The do until loop that runs the whole game.
do{

    $rando = Get-Random -Minimum $min -Maximum $max   #The random number that gets generated for the player to guess. Changes at the end of the loop.
    $LevelCountText = "Level $LevelCount"             #The level count text that is written at the beginning of each level.
    $IntroText = "Memorize this number: $rando"       #The random number that appears at the beginning of the level.

    #The presented number to memorize and timer to display said number
    cls
    "`n"
    $LevelCountText
    "`n"
    $IntroText
    "`n"
    start-sleep -Seconds $pause
    cls

    #The player's answer.
    "`n"
    $question = Read-Host -Prompt "What was the number?"
    
    #If then statement to judge if the player's answer was correct.
    if($question -eq $rando){
        cls
        "`n"
        "Correct!"
        "`n"
        write-host "Your Number: $question"
        "`n"
        write-host "Correct Number: $rando"
        "`n"
        $LevelCount++                                 #The level count number increased by one for next level.
        $min *= 10                                    #The minimum value for the get-random number increased by a mulitple of 10.
        $max *= 10                                    #The maximum value for the get-random number increased by a mulitple of 10.
        $pause += .5                                  #The value for the start-sleep function increased by half a second.
        pause
    }

}until($question -ne $rando)                          #Do until loop ends when the player's number doesn't match the get-random value.

#The end game text.
cls
"`n"
"Incorrect."
"`n"
"Level reached: $LevelCount"
"`n"
write-host "Your Number: $question"
"`n"
write-host "Correct Number: $rando"
"`n"

#Random number that is generated to pick a quote from the $quote array a top of the page.
$rando2 = get-random -minimum 0 -Maximum 9
switch($rando2){
    0{$quotes[0]}
    1{$quotes[1]}
    2{$quotes[2]}
    3{$quotes[3]}
    4{$quotes[4]}
    5{$quotes[5]}
    6{$quotes[6]}
    7{$quotes[7]}
    8{$quotes[8]}
    9{$quotes[9]}
}

"`n"
Pause



