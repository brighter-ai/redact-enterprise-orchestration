# Running brighter Redact Enterprise
Start an instance of brighter Redact Enterprise, with the help of the three redact containers as shown below.


## brighter Redact Enterprise
brighter Redact Enterprise is an ecosystem comprising of three containers which are managed by docker-compose. The three containers - redact, redact-gpu and redact-utils are described in the architecture below.
![image](./redact_containers.png)

## Running brighter Redact services
### Prerequisites
Log in to the brighter AI docker registry with your credentials:

`docker login docker.brighter.ai`

Make sure you have access to your redact license file. For this guide, we'll assume that it's stored within the same folder as the docker-compose.yaml file and named `./license.bal`

| Usage-based licenses | If you're using a usage-based license you must have an active internet connection at all times!       |
|-------------|:------------------------|

## Starting brighter Redact Enterprise
Start the redact-gpu image on all gpus by running:
`./start_redact.sh`
