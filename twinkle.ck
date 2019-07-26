BPM bpm;
bpm.sixteenthNote => dur sixteenth;
bpm.wholeNote => dur bar;
0 => int timer;
.8 => float pan;

[32, 34, 35, 37, 39, 41, 42] @=> int scale[];

HPF hpf => Dyno dy =>Pan2 panner => dac;
panner => GVerb reverb => dac;
dy => MonoDelay monoDelayL => dac.left;
dy => MonoDelay monoDelayR => dac.right;

150 => hpf.freq;

0.4 => reverb.gain;
4::second => reverb.revtime;

dy.compress();
3 => dy.ratio;
.12 => dy.thresh;
1::ms => dy.attackTime;
200::ms => dy.releaseTime;
1.4 => dy.gain;

.2 => monoDelayL.gain => monoDelayR.gain;
6::sixteenth => monoDelayL.setDelayTime;
.2 => monoDelayL.setFeedback;
9::sixteenth => monoDelayR.setDelayTime;
.2 => monoDelayR.setFeedback;

fun void strike(float freq) {
    BandedWG bwg => hpf;

    .35 => bwg.gain;
    freq => bwg.freq;
    pan => panner.pan;
    -1 *=> pan;

    Math.random2f(.5, 1) => bwg.bowRate;
    Math.random2f(.5, 1) => bwg.bowPressure;
    Math.random2f(.5, 1) => bwg.strikePosition;
    Math.random2(0, 3) => bwg.preset;
    Math.random2f(.8, 1) => bwg.pluck;
    second => now;
}

8::bar => now;

while (bpm.locator < 152) {
    timer % 32 => int step;

    scale[Math.random2(0, scale.size() - 1)] => int selectedNote;
    Math.random2(0,4) * 12 + selectedNote => Std.mtof => float freq;
    
    if (timer % 2 == 0) {
        spork ~ strike(freq);
    } else {
        if (Math.random2(0, 3) == 0) {
            1/3 * sixteenth => now;
            spork ~ strike(freq);
            2/3 * sixteenth => now;
        }
    }
    sixteenth => now;
    timer++;
}

8::bar => now;
