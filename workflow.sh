#!/bin/sh 

MODE=$1
ITER=$2
STEP=$3
PROB=$4
RATE=$5

test -z "$MODE" && MODE='help'
test -z "$STEP" && STEP=0
test -z "$PROB" && PROB=0
test -z "$RATE" && RATE=1       # 1 sample/sec

ORIG="`pwd`"

export RADICAL_SYNAPSE_SAMPLERATE=$RATE
export EXPERIMENT=synapse_s${STEP}_p${PROB}_r${RATE}
export RADICAL_SYNAPSE_TAGS="prob:$PROB,step:$STEP,rate:$RATE"
export RADICAL_SYNAPSE_DBURL=mongodb://54.221.194.147:24242/$EXPERIMENT
export RADICAL_SYNAPSE_DBURL=mongodb://localhost/$EXPERIMENT
export RADICAL_SYNAPSE_DBURL=file://localhost/$ORIG/data/$EXPERIMENT

export RADICAL_SYNAPSE_DBURL="`echo $RADICAL_SYNAPSE_DBURL | tr '.' '_'`"

echo "mode : $MODE"
echo "iter : $ITER"
echo "step : $STEP"
echo "prob : $PROB"
echo "rate : $RATE"
echo "tags : $RADICAL_SYNAPSE_TAGS"
echo "dburl: $RADICAL_SYNAPSE_DBURL"


# ------------------------------------------------------------------------------
#
if test "$MODE" = "help"
then
    echo "$0 <mode> [ITER] [STEP] [PROB] [RATE]"
    exit
fi


# ------------------------------------------------------------------------------
#
if test "$MODE" = "exe"
then

    i=0
    while ! test $i = $ITER
    do
        i=$(( i+1 ))
        echo "executing $i ($ITER) - `date`"

        cd       $ORIG
        rm   -rf $EXPERIMENT/
        mkdir -p $EXPERIMENT/
        cd       $EXPERIMENT/
      # ln    -s ../rawdata/* .
        
        rm -f start_tmp.gro
        p=0
        while ! test $p = $PROB
        do
            p=$((p+1))
            cat ../rawdata/start.gro  | sed "1"','"25"'!d' >> start_tmp.gro
        done

        cat ../rawdata/grompp.mdp | sed -e "s/###STEP###/$STEP/g" > grompp.mdp
        cat ../rawdata/topol.top  > topol.top
        
        grompp  \
                \
               -f  grompp.mdp \
               -p  topol.top \
               -c  start_tmp.gro \
               -o  topol.tpr \
               -po mdout.mdp > log 2>&1

        radical-synapse-execute \
            mdrun  \
               -nt 1 \
               -o traj.trr \
               -e ener.edr \
               -s topol.tpr \
               -g mdlog.log \
               -cpo state.cpt \
               -c outgro >> log 2>&1

        echo "          $i ($ITER) - `date`"

    done

    exit
fi


# ------------------------------------------------------------------------------
#
if test "$MODE" = "pro"
then

    i=0
    while ! test $i = $ITER
    do
        i=$(( i+1 ))
        echo "profiling $i ($ITER) - `date`"

        cd       $ORIG
        rm   -rf $EXPERIMENT/
        mkdir -p $EXPERIMENT/
        cd       $EXPERIMENT/
      # ln    -s ../rawdata/* .
        
        rm -f start_tmp.gro
        p=0
        while ! test $p = $PROB
        do
            p=$((p+1))
            cat ../rawdata/start.gro  | sed "1"','"25"'!d' >> start_tmp.gro
        done

        cat ../rawdata/grompp.mdp | sed -e "s/###STEP###/$STEP/g" > grompp.mdp
        cat ../rawdata/topol.top  > topol.top
        
        grompp  \
                \
               -f  grompp.mdp \
               -p  topol.top \
               -c  start_tmp.gro \
               -o  topol.tpr \
               -po mdout.mdp > log 2>&1

        radical-synapse-profile \
            mdrun  \
               -nt 1 \
               -o traj.trr \
               -e ener.edr \
               -s topol.tpr \
               -g mdlog.log \
               -cpo state.cpt \
               -c outgro >> log 2>&1

        echo "          $i ($ITER) - `date`"

    done

    exit
fi


# ------------------------------------------------------------------------------
#
if test "$MODE" = "emu"
then

    i=0
    while ! test $i = $ITER
    do
        i=$(( i+1 ))
        echo "emulating $i ($ITER) - `date`"

        cd $ORIG

        radical-synapse-emulate \
            mdrun  \
               -nt 1 \
               -o traj.trr \
               -e ener.edr \
               -s topol.tpr \
               -g mdlog.log \
               -cpo state.cpt \
               -c outgro >> log 2>&1

        echo "          $i ($ITER) - `date`"

    done

    exit
fi


# ------------------------------------------------------------------------------
#
if test "$MODE" = "plot"
then

    echo "plotting $SYNAPSE_DURL - `date`"

    for flag in '-p' '-e'
    do
        echo $RADICAL_SYNAPSE_DBURL
        cmd="mdrun -nt 1 -o traj.trr -e ener.edr -s topol.tpr -g mdlog.log -cpo state.cpt -c outgro"
        cd $ORIG/plots/
        radical-synapse-stats -m plot -x "$cmd" $flag
        cd $ORIG
    done
    
    exit
fi


# ------------------------------------------------------------------------------
#
echo "unknown mode $MODE"
exit 1

