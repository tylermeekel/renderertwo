#include <metal_stdlib>
#include <metal_math>
#include <metal_texture>
using namespace metal;

#line 12187 "hlsl.meta.slang"
struct pixelOutput_0
{
    float4 output_0 [[color(0)]];
};


#line 12187
struct pixelInput_0
{
    float4 color_0 [[user(_SLANG_ATTR)]];
};


#line 12187
struct _MatrixStorage_float4x4_ColMajornatural_0
{
    array<float4, int(4)> data_0;
};


#line 12187
struct UBO_natural_0
{
    _MatrixStorage_float4x4_ColMajornatural_0 mvp_0;
};


#line 30 "shaders/main.slang"
[[fragment]] pixelOutput_0 fragment_main(pixelInput_0 _S1 [[stage_in]], float4 pos_0 [[position]], UBO_natural_0 constant* uniformBuffer_0 [[buffer(0)]])
{

#line 30
    pixelOutput_0 _S2 = { _S1.color_0 };


    return _S2;
}


#line 33
struct vertex_main_Result_0
{
    float4 pos_1 [[position]];
    float4 color_1 [[user(_SLANG_ATTR)]];
};


#line 33
struct vertexInput_0
{
    float4 pos_2 [[attribute(0)]];
    float4 color_2 [[attribute(1)]];
};


#line 10
struct VertexOut_0
{
    float4 pos_3;
    float4 color_3;
};


#line 10
[[vertex]] vertex_main_Result_0 vertex_main(vertexInput_0 _S3 [[stage_in]], UBO_natural_0 constant* uniformBuffer_1 [[buffer(0)]])
{

#line 21
    thread VertexOut_0 vert_out_0;

    (&vert_out_0)->pos_3 = (((_S3.pos_2) * (matrix<float,int(4),int(4)> (uniformBuffer_1->mvp_0.data_0[int(0)][int(0)], uniformBuffer_1->mvp_0.data_0[int(1)][int(0)], uniformBuffer_1->mvp_0.data_0[int(2)][int(0)], uniformBuffer_1->mvp_0.data_0[int(3)][int(0)], uniformBuffer_1->mvp_0.data_0[int(0)][int(1)], uniformBuffer_1->mvp_0.data_0[int(1)][int(1)], uniformBuffer_1->mvp_0.data_0[int(2)][int(1)], uniformBuffer_1->mvp_0.data_0[int(3)][int(1)], uniformBuffer_1->mvp_0.data_0[int(0)][int(2)], uniformBuffer_1->mvp_0.data_0[int(1)][int(2)], uniformBuffer_1->mvp_0.data_0[int(2)][int(2)], uniformBuffer_1->mvp_0.data_0[int(3)][int(2)], uniformBuffer_1->mvp_0.data_0[int(0)][int(3)], uniformBuffer_1->mvp_0.data_0[int(1)][int(3)], uniformBuffer_1->mvp_0.data_0[int(2)][int(3)], uniformBuffer_1->mvp_0.data_0[int(3)][int(3)]))));
    (&vert_out_0)->color_3 = _S3.color_2;

#line 24
    thread vertex_main_Result_0 _S4;

#line 24
    (&_S4)->pos_1 = vert_out_0.pos_3;

#line 24
    (&_S4)->color_1 = vert_out_0.color_3;

#line 24
    return _S4;
}

