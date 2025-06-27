shader_type canvas_item;

uniform vec4 oldColorBody1 : source_color;
uniform vec4 oldColorBody2 : source_color;
uniform float precision : hint_range(0.0, 1.0, 0.1) = 0.1;
uniform float strength: hint_range(0., 1.) = 0.3;
uniform float speed: hint_range(0., 10.) = 0.5;
uniform float angle: hint_range(0., 360.) = 45.;
uniform int sprite_sheet_columns: hint_range(1,16) = 1;
uniform int sprite_sheet_rows: hint_range(1,16) = 1;

// determine if one float is less than another
// return 1 if true, 0 if false
float when_lt(float x, float y) {
  return max(sign(y - x), 0.0);
}

void fragment() {
// get the overall size of the sprite sheet
vec2 sprite_sheet_size = vec2(textureSize(TEXTURE,0));
// get the frame sizes based on the columns and rows
vec2 frame_size;
frame_size.x = sprite_sheet_size.x/float(sprite_sheet_columns);
frame_size.y = sprite_sheet_size.y/float(sprite_sheet_rows);
// seperate the sprite sheet into "frames" so that the rainbow is
// repeated for each frame individually, and not across the whole thing
// together
vec2 current_point = sprite_sheet_size * UV;
float row = floor(current_point.y / frame_size.y);
float column = floor(current_point.x / frame_size.x);
vec2 max_point = (frame_size * vec2(column, row)) + frame_size;
vec2 new_uv = 1.0 - (max_point - current_point) / frame_size;

// get the current desired hue value in time
float hue = new_uv.x * cos(radians(angle)) - new_uv.y * sin(radians(angle));
hue = fract(hue + fract(TIME  * speed));
float x = 1. - abs(mod(hue / (1./ 6.), 2.) - 1.);
vec3 rainbow;
// cycle through the rainbow based on the current hue value
rainbow += vec3(1., x, 0.) * when_lt(hue,1./6.);
rainbow += vec3(x, 1., 0) * when_lt(hue,1./3.) * when_lt(1./6.,hue);
rainbow += vec3(0, 1., x) * when_lt(hue,1./2.) * when_lt(1./3.,hue);
rainbow += vec3(0., x, 1.) * when_lt(hue,2./3.) * when_lt(1./2.,hue);
rainbow += vec3(x, 0., 1.) * when_lt(hue,5./6.) * when_lt(2./3.,hue);
rainbow += vec3(1., 0., x) * when_lt(hue,1.1) * when_lt(5./6.,hue);

vec4 currentColor = texture(TEXTURE, UV);
// replace the current color with the rainbow color based on the strength value
vec4 newColor1 = mix(currentColor, vec4(rainbow, currentColor.a), strength);
// replace the second color a little less based on the strength value
vec4 newColor2 = mix(currentColor, vec4(rainbow - vec3(0.4, 0.4, 0.4), currentColor.a), strength);
COLOR = vec4(0.0, 0.0, 0.0, 0.0); // reset the color to 0 so we can add colors
// Add the new rainbow color if the current pixel color matches the old color
COLOR += newColor1 * when_lt(distance(currentColor, oldColorBody1),precision);
COLOR += newColor2 * when_lt(distance(currentColor, oldColorBody2),precision);
vec4 currentColor1 = COLOR; // get the current value of the pixels
COLOR += currentColor * when_lt(distance(vec4(0.0, 0.0, 0.0, 0.0), currentColor1),precision);
}