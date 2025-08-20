// Test Unicode rendering with different fonts
fonts = ["Liberation Sans", "Noto Sans", "DejaVu Sans", "FreeSans", "Arial"];
symbols = ["⇪", "⌦", "⌫", "⏎", "⊞"];

for(i = [0:len(fonts)-1]) {
  for(j = [0:len(symbols)-1]) {
    translate([i*20, j*15, 0])
    text(symbols[j], font=fonts[i], size=8);
  }
}