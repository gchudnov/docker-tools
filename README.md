# docker-tools
Docker-related tools and scripts

## dcp.sh
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
