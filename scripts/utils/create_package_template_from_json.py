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
os.system(f"python ./scripts/utils/create_package_template.py --pkg_name '{pkg.get('pkg_name')}' --version '{pkg.get('version')}' --authors '{pkg.get('authors')}' --tool_name '{pkg.get('tool_name')}' --category '{pkg.get('category')}' --description '{pkg.get('description')}' --zip_url '{pkg.get('url')}' --zip_hash '{pkg.get('hash')}' --type '{pkg.get('type')}' --dependency '{pkg.get('dependency')}' --shim_path '{pkg.get('shim_path')}'")

# Print the package name so that we can use it from workflows/new_package.yml
print(pkg['pkg_name'])
