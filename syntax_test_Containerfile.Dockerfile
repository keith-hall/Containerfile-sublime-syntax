# SYNTAX TEST partial-symbols "Containerfile.sublime-syntax"
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
#             ^^^^^^ meta.annotation.parameters
#             ^^^^^ string.unquoted

ARG abc=def
# ^ keyword.context.containerfile
#   ^^^ variable.parameter.containerfile
#      ^ keyword.operator.assignment.bash
#       ^^^ variable.other.readwrite.shell

# comment between ARG and first FROM
# <- comment.line.number-sign.containerfile punctuation.definition.comment.containerfile
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ comment.line.number-sign.containerfile

FROM python:3-alpine as python_builder
# <- meta.namespace
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.namespace - invalid
# <- keyword.import.from
# ^^ keyword.import.from
#    ^^^^^^ support.module
#          ^ punctuation.separator.key-value - support
#           ^^^^^^^^ support.constant
#                    ^^ keyword.context
#                       ^^^^^^^^^^^^^^ entity.name.label
#                       @@@@@@@@@@@@@@ definition

# notadirective=because appears after a builder instruction
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ comment.line.number-sign - meta.annotation - meta.namespace

FROM --platform=linux/amd64 python:3-alpine as python-builder2
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.namespace - invalid
# ^^ keyword.import.from
#    ^^^^^^^^^^ variable.parameter - support
#    ^^ punctuation.definition.parameter
#              ^ keyword.operator.assignment
#               ^^^^^^^^^^^ string.unquoted - support
#                           ^^^^^^ support.module
#                                 ^ punctuation.separator.key-value
#                                  ^^^^^^^^ support.constant
#                                           ^^ keyword.context
#                                              ^^^^^^^^^^^^^^^ entity.name.label
#                                                             ^ - entity

FROM python_builder AS test
#    @@@@@@@@@@@@@@ reference
#^^^^^^^^^^^^^^^^^^^^^^^^^^^ - invalid
#                   ^^ keyword.context
#                      ^^^^ entity.name.label
#                      @@@@ definition

ARG POETRY_HTTP_BASIC_AZURE_PASSWORD
# ^ keyword.context.containerfile
#   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ variable.parameter.containerfile
ENV POETRY_HTTP_BASIC_AZURE_USER="docker"
# ^ keyword.context.containerfile
#   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ variable.other.readwrite.shell
#                               ^ keyword.operator.assignment.shell
#                                ^^^^^^^^ string.quoted.double.shell

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
#   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ source.shell
#                                                                                                              ^ - source.shell
#   ^^^^ meta.function-call.identifier variable.function
#        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.function-call.arguments
#        ^^^^ meta.parameter.option variable.parameter.option
#        ^ punctuation.definition.parameter
#                                                                                     ^ keyword.operator.assignment.pipe
#                                                                                       ^^^^^^^^^^^^^^ variable.other.readwrite
#                                                                                                     ^ keyword.operator.assignment
#                                                                                                      ^ meta.string string.unquoted.shell
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
#                                           ^^^^ variable.language.builtin
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
# ^^^^^^ source.shell.bash.embedded.containerfile meta.function-call.identifier variable.function
#        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ source.shell meta.function-call.arguments
#                                         ^ - source.shell
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
# <- meta.namespace
#^^^^^^^^^^^^^^^^^^^^ meta.namespace
#                    ^ - meta.namespace
#^^^^^^^^^^^^^^^^^^^^ - invalid

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
#   ^^^^ meta.function-call.arguments variable.language.builtin
#       ^ meta.function-call.arguments keyword.operator.assignment
#        ^^^^^^^^^^^^^^^^^^^^^ meta.function-call.arguments meta.string
#        ^ string.quoted.double punctuation.definition.string.begin
#         ^^^^^^^^^^^^^^ string.quoted.double
#                       ^ meta.interpolation.parameter variable.language.builtin punctuation.definition.variable
#                        ^^^^ meta.interpolation.parameter variable.language.builtin
#                            ^ string.quoted.double punctuation.definition.string.end

# -------------------------------

FROM microsoft/windowsservercore
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.namespace - invalid
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^ support.module

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

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost/ || exit 1
# ^^^^^^^^^ keyword.other
#           ^^^^^^^^^^ variable.parameter
#           ^^ punctuation.definition.parameter
#                     ^ keyword.operator.assignment
#                      ^^ string.unquoted
#                         ^^^^^^^^^ variable.parameter
#                         ^^ punctuation.definition.parameter
#                                  ^ keyword.operator.assignment
#                                   ^^ string.unquoted
#                                      ^^^ keyword.other
#                                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ source.shell.bash.embedded

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1
# ^^^ keyword.other.containerfile
#     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ source.shell.bash.embedded.containerfile

