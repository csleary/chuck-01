BPM bpm;
bpm.sixteenthNote => dur sixteenth;

fun void play808Snare (float accent, int roll) {
    SD808 sd => Dyno dy;
    dy => Gain master => dac;

    44 => Std.mtof => sd.setFreq1;
    56 => Std.mtof => sd.setFreq2;

    dy.compress();
    4. => dy.ratio;
    .5 => dy.thresh;
    1::ms => dy.attackTime;
    50::ms => dy.releaseTime;
    .3/roll => dy.gain;

    sd.noteOn(accent);
    8::sixteenth => now;
}

fun void playSnare (float gain) {
    Noise n => LPF lp => HPF hp => Envelope nAmp => SinOsc s => Envelope envAmp => Dyno dy;
    dy => Gain master => dac;
    SinOsc s2 => envAmp;
    
    dy.compress();
    4. => dy.ratio;
    .35 => dy.thresh;
    2::ms => dy.attackTime;
    50::ms => dy.releaseTime;
    1.2 => dy.gain;

    9000 => lp.freq;
    1500 => hp.freq;

    2 => s.sync;
    56 => Std.mtof => float s1Freq => s.freq;
    s1Freq => s2.freq;
    gain * 2/3 => s.gain;
    gain => s2.gain;
    10000 => n.gain;
    .25 => master.gain;

    1. => envAmp.value => nAmp.value;
    .05 => envAmp.time;
    .1 => nAmp.time;
    .05 => envAmp.target;
    .05 => nAmp.target;
    1::sixteenth/2 => now;

    .2 => envAmp.time;
    .3 => nAmp.time;
    .0 => envAmp.target;
    .0 => nAmp.target;
    250::ms => now;

    envAmp.keyOff();
    nAmp.keyOff();
    8::sixteenth => now;
}

fun void roll (int roll) {
    if (Math.random2(0, 4) == 1) {
        for (0 => int i; i < roll; i++) {
            spork ~ play808Snare(0, roll);
            1::sixteenth/roll => now;
        }
    } else {
        for (0 => int i; i < roll; i++) {
            spork ~ playSnare(.6/roll);
            1::sixteenth/roll => now;
        }
    }
}

[
0, 0, 0, 0,
1, 0, 0, 0,
0, 1, -1, -1,
1, 0, -1, 1
] @=> int snarePatternA[];

[
0, 0, 1, 0,
0, 0, 0, 1,
0, 0, 1, 0,
0, 0, 0, 1
] @=> int snarePatternB[];

[
0, 0, 0, 0,
1, 0, 0, 0,
0, 0, 0, -1,
1, 0, 0, 0
] @=> int snarePatternC[];

[
0, 0, 1, 0,
0, 1, 0, 0,
1, 0, 0, 1,
0, 0, 1, -1
] @=> int snarePatternD[];

[
    snarePatternA,
    snarePatternB,
    snarePatternC,
    snarePatternD
] @=> int patterns[][];

while (bpm.locator < 143) {
    bpm.sixteenthNote => sixteenth;
    patterns[Math.random2(0, patterns.size() - 1)] @=> int activePattern[];

    for (0 => int i; i < activePattern.size(); i++) {
        if (activePattern[i] == -1) {
            spork ~ roll(Math.random2(1, 8));
        } else if (activePattern[i]) {
            if (Math.random2(0, 1)) {
                spork ~ playSnare(.6);
            } else {
                spork ~ play808Snare(0., 1);
            }
        }
        sixteenth => now;
    }
}