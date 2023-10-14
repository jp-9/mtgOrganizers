/*
Use this library to create modular card organizers
                    
                 -- +-----------+
  wallThickness -- / +------+  /|
                  / /      /  / | outerHeight
                 / +------+  /  |
                +-----------+   +       -
                |           |  /( )    /
                |           | /  ^    / outerLength
                +-----------+    |   -
                 outerWidth      |
                                Lock
                                
  tabThickness    +----------------+        +          
            \    +----------------+|        |
             \   |   Description  ||        |
       t      \  |                ||    -   | b
       a       \ |                ||    | c | a
       b  +--   /|                |+-+  | a | c
       D  |    +-+                +-+|  | r | k
          |    |                    ||  | d | H
       e  |    |_                   |+  | H | e
       p  +--  +-+                +-+   | e | i 
       t       / |                ||    | i | g
       h      /  |                ||    | g | h
             /   |                ||    | h | t
            /    |                ||    | t |
        tabWidth |                |+    |   |
                 +----------------+     -   -        
                 |--dividerWidth--|
          
          
          
      |---------------------outerLength-----------------| 
      
      +-----------------+---+----------+---+-------------+   -
     /                 +---+          +---+             /|   |
    +-----------------+|  +----------+|  +-------------+ |   |
    |                 ||  |          ||  |\            | |   |
    |               _ |+--|          |+--| |           | |   | outerHeight
    |  notchWidth /_  +---+          +---+ | --> notchDepth  |
    |                 |___|               \|           | |   |
   ...            notchThickness                      ..... ...
*/

/* Parameters for Card Dividers */
cardHeight = 89; // Height of a magic card, tab titles will be above
cardWidth = 68; // mm


/* Outer dimensions of the box*/
wallThickness = 2.5; // mm
outerLength = 115; // mm, adjust this value as per your requirement
// mm, set to the width of the card + a buffer + 2 * wallThickness
outerWidth = cardWidth + 2 + wallThickness*2; 
outerHeight = 50; // mm, adjust this value as per your requirement
lockRadius = 5;  // Lock shouldn't be any smaller than five

/* Functions for generating size of divider notches */
function tabSymbolHeight(back_height, ch=cardHeight) = back_height - ch - 4; 
function tabSymbolExtrude(t=wallThickness) = t+1;
function tabSymbolMargin() = 1;
function dividerWidth(w=outerWidth, t=wallThickness) = (w - (t * 2)) *.98;
function notchDepth(h=outerHeight) = h*0.2; // 20% of the height of the walls 
function notchThickness(t=wallThickness) = t*1.1;
function notchWidth(t=wallThickness) = t*.5;
function tabThickness(t=wallThickness) = t*.95;
function tabWidth(w=outerWidth, t=wallThickness) = (w-dividerWidth(w, t)- notchWidth(t)*2)*.95/2;
function tabDepth(h=outerHeight) = notchDepth(h);


