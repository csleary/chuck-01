Math.srandom(76932376);
BPM bpm;
bpm.setTempo(114);
bpm.wholeNote => dur bar;
spork ~ bpm.barLoop();

// dac => WvOut2 render => blackhole; 
// "mixdown.wav" => render.wavFilename;

Machine.add(me.dir() + "/kick.ck") => int kick;
Machine.add(me.dir() + "/snare.ck") => int snare;
Machine.add(me.dir() + "/shakers.ck") => int shakers;
Machine.add(me.dir() + "/subKick.ck") => int subKick;
Machine.add(me.dir() + "/saws.ck") => int saws;
Machine.add(me.dir() + "/tone1.ck") => int tone1;
Machine.add(me.dir() + "/tone2.ck") => int tone2;
Machine.add(me.dir() + "/twinkle.ck") => int twinkle;
Machine.add(me.dir() + "/stacc.ck") => int stacc;
Machine.add(me.dir() + "/poly.ck") => int poly;

while (bpm.locator < 168) {
    bar => now;
}

// render.closeFile();