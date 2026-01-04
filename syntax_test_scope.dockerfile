# SYNTAX TEST "Containerfile.sublime-syntax"

# syntax=docker/dockerfile:1

#directive=value
# directive =value
# directive= value
# directive = value
#   dIrEcTiVe=value

####[ ARG INSTRUCTIONS ]#######################################################

ARG
# <- keyword.declaration.arg.containerfile
#^^ keyword.declaration.arg.containerfile

ARG CODE_VERSION=latest
#^^ keyword.declaration.arg.containerfile
#   ^^^^^^^^^^^^ meta.assignment.l-value.shell variable.parameter.containerfile
#               ^ meta.assignment.shell keyword.operator.assignment.shell
#                ^^^^^^ meta.assignment.r-value.shell meta.string.glob.shell string.unquoted.shell

####[ CMD INSTRUCTIONS ]#######################################################

CMD /code/run-extras
# <- keyword.control.flow.containerfile
#^^ keyword.control.flow.containerfile
#  ^ meta.function-call.arguments.shell
#   ^^^^^^^^^^^^^^^^ meta.function-call.identifier.shell meta.command.shell variable.function.shell
#   ^ punctuation.separator.path.shell
#        ^ punctuation.separator.path.shell

####[ ENTRYPOINT INSTRUCTIONS ]################################################

ENTRYPOINT /code/run-extras
# <- keyword.control.flow.containerfile
#^^^^^^^^^ keyword.control.flow.containerfile
#         ^ meta.function-call.arguments.shell
#          ^^^^^^^^^^^^^^^^ meta.function-call.identifier.shell meta.command.shell variable.function.shell
#          ^ punctuation.separator.path.shell
#               ^ punctuation.separator.path.shell

ENTRYPOINT ["/bin/bash", "-c", "echo ${text}"]
#^^^^^^^^^ keyword.control.flow.containerfile
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.sequence.list.containerfile
#          ^ punctuation.section.sequence.begin.containerfile
#           ^^^^^^^^^^^ meta.function-call.identifier.shell meta.command.shell variable.function.shell
#           ^ punctuation.definition.quoted.begin.shell
#            ^ punctuation.separator.path.shell
#                ^ punctuation.separator.path.shell
#                     ^ punctuation.definition.quoted.end.shell
#                      ^ punctuation.separator.sequence.shell
#                        ^^^^ meta.string.glob.shell string.quoted.double.shell
#                        ^ punctuation.definition.string.begin.shell
#                           ^ punctuation.definition.string.end.shell
#                            ^ punctuation.separator.sequence.shell
#                              ^^^^^^^^^^^^^^ meta.string.glob.shell
#                              ^^^^^^ string.quoted.double.shell
#                              ^ punctuation.definition.string.begin.shell
#                                    ^^^^^^^ meta.interpolation.parameter.shell - string
#                                    ^ punctuation.definition.variable.shell
#                                     ^ punctuation.section.interpolation.begin.shell
#                                      ^^^^ variable.other.readwrite.shell
#                                          ^ punctuation.section.interpolation.end.shell
#                                           ^ string.quoted.double.shell punctuation.definition.string.end.shell
#                                            ^ punctuation.section.sequence.end.containerfile

ENTRYPOINT [
#^^^^^^^^^ keyword.control.flow.containerfile
#         ^^ meta.function-call.arguments.shell
#          ^ meta.sequence.list.containerfile punctuation.section.sequence.begin.containerfile
    "/bin/bash",
#^^^^^^^^^^^^^^^ meta.function-call.arguments.shell meta.sequence.list.containerfile
#   ^^^^^^^^^^^ meta.function-call.identifier.shell meta.command.shell variable.function.shell
#   ^ punctuation.definition.quoted.begin.shell
#    ^ punctuation.separator.path.shell
#        ^ punctuation.separator.path.shell
#             ^ punctuation.definition.quoted.end.shell
#              ^ punctuation.separator.sequence.shell
    "-c"
#^^^^^^^ meta.function-call.arguments.shell meta.sequence.list.containerfile
#   ^^^^ meta.string.glob.shell string.quoted.double.shell
#   ^ punctuation.definition.string.begin.shell
#      ^ punctuation.definition.string.end.shell
    "echo ${text}"
#^^^^^^^^^^^^^^^^^ meta.function-call.arguments.shell meta.sequence.list.containerfile
#   ^^^^^^^^^^^^^^ meta.string.glob.shell
#   ^^^^^^ string.quoted.double.shell
#   ^ punctuation.definition.string.begin.shell
#         ^^^^^^^ meta.interpolation.parameter.shell
#         ^ punctuation.definition.variable.shell
#          ^ punctuation.section.interpolation.begin.shell
#           ^^^^ variable.other.readwrite.shell
#               ^ punctuation.section.interpolation.end.shell
#                ^ string.quoted.double.shell punctuation.definition.string.end.shell
]
# <- meta.function-call.arguments.shell meta.sequence.list.containerfile punctuation.section.sequence.end.containerfile

