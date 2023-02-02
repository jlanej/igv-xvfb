FROM ubuntu:latest
# docker build -t igv-vm:latest .

WORKDIR /igv
RUN apt-get update 
RUN apt-get install -yq \
	wget \
	unzip \
	bash \
	xvfb \
	openjdk-11-jdk \
	fontconfig \
	git \

RUN git clone https://github.com/PankratzLab/igv-xvfb.git
RUN wget https://data.broadinstitute.org/igv/projects/downloads/2.10/IGV_Linux_2.10.3_WithJava.zip
RUN unzip IGV_Linux_2.10.3_WithJava.zip


# Set the Xvfb bash script as the entry point.
ENTRYPOINT ["/igv/run-xvfb-igv.sh"]

