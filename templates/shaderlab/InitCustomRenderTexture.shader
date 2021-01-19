Shader "<+AUTHOR+>/InitCustomRenderTexture"
{
    Properties
    {
        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _Tex ("InputTex", 2D) = "white" {}
    }

    SubShader
    {
        Lighting Off
        Blend One Zero

        Pass
        {
            CGPROGRAM
            #include "UnityCustomRenderTexture.cginc"

            #pragma vertex InitCustomRenderTextureVertexShader
            #pragma fragment frag
            #pragma target 3.0

            uniform float4 _Color;
            uniform sampler2D _Tex;

            float4 frag(v2f_init_customrendertexture in) : COLOR
            {
                return _Color * tex2D(_Tex, in.texcoord.xy);
            }
            ENDCG
        }
    }
}
