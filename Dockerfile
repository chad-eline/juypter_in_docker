# syntax=docker/dockerfile:1

#Use the support docker image for python as a starting point
FROM python:3.11-slim-buster

# Install mkdocs and other dependencies
RUN --mount=type=cache,sharing=private,target=/var/cache/apt \
    --mount=type=cache,sharing=private,target=/var/lib/apt \
    apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends \
		git \
		curl \
		vim \
		zip \
		g++ \
		gcc \
		jq \
		less \
	&& rm -rf /var/lib/apt/lists/*
RUN apt-get clean

# Add aliases
RUN echo "alias ll='ls -alF'" >> /root/.bashrc && \
    echo "alias c='clear && ll'" >> /root/.bashrc && \
    echo "alias gs='git status'" >> /root/.bashrc

#set work dir to app
WORKDIR /app/jupyter-lab

#copy req's file over to image
COPY requirements.txt requirements.txt
RUN /usr/local/bin/python -m pip install --upgrade pip
RUN pip3 install -r requirements.txt

#start jupyter-lab
# Help comands: jupyter-lab --help-all 
# ENV BROWSER='/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe'
CMD ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
