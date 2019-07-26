BPM bpm;
bpm.sixteenthNote => dur sixteenth;
bpm.wholeNote => dur bar;

Shakers shakers => Dyno dy => Pan2 panner => dac;
.16 => shakers.gain;

dy.compress();
.7 => dy.gain;
.15 => panner.pan;

[
    1, 1, 0, 1,
    1, 1, 0, 1,
    1, 1, 0, 1,
    1, 1, 0, 1
] @=> int pattern[];

[0, 1, 2] @=> int presets[];

fun void noteOn() {
    Math.random2(0, presets.size() - 1) => int index;
    presets[2] => shakers.preset;
    Math.random2f(0.4, .8) => shakers.energy;
    Math.random2f(0.1, .3) => shakers.decay;
    Math.random2f(20, 100) => shakers.objects;
    shakers.noteOn(1);
}

16::bar => now;

while (bpm.locator < 143) {
    repeat (16) {
        for (0 => int i; i < pattern.size(); i++) {
            if (bpm.locator == 143) break;

            if (pattern[i]) {
                spork ~ noteOn();
            }
            sixteenth => now;
        }
    }
    Math.random2(4, 12)::bar => now;
}

bar => now;