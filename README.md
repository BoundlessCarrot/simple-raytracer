# simple-raytracer
A simple translation of the famous [business card raytracer](https://fabiensanglard.net/rayTracing_back_of_business_card/)

You can also render custom messages by generating the bit vectors from ascii art using the included python script.

Take note of the number of columns and rows it tells you your message has, you'll need to change:

  - The `NUM_LINES` constant to the "number of lines" value
  - The `NUM_COLUMNS` constant to the "number of columns" value
  - The contents of the `sphere_positions` array with the contents of the "Bit vector" array from the script.

Note that the bigger your message the longer the rendering is going to take, and it already takes a while as is :)

![rendered img](/jstr.png)

## Usage

  1. Put your ascii art into the python script and run it with `python3 bit_vector_creator.py`
  2. Get your `sphere_positions`, `NUM_COLUMNS`, and `NUM_LINES` from the python script output and place them into the relevant zig variables
     - You can create your own art [here](https://asciiflow.com/#/)
  3. Run with `zig build-exe raytracer.zig && ./raytracer > img.ppm`
     - You can also use the `-O ReleaseFast`  or `-O ReleaseSafe` flags to speed up the execution
  4. Then, with imagemagick installed, run `convert img.ppm img.png` to convert the image to a png format

## Sources
  - [0] [Original source](https://fabiensanglard.net/rayTracing_back_of_business_card/)
  - [1] [Explaining some vars](https://news.ycombinator.com/item?id=6425965)
