class Palette {
  int nPalettes, current;
  color[] palette;
  ArrayList<color[]> paletteDefs;
  
  Palette () {
    paletteDefs = getPaletteDefs();
    nPalettes = paletteDefs.size();
    current = 0;
    palette = this.switchPalette(0);
  }
  
  color getColor(int n, int alpha) {
    color c = this.palette[n];
    color alphaColor = alpha << 030;
    return c & ~#000000 | alphaColor; //some serious bitbanging magic
  }
  
  void nextPalette(){
    this.current = (this.current + 1) % this.nPalettes;
    this.palette = this.switchPalette(this.current);
  }
  
  void setPalette(int n) {
    if (n >= this.nPalettes) {
      return;
    }
    this.current = n;
    this.palette = this.switchPalette(this.current);    
  }
  
  color[] rainbowPalette() {
    pushStyle();
    colorMode(HSB, 360, 1, 1);
    int[] hueValues = {0, 15, 30, 60, 90, 120, 150, 180, 210, 225, 240, 270, 300, 330};//, 360};
    color[] c = new color[hueValues.length];
    for (int index = 0; index < hueValues.length; index++) {
      c[index] = color(hueValues[index], 1, 1);
    }
    popStyle();
    return this.getPalette(c);
  }
  
  color[] rainbowBWPalette() {
    pushStyle();
    colorMode(HSB, 360, 1, 1);
    int[] hueValues = {0, 15, 30, 60, 90, 120, 150, 180, 210, 225, 240, 270, 300, 330};//, 360};
    color[] c = new color[hueValues.length*2];
    for (int index = 0; index < hueValues.length; index++) {
      c[2*index] = color(hueValues[index], 1, 1);
      c[2*index + 1] = color(1, 0,  index%2);
    }
    popStyle();
    return this.getPalette(c);
  }
  
  color[] getPalette(color[] colorsIn) {
    int nColors = colorsIn.length;
    color[] palette = new color[256];
    int stepsPerCycle = 256 / nColors;
    int n = 0;
    int c = 0;
    while (n < 256) {
      for (int i=0; i<stepsPerCycle; i++) {
        if (n<256){
          //palette[n] = lerpColor(colorsIn[c%nColors], colorsIn[(c+1)%nColors], float(i)/float(stepsPerCycle));
          palette[n] = smootherStepC(colorsIn[c%nColors], colorsIn[(c+1)%nColors], float(i)/float(stepsPerCycle));
        }
        n++;
      }
      c++;
    }
    return palette;
  }
  
