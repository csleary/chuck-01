BPM bpm;
bpm.sixteenthNote => dur sixteenth;
bpm.halfNote => dur half;
bpm.wholeNote => dur bar;
.6 => float pan;
2 => int voiceCount;

[
32, 00, 32, 00,
23, 00, 27, 00,
32, 00, 32, 00,
23, 00, 30, 00
] @=> int pitchPatternA[];

[
32, 00, 00, 00,
00, 27, 25, 00,
32, 00, 00, 00,
23, 30, 27, 00
] @=> int pitchPatternB[];

[
32, 00, 00, 00,
23, 00, 25, 00,
32, 00, 00, 00,
00, 30, 27, 00
] @=> int pitchPatternC[];

[
    pitchPatternA,
    pitchPatternB,
    pitchPatternC
] @=> int patterns[][];

fun void playNote (int freq, int length) {
    SawOsc saw => LPF lpf => ADSR envAmp => Tremolo trem => HPF hpf => Dyno dy => Pan2 panner => dac;
    2 => saw.sync;
    SinOsc sin => saw;

    .2 => saw.gain;
    Math.random2(300, 3000) => sin.gain;

    Math.random2(200, 400) => lpf.freq;
    Math.random2f(.7, 1.9) => lpf.Q;

    Math.random2f(.3, 2.) => trem.freq;

    80 => hpf.freq;

    dy.compress();
    3 => dy.ratio;
    .3 => dy.thresh;

    -1 *=> pan;
    pan => panner.pan;


    Std.mtof(freq) * Math.pow(2, Math.random2(2, 5)) + Math.random2f(0.1, 2) => sin.freq; 
    Std.mtof(freq) => saw.freq;
    envAmp.set(5::ms, 1::sixteenth, .8, 2::sixteenth);

    envAmp.keyOn();
    length::sixteenth => now;
    envAmp.keyOff();
    envAmp.releaseTime() => now;
}

24::bar => now;

while (bpm.locator < 152) {
    patterns[Math.random2(0, patterns.size() - 1)] @=> int activePattern[];
    for (0 => int i; i < activePattern.size(); i++) {
        activePattern[i] => int note;
        if (note) {
            for (0 => int i; i < voiceCount; i++) {
                spork ~ playNote(note, 8);
            }
        }
        1::half => now;
    }
}