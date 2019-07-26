BPM bpm;
bpm.sixteenthNote => dur sixteenth;
0.14 => float GAIN;
.6 => float pan;

[
00, 00, 58, 00,
00, 00, 00, 00,
00, 00, 00, 51,
00, 00, 53, 00
] @=> int tonePitch[];

fun void tone2 (int pitch) {
    Step toneFreq => SinOsc oscil => ADSR envAmp => JCRev reverb;
    reverb => Pan2 panner => dac;
    GAIN => oscil.gain;
    .12 => reverb.mix;
    pan => panner.pan;
    
    Math.random2(1, 3) * 12 +=> pitch;
    toneFreq.next(Std.mtof(pitch));
    envAmp.set(5::ms, .25::sixteenth, .1, .25::sixteenth);
    envAmp.keyOn();
    sixteenth => now;
    envAmp.keyOff();
    5::second => now;
}

while (bpm.locator < 152) {
    for (0 => int i; i < tonePitch.cap(); i++) {
        if (i == 15 && !Math.random2(0, 32)) {
                spork ~ tone2(70);
                1::sixteenth => now;
                continue;
        }
            
        if (tonePitch[i]) {
        -1 *=> pan;
        spork ~ tone2(tonePitch[i]);
        }
        1::sixteenth => now;
    }
}

2::bpm.wholeNote => now;