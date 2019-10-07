# Poker
## Setup
Clone repo: `git clone git@github.com:vickris/poker.git`

**TODO: Decide winner according to poker rules**

## Testing

From the shell:
```
Poker.compare_hands(black, white)

#Example
>> Poker.compare_hands("2H 3D 3S 9C KD", "2H 4H 3H 8H AH")
>> "White wins - flush"
>> Poker.compare_hands("2H 3D 3S 9C KD", "2H 3D 3S 9C KD")
>> "Tie"
```

To run tests:
```
mix test test/poker_test.exs
```



