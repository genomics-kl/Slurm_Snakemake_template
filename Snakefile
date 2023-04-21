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
        expand("analysis/hello_world/hello_world_{index}.txt", index=[1,2,3])


rule hello_world:
    """
	Hello world.
    """
    input:
        
    output:
        "analysis/hello_world/hello_world_{index}.txt"
    log:
        stdout="logs/hello_world/hello_world_{index}.o",
        stderr="logs/hello_world/hello_world_{index}.e",
    benchmark:
        "benchmarks/hello_world/hello_world_{index}.txt"
    params:
    threads: 1
    resources:
        mem_gb=8
    envmodules:
    shell:
        """
        for i in {{1..{wildcards.index}}}
        do
            echo `nproc` >> {output}
            echo "Hello world out"
            echo "Hello world err" 1>&2
        done
        """
