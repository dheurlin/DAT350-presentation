# Våra slides till presentationen

De är uppdelade i varsin del så man slipper merge conflicts och sånt.

Dependencies:
* [Metropolis beamer theme](https://github.com/matze/mtheme)
* Pandoc så klart

## Makefilen

`make wide` för att maka 16:9, `make slim` för att maka 4:3. Vi får se vad de
har i salen när vi presenterar.

## Makron

Jag gjorde ett makro så man kan få en sån fet slide med bara stor centread text
på:

```
\bigslide{
Fet jävla text
}
```