####[ ENV INSTRUCTIONS ]#######################################################

ENV abc=hello
# <- keyword.declaration.env.containerfile
#^^ keyword.declaration.env.containerfile
#   ^^^ meta.assignment.l-value.shell variable.other.readwrite.shell
#      ^ meta.assignment.shell keyword.operator.assignment.shell
#       ^^^^^ meta.assignment.r-value.shell meta.string.glob.shell string.unquoted.shell

ENV MY_NAME="John Doe"
#^^ keyword.declaration.env.containerfile
#   ^^^^^^^ meta.assignment.l-value.shell variable.other.readwrite.shell
#          ^ meta.assignment.shell keyword.operator.assignment.shell
#           ^^^^^^^^^^ meta.assignment.r-value.shell meta.string.glob.shell string.quoted.double.shell
#           ^ punctuation.definition.string.begin.shell
#                    ^ punctuation.definition.string.end.shell

ENV MY_DOG=Rex\ The\ Dog
#^^ keyword.declaration.env.containerfile
#   ^^^^^^ meta.assignment.l-value.shell variable.other.readwrite.shell
#         ^ meta.assignment.shell keyword.operator.assignment.shell
#          ^^^^^^^^^^^^^ meta.assignment.r-value.shell meta.string.glob.shell string.unquoted.shell
#             ^^ constant.character.escape.shell
#                  ^^ constant.character.escape.shell

ENV ghi=$abc
# <- keyword.declaration.env.containerfile
#^^ keyword.declaration.env.containerfile
#   ^^^ meta.assignment.l-value.shell variable.other.readwrite.shell
#      ^ meta.assignment.shell keyword.operator.assignment.shell
#       ^^^^ meta.assignment.r-value.shell meta.string.glob.shell meta.interpolation.parameter.shell variable.other.readwrite.shell
#       ^ punctuation.definition.variable.shell

ENV abc=bye def=$abc
# <- keyword.declaration.env.containerfile
#^^ keyword.declaration.env.containerfile
#   ^^^ meta.assignment.l-value.shell variable.other.readwrite.shell
#      ^ meta.assignment.shell keyword.operator.assignment.shell
#       ^^^ meta.assignment.r-value.shell meta.string.glob.shell string.unquoted.shell
#           ^^^ meta.assignment.l-value.shell variable.other.readwrite.shell
#              ^ meta.assignment.shell keyword.operator.assignment.shell
#               ^^^^ meta.assignment.r-value.shell meta.string.glob.shell meta.interpolation.parameter.shell variable.other.readwrite.shell
#               ^ punctuation.definition.variable.shell

ENV MY_NAME="John Doe" MY_DOG=Rex\ The\ Dog \
    MY_CAT=fluffy
#   ^^^^^^ meta.assignment.l-value.shell variable.other.readwrite.shell
#         ^ meta.assignment.shell keyword.operator.assignment.shell
#          ^^^^^^ meta.assignment.r-value.shell meta.string.glob.shell string.unquoted.shell

ENV LANG en_US.UTF-8
#^^ keyword.declaration.env.containerfile
#   ^^^^ meta.assignment.l-value.shell variable.other.readwrite.shell
#        ^^^^^^^^^^^ meta.string.glob.shell string.unquoted.shell

####[ EXPOSE INSTRUCTIONS ]####################################################

EXPOSE 80/tcp
#^^^^^ keyword.other.containerfile
#      ^^^^^^ meta.string.glob.shell string.unquoted.shell

EXPOSE 80/udp
#^^^^^ keyword.other.containerfile
#      ^^^^^^ meta.string.glob.shell string.unquoted.shell

####[ FROM INSTRUCTIONS ]######################################################

FROM
# <- meta.import.containerfile keyword.control.import.from.containerfile
#^^^ meta.import.containerfile keyword.control.import.from.containerfile

FROM image
# <- meta.import.containerfile keyword.control.import.from.containerfile
#^^^^^^^^^ meta.import.containerfile
#^^^ keyword.control.import.from.containerfile
#    ^^^^^ support.module.containerfile

from image:tag
# <- meta.import.containerfile keyword.control.import.from.containerfile
#^^^^^^^^^^^^^ meta.import.containerfile
#^^^ keyword.control.import.from.containerfile
#    ^^^^^ support.module.containerfile
#         ^ punctuation.separator.key-value.containerfile
#          ^^^ constant.language.ref.tag.containerfile

from image:${CODE_VERSION}
#^^^^^^^^^^^^^^^^^^^^^^^^^ meta.import.containerfile
#^^^ keyword.control.import.from.containerfile
#    ^^^^^ support.module.containerfile
#         ^ punctuation.separator.key-value.containerfile
#          ^^^^^^^^^^^^^^^ meta.interpolation.parameter.shell
#          ^ punctuation.definition.variable.shell
#           ^ punctuation.section.interpolation.begin.shell
#            ^^^^^^^^^^^^ variable.other.readwrite.shell
#                        ^ punctuation.section.interpolation.end.shell

