package main

import "core:log"
import sdl "vendor:sdl3"

main_code := #load("./shaders/main.metal")

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
    assert(ok, "Failed to claim window for GPU device")

    vertex_shader := load_shader(gpu, main_code, "vertex_main", .VERTEX)
    assert(vertex_shader != nil, "Vertex Shader is nil!")
    fragment_shader := load_shader(gpu, main_code, "fragment_main", .FRAGMENT)
    assert(fragment_shader != nil, "Fragment Shader is nil!")

    pipeline := sdl.CreateGPUGraphicsPipeline(gpu, {
        vertex_shader = vertex_shader,
        fragment_shader = fragment_shader,
        primitive_type = .TRIANGLELIST,
        target_info = {
            num_color_targets = 1,
            color_target_descriptions = &sdl.GPUColorTargetDescription {
                format = sdl.GetGPUSwapchainTextureFormat(gpu, window)
            }
        }
    })
    defer sdl.ReleaseGPUGraphicsPipeline(gpu, pipeline)

    sdl.ReleaseGPUShader(gpu, vertex_shader)
    sdl.ReleaseGPUShader(gpu, fragment_shader)

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

        // render
        // acquire command buffer
        command_buffer := sdl.AcquireGPUCommandBuffer(gpu)

        // acquire swapchain texture (screen texture)
        swapchain_texture: ^sdl.GPUTexture
        ok = sdl.WaitAndAcquireGPUSwapchainTexture(command_buffer, window, &swapchain_texture, nil, nil)
        assert(ok, "Failed to acquire swapchain texture")
        // begin render pass

        color_target := sdl.GPUColorTargetInfo {
            texture = swapchain_texture,
            load_op = .CLEAR,
            clear_color = {0, 0.2, 0.4, 1},
            store_op = .STORE
        }
        render_pass := sdl.BeginGPURenderPass(command_buffer, &color_target, 1, nil)

        // draw stuff
        sdl.BindGPUGraphicsPipeline(render_pass, pipeline)
        sdl.DrawGPUPrimitives(render_pass, 3, 1, 0, 0)

        // end render pass
        sdl.EndGPURenderPass(render_pass)

        // submit command buffer
        ok = sdl.SubmitGPUCommandBuffer(command_buffer)
        assert(ok, "Failed to submit command buffer")
    }
}

load_shader :: proc(gpu: ^sdl.GPUDevice, code: []u8, entrypoint: cstring, stage: sdl.GPUShaderStage) -> ^sdl.GPUShader {
    return sdl.CreateGPUShader(gpu, {
        code_size = len(code),
        code = raw_data(code),
        entrypoint = entrypoint,
        format = {.MSL},
        stage = stage
    })
}