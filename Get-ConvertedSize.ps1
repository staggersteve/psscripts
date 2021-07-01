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

function Get-ConvertedSize{
    <#
    .DESCRIPTION
        This commandlet converts the sizes of both files and folders from bytes into something readable. 
    .PARAMETER Path
        Get-ConvertedSize
        [-path] <String[]>
    .EXAMPLE
        C:\PS> Get-ConvertedSize -Path C:\Users\Betsy\Desktop\SpecialFolder

        In the example above, the user runs the conversion commandlet on a folder called 'SpecialFolder' on their desktop.
        This would return the size for the folder the user requested.
    .EXAMPLE
        C:\PS> Get-Item -path 'C:\Users\Betsy\Videos\family reunion 2003.mp4' | Get-ConvertedSize

        In the second example above, the user ran the get-item command to get information on a video file in their Videos folder.
        The output from that last command are then piped into the Get-ConvertedSize commandlet for a readable size of the video file. 
    .NOTES
        Author: Steve Kofskie
        Date:   June 24, 2021
    #>
    param(
        [parameter(ValueFromPipeLine)]$Path <#This variable supports both input from the user and anything in the user's pipeline#>
    )

    #The sizes used to convert a file's bite size
    $TB = 1099511627776
    $GB = 1073741824
    $MB = 1048576
    $KB = 1024

    $foldertest = (get-item -path $Path).mode    #Tests to see if the item needing size conversion is a folder
    if($foldertest -like "d*"){                  #Conversion for folder sizes
       $originalsize = (gci -path $Path -recurse | Measure-Object -Property Length -Sum).Sum     #Grabbing the sum of all files within the folder selected.

       if($originalsize -gt 0 -and $originalsize -lt 1024){ #bytes
            $finalsize = $originalsize
            "$finalsize Bytes"
        }elseif($originalsize -gt 1023 -and $originalsize -lt 1048576){ #kilobytes
            $convert = ($originalsize/$KB)
            $finalsize = [math]::Round($convert,2)   #To output the size by two decimal places
            "$finalsize KB"
        }elseif($originalsize -gt 1048575 -and $originalsize -lt 1073741824){ #megabytes
            $convert = ($originalsize/$MB)
            $finalsize = [math]::Round($convert,2)
            "$finalsize MB"
        }elseif($originalsize -gt 1073741823 -and $originalsize -lt 1099511627776){ #gigabytes
            $convert = ($originalsize/$GB)
            $finalsize = [math]::Round($convert,2)
            "$finalsize GB"
        }elseif($originalsize -gt 1099511627775){ #terabytes
            $convert = ($originalsize/$TB)
            $finalsize = [math]::Round($convert,2)
            "$finalsize TB"
        }
    }else{                                      #Conversion for file sizes
        $originalsize = (get-item $Path).Length
        
        if($originalsize -gt 0 -and $originalsize -lt 1024){ #bytes
            $finalsize = $originalsize
            "$finalsize Bytes"
        }elseif($originalsize -gt 1023 -and $originalsize -lt 1048576){ #kilobytes
            $convert = ($originalsize/$KB)
            $finalsize = [math]::Round($convert,2)
            "$finalsize KB"
        }elseif($originalsize -gt 1048575 -and $originalsize -lt 1073741824){ #megabytes
            $convert = ($originalsize/$MB)
            $finalsize = [math]::Round($convert,2)
            "$finalsize MB"
        }elseif($originalsize -gt 1073741823 -and $originalsize -lt 1099511627776){ #gigabytes
            $convert = ($originalsize/$GB)
            $finalsize = [math]::Round($convert,2)
            "$finalsize GB"
        }elseif($originalsize -gt 1099511627775){ #terabytes
            $convert = ($originalsize/$TB)
            $finalsize = [math]::Round($convert,2)
            "$finalsize TB"
        }
    }
}