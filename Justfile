build:
    @echo "Beginning Build..."
    @mkdir -p out
    @echo "Compiling Slang Shaders..."
    @slangc shaders/main.slang -target metal -o shaders/main.metal
    @echo "Building Odin Project..."
    @odin build . -out:out/gpu
    @echo "Build Complete, Running..."

run: build
    @./out/gpu