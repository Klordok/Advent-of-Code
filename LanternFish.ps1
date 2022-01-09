<# 
each lanternfish creates a new lanternfish once every 7 days.
However, this process isn't necessarily synchronized between every lanternfish - 
one lanternfish might have 2 days left until it creates another lanternfish, while another might have 4. 
So, you can model each fish as a single number that represents the number of days until it creates a new lanternfish.

Furthermore, you reason, a new lanternfish would surely need slightly longer before it's capable of producing more lanternfish: 
two more days for its first cycle.

Each day, a 0 becomes a 6 and adds a new 8 to the end of the list, 
while each other number decreases by 1 if it was present at the start of the day.

In this example, after 18 days, there are a total of 26 fish. After 80 days, there would be a total of 5934.

Find a way to simulate lanternfish. How many lanternfish would there be after 80 days?
#>

$InitialState = Get-Content -Path .\LanternFishData.txt

#For each day:
#0 becomes 6
#add new 8 to list
#decrease all other numbers by 1
$FishState = New-Object -TypeName "System.Collections.ArrayList"
$FishList = $InitialState.Split(",")
foreach ($fish in $FishList) {
  #make has of fish and spawn state
  $FishState.Add([PSCustomObject]@{
    Age = [int]$fish
  }) | Out-Null
}

function Age-Fish() {
  #Age fish 1 cycle
  $NewFish = 0
  foreach ($fish in $FishState) {
    #fish that are born get to rest this cycle
    if($fish.age -eq 0) {
      $fish.age = 6
      $NewFish += 1
    }
    else {
      $fish.Age = $fish.Age-1
    }
  }
  if($NewFish -ge 1){
    foreach($baby in 1..$NewFish){
      $FishState.Add([PSCustomObject]@{
        Age = 8
      }) | Out-Null
    }
  }
}

Write-Host "Starting with $($FishState.Count) fish"
foreach ($day in 1..80) {
  Age-Fish
  Write-Host "Day $day : $($FishState.Count)"
}
Write-Host "Answer: $($FishState.Count) fish"
#Answer: 355386