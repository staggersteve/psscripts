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

#Setup functions to create the hashes of a file.
param(
    [parameter(mandatory=$true)] $filepath
)

function get-md5{
    param([parameter(mandatory=$true)]$filepath)
    (Get-FileHash -Path $filepath -Algorithm MD5).hash
}

function get-sha1{
    param([parameter(mandatory=$true)]$filepath)
    (Get-FileHash -Path $filepath -Algorithm SHA1).hash
}

function get-sha256{
    param([parameter(mandatory=$true)]$filepath)
    (Get-FileHash -Path $filepath -Algorithm SHA256).hash
}

#Variables using the functions above to generate the hashes of the requested file and used to place hash in user's clipboard.
$md5 = get-md5 -filepath $filepath
$sha1 = get-sha1 -filepath $filepath
$sha256 = get-sha256 -filepath $filepath


#Assemblies to load when the script is executed.
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")  
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[void] [System.Windows.Forms.Application]::EnableVisualStyles() 

#The window itself that is displayed to the user.
$Form = New-Object system.Windows.Forms.Form 
$Form.Size = New-Object System.Drawing.Size(690,260)
$form.MaximizeBox = $false 
$form.AutoSize = $false
$Form.StartPosition = "CenterScreen" 
$Form.FormBorderStyle = 'Fixed3D'
$Font = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Bold)
$form.Font = $Font 
$Form.Text = "Get Hashes..."

#The first label used to display the filepath of the file being hashed.
$Label1 = New-Object System.Windows.Forms.Label
$Label1.Text = "Filepath: $filepath"
$Label1.AutoSize = $false
$Label1.Size = New-object System.Drawing.Size(600,50)
$Label1.Location = New-Object System.Drawing.Size(15,10)
$Form.Controls.Add($Label1)

#The second label used to display all three hashes to the user.
$Label2 = New-Object System.Windows.Forms.Label 
$Label2.Text = "MD5: $md5 `nSHA1: $sha1 `nSHA256: $sha256 `n`nSelect a button to copy this file's hashes." 
$Label2.AutoSize = $true
$Label2.Location = New-Object System.Drawing.Size(15,80)
$Form.Controls.Add($Label2)

#The 'Copy MD5' button. Copies MD5 hash to user's clipboard.
$md5button = New-Object System.Windows.Forms.Button 
$md5button.Location = New-Object System.Drawing.Size(15,175) 
$md5button.Size = New-Object System.Drawing.Size(125,30) 
$md5button.Text = "Copy MD5" 
$md5button.Add_Click({
        $md5 | clip
}) 
$Form.Controls.Add($md5button)

#The 'Copy SHA1' button. Copies SHA1 hash to user's clipboard.
$sha1button = New-Object System.Windows.Forms.Button 
$sha1button.Location = New-Object System.Drawing.Size(145,175) 
$sha1button.Size = New-Object System.Drawing.Size(125,30) 
$sha1button.Text = "Copy SHA1" 
$sha1button.Add_Click({
        $sha1 | clip
}) 
$Form.Controls.Add($sha1button)

#The 'Copy SHA256' button. Copies SHA256 hash to user's clipboard.
$sha256button = New-Object System.Windows.Forms.Button 
$sha256button.Location = New-Object System.Drawing.Size(275,175) 
$sha256button.Size = New-Object System.Drawing.Size(125,30) 
$sha256button.Text = "Copy SHA256" 
$sha256button.Add_Click({
        $sha256 | clip
}) 
$Form.Controls.Add($sha256button)

#The 'Copy All' button. Copies all three hashes to user's clipboard.
$all3button = New-Object System.Windows.Forms.Button 
$all3button.Location = New-Object System.Drawing.Size(405,175) 
$all3button.Size = New-Object System.Drawing.Size(125,30) 
$all3button.Text = "Copy All" 
$all3button.Add_Click({
        "$md5; $sha1; $sha256" | clip
}) 
$Form.Controls.Add($all3button)

#The 'Close' button. Closes the window.
$closebutton = New-Object System.Windows.Forms.Button 
$closebutton.Location = New-Object System.Drawing.Size(535,175) 
$closebutton.Size = New-Object System.Drawing.Size(125,30) 
$closebutton.Text = "Close" 
$closebutton.Add_Click({
        $Form.Close()
}) 
$Form.Controls.Add($closebutton)

#To display the form with all labels and buttons.
$Form.ShowDialog()
