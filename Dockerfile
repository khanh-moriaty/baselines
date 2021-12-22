FROM python:3.6

RUN apt-get -y update && apt-get -y install ffmpeg
# RUN apt-get -y update && apt-get -y install git wget python-dev python3-dev libopenmpi-dev python-pip zlib1g-dev cmake python-opencv

ENV CODE_DIR /root/code

COPY . $CODE_DIR/baselines
WORKDIR $CODE_DIR/baselines

# Clean up pycache and pyc files
RUN rm -rf __pycache__ && \
    find . -name "*.pyc" -delete && \
    pip install 'tensorflow < 2' && \
    pip install -e .[test]
    wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz
    tar -xf mujoco210-linux-x86_64.tar.gz
    cp -r mujoco210/bin/* /usr/lib/
    mkdir ~/.mujoco
    cp -r mujoco210 ~/.mujoco
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/content/mujoco210/bin:/root/.mujoco/mujoco210/bin
    sudo ln -s /usr/lib/x86_64-linux-gnu/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so
    sudo apt install libosmesa6-dev libgl1-mesa-glx libglfw3
    sudo apt install patchelf
    sudo apt-get install libglew-dev
    sudo apt-get update 
    sudo apt-get install cmake libopenmpi-dev python3-dev zlib1g-dev

CMD /bin/bash
