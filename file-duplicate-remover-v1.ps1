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





param(
    [string][parameter(mandatory=$true)]$filepath, #The directory path that is given by the user. This is used throughout the script.
    [switch]$recurse,                              #This is to use recurse on the path given in the previous parameter. 
    [switch]$full                                  #This is used to switch between one part of the script or the whole script.
    )



function get-yesnoquestion{                        #A basic function to get a yes or no response from the user. Mainly used to confirm the user wants to delete files.
    param(
        [string][parameter(mandatory=$true)]$question
    )

    $prompt = read-host -Prompt "$question (Y/N)"
    while('y','n' -notcontains $prompt){
        $prompt = read-host -Prompt "Answer must be a Y or N. $question"    
    }

    switch($prompt){
        'y'{$true}
        'n'{$false}
    }
}

function get-threewayquestion{                     #A function to get one of three responses from the user. Used when deciding to delete all files, select ones, or cancelling.
    $response = read-host -Prompt "Your answer"
    while(1,2,3 -notcontains $response){
        $response = read-host -Prompt "Invalid response. Must be a 1, 2, or 3. Your answer"
    }

    switch($response){
        1{1}
        2{2}
        3{3}
    }
}

function get-cancellationmessage{                 #A basic function to clear the screen when the user wants to cancel a deletion. Frees up some space in the script.
    param(
        [string][parameter(mandatory=$true)]$message
    )

    cls
    "`n"
    $message
    "`n"
    Pause
}

function get-duplicates{                         #The first function of the script that goes through the all files in the user's path and finds duplicates based on MD5, name, and newest creation date.
    param(
        [string][parameter(mandatory=$true)]$filepath,
        [switch]$recurse
    )

    $foundduplicates = @()
    #Blank array to store found duplicate fullnames.

    if($recurse){                                #If the user selects the recurse parameter when running the script.

        $searchedfiles = (gci -path $filepath -recurse | where {!$_.PSIsContainer} | sort -Property CreationTimeUtc -Descending).FullName
        #The fullnames of files found from the provided path ($searchedfiles) and also searches within folders within the given filepath. 
        #This does not include folders in the search array.

    }else{
        $searchedfiles = (gci -path $filepath | where {!$_.PSIsContainer} | sort -Property CreationTimeUtc -Descending).FullName
        #The fullnames of files found from the provided path ($searchedfiles) but not recursed. This also does not include folders in
        #the search array.
    }

    #The actual search for duplicates. It's basically nested foreach loops comparing all items from both $searchedfiles and
    #$searchedfilehashes to find duplicates.
    foreach($file in $searchedfiles){
        $baseMD5 = (Get-FileHash -Path $file -Algorithm MD5).hash
        #The MD5 file hash of $file.

        if($foundduplicates -notcontains $file){
        #This if-statement is to make sure that $file was not placed in $foundduplicates to waste time comparing it again to others.    
            
            foreach($fileagainst in $searchedfiles){
            #The items in this foreach loop ($fileagainst) get compared against $file and if $fileagainst is considered a duplicate
            #from here, $fileagainst and it's hash are added to $foundduplicates and $foundduplicateHashes.

                if($foundduplicates -notcontains $fileagainst){
                #This if-statement is to make sure that $fileagainst was not placed in $foundduplicates to waste time comparing it
                #again to others.        

                    $fileagainstMD5 = (Get-FileHash -Path $fileagainst -Algorithm MD5).hash
                    #The MD5 file hash of $fileagainst.

                    if($baseMD5 -eq $fileagainstMD5){
                    #This if-statement compares the $baseMD5 to $fileagainstMD5 to see if they are the same. If both hashes are not
                    #the same, the loop resets and $file changes to the next fullname in the $searchedfiles array. If the hashes are 
                    #the same, the current loop proceeds.

                        if($file -ne $fileagainst){
                        #This if-statement compares the fullnames of both $file and $fileagainst to make sure this isn't the same
                        #file path and name being compared.

                            $date1 = (gci -Path $file).CreationTimeUtc
                            $date2 = (gci -Path $fileagainst).CreationTimeUtc
                            if($date1 -lt $date2){
                            #This if-statement compares the CreationTime dates of both $file and $fileagainst. If $date1 ($file) is
                            #older than (less than) $date2 ($fileagainst), $fileagainst is added to $foundduplicates.
                            
                                $foundduplicates += $fileagainst
                            }
                        }
                    }
                }
           }
        }
    }
    $foundduplicates
}


