
struct DirectionalLight
{
	float4 AmbientColor;
	float4 DiffuseColor;
	float3 Direction;
};

cbuffer externalData : register(b0)
{
	DirectionalLight light_1;
	DirectionalLight light_2;
};

// Struct representing the data we expect to receive from earlier pipeline stages
// - Should match the output of our corresponding vertex shader
// - The name of the struct itself is unimportant
// - The variable names don't have to match other shaders (just the semantics)
// - Each variable must have a semantic, which defines its usage
struct VertexToPixel
{
	// Data type
	//  |
	//  |   Name          Semantic
	//  |    |                |
	//  v    v                v
	float4 position		: SV_POSITION;
	float3 normal		: NORMAL;
};

// --------------------------------------------------------
// The entry point (main method) for our pixel shader
// 
// - Input is the data coming down the pipeline (defined by the struct)
// - Output is a single color (float4)
// - Has a special semantic (SV_TARGET), which means 
//    "put the output of this into the current render target"
// - Named "main" because that's the default the shader compiler looks for
// --------------------------------------------------------
float4 main(VertexToPixel input) : SV_TARGET
{
	// Just return the input color
	// - This color (like most values passing through the rasterizer) is 
	//   interpolated for each pixel between the corresponding vertices 
	//   of the triangle we're rendering
	//return input.color;

	//return float4(1, 0, 0, 1);

	// Creates a float4 from a float3 and one more value
	//return light.DiffuseColor; // This line should be temporary

	input.normal = normalize(input.normal);

	float3 direction_1 = normalize(-light_1.Direction);
	float4 amount_1 = saturate(dot(input.normal, direction_1));

	float3 direction_2 = normalize(-light_2.Direction);
	float4 amount_2 = saturate(dot(input.normal, direction_2));

	return (amount_1 * light_1.DiffuseColor + light_1.AmbientColor) + (amount_2 * light_2.DiffuseColor + light_2.AmbientColor);

}