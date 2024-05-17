#!/usr/bin/env python3
# a reference to openscad must exist
# sudo ln -sf /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD /usr/local/bin/openscad

import subprocess
import math
import time

# render the stl
def render():
	# render each part in a thread, so it all goes faster
	print('Starting render')
	start = time.time()

	scad = []
	scad.append(subprocess.Popen(['openscad','-DHEIGHT=10','-DANG=0','-DSIDE="left"','riser.scad','-o','riser-10mm-00deg-left.stl']))
	scad.append(subprocess.Popen(['openscad','-DHEIGHT=10','-DANG=0','-DSIDE="right"','riser.scad','-o','riser-10mm-00deg-right.stl']))

	scad.append(subprocess.Popen(['openscad','-DHEIGHT=5','-DANG=5','-DSIDE="left"','riser.scad','-o','riser-05mm-05deg-left.stl']))
	scad.append(subprocess.Popen(['openscad','-DHEIGHT=5','-DANG=5','-DSIDE="right"','riser.scad','-o','riser-05mm-05deg-right.stl']))

	scad.append(subprocess.Popen(['openscad','-DHEIGHT=10','-DANG=5','-DSIDE="left"','riser.scad','-o','riser-10mm-05deg-left.stl']))
	scad.append(subprocess.Popen(['openscad','-DHEIGHT=10','-DANG=5','-DSIDE="right"','riser.scad','-o','riser-10mm-05deg-right.stl']))

	# wait for all threads to finish, so we know we're done
	for p in scad:
		p.wait()

	elapsed = round(time.time() - start, 1)
	print('Rendering done in', elapsed, 'seconds!')

def main():
	render()

main()