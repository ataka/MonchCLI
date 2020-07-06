plantuml = /usr/local/bin/plantuml
png = review-usecase.png

.PHONY: all
all: $(png)

%.png: %.plantuml
	$(plantuml) $<
