Shader "<+AUTHOR+>/UnlitVF"
{
    Properties
    {
        _MainTex ("Main texture", 2D) = "white" {}

        _Color ("Multiplicative color for _MainTex", Color) = (1.0, 1.0, 1.0, 1.0)

        _EmissionTex ("Emission texture", 2D) = "white" {}

        [HDR]
        _EmissionColor ("Multiplicative color for _EmissionTex", Color) = (0.0, 0.0, 0.0, 1.0)


        [Enum(UnityEngine.Rendering.CullMode)]
        _Cull("Culling Mode", Int) = 2  // Default: Back

        [HideInInspector]
        _RenderingMode("Rendering Mode", Int) = 2

        [Toggle]
        _AlphaTest("Alpha test", Int) = 0

        _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlend("Blend Source Factor", Int) = 5  // Default: SrcAlpha

        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlend("Blend Destination Factor", Int) = 10  // Default: OneMinusSrcAlpha

        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlendAlpha("Blend Source Factor", Int) = 5  // Default: SrcAlpha

        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlendAlpha("Blend Destination Factor", Int) = 10  // Default: OneMinusSrcAlpha

        [Enum(UnityEngine.Rendering.BlendOp)]
        _BlendOp("BlendOp", Int) = 0  // Default: Add

        [Enum(UnityEngine.Rendering.BlendOp)]
        _BlendOpAlpha("BlendOpAlpha", Int) = 0  // Default: Add

        [Enum(Off, 0, On, 1)]
        _ZWrite("ZWrite", Int) = 0  // Default: Off

        [Enum(UnityEngine.Rendering.CompareFunction)]
        _ZTest("ZTest", Int) = 4  // Default: LEqual

        [Enum(2D, 0, 3D, 1)]
        _OffsetFact("Offset Factor", Int) = 0

        _OffsetUnit("Offset Units", Range(-100, 100)) = 0

        Enum(None, 0, A, 1, B, 2, BA, 3, G, 4, GA, 5, GB, 6, GBA, 7, R, 8, RA, 9, RB,10, RBA, 11, RG, 12, RGA, 13, RGB, 14, RGBA, 15)
        _ColorMask("Color Mask", Int) = 15

        [Enum(Off, 0, On, 1)]
        _AlphaToMask("Alpha To Mask", Int) = 0  // Default: Off


        [IntRange]
        _StencilRef("Stencil Reference Value", Range(0, 255)) = 0

        [IntRange]
        _StencilReadMask("Stencil ReadMask Value", Range(0, 255)) = 255

        [IntRange]
        _StencilWriteMask("Stencil WriteMask Value", Range(0, 255)) = 255

        [Enum(UnityEngine.Rendering.CompareFunction)]
        _StencilCompFunc("Stencil Compare Function", Int) = 8  // Default: Always

        [Enum(UnityEngine.Rendering.StencilOp)]
        _StencilPass("Stencil Pass", Int) = 0  // Default: Keep

        [Enum(UnityEngine.Rendering.StencilOp)]
        _StencilFail("Stencil Fail", Int) = 0  // Default: Keep

        [Enum(UnityEngine.Rendering.StencilOp)]
        _StencilZFail("Stencil ZFail", Int) = 0  // Default: Keep
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "VRCFallback" = "StandardFade"
        }

        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
        BlendOp [_BlendOp], [_BlendOpAlpha]
        ZWrite [_ZWrite]
        ZTest [_ZTest]
        Offset [_OffsetFact], [_OffsetUnit]
        AlphaToMask [_AlphaToMask]

        Stencil
        {
            Ref [_StencilRef]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
            Comp [_StencilCompFunc]
            Pass [_StencilPass]
            Fail [_StencilFail]
            ZFail [_StencilZFail]
        }

        Pass
        {
            CGPROGRAM
            #pragma target 3.0

            #pragma only_renderers d3d9 d3d11 d3d11_9x glcore gles gles3 metal vulkan xboxone ps4 n3ds wiiu switch
            #pragma fragmentoption ARB_precision_hint_fastest

            #pragma multi_compile_fog
            #pragma shader_feature_local_fragment _ _ALPHATEST_ON

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            UNITY_DECLARE_TEX2D(_MainTex);
            uniform float4 _Color;
            UNITY_DECLARE_TEX2D(_EmissionTex);
            uniform float4 _EmissionColor;
#ifdef _ALPHATEST_ON
            uniform float _Cutoff;
#endif  // _ALPHATEST_ON

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
                UNITY_FOG_COORDS(1)
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
                UNITY_TRANSFER_FOG(o, o.vertex);
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
#if _ALPHATEST_ON
                clip(mainColor.a - _Cutoff);
#endif  // _ALPHATEST_ON

                const float4 emissionColor = UNITY_SAMPLE_TEX2D(_EmissionTex, i.uv) * _EmissionColor;
                float4 col = mainColor + emissionColor;
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }

    Fallback "Diffuse"
}
