Shader "Custom/SurfaceShaderDiffuseColor"
{
    Properties
    {
        _Albedo("Albedo Principal", Color) = (1,1,1,1)
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
        //float, half, flex, int    
        half4 _Albedo;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Albedo;
        }

        ENDCG
    }
}
