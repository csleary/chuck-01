BPM bpm;
bpm.sixteenthNote => dur sixteenth;
bpm.wholeNote => dur bar;

fun void tunedKick (int freq, int length) {
    Step kickFreq => ADSR envFreq => SinOsc oscil => ADSR envAmp => dac;
    .16 => oscil.gain;
    kickFreq.next(Std.mtof(freq) * (1 << 0));
    envFreq.set(0::ms, 20::ms, .5, 2.::sixteenth);
    envAmp.set(15::ms, 1::sixteenth, .8, 1.::sixteenth);
    envFreq.keyOn(); envAmp.keyOn();
    length::sixteenth => now;
    envFreq.keyOff(); envAmp.keyOff();
    envAmp.releaseTime() => now;
}

[
44, 00, 00, 00,
00, 32, 00, 00,
00, 00, 39, 00,
00, 42, 00, 00
] @=> int kickPitch[];

[
1, 0, 0, 0,
0, 3, 0, 0,
0, 0, 1, 0,
0, 3, 0, 0
] @=> int kickPattern[];

while (bpm.locator < 144) {
    repeat (Math.random2(12, 16)) {
        for (0 => int i; i < kickPattern.cap(); i++) {
            if (kickPattern[i]) {
            spork ~ tunedKick(kickPitch[i], kickPattern[i]);
            }
            1::sixteenth => now;
        }
    }
    Math.random2(1, 4)::bar => now;
}