module mtgOrganizerBox(
    piece="lfc",
    width=outerWidth, 
    length=outerLength,
    height=outerHeight,
    wall_thickness=wallThickness,
    lock_radius=lockRadius
) {
    

    
    module _lock(thickness=wall_thickness) {
        linear_extrude(thickness)
            circle(lock_radius);
    }
    module _lockRight() {
        translate([width+lock_radius*0.7, length/2, 0])
            _lock();
    }
    module _lockLeft(thickness=wall_thickness+2) {  
        // Extra thickness added and locks translated so difference goes all the way through
        translate([lock_radius*0.7, length/2, -1])
            _lock(thickness=thickness);
    }
    module _lockBack() {   
        translate([width/4, length + lock_radius*.7, 0])
            _lock(); 
        translate([width/4*3, length + lock_radius*.7, 0])
            _lock(); 
    }
    module _lockFront(thickness=wall_thickness+2) {
        // Extra thickness added and locks translated so difference goes all the way through
        translate([width/4, lock_radius*0.7, -1])
            _lock(thickness=thickness); 
        translate([width/4*3, lock_radius*0.7, -1])
            _lock(thickness=thickness); 
    }
    
    module _roundedRectangle(length, 
                             width, 
                             cornerRadius=5, 
                             wall_thickness=wallThickness) {
        // Corners
        translate([cornerRadius, cornerRadius, 0])
            linear_extrude(wall_thickness)circle(r=cornerRadius);
        translate([length - cornerRadius, cornerRadius, 0])
            linear_extrude(wall_thickness)circle(r=cornerRadius);
        translate([cornerRadius, width - cornerRadius, 0])
            linear_extrude(wall_thickness)circle(r=cornerRadius);
        translate([length - cornerRadius, width - cornerRadius, 0])
            linear_extrude(wall_thickness)circle(r=cornerRadius);
    
        // Edges
        hull() {
            translate([cornerRadius, cornerRadius, 0])
                linear_extrude(wall_thickness)circle(r=cornerRadius);
            translate([length - cornerRadius, cornerRadius, 0])
                linear_extrude(wall_thickness)circle(r=cornerRadius);
        }
        hull() {
            translate([cornerRadius, width-cornerRadius, 0])
                linear_extrude(wall_thickness)circle(r=cornerRadius);
            translate([length - cornerRadius, width-cornerRadius, 0])
                linear_extrude(wall_thickness)circle(r=cornerRadius);
        }
        hull() {
            translate([cornerRadius, cornerRadius, 0])
                linear_extrude(wall_thickness)circle(r=cornerRadius);
            translate([cornerRadius, width - cornerRadius, 0])
                linear_extrude(wall_thickness)circle(r=cornerRadius);
        }
        hull() {
            translate([length-cornerRadius, cornerRadius, 0])
                linear_extrude(wall_thickness)circle(r=cornerRadius);
            translate([length-cornerRadius, width - cornerRadius, 0])
                linear_extrude(wall_thickness)circle(r=cornerRadius);
        }
        
        // Middle
        translate([cornerRadius/2, cornerRadius/2, 0])cube([length-cornerRadius, width-cornerRadius, wall_thickness]);
    }
    
    
    module _boxBase() {
                        
        watermark_margin = min(min(length, width),50) *.1; // Keep the margins even
        watermark_scale = min(min(length, width),50) * .35; // Scale with smallest dimension, but limit to 50mm * 0.35
                
        difference() {
            cube([width, length, wall_thickness]);
            
            translate([
                (watermark_margin)+(watermark_scale),
                (watermark_margin),
                (-wall_thickness+.5)
            ])
                resize([watermark_scale, 0,0],[false, true, false])
                    linear_extrude(wall_thickness)
                        mirror([1,0,0])
                            import("logo.svg");
        }
        
    }
    
    module _notch() {
        translate([
            notchWidth(t=wall_thickness), 
            wall_thickness,
            height - notchDepth(h=height)
        ])
            cube([
                wall_thickness, 
                notchThickness(t=wall_thickness), 
                notchDepth(h=height)+1
            ]);
    }
    module _bunchOfNotches() {
        gap_length = notchThickness(t=wall_thickness)*5;
        iterations = max(length/gap_length, 1) - 1;
        for (i = [0:iterations]) {
            translate([0,gap_length*i,0])
                _notch();
        }
    }
    module _boxNotchedSide(){
        difference() {
            cube([wall_thickness, length, height]);
            _bunchOfNotches();
        }
    }
    
    module _boxSides() {
        _boxNotchedSide();
                         
        translate([width,0,0])
            mirror([1,0,0])
                _boxNotchedSide();
    }
    
    module _boxBack() {    
        difference() {
            cube([width, wall_thickness, height]);
            translate([width*0.2, wall_thickness+1, height*0.3])
                rotate([90,0,0])
                    _roundedRectangle(
                        length=width*.6, 
                        width=height, 
                        cornerRadius=10,
                        wall_thickness=wall_thickness+2
                    );
        }
    }
    
    module _sideBox() {
        _boxBase();
        _boxSides();
    }
    
    module _endBox() {
        _sideBox();
        _boxBack();
    }
    
    module leftFrontCornerBox() {
                            
        _endBox();
        _lockRight();
        _lockBack();
         
    }
    
    module leftSideBox() {
        difference() {
            _boxBase();
            _lockFront();
        }
        _lockRight();
        _boxSides();
        _lockBack();
    }
    
    module _flippedEndBox(){
        translate([0, length, 0])
            mirror([0, 1, 0])
                _endBox();
    }
    
    module leftBackCornerBox() {
        difference() {
            _flippedEndBox();
            _lockFront();
        };   
        _lockRight();
    }
    
    module frontMiddleBox(){
        difference() {
            _endBox();
            _lockLeft(thickness=wall_thickness+1.01);
        }
        _lockBack();
        _lockRight();
    
    }
    
    module middleMiddleBox() {
        difference() {
            difference() {
                _sideBox();
                _lockLeft(thickness=wall_thickness+1.01);
            };
            _lockFront();
        }
        _lockBack();
        _lockRight();
    }
    
    module backMiddleBox() {
        difference() {
            difference() {
                _flippedEndBox();
                _lockLeft(thickness=wall_thickness+1.01);
            };
            _lockFront();
        }
        _lockRight();
    }
    
    module rightFrontCornerBox() {
        difference() {
            _endBox();
            _lockLeft(thickness=wall_thickness+1.01);
        }
        _lockBack();
    }
    
    module rightSideBox() {
        difference() {
            difference() {
                _sideBox();
                _lockLeft(thickness=wall_thickness+1.01);
            }
            _lockFront();
        }
        _lockBack();
    }
    
    module rightBackCorner() {
        difference() {
            difference() {
                _flippedEndBox();
                _lockLeft(thickness=wall_thickness+1.01);
            }
            _lockFront();
        }
    }
    
    if (piece == "lfc") {
        // Left-Front-Corner
        leftFrontCornerBox();
    } else if (piece == "ls") {
        // Left-Side
        leftSideBox();
    } else if (piece == "lbc") {
        // Left-Back-Corner
        leftBackCornerBox();
    } else if (piece == "fm") {
        // Front-Middle
        frontMiddleBox();
    } else if (piece == "mm") {
        middleMiddleBox();
    } else if (piece == "bm") {
        // Back-Middle
        backMiddleBox();
    } else if (piece == "rfc") {
        // Right-Front-Corner
        rightFrontCornerBox();
    } else if (piece == "rs") {
        // Right-Side
        rightSideBox();
    } else if (piece == "rbc") {
        // Right-Back-Corner
        rightBackCorner();
    }
    
}

