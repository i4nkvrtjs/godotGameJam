shader_type sky;
render_mode use_half_res_pass;

uniform vec3 topSkyDay : source_color;
uniform vec3 horizonSkyDay : source_color;
uniform vec3 topSkyNight : source_color;
uniform vec3 horizonSkyNight : source_color;
uniform vec3 horizonSunRiseSet : source_color;
uniform vec3 topSunRiseSet : source_color;
uniform vec3 sunColor : source_color;
uniform float sunSize = 0.2;
uniform vec3 moonColor : source_color;
uniform float moonSize = 0.1;
uniform float moonOffset = 0.05;

uniform float starDensity = 0.002;  // Controls number of stars
uniform float starSize = 0.002;     // Controls how big each star appears

// Hash function for random star placement
float hash(vec3 p) {
    return fract(sin(dot(p, vec3(127.1, 311.7, 74.7))) * 43758.5453);
}

void sky() {
    // Sun blending
    float sunDirection = distance(EYEDIR.xyz, LIGHT0_DIRECTION);
    float sunPosition = 1.0 - clamp(sunDirection / sunSize, 0.0, 1.0);
    float sunDisk = smoothstep(0.0, sunSize, sunPosition);
    vec4 sun = vec4(sunColor, sunDisk);
    
    // Moon blending
    float moonDirection = distance(EYEDIR.xyz, -LIGHT0_DIRECTION);
    float moonPosition = 1.0 - clamp(moonDirection / moonSize, 0.0, 1.0);
    float moonDisk = smoothstep(0.0, moonSize, moonPosition);
    vec4 moon = vec4(moonColor, moonDisk);

    // Sky gradient blending
    float colorGradient = clamp(EYEDIR.y, 0.0, 1.0);
    vec3 skyColorDay = mix(horizonSkyDay, topSkyDay, colorGradient);
    vec3 skyColorNight = mix(horizonSkyNight, topSkyNight, colorGradient);
    vec3 skyColorSunRiseSet = mix(horizonSunRiseSet, topSunRiseSet, colorGradient);

    float lightY = LIGHT0_DIRECTION.y;
    float dayFactor = smoothstep(0.0, 0.2, lightY);  // Soft transition for day
    float nightFactor = smoothstep(-0.3, 0.0, lightY); // Soft transition for night

    vec3 skyColor = mix(skyColorNight, skyColorSunRiseSet, nightFactor);
    skyColor = mix(skyColor, skyColorDay, dayFactor);

    // Blend the sun into the sky
    skyColor = mix(skyColor, sun.rgb, sun.a);

    // Blend the moon into the night sky
    skyColor = mix(skyColor, moon.rgb, moon.a);

    // --------- FIXED STAR GENERATION ---------
    if (lightY < 0.0) {  // Only show stars at night
        vec3 worldPos = normalize(EYEDIR); // Ensures stars are placed in world space

        float starNoise = hash(floor(worldPos * (1.0 / starDensity))); 
        
        float threshold = 1.0 - starDensity * 5.0;

        if (starNoise > threshold) {
            float starBrightness = smoothstep(threshold, 1.0, starNoise);
            
            // Ensure stars have a proper circular shape
            float starShape = smoothstep(starSize, 0.0, length(fract(worldPos.xy * 100.0) - 0.5));
            
            skyColor += vec3(1.0) * starBrightness * starShape;
        }
    }

    COLOR = skyColor;
}
