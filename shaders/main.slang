struct UBO {
    float4x4 mvp;
};

struct Vertex {
    float4 pos;
    float4 color;
};

struct VertexOut {
    float4 pos: SV_Position;
    float4 color;
}

ConstantBuffer<UBO> uniformBuffer: register(b0);

[shader("vertex")]
VertexOut vertex_main(
    Vertex vertex,
) {
    VertexOut vert_out;

    vert_out.pos = mul(uniformBuffer.mvp, vertex.pos);
    vert_out.color = vertex.color;

    return vert_out;
}

[shader("fragment")]
float4 fragment_main(
    VertexOut vertex_in,
) {
    return vertex_in.color;
}