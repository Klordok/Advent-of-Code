<# 
8:  
 aaaa   
b    c 
b    c 
 dddd 
e    f 
e    f 
 gggg 

Each entry consists of ten unique signal patterns, a | delimiter, and finally the four digit output value. 
Within an entry, the same wire/segment connections are used (but you don't know what the connections actually are). 
The unique signal patterns correspond to the ten different ways the submarine tries to render a digit using the current wire/segment connections.

For each entry, determine all of the wire/segment connections and decode the four-digit output values. 
What do you get if you add up all of the output values?
#>
$TestData = @"
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
"@

$SegmentData = Get-Content .\SevenSegmentSearch.txt
<#
find 1, 4, 7, 8 in patterns after |
one = 2
four = 4
7 = 3
8 = 7
#>


#Use unique signal data to map scramble letters to real letters
#Use letter mapping to find 4 digit output value
#Repeat for all lines in Segment Data
$PatternList = New-Object -TypeName "System.Collections.ArrayList"
$OutputList = New-Object -TypeName "System.Collections.ArrayList"

function Format-SignalData {
    param (
        $SegmentData
    )
    $Lines = $SegmentData.Split("`n")
    foreach ($line in $Lines) {
        #get unique signal data
        $SignalPatterns = $line.Split("|").Trim()[0].Split()
        [void]$PatternList.Add($SignalPatterns)

        #get 4 output values from signal data
        $OutputValues = $line.Split("|").Trim()[1].Split()
        [void]$OutputList.Add($OutputValues)
    }

}

function Decode-Signals {
    param (
        $UniqueSignals
    )
    $SegmentMap = [ordered]@{
        'a'='' #in 7 and not in 1
        'b'=''
        'c'='' #in 1 and 0. Not in 6
        'd'='' 
        'e'='' #6 segments
        'f'=''
        'g'=''
    }
    $DigitMap = [ordered]@{
        0="" #6 segments
        1="" #2 segments
        2="" #5 segments
        3="" #5 segments
        4="" #4 segments
        5="" #5 segments
        6="" #6 segments
        7="" #3 segments
        8="" #7 segments
        9="" #6 segments
    }
    #Find 1, 4, 7, 8
    $UnknownDigits = New-Object -TypeName "System.Collections.ArrayList"
    foreach ($signal in $UniqueSignals){
        switch ($signal.length) {
            2 { $DigitMap[1] = $signal }
            4 { $DigitMap[4] = $signal }
            3 { $DigitMap[7] = $signal }
            7 { $DigitMap[8] = $signal }
            Default {[void]$UnknownDigits.Add($signal)}
        }
    }
    #letter in 7 but not in 1 is in 'a' segment position
    $SegmentMap['a'] = (Compare-Object -ReferenceObject $DigitMap[7].toCharArray() -DifferenceObject $DigitMap[1].toCharArray()).InputObject

    #letters in 1 represent either c or f postion
    foreach ($signal in $UnknownDigits) {
        if ($signal.length -eq 6){
            #0,6,9
            $cSegment = (Compare-Object -ReferenceObject $signal.toCharArray() -DifferenceObject $DigitMap[1].toCharArray() | Where-Object{$_.SideIndicator -eq "=>"}).InputObject
            if ($null -ne $cSegment){
                $SegmentMap['c'] = $cSegment
                $SegmentMap['f'] = (Compare-Object -ReferenceObject $DigitMap[1].toCharArray() -DifferenceObject $cSegment).InputObject
                $DigitMap[6] = $signal
                $UnknownDigits.Remove($signal)
                break
            }
        }
    }

    #2,3,5 have 5 segments
    foreach ($signal in $UnknownDigits) {
        if ($signal.length -eq 5) {
            $SignalChars = $signal.toCharArray()
            if (($SignalChars -contains $SegmentMap['c']) -and ($SignalChars -contains $SegmentMap['f'])){
                $DigitMap[3] = $signal
            }
            elseif (($SignalChars -contains $SegmentMap['c']) -and ($SignalChars -notcontains $SegmentMap['f'])) {
                $DigitMap[2] = $signal
            }
            else {
                $DigitMap[5] = $signal
            }
        }
    }
    $UnknownDigits.Remove($DigitMap[3])
    $UnknownDigits.Remove($DigitMap[2])
    $UnknownDigits.Remove($DigitMap[5])

    Write-Host "`nKnown Digits:"
    $DigitMap
    Write-Host "`nKnown Segments:"
    $SegmentMap
    Write-Host "`nUnknown Digits:"
    $UnknownDigits
}

Format-SignalData -SegmentData $TestData

foreach ($line in $PatternList){
    Decode-Signals -UniqueSignals $line
}