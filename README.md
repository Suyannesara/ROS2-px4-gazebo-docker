### 1. Clone the Repository

```bash
git clone git@github.com:edra-unb-fga/docker-configuration.git
```

### 2. Prepare Your Environment 🌐

#### 2.1 First, create a directory for Docker volumes if you don't have one:

```bash
mkdir ~/Volumes
```

#### 2.2 Create a new `.env` file in the project root by copying `.env.example` and update the `HOST_USER` variable with your host username.

### 3. Build the Image 🛠️

⚠️ **Note:** The image is large and may take 1.5-2 hours to build. The complete image is located at `complete/complete/v0.1.Dockerfile`. Use one of the following commands to run it:

```bash
# To start the service with ROS Foxy
sudo docker compose up -d ros-px4-foxy

# To start the service with ROS Humble
sudo docker compose up -d ros-px4-humble

# To start both services
docker compose up -d --build
```

### 4. Allow Gazebo Permissions 🖥️

Run this command on your terminal (outside the container):

```bash
xhost local:docker
```

### 5. Start the Container 🚀

Once built, enter the container with:

```bash
sudo docker exec -it ros-px4-complete /bin/bash
```

You can open multiple terminal instances inside the container. To open a new terminal in another bash tab, run the command again.

Tip: Set an alias in your `~/.bashrc` to simplify this command.

### 6. Verifications ✅

Check if ROS2 is recognized:

```bash
ros2
```

If there's an error, run the following inside the container and try `ros2` again:

```bash
# For ROS Foxy:
source /opt/ros/foxy/setup.bash

# OR

# For ROS Humble:
source /opt/ros/humble/setup.bash
```

Verify the Ubuntu version:

```bash
lsb_release -a
```

Check if Gazebo opens correctly (it should open an application window):

```bash
# For the ROS Foxy container:
gazebo

# OR

# For the ROS Humble container:
gz sim
```