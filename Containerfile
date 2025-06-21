FROM debian:bookworm-slim as build-env

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y \
  # install tools
  && apt install -y --no-install-recommends git curl ca-certificates \
  # install python dependencies
  && apt install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev libsqlite3-dev \
  # make image smaller
  && rm -rf "/var/lib/apt/lists/*" \
  && rm -rf /var/cache/apt/archives

RUN useradd -m pythonuser

ENV HOME /home/pythonuser
WORKDIR $HOME
USER pythonuser

RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv
ENV PATH $HOME/.pyenv/shims:$HOME/.pyenv/bin:$PATH

ENV PYTHON_VERSION 3.13.5
RUN pyenv install --list | grep -A7 $PYTHON_VERSION \
  && pyenv install $PYTHON_VERSION \
  && pyenv global $PYTHON_VERSION \
  && pyenv rehash \
  && python --version

WORKDIR $HOME/app

RUN pip install Django \
  && pip freeze \
  && python -m django --version

RUN django-admin startproject hello_project

WORKDIR $HOME/app/hello_project

RUN python manage.py startapp hello_app \
  && ls -lisah hello_app \
  && echo "from django.http import HttpResponse\n\ndef index(request):\n    name = request.GET.get('name', 'World')\n    return HttpResponse(f'Hello {name}!')" >> hello_app/views.py \
  && sed -i "s%urlpatterns = \[%from hello_app import views\n\nurlpatterns = \[%g" hello_project/urls.py \
  && sed -i "s%]%    path('',views.index, name='greeting')\n    ]%g" hello_project/urls.py \
  && python manage.py migrate

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

HEALTHCHECK CMD curl -f "http://localhost:8000" || exit 1
