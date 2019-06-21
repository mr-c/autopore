#Base images
FROM python:3.7-slim

#Constants
ARG NANOPOLISH_VERSION=0.11.1

#Setup
RUN apt-get update \
 && apt-get install -y git \
                       make \
                       wget \
                       build-essential \
                       libz-dev
RUN pip3 install biopython \
 && pip3 install pysam
 
#Set Workdir
WORKDIR /software

#Install nanopolish
RUN git clone --recursive https://github.com/jts/nanopolish.git
WORKDIR /software/nanopolish
RUN git checkout v${NANOPOLISH_VERSION}
RUN make
ENV PATH="/software/nanopolish:${PATH}"
ENV PATH="/software/nanopolish/scripts:${PATH}"
RUN chmod +x /software/nanopolish/nanopolish
RUN chmod +x /software/nanopolish/scripts/nanopolish_makerange.py

#Cleanup
RUN apt-get clean