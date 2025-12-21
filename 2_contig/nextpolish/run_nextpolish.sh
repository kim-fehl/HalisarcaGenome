#!/bin/bash
export PYTHONPATH=${PYTHONPATH}:/home/vasiliy_zubarev/software/paralleltask
export PATH=${PATH}:/home/vasiliy_zubarev/software/minimap2/
/home/vasiliy_zubarev/software/NextPolish/nextPolish ./run.cfg 1> ./nextpolish.log 2> ./nextpolish.err
