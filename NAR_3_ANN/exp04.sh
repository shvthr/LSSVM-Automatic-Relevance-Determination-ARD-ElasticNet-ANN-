#!/bin/bash
cd ../..
svn update
cd -
matlab -nodisplay -nosplash -nodesktop -r "run('./exp04_scr.m');exit;"
svn add *.mat
svn commit -m 'new results'
