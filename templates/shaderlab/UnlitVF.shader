Shader "<+AUTHOR+>/UnlitVF"
{
    Properties
    {
        _MainTex ("Main texture", 2D) = "white" {}
        _Color ("Multiplicative color for _MainTex", Color) = (1.0, 1.0, 1.0, 1.0)

        _EmissionTex ("Emission texture", 2D) = "white" {}
        [HDR] _EmissionColor ("Multiplicative color for _EmissionTex", Color) = (0.0, 0.0, 0.0, 1.0)

        [Toggle]
        _EnableFog ("Enable Fog", Float) = 1

        [Enum(UnityEngine.Rendering.CullMode)]
        _Cull("Cull", Float) = 2  // Default: Back

        [Enum(UnityEngine.Rendering.CompareFunction)]
        _ZTest("ZTest", Float) = 4  // Default: LEqual

        [Enum(Off, 0, On, 1)]
        _ZWrite("ZWrite", Float) = 0  // Default: Off

        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcFactor("Src Factor", Float) = 5  // Default: SrcAlpha

        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstFactor("Dst Factor", Float) = 10  // Default: OneMinusSrcAlpha
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }

        Cull [_Cull]
        ZWrite [_ZWrite]
        ZTest [_ZTest]
        Blend [_SrcFactor] [_DstFactor]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #pragma only_renderers d3d9 d3d11 d3d11_9x glcore gles gles3 metal vulkan xboxone ps4 n3ds wiiu switch
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_fog
            #pragma shader_feature _ _ENABLEFOG_ON

            #include "UnityCG.cginc"

            UNITY_DECLARE_TEX2D(_MainTex);
            uniform float4 _Color;
            UNITY_DECLARE_TEX2D(_EmissionTex);
            uniform float4 _EmissionColor;

            /*!
             * @brief Input data type for vertex shader function
             */
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            /*!
             * @brief Input data type for fragment shader function
             */
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
#ifdef _ENABLEFOG_ON
                UNITY_FOG_COORDS(1)
#endif  // _ENABLEFOG_ON
            };


            /*!
             * @brief Vertex shader function
             * @param [in] v  Input data
             * @return color of texel at (i.uv.x, i.uv.y)
             */
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
#ifdef _ENABLEFOG_ON
                UNITY_TRANSFER_FOG(o, o.vertex);
#endif  // _ENABLEFOG_ON
                return o;
            }

            /*!
             * @brief Fragment shader function
             * @param [in] i  Input data from vertex shader
             * @return color of texel at (i.uv.x, i.uv.y)
             */
            fixed4 frag(v2f i) : SV_Target
            {
                const float4 mainColor = UNITY_SAMPLE_TEX2D(_MainTex, i.uv) * _Color;
                const float4 emissionColor = UNITY_SAMPLE_TEX2D(_EmissionTex, i.uv) * _EmissionColor;
                float4 col = mainColor + emissionColor;
#ifdef _ENABLEFOG_ON
                UNITY_APPLY_FOG(i.fogCoord, col);
#endif  // _ENABLEFOG_ON
                return col;
            }
            ENDCG
        }
    }

    Fallback "Diffuse"
}
