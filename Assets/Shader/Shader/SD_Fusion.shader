Shader "Custom/SD_Fusion"
{
    Properties
    {
        //NormalMap
        _MainTex2("MainTexture", 2D) = "white" {}
        _NormalTex("Normal Texture", 2D) = "bump" {} 

        //NormalStrength
        _Albedo("Albedo Color", color) = (1,1,1,1)
        //_MainTex("Main Texture", 2D) = "white" {}
        //_NormalTex("Normal Texture", 2D) = "bump" {}
        _NormalStrength("Normal Strength", Range(-5,5)) = 1

        //RimLigth
        [HDR] _RimColor("Rim Color", Color) = (1, 0, 0, 1)
        _RimPower("Rim Power", Range(0.0, 8.0)) = 1.0

        //Texture
        //_AlbedoTex("Albedo Principal", Color) = (1,1,1,1)
        //_MainTex("Main Texture", 2D) = "white"{}

        //Color
        //_Albedo("Albedo Principal", Color) = (1,1,1,1)
        
        //NormalMap
        //NormalStrength
        //RimLigth
        //Texture
        //Color

    }
    Subshader
    {
        tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM
            #pragma surface surf Lambert
            //NormalMap
            sampler _MainTex2;
            sampler _NormalTex;

            //NormalStrength
            fixed3 _Albedo;
            //sampler _MainTex;
            //sampler _NormalTex;
            float _NormalStrength;

            //RimLigth
            half3 _RimColor;
            float _RimPower;
            
            //Texture
            //half4 _AlbedoTex;
            //sampler2D _MainTex;
            
            //Color
            //half4 _Albedo;
            
            struct Input
            {
                //NormalMap
                float2 uv_MainTex2;
                float2 uv_NormalTex;

                //NormalStrength
                //float2 uv_MainTex;
                //float2 uv_NormalTex;
                
                //RimLigth
                float3 viewDir;

                //Texture
                //float2 uv_MainTex;

                //Color
                //float2 uv_MainTex;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                //NormalMap
                half4 texColor3 = tex2D(_MainTex2, IN.uv_MainTex2);
                o.Albedo = texColor3.rgb;
                half4 normalColor = tex2D(_NormalTex, IN.uv_NormalTex);
                half3 normal = UnpackNormal(normalColor);
                o.Normal = normal;

                //NormalStrength
                fixed3 texColor2 = tex2D(_MainTex2, IN.uv_MainTex2);
                o.Albedo = texColor2  * _Albedo;
                fixed4 normalColor2 = tex2D(_NormalTex, IN.uv_NormalTex);
                fixed3 normal2 = UnpackNormal(normalColor2).rgb;
                normal2.z = normal2.z / _NormalStrength;
                o.Normal = normalize(normal2);

                //RimLigth
                float3 nVD = normalize(IN.viewDir);
                float3 NdotV = dot(nVD, o.Normal);
                half rim = 1 - saturate(NdotV);
                o.Emission = _RimColor.rgb * pow(rim, _RimPower);

                //Texture
                //half4 texColor = tex2D( _MainTex, IN.uv_MainTex);
                //o.Albedo = _Albedo * texColor.rgb;

                //Color
               // o.Albedo = _Albedo;
            }

        ENDCG
    }
}