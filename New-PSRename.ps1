<#This is free and unencumbered software released into the public domain.

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
#>


function New-PSRename{
    <#
    .DESCRIPTION
        This commandlet bulk renames files in a given folder with a common name and adds an increasing number to the end of the filename. 
    .PARAMETER Path
        New-PSRename
        [-path] <String[]>
        [-commonfilename] <String[]>
        [-creationtimeascending]<switch>
        [-lastwritetimeascending]<switch>

    .EXAMPLE
        C:\PS> New-PSRename -path 'C:\Users\domo\Desktop\trip photos' -commonfilename 'Cancun Trip 090817'

        The example above runs the renaming function (New-PSRename,) along with the path to the folder of 
        files needing renaming (-path), and the name that will be used among all files in the user's given 
        folder (-commonfilename).

    .EXAMPLE
        C:\PS> New-PSRename -path 'C:\Users\domo\Desktop\trip photos' -commonfilename 'Cancun Trip 090817' -lastwritetimeascending

        The second example above runs the renaming function (New-PSRename), along with the path to the folder of files needing 
        renaming (-path), the name that will be used among all files in the user's given folder (-commonfilename), and to rename 
        the files based on ascending last write time (-lastwritetimeascending).

    .NOTES
        Author: Stephen Kofskie
        Date:   June 24, 2021    
    #>
    param(
        [string][parameter(mandatory=$true)]$path            <#The given path by the user where files will be renamed#> ,
        [string][parameter(mandatory=$true)]$commonfilename  <#The name that will be distributed to files needing renaming.#> ,
        [switch]$creationtimeascending                       <#If the user wants to sort the files in $path by the files' creation time UTC ascending.#> ,
        [switch]$lastwritetimeascending                      <#If the user wants to sort the files in $path by files' last write time UTC ascending.#>
        
    )

    $extensions = @('null')
    $finalselectedfiles = @('null')

    #Testing the user's inputted path exists
    $pathexists = Test-Path $path
    switch($pathexists){
        $true{
            $quickcounter = 0        #Counter for all files that get renamed.

            if($creationtimeascending){
                #The search for all files (not folders) in the user path given and placed in the $finalselectedfiles array. Sorted by Creation Time UTC Ascending.
                $quickfoundfilenames = (gci -path $path | ?{!$_.PSIsContainer} | sort -Property CreationTimeUtc).FullName
                foreach($i in $quickfoundfilenames){
                $finalselectedfiles += $i
                }
            }elseif($lastwritetimeascending){
                #The search for all files (not folders) in the user path given and placed in the $finalselectedfiles array. Sorted by Last Write Time UTC Ascending.
                $quickfoundfilenames = (gci -path $path | ?{!$_.PSIsContainer} | sort -Property LastWriteTimeUtc).FullName
                foreach($i in $quickfoundfilenames){
                $finalselectedfiles += $i
                }
            }else{
                #The search for all files (not folders) in the user path given and placed in the $finalselectedfiles array.
                $quickfoundfilenames = (gci -path $path | ?{!$_.PSIsContainer}).FullName
                foreach($i in $quickfoundfilenames){
                    $finalselectedfiles += $i
                }
            }

            #The search for the extensions for all files found in the user path given and placed in $extensions array. Used for renaming files.
            for($i=1; $i -lt ($finalselectedfiles).Length; $i++){
                $quickfoundextensions = (get-item -path $finalselectedfiles[$i]).Extension
                $extensions += $quickfoundextensions
            }

            #Process of renaming user's selected files.
            for($i=1; $i -lt ($finalselectedfiles).length; $i++){
                [string]$string = "$commonfilename-$i" + $extensions[$i]
                Rename-Item -Path $finalselectedfiles[$i] -NewName $string
                $quickcounter++
            }

            Write-host "`n"
            Write-host "$quickcounter file(s) renamed with the common name: $commonfilename"
            Write-host "`n"
        }
        $false{
            Write-host "`n"
            Write-host "Error: The entered path does not exist. Please check that you typed in the correct pathway."
            Write-host "`n"
        }
    }
}