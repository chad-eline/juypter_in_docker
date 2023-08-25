#Want to build a docker file for pyspark, hadoop, and sparklab.

# Vars
container_nm=jupyter-lab

#Create a venv, source it
python3 -m venv .venv && source .venv/bin/activate

#install python packages into the venv
python3 -m pip install pyspark \
pyspark[sql] \
pyspark[pandas_on_spark] plotly \
pyspark[connect] \
jupyterlab \
notebook

#create a req's file from the venv for docker image
python3 -m pip freeze > requirements.txt

# Check if image is already running and stop it if it is
running_image_name=docker ps -a|grep $container_nm|awk '{print $1}'
if [ ! $running_image_name]; then
    # docker rm $(docker stop $(docker ps -a -q --filter ancestor=$container_nm --format="{{.ID}}"))
    docker rm $(docker stop $(docker ps -a --filter ancestor=$container_nm --format="{{.ID}}"))
fi

# build docker with the tag and run it 
docker build --tag $container_nm .
docker run -d \
    --name $container_nm \
    --hostname $container_nm \
    --mount type=bind,src="$(pwd)",target=/app/$container_nm \
    -p 8888:8888 $container_nm

# Open the container in a new tab, this will only work for WSL on windows
# Still need to capture the token back to this window
cmd.exe /C start "http://localhost:8888/login?next=%2Flab"