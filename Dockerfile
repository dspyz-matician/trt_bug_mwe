FROM nvcr.io/nvidia/tensorrt:23.03-py3

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y python3-tk

RUN useradd -m me

USER me

RUN pip install matplotlib==3.7.5 torch==2.2.2 onnx==1.16.0

WORKDIR /home/me/app
