
## radical.synapse Experiments

run experiments:
----------------

  - install gromacs 5.0.4
  - make sure that 'perf stat' can be executed by user
  - make sure 'perf stat' reports CPU cycles etc.
  - create Python virtualenv
  - install Synapse v0.10 
    - pip install radical.synapse==0.10
  - edit 'run.sh' 
    - adjust parameter space to scan (steps, smapling rates etc)
    - adjust path for storing data files (DBURL)
  - run 'run.sh pro' for profiling runs
  - run 'run.sh exe' for execution timings (w/o profiling)
  - run 'run.sh emu' for emulation runs

  - to add data from other hosts, 
    - first run profiling mode above
    - perform the same steps as above, but
      - no 'perf stat' support is needed
      - no profiling run is needed
      - before running the emulation, copy the data files from the original
        profiling host to the same (relative) location on the target host 
        (or use a mongodb url which is accessible by noth hosts)


create plots:
-------------

  - cd plots
  - run 'ipython notebook'
  - open the 'Synapse_WRAP.ipynb' notebook
  - make sure the first cell loads the required modules and shows the expected
    synapse version
  - asjust the path to the data files in cell two
  - run all cells
  - plots will be stored in '/plots/'


