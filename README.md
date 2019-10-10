# Våra slides till presentationen

De är uppdelade i varsin del så man slipper merge conflicts och sånt.

Dependencies:
* [Metropolis beamer theme](https://github.com/matze/mtheme)
* Pandoc så klart

## Makefilen

`make wide` för att maka 16:9, `make slim` för att maka 4:3. Vi får se vad de
har i salen när vi presenterar.

## Rubrik med progress bar

Vanliga slides görs med en h2, dvs `## Rubrik`. Om man istället vill ha en fet
fullscreen-rubrik med progressbar kör man bara en `# rubrik` utan något under så
blir det fett. Detta definieras av temat.
