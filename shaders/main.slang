struct UBO {
    float4x4 projection_matrix;
};

ConstantBuffer<UBO> uniformBuffer: register(b0);

[shader("vertex")]
float4 vertex_main(
    uint vertex_id: SV_VertexID,
) {
    float4 position;

    if (vertex_id == 0) {
        position = float4(-0.5, -0.5, -5.0, 1.0);
    } else if (vertex_id == 1) {
        position = float4(0, 0.5, -5.0, 1);
    } else if (vertex_id == 2) {
        position = float4(0.5, -0.5, -5.0, 1.0);
    } else {
        position = float4(0, 0, 0, 0);
    }

    return mul(uniformBuffer.projection_matrix, position);
}

[shader("fragment")]
float4 fragment_main() {
    return float4(1, 0, 0, 1);
}