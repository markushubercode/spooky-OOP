SndBuf fx => Gain master => dac;
me.dir(-1) + "audio/stereo_fx_01.wav" => fx.read;
fx.samples() => fx.pos;


private class BPM 
{
    dur qN, eN, sN, tN;
    
    fun void tempo (float metro)
    {
        (60.0/metro) => float SPB;
        SPB::second => qN;
        qN*0.5 => eN;
        eN*0.5 => sN;
        sN*0.5 => tN;
    }
}

BPM tempo;
tempo.tempo(120);

class Gran
{
    
    fun void granny (int steps)
    {
        fx.samples()/steps => int grain;
        0.2 => fx.gain;
        0 => fx.pos;
        grain::samp => now; 
    }
    
}

class Simple
{
    SinOsc s => Gain input => dac;
    
    Delay d[3];
    input => d[0] => dac.left;
    input => d[1] => dac.right;
    input => d[2] => dac;
    
    for (0 => int i; i < 3; i++)
    {
        d[i] => d[i];
        0.5 => d[i].gain;
        0.5::second => d[i].max => d[i].delay;
    }
    
    fun float myMusic (float midi, float vol, float length)
    {
        Std.mtof(midi) => s.freq;
        vol => s.gain;
        length::second => now;
    }
}

Simple sim;
Gran g;

spork~one();
spork~two();

while (true)1::second => now;

fun void one()
{
    while (true)
    {
        sim.myMusic (Math.random2f(60.0,66.0), 0.5, 0.5);
        sim.myMusic (Math.random2f(60.0,66.0), 0.5, 0.2);
        sim.myMusic (Math.random2f(60.0,66.0), 0.5, 1.0);
    }
}

fun void two()
{
    while (true)
    {
        g.granny(30);   
    }
}
0 => int counter;



























