build:
    @echo "Beginning Build..."
    @mkdir -p out
    @echo "Compiling Slang Shaders..."
    @slangc shaders/main.slang -target metal -o shaders/main.metal
    @echo "Building Odin Project..."
    @odin build . -out:out/renderertwo
    @echo "Build Complete!"

run: build
    @echo "Running..."
    @./out/renderertwo