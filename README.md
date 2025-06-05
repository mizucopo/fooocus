# fooocus

```sh
docker pull --platform linux/amd64 nvidia/cuda:12.8.1-devel-ubuntu24.04
```

```sh
docker build --platform linux/amd64 -t mizucopo/fooocus:develop .
```

```sh
docker push mizucopo/fooocus:develop
```

```sh
docker run --rm --gpus all -p 7865:7865 -v ./checkpoints:/app/models/checkpoints -v ./outputs:/app/outputs -it mizucopo/fooocus:develop /bin/bash
```
