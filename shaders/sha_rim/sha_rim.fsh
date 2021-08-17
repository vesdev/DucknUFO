//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

//vvv number has to be a multiple of 6
uniform highp vec2 texel;

const highp vec2 light = vec2(-1,-1);
const highp float rimSize = 1.;

const highp vec4 col = vec4(70./255.,181./255.,25./255.,1.);
const highp float alpha = .7;
void main()
{
    vec4 rim_col = vec4(0);
    
    //rim light
    if (texture2D(gm_BaseTexture, v_vTexcoord).a != 0.){
        
        highp vec2 rim = vec2(0.0);
        highp float addedAlpha = 0.0; 
        highp vec2 aux = vec2(texel.x*rimSize,0.);
        highp float value = 0.;
        value = texture2D(gm_BaseTexture, v_vTexcoord + aux).a;
        rim.x -= value;
        addedAlpha += value;
        value = texture2D(gm_BaseTexture, v_vTexcoord - aux).a;
        rim.x += value;
        addedAlpha += value;
 
        aux = vec2(0.,texel.y*rimSize);
        value = texture2D(gm_BaseTexture, v_vTexcoord + aux).a;
        rim.y -= value;
        addedAlpha += value;
        value = texture2D(gm_BaseTexture, v_vTexcoord - aux).a;
        rim.y += value;
        addedAlpha += value;
    
        if (addedAlpha < 4.)
        {
		
			rim_col += dot(light, rim);
        }
    }
	
	rim_col = ceil(max(vec4(0.), rim_col))*col;
	//rim_col = rim_col*col*alpha;
	highp vec4 shadow = vec4(0,0,0,1);
	for(float i = 16.; i > 0.; i-=1.)
	{
		shadow.a -= (1.-texture2D(gm_BaseTexture, v_vTexcoord-texel*i).a)*(1./16.);
	}
	shadow.a = ceil(max(0., shadow.a))*alpha;
	
    gl_FragColor = shadow+texture2D(gm_BaseTexture, v_vTexcoord)+rim_col;
}