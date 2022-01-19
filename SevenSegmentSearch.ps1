<# 
Each entry consists of ten unique signal patterns, a | delimiter, and finally the four digit output value. 
Within an entry, the same wire/segment connections are used (but you don't know what the connections actually are). 
The unique signal patterns correspond to the ten different ways the submarine tries to render a digit using the current wire/segment connections.

Because the digits 1, 4, 7, and 8 each use a unique number of segments, 
you should be able to tell which combinations of signals correspond to those digits. 
Counting only digits in the output values (the part after | on each line), 
in the above example, there are 26 instances of digits that use a unique number of segments (highlighted above).

In the output values, how many times do digits 1, 4, 7, or 8 appear?
#>
$TestInput = @"
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
$OutputList = New-Object -TypeName "System.Collections.ArrayList"
function Get-OutputValues {
    param (
        $SignalData
    )
    $Lines = $SignalData.Split("`n")
    foreach ($line in $Lines) {
        #get 4 output values from signal data
        $OutputValues = $line.Split("|").Trim()[1].Split()
        foreach($value in $OutputValues){
            [void]$OutputList.Add($value)
        }
    }
}

function Count-DigitSignals {
    param (
        $SignalList
    )
    <# 
    one = 2
    four = 4
    seven = 3
    eight = 7
    #>
    $SignalTotal = 0
    $SegmentCounts = 2,4,3,7
    foreach ($signal in $SignalList) {
        if ($signal.length -in $SegmentCounts) {
            $SignalTotal += 1
        }
    }
    Write-Host "Found $SignalTotal valid outputs"
}

Get-OutputValues -SignalData $SegmentData

Count-DigitSignals -SignalList $OutputList
#Answer: 514