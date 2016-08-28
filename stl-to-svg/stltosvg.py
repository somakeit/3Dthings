#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# @(#)stltosvg.py
#
# Copyright (c) 2016 Jeremy Reeve

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""stltosvg.py

This module allows one to provide an STL mesh file, process it as though
it were being sliced for 3D printing, select which of the pertinent layers
one is interested in and have the resultant SVG document post-processed
to ensure correct units are used on import by a vector graphics program
such as Inkscape. 

Example:

        $ python stltosvg.py --layer 3 mymodel.stl
#
# If no layer is specified then all pertinent layers are output to 
# separate files.
# 
#
"""

import argparse
import subprocess
import os.path
import sys

from lxml import etree

INTERMEDIATE_FILE_SUFFIX = 'all'
FILETYPE_SUFFIX = 'svg'
XML_NAMESPACE_SVG = {'svg' : 'http://www.w3.org/2000/svg'}

def main():
    parser = argparse.ArgumentParser(description='Convert STL to SVG document '
                                     'containing a single slice or layer of the'
                                     ' mesh.',
                                     epilog='''Example:

        $ python stltosvg.py --layer 3 mymodel.stl
''')
    parser.add_argument('inputfile', nargs=1,
                        help='input file')
    parser.add_argument('--layer', type=int, nargs='*', action='append',
                        help='which layer(s) to process')
    parser.add_argument('--version', action='version', version='%(prog)s 0.1')

    args = parser.parse_args()

    path, filename = os.path.split(args.inputfile[0])
    filenameroot, _ = os.path.splitext(filename)
    
    OUTPUT_FILENAME_FORMAT = '[input_filename_base].' \
                             + INTERMEDIATE_FILE_SUFFIX + '.' + FILETYPE_SUFFIX

    # The following is a bit dokey but necessary
    SVG_FILENAME_SLICED = os.path.join(path, filenameroot               \
                                       + '.' + INTERMEDIATE_FILE_SUFFIX \
                                       + '.' + FILETYPE_SUFFIX)
    
    try:
        completed = subprocess.run(['slic3r', '--output-filename-format',
                                    OUTPUT_FILENAME_FORMAT,
                                    '--export-svg', args.inputfile[0]],
                                   check=True)
    except subprocess.CalledProcessError as err:
        print("Problem slicing: ", str(err))
        sys.exit(1)
    
    try:
        with open(SVG_FILENAME_SLICED) as fp:
            all_layers_tree = etree.parse(fp)
            all_layers_svg = all_layers_tree.getroot()
            layers = all_layers_tree.xpath('/svg:svg/svg:g',
                                           namespaces=XML_NAMESPACE_SVG)
            

            for layer_group in layers:
                layer_id = layer_group.attrib['id']
                print('Processing: ', layer_id)

                #layer_tree.docinfo = all_layers_tree.docinfo
                #etree.register_namespace('xi', 'http://www.w3.org/2001/XInclude')

                svg_element = etree.Element('svg')

                for attrib_key, attrib_value in all_layers_svg.items():
                    svg_element.set(attrib_key, attrib_value)
                
                width = float(svg_element.attrib['width'])
                height = float(svg_element.attrib['height'])
                svg_element.attrib['width'] += 'mm'
                svg_element.attrib['height'] += 'mm'

                svg_element.set('viewBox', '0 0 ' + str(width) + ' ' \
                                + str(height))

                svg_element.append(layer_group)
                layer_tree = etree.ElementTree(svg_element)
                #create filename for individual layer file:
                SVG_FILENAME_LAYER = os.path.join(path, filenameroot        \
                                                  + '.' + layer_id          \
                                                  + '.' + FILETYPE_SUFFIX)
    
                with open(SVG_FILENAME_LAYER, 'wb') as lf:
                    layer_tree.write(lf)

                
    except EnvironmentError as err:
        print("Oh dear! ", str(err))
        sys.exit(1)



    

if __name__ == '__main__':
    main()
