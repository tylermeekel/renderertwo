#include <metal_stdlib>
#include <metal_math>
#include <metal_texture>
using namespace metal;

#line 1875 "hlsl.meta.slang"
struct pixelOutput_0
{
    float4 output_0 [[color(0)]];
};


#line 1875
struct pixelInput_0
{
    float4 color_0 [[user(_SLANG_ATTR)]];
    float2 uv_0 [[user(_SLANG_ATTR_1)]];
};


#line 1875
struct _MatrixStorage_float4x4_ColMajornatural_0
{
    array<float4, int(4)> data_0;
};


#line 1875
struct UBO_natural_0
{
    _MatrixStorage_float4x4_ColMajornatural_0 mvp_0;
};


#line 4311 "core.meta.slang"
struct KernelContext_0
{
    UBO_natural_0 constant* uniformBuffer_0;
    texture2d<float, access::sample> entryPointParams_sampler_texture_0;
    sampler entryPointParams_sampler_sampler_0;
};


#line 33 "shaders/main.slang"
[[fragment]] pixelOutput_0 fragment_main(pixelInput_0 _S1 [[stage_in]], float4 pos_0 [[position]], UBO_natural_0 constant* uniformBuffer_1 [[buffer(0)]], texture2d<float, access::sample> entryPointParams_sampler_texture_1, sampler entryPointParams_sampler_sampler_1)
{

#line 33
    KernelContext_0 kernelContext_0;

#line 33
    (&kernelContext_0)->uniformBuffer_0 = uniformBuffer_1;

#line 33
    (&kernelContext_0)->entryPointParams_sampler_texture_0 = entryPointParams_sampler_texture_1;

#line 33
    (&kernelContext_0)->entryPointParams_sampler_sampler_0 = entryPointParams_sampler_sampler_1;



    ;

#line 37
    pixelOutput_0 _S2 = { (((&kernelContext_0)->entryPointParams_sampler_texture_0).sample(((&kernelContext_0)->entryPointParams_sampler_sampler_0), (_S1.uv_0))) };

#line 37
    return _S2;
}


#line 37
struct vertex_main_Result_0
{
    float4 pos_1 [[position]];
    float4 color_1 [[user(_SLANG_ATTR)]];
    float2 uv_1 [[user(_SLANG_ATTR_1)]];
};


#line 37
struct vertexInput_0
{
    float4 pos_2 [[attribute(0)]];
    float4 color_2 [[attribute(1)]];
    float2 uv_2 [[attribute(2)]];
};


#line 11
struct VertexOut_0
{
    float4 pos_3;
    float4 color_3;
    float2 uv_3;
};


#line 11
[[vertex]] vertex_main_Result_0 vertex_main(vertexInput_0 _S3 [[stage_in]], UBO_natural_0 constant* uniformBuffer_2 [[buffer(0)]])
{

#line 23
    thread VertexOut_0 vert_out_0;

    (&vert_out_0)->pos_3 = (((_S3.pos_2) * (matrix<float,int(4),int(4)> (uniformBuffer_2->mvp_0.data_0[int(0)][int(0)], uniformBuffer_2->mvp_0.data_0[int(1)][int(0)], uniformBuffer_2->mvp_0.data_0[int(2)][int(0)], uniformBuffer_2->mvp_0.data_0[int(3)][int(0)], uniformBuffer_2->mvp_0.data_0[int(0)][int(1)], uniformBuffer_2->mvp_0.data_0[int(1)][int(1)], uniformBuffer_2->mvp_0.data_0[int(2)][int(1)], uniformBuffer_2->mvp_0.data_0[int(3)][int(1)], uniformBuffer_2->mvp_0.data_0[int(0)][int(2)], uniformBuffer_2->mvp_0.data_0[int(1)][int(2)], uniformBuffer_2->mvp_0.data_0[int(2)][int(2)], uniformBuffer_2->mvp_0.data_0[int(3)][int(2)], uniformBuffer_2->mvp_0.data_0[int(0)][int(3)], uniformBuffer_2->mvp_0.data_0[int(1)][int(3)], uniformBuffer_2->mvp_0.data_0[int(2)][int(3)], uniformBuffer_2->mvp_0.data_0[int(3)][int(3)]))));
    (&vert_out_0)->color_3 = _S3.color_2;
    (&vert_out_0)->uv_3 = _S3.uv_2;

#line 27
    thread vertex_main_Result_0 _S4;

#line 27
    (&_S4)->pos_1 = vert_out_0.pos_3;

#line 27
    (&_S4)->color_1 = vert_out_0.color_3;

#line 27
    (&_S4)->uv_1 = vert_out_0.uv_3;

#line 27
    return _S4;
}

