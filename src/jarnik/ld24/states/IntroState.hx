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

class IntroState extends State 
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
        GameLog.log( {
            level: PlayState.currentCase,
            event: "intro"
        } );

        addChild( PlayState.cursor );
        addChild( toolbar );
        toolbar.setActiveTool( TOOL_POINT );
        dialogue.play( PlayState.cases[ PlayState.currentCase ].intro );
    }

    override public function update( timeElapsed:Float ):Void {
        if ( dialogue.shown() )
            dialogue.update( timeElapsed );
        else
            Main.switchState( STATE_PLAY );
    }

}
