BPM bpm;
bpm.sixteenthNote => dur sixteenth;

BD808 kick => Dyno dy => dac;
.44 => kick.gain;
2000 => kick.setCutoff;
4 => kick.setDecay;

dy.compress();
.25 => dy.slopeAbove;
.2 => dy.thresh;
10::ms => dy.attackTime;
100::ms => dy.releaseTime;

[
1, 0, 0, 0,
0, 0, 1, 0,
0, 0, 0, 8,
0, 4, 0, 0
] @=> int kickPattern[];

fun void trig(int chance) {
    if (Math.random2(1, chance) == 1) {
        kick.noteOn();
    }
    second => now;
}

while (bpm.locator < 143) {
    for (0 => int i; i < kickPattern.size(); i++) {
        if (kickPattern[i]) {
            spork ~ trig(kickPattern[i]);
        }
        sixteenth => now;
    }
}

kick.noteOn();
4::sixteenth => now;