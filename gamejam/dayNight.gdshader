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
uniform vec3 ambientNightLight = vec3(0.05, 0.05, 0.1); // Soft blue night ambient light

void sky() {
    float sunDirection = distance(EYEDIR.xyz, LIGHT0_DIRECTION);
    float sunPosition = 1.0 - clamp(sunDirection / sunSize, 0.0, 1.0);
    float sunDisk = smoothstep(0.0, sunSize, sunPosition);
    vec4 sun = vec4(sunColor, sunDisk);
    
    float moonDirection = distance(EYEDIR.xyz, -LIGHT0_DIRECTION);
    float moonPosition = 1.0 - clamp(moonDirection / moonSize, 0.0, 1.0);
    float moonDisk = smoothstep(0.0, moonSize, moonPosition);

    float colorGradient = clamp(EYEDIR.y, 0.0, 1.0);
    vec3 skyColorDay = mix(horizonSkyDay, topSkyDay, colorGradient);
    vec3 skyColorNight = mix(horizonSkyNight, topSkyNight, colorGradient);
    vec3 skyColorSunRiseSet = mix(horizonSunRiseSet, topSunRiseSet, colorGradient);

    float lightY = LIGHT0_DIRECTION.y;
    float dayFactor = smoothstep(0.0, 0.15, lightY);
    float nightFactor = smoothstep(-0.3, 0.0, lightY);
    
    vec3 skyColor = mix(skyColorNight, skyColorSunRiseSet, nightFactor);
    skyColor = mix(skyColor, skyColorDay, dayFactor);
    
    // Blend the sun into the sky
    skyColor = mix(skyColor, sun.rgb, sun.a);

    // Add ambient night light when the sun is down
    float ambientFactor = smoothstep(-0.2, 0.0, lightY); // Controls how much ambient light is added
    skyColor += ambientNightLight * ambientFactor;

    COLOR = skyColor;
}