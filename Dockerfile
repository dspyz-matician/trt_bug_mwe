FROM nvidia/cuda:12.3.2-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y git python3 python3-pip python3-tk
RUN apt-get install -y python3-libnvinfer-dev=10.0.0.6-1+cuda12.4

RUN useradd -m me

USER me

RUN pip install matplotlib torch==2.2.2 onnx==1.16.0
RUN pip install polygraphy==0.49.0
RUN pip install onnxruntime==1.17.1

WORKDIR /home/me/app
