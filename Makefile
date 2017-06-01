main: css
	elm-make --yes src/Main.elm --output elm.js
css:
	elm-css src/css/Stylesheets.elm
clean:
	rm -rf elm-stuff/ elm.js styles.css
all: clean main