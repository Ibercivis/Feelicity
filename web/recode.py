#! /usr/bin/env python

# -*- coding: utf-8 -*-

import datetime
import os, shutil

import subprocess

def recode_files(path):
    for element in os.listdir(path):
        full_path = os.path.join(path, element)
        if os.path.isdir(full_path):
            recode_files(full_path)
        else:
            if full_path[-4:] == ".mp4":
                mp4_subprocess = subprocess.Popen(["HandBrakeCLI", "-v", "-i", full_path, "--preset=iPhone & iPod Touch", "-O", "-o", full_path + ".m4v"])
                mp4_subprocess.wait()
                os.rename(full_path + ".m4v", full_path)


recode_files(os.path.join(os.getcwd(), "tedx/public/files"))