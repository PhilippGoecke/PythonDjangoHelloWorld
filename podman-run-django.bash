podman build --no-cache --rm --file Containerfile --tag django:demo .
podman run --interactive --tty --publish 8000:8000 django:demo
echo "browse http://localhost:8000/?name=test"
