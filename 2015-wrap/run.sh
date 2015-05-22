#!/bin/sh

ARG=$1

if test -z "$ARG"
then
    echo "need mode arg (run | emu | plot)"
    exit
fi
MODE="$ARG"


ITERS="10"
STEPS="10000 50000 100000 500000 1000000 5000000 10000000" 
PROBS="1"
SAMPLES="0.1 0.2 0.5 1 2 5 10"

if ! test -f /tmp/synapse_storage.in
then
    echo "creating tmp input"
    head -c 100000000 /dev/urandom > /tmp/synapse_storage.in
    echo "creating tmp input done"
fi


for iter in $ITERS
do
    for step in $STEPS
    do
        for prob in $PROBS
        do
            for sample in $SAMPLES
            do
                ./workflow.sh $MODE $iter $step $prob $sample
            done
        done
    done
done

