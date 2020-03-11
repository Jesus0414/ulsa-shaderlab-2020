Shader "Custom/SD_Actividad"
{
    Properties
    {
        _Albedo("Albedo Color", Color) = (1,1,1,1)
        [HDR]_RimColor("Rim Light Color", Color) = (1,1,1,1)
        _RimPower("Rim Power", Range(0.0,8.0)) = 0.5
        _MainTex("Main Texture", 2D) = "white"{}
        _NormalTex("Normal Texture", 2D) = "bump"{}
        _RampText("Ramp Texture", 2D) = "white"{}
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM
            #pragma surface surf Lambert

            sampler2D _RampTex;

            half4 LightingRamp(SurfaceOutput s, half3 lightDir, half atten)
            {
                half NdotL = dot(s.Normal, lightDir);
                half diff = NdotL * 0.5 + 0.5;
                float2 uv_RampTex = float2(diff, 0);
                half3 rampColor = tex2D(_RampTex, uv_RampTex).rgb;
                half4 c;
                c.rgb = s.Albedo * _LightColor0.rgb * atten * rampColor;
                c.a = s.Alpha;
                return c;
            }

            half4 LightingLambertWrap(SurfaceOutput s, half3 lightDir, half atten)
            {
                half NdotL = dot (s.Normal, lightDir);
                half diff = NdotL * 0.5 + 0.5;
                half4 c;
                c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten);
                c.a = s.Alpha;
                return c;
            }

            half4 _Albedo;
            sampler _MainTex;
            sampler _NormalTex;
            half3 _RimColor;
            float _RimPower;

            struct Input
            {
                float a;
                float2 uv_MainTex;
                float2 uv_NormalTex;
                float3 viewDir;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                o.Albedo = _Albedo.rgb;
                half4 texColor = tex2D(_MainTex, IN.uv_MainTex);
                o.Albedo = texColor.rgb;
                half4 normalColor = tex2D(_NormalTex, IN.uv_NormalTex);
                half3 normal = UnpackNormal(normalColor);
                o.Normal = normal;
                float3 nVD = normalize(IN.viewDir);
                float3 NdotV = dot(nVD, o.Normal);
                half rim = 1 - saturate(NdotV);
                o.Emission = _RimColor.rgb * pow(rim, _RimPower);

            }

        ENDCG
    }
}