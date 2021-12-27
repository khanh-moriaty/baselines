FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04

RUN apt-get -y update && apt-get -y install ffmpeg
# RUN apt-get -y update && apt-get -y install git wget python-dev python3-dev libopenmpi-dev python-pip zlib1g-dev cmake python-opencv

RUN apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y vim git curl wget htop unzip && \
    apt-get install -y software-properties-common && \
    yes | add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.6 && \
    apt-get install -y python3-distutils && \
    apt-get install -y python3.6-dev && \
    (curl https://bootstrap.pypa.io/get-pip.py | python3.6)

ENV CODE_DIR /root/code

COPY . $CODE_DIR/baselines
WORKDIR $CODE_DIR/baselines

# Clean up pycache and pyc files
RUN rm -rf __pycache__ && \
    find . -name "*.pyc" -delete && \
    pip install 'tensorflow < 2' && \
    pip install -e .[test] && \
    apt-get install -y wget && \
    wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz && \
    tar -xf mujoco210-linux-x86_64.tar.gz && \
    cp -r mujoco210/bin/* /usr/lib/ && \
    mkdir ~/.mujoco && \
    cp -r mujoco210 ~/.mujoco && \
#   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/content/mujoco210/bin:/root/.mujoco/mujoco210/bin && \
    ln -s /usr/lib/x86_64-linux-gnu/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so && \
    apt install -y libosmesa6-dev libgl1-mesa-glx libglfw3 && \
    apt install -y patchelf && \
    apt-get install -y libglew-dev && \
    apt-get install -y cmake libopenmpi-dev python3-dev zlib1g-dev
    
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CODE_DIR}/baselines/mujoco210/bin:/root/.mujoco/mujoco210/bin"

RUN pip install -r requirements.txt

CMD /bin/bash
