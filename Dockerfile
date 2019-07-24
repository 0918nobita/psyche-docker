FROM alpine:3.10

RUN set -ex

RUN apk update

RUN apk add sudo m4 patch libc-dev gcc ocaml-compiler-libs make

RUN echo 'root:root' | chpasswd

RUN adduser -S opam-user \
      && echo "opam-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
      && echo "opam-user:opam-user" | chpasswd

USER opam-user

RUN sudo apk add opam

RUN opam init --disable-sandboxing

RUN opam install -y ocamlfind base