module mtgDividers(
    width=outerWidth,
    height=outerHeight,
    card_height=cardHeight,
    wall_thickness=wallThickness,
    text_str="",
    image_file="",
    image_offset=[0,0,0],
) {
    
    back_height=cardHeight+11;
    
    module tab() {
        cube(
            [
                dividerWidth(w=width, t=wall_thickness),
                back_height,
                wall_thickness
            ]
        );
        
        translate([
            -tabWidth(width,wall_thickness), 
            height - wall_thickness - notchDepth(), 
            0
        ])
            cube([
                tabWidth(width, wall_thickness)*2 + dividerWidth(width, wall_thickness),
                tabDepth(height), 
                tabThickness(wall_thickness)]
            );
    }
    
    module text_tab() {
        
        font_size = tabSymbolHeight(back_height, card_height);   
        
        tab();
        
        linear_extrude(tabSymbolExtrude(wall_thickness))
            translate([
                dividerWidth(width, wall_thickness) - 1, 
                back_height - font_size - 1, 
                0
            ])
                text(
                    text_str, 
                    size=font_size, 
                    font="Uechi:style=Gothic", 
                    halign ="right"
                ); 
        
    }
    
    module symbolImage(filename) {
        translate([
            tabSymbolHeight(back_height, card_height) / 2, 
            tabSymbolHeight(back_height, card_height) / 2, 
            0
        ])
            resize(
                newsize=[
                    tabSymbolHeight(back_height, card_height), 
                    0, 
                    tabSymbolExtrude(wall_thickness)-wall_thickness
                ], 
                auto=[false, true,false]
            )
                import(filename, 3);
    }
    
    module logo_tab() {
        
        
        logo_placemant_width=
            dividerWidth(width, wall_thickness) 
            - tabSymbolMargin() 
            - tabSymbolHeight(back_height, card_height); // scaling based on height
            
        
        logo_placement_height=
            back_height 
            - tabSymbolMargin() 
            - tabSymbolHeight(back_height, card_height); // Scaling based on height
        
        tab();
        
        linear_extrude(tabSymbolExtrude(wall_thickness))
            translate([
                logo_placemant_width - tabSymbolMargin()*2,
                logo_placement_height, 
                0
            ])
            text(
                text_str, 
                size=tabSymbolHeight(back_height, card_height), 
                font="Uechi:style=Gothic", 
                halign ="right"
            );
        
        translate([
            logo_placemant_width - tabSymbolMargin() + image_offset[0], 
            logo_placement_height + image_offset[1], 
            wall_thickness+image_offset[2]
        ])
            symbolImage(image_file);
    }
    
    if (text_str!="" && image_file=="") {
        text_tab();
    } else if (image_file !="") {
        logo_tab();
    } else {
        tab();
    }
}


