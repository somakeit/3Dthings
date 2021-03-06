#!/usr/bin/env python

# This one for now:  http://www.wickes.co.uk/Wickes-External-Wall-Grille-150mm/p/199815
# Maybe try this too: http://www.wickes.co.uk/Wickes-Hit+Miss-Vent-225-x-225mm/p/713014
# Even better: http://www.fantronix.com/acatalog/6--150mm--Cowled-Vent-Wind-Baffle-Grille.html

import svgwrite
from svgwrite import mm

MARGIN = 5 #mm
WINDOW_WIDTH    = 18 * 25.4  # mm
WINDOW_HEIGHT   = 12 * 25.4  # mm

CUTOUT_RADIUS   = 75.0 + 1.0  # mm
CUTOUT_AUTO_CENTRE = True
CUTOUT_CENTRE_X = 100.0 # mm
CUTOUT_CENTRE_Y = 100.0 # mm

STROKE_WIDTH    = 0.025 # mm

def window_vent(name):

    dwg = svgwrite.Drawing(name, ("500mm", "500mm"), debug = True)

    if CUTOUT_AUTO_CENTRE:
        centre_x = MARGIN + (WINDOW_WIDTH / 2)
        centre_y = MARGIN + (WINDOW_HEIGHT / 2)
    else:
        centre_x = CUTOUT_CENTRE_X
        centre_y = CUTOUT_CENTRE_Y
    
    dwg.add(dwg.rect((MARGIN * mm, MARGIN * mm),
                     (WINDOW_WIDTH * mm, WINDOW_HEIGHT * mm),
                     fill='none', stroke='black',
                     stroke_width = STROKE_WIDTH * mm))

    dwg.add(dwg.circle(center = (centre_x * mm, centre_y * mm),
                       r = CUTOUT_RADIUS * mm, fill = 'none', stroke = 'black',
                       stroke_width = STROKE_WIDTH * mm))
    dwg.save()


if __name__ == '__main__':
    window_vent('window_vent.svg')

