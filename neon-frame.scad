height = 9;
n_grid_rows = 2;
n_grid_cols = 2;
grid_size = 190;
thinwall = 1.14;


module drawGrid(gridSize, wallCount, wallWidth, wallHeight) {
    // Calculate the spacing between walls based on the grid size and wall count
    spacing = (gridSize - wallWidth) / (wallCount + 1);
    
    // Draw vertical walls
    for (i = [0 : wallCount + 1]) {
        translate([i * spacing, 0, 0])
        cube([wallWidth, gridSize, wallHeight], false);
    }

    // Draw horizontal walls
    for (j = [0 : wallCount + 1]) {
        translate([0, j * spacing, 0])
        cube([gridSize, wallWidth, wallHeight], false);
    }
}

module draw_kerf(grid_size, wall_height, kerf) {
    translate([grid_size/2, grid_size/2, wall_height/2])
    difference() {
        cube([grid_size + 2*kerf, grid_size + 2*kerf, wall_height + 0.1], true);
        cube([grid_size, grid_size, wall_height+0.2], true);
    }
}


difference(){
    union(){
        for (row = [0:n_grid_rows - 1]) {
            for (col = [0:n_grid_cols - 1]) {
                translate([grid_size * row, grid_size * col, 0])
                drawGrid(grid_size, 3, thinwall, height);
            }
        }
        
        linear_extrude(height = height)
        offset(r=thinwall)
        import("pattern_path.svg");
        
    };
    
    union(){
        for (row = [0:n_grid_rows - 1]) {
            for (col = [0:n_grid_cols - 1]) {
                translate([grid_size * row, grid_size * col, 0])
                draw_kerf(grid_size, height+0.1, 0.1);
            }
        }

        translate([0,0,0.70])
        linear_extrude(height = height)
        import("pattern_path.svg");
    }
}

//!draw_kerf(grid_size, height, 0.5);
//minkowski(){
//    import("pattern.svg");
//    circle(r=2);
//}