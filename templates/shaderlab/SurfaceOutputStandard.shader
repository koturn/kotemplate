Shader "<+AUTHOR+>/SurfaceOutputStandard"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)

        _EmissionTex ("Emission texture", 2D) = "white" {}
        [HDR] _EmissionColor ("Multiplicative color for _EmissionTex", Color) = (0.0, 0.0, 0.0, 1.0)

        _NormalMapIntensity ("Normal Intensity", Float) = 1.0
        _NormalMap("Normal Map", 2D) = "bump" {}

        _Glossiness ("Smoothness", Range(0.0, 1.0)) = 0.5
        _Metallic ("Metallic", Range(0.0, 1.0)) = 0.0

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
            "RenderType" = "Opaque"
        }

        LOD 200

        Cull [_Cull]
        ZWrite [_ZWrite]
        ZTest [_ZTest]
        Blend [_SrcFactor] [_DstFactor]

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0


        struct Input
        {
            float2 uv_MainTex;
        };


        UNITY_DECLARE_TEX2D(_MainTex);
        uniform fixed4 _Color;
        UNITY_DECLARE_TEX2D(_EmissionTex);
        uniform fixed3 _EmissionColor;
        UNITY_DECLARE_TEX2D(_NormalMap);
        uniform half _NormalMapIntensity;
        uniform half _Glossiness;
        uniform half _Metallic;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = UNITY_SAMPLE_TEX2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
            o.Emission = UNITY_SAMPLE_TEX2D(_EmissionTex, IN.uv_MainTex).rgb * _EmissionColor;
            o.Normal = lerp(
                float3(0.0, 0.0, 1.0),
                UnpackNormal(UNITY_SAMPLE_TEX2D(_NormalMap, IN.uv_MainTex)),
                _NormalMapIntensity);
            o.Smoothness = _Glossiness;
            o.Metallic = _Metallic;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
