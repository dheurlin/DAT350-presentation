default: wide

wide: combined
	pandoc -t beamer combined.md \
		-V theme:metropolis -V aspectratio:169 -o slides.pdf

slim: combined
	pandoc -t beamer combined.md \
		-V theme:metropolis -V aspectratio:43 -o slides.pdf

combined: preamble.md oskuld.md bs.md
	cat preamble.md > combined.md; \
		echo "" >> combined.md; \
		cat oskuld.md >> combined.md; \
		echo "" >> combined.md; \
		cat bs.md >> combined.md

clean:
	rm *.pdf; rm combined.md
