<#
It seems like the submarine can take a series of commands like forward 1, down 2, or up 3:

    forward X increases the horizontal position by X units.
    down X increases the depth by X units.
    up X decreases the depth by X units.
Your horizontal position and depth both start at 0. 
Calculate the horizontal position and depth you would have after following the planned course. 
What do you get if you multiply your final horizontal position by your final depth?
#>

$diveCommands = Get-Content -Path .\diveCommands.txt

$horizontal = 0
$depth = 0

foreach($command in $diveCommands){
    $direction = $command.split()[0]
    $distance = [int]$command.split()[1]

    switch ($direction) {
        'forward'   { $horizontal += $distance }
        'up'        { $depth -= $distance}
        'down'      { $depth += $distance}
        Default {}
    }
}
$answer = $horizontal*$depth
Write-Host "Horizonatal position: $horizontal"
Write-Host "Depth: $depth"
Write-Host "H*D = $answer"
#answer: 2091984