from image@abcedaef
# <- meta.import.containerfile keyword.control.import.from.containerfile
#^^^^^^^^^^^^^^^^^^ meta.import.containerfile
#^^^ keyword.control.import.from.containerfile
#    ^^^^^ support.module.containerfile
#         ^ punctuation.separator.key-value.containerfile
#          ^^^^^^^^ constant.language.ref.digest.containerfile

from image as alias
# <- meta.import.containerfile keyword.control.import.from.containerfile
#^^^^^^^^^^^^^^^^^^ meta.import.containerfile
#^^^ keyword.control.import.from.containerfile
#    ^^^^^ support.module.containerfile
#          ^^ keyword.operator.assignment.as.containerfile
#             ^^^^^ entity.name.label.containerfile

from --platform=linux image:tag as alias
# <- meta.import.containerfile keyword.control.import.from.containerfile
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.import.containerfile
#^^^ keyword.control.import.from.containerfile
#    ^^^^^^^^^^ meta.parameter.option.shell variable.parameter.option.shell
#    ^^ punctuation.definition.parameter.shell
#              ^ keyword.operator.assignment.shell
#               ^^^^^ meta.string.glob.shell string.unquoted.shell
#                     ^^^^^ support.module.containerfile
#                          ^ punctuation.separator.key-value.containerfile
#                           ^^^ constant.language.ref.tag.containerfile
#                               ^^ keyword.operator.assignment.as.containerfile
#                                  ^^^^^ entity.name.label.containerfile

####[ LABEL INSTRUCTION ]######################################################

LABEL "com.example.vendor"="ACME Incorporated"
#^^^^ keyword.declaration.label.containerfile
#     ^^^^^^^^^^^^^^^^^^^^ meta.assignment.l-value.shell variable.label.containerfile
#     ^ punctuation.definition.quoted.begin.shell
#                        ^ punctuation.definition.quoted.end.shell
#                         ^ meta.assignment.shell keyword.operator.assignment.shell
#                          ^^^^^^^^^^^^^^^^^^^ meta.assignment.r-value.shell meta.string.glob.shell string.quoted.double.shell
#                          ^ punctuation.definition.string.begin.shell
#                                            ^ punctuation.definition.string.end.shell

LABEL org.opencontainers.image.authors="SvenDowideit@home.org.au"
#^^^^ keyword.declaration.label.containerfile
#     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.assignment.l-value.shell variable.label.containerfile
#                                     ^ meta.assignment.shell keyword.operator.assignment.shell
#                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.assignment.r-value.shell meta.string.glob.shell string.quoted.double.shell
#                                      ^ punctuation.definition.string.begin.shell
#                                                               ^ punctuation.definition.string.end.shell

LABEL description="This text illustrates \
that label-values can span multiple lines."
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.assignment.r-value.shell meta.string.glob.shell string.quoted.double.shell
#                                         ^ punctuation.definition.string.end.shell

LABEL multi.label1="value1" \
      multi.label2="value2" \
      other="value3"
#     ^^^^^ meta.assignment.l-value.shell variable.label.containerfile
#          ^ meta.assignment.shell keyword.operator.assignment.shell
#           ^^^^^^^^ meta.assignment.r-value.shell meta.string.glob.shell string.quoted.double.shell
#           ^ punctuation.definition.string.begin.shell
#                  ^ punctuation.definition.string.end.shell

####[ RUN INSTRUCTIONS ]#######################################################

RUN
# <- keyword.control.flow.containerfile
#^^ keyword.control.flow.containerfile

RUN /code/$CMD
#^^ keyword.control.flow.containerfile
#  ^ meta.function-call.arguments.shell
#   ^^^^^^^^^^ meta.function-call.identifier.shell meta.command.shell
#   ^^^^^^ variable.function.shell
#   ^ punctuation.separator.path.shell
#        ^ punctuation.separator.path.shell
#         ^^^^ meta.interpolation.parameter.shell variable.other.readwrite.shell
#         ^ punctuation.definition.variable.shell

RUN --network ping localhost
#^^ keyword.control.flow.containerfile
#  ^^^^^^^^^^^ meta.function-call.arguments.shell
#   ^^^^^^^^^ meta.parameter.option.shell variable.parameter.option.shell
#   ^^ punctuation.definition.parameter.shell
#             ^^^^ meta.function-call.identifier.shell meta.command.shell variable.function.shell
#                 ^^^^^^^^^^ meta.function-call.arguments.shell
#                  ^^^^^^^^^ meta.string.glob.shell string.unquoted.shell

RUN source $HOME/.bashrc && \
echo $HOME
#^^^ meta.function-call.identifier.shell support.function.shell
#   ^^^^^^ meta.function-call.arguments.shell
#    ^^^^^ meta.string.glob.shell meta.interpolation.parameter.shell variable.language.builtin.shell
#    ^ punctuation.definition.variable.shell
