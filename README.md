[![Brighter AI logo](./pictures/brighter.png)](https://brighter.ai/)

# Running brighter Redact Enterprise

Start an instance of brighter Redact Enterprise, consisting of three redact containers which are managed by docker-compose.

## brighter Redact Enterprise

brighter Redact Enterprise is an ecosystem comprising of three containers which are managed by docker-compose. The three containers - redact, redact-gpu and redact-utils are described in the architecture below.
![image](./pictures/redact_containers.png)

## Running brighter Redact services

### Prerequisites

Log in to the brighter AI docker registry with your credentials:

`docker login docker.brighter.ai`

Make sure you have access to your redact license file. For this guide, we'll assume that it's stored within the same folder as the docker-compose.yaml file and named `./license.bal`

| Usage-based licenses | If you're using a usage-based license you must have an active internet connection at all times!       |
|-------------|:------------------------|

## Starting brighter Redact Enterprise

0. (optional) Change the default configuration as described [below](#configuration)

1. Start redact in default configuration by running:
`./start_redact.sh`
if you also want to start the graphical user interface add the `-u` flag
`./start_redact.sh -u`

2. Start anonymizing using the ui ($HOSTIP:8080/ui), sra ($HOSTIP:8080/sra), or the flassger interface($HOSTIP:8787).

3. Redact can be shut down with the following script:
`./stop_redact.sh`

### Configuration

The configuration of the docker-compose setup can be changed within the [docker-compose.env](./docker-compose.env) file.

#### Redact Docker Images

``` bash
REDACT_IMAGE=...
REDACT_GPU_IMAGE=...
REDACT_UTILS_IMAGE=...
```

#### GPU Optimized Images

The following GPU-specific containers exist, and can be used only with the specified GPU type for speed improvements:

| Standard Image   | T4 Optimized Image            | A100 Optimized Image            | 2080TI Optimized Image     |
|------------------|-------------------------------|---------------------------------|----------------------------|
| redact-gpu:2.5.0 | redact-gpu:2.5.0-T4           | redact-gpu:2.5.0-A100           | redact-gpu:2.5.0-2080ti    |
| redact-gpu:2.4.0 | redact-gpu:2.4.0-optimized-T4 | redact-gpu:2.4.0-optimized-A100 |                            |
| redact-gpu:2.3.1 | redact-gpu:2.3.1-trt-T4       |                                 |                            |

This applys to the `REDACT_GPU_IMAGE` located in `docker-compose.env`

#### Ports

``` bash
REDACT_API_PORT=...
REDACT_UI_PORT=...
```

#### REDACT_LICENSE_FILE

The location and name of the local redact license file can be changed with the following environment variable:

``` bash
REDACT_LICENSE_FILE=...
```

#### GPU_IDS

Simply change the `GPU_IDS` variable to select your desired GPUs.\
E.g.:

- `GPU_IDS=0,1,2` for GPUs with IDs 0, 1 and 2
- `GPU_IDS=all` for all GPUs.

See [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/user-guide.html#gpu-enumeration) for more information.

#### Disabling Features

Disabling features can be used to reduce memory consumption and lowering the idle load.

``` bash
DISABLE_FACES={true | false}
DISABLE_LICENSE_PLATES={true | false}
DISABLE_PERSONS={true | false}
DISABLE_BLUR={true | false}
DISABLE_EXTRACT={true | false}
DISABLE_DNAT={true | false}
```

#### Retrieving Error Logs

If there are any issues with processing files, the error logs of all micro-services can be downloaded and sent to Brighter AI for further investigation.

To download the error logs, run `./download_logs.sh` and send the output zip file (`redact_logs.zip`) to Brighter AI
