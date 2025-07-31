#include <metal_stdlib>
#include <metal_math>
#include <metal_texture>
using namespace metal;

#line 12187 "hlsl.meta.slang"
struct vertexOutput_0
{
    float4 output_0 [[position]];
};


#line 12187
struct _MatrixStorage_float4x4_ColMajornatural_0
{
    array<float4, int(4)> data_0;
};


#line 12187
struct UBO_natural_0
{
    _MatrixStorage_float4x4_ColMajornatural_0 projection_matrix_0;
    float4 color_0;
};


#line 4311 "core.meta.slang"
struct KernelContext_0
{
    UBO_natural_0 constant* uniformBuffer_0;
};


#line 9 "shaders/main.slang"
[[vertex]] vertexOutput_0 vertex_main(uint vertex_id_0 [[vertex_id]], UBO_natural_0 constant* uniformBuffer_1 [[buffer(0)]])
{

#line 10
    KernelContext_0 kernelContext_0;

#line 10
    (&kernelContext_0)->uniformBuffer_0 = uniformBuffer_1;

#line 10
    float4 position_0;



    if(vertex_id_0 == 0U)
    {

#line 14
        position_0 = float4(-0.5, -0.5, -5.0, 1.0);

#line 14
    }
    else
    {

#line 16
        if(vertex_id_0 == 1U)
        {

#line 16
            position_0 = float4(0.0, 0.5, -5.0, 1.0);

#line 16
        }
        else
        {

#line 18
            if(vertex_id_0 == 2U)
            {

#line 18
                position_0 = float4(0.5, -0.5, -5.0, 1.0);

#line 18
            }
            else
            {

#line 18
                position_0 = float4(0.0, 0.0, 0.0, 0.0);

#line 18
            }

#line 16
        }

#line 14
    }

#line 14
    vertexOutput_0 _S1 = { (((position_0) * (matrix<float,int(4),int(4)> ((&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(0)][int(0)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(1)][int(0)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(2)][int(0)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(3)][int(0)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(0)][int(1)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(1)][int(1)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(2)][int(1)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(3)][int(1)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(0)][int(2)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(1)][int(2)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(2)][int(2)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(3)][int(2)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(0)][int(3)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(1)][int(3)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(2)][int(3)], (&kernelContext_0)->uniformBuffer_0->projection_matrix_0.data_0[int(3)][int(3)])))) };

#line 24
    return _S1;
}


#line 24
struct pixelOutput_0
{
    float4 output_1 [[color(0)]];
};


#line 28
[[fragment]] pixelOutput_0 fragment_main(UBO_natural_0 constant* uniformBuffer_2 [[buffer(0)]])
{

#line 28
    pixelOutput_0 _S2 = { uniformBuffer_2->color_0 };
    return _S2;
}

