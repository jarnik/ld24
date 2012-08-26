package jarnik.ld24;

import nme.Assets;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.FPS;
import nme.display.Graphics;
import nme.display.Sprite;
import nme.display.Stage;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.geom.Rectangle;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.events.KeyboardEvent;
import nme.media.Sound;
import nme.media.SoundTransform;

class SoundLib
{
    
    private static var sounds:Hash<Sound>;

	public function new () 
	{
   	}

    public static function init():Void {
        sounds = new Hash<Sound>();

        var list:Array<String> = [
            "click.mp3",
            "fail.mp3",
            "pet.mp3",
            "punch.mp3",
            "point.mp3",
            "win.mp3"
        ];

        for ( item in list )
            preload( "assets/sfx/"+item );

    }

    public static function preload( url:String ):Void {
        if ( sounds == null )
            init();

        var sound:Sound = sounds.get( url );
        if ( sound == null ) {
            sound = Assets.getSound( url );
            sounds.set( url, sound );
        }
    }

    public static function play( url:String, volume:Float = 1 ):Void {
        if ( sounds == null )
            init();

        var sound:Sound = sounds.get( url );
        if ( sound == null ) {
            sound = Assets.getSound( url );
            sounds.set( url, sound );
        }
        sound.play( 0, 0, new SoundTransform( volume ) );
    }


}
