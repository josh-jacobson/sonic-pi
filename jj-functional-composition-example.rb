# Composition (of functions and music)
# by Josh Jacobson
# a simple live loop with melody, chords and drums. Composed with the help of function composition.

use_bpm 60

# Starting melody and chords

notes = [72, 75, 79, 82, 84]
Fmin9 = [53, 68, 72, 75, 79]
Cmin11 = [60, 67, 70, 74, 77]


# Composers

def octave_down(melody)
  return melody.map { |note| note-12 }
end

def reorder(melody)
  return melody.shuffle
end

def reverse(melody)
  return melody.reverse
end

def compose_melody(notes, composer_functions)
  for func in composer_functions
    notes = method(func).call(notes)
  end
  return notes
end

# Players

def play_chord(notes)
  for note in notes
    play note
  end
end

def play_melody(melody)
  use_synth :pulse
  for note in melody
    play note
    sleep 0.5
  end
  sleep 1.5
end

def play_chords
  play_chord(Fmin9)
  sleep 1
  
  play_chord(Cmin11)
  sleep 3
end


# Live Loops:
counter = 0

live_loop :melody do
  if (counter > 1)
    melody = compose_melody(notes, [:octave_down, :reorder])
    play_melody(melody)
  else
    sleep 4
  end
  
  counter += 1
end

live_loop :chords do
  play_chords()
end

live_loop :amen_break do
  p = [0.125, 0.25, 0.5].choose
  with_fx :slicer, phase: p, wave: 0, mix: rrand(0.7, 1) do
    r = [1, 1, 1, -1].choose
    sample :loop_amen, beat_stretch: 2, rate: r, amp: 2
  end
  sleep 2
end

live_loop :bass_drum do
  sample :bd_haus, cutoff: 70, amp: 1.5
  sleep 0.5
end
