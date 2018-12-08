# nashdown
A simple human-readable file format and Ruby-based parser for Nashville Number System chord charts

### WIP/Notes

.nd files

WIP regex exploration [Rubular: (b|#)?(1-7)(-)?(m7|min7|Maj7|maj7|M7|d7)?((add|sus|aug|dim)1-9{0,2})?(\/1-7)?](http://rubular.com/r/TdgXYvHcIX)

 http://rubular.com/r/UOem6bu6Fr


## Basic Chart
```
1 1 4 1
1 1 5 1
```

## Multiple chords per bar

```
1_5 2_4 6_1
1'''_5'
```

## Minors/7s
```
6- 5d7 2m7 2M7
```

## Other extensions, etc.
```
4add9 4sus4
```

## Slash
```
5/7
```


## Accidentals
```
b6 b7
```


## Diamonds
```
1 1 4 <5>
```

## Watch
```
1 1 4 <@5>
```

## Marcato
```
1 1 4 ^5
```

## Push
```
1 1 4 <5
```

## Ties
```
1 1 4 <5>~<5>
```

## X and •
```
1 5 1/3 x
1 • 5 •
```

## Dynamics
```
mp 1 1 4 1
f 1 1 5 1
ff -7 5 1 1
```

## Todo dynamic changes

## Short bars
```
1 1 4''
```


## Repeats
```
|: 1 1 4 5
1 1 | 4 5 :| 5 4 |    (first and last time)
```

## Rehearsal marks and notes
```
Verse)
1 1 4 5
--Bass enters
1 1 4 5

Chorus)
1 1 5 1
```

## Title, key, bpm, feel
```
"The Title"
Eb, Blues, 4/4, 150bpm


```

# Full chart example
From page 25 of “Song charting made easy”

```
"One More Minute With You"
Pop-Rock
F#
4/4
140bpm

I)
--1x guitar only--
||: 1 1 1 1

V)
mp
1 1 1 1
4 4 4 4
1 1 1 1
4 4 4 4

Cha)
--Full band--
mf
<2->~<2-> <4>~<4> --(Diamond 1x only!)--
<2->~<2-> 4 4

Ch)
f
1 5 1/3 4
1 4 | b3 <4> :|| b3 4 |

Ch)
f
<1 5 1/3 4
1 5 b3 4

Br)
mp
b6 b6 b7 b7
1 1
f
b6 b6 b7 b7
4 4 b3 4

Solo)
1 5 1/3 4
1 5 b3 4

Ch)
1 5 ^1/3 4
<1 5 b3 4

Ch)
>1 5 1/3 4
1 5 b3 4

Out)
||: 1 5 1/3 4
1 5 b3 4 :|| <@1>

```