# syntax=docker/dockerfile:1
FROM debian
RUN <<EOT bash
  apt-get update
  apt-get install -y something
  # TODO: scope as bash script
EOT
# <- source.shell.bash.embedded.containerfile meta.redirection.shell meta.tag.heredoc.end.shell entity.name.tag.heredoc.shell
#  ^ - meta.string

# syntax=docker/dockerfile:1
FROM alpine
COPY <<-"EOT" /app/script.sh
  echo hello ${FOO}
EOT
# TODO: scope variable interpolation in the heredoc above
RUN FOO=abc bash /app/script.sh

# syntax=docker/dockerfile:1
FROM ubuntu
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked apt update && apt-get --no-install-recommends install -y gcc
# ^^ variable.parameter.containerfile punctuation.definition.parameter.containerfile
#   ^^^^^ variable.parameter.containerfile
#        ^ keyword.operator.assignment.containerfile
#         ^^^^ variable.parameter.inner.containerfile
#             ^ keyword.operator.assignment.containerfile
#              ^^^^^ string.unquoted.containerfile
#                   ^ punctuation.separator.sequence.containerfile
#                    ^^^^^^ variable.parameter.inner.containerfile
#                          ^ keyword.operator.assignment.containerfile
#                           ^^^^^^^^^^^^ string.unquoted.containerfile
#                                       ^ punctuation.separator.sequence.containerfile
#                                        ^^^^^^^ variable.parameter.inner.containerfile
#                                               ^ keyword.operator.assignment.containerfile
#                                                ^^^^^^ string.unquoted.containerfile
#                                                       ^^^ source.shell.bash.embedded.containerfile meta.function-call.identifier.shell variable.function.shell

RUN --mount=type=bind,source=./for_mounting,target=/app,readonly do_something
#                                                      ^ punctuation.separator.sequence.containerfile
#                                                       ^^^^^^^^ variable.parameter.inner.containerfile
#                                                                ^^^^^^^^^^^^ variable.function.shell

RUN \

# <- invalid.illegal.missing-shell-instruction.containerfile

RUN apt-get -y update && \
    # comment eaten by Docker, not passed to shell
    # <- comment.line.number-sign.containerfile punctuation.definition.comment.containerfile
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ comment.line.number-sign.containerfile
    apt-get install something
# <- source.shell.bash.embedded.containerfile - comment - variable
#^^^ source.shell.bash.embedded.containerfile - comment - variable
#   ^^^^^^^ source.shell.bash.embedded.containerfile variable.function.shell

LABEL org.opencontainers.image.authors="SvenDowideit@home.org.au"
# ^^^ keyword.other.containerfile
#     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ variable.parameter.containerfile
#                                     ^ keyword.operator.assignment.bash

#https://stackoverflow.com/a/60820156/4473405
ARG my_arg

FROM centos:7 AS base
RUN echo "do stuff with the centos image"

FROM base AS branch-version-1
RUN echo "this is the stage that sets VAR=TRUE"
ENV VAR=TRUE

FROM base AS branch-version-2
RUN echo "this is the stage that sets VAR=FALSE"
ENV VAR=FALSE

FROM branch-version-${my_arg} AS final
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.namespace - invalid
#    ^^^^^^^^^^^^^^^^^^^^^^^^ support.module.containerfile
#                   ^^^^^^^^^ meta.interpolation.parameter
#                   ^ punctuation.definition.variable
#                    ^ punctuation.section.interpolation.begin - variable
#                     ^^^^^^ variable
#                           ^ punctuation.section.interpolation.end - variable
#                            ^ - support
#                             ^^ keyword.context
#                                ^^^^^ entity.name.label
RUN echo "VAR is equal to ${VAR}"

#----------------------------------------------------------
FROM some_image:v${my_arg} AS another
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.namespace - invalid
#    ^^^^^^^^^^ support.module
#              ^ punctuation.separator.key-value
#               ^^^^^^^^^^ support.constant
#                ^ punctuation.definition.variable
#                 ^ punctuation.section.interpolation.begin - variable
#                  ^^^^^^ variable
#                        ^ punctuation.section.interpolation.end - variable
#                         ^ - support
#                          ^^ keyword.context
#                            ^ - keyword - entity
#                             ^^^^^ entity.name.label


# https://docs.docker.com/reference/dockerfile/#environment-replacement
# Environment variables are notated in the Dockerfile either with $variable_name or ${variable_name}. They are treated equivalently and the brace syntax is typically used to address issues with variable names with no whitespace, like ${foo}_bar.

# The ${variable_name} syntax also supports a few of the standard bash modifiers as specified below:

# ${variable:-word} indicates that if variable is set then the result will be that value. If variable is not set then word will be the result.
# ${variable:+word} indicates that if variable is set then word will be the result, otherwise the result is the empty string.

