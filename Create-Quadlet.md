You can create a Quadlet file by manually writing a configuration file or by using the `podlet` command-line tool. A Quadlet file is a simplified, declarative way to define and manage Podman containers, pods, volumes, or networks using `systemd`.

-----

### 📝 Manual Method: Creating a Quadlet File from Scratch

The manual method involves creating a text file with a specific name and syntax. This is great for learning the structure and having full control.

1.  **Choose a location**: Quadlet files must be placed in specific directories for `systemd` to find them. The most common locations are:

      * **For rootless containers**: `~/.config/containers/systemd/`
      * **For rootful containers**: `/etc/containers/systemd/`
        If the directory doesn't exist, create it with `mkdir -p`.

2.  **Name the file**: The file name determines the type of Quadlet. It must follow the format `name.extension`. The extension tells `podman` what kind of `systemd` unit to generate. Common extensions include:

      * `.container`: For a single container.
      * `.pod`: For a pod of containers.
      * `.volume`: For a persistent volume.
      * `.network`: For a Podman network.

3.  **Write the content**: A Quadlet file uses an INI-style format with different sections. A basic container Quadlet will have at least the `[Unit]` and `[Container]` sections.

      * `[Unit]`: This section contains standard `systemd` unit options, like `Description` and `After`.
      * `[Container]`: This is the core section for a `.container` file. It holds the `podman run` options in a declarative format. Keys like `Image=`, `ContainerName=`, `PublishPort=`, and `Volume=` are used here.
      * `[Service]`: Optional, for `systemd` service behavior like `Restart=always`.
      * `[Install]`: Optional, for enabling the service to start on boot, using `WantedBy=default.target` for rootless or `WantedBy=multi-user.target` for rootful.

4.  **Save the file**: Save the file with the correct name and extension in the appropriate directory.

#### **Simple Example: Nginx Container**

Here's an example of a Quadlet file for a basic Nginx container.

  * **File Path**: `~/.config/containers/systemd/nginx.container`

  * **File Content**:

    ```ini
    [Unit]
    Description=Nginx Web Server
    After=network-online.target

    [Container]
    ContainerName=nginx
    Image=docker.io/library/nginx
    PublishPort=80:8080
    AutoUpdate=registry

    [Service]
    Restart=always

    [Install]
    WantedBy=multi-user.target
    ```

<!-- end list -->

5.  **Reload `systemd`**: After creating the file, you must tell `systemd` to reload its configuration to detect the new file and generate the corresponding `.service` unit.

      * **For rootless**: `systemctl --user daemon-reload`
      * **For rootful**: `sudo systemctl daemon-reload`

6.  **Start and enable**: Now, you can manage the container as a `systemd` service.

      * `systemctl --user start nginx.service`
      * `systemctl --user enable nginx.service` (to make it start at boot)

-----

### ⚙️ Automated Method: Using `podlet`

For more complex commands or converting from Docker Compose, the `podlet` tool simplifies the process by generating Quadlet files for you.

1.  **Install `podlet`**: It's a separate utility you'll need to install. The `podlet` GitHub page has instructions for various platforms.

2.  **Generate from a `podman run` command**: Simply prepend `podlet` to your `podman run` command. It will print the generated Quadlet content to standard output, which you can then redirect to a file.

      * **Example**:
        `podlet podman run --name=my-nginx -p 80:8080 docker.io/library/nginx > ~/.config/containers/systemd/my-nginx.container`

3.  **Generate from an existing container**: You can also create a Quadlet from a container that's already running.

      * **Example**:
        `podlet generate container my-running-container > ~/.config/containers/systemd/my-running-container.container`