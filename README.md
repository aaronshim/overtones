# overtones
A hands-on overtone synthesizer for building new tonal colors, built in Elm using the best of modern web technologies and functional programming.

This project was inspired by [The Haskell School of Expression](http://www.cs.yale.edu/homes/hudak/SOE/), especially the idea that the power of functional programming (and functional reactive programming) is well-suited for multimedia projects.

The eventual goal is to make this product platform-agnostic by wrapping it in Electron.

## How to get started
0. Make sure you have Node and NPM installed.

1. Install Elm
    
        npm install -g elm

### (with building and running)

2. Run the `Makefile` (`make`)

3. Open `index.html` in a browser

### (with developing)

2. Run `elm-reactor`

        elm-reactor

3. Open your browser to `localhost:8000` and click on `Main.elm` to start the dev environment. Because ports do not work yet with `elm-reactor`, we won't get audio, but we can debug all the layers and play with the time-travelling debugger *except* for the Web Audio API interop layer.

4. **(Optional)** Install VS Code (or your choice of text editor) with the VS Code [`elm` extension](https://github.com/Krzysztof-Cieslak/vscode-elm) (or the analogue for your text editor), along with the `elm-format` package (`npm install -g elm-format`) for a more robust IDE experience.