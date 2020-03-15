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




#Mandatory parameter needed to get the path of the file to hash.
param(
    [parameter(mandatory=$true)][string]$filepath
)

#Each variable pulls one type algorithm from the file provided.  
$md5hash = (Get-FileHash -Path $filepath -Algorithm MD5).hash
$sha1hash = (Get-FileHash -Path $filepath -Algorithm SHA1).hash
$sha256hash = (Get-FileHash -Path $filepath -Algorithm SHA256).hash

#The MD5, SHA1, and SHA256 hashes of the file provided are automatically placed in the user's clipboard
"MD5: $md5hash; SHA1: $sha1hash; SHA256: $sha256hash" | clip

#A pop-up window is brought up with three hashes from the file provided.
#Due to the limited size of the pop-up window, the SHA256 hash takes up two lines instead of the window auto-adjusting.  
$hashwindow = New-object -ComObject Wscript.shell
$hashtext = "Path: $filepath `n`nMD5: $md5hash `nSHA1: $sha1hash `nSHA256: $sha256hash `n`nHashes were placed in your clipboard."
$hashwindow.popup($hashtext,0,'Get Hashes',0x0)

