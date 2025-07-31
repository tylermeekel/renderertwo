[shader("vertex")]
float4 vertex_main(
    uint vertex_id: SV_VertexID,
) {
    if (vertex_id == 0) {
        return float4(-0.5, -0.5, 0.0, 1.0);
    } else if (vertex_id == 1) {
        return float4(0, 0.5, 0, 1);
    } else if (vertex_id == 2) {
        return float4(0.5, -0.5, 0.0, 1.0);
    } else {
        return float4(0, 0, 0, 0);
    }
}

[shader("fragment")]
float4 fragment_main() {
    return float4(1, 0, 0, 1);
}