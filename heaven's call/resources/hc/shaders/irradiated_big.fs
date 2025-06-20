varying vec4 Color0;
varying vec2 TexCoord0;
varying vec4 ColorizeOut;
varying vec3 ColorOffsetOut;
varying vec2 TextureSizeOut;
varying float PixelationAmountOut;
varying vec3 ClipPlaneOut;

uniform sampler2D Texture0;

//Video URL: https://youtu.be/f4s1h2YETNY
vec3 palette( float t ) {
	vec3 a = vec3(1.5, 2.5, 0.5);
	vec3 b = vec3(0.5, 0.5, 0.5);
	vec3 c = vec3(1.0, 1.0, 1.0);
	vec3 d = vec3(0.263,0.416,0.557);

	return a + b*cos( 6.28318*(c*t+d) );
}

vec4 SquareStatic(vec2 uv, float time){

	vec2 uv0 = uv;
	
	vec3 finalColor = vec3(.0);

	for (float i = 0.0; i < 4.0; i++) {
		uv = fract(uv * 1000.5) - 1.5;

		float d = length(uv) * exp(-length(uv0));

		vec3 col = palette(length(uv0) + i*.4 + time*.4);

		d = sin(d*8. + time)/8.;
		d = abs(d);

		d = pow(.01 / d, 1.2);

		finalColor += col * d;
	}

	return vec4(finalColor, 1.0);
}

const float PI = 3.1415926535;
const float L = .8;
const float epsilon = 0.1;

vec4 GreenMiles(vec2 uv, float time){
	float tiempo = time/100.0;

	float pt = fract(tiempo*0.1)*10.28;
	uv.x += sin(pt)*1.3;
	uv.y += uv.x*cos(pt)*0.6;


	float d1 = length(uv*0.33);
	float n = 14.0;
	float escala = 50000.0;
	n += cos(d1+uv.y*escala+tiempo*10.2)*2.0;
	float m=sin(uv.x*escala+tiempo*10.35-(d1*0.34))*1.0;

	n += 2.50*sin(uv.y+tiempo);
	m += 0.66*cos(tiempo+uv.x*0.5);

	float node = abs(cos(n * PI * uv.x / L) * cos(m * PI * uv.y / L) - cos(m * PI * uv.x / L) * cos(n * PI * uv.y / L));

	float v = smoothstep(0., epsilon, node*0.05);
	v=0.3/pow(v,.75);

	float xx = length(vec3(v*.55,v*0.45,v*0.85));
	xx = smoothstep(.05,7.5,xx);
	xx = pow(xx,10.0);


	return vec4( vec3(xx,0.7,xx), 1. );
}

//dog
vec3 mod289(vec3 x)
{
	return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x)
{
	return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x)
{
	return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
{
	const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
					  0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
					 -0.577350269189626,  // -1.0 + 2.0 * C.x
					  0.024390243902439); // 1.0 / 41.0
	// First corner
	vec2 i  = floor(v + dot(v, C.yy) );
	vec2 x0 = v -   i + dot(i, C.xx);

	// Other corners
	vec2 i1;
	//i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
	//i1.y = 1.0 - i1.x;
	i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
	// x0 = x0 - 0.0 + 0.0 * C.xx ;
	// x1 = x0 - i1 + 1.0 * C.xx ;
	// x2 = x0 - 1.0 + 2.0 * C.xx ;
	vec4 x12 = x0.xyxy + C.xxzz;
	x12.xy -= i1;

	// Permutations
	i = mod289(i); // Avoid truncation effects in permutation
	vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));

	vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
	m = m*m ;
	m = m*m ;

	// Gradients: 41 points uniformly over a line, mapped onto a diamond.
	// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

	vec3 x = 2.0 * fract(p * C.www) - 1.0;
	vec3 h = abs(x) - 0.5;
	vec3 ox = floor(x + 0.5);
	vec3 a0 = x - ox;

	// Normalise gradients implicitly by scaling m
	// Approximation of: m *= inversesqrt( a0*a0 + h*h );
	m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

	// Compute final noise value at P
	vec3 g;
	g.x  = a0.x  * x0.x  + h.x  * x0.y;
	g.yz = a0.yz * x12.xz + h.yz * x12.yw;
	return 130.0 * dot(m, g);
}

void main(void)
{
	// Clip
	if(dot(gl_FragCoord.xy, ClipPlaneOut.xy) < ClipPlaneOut.z)
		discard;
		
	// Pixelate
	vec2 pa = vec2(1.0+PixelationAmountOut, 1.0+PixelationAmountOut) / TextureSizeOut;
	
	vec2 uv_aligned = TexCoord0 - mod(TexCoord0, pa) + pa * 0.5;
	vec2 uv = PixelationAmountOut > 0.0 ? uv_aligned : TexCoord0;
	uv = uv_aligned;
	
	vec4 Color = Color0 * texture2D(Texture0, PixelationAmountOut > 0.0 ? TexCoord0 - mod(TexCoord0, pa) + pa * 0.5 : TexCoord0);
	//vec4 Color = texture2D(Texture0, uv);
	
	float t = ColorizeOut.a*10.0*PI + PI*(TexCoord0.x * (TextureSizeOut.x / TextureSizeOut.y) + TexCoord0.y);
	//t = 1.0-pow(max(0.0,sin(t)), 20.0)-sin(t)/4.0;
	
	float r = ColorOffsetOut.x * Color.a;
	float g = ColorOffsetOut.y * Color.a;
	float b = ColorOffsetOut.z * Color.a;
	
	//if (0.65 < r && g < 0.55 && (0.55 < b && b < 0.85) ){
	if (r < 0.1 && 0.9 < g && b < 0.1 ){
		Color = SquareStatic(uv/1., g*512.);
	}
	//else if (r < 0.5 && g >= 0.5 && b < 0.5){
	else if ((0.8 < r && r < 0.9) && g >= 0.9 && b <= 0.1){
		Color = GreenMiles(uv/1., b*1024.);
	}
	
	vec3 Colorized = Color.rgb;
	gl_FragColor = vec4(Colorized, Color.a);
	
	gl_FragColor.rgb = mix(gl_FragColor.rgb, gl_FragColor.rgb - mod(gl_FragColor.rgb, 1.0/16.0) + 1.0/32.0, clamp(PixelationAmountOut, 0.0, 1.0));
}

