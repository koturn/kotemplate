precision mediump float;

//! Elapsed seconds.
uniform float u_time;
//! Mouse position.
uniform vec2 u_mouse;
//! Screen resolution.
uniform vec2 u_resolution;


#ifndef DOXYGEN
float sdf(vec3 p);
float sdSphere(vec3 p, float size);
vec3 getNormal(vec3 p);
float sq(float x);
#endif


/*!
 * @brief Entry point of this fragment shader program.
 */
void main(void)
{
    const float MinRayDist = 0.001;
    const float MaxRayDist = 1000.0;
    const int LoopMax = 128;
    const float ScreenZ = 4.0;
    const vec3 lightDir = normalize(vec3(0.0, 1.0, 1.0));

    const vec3 kAlbedo = vec3(1.0, 1.0, 1.0);
    const float kSpecularPower = 50.0;
    const vec3 kSpecularColor = vec3(0.5, 0.5, 0.5);
    const vec3 kLightCol = vec3(1.0, 1.0, 1.0);

    const vec3 cameraPos = vec3(0.0, 0.0, 10.0);

    vec2 position = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / min(u_resolution.x, u_resolution.y);

    vec3 rayDir = normalize(vec3(position, ScreenZ) - cameraPos);

    // Distance.
    float d = 0.0;
    // Total distance.
    float t = 0.0;

    for (int i = 0; i < LoopMax; i++) {
        vec3 rayPos = cameraPos + rayDir * t;
        d = sdf(rayPos);
        t += d;
        if (d < MinRayDist || t > MaxRayDist) {
            break;
        }
    }

    if (d > MinRayDist) {
        discard;
    }

    vec3 finalRayPos = cameraPos + rayDir * t;
    vec3 normal = getNormal(finalRayPos);

    float nDotL = max(0.0, dot(normal, lightDir));

    // vec3 color = vec3(nDotL);
    vec3 diffuse = vec3(sq(0.5 * nDotL + 0.5)) * kLightCol;

    vec3 viewDir = normalize(cameraPos - finalRayPos);
    vec3 specular = pow(max(0.0, dot(normalize(lightDir + viewDir), normal)), kSpecularPower) * kSpecularColor.xyz * kLightCol;

    gl_FragColor = vec4(diffuse * kAlbedo + specular, 1.0);
}


/*!
 * @brief SDF (Signed Distance Function) of objects.
 * @param [in] p  Position of the tip of the ray.
 * @return Signed Distance to the objects.
 */
float sdf(vec3 p)
{
    // <+CURSOR+>
    return sdSphere(p, 0.5);
}


/*!
 * @brief SDF of Sphere.
 * @param [in] p  Position of the tip of the ray.
 * @param [in] size  Size of sphere.
 * @return Signed Distance to the Sphere.
 */
float sdSphere(vec3 p, float size)
{
    return length(p) - size;
}


/*!
 * @brief Calculate normal of the objects.
 * @param [in] p  Position of the tip of the ray.
 * @return Normal of the objects.
 */
vec3 getNormal(vec3 p)
{
    const vec2 k = vec2(1.0, -1.0);
    const vec2 kh = vec2(0.001, -0.001);

    return normalize(
        k.xyy * sdf(p + kh.xyy)
            + k.yyx * sdf(p + kh.yyx)
            + k.yxy * sdf(p + kh.yxy)
            + sdf(p + kh.xxx));
}


/*!
 * @brief Calculate squared value.
 * @param [in] x  A value.
 * @return x * x
 */
float sq(float x)
{
    return x * x;
}