  ArrayList<color[]> getPaletteDefs() {
    ArrayList<color[]> list = new ArrayList<color[]>();
    pushStyle();
    colorMode(RGB, 255, 255, 255, 255);
    list.add(rainbowPalette());
    list.add(new color[] {
      color(0),
      color(255),
    });
    list.add(new color[] {
      color(184, 215, 0),
      color(0, 181, 8),
      color(251, 81, 3),
      color(251, 153, 20),
      color(247, 221, 0),
      color(239, 192, 114),
      color(248, 238, 203),
      color(88, 206, 210),
      color(69, 1, 148),
    });
    list.add(new color[] {
      color(50,36,41),
      color(246,172, 213),
      color(248, 0, 106 ),
      color(121, 21, 145),
      color(96, 16, 185),
      color(72, 47, 174),
      color(234, 0, 169),
      color(1, 0, 0),
      color(97, 11, 200),
    });
    list.add(new color[] {
      color(253,0,255),
      color(253,255,0),
      color(0,255,56),
      color(0,249,255),
      color(60,0,255),
    });
    list.add(new color[] {
      color(0, 255, 255),
      color(255,155,141),
      color(255,0,243),
      color(170,0,255),
      color(0,46,255),
    });
    list.add(new color[] {
      color(1, 0, 0),
      color(0,255,210),
      color(0,186,163),
      color(86,255,182),
      color(81,81,81),
    });
    list.add(new color[] {
      color(180, 77, 202),
      color(248, 180, 250),
      color(100,0,151),
      color(78, 169, 246),
      color(223, 239, 253),
      color(11, 106, 186),
      color(108, 186, 129),
      color(190, 255, 227),
      color(0, 202, 96),
    });
    list.add(new color[] {
      color(166,124,0),
      color(191,155,48),
      color(255,191,0),
      color(255,207,64),
      color(255,220,115),
    });
    list.add(new color[] {
      color(255, 247, 103),
      color(146, 234, 176),
      color(87, 214, 231),
      color(146, 234, 176),
      color(255, 247, 103),
      color(247, 104, 168),
    });
    list.add(new color[] {
      color(255, 0, 255),
      color(0, 255, 255),
    });
    list.add(new color[] {
      color(156, 213, 48),
      color(85, 102, 53),
      color(54, 64, 33),
      color(3, 95, 87),
      color(0, 176, 171),
      color(147, 231, 224),
      color(216, 231, 230),
      color(222, 240, 202),
    });
    list.add(new color[] {
      color(126, 186, 186),
      color(126, 186, 186),
      color(76, 123, 139),
      color(76, 123, 139),
      color(178, 78,142),
      color(178, 78,142),
    });
    list.add(new color[] {
      color(43, 240, 252),
      color(105, 10, 255),
      color(0, 247, 222),
      color(51, 2, 174),
    });
    list.add(rainbowBWPalette());
    list.add(new color[] {
      color(1,0,0),
      color(250,0,0),
      color(250,0,0),
      color(240,0.86*255,0.65*255),
      color(250,0,0),
      color(250,0,0),
      color(1,0,0),
    });
    list.add(new color[] {
      #08F7FE,
      #09FBD3,
      #FE53BB,
      #F5D300,
    });
    list.add(new color[] {
      #FFACFC,
      #F148FB,
      #7122FA,
      #560A86,
    });
    list.add(new color[] {
      #75D5FD,
      #B76CFD,
      #FF2281,
      #011FFD,
    });
    list.add(new color[] {
      #FDC7D7,
      #FF9DE6,
      #A5D8F3,
      #E8E500,
    });
    list.add(new color[] {
      #00FECA,
      #FDF200,
      #FF85EA,
      #7B61F8,
    });
    list.add(new color[] {
      #FFD300,
      #DE38C8,
      #652EC7,
      #33135C,
    });
    list.add(new color[] {
      #3B27BA,
      #E847AE,
      #13CA91,
      #FF9472,
    });
    list.add(new color[] {
      #FFDEF3,
      #FF61BE,
      #3B55CE,
      #35212A,
    });
    list.add(new color[] {
      #FDD400,
      #FDB232,
      #02B8A2,
      #01535F,
    });
    list.add(new color[] {
      #FEC763,
      #EA55B1,
      #A992FA,
      #00207F,
    });
    list.add(new color[] {
      #79FFFE,
      #FEA0FE,
      #FF8B8B,
      #F85125,
    });
    list.add(new color[] {
      #CE96FB,
      #FF8FCF,
      #00C2BA,
      #037A90,
    });
    list.add(new color[] {
      #01FFC3,
      #01FFFF,
      #FFB3FD,
      #9D72FF,
    });
    list.add(new color[] {
      #A0EDFF,
      #EBF875,
      #28CF75,
      #FE6B35,
    });
    list.add(new color[] {
      #FFFF66,
      #FC6E22,
      #FF1493,
      #C24CF6,
    });
    list.add(new color[] {
      #D9EB4B,
      #00A9FE,
      #FD6BB6,
      #EF0888,
    });
    list.add(new color[] {
      #FFE3F1,
      #FE1C80,
      #FF5F01,
      #CE0000,
    });
    list.add(new color[] {
      #FEF900,
      #03DDDC,
      #FF822E,
      #F21A1D,
    });
    list.add(new color[] {
      #FCF340,
      #7FFF00,
      #FB33DB,
      #0310EA,
    });
    list.add(new color[] {
      #E92EFB,
      #FF2079,
      #440BD4,
      #04005E,
    });
    list.add(new color[] {
      color(25, 1, 26),
      color(1, 1, 1),
      color(130, 4, 178),
      color(200, 24, 201),
      color(7, 9, 27),
      color(252, 141, 35),
    });
    list.add(new color[] {
      color(22, 6, 23),
      color(231, 117, 179),
      color(132, 76, 127),
      color(252, 147, 191),
      color(180, 97, 154),
      color(9, 4, 23),
    });
    popStyle();
    return list;
  }
  
  color[] switchPalette(int n) {
    return getPalette(paletteDefs.get(n));
  }
  
}


//////////////////////////////////////////////
//smootherStep biz
//////////////////////////////////////////////
//OK, well, the problem with lerpColor is that it doesn't travel 
//the shortest distance on the colour wheel, it always goes clockwise.
//So 2 colours that are next to each other if they are in 
//counter clockwise order will give a rainbow gradient.
//so we use the "smootherStep" algorithm instead. 
//As per https://medium.com/@behreajj/color-gradients-in-processing-v-2-0-e5c0b87cdfd2

int composeclr(float[] in) {
  return composeclr(in[0], in[1], in[2], in[3]);
}

// Assumes that RGBA are in range 0 .. 1.
int composeclr(float red, float green, float blue, float alpha) {
  return round(alpha * 255.0) << 24
    | round(red * 255.0) << 16
    | round(green * 255.0) << 8
    | round(blue * 255.0);
}

// Assumes that out has 4 elements.
// 1.0 / 255.0 = 0.003921569
float[] decomposeclr(int clr) {
  float[] out = new float[] { 0.0, 0.0, 0.0, 1.0 };
  out[3] = (clr >> 24 & 0xff) * 0.003921569;
  out[0] = (clr >> 16 & 0xff) * 0.003921569;
  out[1] = (clr >> 8 & 0xff) * 0.003921569;
  out[2] = (clr & 0xff) * 0.003921569;
  return out;
}

float smootherStep(float st) {
  return st * st * st * (st * (st * 6.0 - 15.0) + 10.0);
}

float[] smootherStepRgb(float[] a, float[] b, float st) {
  float[] out = new float[4];
  float eval = smootherStep(st);
  out[0] = a[0] + eval * (b[0] - a[0]);
  out[1] = a[1] + eval * (b[1] - a[1]);
  out[2] = a[2] + eval * (b[2] - a[2]);
  out[3] = a[3] + eval * (b[3] - a[3]);
  return out;
}

color smootherStepC(color c1, color c2, float frac) {
  float[] c1f, c2f = new float[4];
  c1f = decomposeclr(c1);
  c2f = decomposeclr(c2);
  return composeclr(smootherStepRgb(c1f, c2f, frac));
}
//////////////////////////////////////////////
//end smootherStep biz
//////////////////////////////////////////////
