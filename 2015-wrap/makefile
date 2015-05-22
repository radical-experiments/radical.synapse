
run:
	mkdir -p run_0000/; \
	cd       run_0000/; \
	ln    -s ../rawdata/* . ; \
	python ../run.py --mdp grompp.mdp --gro start.gro --top topol.top --out out.gro

clean:
	cd run_0000/; \
	rm -v *_000* out.gro

