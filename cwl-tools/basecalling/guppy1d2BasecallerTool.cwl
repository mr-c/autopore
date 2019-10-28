#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: guppy_basecaller_1d2

doc: |
  This workflow employs ONTs guppy basecaller to perform 1D2 basecalling on a directory of .fast5-files with raw nanopore reads. Basecalling results are returned as an Array of .fastq-files and as a directory containing said files. Summary and telemetry files produced by guppy are returned as well. IMPORTANT: Either kit id and flowcell id OR custom config files OR config names have to be provided.

hints:
  DockerRequirement:
    dockerPull: genomicpariscentre/guppy:3.3.0
  SoftwareRequirement:
    packages:
      guppy:
        specs: [ https://community.nanoporetech.com/protocols/Guppy-protocol-preRev/v/gpb_2003_v1_revk_14dec2018/linux-guppy ] #Login credentials required.
        version: [ 3.3.0 ]

requirements:
  InlineJavascriptRequirement: {}

arguments:
  - valueFrom: "reads" #Name of output directory.
    prefix: --save_path
  - valueFrom: "1" #Every worker thread will run a seperate basecaller.
    prefix: --cpu_threads_per_caller
  - valueFrom: "--disable_pings" #Disable communication with ONT servers to circumvent increased runtime when servers cannot be reached.

inputs:
  fast5_directory:
    label: Directory containing nanopore signal data in fast5 format.
    type: Directory
    inputBinding:
      prefix: --input_path
  recursive_input_search:
    label: Determines wether guppy will recursively search the input directory for fast5 files.
    type: boolean
    default: true
    inputBinding:
      prefix: --recursive
  flowcell_id:
    label: Identifier of flowcell used in nanopore experiment (e.g. FLO-MIN106).
    type: string?
    inputBinding:
      prefix: --flowcell
  kit_id:
    label: Identifier of kit used in nanopore experiment (e.g. SQK-RBK004).
    type: string?
    inputBinding:
      prefix: --kit
  worker_threads:
    label: Determines number of basecallers to be run in parallel, each with one thread.
    type: int
    default: 1
    inputBinding:
      prefix: --num_callers
  config_file:
    label: A custom config file to control guppy parameters in detail.
    type: File?
    inputBinding:
      prefix: --config
  config_name:
    label: Name of one of guppys preset configs.
    type: string?
    inputBinding:
      prefix: --config
  enable_adapter_trimming:
    label: Determines wether guppy should perform adapter trimming.
    type: string
    default: "false"
    inputBinding:
      prefix: --trim_barcodes
  index_file:
    label: Sequencing summary generated by 1d basecaller
    type: File
    inputBinding:
      prefix: --index_file

outputs:
  array_of_reads:
    label: Array of all reads generated by guppy.
    type: File[]
    outputBinding:
      glob: $("reads/*.fastq")
  reads_directory:
    label: Directory containing all reads generated by guppy as well as sequencing summary and telemetry.
    type: Directory
    outputBinding:
      glob: reads
  sequencing_summary:
    label: Summary of results produced by guppy.
    type: File
    outputBinding:
      glob: reads/sequencing_summary.txt
  sequencing_telemetry:
    label: Telemetry data produced by guppy.
    type: File
    outputBinding:
      glob: reads/sequencing_telemetry.js

s:author:
  - class: s:Person
    s:email: mailto:tom.tubb@googlemail.com
    s:name: Tom Tubbesing
s:dateCreated: "2019-04-15"
s:license: "https://spdx.org/licenses/GPL-3.0-or-later.html"

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.20.owl
