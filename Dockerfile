FROM nvidia/cuda:12.3.2-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y git python3 python3-pip python3-tk
RUN pip install matplotlib
RUN pip install torch==2.2.2
RUN apt-get install -y python3-libnvinfer-dev=10.0.0.6-1+cuda12.4

WORKDIR /root/app
