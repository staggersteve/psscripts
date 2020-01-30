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



#Required parameter to point to the folder that needs reorganizing.
param(
    [parameter(mandatory=$true)][string]$path
)
#Variable for Error prompt when user gives a bad path or the given path has no files/folders to organize
$errorprompt = New-Object -ComObject wscript.shell

#To test that the user given path exists
$pathtest = test-path -path $path

if($pathtest -eq $true){
   
    #Test to see of there is at least one file/folder to sort. Archive folders have '-arc' in name to exclude it from archiving itself in another folder
    $nonarchivetest = (get-childitem -path $path -exclude "*-arc").length
    if($nonarchivetest -ge 1){
        do{
            
            #This part sorts the files/folders from oldest 'last write time' to newest, selects the first entry, and extracts the last write time into the $pull variable
            #The $month and $year variable extract the month and year and store them in their respective variable.
            #The $foldername variable takes the year and month of the file/folder and makes that the new folder name along with '-arc'on the end. Ex: 2015-01-arc 
            $pull = get-childitem -path $path -exclude "*-arc"| Sort-Object -Property LastWriteTime | Select-Object -First 1 -ExpandProperty LastWriteTime
            $month = $pull.ToString('MM')
            $year = $pull.ToString('yyyy')
            $foldername = "$path\$year-$month-arc"

            #The $testpath variable test to see if $foldername already exists within the user given path.
            #If the path exists, the file/folder that the $foldername is based on will be moved to the already existing folder.
            #If the path doesn't exist, a new folder will be created with the name from $foldername and the respective file/folder with that lastwritetime will be moved to the new folder.
            $testpath = Test-Path $foldername
            if($testpath -eq $true){
                get-childitem -path $path -exclude "*-arc"| where {$_.LastWriteTime.Month -eq $month -and $_.LastWriteTime.Year -eq $year} | move-item -Destination $foldername
            }else{
                $newfolder = new-item -ItemType Directory -Path "$foldername"
                get-childitem -path $path -exclude "*-arc"| where {$_.LastWriteTime.Month -eq $month -and $_.LastWriteTime.Year -eq $year} | move-item -Destination $newfolder
            }

            #This checks to see if there are still any files/folders that need to be organized without containing '-arc' in its name.
            #If the variable $check isn't the number zero, the do loop will repeat until there are no files/folder that aren't containing '-arc' in its name.
            $check = (Get-ChildItem -path $path -exclude "*-arc").Length
            $check
        }until($check -eq "0")

        #End prompt that pops up notifying the user that the organizing process is complete.
        $endprompt = New-Object -ComObject wscript.shell
        $endprompt.popup("Files were sorted under the path: $path.", 0, "Process Complete", 0x0)
    }else{
        #Prompt that comes up if the script is executed, tests that the path exists, but nothing without '-arc' appears.
        $noarcmessage = "There were no files or folders that had to be archived.  Archiving will not commence."
        $noarcheader = "No files to backup"
        $errorprompt.popup($noarcmessage,0,$noarcheader,0x40)
    }
    
}else{
    #Error prompt that appears if the path the user entered does not exist.
    $tpathmessage = "The folder path $path could not be found.  Please make sure that you typed the path in correctly."
    $tpathheader = "Test-Path Error"
    $errorprompt.popup($tpathmessage,0,$tpathheader,0x10)
}









