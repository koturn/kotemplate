Shader "<+AUTHOR+>/CustomRenderTexture"
{
    Properties
    {
        _MainTexture2D ("Main Texture", 2D) = "white" {}
    }
    SubShader
    {
        Blend One Zero
        Cull Off
        Lighting Off
        ZWrite Off
        ZTest Always

        Pass
        {
            Name "Update"

            CGPROGRAM
            #pragma target 3.0

            #include "UnityCustomRenderTexture.cginc"

            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag

            uniform sampler2D _MainTexture2D;
            uniform float4 _MainTexture2D_ST;
            uniform float4 _MainTexture2D_TexelSize;

            float4 frag(v2f_customrendertexture i) : COLOR
            {
                // <+CURSOR+>
                return tex2D(_MainTexture2D, i.globalTexcoord);
                // return tex2D(_SelfTexture2D, i.globalTexcoord);
            }
            ENDCG
        }
    }
}
