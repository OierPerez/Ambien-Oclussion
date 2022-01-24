#version 400


layout(location = 0) in vec3 position;
layout(location = 1) in vec3 in_normal;
layout(location = 2) in vec4 in_tangent;
layout(location = 3) in vec2 UV;
layout(location = 4) in vec4 joints;
layout(location = 5) in vec4 weights;

uniform mat4 M;
uniform mat4 P;
uniform mat4 C;

uniform mat4 jointMatrix[128];
uniform bool UseSkin;


out vec3 pos;
out vec2 uv;
out vec3 normal;
out vec3 tangent;

void main()
{

    mat4 skin_matrix;
    
    if(UseSkin)
    {
        skin_matrix = weights.x * jointMatrix[int(joints.x)] +
	 			      weights.y * jointMatrix[int(joints.y)] +
	 			      weights.z * jointMatrix[int(joints.z)] +
	 			      weights.w * jointMatrix[int(joints.w)];
    }
    else
	    skin_matrix = mat4(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1);
    
    gl_Position = P*C*M*skin_matrix* vec4(position, 1);
    pos = (C*M*skin_matrix* vec4(position,1)).xyz;
    normal = normalize(vec3( transpose(inverse(C*M * skin_matrix)) * vec4(in_normal, 0)));
    tangent = vec3( (C*M*skin_matrix) * vec4(in_tangent.xyz, 0));
    uv = UV;
}