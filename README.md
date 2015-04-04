# docker-tools
Docker-related tools and scripts

### Overview

[Copying data between Docker containers](https://medium.com/@gchudnov/copying-data-between-docker-containers-26890935da3f)

## Copying data between Docker containers -- dcp.sh

```shell
dcp.sh 
Usage: dcp.sh [OPTIONS] SOURCE DESTINATION

Copies files and directories between running containers and the host

Patterns:
  dcp.sh CONTAINER:PATH HOSTPATH
  dcp.sh HOSTPATH CONTAINER:PATH
  dcp.sh CONTAINER1:PATH CONTAINER2:PATH

Examples:
* CONTAINER:PATH -> HOSTPATH
  dcp.sh kickass_yonath:/home/data.txt .
    - Copies '/home/data.txt' from 'kickass_yonath' container to the current host directory

* HOSTPATH -> CONTAINER:PATH
  dcp.sh ./test.txt kickass_yonath:/home/e1/e2
    - Copies 'test.txt' from the current host directory to '/home/e1/e2' in the 'kickass_yonath' container

  dcp.sh /home/user/Downloads/test.txt kickass_yonath:/home/e1/e2
    - Copies 'test.txt' from the host directory to '/home/e1/e2' in the 'kickass_yonath' container

  dcp.sh /home/user/Downloads kickass_yonath:/home/d1/d2
    - Copies the entire 'Downloads' directory to '/home/d1/d2' in the 'kickass_yonath' container

* CONTAINER1:PATH -> CONTAINER2:PATH
  dcp.sh kickass_yonath:/home ecstatic_colden:/
    - Copies the entire 'home' directory from 'kickass_yonath' to 'ecstatic_colden'

  dcp.sh kickass_yonath:/home/data.txt ecstatic_colden:/
    - Copies 'data.txt' file from 'kickass_yonath' conrainer to the 'ecstatic_colden' container

Options:
    -h       Display this help message

```


## Trapping signals in Docker
[Example](https://github.com/gchudnov/docker-tools/tree/master/signals)

* `/foreground` -- Application is the main process in the container (PID1)
* `/background` -- Application is the background process in the container (!= PID1)

```shell
# Building the image
$ ./build.sh
- `docker build -t <NAME> .`

# Running the container
$ ./run.sh
- `docker run -it --rm -p 3000:3000 --name="<NAME>" <NAME>`

# Sending signals
* SIGUSR1
$ ./sig-usr1.sh
- `docker kill --signal="SIGUSR1" <NAME>`

* SIGTERM
$ ./sig-term.sh
- `docker kill --signal="SIGTERM" <NAME>`
```
