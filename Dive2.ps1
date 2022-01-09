<#
In addition to horizontal position and depth, you'll also need to track a third value, aim, which also starts at 0. 
The commands also mean something entirely different than you first thought:

    down X increases your aim by X units.
    up X decreases your aim by X units.
    forward X does two things:
        It increases your horizontal position by X units.
        It increases your depth by your aim multiplied by X.
Using this new interpretation of the commands, 
calculate the horizontal position and depth you would have after following the planned course. 
What do you get if you multiply your final horizontal position by your final depth?
#>
$diveCommands = Get-Content -Path '.\diveCommands.txt'
$testDive = 'forward 5','down 5','forward 8','up 3','down 8','forward 2'
$horizontal = 0
$depth = 0
$aim = 0

foreach($command in $diveCommands){
    $command
    $direction = $command.split()[0]
    $Xunits = [int]$command.split()[1]

    switch ($direction) {
        'forward'   { $horizontal += $Xunits
                      $depth += $aim*$Xunits }
        'up'        { $aim -= $Xunits}
        'down'      { $aim += $Xunits}
        Default {}
    }
}
$answer = $horizontal*$depth
Write-Host "Horizonatal position: $horizontal"
Write-Host "Depth: $depth"
Write-Host "H*D = $answer"
#answer 2086261056
#klordok answer: 1463827010