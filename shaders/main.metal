#include <metal_stdlib>
#include <metal_math>
#include <metal_texture>
using namespace metal;

#line 2 "shaders/main.slang"
struct vertexOutput_0
{
    float4 output_0 [[position]];
};


#line 2
[[vertex]] vertexOutput_0 vertex_main(uint vertex_id_0 [[vertex_id]])
{

    if(vertex_id_0 == 0U)
    {

#line 5
        vertexOutput_0 _S1 = { float4(-0.5, -0.5, 0.0, 1.0) };
        return _S1;
    }
    else
    {

#line 7
        if(vertex_id_0 == 1U)
        {

#line 7
            vertexOutput_0 _S2 = { float4(0.0, 0.5, 0.0, 1.0) };
            return _S2;
        }
        else
        {

#line 9
            if(vertex_id_0 == 2U)
            {

#line 9
                vertexOutput_0 _S3 = { float4(0.5, -0.5, 0.0, 1.0) };
                return _S3;
            }
            else
            {

#line 10
                vertexOutput_0 _S4 = { float4(0.0, 0.0, 0.0, 0.0) };

                return _S4;
            }

#line 12
        }

#line 12
    }

#line 12
}


#line 12
struct pixelOutput_0
{
    float4 output_1 [[color(0)]];
};

[[fragment]] pixelOutput_0 fragment_main()
{

#line 17
    pixelOutput_0 _S5 = { float4(1.0, 0.0, 0.0, 1.0) };
    return _S5;
}

