function printHeader(output_file) {
    print "#VRML V1.0 ascii" > output_file
    print "" > output_file
    print "Transform {" > output_file
    print "    children [" > output_file
    print "        Shape {" > output_file
    print "            appearance Appearance {" > output_file
    print "                material Material {" > output_file
    print "                    diffuseColor 1 0 0" > output_file
    print "                }" > output_file
    print "            }" > output_file
    print "            geometry IndexedFaceSet {" > output_file
    print "                coord Coordinate {" > output_file
    print "                    point [" > output_file
}

function printPointsFooter(output_file) {
    print "                    ]" > output_file
    print "                }" > output_file
    print "                coordIndex [" > output_file
}

function printCellsFooter(output_file) {
    print "                ]" > output_file
    print "            }" > output_file
    print "        }" > output_file
    print "    ]" > output_file
    print "}" > output_file
}

BEGIN { 
    output_file = ""
}

/DATASET UNSTRUCTURED_GRID/ {
    in_points = 1
}

in_points && /POINTS/ {
    if (output_file != "") {
        printCellsFooter(output_file)
        close(output_file)
    }
    output_file = FILENAME ".vrml"
    printHeader(output_file)

    num_points = $2
    for (i = 1; i <= num_points; i++) {
        getline
        print "                    " $1, $2, $3 "," > output_file
    }
    printPointsFooter(output_file)
    in_points = 0
}

/CELLS/ {
    in_cells = 1
}

in_cells && /CELLS/ {
    num_cells = $2
    for (i = 1; i <= num_cells; i++) {
        getline
        num_points_in_cell = $1
	printf "                    " > output_file
        for (j = 2; j <= num_points_in_cell + 1; j++) {
            printf "%s", $(j) > output_file
            if (j < num_points_in_cell + 1) {
                printf ", " > output_file
            } else {
                printf ", -1\n" > output_file
            }
        }
    }
    in_cells = 0
}

END {
    if (output_file != "") {
        printCellsFooter(output_file)
        close(output_file)
    }
}
