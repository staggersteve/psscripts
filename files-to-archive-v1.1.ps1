<#
Files-to-archive v1.1

DESCRIPTION:
This is an updated version of the script I uploaded to GitHub on January 29, 2020. A flaw was found where the script would be caught in a loop if 
there was an identically named file found within an archived folder. The script was re-written to be able to sort files to be archived depending 
upon:
   -How may files to be sorted (one / more than one)
   -How to deal with matching names (rename / delete / move nothing)
   -Optionally deal with matching hashed files to be sorted (delete / move nothing)

The purpose of the script is to sort files within a given path based on a file's 'Date Modified' date. The file's year & month from the 'Date 
Modified' date are extracted, a folder is created (archive folder) & named with those two pieces of info (ex: a file's date modified date is 
8/17/2012, a new folder is created called 2012-8-arc), and the file is moved into the new folder. No folders within the user's given folder path 
are sorted into newly created folders, just files. If an archived folder was previously made, the script checks to see if the there is an 
identical file within this folder compared to the files that are to be sorted at the top level of the user's given folder path. Files can 
be compared by name and/or hash. From the parameters, the user can choose to delete/rename matching files or delete matching hashed files. 
Choosing none of the optional parameters in regards to duplicate files will not move any files within the user's given folder path but will also 
create an error log on the user's desktop to alert them of the error. At the end of the script, an end log is created in the user's documents 
folder noting any files having been renamed or deleted. 

PARAMETERS:
   -folderpath: Folder path, the folder the user wants sorted into sub-folders.
   -DeleteDuplicateHashFiles: Delete Duplicate Hash Files, used to delete found duplicate hash files from the top level of the folder from the 
   parameter 'folderpath' (does NOT delete the matching hashed file in the found destination folder).
   -DeleteDuplicateNamedFiles: Delete Duplicate Hash Files, used to delete found duplicate named files from the top level of the folder from the 
   parameter 'folderpath' (does NOT delete the matching named file in the found destination folder). This parameter cannot be used in conjunction 
   with the 'RenameDuplicateNamedFiles' parameter in a command.
   -RenameDuplicateNamedFiles: Rename Duplicate Named Files, used to rename found duplicate named files from the top level of the folder from the 
   parameter 'folderpath' (does NOT rename the matching named file in the found destination folder). This parameter cannot be used in conjunction 
   with the 'DeleteDuplicateNamedFiles' parameter in a command.
   -NoEndLog: No End Log, used if the user does not want a summary log placed in the users' documents folder.

EXAMPLE:

C:\PS\files-to-archive-v1.1 -folderpath 'C:\Users\Steve\Pictures\Family Photos 2021' -RenameDuplicateNamedFiles -NoEndLog

This command line example points the script to a folder path in the user's Pictures folder and uses two parameters to rename any duplicate named 
files found and to not create an end log in the user's documents folder.

NOTES:
   -Currently the script doesn't check for identical hash files within the files to be sorted from the user's given folder path. 
   -Some errors may run during the script if you are viewing the command being run in a window.
   -Using the 'DeleteDuplicateHashFiles' parameter will be a slow process for files other than text and pictures. 

Written by Stephen Kofskie, https://www.kofskie.com
#>
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
#>


param(
    [parameter(Mandatory=$true)][string]$folderpath,  #The user's folder that they want sorted
    [switch]$DeleteDuplicateHashFiles,                #Parameter switch to delete duplicate hash files in user's folder
    [switch]$DeleteDuplicateNamedFiles,               #Parameter switch to delete duplicate named files in user's folder
    [switch]$RenameDuplicateNamedFiles,               #Parameter switch to rename duplicate named files in user's folder
    [switch]$NoEndLog                                 #Parameter switch to not create an endlog with what was possibly deleted or renamed
)

