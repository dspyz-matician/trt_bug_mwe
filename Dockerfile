FROM nvcr.io/nvidia/tensorrt:23.03-py3

RUN apt-get update
RUN apt-get install -y python3-tk=3.8.10-0ubuntu1~20.04

RUN useradd -m me

USER me

RUN pip install matplotlib==3.7.5 torch==2.2.2 onnx==1.16.0

WORKDIR /home/me/app
