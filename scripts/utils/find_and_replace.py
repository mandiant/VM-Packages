import os
import re
import subprocess
import sys


def replace_package_content(path, to_find, to_replace, file_exts=['nuspec', 'ps1', 'psm1']):
  for root, _, files in os.walk(path, topdown=True):
    for name in files:
      filepath = os.path.join(root, name)
      if filepath.split('.')[-1] not in file_exts:
        continue

      with open(filepath, 'r') as f:
        lines = f.readlines()

      for i in range(len(lines)):
        lines[i] = re.sub(to_find, to_replace, lines[i])

      with open(filepath, 'w') as f:
        f.writelines(lines)


def replace_filepaths(path, to_find, to_replace):
  for root, _, files in os.walk(path, topdown=True):
    for name in files:
      filepath = os.path.join(root, name)
      new_filepath = re.sub(to_find, to_replace, filepath)
      if new_filepath != filepath:
        cmd = 'git mv ' + filepath + ' ' + new_filepath
        subprocess.run(cmd.split())


def replace_dirpaths(path, to_find, to_replace):
  for root, _, _ in os.walk(path, topdown=True):
    new_dirpath = re.sub(to_find, to_replace, root)
    if new_dirpath != root:
      cmd = 'git mv ' + root + ' ' + new_dirpath
      subprocess.run(cmd.split())


def get_script_directory():
  path = os.path.realpath(sys.argv[0])
  if os.path.isdir(path):
    return path
  else:
    return os.path.dirname(path)


if __name__ == "__main__":
  root_dir = os.path.dirname(os.path.dirname(get_script_directory()))
  packages_path = os.path.join(root_dir, 'packages')
  replace_package_content(packages_path, '\.fireeye', '.vm')
  replace_package_content(packages_path, 'FireEye', 'Mandiant')
  replace_package_content(packages_path, 'FE-([a-zA-Z-]*)', r'VM-\1')
  replace_package_content(packages_path, 'FireEyeVM.common', 'vm.common')
  replace_package_content(packages_path, 'github\.com/fireeye', 'github.com/mandiant')
  replace_filepaths(packages_path, '(.*?).fireeye.nuspec', r'\1.vm.nuspec')
  replace_dirpaths(packages_path, '(.*?).fireeye', r'\1.vm')