function New-EndLog{
    <#
        Function for end log to appear or append (depending on if the user ran the script before) with any deleted hash files or renamed files. 
        Also for errors in case the folder path the user entered wasn't found or both parameters 'RenameDuplicateNamedFiles' and
        'DeleteDuplicateNamedFiles' were used in a command.
    #>
    param(
        [parameter(Mandatory=$true)][string]$folderpath,   #The user's folder that they want sorted
        [array]$MatchedFileNameInUserFolder,               #As the name says, stores matched file names in user folder to be matched
        [array]$MatchedFileNameInFoundFolder,              #As the name says, stores matched file names in found archive folder
        [array]$MatchedHashInUserFolder,                   #As the name says, stores matching hash files in user folder
        [array]$MatchedHashesInFoundFolder,
        [switch]$RenameDuplicateNamedFiles,                #Switch used to add additional information to log file
        [switch]$DeleteDuplicateNamedFiles,                #Switch used to add additional information to log file
        [switch]$DeleteDuplicateHashFiles,                 #Switch used to add additional information to log file
        [switch]$noFilesFound,                             #No files found to sort
        [switch]$ErrorLog,                                 #Switch to add error message to log file
        [int]$ErrorLevel                                   #Switch to determine which error message to add to log file
    )

    $EndLogPath = "$env:USERPROFILE\Documents\Files-to-archive-log.txt"         #Location of the log file
    $dateFormatted = get-date -Format yyMMdd-HHmmss                             #Date for log file

    $DoesLogExist = test-path -Path $EndLogPath                                 #Test path and if statement in case the log file wasn't created before.
    if($DoesLogExist -eq $false){
        New-item -ItemType File -Path $EndLogPath
    }

    #Beginning of log
    Add-Content -Path $EndLogPath -Value ""
    Add-Content -Path $EndLogPath -Value "Files-To-Archive Script Finished $dateFormatted."
    Add-Content -Path $EndLogPath -Value ""
    Add-Content -Path $EndLogPath -Value "Folder path to sort: $folderpath"
    Add-Content -Path $EndLogPath -Value ""

    if($ErrorLog){                  #If ErrorLog switch was used to add error message to log
        switch($ErrorLevel){
            1{
                Add-Content -Path $EndLogPath -Value "Cause of Failure: Folder path given was not found."
                Add-Content -Path $EndLogPath -Value "Double check the spelling for the path of the given folder and run the task again."
            }
            4{
                Add-Content -Path $EndLogPath -Value "Cause of Failure: Both Parameters DeleteDuplicateNamedFiles and RenameDuplicateNamedFiles were both entered in the command line."
                Add-Content -Path $EndLogPath -Value "Please use only one of those parameters for handling duplicate named files."
            }
        } 
    }else{  #Specific lines to add to log file if ErrorLog parameter wasn't used.
        if($DeleteDuplicateNamedFiles){
            Add-Content -Path $EndLogPath -Value "The parameter 'DeleteDuplicateNamedFiles' was used in the script."
            Add-Content -Path $EndLogPath -Value "The files below were deleted."
        }elseif($RenameDuplicateNamedFiles){
            Add-Content -Path $EndLogPath -Value "The parameter 'RenameDuplicateNamedFiles' was used in the script."
            Add-Content -Path $EndLogPath -Value "The files below were renamed closely their matched file."
        }
    
        Add-Content -Path $EndLogPath -Value "Files found with matching names in User requested folder:"
        foreach($i in $MatchedFileNameInUserFolder){
            Add-Content -Path $EndLogPath -Value "$i"
        }
        
        if($noFilesFound){
            Add-Content -Path $EndLogPath -Value ""
            Add-Content -Path $EndLogPath -Value "No files were found to sort in the given path. If this was an error, make sure you entered the correct folder path."
        }else{
            Add-Content -Path $EndLogPath -Value ""
            Add-Content -Path $EndLogPath -Value "Files found with matching names in Found Archive Folder:"
            foreach($i in $MatchedFileNameInFoundFolder){
                Add-Content -Path $EndLogPath -Value "$i"
            }
        }
    
        if($DeleteDuplicateHashFiles){
            Add-Content -Path $EndLogPath -Value ""
            Add-Content -Path $EndLogPath -Value "The parameter 'DeleteDuplicateHashFiles' was used in the script. The files below were deleted:"
            foreach($x in $MatchedHashInUserFolder){
                Add-Content -Path $EndLogPath -Value "$x"
            }
            Add-Content -Path $EndLogPath -Value ""
            Add-Content -Path $EndLogPath -Value "Files found with matching hashes in Found Archive Folder:"
            foreach($x in $MatchedHashesInFoundFolder){
                Add-Content -Path $EndLogPath -Value "$x"
            }
        }
    }

    Add-Content -Path $EndLogPath -Value ""
    Add-Content -Path $EndLogPath -Value "------------------------------------------------------------"
}

