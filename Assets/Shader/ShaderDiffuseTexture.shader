Shader "Custom/ShaderDiffuseTexture"
{
    Properties
    {
        _Albedo("Albedo Principal", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
    }

    SubShader
    {
        Tags 
        { 
            "Queue" = "Geometry" 
            "RenderType"="Opaque" //opaque= luz opaca;  
        }

        CGPROGRAM

        #pragma surface surf Lambert
        //VARIABLES         float, half, flex, int    
        half4 _Albedo;
        sampler2D _MainTex;


        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            half4 texColor = tex2D( _MainTex, IN.uv_MainTex);
            o.Albedo = _Albedo * texColor.rgb;
        }

        ENDCG
    }
}
