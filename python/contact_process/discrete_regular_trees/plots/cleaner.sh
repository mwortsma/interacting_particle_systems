#!/bin/bash

for d in */ ; do
    cd $d
    rm local_cond.pkl  local_joint.pkl  local_joint_residual.pkl
    cd ..
done