function New-FindAndDeleteHashFiles{
    <#
    Function used to either find identical hashes or to delete them. Find prameter used for log file when listing matching file hashes
    against files to be sorted.
    #>
    param(
        [parameter(Mandatory=$true)]$folderpath,
        [switch]$Find,
        [switch]$Delete
    )

    $MatchedHash = @()

    [array]$filesWithinUserPath = (Get-ChildItem -path $folderpath | Where-Object{!$_.PSIsContainer} | Sort-Object -Property CreationTimeUtc).FullName

    foreach($file in $filesWithinUserPath){
        $fileMonth = (Get-Item -Path $file).LastWriteTimeUtc.Month          #The file's last write time month
        $fileYear = (Get-Item -Path $file).LastWriteTimeUtc.Year            #The file's last write time year
        $foldername = "$fileYear-$fileMonth-arc"                            #The naming structure to call the folder
        $archiveFolderpath = "$folderpath\$foldername"                      #The pathway to the new folder
        
        $testArchiveFolderPath = Test-Path -Path $archiveFolderpath         #Test to see if the archived folder already exists
        if($testArchiveFolderPath -eq $true){                               #If the archive folder already exists
                   
            $grabExisitingFilesInFolder = (Get-ChildItem -Path $archiveFolderpath | Where-Object{!$_.PSIsContainer}).FullName
            #Grabbing all the files by full path within the found archive folder
            
            $currentFileHash = (Get-FileHash -Path $file -Algorithm MD5).Hash
            foreach($FileOnDeck in $grabExisitingFilesInFolder){
                $HashOnDeck = (Get-FileHash -Path $FileOnDeck -Algorithm MD5).Hash
                if($HashOnDeck -eq $currentFileHash){                   #If the hash of the file within the found archive folder matches the hash of a file to be sorted
                    if($Find){
                        $MatchedHash += $FileOnDeck
                    }elseif($Delete){
                        $MatchedHash += $file                   #File is added to array list placed in end log
                        Remove-item -path $file -Force
                    }
                }
            }
        }
    }
    if($MatchedHash.Count -ge 1){
        $MatchedHash
    }
}


$MatchedFileNameInUserFolder = @()                    #File paths found with the same name at the base of the user folder.
$MatchedFileNameInFoundFolder = @()                   #File paths found with identical names within archive folders in the user folder.

if($DeleteDuplicateNamedFiles){             #Check to make sure the user didn't select both parameters to delete duplicate files and to rename duplicate files
    if($RenameDuplicateNamedFiles){
        if(!$NoEndLog){New-EndLog -folderpath $folderpath -ErrorLog -ErrorLevel 4; break}
    }
}