function get-questionables{                  #The second part of the script if the user uses the full parameter. Finds any questionable matching hashes that have the same creation date & time.
    param(
        [string][parameter(mandatory=$true)]$filepath,
        [switch]$recurse
    )

    if($recurse){
        $searchedfiles = (gci -path $filepath -recurse | where {!$_.PSIsContainer} | sort -Property CreationTimeUtc -Descending).FullName
        #The fullnames of files found from the provided path ($searchedfiles). This also does not include folders in
        #the search array.

    }else{
        $searchedfiles = (gci -path $filepath | where {!$_.PSIsContainer} | sort -Property CreationTimeUtc -Descending).FullName
        #The fullnames of files found from the provided path ($searchedfiles) but not recursed. This also does not include folders in
        #the search array.
    }

    $questionablefiles = @()
    #Blank array to store found duplicate fullnames.

    foreach($file in $searchedfiles){
    #The actual search for duplicates. It's basically nested foreach loops comparing all items in $searchedfiles to find duplicates.

        $baseMD5 = (Get-FileHash -Path $file -Algorithm MD5).hash
        #The MD5 file hash of $file.

        foreach($fileagainst in $searchedfiles){
        #The items in this foreach loop ($fileagainst) get compared against $file and if $fileagainst is considered a duplicate
        #from here, $fileagainst and it's hash are added to $foundduplicates.

            $fileagainstMD5 = (Get-FileHash -Path $fileagainst -Algorithm MD5).hash
            #The MD5 file hash of $fileagainst.

                if($baseMD5 -eq $fileagainstMD5){
                #This if-statement compares the $baseMD5 to $fileagainstMD5 to see if they are the same. If both hashes are not
                #the same, the loop resets and $file changes to the next fullname in the $searchedfiles array. If the hashes are 
                #the same, the current loop proceeds.

                    if($file -ne $fileagainst){
                    #This if-statement compares the fullnames of both $file and $fileagainst to make sure this isn't the same
                    #file path and name being compared.

                        $date1 = (gci -Path $file).CreationTimeUtc
                        $date2 = (gci -Path $fileagainst).CreationTimeUtc
                        if($date1 -eq $date2){
                        #This if-statement compares the CreationTime dates of both $file and $fileagainst. If $date1 ($file) is
                        #the same as $date2 ($fileagainst), $fileagainst is added to $questionablefiles.
                            
                            $questionablefiles += $fileagainst
                        }
                    }
                 }
            }
        }
    $questionablefiles
}

function get-emptyfolders{      #Function for the third part of search that removes empty folders in the specified path.
    param(
        [string][parameter(mandatory=$true)]$filepath,
        [switch]$recurse
    )

    if($recurse){
        $grabfolders = (gci -Path $filepath -recurse | Where{$_.PSIsContainer}).FullName
        #The variable that grabs only the folders of the user's path, specifically the full file name.
    }else{
        $grabfolders = (gci -Path $filepath | Where{$_.PSIsContainer}).FullName
        #The variable that grabs only the folders of the user's path, specifically the full file name.
    }
    
    $emptyfolders = @()
    #An empty array to store the found empty folder paths.

    foreach($folder in $grabfolders){
        $size = (gci -path $folder -recurse | Measure-Object -Property Length -Sum).Sum
        #This variable takes each full name path found from $grabfolders, finds the size of the folder (in bytes) and returns only the size.
        
        if($size -lt 1){
        #If $size of $folder is less than 1 byte, $folder is considered empty and added to the $emptyfolders array.
            $emptyfolders += $folder
        }
    }
    $emptyfolders
}




#actual program


$formatteddate = get-date -Format yyMMdd-HHmmss                                                      #Date for the log name
$foundfileslogpath = "$env:USERPROFILE\Desktop\file-duplicate-remover-$formatteddate.txt"            #Path for the log name to be placed.
$confirmationquestion = "Confirmation. Are you sure you want to delete the file(s) found? This can't be undone."


