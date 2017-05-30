main:
	elm-make --yes src/Main.elm --output elm.js
clean:
	rm -rf elm-stuff/ elm.js
all: clean main