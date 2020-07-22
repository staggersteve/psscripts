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


#Word bank used in game.
$wordbank = @(
                'developer',
                'nurse',
                'assistant',
                'dentist',
                'nurse',
                'doctor',
                'orthodontist',
                'pediatrician',
                'veterinarian',
                'manager',
                'technician',
                'mathematician',
                'optometrist',
                'surgeon',
                'administrator',
                'engineer',
                'investigator',
                'specialist',
                'accountant',
                'actuary',
                'lawyer',
                'trainer',
                'estimator',
                'programmer',
                'goldfish',
                'elephant',
                'gorilla',
                'leopard',
                'rhinoceros',
                'raccoon',
                'hippopotamus',
                'kangaroo',
                'giraffe',
                'mongoose',
                'meerkat',
                'chinchilla',
                'alligator',
                'crocodile',
                'platypus',
                'hedgehog',
                'echidna',
                'chimpanzee',
                'reindeer',
                'walrus',
                'cheetah',
                'pogona',
                'alabama',
                'alaska',
                'arkansas',
                'california',
                'colorado',
                'connecticut',
                'delaware',
                'florida',
                'georgia',
                'hawaii',
                'idaho',
                'illinois',
                'indiana',
                'iowa',
                'kansas',
                'kentucky',
                'louisiana',
                'maine',
                'maryland',
                'massachusetts',
                'michigan',
                'minnesota',
                'mississippi',
                'missouri',
                'montana',
                'nebraska',
                'nevada',
                'ohio',
                'oklahoma',
                'oregon',
                'pennsylvania',
                'tennessee',
                'texas',
                'utah',
                'vermont',
                'virginia',
                'washington',
                'wisconsin',
                'wyoming',
                'superior',
                'michigan',
                'erie',
                'ontario',
                'huron'
)
#Categorys for the words used in game.
$categorybank = @(
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'occupation',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'animal',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'U.S. State',
            'Great Lake',
            'Great Lake',
            'Great Lake',
            'Great Lake',
            'Great Lake'  
)

$randnum = get-random -Minimum 0 -Maximum $wordbank.Count     #Random number generated from the amount of words in the wordbank.
$word = $wordbank[$randnum]                                   #The selected word for this iteration of the game.
$category = $categorybank[$randnum]                           #The corresponding category for the word picked.
$bword = $word.ToCharArray()                                  #The selected word with it's letters broken down into an array.

#The hangman images used in game.
#zero
$a = "    ___ `n   l   |`n       |`n       |`n       |`n       |`n       |`n ______|"

#one
$b = "    ___ `n   l   |`n   O   |`n       |`n       |`n       |`n       |`n ______|"

#two
$c = "    ___ `n   l   |`n   O   |`n   |   |`n   |   |`n       |`n       |`n ______|"

#three
$d = "    ___ `n   l   |`n   O   |`n  \|   |`n   |   |`n       |`n       |`n ______|"

#four
$e = "    ___ `n   l   |`n   O   |`n  \|/  |`n   |   |`n       |`n       |`n ______|"

#five
$f = "    ___ `n   l   |`n   O   |`n  \|/  |`n   |   |`n  /*   |`n       |`n ______|"

#six
$g = "    ___ `n   l   |`n   O   |`n  \|/  |`n   |   |`n  /*\  |`n       |`n ______|"

#endgame
$h = "   O   `n  \|/  `n   |   `n  /*\  "

$hangman = @($a,$b,$c,$d,$e,$f,$g,$h)                        #Array with all hangman images collected.
$hangmancounter = 0                                          #Variable that gets increased by one each time player is incorrect. Used to display corresponding hangman image.

$correctcount = 0                                            #Variable that keeps track of how many letters the user found. Used to end the game.
$wrongletters = @()                                          #The array that keeps track of incorrect letters to display to player.
$correctletters = @()                                        #The array that keeps track of correct letters so the user doesn't add them back into their guess.
$Guesscount = 6                                              #The incorrect guess count that goes down when the player makes an incorrect guess.
$numberofletters = $word.length                              #Variable that counts number of letters and displayed to user.

