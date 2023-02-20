# igv-xvfb
IGV with Xvfb

Build an IGV container with Xvfb and a script to perform graphics functions, such as snapshotting, from the command line without a display.

The docker container can be pulled and the make_igv_snapshots.sh script run from the command with a script similar to the following igv-snap.sh bash script, which was written to use Apptainer from a global scratch directory on a Linux HPC:

	 #!/bin/bash

	 #location of the apptainer oci cache
	SIF_CACHE=/the/path/to/your/apptainer/cache_dir/cache/oci-tmp

	 #where screenshots will be created
	snapshotDirectory=/scratch.global/where/to_put/the/igv/images

 	#where bam/vcf file defined in the .igv file are located
	bamDir=/scratch.global/directory/of/bam/files

 	#where bam/vcf file defined in the .igv file are located
	vcfDir=/scratch.global/directory/of/vcf/files

 	#Directory containing `.igv` files.
	igvScriptDir=/scratch.global/directory/of/igv/batch/files

 	#Make sure the APPTAINER_CACHEDIR variable is set.
 	if [ -z $APPTAINER_CACHEDIR ];
    		then CACHE_DIR=$HOME/.singularity/cache
    		else CACHE_DIR=$APPTAINER_CACHEDIR
		  fi		

 	#Make sure cache dir exists so lock file can be created by flock
	 mkdir -p $CACHE_DIR
	LOCK_FILE=$CACHE_DIR/singularity_pull_flock
	# Create an exclusive filelock with flock pull the container
	flock --exclusive --timeout 900 $LOCK_FILE \
		apptainer pull -F  ${SIF_CACHE}/igv-xvfb.sif docker://quay.io/lee04110/igv-xvfb
		apptainer exec --containall \
			       	-B /scratch.global \
				      -B ${snapshotDirectory}:/imageDir \
				      -B ${bamDir}:/bamDir \
				      -B ${vcfDir}:/vcfDir \
				      -B ${igvScriptDir}:/batchDir \
				      -B ${SIF_CACHE} \
			       	${SIF_CACHE}/igv-xvfb.sif \
			       	/usr/bin/xvfb-run /igv/igv-xvfb/make_igv_snapshots.sh

