#!/bin/bash
#
# Script to print out the parts for the riser, left and right sides, to STL files
#
# a reference to openscad must exist
# sudo ln -sf /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD /usr/local/bin/openscad
#
echo "exporting parts from openscad to stl"
openscad --version
openscad -D 'part=1' -D 'side="left"' -o riser-left.stl riser.scad 
openscad -D 'part=2' -D 'side="right"' -o riser-right.stl riser.scad 