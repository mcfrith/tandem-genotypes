from setuptools import setup
from os import path
import subprocess

here = path.abspath(path.dirname(__file__))

# Why is this so hard?
commitInfo = "$Format:%d$".strip("( )").split()
if "tag:" in commitInfo:
    version = commitInfo[commitInfo.index("tag:") + 1].rstrip(",")
else:
    args = "git", "-C", here, "describe", "--dirty"
    p = subprocess.Popen(args, stdout=subprocess.PIPE, universal_newlines=True)
    out, err = p.communicate()
    if p.returncode:
        raise subprocess.CalledProcessError(p.returncode, args)
    version = out.strip()

setup(
    name="tandem-genotypes",
    version=version,
    description='Find tandem repeat length changes, from "long" DNA reads aligned to a genome',
    long_description=open(path.join(here, 'README.md')).read(),
    long_description_content_type="text/markdown",
    url="https://github.com/mcfrith/tandem-genotypes",
    author="Martin C. Frith",
    author_email="mcfrith@gmail.com",
    classifiers=[
        'Intended Audience :: Science/Research',
        'Topic :: Scientific/Engineering :: Bio-Informatics',
        'License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)',
    ],
    scripts=[
        "tandem-genotypes",
        "tandem-genotypes-join",
        "tandem-genotypes-plot",
    ],
)
