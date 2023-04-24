import pandas as pd
import numpy as np
import os
import re
import itertools
from snakemake.utils import validate, min_version
##### set minimum snakemake version #####
min_version("6.15.0")

##### Editable variables #####

snakemake_dir = os.getcwd() + "/"

# make a tmp directory for analyses
tmp_dir = os.path.join(snakemake_dir, "tmp")
if not os.path.exists(tmp_dir):
    os.mkdir(tmp_dir)

rule all:
    input:
        expand("analysis/hello_world/hello_world_{index}_{barcode}.txt", index=[1,2,3], barcode=["foo"])


rule hello_world:
    """
	Hello world.
    """
    input:
        
    output:
        "analysis/hello_world/hello_world_{index}_{barcode}.txt"
    params:
    benchmark:
        "benchmarks/hello_world/hello_world_{index}_{barcode}.txt"
    threads: lambda wildcards: int(wildcards.index)
    resources:
        mem_gb=8
    envmodules:
    shell:
        """
        echo "Running proc results in `nproc`" > {output}

        for i in {{1..{wildcards.index}}}
        do
            echo "Hello" >> {output}
            echo "Hello world out"
            echo "Hello world err" 1>&2
        done
        """
