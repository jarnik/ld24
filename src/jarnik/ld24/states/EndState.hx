package jarnik.ld24.states;

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
import jarnik.ld24.Toolbar;
import jarnik.ld24.Dialogue;

class EndState extends State 
{
    private var dialogue:Dialogue;
    private var toolbar:Toolbar;

	public function new () 
	{        
		super();
        toolbar = PlayState.toolbar;
	}

    override private function create():Void {

        addChild( new Bitmap(Assets.getBitmapData( "assets/scene.png" ), nme.display.PixelSnapping.AUTO, false ) );

        addChild( new Bitmap(Assets.getBitmapData( "assets/vignette.png" ), nme.display.PixelSnapping.AUTO, false ) );
        
        addChild( dialogue = new Dialogue() );
    }

    override private function reset():Void {
        addChild( PlayState.cursor );
        addChild( toolbar );
        toolbar.setActiveTool( TOOL_POINT );
        dialogue.play([
            { l:"<The sparks flying from the corpse of a burning schoolbus, it looked like a swarm of restless fireflies...>" },
            { l:"Lucky the firemen were nearby... all the kids are safe.", img:"mendel" },
            { l:"Yeah... You know what? Let's go for a drink." },
            { l:"Ok, you're paying? #p So great of you.", img:"mendel" },
            { l:"Whatever..." },
            { l:"<THE END>" }
        ]);
    }

    override public function update( timeElapsed:Float ):Void {
        if ( dialogue.shown() )
            dialogue.update( timeElapsed );
    }

}
