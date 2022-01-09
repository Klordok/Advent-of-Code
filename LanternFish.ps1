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
