#!/bin/bash
cd ../..
svn update
cd -
matlab -nodisplay -nosplash -nodesktop -r "run('./exp12_fw.m');exit;"
matlab -nodisplay -nosplash -nodesktop -r "run('./exp12_bw.m');exit;"
svn add *.mat
svn commit -m 'new results'
