#version 450

uniform vec2 resolution;
uniform vec3 lightPosition;// = vec3(100.0, 200.0, 500.0);
const vec3 eye = vec3(0.0, 200.0, 500.0);
uniform sampler2D texsample;
uniform sampler2D normals;
uniform float time;

in vec2 texcoord;
in vec3 world;

out vec4 frag;

float saturate(float value) {
	return clamp(value, 0.0, 1.0);	
}

void main() {
	//lightPosition.x = sin(time) * 1000.0;
	//lightPosition.y = sin(time * 0.5) * 2000.0;
	//vec2 position = gl_FragCoord.xy;
	//vec2 texcoord = (position.xy + 1.0) / 2.0;
	vec3 normal = texture(normals, texcoord).rgb * 2.0 - 1.0;
	
	//vec3 world = vec3(gl_FragCoord.xy, 0);
	//world.x /= resolution.x;
	//world.y /= resolution.y;
	vec3 lightDirection = normalize(world - lightPosition);
	//lightDirection = vec3(0.1, 0.2, -0.7);
	float diffuse = saturate(dot(normal, -lightDirection));
	vec3 h = normalize(normalize(eye - world) - lightDirection);
	float specular = pow(saturate(dot(h, normal)), 15.0);
	float light = 0.2 + diffuse * 0.5;
	
	float a = texture(texsample, texcoord).a;
	frag = vec4(texture(texsample, texcoord).xyz * light + specular * a, a);
}
