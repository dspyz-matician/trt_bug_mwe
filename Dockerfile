FROM nvidia/cuda:11.4.3-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y git python3 python3-pip python3-tk
RUN apt-get install -y python3-libnvinfer-dev=8.5.3-1+cuda11.8 \
    python3-libnvinfer=8.5.3-1+cuda11.8 \
    libnvinfer-dev=8.5.3-1+cuda11.8 \
    libnvinfer-plugin-dev=8.5.3-1+cuda11.8 \
    libnvparsers-dev=8.5.3-1+cuda11.8 \
    libnvonnxparsers-dev=8.5.3-1+cuda11.8 \
    libnvinfer8=8.5.3-1+cuda11.8 \
    libnvinfer-plugin8=8.5.3-1+cuda11.8 \
    libnvparsers8=8.5.3-1+cuda11.8 \
    libnvonnxparsers8=8.5.3-1+cuda11.8

RUN useradd -m me

USER me

RUN pip install --no-warn-script-location matplotlib onnx==1.16.0 polygraphy==0.49.0 onnxruntime==1.16.3 pycuda==2024.1
RUN pip install --ignore-requires-python --no-warn-script-location torch==2.2.2+cu118 -f https://download.pytorch.org/whl/torch_stable.html

WORKDIR /home/me/app