#Testing the filepath given from the user
$testuserfilepath = test-path $filepath
switch($testuserfilepath){
#If the filepath given by the user is real, an initial search is started and log file is created on the user's desktop. If the filepath doesn't return anything,
#the script does not run or create any log file.
    $true{
        if($recurse){
            
            $foundfiles = get-duplicates -filepath $filepath -recurse

            new-item -ItemType File -Path $foundfileslogpath
            Add-Content -Path $foundfileslogpath -Value "File Duplicate Remover run on $formatteddate."
            Add-Content -Path $foundfileslogpath -Value ""

        }else{

            $foundfiles = get-duplicates -filepath $filepath

            new-item -ItemType File -Path $foundfileslogpath
            Add-Content -Path $foundfileslogpath -Value "File Duplicate Remover run on $formatteddate."
            Add-Content -Path $foundfileslogpath -Value ""
        }
    }
    $false{

        "`n"
        "ERROR: Filepath not found. Please check that you entered the path correctly."
        "`n"
        Return
    }
}

        
if($foundfiles -ge 1){
#First search, definite duplicates based on same hash but different creation dates.

    $duplicatescount = $foundfiles.count
    #Display for the end user.
    cls
    "`n"
    "Search 1: Found Duplicates"
    "`n"
    "These files found have the same MD5 hash and newer creation dates."
    "`n"
    "$duplicatescount duplicate(s) found."
    "`n"
    "The found duplicate(s) and hash(es):"
    $foundfiles
    "`n"
    
    #The same search from above is added to the created log file.    
    Add-Content -Path $foundfileslogpath -Value "Search 1"    
    Add-Content -Path $foundfileslogpath -Value "$duplicatescount duplicate(s) found."
    Add-Content -Path $foundfileslogpath -Value "The found duplicate(s):"            
    foreach($item in $foundfiles){
        Add-Content -Path $foundfileslogpath -Value "$item"
    }
    Add-Content -Path $foundfileslogpath -Value ""
        
    #The three way choice for the user to choose all files to delete, choose one or more files, or to cancel the deletion. 
    "A text file was created on your desktop with the duplicate files found under the path $foundfileslogpath."
    "`n"        
    "`n"
    "Select one of the following options:"
    "1. Select all files to delete"
    "2. Choose one or more files to delete"
    "3. Cancel deletion"
    "`n"

    $deletionquestion = get-threewayquestion
    switch($deletionquestion){
        1{ 
        #User deletes all files found in the first search        
            $deletionquestion = get-yesnoquestion -question $confirmationquestion
            switch($deletionquestion){
                $true{
                    cls
                    "`n"
                    foreach($file in $foundfiles){
                    #This foreach statement goes through all the stored duplicate files from $foundfiles and deletes them one by one. Afterwards it checks to see if it still exists.
                    #Whether it still exists or not is reflected in the console and in the log file.
                        Remove-Item -Path $file -Force
                        $check = test-path -Path $file
                        switch($check){
                            $true{
                                "Error with deleting $file."
                                "`n"
                                Add-content -Path $foundfileslogpath -Value "Error deleting $file"
                            }
                            $false{
                                "Deleted: $file"
                                "`n"
                                Add-content -Path $foundfileslogpath -Value "DELETED: $file"
                            }
                        }
                    }
                    Add-Content -Path $foundfileslogpath -Value ""    
                }
                $false{
                    get-cancellationmessage -message "Deletion cancelled for Search 1."
                    Pause
                }
            }

         }
        2{ #User selects what files they want to delete

            do{
            #This do-until loop adds all long file paths from $foundfiles and added to $displayfiles array. The $displayfiles array is placed in a for loop to display files for
            #the user to choose. The user selects what files they want deleted represented by the number next to each file. After the user selects what file they want deleted,
            #a new screen is shown to the user with the files they selected. If they choose to proceed with deletion or cancellation, the loop ends. If the user chooses to redo,
            #the loop resets.
                $displayfiles = @('filler')
                #The item 'filler' is added to the array so the number associated with file shown below matches with what file they actually selected in the array for deletion later.
                foreach($file in $foundfiles){
                    $displayfiles += $file
                }

                $selectedarray = @()

                cls
                "`n"
                "Duplicates found: "
                "`n"

                for($i=1; $i -lt ($displayfiles).count; $i++){
                    "$i. " + $displayfiles[$i]
                }
            
                "`n"
                "Enter the number corresponding to the file above. For multiple files, use a comma (,) to keep everything separate."
                $selectfiles = Read-host -Prompt "Your selection"
                $userselectedfiles = $selectfiles -split ","

                cls
                "`n"
                "Selected files: "
                "`n"
                foreach($x in $userselectedfiles){
                    $displayfiles[$x]
                    $selectedarray += $displayfiles[$x]
                }
            
                "`n"
                "Select one of the following options:"
                "1. Delete the selected files"
                "2. Choose files again"
                "3. Cancel"
                "`n"
                $choosefilesdeletionquestion = get-threewayquestion

            }until($choosefilesdeletionquestion -eq 1 -or $choosefilesdeletionquestion -eq 3)

            switch($choosefilesdeletionquestion){
                1{ #Deleting the user picked files
                    $deletionquestion = get-yesnoquestion -question $confirmationquestion
                    switch($deletionquestion){
                        $true{
                            foreach($x in $selectedarray){
                                remove-item -path $x -Force
                                $deletiontest = test-path -Path $x
                                switch($deletiontest){
                                    $true{
                                        "Error deleting file: $x"
                                        "`n"
                                        Add-content -Path $foundfileslogpath -Value "Error deleting $x"
                                        start-sleep -Milliseconds 500
                                    }
                                    $false{
                                        "DELETED: $x"
                                        "`n"
                                        Add-content -Path $foundfileslogpath -Value "DELETED: $x"
                                        Start-Sleep -Milliseconds 500      
                                    }
                                }
                             }
                             Add-Content -Path $foundfileslogpath -Value ""    
                        }
                        $false{
                            get-cancellationmessage -message "Deletion cancelled for Search 1."
                        }
                    }
                }
               3{ #Cancelling the deletion
                    get-cancellationmessage -message "Deletion cancelled for Search 1."
                }
            }

         }
        3{
            get-cancellationmessage -message "Deletion cancelled for Search 1."
         }
    }
}else{
    Add-Content -Path $foundfileslogpath -Value "Search 1: No duplicate files were found at filepath $filepath"    
    Add-Content -Path $foundfileslogpath -Value ""

    "`n"
    "First search found no duplicate files were found at filepath $filepath"
    "`n"
    start-sleep -Seconds 3
}

