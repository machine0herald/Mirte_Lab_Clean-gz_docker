#!/usr/bin/env python3
"""
Generate README.md and docs placeholders for ROS packages under src/.

This script scans for package.xml files and creates lightweight
documentation placeholders (README.md, docs/quickstart.md, examples/usage.md)
when they are missing. It will not modify source code files.
"""
import os
import xml.etree.ElementTree as ET
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'src'


def find_packages(src_dir):
    for dirpath, dirs, files in os.walk(src_dir):
        if 'package.xml' in files:
            yield Path(dirpath)


def read_package_name(package_xml_path):
    try:
        tree = ET.parse(package_xml_path)
        root = tree.getroot()
        name = root.find('name')
        if name is not None and name.text:
            return name.text.strip()
    except Exception:
        pass
    return None


README_TMPL = """# {pkg_name}

Short description: TODO — add a short description of the package.

## Contents
- Package: {pkg_name}
- Path: `{pkg_path}`

## Quickstart
1. Source your workspace: `source /opt/ros/<distro>/setup.bash && source install/setup.bash`
2. Build (if needed): `colcon build --packages-select {pkg_name}`
3. Run examples in `examples/` or `launch/`.

## Documentation
- Quickstart / tutorial: `docs/quickstart.md`
- Examples: `examples/usage.md`

## Notes
- This README was generated automatically. Please replace placeholders with package-specific information.
"""

QUICKSTART_TMPL = """# Quickstart for {pkg_name}

This quickstart explains common usage for the `{pkg_name}` package.

## Run (example)
Add any example commands to run nodes or launch files here. Example:

```
# ros2 launch {pkg_name} example.launch.py
```

## Configuration
Document configuration files, parameters, and environment variables.
"""

EXAMPLE_TMPL = """# Examples for {pkg_name}

Describe example use-cases and how to run them.

### Example 1: Minimal run

```
# Example command
```
"""


def write_if_missing(path: Path, content: str):
    if path.exists():
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding='utf-8')
    return True


def main():
    created = []
    for pkg_dir in find_packages(SRC):
        pkg_xml = pkg_dir / 'package.xml'
        pkg_name = read_package_name(pkg_xml) or pkg_dir.name
        readme_path = pkg_dir / 'README.md'
        docs_quick = pkg_dir / 'docs' / 'quickstart.md'
        examples_usage = pkg_dir / 'examples' / 'usage.md'

        if write_if_missing(readme_path, README_TMPL.format(pkg_name=pkg_name, pkg_path=str(pkg_dir))):
            created.append(str(readme_path))
        if write_if_missing(docs_quick, QUICKSTART_TMPL.format(pkg_name=pkg_name)):
            created.append(str(docs_quick))
        if write_if_missing(examples_usage, EXAMPLE_TMPL.format(pkg_name=pkg_name)):
            created.append(str(examples_usage))

    if created:
        print('Created files:')
        for p in created:
            print(' -', p)
    else:
        print('No files created; all packages already have docs placeholders.')


if __name__ == '__main__':
    main()
