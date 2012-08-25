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
import jarnik.ld24.Alien;

class Photo extends Sprite
{
    public var alien:Alien;
    private var photo:Sprite;
    private var tf:TextField;

	public function new () 
	{
		super();
        mouseChildren = false;
       
        var fade:Bitmap;
        addChild( fade = new Bitmap(Assets.getBitmapData( "assets/fade.png" ), nme.display.PixelSnapping.AUTO, false ) );
        fade.alpha = 0.8;

        addChild( photo = new Sprite() );
        var photoBgr:Bitmap;
        photo.addChild( photoBgr = new Bitmap(Assets.getBitmapData( "assets/photo.png" ), nme.display.PixelSnapping.AUTO, false ) );
        photo.addChild( alien = new Alien() );
        alien.x = photoBgr.width/2;
        alien.y = 154;
        photo.x = (Main.w - photo.width)/2;
        photo.y = (Main.h - photo.height)/2;

        tf = new TextField(); 
        tf.defaultTextFormat =  new TextFormat (Main.font.fontName, 16, 0x000000, null, null, null, null, null, TextFormatAlign.CENTER );
        tf.height = 400;
        tf.width = photo.width - 40;
        tf.selectable = false;
        tf.mouseEnabled = false;
        tf.embedFonts = true;
        tf.wordWrap = true;
        photo.addChild( tf );
        tf.x = 20;
        tf.y = 187;
	}

    public function show( config:AlienConfig, text:String ):Void {
        //alien.setConfig( config );
        tf.text = text;
        visible = true;
    }

    public function hide():Void {
        visible = false;
    }

}
