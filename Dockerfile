FROM nvidia/cuda:11.4.3-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y git python3 python3-pip python3-tk
RUN apt-get install -y python3-libnvinfer-dev=8.2.5-1+cuda11.4 \
    python3-libnvinfer=8.2.5-1+cuda11.4 \
    libnvinfer-dev=8.2.5-1+cuda11.4 \
    libnvinfer-plugin-dev=8.2.5-1+cuda11.4 \
    libnvparsers-dev=8.2.5-1+cuda11.4 \
    libnvonnxparsers-dev=8.2.5-1+cuda11.4 \
    libnvinfer8=8.2.5-1+cuda11.4 \
    libnvinfer-plugin8=8.2.5-1+cuda11.4 \
    libnvparsers8=8.2.5-1+cuda11.4 \
    libnvonnxparsers8=8.2.5-1+cuda11.4 \
    libcudnn8=8.2.4.15-1+cuda11.4 \
    libcudnn8-dev=8.2.4.15-1+cuda11.4

RUN useradd -m me

USER me

RUN pip install matplotlib onnx==1.16.0 polygraphy==0.49.0 onnxruntime==1.16.3
RUN pip install --ignore-requires-python torch==2.2.2+cu118 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install pycuda==2024.1

WORKDIR /home/me/app
