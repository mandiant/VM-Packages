#!/usr/bin/env python

"""Wrapper for 'create_package_template.py' that receives the arguments as a
   json string and prints the package name. This code could be integrated in
   'create_package_template.py'
"""

import json
import sys
import os

json_str = sys.argv[1]
pkg = json.loads(json_str)
os.system(f"python ./scripts/utils/create_package_template.py --pkg_name '{pkg['pkg_name']}' --version '{pkg['version']}' --authors '{pkg['authors']}' --tool_name '{pkg['tool_name']}' --category '{pkg['category']}' --description '{pkg['description']}' --zip_url '{pkg['url']}' --zip_hash '{pkg['hash']}' --type '{pkg['type']}'")

# Print the package name so that we can use it from workflows/new_package.yml
print(pkg['pkg_name'])
