#Want to build a docker file for pyspark, hadoop, and sparklab.


echo "Starting build of Jupyter..."

# Vars
container_nm=jupyter-lab

if [ -d .venv ];then 
    echo "Deleting .venv as it already exists."
    rm -rf .venv
fi

echo "Creating a new venv and sourcing it."
python3 -m venv .venv && source .venv/bin/activate

echo "Installing python packages into the venv."
python3 -m pip install pyspark \
pyspark[sql] \
pyspark[pandas_on_spark] plotly \
pyspark[connect] \
jupyterlab \
notebook \
matplotlib \
duckdb


echo "Creating requirements.txt from the .venv for the docker image."
python3 -m pip freeze > requirements.txt

# Check if image is already running and stop it if it is
running_image_name=docker ps -a|grep $container_nm|awk '{print $1}'
if [ ! $running_image_name]; then
    echo "Docker image is already running. Stopping and deleting it now."
    # docker rm $(docker stop $(docker ps -a -q --filter ancestor=$container_nm --format="{{.ID}}"))
    docker rm $(docker stop $(docker ps -a --filter ancestor=$container_nm --format="{{.ID}}"))
fi

# build docker with the tag and run it 
echo "Building the docker image with the tag..."
docker build --tag $container_nm .

echo "Starting docker build..."
docker run -d \
    --name $container_nm \
    --hostname $container_nm \
    --mount type=bind,src="$(pwd)",target=/app/$container_nm \
    -p 8888:8888 $container_nm

# Open the container in a new tab, this will only work for WSL on windows
# Still need to capture the token back to this window
echo "Launching browser now..."
cmd.exe /C start "http://localhost:8888/login?next=%2Flab"