#How letter blanks are displayed for the user. 
$blankstring = @()                                           
$bscount = 0
do{                                                          #Do loop that adds a blank space to $blankstring array until the amount of blank spaces equal the selected word's character count.
    $blankstring += ' _ '
    $bscount++
}until($bscount -eq $bword.count)

#Introduction Screen
cls
"`n"
"HANGMAN"
"`n"
"Prisoner Kenny is about to be hanged. The sheriff will pardon Kenny `n
if you guess the letters to a random word. Why the sheriff would determine `n
a person's life based on guessing a few letters seems cruel and unusual, `n
but hey, that's Murica! If you can't guess all the correct letters, Kenny will be killed. "
"`n"
"Will you save him?"
"`n"
pause

#The game itself in a do-until loop. If the $hangmancounter variable reaches 6, the loop stops and ends the game.
do{
   #The game screen that is presented to the player. This do-until loop stops when the user enters a response (i.e. a letter) that fits the 'do-until' criteria. 
    do{
        cls
            "`n"
            "Wrong Guesses Left: $Guesscount"
            "`n"
            $hangman[$hangmancounter]
            "`n"
            $blankstring -join ''
            "`n"
            "Category: $category"
            "`n"
            "Number of Letters in Word: $numberofletters"
            "`n"
            "Wrong Letters: $wrongletters"
            "`n"
       $guess = read-host -Prompt "Guess a letter"
       $guess.Trim()                                        #Trim used in case the player places a space in their response.
    }until(
       $guess.length -eq 1 -and $guess -notcontains "" -and $wrongletters -notcontains $guess -and $correctletters -notcontains $guess) #The criteria for the user's answer to be accepted.

    #The player's guess is put in an if-then statement. If the word array (i.e. $bword) contains $guess, it goes through another if-then statement to determine if there is more than one
    #letter of the same letter in the word.
     if($bword -contains $guess){
         $posofletter = (0..($bword.count - 1)) | where {$bword[$_] -eq "$guess"}     #Variable used to determine where the player's guess is placed in the $blankstring array for the player to proceed in their progress of the game.
         if($posofletter.count -gt 1){
            foreach($i in $posofletter){                                              #Foreach loop that adds the same letter into the blanks of the word.
                $blankstring[$i] = " $guess "
                $correctcount++
                $correctletters += $guess
            }

         }else{
            #If there was only one letter of the type the player guessed.
            $correctcount++                                                          #One is added to the $correctcount variable
            $correctletters += $guess                                                #Correct letter is added to this array so it can't be guessed again.
            $blankstring[$posofletter] = " $guess "                                  #Player's guess is added to the blanks on screen.
         }
         
         #Screen that is shown when a letter is found.
         cls
         "`n"
         "Letter $guess was found!"
         "`n"
         
         #The endgame if the player finds all the letters. Each time a player correctly guesses a letter, $correctcount increases by one. If this equals the count of the amount of letters in the word,
         #the loop breaks and ends the game.
         if($correctcount -eq $word.length){
                    cls
                    "`n"
                    $hangman[7]
                    "`n"
                    "$word was the word! Kenny lives another day!"
                    "`n"
                    pause
                    Return 
         }
         pause

     }else{
        #Screen that is show if the letter is not found.
        cls
         "`n"
         "$guess was not found."
         "`n"
         $wrongletters += $guess                                                         #Letter is added to array for the player to see and can't be guessed again.
         $hangmancounter++                                                               #Hangman counter is increased by one to display the next image.
         $Guesscount -= 1                                                                #$Guesscount goes down by one to inform the player of how many wrong guesses they can make.
         pause
      }
}until($hangmancounter -eq 6)


#Game over screen if the player fails to find all the letters to word.
if($hangmancounter -eq 6){
    cls
    "`n"
    $hangman[6]
    "`n"
    "You killed Kenny!"
    "`n"
    "The word was $word."
    "`n"
    "Luckily Kenny isn't real.  Better luck next time."
    "`n"
    Pause
}