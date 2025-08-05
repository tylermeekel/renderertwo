package main

import "core:image"
import "core:log"
import "core:mem"
import "core:math/linalg"
import stbi "vendor:stb/image"
import sdl "vendor:sdl3"

main_code := #load("./shaders/main.metal")

time: u64 = 0

UBO :: struct {
    mvp_matrix: matrix[4, 4]f32,
}

Vertex :: struct {
    pos: [4]f32,
    color: [4]f32,
    uv: [2]f32,
}

main :: proc() {
    context.logger = log.create_console_logger()
    sdl.SetLogPriorities(.VERBOSE)

    ok := sdl.Init({.VIDEO})
    assert(ok, "Failed to Initialize SDL3")

    window := sdl.CreateWindow("SDL3 GPU", 1080, 720, {})
    assert(window != nil, "Failed to create window")
    defer sdl.DestroyWindow(window)

    gpu := sdl.CreateGPUDevice({.MSL, .METALLIB}, true, nil)
    defer sdl.DestroyGPUDevice(gpu)

    ok = sdl.ClaimWindowForGPUDevice(gpu, window)
    assert(ok)

    vertex_shader := load_shader(gpu, main_code, "vertex_main", .VERTEX, {
        num_uniform_buffers = 1
    })
    assert(vertex_shader != nil)
    fragment_shader := load_shader(gpu, main_code, "fragment_main", .FRAGMENT, {
        num_samplers = 1
    })
    assert(fragment_shader != nil)

    // load pixels
    img_size: [2]i32
    pixels := stbi.load("./assets/prototype.png", &img_size.x, &img_size.y, nil, 4)
    pixels_size := u32(img_size.x * img_size.y * 4)
    assert(pixels != nil)

    // create texture on GPU
    texture := sdl.CreateGPUTexture(gpu, {
        type = .D2,
        format = .R8G8B8A8_UNORM,
        usage = {.SAMPLER},
        width = u32(img_size.x),
        height = u32(img_size.y),
        layer_count_or_depth = 1,
        num_levels = 1,
    })

    // upload pixels to GPU texture
    texture_transfer_buf := sdl.CreateGPUTransferBuffer(gpu, {
        usage = .UPLOAD,
        size = pixels_size
    })

    texture_transfer_mem := sdl.MapGPUTransferBuffer(gpu, texture_transfer_buf, false)
    mem.copy(texture_transfer_mem, pixels, int(pixels_size))
    sdl.UnmapGPUTransferBuffer(gpu, texture_transfer_buf)

    texture_command_buf := sdl.AcquireGPUCommandBuffer(gpu)

    texture_copy_pass := sdl.BeginGPUCopyPass(texture_command_buf)

    sdl.UploadToGPUTexture(texture_copy_pass, {
        transfer_buffer = texture_transfer_buf,
        offset = 0,
        pixels_per_row = u32(img_size.x)
    }, {
        texture = texture,
        w = u32(img_size.x),
        h = u32(img_size.y),
        d = 1,
    }, false)

    sdl.EndGPUCopyPass(texture_copy_pass)
    ok = sdl.SubmitGPUCommandBuffer(texture_command_buf)
    
    sampler := sdl.CreateGPUSampler(gpu, {})
    
    // create sampler for shader
    // make shader sample color from texture

    vertex_buffer_description := sdl.GPUVertexBufferDescription {
        slot = 0,
        pitch = size_of(Vertex),
        input_rate = .VERTEX,
    }

    vertex_attributes := []sdl.GPUVertexAttribute {
        {
            location = 0,
            buffer_slot = 0,
            format = .FLOAT4,
            offset = u32(offset_of(Vertex, pos))
        },
        {
            location = 1,
            buffer_slot = 0,
            format = .FLOAT4,
            offset = u32(offset_of(Vertex, color))
        },
        {
            location = 2,
            buffer_slot = 0,
            format = .FLOAT2,
            offset = u32(offset_of(Vertex, uv))
        }
    }

    pipeline := sdl.CreateGPUGraphicsPipeline(gpu, {
        vertex_shader = vertex_shader,
        fragment_shader = fragment_shader,
        primitive_type = .TRIANGLELIST,
        target_info = {
            num_color_targets = 1,
            color_target_descriptions = &sdl.GPUColorTargetDescription {
                format = sdl.GetGPUSwapchainTextureFormat(gpu, window)
            }
        },
        vertex_input_state = {
            vertex_buffer_descriptions = &vertex_buffer_description,
            num_vertex_buffers = 1,
            vertex_attributes = raw_data(vertex_attributes),
            num_vertex_attributes = u32(len(vertex_attributes))
        }
    })
    defer sdl.ReleaseGPUGraphicsPipeline(gpu, pipeline)

    sdl.ReleaseGPUShader(gpu, vertex_shader)
    sdl.ReleaseGPUShader(gpu, fragment_shader)

    height: i32
    width: i32
    _ = sdl.GetWindowSize(window, &width, &height)

    aspect := f32(width) / f32(height)
    projection_matrix := linalg.matrix4_perspective_f32(70, aspect, 0.0001, 1000)

    vertices := []Vertex {
            { // bl
                pos = {-1, -1, 0, 1},
                color = {1, 1, 0, 1},
                uv = {0, 1},
            },
            { // tl
                pos = {-1, 1, 0, 1},
                color = {1, 0, 1, 1},
                uv = {0, 0},
            },
            { // tr
                pos = {1, 1, 0, 1},
                color = {0, 1, 1, 1},
                uv = {1, 0},
            },
            { // br
                pos = {1, -1, 0, 1},
                color = {1, 1, 1, 1},
                uv = {1, 1},
            }
    }
    vertices_size := u32(len(vertices) * size_of(Vertex))

    indices := []u32{
        0, 1, 2,
        0, 2, 3,
    }
    indices_size := u32(len(indices) * size_of(u32))

    // Create Vertex Buffer
    vertex_buffer := sdl.CreateGPUBuffer(gpu, {
        usage = {.VERTEX},
        size = vertices_size
    })

    index_buffer := sdl.CreateGPUBuffer(gpu, {
        usage = {.INDEX},
        size = indices_size
    })

    // Create Transfer Buffer
    transfer_buffer := sdl.CreateGPUTransferBuffer(gpu, {
        usage = .UPLOAD,
        size = vertices_size + indices_size
    })

    // Map Transfer Buffer Memory
    transfer_buffer_mem := transmute([^]byte)sdl.MapGPUTransferBuffer(gpu, transfer_buffer, false)

    // Copy to Transfer Buffer
    mem.copy(transfer_buffer_mem, raw_data(vertices), int(vertices_size))
    mem.copy(transfer_buffer_mem[vertices_size:], raw_data(indices), int(indices_size))

    // Unmap Transfer Buffer
    sdl.UnmapGPUTransferBuffer(gpu, transfer_buffer)

    // Create Copy Pass Command Buffer
    copy_command_buffer := sdl.AcquireGPUCommandBuffer(gpu)

    // Start Copy Pass
    copy_pass := sdl.BeginGPUCopyPass(copy_command_buffer)
    // Copy from TBuffer to Vertex Buffer
    sdl.UploadToGPUBuffer(copy_pass, {
        transfer_buffer = transfer_buffer,
        offset = 0
    }, {
        buffer = vertex_buffer,
        offset = 0,
        size = vertices_size
    }, false)

    // Copy from TBuffer to Index Buffer
    sdl.UploadToGPUBuffer(copy_pass, {
        transfer_buffer = transfer_buffer,
        offset = vertices_size
    }, {
        buffer = index_buffer,
        offset = 0,
        size = indices_size
    }, false)

    // End Copy Pass
    sdl.EndGPUCopyPass(copy_pass)
    // Submit Command Buffer
    ok = sdl.SubmitGPUCommandBuffer(copy_command_buffer)
    assert(ok, "Failed to submit vertex copy buffer")

    vertex_buffer_binding := sdl.GPUBufferBinding {
        buffer = vertex_buffer,
        offset = 0
    }

    main_loop: for {
        // process events
        ev: sdl.Event
        for sdl.PollEvent(&ev) {
            #partial switch ev.type {
                case .QUIT:
                    break main_loop
                case .KEY_DOWN:
                    if ev.key.scancode == .ESCAPE do break main_loop
            }
        }

        // update game state
        currentTime := sdl.GetTicks()
        deltaTime := (currentTime - time) / 1000
        time = currentTime

        model_matrix := linalg.matrix4_translate_f32({0, 0, -5})
        model_matrix *= linalg.matrix4_rotate_f32(f32(f32(currentTime) / 1000), [3]f32{0, 1, 0})

        ubo := UBO {
            mvp_matrix = projection_matrix * model_matrix
        }

        // render
        // acquire command buffer
        command_buffer := sdl.AcquireGPUCommandBuffer(gpu)

        // acquire swapchain texture (screen texture)
        swapchain_texture: ^sdl.GPUTexture
        ok = sdl.WaitAndAcquireGPUSwapchainTexture(command_buffer, window, &swapchain_texture, nil, nil)
        assert(ok, "Failed to acquire swapchain texture")

        color_target := sdl.GPUColorTargetInfo {
            texture = swapchain_texture,
            load_op = .CLEAR,
            clear_color = {0, 0.2, 0.4, 1},
            store_op = .STORE
        }
        render_pass := sdl.BeginGPURenderPass(command_buffer, &color_target, 1, nil)

        // draw stuff
        sdl.BindGPUGraphicsPipeline(render_pass, pipeline)
        sdl.BindGPUVertexBuffers(render_pass, 0, &vertex_buffer_binding, 1)
        sdl.PushGPUVertexUniformData(command_buffer, 0, &ubo, size_of(UBO))
        sdl.BindGPUIndexBuffer(render_pass, {buffer = index_buffer}, ._32BIT)
        sdl.BindGPUFragmentSamplers(render_pass, 0, &(sdl.GPUTextureSamplerBinding{sampler = sampler, texture = texture}), 1)
        // sdl.DrawGPUPrimitives(render_pass, 3, 1, 0, 0) - old (for drawing direct points)
        sdl.DrawGPUIndexedPrimitives(render_pass, 6, 1, 0, 0, 0)

        // end render pass
        sdl.EndGPURenderPass(render_pass)

        // submit command buffer
        ok = sdl.SubmitGPUCommandBuffer(command_buffer)
        assert(ok, "Failed to submit command buffer")
    }
}

ExtraShaderInfo :: struct {
    num_samplers: u32,
    num_storage_textures: u32,
    num_uniform_buffers: u32,
    num_storage_buffers: u32,
}

load_shader :: proc(gpu: ^sdl.GPUDevice, code: []u8, entrypoint: cstring, stage: sdl.GPUShaderStage, extra_info: ExtraShaderInfo = {}) -> ^sdl.GPUShader {
    return sdl.CreateGPUShader(gpu, {
        code_size = len(code),
        code = raw_data(code),
        entrypoint = entrypoint,
        format = {.MSL},
        stage = stage,
        num_samplers = extra_info.num_samplers,
        num_storage_textures = extra_info.num_storage_textures,
        num_uniform_buffers = extra_info.num_uniform_buffers,
        num_storage_buffers = extra_info.num_storage_buffers
    })
}