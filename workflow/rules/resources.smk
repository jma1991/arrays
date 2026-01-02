# Author: James Ashmore
# Copyright: Copyright 2020, James Ashmore
# Email: jma1991@icloud.com
# License: MIT

rule annotation:
    output:
        directory(expand("resources/bioconductor/annotation/lib/R/library/{annotation}", annotation = config["annotation"]))
    params:
        name = config["annotation"],
        path = lambda wc, output: Path(output[0]).parents[3]
    log:
        out = "logs/annotation.out",
        err = "logs/annotation.err"
    message:
        "Install annotation package: {params.name}"
    shell:
        "conda create --quiet --yes --prefix {params.path} --strict-channel-priority --override-channels --channel conda-forge --channel bioconda --channel defaults bioconductor-{params.name}=8.7.0 1> {log.out} 2> {log.err}"

rule organism:
    output:
        directory(expand("resources/bioconductor/organism/lib/R/library/{organism}", organism = config["organism"]))
    params:
        name = config["organism"],
        path = lambda wc, output: Path(output[0]).parents[3]
    log:
        out = "logs/organism.out",
        err = "logs/organism.err"
    message:
        "Install organism package: {params.name}"
    shell:
        "conda create --quiet --yes --prefix {params.path} --strict-channel-priority --override-channels --channel conda-forge --channel bioconda --channel defaults bioconductor-{params.name}=3.13.0 1> {log.out} 2> {log.err}"

rule platform:
    output:
        directory(expand("resources/bioconductor/platform/lib/R/library/{platform}", platform = config["platform"]))
    params:
        name = config["platform"],
        path = lambda wc, output: Path(output[0]).parents[3]
    log:
        out = "logs/platform.out",
        err = "logs/platform.err"
    message:
        "Install platform package: {params.name}"
    shell:
        "conda create --quiet --yes --prefix {params.path} --strict-channel-priority --override-channels --channel conda-forge --channel bioconda --channel defaults bioconductor-{params.name}=3.14.1 1> {log.out} 2> {log.err}"