FROM some_image:${VARIABLE:-default} AS some_stage
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.namespace.containerfile
#^^^ keyword.import.from.containerfile
#    ^^^^^^^^^^ support.module.containerfile
#              ^ punctuation.separator.key-value.containerfile
#               ^^^^^^^^^^^^^^^^^^^^ support.constant.containerfile meta.interpolation.parameter.shell
#               ^ punctuation.definition.variable.shell
#                ^ punctuation.section.interpolation.begin.shell
#                 ^^^^^^^^ variable.other.readwrite.shell
#                         ^^ keyword.operator.assignment.shell
#                           ^^^^^^^ meta.string.regexp.shell string.unquoted.shell
#                                  ^ punctuation.section.interpolation.end.shell
#                                    ^^ keyword.context.containerfile
#                                       ^^^^^^^^^^ entity.name.label.containerfile
LABEL example="foo-$ENV_VAR"
#^^^^ keyword.other.containerfile
#    ^^^^^^^^ variable.parameter.containerfile
#            ^ keyword.operator.assignment.bash
#             ^^^^^^^^^^^^^^ meta.function-call.arguments.shell meta.assignment.l-value.shell
#             ^^^^^ variable.other.readwrite.shell
#             ^ punctuation.definition.quoted.begin.shell
#                  ^^^^^^^^ meta.interpolation.parameter.shell variable.other.readwrite.shell
#                  ^ punctuation.definition.variable.shell
#                          ^ variable.other.readwrite.shell punctuation.definition.quoted.end.shell
LABEL example='foo-$ENV_VAR'
#^^^^ keyword.other.containerfile
#    ^^^^^^^^ variable.parameter.containerfile
#            ^ keyword.operator.assignment.bash
#             ^^^^^^^^^^^^^^ meta.function-call.arguments.shell meta.assignment.l-value.shell variable.other.readwrite.shell
#             ^ punctuation.definition.quoted.begin.shell
#                  ^ - punctuation
#                          ^ punctuation.definition.quoted.end.shell


HEALTHCHECK --start-period=10s --interval=5s --retries=10 --timeout=3s CMD /opt/mssql-tools/bin/sqlcmd -d some_database -U sa -P some_sa_pa55word -Q 'SELECT 1;'
# ^^^^^^^^^ keyword.other.containerfile
#           ^^ punctuation.definition.parameter.containerfile
#             ^^^^^^^^^^^^ variable.parameter.containerfile
#                         ^ keyword.operator.assignment.containerfile
#                          ^^^ string.unquoted.containerfile

ENTRYPOINT [\
    "sh",\
    # comment halfway through with no line continuation required
    # <- punctuation.definition.comment.containerfile
    # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ comment.line.number-sign.containerfile
    "-c","echo hello $NAME"]
#^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.sequence.containerfile - invalid
#   ^^^^ string.quoted.double.json
#       ^ punctuation.separator.sequence
#        ^^^^^^^^^^^^^^^^^^ string.quoted.double.json
#                          ^ punctuation.section.sequence.end
#                           ^ - illegal - meta.sequence

HEALTHCHECK NONE
# ^^^^^^^^^^^^^^ keyword.other.containerfile

ENTRYPOINT [\
    "sh", "-c",\
    "echo \"testing\\\u002b\""\
    #     ^^ constant.character.escape.json
    #              ^^^^^^^^^^ constant.character.escape.json
    #                        ^ meta.sequence.containerfile string.quoted.double.json punctuation.definition.string.end.json
    #                         ^^ meta.sequence.containerfile punctuation.separator.continuation.line.containerfile
]
# <- meta.sequence.containerfile punctuation.section.sequence.end.json

ENTRYPOINT ["sh", "-c","echo testing",]
# ^^^^^^^^ keyword.other.containerfile
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^ - invalid
#          ^ punctuation.section.sequence.begin.containerfile
#           ^ punctuation.definition.string.begin.json
#           ^^^^ string.quoted.double.json
#              ^ punctuation.definition.string.end.json
#               ^ punctuation.separator.sequence.json
#                                     ^ meta.sequence.containerfile invalid.illegal.expected-string.json

ENTRYPOINT ["something"]
# ^^^^^^^^ keyword.other.containerfile
#          ^^^^^^^^^^^^^ meta.sequence.containerfile - invalid
#                       ^ - meta.sequence
#           ^^^^^^^^^^^ string.quoted.double.json

ENTRYPOINT []
# ^^^^^^^^ keyword.other.containerfile
#          ^ meta.sequence.containerfile punctuation.section.sequence.begin.containerfile
#           ^ meta.sequence.containerfile invalid.illegal.expected-string.json

ENTRYPOINT [
# ^^^^^^^^ keyword.other.containerfile
#          ^ meta.sequence.containerfile punctuation.section.sequence.begin.containerfile
#           ^ meta.sequence.containerfile invalid.illegal.line-end.containerfile
