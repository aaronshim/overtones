/* WEBPACK ENTRYPOINT 
   (All our Elm code, CSS, etc. get aggregated here.)
*/
require('./css/fonts.css');
require('normalize.css');
require('milligram');
require('./css/Stylesheets.elm');

var Elm = require('./Main.elm');
var app = Elm.Main.fullscreen();

// Our Ports (to receive messages from Elm)
app.ports.controlAudioApi.subscribe(function(audioState) {
    console.log("Received: " + JSON.stringify(audioState));
    clearAudio();
    for (var i = 0; i < audioState.length; i++) {
        var tone = audioState[i];
        createAudio(tone.waveType, tone.frequency, tone.volume);
    }
});

// This is our WebAudio stuff

var audioContext = new AudioContext();
var oscillators = [];
var gains = [];

function createAudio(waveType, frequency, volume) {
    // Create our wave
    var oscillator = audioContext.createOscillator();
    oscillator.type = waveType;
    oscillator.frequency.value = frequency;
    
    // Create our volume control on the wave
    var gainNode = audioContext.createGain();
    gainNode.gain.value = volume;

    // Wire them up
    oscillator.connect(gainNode);
    gainNode.connect(audioContext.destination);

    // Cache the WebAudio API node objects
    oscillators.push(oscillator);
    gains.push(gainNode);

    // flip the switch
    oscillator.start(0);
}

function clearAudio() {
    // Turn off all of our nodes
    for (var i = 0; i < oscillators.length; i++) {
        oscillators[i].stop(0);
        oscillators[i].disconnect();
    }

    for (var i = 0; i < gains.length; i++) {
        gains[i].disconnect();
    }

    // Purge our cache
    oscilators = [];
    gains = [];
}
