#!/usr/bin/env python3
import os
import shutil

TERM_WIDTH, _ = os.get_terminal_size()

with open('dotfilelist', 'r') as dotfile_paths:
    for file_path in dotfile_paths:
        file_path = file_path.strip()
        dest_path = file_path.replace('~', './home')
        file_path = os.path.expanduser(file_path)
        print(f' [Copying {dest_path = }] '.center(TERM_WIDTH, '-'))
        print(f' [To {file_path = }] '.center(TERM_WIDTH, '-'))
        print('\n')
        shutil.copy(file_path, dest_path)
