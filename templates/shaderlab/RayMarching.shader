Shader "<+AUTHOR+>/RayMarching/<+FILEBASE+>"
{
    Properties
    {
        _MaxLoop ("Maximum loop count", Int) = 256
        _MinRayLength ("Minimum length of the ray", Float) = 0.01
        _MaxRayLength ("Maximum length of the ray", Float) = 1000.0
        _Scale ("Scale vector", Vector) = (1.0, 1.0, 1.0, 1.0)
        _MarchingFactor ("Marching Factor", Float) = 1.0

        _Color ("Color of the objects", Color) = (1.0, 1.0, 1.0, 1.0)
        _SpecularPower ("Specular Power", Range(0.0, 100.0)) = 5.0
        _SpecularColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1.0)

        [KeywordEnum(Optimized, Optimized Loop, Conventional)]
        _NormalCalcMode ("Normal Calculation Mode", Int) = 0

        [KeywordEnum(Lembert, Half Lembert, Squred Half Lembert, Disable)]
        _DiffuseMode ("Reflection Mode", Int) = 2

        [KeywordEnum(Original, Half Vector, Disable)]
        _SpecularMode ("Specular Mode", Int) = 1

        [KeywordEnum(Legacy, SH9, Disable)]
        _AmbientMode ("Ambient Mode", Int) = 1

        [Toggle(_ENABLE_REFLECTION_PROBE)]
        _EnableReflectionProbe ("Enable Reflection Probe", Int) = 1

        _RefProbeBlendCoeff ("Blend coefficient of reflection probe", Range(0.0, 1.0)) = 0.5

        [Enum(UnityEngine.Rendering.CullMode)]
        _Cull ("Culling Mode", Int) = 1  // Default: Front

        // [ColorMask]
        _ColorMask ("Color Mask", Int) = 15

        [Enum(Off, 0, On, 1)]
        _AlphaToMask ("Alpha To Mask", Int) = 0  // Default: Off
    }

    SubShader
    {
        Tags
        {
            "Queue" = "AlphaTest"
            "RenderType" = "Transparent"
            "DisableBatching" = "True"
            "IgnoreProjector" = "True"
            "VRCFallback" = "Hidden"
        }

        Cull [_Cull]
        ColorMask [_ColorMask]
        AlphaToMask [_AlphaToMask]

        CGINCLUDE
        #pragma target 3.0

        // keywords:
        //   FOG_LINEAR
        //   FOG_EXP
        //   FOG_EXP2
        #pragma multi_compile_fog

        #pragma shader_feature_local_fragment _NORMALCALCMODE_OPTIMIZED _NORMALCALCMODE_OPTIMIZED_LOOP _NORMALCALCMODE_OPTIMIZED_CONVENTIONAL
        #pragma shader_feature_local_fragment _DIFFUSEMODE_LEMBERT _DIFFUSEMODE_HALF_LEMBERT _DIFFUSEMODE_SQURED_HALF_LEMBERT _DIFFUSEMODE_DISABLE
        #pragma shader_feature_local_fragment _SPECULARMODE_ORIGINAL _SPECULARMODE_HALF_VECTOR _SPECULARMODE_DISABLE
        #pragma shader_feature_local_fragment _AMBIENTMODE_LEGACY _AMBIENTMODE_SH _AMBIENTMODE_DISABLE
        #pragma shader_feature_local_fragment _ _ENABLE_REFLECTION_PROBE

        #include "UnityCG.cginc"
        #include "UnityStandardUtils.cginc"
        #include "AutoLight.cginc"


        /*!
         * @brief Input of vertex shader.
         */
        struct appdata
        {
            //! Local position of the vertex.
            float4 vertex : POSITION;
            //! Second texture coordinate.
            float2 uv2 : TEXCOORD1;
        };

        /*!
         * @brief Output of vertex shader and input of fragment shader.
         */
        struct v2f
        {
            //! Clip space position of the vertex.
            float4 pos : SV_POSITION;
            //! World position at the pixel.
            float3 localPos : TEXCOORD0;
            //! Local space position of the camera.
            nointerpolation float3 localSpaceCameraPos : TEXCOORD1;
            //! Local space light position.
            nointerpolation float3 localSpaceLightPos : TEXCOORD2;
            //! Lighting and shadowing parameters.
            UNITY_LIGHTING_COORDS(3, 4)
        };

        /*!
         * @brief Output of fragment shader.
         */
        struct fout
        {
            //! Output color of the pixel.
            half4 color : SV_Target;
            //! Depth of the pixel.
            float depth : SV_Depth;
        };

        /*!
         * @brief Output of rayMarch().
         */
        struct rmout
        {
            //! Length of the ray.
            float rayLength;
            //! A flag whether the ray collided with an object or not.
            bool isHit;
        };


        rmout rayMarch(float3 rayOrigin, float3 rayDir);
        float map(float3 p);
        float sdSphere(float3 p, float r);
        float3 getNormal(float3 p);
        half4 applyFog(float fogFactor, half4 color);
        float3 worldToObjectPos(float3 worldPos);
        float3 worldToObjectPos(float4 worldPos);
        float3 objectToWorldPos(float3 localPos);
        fixed getLightAttenuation(v2f fi, float3 worldPos);
        half4 getRefProbeColor(float3 refDir, float3 worldPos);
        half4 getRefProbeColor0(float3 refDir, float3 worldPos);
        half4 getRefProbeColor1(float3 refDir, float3 worldPos);
        float3 boxProj0(float3 refDir, float3 worldPos);
        float3 boxProj1(float3 refDir, float3 worldPos);
        float3 boxProj(float3 refDir, float3 worldPos, float4 probePos, float4 boxMin, float4 boxMax);
        float sq(float x);
        float3 normalizeEx(float3 v);


        //! Color of light.
        uniform fixed4 _LightColor0;

        //! Color of the objects.
        uniform half4 _Color;
        //! Maximum loop count.
        uniform int _MaxLoop;
        //! Minimum length of the ray.
        uniform float _MinRayLength;
        //! Maximum length of the ray.
        uniform float _MaxRayLength;
        //! Scale vector.
        uniform float3 _Scale;
        //! Marching Factor.
        uniform float _MarchingFactor;
        //! Specular power.
        uniform float _SpecularPower;
        //! Specular color.
        uniform float4 _SpecularColor;
        //! Blend coefficient of reflection probe.
        uniform float _RefProbeBlendCoeff;

        /*!
         * @brief Vertex shader function.
         *
         * @param [in] v  Input data
         * @return Output for fragment shader (v2f).
         */
        v2f vert(appdata v)
        {
            v2f o;
            UNITY_INITIALIZE_OUTPUT(v2f, o);

            o.localPos = v.vertex.xyz;
            o.localSpaceCameraPos = worldToObjectPos(_WorldSpaceCameraPos) * _Scale;
#ifdef USING_DIRECTIONAL_LIGHT
            o.localSpaceLightPos = normalizeEx(mul((float3x3)unity_WorldToObject, _WorldSpaceLightPos0.xyz) * _Scale);
#else
            o.localSpaceLightPos = worldToObjectPos(_WorldSpaceLightPos0) * _Scale;
#endif  // USING_DIRECTIONAL_LIGHT
            UNITY_TRANSFER_LIGHTING(o, v.uv2);

            v.vertex.xyz /= _Scale;
            o.pos = UnityObjectToClipPos(v.vertex);

            return o;
        }


        /*!
         * @brief Fragment shader function.
         *
         * @param [in] fi  Input data from vertex shader.
         * @return Output of each texels (fout).
         */
        fout frag(v2f fi)
        {
            // Define ray direction by finding the direction of the local coordinates
            // of the mesh from the local coordinates of the viewpoint.
            const float3 localRayDir = normalize(fi.localPos - fi.localSpaceCameraPos);

            const rmout ro = rayMarch(fi.localSpaceCameraPos, localRayDir);
            if (!ro.isHit) {
                discard;
            }

            const float3 localFinalPos = fi.localSpaceCameraPos + localRayDir * ro.rayLength;
            const float3 worldFinalPos = objectToWorldPos(localFinalPos);

            const float3 localNormal = getNormal(localFinalPos);
            const float3 localViewDir = normalize(fi.localSpaceCameraPos - localFinalPos);
#ifdef USING_DIRECTIONAL_LIGHT
            const float3 localLightDir = fi.localSpaceLightPos;
#else
            const float3 localLightDir = normalize(fi.localSpaceLightPos - localFinalPos);
#endif  // USING_DIRECTIONAL_LIGHT
            const fixed3 lightCol = _LightColor0.rgb * getLightAttenuation(fi, worldFinalPos);

            // Lambertian reflectance.
            const float nDotL = dot(localNormal, localLightDir);
#if defined(_DIFFUSEMODE_SQURED_HALF_LEMBERT)
            const half3 diffuse = lightCol * sq(nDotL * 0.5 + 0.5);
#elif defined(_DIFFUSEMODE_HALF_LEMBERT)
            const half3 diffuse = lightCol * (nDotL * 0.5 + 0.5);
#elif defined(_DIFFUSEMODE_LEMBERT)
            const half3 diffuse = lightCol * max(0.0, nDotL);
#else
            const half3 diffuse = half3(1.0, 1.0, 1.0);
#endif  // defined(_DIFFUSEMODE_SQURED_HALF_LEMBERT)

            // Specular reflection.
#ifdef _SPECULARMODE_HALF_VECTOR
            const half3 specular = pow(max(0.0, dot(normalize(localLightDir + localViewDir), localNormal)), _SpecularPower) * _SpecularColor.xyz * lightCol;
#elif _SPECULARMODE_ORIGINAL
            const half3 specular = pow(max(0.0, dot(reflect(-localLightDir, localNormal), localViewDir)), _SpecularPower) * _SpecularColor.xyz * lightCol;
#else
            const half3 specular = half3(0.0, 0.0, 0.0);
#endif  // _SPECULARMODE_HALF_VECTOR

            // Ambient color.
#if !UNITY_SHOULD_SAMPLE_SH
            const half3 ambient = half3(0.0, 0.0, 0.0);
#elif defined(_AMBIENTMODE_SH)
            const half3 ambient = ShadeSHPerPixel(
                UnityObjectToWorldNormal(localNormal),
                half3(0.0, 0.0, 0.0),
                worldFinalPos);
#elif defined(_AMBIENTMODE_LEGACY)
            const half3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
#else
            const half3 ambient = half3(0.0, 0.0, 0.0);
#endif  // !UNITY_SHOULD_SAMPLE_SH

#ifdef _ENABLE_REFLECTION_PROBE
            const half4 refColor = getRefProbeColor(
                UnityObjectToWorldNormal(reflect(-localViewDir, localNormal)),
                worldFinalPos);
            const half4 col = half4((diffuse + ambient) * lerp(_Color.rgb, refColor.rgb, _RefProbeBlendCoeff) + specular, _Color.a);
#else
            const half4 col = half4((diffuse + ambient) * _Color.rgb + specular, _Color.a);
#endif  // _ENABLE_REFLECTION_PROBE

            const float4 projPos = UnityWorldToClipPos(worldFinalPos);

            fout fo;
            fo.color = applyFog(projPos.z, col);
            fo.depth = projPos.z / projPos.w;

            return fo;
        }


        /*!
         * @brief Execute ray marching.
         *
         * @param [in] rayOrigin  Origin of the ray.
         * @param [in] rayDir  Direction of the ray.
         * @return Result of the ray marching.
         */
        rmout rayMarch(float3 rayOrigin, float3 rayDir)
        {
            rmout ro;
            ro.rayLength = 0.0;
            ro.isHit = false;

            // Marching Loop.
            for (int i = 0; i < _MaxLoop; i++) {
                // Position of the tip of the ray.
                const float d = map((rayOrigin + rayDir * ro.rayLength));

                ro.isHit = d < _MinRayLength;
                ro.rayLength += d * _MarchingFactor;

                // Break this loop if the ray goes too far or collides.
                if (ro.isHit || ro.rayLength > _MaxRayLength) {
                    break;
                }
            }

            return ro;
        }

        /*!
         * @brief SDF (Signed Distance Function) of objects.
         *
         * @param [in] p  Position of the tip of the ray.
         * @return Signed Distance to the objects.
         */
        float map(float3 p)
        {
            // <+CURSOR+>
            return sdSphere(p, 0.5);
        }

        /*!
         * @brief SDF of Sphere.
         *
         * @param [in] r  Radius of sphere.
         * @return Signed Distance to the Sphere.
         */
        float sdSphere(float3 p, float r)
        {
            return length(p) - r;
        }

        /*!
         * @brief Calculate normal of the objects.
         *
         * @param [in] p  Position of the tip of the ray.
         * @return Normal of the objects.
         * @see https://iquilezles.org/articles/normalsSDF/
         */
        float3 getNormal(float3 p)
        {
#if defined(_NORMALCALCMODE_OPTIMIZED)
            // Lightweight normal calculation.
            // SDF is called four times and each calling is inlined.
            static const float2 k = float2(1.0, -1.0);
            static const float2 kh = k * 0.0001;

            return normalize(
                k.xyy * map(p + kh.xyy)
                    + k.yxy * map(p + kh.yxy)
                    + k.yyx * map(p + kh.yyx)
                    + map(p + kh.xxx));
#elif defined(_NORMALCALCMODE_OPTIMIZED_LOOP)
            // SDF is called four times.
            // When the loop is not unrolled, there is only one SDF calling in the loop,
            // which helps reduce code size.
            static const float2 k = float2(1.0, -1.0);
            static const float h = 0.0001;
            static const float3 ks[4] = {k.xyy, k.yxy, k.yyx, k.xxx};

            float3 normal = float3(0.0, 0.0, 0.0);

            UNITY_LOOP
            for (int i = 0; i < 4; i++) {
                normal += ks[i] * map(p + ks[i] * h);
            }
            return normalize(normal);
#else
            // Naive normal calculation.
            // SDF is called six times and each calling is inlined.
            static const float2 d = float2(0.0001, 0.0);

            return normalize(
                float3(
                    map(p + d.xyy) - map(p - d.xyy),
                    map(p + d.yxy) - map(p - d.yxy),
                    map(p + d.yyx) - map(p - d.yyx)));
#endif  // defined(_NORMALCALCMODE_OPTIMIZED)
        }

        /*!
         * @brief Apply fog.
         *
         * UNITY_APPLY_FOG includes some variable declaration.
         * This function can be used to localize those declarations.
         * If fog is disabled, this function returns color as is.
         *
         * @param [in] color  Target color.
         * @return Fog-applied color.
         */
        half4 applyFog(float fogFactor, half4 color)
        {
            UNITY_APPLY_FOG(fogFactor, color);
            return color;
        }

        /*!
         * @brief Convert from world coordinate to local coordinate.
         *
         * @param [in] worldPos  World coordinate.
         * @return World coordinate.
         */
        float3 worldToObjectPos(float3 worldPos)
        {
            return worldToObjectPos(float4(worldPos, 1.0));
        }

        /*!
         * @brief Convert from world coordinate to local coordinate.
         *
         * @param [in] worldPos  World coordinate.
         * @return World coordinate.
         */
        float3 worldToObjectPos(float4 worldPos)
        {
            return mul(unity_WorldToObject, worldPos).xyz;
        }


        /*!
         * @brief Convert from local coordinate to world coordinate.
         *
         * @param [in] localPos  Local coordinate.
         * @return World coordinate.
         */
        float3 objectToWorldPos(float3 localPos)
        {
            return mul(unity_ObjectToWorld, float4(localPos, 1.0)).xyz;
        }

        /*!
         * @brief Get Light Attenuation.
         *
         * @param [in] fi  Input data for fragment shader.
         * @param [in] worldPos  World coordinate.
         * @return Light Attenuation Value.
         */
        fixed getLightAttenuation(v2f fi, float3 worldPos)
        {
            // v must be declared in this scope.
            // v must include following.
            //   vertex : POSITION
            // a._ShadowCoord = mul( unity_WorldToShadow[0], mul( unity_ObjectToWorld, v.vertex ) );
            // UNITY_TRANSFER_SHADOW(fi, texcoord2);

            // a._LightCoord = mul(unity_WorldToLight, mul(unity_ObjectToWorld, v.vertex)).xyz;
            // UNITY_TRANSFER_LIGHTING(fi, texcoord2);

            // v2f must include following.
            //   pos : SV_POSITION
            UNITY_LIGHT_ATTENUATION(atten, fi, worldPos);
            return atten;
        }

        /*!
         * @brief Get blended color of the two reflection probes.
         *
         * @param [in] refDir  Reflect direction (must be normalized).
         * @param [in] worldPos  World coordinate.
         * @return Color of reflection probe.
         */
        half4 getRefProbeColor(float3 refDir, float3 worldPos)
        {
            return lerp(
                getRefProbeColor1(refDir, worldPos),
                getRefProbeColor0(refDir, worldPos),
                unity_SpecCube0_BoxMin.w);
        }

        /*!
         * @brief Get color of the first reflection probe.
         *
         * @param [in] refDir  Reflect direction (must be normalized).
         * @param [in] worldPos  World coordinate.
         * @return Color of the first reflection probe.
         */
        half4 getRefProbeColor0(float3 refDir, float3 worldPos)
        {
            half4 refColor = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, boxProj0(refDir, worldPos), 0.0);
            refColor.rgb = DecodeHDR(refColor, unity_SpecCube0_HDR);
            return refColor;
        }

        /*!
         * @brief Get color of the second reflection probe.
         *
         * @param [in] refDir  Reflect direction (must be normalized).
         * @param [in] worldPos  World coordinate.
         * @return Color of the second reflection probe.
         */
        half4 getRefProbeColor1(float3 refDir, float3 worldPos)
        {
            half4 refColor = UNITY_SAMPLE_TEXCUBE_SAMPLER_LOD(unity_SpecCube1, unity_SpecCube0, boxProj1(refDir, worldPos), 0.0);
            refColor.rgb = DecodeHDR(refColor, unity_SpecCube1_HDR);
            return refColor;
        }

        /*!
         * @brief Get reflection direction of the first reflection probe
         * considering box projection.
         *
         * @param [in] refDir  Refrection dir (must be normalized).
         * @param [in] worldPos  World coordinate.
         * @return Refrection direction considering box projection.
         */
        float3 boxProj0(float3 refDir, float3 worldPos)
        {
            return boxProj(
                refDir,
                worldPos,
                unity_SpecCube0_ProbePosition,
                unity_SpecCube0_BoxMin,
                unity_SpecCube0_BoxMax);
        }

        /*!
         * @brief Get reflection direction of the second reflection probe
         * considering box projection.
         *
         * @param [in] refDir  Refrection dir (must be normalized).
         * @param [in] worldPos  World coordinate.
         * @return Refrection direction considering box projection.
         */
        float3 boxProj1(float3 refDir, float3 worldPos)
        {
            return boxProj(
                refDir,
                worldPos,
                unity_SpecCube1_ProbePosition,
                unity_SpecCube1_BoxMin,
                unity_SpecCube1_BoxMax);
        }

        /*!
         * @brief Obtain reflection direction considering box projection.
         *
         * This function is more efficient than BoxProjectedCubemapDirection() in UnityStandardUtils.cginc.
         *
         * @param [in] refDir  Refrection dir (must be normalized).
         * @param [in] worldPos  World coordinate.
         * @param [in] probePos  Position of Refrection probe.
         * @param [in] boxMin  Position of Refrection probe.
         * @param [in] boxMax  Position of Refrection probe.
         * @return Refrection direction considering box projection.
         */
        float3 boxProj(float3 refDir, float3 worldPos, float4 probePos, float4 boxMin, float4 boxMax)
        {
            // UNITY_SPECCUBE_BOX_PROJECTION is defined if
            // "Reflection Probes Box Projection" of GraphicsSettings is enabled.
#ifdef UNITY_SPECCUBE_BOX_PROJECTION
            // probePos.w == 1.0 if Box Projection is enabled.
            if (probePos.w > 0.0) {
                const float3 magnitudes = ((refDir > 0.0 ? boxMax.xyz : boxMin.xyz) - worldPos) / refDir;
                refDir = refDir * min(magnitudes.x, min(magnitudes.y, magnitudes.z)) + (worldPos - probePos);
            }
#endif  // UNITY_SPECCUBE_BOX_PROJECTION

            return refDir;
        }

        /*!
         * @brief Calculate squared value.
         *
         * @param [in] x  A value.
         * @return x * x
         */
        float sq(float x)
        {
            return x * x;
        }

        /*!
         * @brief Zero-Division avoided normalize.
         * @param [in] v  A vector.
         * @return normalized vector or zero vector.
         */
        float3 normalizeEx(float3 v)
        {
            const float vDotV = dot(v, v);
            return vDotV == 0.0 ? v : (rsqrt(vDotV) * v);
        }

        ENDCG

        Pass
        {
            Name "FORWARD_BASE"
            Tags
            {
                "LightMode" = "ForwardBase"
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // keywords:
            //   DIRECTIONAL
            //   LIGHTMAP_ON
            //   DIRLIGHTMAP_COMBINED
            //   DYNAMICLIGHTMAP_ON
            //   LIGHTMAP_SHADOW_MIXING
            //   VERTEXLIGHT_ON
            //   LIGHTPROBE_SH
            #pragma multi_compile_fwdbase
            ENDCG
        }  // ForwardBase

        Pass
        {
            Name "FORWARD_ADD"
            Tags
            {
                "LightMode" = "ForwardAdd"
            }

            Blend One One
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // Keywords:
            //   POINT
            //   DIRECTIONAL
            //   SPOT
            //   POINT_COOKIE
            //   DIRECTIONAL_COOKIE
            #pragma multi_compile_fwdadd
            ENDCG
        }  // ForwardAdd
    }
}
