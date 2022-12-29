# SYNTAX TEST "Dockerfile.sublime-syntax"
# syntax=docker/dockerfile:1

#directive=value
# directive =value
# directive= value
# directive = value
#   dIrEcTiVe=value
#^^^^^^^^^^^^^^^^^^^ comment.line
# <- comment.line meta.annotation punctuation.definition.annotation
#   ^^^^^^^^^ meta.annotation.identifier variable.language
#            ^ meta.annotation keyword.operator.assignment
#             ^^^^^^ meta.annotation.parameters string.unquoted

FROM python:3-alpine as python_builder
# <- keyword.import.from
# ^^ keyword.import.from
#    ^^^^^^ support.module
#          ^ punctuation.separator.key-value
#           ^^^^^^^^ support.constant
#                    ^^ keyword.context
#                       ^^^^^^^^^^^^^^ entity.name.label

# notadirective=because appears after a builder instruction
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ comment.line.number-sign - meta.annotation

FROM --platform=linux/amd64 python:3-alpine as python_builder2
# ^^ keyword.import.from
#    ^^^^^^^^^^ variable.parameter
#    ^^ punctuation.definition.parameter
#              ^ keyword.operator.assignment
#               ^^^^^^^^^^^ string.unquoted
#                           ^^^^^^ support.module
#                                 ^ punctuation.separator.key-value
#                                  ^^^^^^^^ support.constant
#                                           ^^ keyword.context
#                                              ^^^^^^^^^^^^^^^ entity.name.label
#                                                             ^ - entity

RUN apk update && \
  apk add \
  build-base \
  curl \
  git \
  libffi-dev \
  openssh-client \
  postgresql-dev

# Install Poetry & ensure it is in $PATH
RUN curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | POETRY_PREVIEW=1 python
# ^ keyword.other
#   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ source.shell
#   ^^^^ meta.function-call.identifier variable.function
#        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.function-call.arguments
#        ^^^^ meta.parameter.option variable.parameter.option
#        ^ punctuation.definition.parameter
#                                                                                     ^ keyword.operator.assignment.pipe
#                                                                                       ^^^^^^^^^^^^^^ meta.variable variable.other.readwrite
#                                                                                                     ^ keyword.operator.assignment
#                                                                                                      ^ meta.number.integer.decimal constant.numeric.value
#                                                                                                        ^^^^^^ meta.function-call.identifier variable.function

ENV PATH "/root/.poetry/bin:/opt/venv/bin:${PATH}"
# <- keyword.context
#   ^^^^ variable.other.readwrite
#       ^ invalid.deprecated.missing-equals - variable
#        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.string
#        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ string.quoted.double
#                                         ^^^^^^^ meta.interpolation.parameter
#                                         ^ punctuation.definition.variable
#                                          ^ punctuation.section.interpolation.begin
#                                           ^^^^ variable.other.readwrite
#                                               ^ punctuation.section.interpolation.end
#                                                ^ string.quoted.double punctuation.definition.string.end

COPY poetry.lock pyproject.toml /opt/project
# ^^ keyword.other
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.function-call.arguments
RUN python -m venv /opt/venv && \
  source /opt/venv/bin/activate && \
  pip install -U pip && \
  cd /opt/project && \
  poetry install --no-dev --no-interaction
# ^^^^^^ source.shell meta.function-call.identifier variable.function
#        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ source.shell meta.function-call.arguments
#                ^^ meta.parameter.option variable.parameter.option punctuation.definition.parameter
#                  ^^^^^^ meta.parameter.option variable.parameter.option

# Install the project itself (this is almost never cached)
COPY . /opt/project
RUN source /opt/venv/bin/activate && \
  cd /opt/project && \
  poetry install --no-dev --no-interaction

# Below this line is now creating the deployed container
# Anything installed above but not explicitly copied below is *not* available in the final container!
FROM python:3-alpine

# Any general deployed container setup that you want cached should go here

# Copy Project Virtual Environment from python_builder
COPY --from=python_builder /opt /opt
# ^^ keyword.other
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.function-call.arguments
#    ^^^^^^ meta.parameter.option variable.parameter.option
#          ^ keyword.operator.assignment
#           ^^^^^^^^^^^^^^ meta.string string.unquoted

# Add the VirtualEnv to the beginning of $PATH
ENV PATH="/opt/venv/bin:$PATH"
# ^ keyword.context
#   ^^^^ meta.function-call.arguments meta.variable variable.other.readwrite
#       ^ meta.function-call.arguments keyword.operator.assignment
#        ^^^^^^^^^^^^^^^^^^^^^ meta.function-call.arguments meta.string
#        ^ string.quoted.double punctuation.definition.string.begin
#         ^^^^^^^^^^^^^^ string.quoted.double
#                       ^ meta.interpolation.parameter variable.other.readwrite punctuation.definition.variable
#                        ^^^^ meta.interpolation.parameter variable.other.readwrite
#                            ^ string.quoted.double punctuation.definition.string.end

# -------------------------------

FROM microsoft/windowsservercore

# Executed as cmd /S /C echo default
RUN echo default

# Executed as cmd /S /C powershell -command Write-Host default
RUN powershell -command Write-Host default

# Executed as powershell -command Write-Host hello
SHELL ["powershell", "-command"]
# ^^^ keyword.other
#     ^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.sequence
#     ^ punctuation.section.sequence.begin
#      ^^^^^^^^^^^^ string.quoted.double
#      ^ punctuation.definition.string.begin
#                 ^ punctuation.definition.string.end
#                  ^ punctuation.separator.sequence - string
#                    ^^^^^^^^^^ string.quoted.double
#                    ^ punctuation.definition.string.begin
#                             ^ punctuation.definition.string.end
#                              ^ punctuation.section.sequence.end
RUN Write-Host hello
# ^ keyword.other
#   ^^^^^^^^^^ source.shell meta.function-call.identifier variable.function
# TODO: if we were clever, we'd switch to powershell syntax for RUN etc. instead of Bash

# Executed as cmd /S /C echo hello
SHELL ["cmd", "/S", "/C"]
RUN echo hello

# -------------------------------

ONBUILD ADD . /app/src
# ^^^^^ storage.modifier
#       ^^^ keyword.other
#           ^^^^^^^^^^ meta.function-call.arguments
ONBUILD RUN /usr/local/bin/python-build --dir /app/src
# ^^^^^ storage.modifier
#       ^^^ keyword.other
#           ^^^^^^^^^^^^^^^^^^^^^^^^^^^ source.shell meta.function-call.identifier variable.function

STOPSIGNAL SIGTERM
# ^^^^^^^^ keyword.other
#          ^^^^^^^ meta.function-call.arguments

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1
# TODO: scope CMD and everything afterwards correctly above

# syntax=docker/dockerfile:1
FROM debian
RUN <<EOT bash
  apt-get update
  apt-get install -y something
EOT
# TODO: scope heredoc correctly above

# syntax=docker/dockerfile:1
FROM alpine
COPY <<-"EOT" /app/script.sh
  echo hello ${FOO}
EOT
# TODO: scope variable interpolation in the heredoc above
RUN FOO=abc ash /app/script.sh

