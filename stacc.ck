BPM bpm;
bpm.sixteenthNote => dur sixteenth;
bpm.wholeNote => dur bar;

ChipTrill chipTrill => WPKorg35 filter => Pan2 panner => dac;
0.04 => chipTrill.setGain;
-.15 => panner.pan;

[
56, 56, 47, 46,
00, 46, 44, 49,
00, 49, 00, 63,
00, 63, 70, 68
] @=> int tonePitch[];

32::bar => now;

while (bpm.locator < 152) {
    repeat (8) {
        for (0 => int i; i < tonePitch.size(); i++) {
            if (tonePitch[i]) {
                Math.random2f(200, 8000) => filter.cutoff;
                Math.random2f(1, 1.8) => filter.resonance;
                spork ~ chipTrill.noteOn(tonePitch[i]);
            }
            sixteenth => now;
        }
    }
    8::bar => now;
}