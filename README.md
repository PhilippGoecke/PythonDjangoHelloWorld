# PythonDjangoHelloWorld
Python Django Hello World  

https://www.djangoproject.com/  

Source: https://docs.djangoproject.com/en/4.1/intro/tutorial01/  

`docker run -p 8000:8000 -it python:3.12.0a6-slim-bullseye bash`  
or  
`kubectl run -it python312 --image=python:3.12.0a6-slim-bullseye --port=8000 -- bash`  
`kubectl port-forward python312 7000:8000`

```console
python --version
python -m pip install Django
python -m django --version
django-admin startproject mysite
cd mysite
python manage.py runserver 0.0.0.0:8000
```
