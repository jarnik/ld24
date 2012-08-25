package jarnik.ld24;

import nme.Assets;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.geom.Transform;
import nme.geom.ColorTransform;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.FPS;
import nme.display.Graphics;
import nme.display.Sprite;
import nme.display.Stage;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.display.DisplayObject;
import nme.geom.Rectangle;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.Font;
import nme.events.KeyboardEvent;
import nme.media.Sound;
import nme.media.SoundChannel;

import jarnik.ld24.Main;

typedef AlienConfig = {
    var legs:Int;
    var body:Int;
    var bodyColor:Int;
    var spotColor:Int;
    var eyes:Int;
    var horns:Bool;
    var antena:Bool;
}

class Alien extends Sprite
{
    private var legs:AnimatedSprite;
    private var body:AnimatedSprite;
    private var spots:AnimatedSprite;
    private var eyes:AnimatedSprite;
    private var horns:AnimatedSprite;
    private var antena:AnimatedSprite;

    private var skin:Sprite;

    public var config:AlienConfig;

    public static inline var BODY_COLORS:Array<Array<Float>> = [
        [ 1, 0, 0 ],
        [ 0, 1, 0 ],
        [ 0, 0, 1 ],
        [ 1, 1, 0 ]
    ];
    public static inline var SPOT_COLORS:Array<Array<Float>> = [
        [ 0, 1, 1 ],
        [ 1, 0, 1 ],
        [ 1, 1, 1 ]
    ];

	public function new () 
	{
		super();

        addChild( skin = new Sprite() );

        legs = new AnimatedSprite( "assets/legs.png", 64, 128 );
        skin.addChild( legs );
        legs.transform.colorTransform = new ColorTransform( 0.3, 0.3, 0.3 );
        body = new AnimatedSprite( "assets/body.png", 64, 128 );
        skin.addChild( body );
        spots = new AnimatedSprite( "assets/spots.png", 64, 128 );
        skin.addChild( spots );
        eyes = new AnimatedSprite( "assets/eyes.png", 64, 128 );
        skin.addChild( eyes );
        horns = new AnimatedSprite( "assets/props.png", 64, 128 );
        skin.addChild( horns );
        horns.setFrame( 0 );
        horns.transform.colorTransform = new ColorTransform( 0.5, 0.3, 0.3 );
        antena = new AnimatedSprite( "assets/props.png", 64, 128 );
        skin.addChild( antena );
        antena.setFrame( 1 );
        antena.transform.colorTransform = new ColorTransform( 0.9, 0.6, 0.9 );

        skin.x = -32;
        skin.y = -128;
        
        randomize();
	}

    public function randomize():Void {
        setConfig( getRandomConfig() );
    }
  
    public function setConfig( config:AlienConfig ):Void {
        this.config = config;

        legs.setFrame( config.legs );
        body.setFrame( config.body );
        var bodyColor:Array<Float> = BODY_COLORS[ config.bodyColor ];
        body.transform.colorTransform = new ColorTransform( bodyColor[ 0 ], bodyColor[ 1 ], bodyColor[ 2 ] );
        spots.setFrame( config.body );
        var spotColor:Array<Float> = SPOT_COLORS[ config.spotColor ];
        spots.transform.colorTransform = new ColorTransform( spotColor[ 0 ], spotColor[ 1 ], spotColor[ 2 ], 0.8 );
        eyes.setFrame( config.eyes );
        horns.visible = config.horns;
        antena.visible = config.antena;
    }

    public function setScale( scale:Float ):Void {
        skin.scaleX = scale;
        skin.scaleY = scale;
        skin.x = -32*scale;
        skin.y = -128*scale;
    }

    public static function getRandomConfig():AlienConfig {
        return {
            legs: Math.floor( 5 * Math.random() ),
            body: Math.floor( 4 * Math.random() ),
            bodyColor: Math.floor( Math.random() * BODY_COLORS.length ),
            spotColor: Math.floor( Math.random() * SPOT_COLORS.length ),
            eyes: Math.floor( 5 * Math.random() ),
            horns: (Math.random() > 0.5 ),
            antena: (Math.random() > 0.5 )
        };
    }

    public static function breed( father:AlienConfig, mother:AlienConfig ):AlienConfig {
        return {
            legs: Math.floor( (father.legs + mother.legs) / 2 ),
            body: Math.floor( (father.body + mother.body) / 2 ),
            bodyColor: father.bodyColor,
            spotColor: mother.spotColor,
            eyes: Math.floor( (father.eyes + mother.eyes) / 2 ),
            horns: father.horns,
            antena: mother.antena
        };
    }

}
