BPM bpm;
bpm.sixteenthNote => dur sixteenth;
bpm.wholeNote => dur bar;
0.22 => float GAIN;

fun void tone (int freq) {
    Step toneFreq => SinOsc oscil => ADSR envAmp => dac;
    GAIN => oscil.gain;
    toneFreq.next(Std.mtof(freq + 12));
    envAmp.set(10::ms, 0.25::sixteenth, .1, .25::sixteenth);
    envAmp.keyOn();
    1::sixteenth => now;
    envAmp.keyOff();
    envAmp.releaseTime() => now;
}

[
56, 00, 46, 00,
00, 00, 00, 00,
44, 00, 00, 00,
00, 00, 39, 32
] @=> int tonePitch[];

while (bpm.locator < 152) {
    repeat (8) {
        for (0 => int i; i < tonePitch.cap(); i++) {
            if (i == 0 && Math.random2(1, 8) == 1) {
                1::sixteenth => now;
                continue;
            }
            if (tonePitch[i]) {
            spork ~ tone(tonePitch[i]);
            }
            1::sixteenth => now;
        }
    }
    4::bar => now;
}