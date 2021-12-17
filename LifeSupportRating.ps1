<#
life support rating can be determined by multiplying the oxygen generator rating by the CO2 scrubber rating.
LSR = O2 * CO2
start with the full list of binary numbers from your diagnostic report and consider just the first bit of those numbers. Then:

    Keep only numbers selected by the bit criteria for the type of rating value for which you are searching. 
    Discard numbers which do not match the bit criteria.
    If you only have one number left, stop; this is the rating value for which you are searching.
    Otherwise, repeat the process, considering the next bit to the right.

The bit criteria depends on which type of rating value you want to find:

    To find oxygen generator rating, determine the most common value (0 or 1) in the current bit position, and keep only numbers with that bit in that position. 
    If 0 and 1 are equally common, keep values with a 1 in the position being considered.
    To find CO2 scrubber rating, determine the least common value (0 or 1) in the current bit position, and keep only numbers with that bit in that position. 
    If 0 and 1 are equally common, keep values with a 0 in the position being considered.

#>

$ReportData = Get-Content .\ReportData.txt

function Get-OxygenGeneratorRating() {
    [CmdletBinding()]
    param (
        $OGRData
    )
    #To find oxygen generator rating, determine the most common value (0 or 1) in the current bit position, 
    #If 0 and 1 are equally common, keep values with a 1 in the position being considered.
    #keep only numbers with that bit in that position.

    Write-Verbose "Finding OGR"
    foreach($position in (0..($OGRData[0].Length-1))){
        Write-Verbose "Checking position $position"
        $1count = 0
        foreach($item in $OGRData){
            if($item[$position] -eq '1'){
                $1count += 1
            }
        }
        if($1count -ge $OGRData.count/2){
            #remove numbers with 0 in current position
            Write-Verbose "1 is most common in position $position"
            $OGRData = $OGRData | Where-Object{$_[$position] -eq '1'}
        }
        else{
            #remove numbers with 1 in current position
            Write-Verbose "0 is most common in position $position"
            $OGRData = $OGRData | Where-Object{$_[$position] -eq '0'}
        }
        Write-Verbose "$($OGRData.count) items remain"
        if($OGRData.count -eq 1){
            $OGRData
        
            break
        }
    }

}

function Get-ScrubberRating() {
    #To find CO2 scrubber rating, determine the least common value (0 or 1) in the current bit position.
    #If 0 and 1 are equally common, keep values with a 0 in the position being considered.
    #keep only numbers with that bit in that position. 
    [CmdletBinding()]
    param(
        $ScrubData
    )
    Write-Verbose "Finding Scrub"
    foreach($position in (0..($ScrubData[0].Length-1))){
        Write-Verbose "Checking position $position"
        $1count = 0
        foreach($item in $ScrubData){
            if($item[$position] -eq '1'){
                $1count += 1
            }
        }
        if($1count -lt $ScrubData.count/2){
            #remove numbers with 0 in current position
            Write-Verbose "1 is least common in position $position"
            $ScrubData = $ScrubData | Where-Object{$_[$position] -eq '1'}
        }
        else{
            #remove numbers with 1 in current position
            Write-Verbose "0 is least common in position $position"
            $ScrubData = $ScrubData | Where-Object{$_[$position] -eq '0'}
        }
        Write-Verbose "$($ScrubData.count) items remain"
        if($ScrubData.count -eq 1){
            $ScrubData
        
            break
        }
    }
}
$OGbstring = Get-OxygenGeneratorRating -OGRData $ReportData
$CObstring = Get-ScrubberRating -ScrubData $ReportData
Write-Host "Oxygen Generation Rating:$OGbstring"
Write-Host "CO2 Scrub Rating:$CObstring"

$OGint = [Convert]::ToInt32($OGbstring,2)
$COint = [Convert]::ToInt32($CObstring,2)

$OGint
$COint
$answer = $OGint*$COint

Write-Host "Answer: $answer"
#Answer: 3969126