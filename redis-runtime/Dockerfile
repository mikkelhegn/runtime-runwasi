FROM scratch as temp
COPY spin.toml spin.toml
# Make sure to change the following line, depending on where the compiles wasm is located. This will vary based on the programming language you use. Check the spin.toml file, which has a reference to the file.
COPY target/redis-runtime.wasm target/redis-runtime.wasm
COPY runtime-config.toml runtime-config.toml

FROM scratch
COPY --from=temp . .
ENTRYPOINT ["/"]
