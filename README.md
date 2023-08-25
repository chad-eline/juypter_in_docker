# juypter_in_docker
An end to end example of how to build and host jupyter in docker.


Prerequisities
    1. A linux OS (max/unbuntu/wsl).
    2. Python and pip on that linux os
    3. https://docs.docker.com/get-docker/
    4. https://en.wikipedia.org/wiki/Makefile
        - sudo sudo apt install make

How to build

    Run:
        ./build_jupyter.sh

    - This bash file will create venv file.
    - export it to a req's file
    - Stop the docker imagie if its already running
    - Build the container, which will trigger the dockerfile, with the tag name
        - The docker file will essentially build a linux image with the req's you give it
    - And then start the container and expose its port
    