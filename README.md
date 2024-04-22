# simple-raytracer
A simple translation of the famous business card raytracer (found [here](https://fabiensanglard.net/rayTracing_back_of_business_card/))

You can also now have custom messages by generating the bit vectors from ascii art using the python script.

Take note of the number of columns and rows it tells you your message has, you'll need to change:

  - The length of `sphere_positions` (i.e. the array of bit vectors) and the `NUM_LINES` constant to the "number of lines" value
  - The `NUM_COLUMNS` constant to the "number of columns" value
  - Of course, the contents of the `sphere_positions` array with the contents of the "Bit vector" array from the script.

Note that the bigger your message the longer the rendering is going to take, and it already takes a while as is :)

![rendered img](/ekr.png)
