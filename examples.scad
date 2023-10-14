


/* Create a module and modify global variables from mtgorganizers.scad
 * to create custom sizes. For different cards just set cardWidth and cardHeight 
 * and everything else will scale accordingly
 */
module customSizes() {
    
    // Customize the sizes
    
    include <mtgorganizers.scad>;
    
    cardWidth=42;
    mtgOrganizerBox("rfc");
    
    cardHeight=68;
    translate([wallThickness*1.25, outerLength*.34, wallThickness])
        rotate([90,0,0])
            mtgDividers(text_str="Custom");
}
// customSizes();


/** Example of all the pieces, translated to see how they fit together */
module example() {
    
    include <mtgorganizers.scad>;
    
    mtgOrganizerBox("lfc"); // Left-Front-Corner
    translate([0, outerLength + 10, 0])mtgOrganizerBox("ls");  // Left-side
    translate([0, outerLength*2 + 20, 0])mtgOrganizerBox("lbc"); //Left-back-corner
    translate([outerWidth+10, 0, 0])mtgOrganizerBox("fm"); // Front-middle
    translate([outerWidth+10, outerLength + 10, 0])mtgOrganizerBox("mm"); // Middle-middle
    translate([outerWidth+10, outerLength*2 + 20, 0])mtgOrganizerBox("bm"); // Back-middle
    translate([outerWidth*2 + 20, 0, 0])mtgOrganizerBox("rfc"); // Right-front-corner
    translate([outerWidth*2 + 20, outerLength + 10, 0])mtgOrganizerBox("rs"); // right-side
    translate([outerWidth*2 + 20, outerLength*2 + 20, 0])mtgOrganizerBox("rbc"); // Right-back-corner

    // Divider with text and an image
    // Play with offsets to get the image right if the image isn't imported already centered.
    // Should work relatively nicely with SVG and STL files.
    translate([wallThickness*1.25, outerLength*.75, wallThickness])
        rotate([90,0,0])
            mtgDividers(image_file="logo.svg", text_str="jp-9 Printing", image_offset=[-3,-6,0]); 
    
    // Text Only Divider
    translate([wallThickness*1.25 + outerWidth + 10, outerLength*2.34, wallThickness])
        rotate([90,0,0])
            mtgDividers(text_str="Mythics");
}
// example();


/* Build each piece individually, parameters not included will 
 * revert to defaults for Magic the Gathering Cards
 */
use <mtgorganizers.scad>;
// mtgOrganizerBox("lbc", width=80, length=20, height=25, wall_thickness=1); custom sizing
mtgOrganizerBox(); // Defaults


