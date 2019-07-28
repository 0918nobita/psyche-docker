FROM alpine:3.10

RUN set -ex
RUN apk update
RUN apk add sudo m4 patch libc-dev gcc g++ ocaml-compiler-libs make git python cmake

# wabt ( wat2wasm, wasm2wat, wasm-objdump, wasm-interp ) のインストール

RUN git clone --recursive https://github.com/WebAssembly/wabt
WORKDIR /wabt
RUN mkdir build
WORKDIR /wabt/build
ENV CXX g++
RUN cmake ..
RUN cmake --build .
RUN cmake ..
WORKDIR /
RUN mv /wabt/build/wat2wasm /usr/bin/wat2wasm
RUN mv /wabt/build/wasm2wat /usr/bin/wasm2wat
RUN mv /wabt/build/wasm-objdump /usr/bin/wasm-objdump
RUN mv /wabt/build/wasm-interp /usr/bin/wasm-interp
RUN rm -rf /wabt

RUN echo 'root:root' | chpasswd
RUN adduser -S opam-user \
      && echo "opam-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
      && echo "opam-user:opam-user" | chpasswd
USER opam-user

RUN sudo apk add opam

RUN opam init --disable-sandboxing
