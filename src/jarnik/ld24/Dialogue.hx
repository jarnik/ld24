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
import nme.ui.Mouse;

import jarnik.ld24.Main;
import jarnik.ld24.Alien;
import jarnik.ld24.states.PlayState;

typedef Script = Array<Dynamic>; 

class Dialogue extends Sprite
{
    public var speech:Bitmap;
    public var fade:Bitmap;
    public var tf:TextField;
    public var darwin:Bitmap;
    private var script:Script;
    private var currentLine:Int;
    private var currentChar:Int;
    private var moodRequired:Float;
    private var mood:Float;
    private var bullet:Bitmap;
    private var charTimer:Float;
    private var lineText:String;

    private var speakerLayer:Sprite;
    private var speakerBitmap:Bitmap;
    private var speakerImg:String;

	public function new () 
	{
		super();
        //mouseChildren = false;
        var bgrLayer:Sprite; 
        addChild( bgrLayer = new Sprite() );

        bgrLayer.addChild( fade = new Bitmap(Assets.getBitmapData( "assets/fade.png" ), nme.display.PixelSnapping.AUTO, false ) );
        fade.alpha = 0.8;
      
        bgrLayer.addChild( speech = new Bitmap(Assets.getBitmapData( "assets/speech.png" ), nme.display.PixelSnapping.AUTO, false ) );
        
        tf = new TextField(); 
        tf.defaultTextFormat =  new TextFormat (Main.font.fontName, 16, 0x505050, null );
        tf.width = 430;
        tf.height = 140;
        tf.selectable = false;
        tf.mouseEnabled = false;
        tf.embedFonts = true;
        tf.wordWrap = true;
        tf.x = (Main.w - tf.width ) / 2;
        tf.y = 20;
        tf.text = "Charles Robert Darwin, FRS was an English naturalist. He established that all species of life have descended over time from common ancestors, and proposed the scientific theory that this branching";
        addChild( tf );

        addChild( darwin = new Bitmap(Assets.getBitmapData( "assets/darwin.png" ), nme.display.PixelSnapping.AUTO, false ) );
        darwin.scaleX = 2;
        darwin.scaleY = 2;
        darwin.y = Main.h - darwin.height;

        var bmp:Bitmap;
        var spr:Sprite;
        addChild( speakerLayer = new Sprite() );
        speakerLayer.addChild( bmp = new Bitmap(Assets.getBitmapData( "assets/happy.png" ), nme.display.PixelSnapping.AUTO, false ) );
        bmp.x = -bmp.width;
        speakerLayer.addChild( bmp = new Bitmap(Assets.getBitmapData( "assets/sad.png" ), nme.display.PixelSnapping.AUTO, false ) );
        bmp.x = -bmp.width; bmp.y = 128 - bmp.height;
        speakerLayer.addChild( bullet = new Bitmap(Assets.getBitmapData( "assets/bullet.png" ), nme.display.PixelSnapping.AUTO, false ) );
        bullet.x = -bullet.width; bullet.y = 64 - bullet.height/2;
        speakerLayer.addChild( spr = new Sprite() );
        spr.addChild( bmp = new Bitmap(Assets.getBitmapData( "assets/darwin.png" ), nme.display.PixelSnapping.AUTO, false ) );
        bmp.scaleX = -2; bmp.scaleY = 2;
        bmp.x = bmp.width;
        speakerBitmap = bmp;
        spr.addEventListener( MouseEvent.CLICK, speakerClickHandler );

        speakerLayer.x = Main.w - 128;
        speakerLayer.y = Main.h - 128;

        bgrLayer.addEventListener( MouseEvent.CLICK, stageClickHandler );

        hide();

        /*
        play([
            { l:"I've had a bad feeling about this evening..." }, 
            { l:"When suddenly, #s one of those damned squishy #p blobs came punching at my door.", img:"darwin" }
        ]);*/
	}

    private function updateMood():Void {
        bullet.y = 64 - bullet.height/2 - (64-12)*mood;
    }

    public function update( elapsed:Float ):Void {
        if ( charTimer >= 0 ) {
            charTimer += elapsed;
            if ( charTimer > 0.05 ) {
                charTimer = 0;
                if ( moodRequired != 0 ) {
                    var randomChars:String = "#$@!&*/-\\|";
                    lineText = lineText.substr(0,lineText.length-1);
                    if ( moodRequired == mood ) {
                        moodRequired = 0;
                        mood = 0;
                        updateMood();
                    } else
                        lineText += randomChars.charAt( Math.floor( randomChars.length*Math.random()) );
                } else {
                    var nextChar:String = script[ currentLine ].l.charAt( currentChar );
                    currentChar++;
                    if ( nextChar == "#" ) {
                        nextChar = script[ currentLine ].l.charAt( currentChar );
                        switch ( nextChar ) {
                            case "p": moodRequired = -1;
                            case "s": moodRequired = 1;
                        }
                        currentChar += 2; 
                        nextChar = "-";
                    } 
                    lineText += nextChar;
                    if ( currentChar >= script[ currentLine ].l.length )
                        charTimer = -1;
                }
                tf.text = lineText;
            }
        }
    }

    public function hide():Void {
        tf.visible = false;
        speech.visible = false;
        fade.visible = false;
        speakerLayer.visible = false;
    }

    public function show():Void {
        tf.visible = true;
        speech.visible = true;
        fade.visible = true;
        speakerLayer.visible = true;
    }

    public function shown():Bool { return tf.visible; }

    private function nextLine() {
        currentLine++;
        Main.log("next line " +currentLine);
        if ( currentLine == script.length ) {
            hide();
            return;
        }

        currentChar = 0;
        charTimer = 0;
        lineText = "";
        tf.text = lineText;
        moodRequired = 0;

        var left:Bool = (script[ currentLine ].img == null );
        if ( !left )
            speakerLayer.visible = true;
        speech.scaleX = ( left ? 1 : -1 );
        speech.x = ( left ? 0 : speech.width );
        if ( !left && speakerImg != script[ currentLine ].img ) {
            speakerImg = script[ currentLine ].img;
            speakerBitmap.bitmapData = Assets.getBitmapData("assets/"+speakerImg+".png");
        }
    }

    public function play( script:Script ):Void {
        tf.text = "";
        show();
        mood = 0;
        currentLine = -1;
        speakerLayer.visible = false;
        this.script = script;
        nextLine();
    }

    private function stageClickHandler( e:MouseEvent ):Void {
        if ( shown() && moodRequired == 0 ) {
            var found:Bool = false;
            if ( currentChar >= script[ currentLine ].l.length-1 ) {
                nextLine();
                return;
            }
            for ( i in currentChar...script[ currentLine ].l.length ) {
                if ( script[ currentLine ].l.charAt( i ) == "#" ) {
                    found = true;
                    currentChar = i;
                    break;
                } else {
                    lineText += script[ currentLine ].l.charAt( i );
                    currentChar = i;
                }
            }
            tf.text = lineText;
            if ( !found ) 
                charTimer = -1;
        }
    }

    private function speakerClickHandler( e:MouseEvent ):Void {
        switch ( PlayState.toolbar.activeTool ) {
            case TOOL_POINT:
            case TOOL_PUNCH:
                mood -= 0.4;
            case TOOL_PET:
                mood += 0.4;
        }
        mood = Math.min( 1, Math.max( -1, mood ) );
        updateMood();
    }

}
