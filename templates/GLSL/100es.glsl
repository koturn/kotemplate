/*!
 * @brief Template GLSL file for OpenGL ES 1.0.
 *
 * Remove #version on ShaderToy or TwiGL.
 *
 * @author <+AUTHOR+>
 * @date <+DATE+>
 * @file <+FILE+>
 * @version 0.1
 */
#ifdef GL_ES
precision mediump float;
#else
precision highp float;
#endif

// Platform switch.
#define PLATFORM PLATFORM_OTHER
// Shadertoy: https://www.shadertoy.com/new#
#define PLATFORM_SHADERTOY 1
// TwiGL: https://twigl.app/
#define PLATFORM_TWIGL 2
// NEORT: https://neort.io/createfromglsl
// GLSL SANDBOX: https://glslsandbox.com/
#define PLATFORM_NEORT 3
// js4kintro: http://jp.wgld.org/js4kintro/editor/
#define PLATFORM_JS4KINTRO 5
// The Book of Shaders: http://editor.thebookofshaders.com/
// vscode-glsl-canvas: https://marketplace.visualstudio.com/items?itemName=circledev.glsl-canvas
// vim-previmglsl: https://github.com/koturn/vim-previmglsl
#define PLATFORM_OTHER 99

#if PLATFORM == PLATFORM_SHADERTOY
#    define u_resolution iResolution
#    define u_time iTime
#    define u_mouse iMouse
#    define u_backBuffer iChannel0
#    define texture2D texture
#    define textureCube texture
#elif PLATFORM == PLATFORM_TWIGL || PLATFORM == PLATFORM_NEORT
#    define u_resolution resolution
#    define u_time time
#    define u_mouse mouse
// NOTE: backbuffer is not supported on GLSL SANDBOX.
#    define u_backBuffer backbuffer
#elif PLATFORM == PLATFORM_JS4KINTRO
#    define u_resolution r
#    define u_time t
#    define u_mouse m
#    define u_backBuffer smp
#endif


#if PLATFORM != PLATFORM_SHADERTOY
//! Screen resolution.
uniform vec2 u_resolution;
//! Elapsed seconds.
uniform float u_time;
//! Mouse position.
uniform vec2 u_mouse;
//! Previous frame.
uniform sampler2D u_backBuffer;
//! Pseudo framerate.
const float iFrameRate = 60.0;
//! Pseudo delta-time.
const float iTimeDelta = 1.0 / iFrameRate;
//! Pseudo elapsed number of frames.
#    define iFrame int(u_time * iFrameRate)
#endif


void mainImage(out vec4 fragColor, vec2 fragCoord);


#if PLATFORM != PLATFORM_SHADERTOY
/*!
 * @brief Entry point of this fragment shader program.
 */
void main(void)
{
    mainImage(/* out */ gl_FragColor, gl_FragCoord.xy);
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