#If the script doesn't run the $full parameter (-full), the script will end here. Questionable file duplicates and empty folder deletion are not included. 

if($full){

    #Second Search for questionables. These files have the same MD5 but the creation dates are the same. Basically the second search with questionable matches is identical in code
    #structure.

    if($recurse){
        $dafoundquestionables = get-questionables -filepath $filepath -recurse
    }else{
        $dafoundquestionables = get-questionables -filepath $filepath
    }

    if($dafoundquestionables -ge 1){

        $questionablescount = ($dafoundquestionables).count
    
        cls
        "`n"
        "Search 2: Questionable Duplicates"
        "`n"
        "These files found have the same MD5 hash but have identical creation dates. It is up to the user to determine if these should be deleted."
        "`n"
        "$questionablescount duplicate(s) found."
        "`n"
        "The found duplicate(s) and hash(es):"
        $dafoundquestionables
        "`n"     

        Add-Content -Path $foundfileslogpath -Value "Search 2: Questionables"
        Add-Content -Path $foundfileslogpath -Value "$questionablescount questionables found."
        Add-Content -Path $foundfileslogpath -Value "The found questionable duplicate(s):"
        foreach($i in $dafoundquestionables){
            Add-Content -Path $foundfileslogpath -Value $i
        }
        Add-Content -Path $foundfileslogpath -Value ""

        "`n"
        "Select one of the following options:"
        "1. Select all files to delete"
        "2. Choose one or more files to delete"
        "3. Cancel deletion"
        "`n"

        $deletionquestion = get-threewayquestion
        switch($deletionquestion){
            1{ #user selects all files to be deleted
                $deletionquestion = get-yesnoquestion -question $confirmationquestion
                switch($deletionquestion){
                    $true{
                        foreach($file in $dafoundquestionables){
                            Remove-item -Path $file -Force
                            $deletiontest = test-path $file
                            switch($deletiontest){
                                $true{
                                    "Error deleting $file"
                                    "`n"
                                    Add-Content -Path $foundfileslogpath -Value "Error deleting $file"
                                    start-sleep -Milliseconds 500
                                }
                                $false{
                                    "DELETED: $file"
                                    "`n"
                                    Add-Content -Path $foundfileslogpath -Value "DELETED: $file"
                                    start-sleep -Milliseconds 500
                                }
                            }
                        }
                    }
                    $false{
                        get-cancellationmessage -message "Deletion cancelled for Search 1."
                    }
                }
            }
            2{  #user chooses what files they want to delete
                do{
                
                    $displayfiles = @('filler')
                    foreach($file in $dafoundquestionables){
                        $displayfiles += $file
                    }

                    $selectedarray = @()

                    cls
                    "`n"
                    "Duplicates found: "
                    "`n"

                    for($i=1; $i -lt ($displayfiles).count; $i++){
                        "$i. " + $displayfiles[$i]
                    }
            
                    "`n"
                    "Enter the number corresponding to the file above. For multiple files, use a comma (,) to keep everything separate."
                    $selectfiles = Read-host -Prompt "Your selection"

                    $userselectedfiles = $selectfiles -split ","
                
                    cls
                    "`n"
                    "Selected files: "
                    "`n"
                    foreach($x in $userselectedfiles){
                        $displayfiles[$x]
                        $selectedarray += $displayfiles[$x]
                    }
            
                    "`n"
                    "Select one of the following options:"
                    "1. Delete the selected files"
                    "2. Choose files again"
                    "3. Cancel"
                    "`n"
           
                    $choosefilesdeletionquestion = get-threewayquestion
                }until($choosefilesdeletionquestion -eq 1 -or $choosefilesdeletionquestion -eq 3)

                switch($choosefilesdeletionquestion){
                    1{
                        $deletionquestion = get-yesnoquestion -question $confirmationquestion
                        switch($deletionquestion){
                           $true{
                               foreach($x in $selectedarray){
                                  remove-item -path $x -Force
                                  $deletiontest = test-path -Path $x
                                  switch($deletiontest){
                                    $true{
                                        "`n"
                                        "Error deleting file: $x"
                                        Add-content -Path $foundfileslogpath -Value "Error deleting $x"
                                    }
                                    $false{
                                        "`n"
                                        "DELETED: $x"
                                        Add-content -Path $foundfileslogpath -Value "DELETED: $x"
                                    }
                                  }
                               }
                               Add-Content -Path $foundfileslogpath -Value ""
                           }
                           $false{
                                get-cancellationmessage -message "Deletion cancelled for Search 2."
                            }
                       }
                    }
                    3{
                        get-cancellationmessage -message "Deletion cancelled for Search 2."
                    }
                }
            }
            3{  #user cancels deletion.
                get-cancellationmessage -message "Deletion cancelled for Search 2."
            }
        }

    }else{
        Add-Content -Path $foundfileslogpath -Value "Search2: No questionable files found in the second search."
        Add-Content -Path $foundfileslogpath -Value ""
        "`n"
        "No questionable duplicate files were found at filepath $filepath"
        "`n"
        start-sleep -Seconds 3
    }

    #Third search for empty folders. Again, the same code structure from the first and second searches duplicated and placed here.
    
    if($recurse){
        $findemptyfolders = get-emptyfolders -filepath $filepath -recurse
    }else{
        $findemptyfolders = get-emptyfolders -filepath $filepath
    }

    if($findemptyfolders -ge 1){

        $foldercount = ($findemptyfolders).count

       cls
       "`n"
       "Search 3: Empty folders"
       "`n"
       "$foldercount empty folder(s) found."
       "`n"
       "The found duplicate(s) and hash(es):"
       $findemptyfolders
       "`n"

       Add-Content -Path $foundfileslogpath -Value "Search 3: Empty Folders"
       Add-Content -Path $foundfileslogpath -Value "$foldercount empty folder(s) found."
       Add-Content -Path $foundfileslogpath -Value "The found empty folder(s):"
       foreach($i in $findemptyfolders){
           Add-Content -Path $foundfileslogpath -Value $i
       }
       Add-Content -Path $foundfileslogpath -Value ""

       "`n"
        "Select one of the following options:"
        "1. Select all folders to delete"
        "2. Choose one or more folders to delete"
        "3. Cancel deletion"
        "`n"

        $deletionquestion = get-threewayquestion
        switch($deletionquestion){ 
            1{   #User decides to remove all empty folders
                $deletionquestion = get-yesnoquestion -question $confirmationquestion
                switch($deletionquestion){
                    $true{
                        foreach($i in $findemptyfolders){
                            remove-item -path $i -Force
                            $deletiontest = Test-Path $i
                            switch($deletiontest){
                                $true{
                                    "Error deleting folder: $i"
                                    "`n"
                                    Add-content -Path $foundfileslogpath -Value "Error deleting folder $i"
                                    start-sleep -Milliseconds 500
                                }
                                $false{
                                    "DELETED Folder: $i"
                                    "`n"
                                    Add-content -Path $foundfileslogpath -Value "DELETED Folder: $i"
                                    start-sleep -Milliseconds 500
                                }
                            }
                        }
                    }
                    $false{
                        get-cancellationmessage -message "Deletion cancelled for Search 3."
                    }
                }
            }
            2{  #user decides to select what folders they want to delete.
                do{
                
                    $displayfiles = @('filler')
                    foreach($folder in $findemptyfolders){
                        $displayfiles += $folder
                    }

                    $selectedarray = @()

                    cls
                    "`n"
                    "Folders found: "
                    "`n"

                    for($i=1; $i -lt ($displayfiles).count; $i++){
                        "$i. " + $displayfiles[$i]
                    }
            
                    "`n"
                    "Enter the number corresponding to the folder above. For multiple folders, use a comma (,) to keep everything separate."
                    $selectfiles = Read-host -Prompt "Your selection"

                    $userselectedfiles = $selectfiles -split ","
                
                    cls
                    "`n"
                    "Selected folders: "
                    "`n"
                    foreach($x in $userselectedfiles){
                        $displayfiles[$x]
                        $selectedarray += $displayfiles[$x]
                    }
            
                    "`n"
                    "Select one of the following options:"
                    "1. Delete the selected folders"
                    "2. Choose folders again"
                    "3. Cancel"
                    "`n"
           
                    $choosefilesdeletionquestion = get-threewayquestion
                }until($choosefilesdeletionquestion -eq 1 -or $choosefilesdeletionquestion -eq 3)

                switch($choosefilesdeletionquestion){
                    1{
                        $deletionquestion = get-yesnoquestion -question $confirmationquestion
                        switch($deletionquestion){
                            $true{
                                foreach($x in $selectedarray){
                                  remove-item -path $x -Force
                                  $deletiontest = test-path -Path $x
                                  switch($deletiontest){
                                    $true{
                                        "Error deleting folder: $x"
                                        "`n"
                                        Add-content -Path $foundfileslogpath -Value "Error deleting folder $x"
                                    }
                                    $false{
                                        "DELETED Folder: $x"
                                        "`n"
                                        Add-content -Path $foundfileslogpath -Value "DELETED Folder: $x"
                                    }
                                  }
                               }
                               Add-Content -Path $foundfileslogpath -Value ""
                            }
                            $false{
                                get-cancellationmessage -message "Deletion cancelled for Search 3."
                            }
                        }
                    }
                    3{
                        get-cancellationmessage -message "Deletion cancelled for Search 3."
                    }
                }

            }
            3{ #user cancels deletion of folders
               get-cancellationmessage -message "Deletion cancelled for Search 3."
            }
        }

    }else{
       Add-Content -Path $foundfileslogpath -Value "Search 3: No empty folders were found at filepath $filepath"
       Add-Content -Path $foundfileslogpath -Value ""
       "`n"
       "No empty folders were found at filepath $filepath"
       "`n"
       start-sleep -Seconds 3
    }
}
