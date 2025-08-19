// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

include <./includes.scad>


// example key
// dcs_row(5) legend("⇪", size=9) key();

// example row
/* for (x = [0:1:4]) {
  translate_u(0,-x) dcs_row(x) key();
} */

// example layout
/* preonic_default("dcs") key(); */


  // cherry_row(x)
  // dcs_row(x)
  // dsa_row(x) // curve gets gentler at the top
  // dss_row(x) // curve gets gentler at the top
  // g20_row(x)
  // grid_row(x)
  // hex_row(x)
  // hipro_row(x) // curve gets gentler at the top
  // mt3_row(x)
  // oem_row(x)
  // sa_row(x) // curve gets gentler at the top


// legends = ["F1", "1", "q", "a", "z", "x"];
// for (x = [0:5]) {
//   translate_u(0,-x)

//   custom_row(x)
//   // frontside()



//   front_legend(legends[x], size=5)
//   {
//     // $stem_support_type = "disable";
//     // $dish_type = "disable";
//     $inset_legend_depth = 2;
//     $inset_legend_depth = 0;

//     /* $top_tilt = 30; */
//     union() {
//       key();
//     }
//   }
// }

row_distance = 0.6;

module key_total(key_legends, key_rows, key_fonts, key_size) {
  total = len(key_legends);
  root = ceil(sqrt(total));

  for (i = [0:total-1]) {
    x = i % root;
    y = floor(i / root) * row_distance;

    $inset_legend_depth = 0;
    
    translate_u(x, -y)
    custom_row(key_rows[i])
    frontside()
    front_legend(key_legends[i], size=key_size[i])
    key();
  }
}

module key_body(key_legends, key_rows, key_fonts, key_size) {
  total = len(key_legends);
  root = ceil(sqrt(total));

  layer_height = 0.2;
  face_layers = 3;
  transparent_layers = 10;

  transparent_height = (layer_height * face_layers) + (layer_height * transparent_layers / 2);
  transparent_thickness = layer_height * transparent_layers;

  $inset_legend_depth = layer_height * (face_layers + transparent_layers);

  for (i = [0:total-1]) {
    x = i % root;
    y = floor(i / root) * row_distance;
    
    translate_u(x, -y)

    difference() {
      custom_row(key_rows[i])
      frontside()
      front_legend(key_legends[i], size=key_size[i])
      key();
      
      // Subtract cube - adjust dimensions as needed
      translate([0, 0, transparent_height]) cube([$bottom_key_width, $bottom_key_height, transparent_thickness], center=true);
    }
  }
}

module key_legend(key_legends, key_rows, key_fonts, key_size) {
  difference() {
    key_total(key_legends, key_rows, key_fonts, key_size);
    key_body(key_legends, key_rows, key_fonts, key_size);
  }
}

/*

`~ 1! 2@ 3# 4$ 5% ESC ⌦ 6^ 7& 8* 9( 0) ⌫
TAB q w e r t -_ =+ y u i o p \|
⇪ a s d f g [{ ]} h j k l ;: '"
CTRL z x c v b HOME END n m ,< .> /? ⏎
⊞ ALT ⎵ ⇪ ⇪ ⎵ FN INS


*/

key_legends = [
  "`~",   "1!", "2@", "3#", "4$", "5%", "ESC",     "⌦", "6^", "7&", "8*", "9(", "0)", "⌫",
  "TAB",  "q",  "w",  "e",  "r",  "t", "-_",       "=+", "y", "u", "i", "o", "p", "\|",
  "⇪",    "a",  "s",  "d",  "f",  "g", "[{",       "]}", "h", "j", "k", "l", ";:", "'\"",
  "CTRL", "z",  "x",  "c",  "v",  "b", "HOME",     "END", "n", "m", ",<", ".>", "/?", "⏎",
                        "⊞", "ALT", "⎵", "⇪",      "⇪", "⎵", "FN", "INS",
];

key_rows = [
  1,1,1,1,1,1,1,    1,1,1,1,1,1,1,
  2,2,2,2,2,2,2,    2,2,2,2,2,2,2,
  3,3,3,3,3,3,3,    3,3,3,3,3,3,3,
  4,4,4,4,4,4,4,    4,4,4,4,4,4,4,
        2,2,2,2,    2,2,2,2,
];

c = "Consolas";

key_fonts = [
  c,c,c,c,c,c,c,    c,c,c,c,c,c,c,
  c,c,c,c,c,c,c,    c,c,c,c,c,c,c,
  c,c,c,c,c,c,c,    c,c,c,c,c,c,c,
  c,c,c,c,c,c,c,    c,c,c,c,c,c,c,
        c,c,c,c,    c,c,c,c,
];

key_size = [
  4,4,4,4,4,4,3,    5,4,4,4,4,4,5,
  3,5,5,5,5,5,4,    4,5,5,5,5,5,4,
  5,5,5,5,5,5,4,    4,5,5,5,5,4,4,
  3,5,5,5,5,5,3,    3,5,5,4,4,4,5,
        5,3,5,5,    5,5,3,3,
];

// Validate array lengths
assert(len(key_legends) == len(key_rows), "key_legends and key_rows must have the same length");
assert(len(key_legends) == len(key_fonts), "key_legends and key_fonts must have the same length");
assert(len(key_legends) == len(key_size), "key_legends and key_size must have the same length");

// key_legend(key_legends, key_rows, key_fonts);
key_body(key_legends, key_rows, key_fonts, key_size);
