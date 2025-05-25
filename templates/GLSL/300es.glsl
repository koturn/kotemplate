#version 300 es
/*!
 * @brief Template GLSL file for OpenGL ES 3.0.
 *
 * Remove #version on ShaderToy or TwiGL.
 *
 * @author <+AUTHOR+>
 * @date <+DATE+>
 * @file <+FILE+>
 * @version 0.1
 */
precision mediump float;

// Platform switch.
#define PLATFORM PLATFORM_OTHER
// Shadertoy: https://www.shadertoy.com
#define PLATFORM_SHADERTOY 1
// TwiGL: https://twigl.app/
#define PLATFORM_TWIGL 2
// NEORT: https://neort.io/createfromglsl
#define PLATFORM_NEORT 3
// glsl.app; https://glsl.app/
#define PLATFORM_GLSLAPP 4
// vscode-glsl-canvas: https://marketplace.visualstudio.com/items?itemName=circledev.glsl-canvas
// vim-previmglsl: https://github.com/koturn/vim-previmglsl
#define PLATFORM_OTHER 99

#if PLATFORM == PLATFORM_SHADERTOY
#    define u_resolution iResolution
#    define u_time iTime
#    define u_mouse iMouse
#    define u_backBuffer iChannel0
#elif PLATFORM == PLATFORM_TWIGL || PLATFORM == PLATFORM_NEORT
#    define u_resolution resolution
#    define u_time time
#    define u_mouse mouse
#    define u_backBuffer backbuffer
#endif

#if PLATFORM != PLATFORM_SHADERTOY
//! Screen resolution.
uniform vec2 u_resolution;
//! Elapsed seconds.
uniform float u_time;
#    if PLATFORM == PLATFORM_GLSLAPP
//! Mouse position (zw is click flags).
uniform vec4 u_mouse;
#    else
//! Mouse position.
uniform vec2 u_mouse;
#    endif
//! Pseudo framerate.
const float iFrameRate = 60.0;
//! Pseudo delta-time.
const float iTimeDelta = 1.0 / iFrameRate;
//! Pseudo elapsed number of frames.
#    define iFrame int(u_time * iFrameRate)
//! Output color
out vec4 FragColor;
#endif


void mainImage(out vec4 fragColor, vec2 fragCoord);


#if PLATFORM != PLATFORM_SHADERTOY
/*!
 * @brief Entry point of this fragment shader program.
 */
void main(void)
{
    mainImage(/* out */ FragColor, gl_FragCoord.xy);
}
#endif


/*!
 * @brief Body of fragment shader function.
 * @param [out] fragColor  Color of fragment.
 * @param [in] fragCoord  Coordinate of fragment.
 */
void mainImage(out vec4 fragColor, vec2 fragCoord)
{
    <+CURSOR+>
    vec2 position = (fragCoord.xy * 2.0 - u_resolution.xy) / min(u_resolution.x, u_resolution.y);
    fragColor = vec4(position, 0.0, 1.0);
}
