#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Basecalls raw ONT nanopore reads.
doc: |
  Uses guppy to perform basecalling on raw nanopore read data from experiments using 1d chemistry. Returns a single fastq file as well as a report. Either kit id and flowcell id OR custom config files OR config names have to be provided.

hints:
  SoftwareRequirement:
    packages:
      guppy:
        specs: [ https://community.nanoporetech.com/protocols/Guppy-protocol-preRev/v/gpb_2003_v1_revk_14dec2018/linux-guppy ] #Login credentials required.
        version: [ 3.3.0 ]

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  fast5_directory:
    label: Directory containing raw nanopore signal data in fast5 format.
    type: Directory
  worker_threads:
    label: Number of CPU-threads used in computationally intensive steps.
    type: int?
  flowcell_id:
    label: Identifier of flowcell used in nanopore experiment (e.g. FLO-MIN106).
    type: string?
  kit_id:
    label: Identifier of kit used in nanopore experiment (e.g. SQK-RBK004).
    type: string?
  config_file:
    label: A custom config file to control guppy parameters in detail.
    type: File?
  config_name:
    label: Name of one of guppys preset configs.
    type: string?    
  enable_adapter_trimming:
    label: Determines wether guppy will perform adapter trimming.
    type: string?

outputs:
  merged_reads:
    label: fastq file with all reads generated by basecaller.
    type: File
    outputSource: read_merging/merged_reads
  sequencing_summary:
    label: Summary of results as reported by basecaller.
    type: File
    outputSource: basecalling/sequencing_summary

steps:
  basecalling:
    label: Performs basecalling on nanopore signal data using ONTs guppy software
    run: guppyBasecallerTool.cwl
    in:
      fast5_directory: fast5_directory
      flowcell_id: flowcell_id
      kit_id: kit_id
      config_name: config_name
      config_file: config_file
      worker_threads: worker_threads
      enable_adapter_trimming: enable_adapter_trimming
    out: [array_of_reads, reads_directory, sequencing_summary, sequencing_telemetry]
  read_merging:
    label: Merges all reads generated by basecaller into a single file.
    run: ../misc/readMergingTool.cwl
    in:
      array_of_reads: basecalling/array_of_reads
      namesource_directory: fast5_directory
    out: [merged_reads]

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2018-07-18"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/version/latest/schema.rdf
  - http://edamontology.org/EDAM_1.20.owl
