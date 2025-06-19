podman build --no-cache --rm -f Containerfile -t django:demo .
podman run --interactive --tty -p 8000:8000 django:demo
echo "browse http://localhost:8000/?name=test"
