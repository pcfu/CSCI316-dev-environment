# Setup Guide

## Linux

1. Install [Docker](https://docs.docker.com/engine/install/) (Google how to do this on your distro)
2. `git clone` this repo into a directory of your choice
3. Open a terminal and `cd` to your project directory
4. Execute `./run.sh` (Note the `.` in front of `/`)

<br/>

Wait for image to install. Proceed with step 5 **when you see the following output:**

    ...
    The Jupyter Notebook is running at:
    http://(e7cb5c1a2c89 or 127.0.0.1):8888/
    Use Control-C to stop this server and shut down all kernels

5. Open Jupyter by visiting `localhost:8888` in a browser

<br/>

**Stopping the image**

1. In the terminal where image is running, press `ctrl-c`
2. Enter `y` when prompted
