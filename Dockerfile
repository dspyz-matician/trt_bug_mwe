FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y git python3 python3-pip python3-tk
RUN pip install --ignore-requires-python torch==2.2.2+cu118 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install matplotlib onnx
RUN apt-get install -y python3-libnvinfer=8.6.1.6-1+cuda11.8 \
    libnvinfer8=8.6.1.6-1+cuda11.8 \
    libnvinfer-plugin8=8.6.1.6-1+cuda11.8 \
    libnvinfer-vc-plugin8=8.6.1.6-1+cuda11.8 \
    libnvparsers8=8.6.1.6-1+cuda11.8 \
    libnvonnxparsers8=8.6.1.6-1+cuda11.8

WORKDIR /root/app
