Shader "Custom/Warhol" {
	Properties {
		_MainTex ("Monroe", 2D) = "white" {}
		_OverlayTex("Overlay", 2D) = "white" {}
		_BlendAlpha("Blend", Range(-5,5)) = 2.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		float _BlendAlpha;
		sampler2D _MainTex;
		sampler2D _OverlayTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutputStandard o) {
			// Make sure uv is not upside down
			#if UNITY_UV_STARTS_AT_TOP
			IN.uv_MainTex = -IN.uv_MainTex;
			#endif

			// Invert the blend range value
			_BlendAlpha = -_BlendAlpha;

			float4 main = tex2D(_MainTex, IN.uv_MainTex * 2);
			float4 overlay = tex2D(_OverlayTex, IN.uv_MainTex);
			fixed4 c = ((1 - _BlendAlpha) * main) + _BlendAlpha * overlay;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
