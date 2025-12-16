// Candy Collective menu theme
// https://strudel.cc/?WLG3_LyEOmoG
drone:
   note("<c2 <ab1 [ab2 ab2 ab2 f2]>>/2")// <c2 [c3 f2>]>/2")
  .sound("sine")
  ._scope()

chords:
   chord("<[Cm - Cm7 Eb^7] [Ab^7 - Ab6 Bb7]>/2")
  .voicing()
  ._pianoroll()
  .sound("harp")
  .pan(sine.range(0.25, 0.75).slow(4))
  .delay(".2")
  .delaytime(".35")
  .delayfeedback(".5")
  .room(.1)
  .roomsize("5")
  .gain(1)

drums: stack(
  s("bd") .struct("x ~ ~ x <~ [~ x] ~> ~ ~ ~"),
  s("rim").struct("~ ~ ~ ~ x <~ [~ x]> ~ ~"),
  s("hh") .struct("~ ~ x ~ ~ ~ x <~ ~ ~ [x x x]>"),
)
  .bank('rolandtr909')
  .gain(.1)
  // .delay(.2)
  //.delaytime(".2")
  ._spiral()
