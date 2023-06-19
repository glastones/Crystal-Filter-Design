# glastone
This program made in my spare time. It is made in order to calculate a Wideband discrete xtal crystal filters. 
All equations comes from the Anatol Sverev handbook of filter synthesis book.
The software tested in very little design and it seem to work fine. At least in at the frequency of the crystals seem to be ok. At least in simulation. 

The problem with the calculations occurs because you mus know the strain capacitance (C0) and the Motional capacitance (Ci) and the Motional Inductance (Li). If you like to solve that problem you must  communicate with the crystal manufacture. 

So the software based on the Motional Capacitance. Base on that calculate the motional Inductance (Li)
the strain Capacitance (C0) with the assumption that the area of the electrode make a simple parallel plate capacitance. This is not accurate because even if the manufacture use the calculated electrode the capacitance varies from the type of the blank it will us. The strain capacitance also include the holder capacitance and the cementing of the crystal in the holder. Another assumption is that the blank is used is AT-Cut. At low frequencies such 1MHz it is easy to use the SC cut or some other cut.
If you do not know the value of the Co you could not be accurate for the capacitor between the crystals and the input and output capacitance. 
So you have 2 option here. First the calculated filter impedance used in the matching module to make the form natural impedance to a desirable impedance. With this way you do not care about any capacitance at the input and the output. As for the capacitor between the crystals it is wised to consider using an inductance with a tuned capacitance in order to tune out the any parasitic capacitance which may need it the filter. With this option you could easily make a filter with low ripple and very sharp response.
The second solution is to contact with the manufacture and inform you with the characteristics of the crystal which made for that frequencies. Then you could calculate more accurate the capacitance in the circuits. 
In schematics which show in the program shows only the transformers which need it (at which points) but not the tuning capacitors which need it. Those transformer are calculate mostly empirical.
The values must be in the order of the Li of the crystals. 

The pdf file shows how to calculate the transformer and a rule of thump of how to calculate the primary inductor.

The program files.

This program create a manufacture data file. A simple text file which could be send to the manufacture and it is used to observe the assumption which made. 

The response file which is a csv file. This files could be used with the excel in order to see the response of the filter. Sometimes (and I do not know why ) the program produce an error when simulation runs. 
Try with smaller span or larger step.

The values 

In this program you must enter the center frequency , span and motional capacitance. If you do not know it you could use a value from 1 to 9 fF. Form that value the algorithm calculate the spot size which need to be used so the Static capacitance occurs.

Happy news for eveyone which may interesting. I manage to add more design to the program in 19/06/2023. Those are in Version 2 The problem is i haven't implement the print function which is not working yet.


Thoughts about improvements.

The program is open source and all could be able to play with the code. 
Because I am not a professional programmer I could not manage the code (too many units and code pure documentation). So I do not know when I could made an update. 
The program calculate all values of the crystals. So If you have the actually crystal parameters you could not used them because there are not such options yet. I think that could be easy for example for someone to make a unit which could take as inputs the crystal parameters and could calculate with high accuracy the filter. Also higher order of crystal filter could be made by cascade the existing filters. 
Because I am a bit lazy I copied a lot of times the same code. So a huge improvement in size and performance could be made by optimize the code. 
Another think is the crystal cutting. The current algorithm suppose that the crystal has been order with X-Axis cut ant the angle is 35.25degrees which is the most common. 
It will be useful if someone change that algorithm for other cuttings and other angles.
Something that does not finished buy partial implement is the ability to print the screen. I do not consider that will be very useful because of the produced files. 
If you enter the result simulations into excel or open office (open office seems some strange character in from of the numbers maybe because not utf-8 font is used or may need it the csv class which free pascal used for that purpose. You should easily correct this with the function right). 
As for the graphical  representation of the filter may someone make a chart or something similar in order to see user the complete response of the filter in the screen.

That is all for that program. 
For any further details please let me know.