######Start######
$testUserpath = Test-Path -Path $folderpath     #Check to see if the user's folder path exists before continuing 
if($testUserpath -eq $True){

    if($DeleteDuplicateHashFiles){              #Finding identical hashes first to get out of the way for normal sorting
        $filesWithinUserPathForDeleteHashes = (Get-ChildItem -path $folderpath | Where-Object{!$_.PSIsContainer} | Sort-Object -Property CreationTimeUtc).FullName
        if($filesWithinUserPathForDeleteHashes -ge 1){
            $MatchedHashesInFoundFolder = New-FindAndDeleteHashFiles -folderpath $folderpath -Find
            $MatchedHashInUserFolder = New-FindAndDeleteHashFiles -folderpath $folderpath -Delete
        }
    }

    $filesWithinUserPath = (Get-ChildItem -path $folderpath | Where-Object{!$_.PSIsContainer} | Sort-Object -Property CreationTimeUtc).FullName
    #The variable that stores the full paths of all items in the user's requested folder path
    if($filesWithinUserPath.Count -ge 1){       #If statement checking if there are loose files within the user's requested folder

        if($filesWithinUserPath.Count -eq 1){   ########## If there is ONLY one file in the user's requested path ################

            #Creating the folder that will store the lone file in the user's requested path
            $fileMonth = (Get-Item -Path $filesWithinUserPath).LastWriteTimeUtc.Month      #The file's last write time month
            $fileYear = (Get-Item -Path $filesWithinUserPath).LastWriteTimeUtc.Year        #The file's last write time year
            $foldername = "$fileYear-$fileMonth-arc"                                   #The naming structure to call the folder
            $archiveFolderpath = "$folderpath\$foldername"                             #The pathway to the new folder

            $testArchiveFolderPath = Test-Path -Path $archiveFolderpath                #Test to see if the archived folder already exists
            if($testArchiveFolderPath -eq $true){                                      #If the folder already exists
                
                $grabExisitingNamesInFolder = (Get-ChildItem -Path $archiveFolderpath | Where-Object{!$_.PSIsContainer}).FullName
                    #Grabs all files with their full paths in the found archive folder
                $filesWithinUserPathName = (Get-Item -path $filesWithinUserPath).Name
                    #Grabs the file names only of all files in the found archive folder
                foreach($x in $grabExisitingNamesInFolder){   #foreach loop that compares file names from the found archived folder againsted file needing sorting
                    
                    $FileNameOnDeck = (Get-Item -Path $x).Name
                    if($FileNameOnDeck -eq $filesWithinUserPathName){
                        $MatchedFileNameInUserFolder += $filesWithinUserPath     #Full filepaths used here only for logs and for renaming/deletion
                        $MatchedFileNameInFoundFolder += $x                      #Full filepaths used here only for logs

                        if($RenameDuplicateNamedFiles){     #If parameter selected, sorted file will be renamed and moved into found archived folder
                            
                            $AddToEndOfFileName = 1                                     #Number added at the end of a file to differentiate it from matching name
                            do{
                                foreach($file in $MatchedFileNameInUserFolder){
                                    $CurrentName = (get-item -Path $file).Name          #Current name of file to be sorted
                                    $fileExtension = (Get-Item -path $file).Extension   #The file extension of file to be sorted
                                    $Trim = $CurrentName.TrimEnd("$fileExtension")      #Removing the extension off the name

                                    $newname = "$Trim-$AddToEndOfFileName"              #The new name of the file to be sorted
                                    $newNameAndExt = "$newname$fileExtension"           #The new name and its original extension
                                    $JustPath = $file.TrimEnd($CurrentName)             #The pathway to where the sorted file currently is placed
                                    $newerName = "$JustPath$newname$fileExtension"      #The new file name of the file to be sorted, including the full path

                                    $fileMonth = (Get-Item -Path $file).LastWriteTimeUtc.Month      #The file's last write time month
                                    $fileYear = (Get-Item -Path $file).LastWriteTimeUtc.Year        #The file's last write time year
                                    $foldername = "$fileYear-$fileMonth-arc"                        #The naming structure to call the folder
                                    $archiveFolderpath = "$folderpath\$foldername"                  #The pathway to the new folder
                                    $grabExisitingNamesInFolder = (Get-ChildItem -Path $archiveFolderpath | Where-Object{!$_.PSIsContainer}).Name
                                        #Grabbing file names within found archived folder path to match against newly renamed file to sort

                                    $MatchingNameFlag = $grabExisitingNamesInFolder -contains $newNameAndExt
                                    if($MatchingNameflag -eq $true){            
                                        #If there is already a file named as the newly renamed file, the number to include at the end of the name increases and the do loop repeats.
                                        $AddToEndOfFileName++
                                    }
                                }
                            }until($MatchingNameFlag -eq $false)
                            #Renaming and moving file to archive folder
                            Rename-Item -Path $file -NewName $newNameAndExt -ErrorAction SilentlyContinue
                            Move-Item -Path $newerName -Destination $archiveFolderpath -ErrorAction SilentlyContinue

                        }elseif($DeleteDuplicateNamedFiles){     #If parameter selected, sorted file will be deleted
                            foreach($i in $MatchedFileNameInUserFolder){
                                Remove-Item -Path $i -Force
                            }
                        }
                    }else{
                        Move-item -Path $filesWithinUserPath -Destination $archiveFolderpath -ErrorAction SilentlyContinue
                    }
                }
            }else{   #If the archive folder does not exist.
                New-Item -ItemType Directory -Path $archiveFolderpath -ErrorAction SilentlyContinue
                Move-item -Path $filesWithinUserPath -Destination $archiveFolderpath -ErrorAction SilentlyContinue
            }
        }else{                   ########### If there is more than one file in the user's requested path ###########
            foreach($file in $filesWithinUserPath){
                $fileMonth = (Get-Item -Path $file).LastWriteTimeUtc.Month          #The file's last write time month
                $fileYear = (Get-Item -Path $file).LastWriteTimeUtc.Year            #The file's last write time year
                $foldername = "$fileYear-$fileMonth-arc"                            #The naming structure to call the folder
                $archiveFolderpath = "$folderpath\$foldername"                      #The pathway to the new folder
                
                $testArchiveFolderPath = Test-Path -Path $archiveFolderpath         #Test to see if the archived folder already exists
                $filesWithinUserPathName = (Get-Item -path $file).Name              #Grabbing the current file name in array $filesWithinUserPath

                if($testArchiveFolderPath -eq $true){                               #If the archive folder already exists
                   
                    $grabExisitingFilesInFolder = (Get-ChildItem -Path $archiveFolderpath | Where-Object{!$_.PSIsContainer}).FullName
                    #Grabbing all the files by full path within the found archive folder
                              
                    foreach($i in $grabExisitingFilesInFolder){                     #Process of matching names of files within found archive folder against files to be sorted
                        $NameOnDeck = (Get-Item -Path $i).Name
                        if($NameOnDeck -eq $filesWithinUserPathName){               #If the name of a file from the found archived folder matches a filename from the files to be sorted
                            $MatchedFileNameInUserFolder += $file                   #File added to array to be placed in end log
                            $MatchedFileNameInFoundFolder += $i                     #File added to array to be placed in end log

                            if($RenameDuplicateNamedFiles){                         #If $RenameDuplicateNamedFiles parameter was selected

                                foreach($file in $MatchedFileNameInUserFolder){
                                    $AddToEndOfFileName = 1                                                                 #Number added to the end of a file to differentiate it from matching name
                                    do{
                                        $CurrentName = (get-item -Path $file -ErrorAction SilentlyContinue).Name            #Current name of file to be sorted
                                        $fileExtension = (Get-Item -path $file -ErrorAction SilentlyContinue).Extension     #The file extension of file to be sorted
                                        $Trim = $CurrentName.TrimEnd("$fileExtension")                                      #Removing the extension off the name

                                        $newname = "$Trim-$AddToEndOfFileName"                                              #The new name of the file to be sorted
                                        $newNameAndExt = "$newname$fileExtension"                                           #The new name and it's original extension
                                        $JustPath = $file.TrimEnd($CurrentName)                                             #The pathway to where the sorted file currently is placed
                                        $newerName = "$JustPath$newname$fileExtension"                                      #The new file name of the file to be sorted, including the full path

                                        $fileMonth = (Get-Item -Path $file -ErrorAction SilentlyContinue).LastWriteTimeUtc.Month      #The file's last write time month
                                        $fileYear = (Get-Item -Path $file -ErrorAction SilentlyContinue).LastWriteTimeUtc.Year        #The file's last write time year
                                        $foldername = "$fileYear-$fileMonth-arc"                                                      #The naming structure to call the folder
                                        $archiveFolderpath = "$folderpath\$foldername"                                                #The pathway to the new folder
                                        $grabExisitingNamesInFolder = (Get-ChildItem -Path $archiveFolderpath | Where-Object{!$_.PSIsContainer} -ErrorAction SilentlyContinue).Name
                                            #Grabbing file names within found archived folder path to match against newly renamed file to sort

                                        $Flag = $grabExisitingNamesInFolder -contains $newNameAndExt
                                        if($flag -eq $true){
                                            #If there is already a file name as the newly renamed file, the number to include at the end of the name increases and the do loop repeats.
                                            $AddToEndOfFileName++
                                        }
                                    }until($flag -eq $false)
                                    #Renaming and moving file to archive folder
                                    Rename-Item -Path $file -NewName $newNameAndExt -ErrorAction SilentlyContinue
                                    Move-Item -Path $newerName -Destination $archiveFolderpath -ErrorAction SilentlyContinue
                                }

                            }elseif($DeleteDuplicateNamedFiles){        #If parameter selected, sorted file will be deleted
                                Foreach($i in $MatchedFileNameInUserFolder){
                                    Remove-Item -Path $i -Force -ErrorAction SilentlyContinue
                                }
                            }
                        }else{
                            Move-item -Path $file -Destination $archiveFolderpath -ErrorAction SilentlyContinue
                        }
                    }
                }else{
                    New-Item -ItemType Directory -Path $archiveFolderpath -ErrorAction SilentlyContinue
                    Move-item -Path $file -Destination $archiveFolderpath -ErrorAction SilentlyContinue
                }
            }
        }
        #Add endlog to user's documents folder
        if(!$NoEndLog){ #If the user added the parameter to not create/add-to a log file, the script stops here
            If($DeleteDuplicateNamedFiles){     #Process of generating an end log depending on what parameters the user entered
                if($DeleteDuplicateHashFiles){
                    New-EndLog -folderpath $folderpath -MatchedFileNameInUserFolder $MatchedFileNameInUserFolder -MatchedFileNameInFoundFolder $MatchedFileNameInFoundFolder -MatchedHashInUserFolder $MatchedHashInUserFolder -MatchedHashesInFoundFolder $MatchedHashesInFoundFolder -DeleteDuplicateNamedFiles -DeleteDuplicateHashFiles
                }else{
                    New-EndLog -folderpath $folderpath -MatchedFileNameInUserFolder $MatchedFileNameInUserFolder -MatchedFileNameInFoundFolder $MatchedFileNameInFoundFolder -MatchedHashInUserFolder $MatchedHashInUserFolder -DeleteDuplicateNamedFiles
                }
            }elseif($RenameDuplicateNamedFiles){
                if($DeleteDuplicateHashFiles){
                    New-EndLog -folderpath $folderpath -MatchedFileNameInUserFolder $MatchedFileNameInUserFolder -MatchedFileNameInFoundFolder $MatchedFileNameInFoundFolder -MatchedHashInUserFolder $MatchedHashInUserFolder -MatchedHashesInFoundFolder $MatchedHashesInFoundFolder -RenameDuplicateNamedFiles -DeleteDuplicateHashFiles
                }else{
                    New-EndLog -folderpath $folderpath -MatchedFileNameInUserFolder $MatchedFileNameInUserFolder -MatchedFileNameInFoundFolder $MatchedFileNameInFoundFolder -MatchedHashInUserFolder $MatchedHashInUserFolder -RenameDuplicateNamedFiles
                }
            }else{
                New-EndLog -folderpath $folderpath -MatchedFileNameInUserFolder $MatchedFileNameInUserFolder -MatchedFileNameInFoundFolder $MatchedFileNameInFoundFolder -MatchedHashInUserFolder $MatchedHashInUserFolder
            }
        }
    }else{
        if(!$NoEndLog){New-Endlog -folderpath $folderpath -DeleteDuplicateHashFiles -MatchedHashInUserFolder $MatchedHashInUserFolder -MatchedHashesInFoundFolder $MatchedHashesInFoundFolder -noFilesFound}
    }
}else{
    if(!$NoEndLog){New-EndLog -folderpath $folderpath -ErrorLog -ErrorLevel 1; break}
}