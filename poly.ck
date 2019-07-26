BPM bpm;
bpm.sixteenthNote => dur sixteenth;
bpm.wholeNote => dur bar;

ModPoly modPoly;
.6 => modPoly.setPanSpread;
2 => int voiceCount => modPoly.setVoiceCount;

[
[70], [0], [0], [0],
[66], [0], [0], [0],
[58, 51], [0], [0], [0],
[56, 61, 65], [0], [0], [0]
] @=> int patternA[][];

[
[61, 70], [0], [0], [0],
[66, 68], [0], [0], [0],
[58], [0], [0], [0],
[56, 65], [0], [0], [0]
] @=> int patternB[][];

40::bar => now;

repeat (8) {
    for (0 => int i; i < patternA.size(); i++) {
        for (0 => int j; j < patternA[i].size(); j++) {
            if (patternA[i][j]) {
                for (0 => int k; k < voiceCount; k++) {
                    spork ~ modPoly.noteOn(patternA[i][j], k);
                }
            }
        }
    4::sixteenth => now;
    }
}

160 => int end;
while (bpm.locator < end) {
    repeat (8) {
        for (0 => int i; i < patternB.size(); i++) {
            if (bpm.locator == end) break;
            for (0 => int j; j < patternB[i].size(); j++) {
                if (patternB[i][j]) {
                    for (0 => int k; k < voiceCount; k++) {
                        spork ~ modPoly.noteOn(patternB[i][j], k);
                    }
                }
            }
        4::sixteenth => now;
        }
    }
    8::bar => now;
}
2::bar => now;

