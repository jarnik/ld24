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

class TitleState extends State 
{
    private var title:Sprite;
    private var music:Sound;
    private var musicChannel:SoundChannel;

	public function new () 
	{
		super();

        music = Assets.getSound("assets/music/horses.mp3");
        musicChannel = music.play( 0, 1000 );
	}

    override private function create():Void {

        addChild( title = new Sprite() );
        title.addChild( new Bitmap(Assets.getBitmapData( "assets/title.png" ), nme.display.PixelSnapping.AUTO, false ) );
        
        //words.showText( startWords[ Std.int(startWords.length * Math.random()) ], null, false );
        //words.visible = true;
        /*
        addChild( new Bitmap(Assets.getBitmapData( "assets/screen_white.png" ), nme.display.PixelSnapping.AUTO, false ) );
        */
        //addChild( new Bitmap(Assets.getBitmapData( "assets/screen_title.png" ), nme.display.PixelSnapping.AUTO, false ) );

        title.addEventListener( MouseEvent.CLICK, onMouseHandler );
        /*
        stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseHandler );
        stage.addEventListener( MouseEvent.MOUSE_UP, onMouseHandler );        
        */

        /*
        rooms = [
            new Room(
                new Point3D( 150,0,0 ),
                new Point3D( 0, -Math.PI/2, 0 ),
                new Point3D( 200,100,100 ),
                [
                    { bitmap: "wall_b.png" },
                    { bitmap: "wall_r.png" },
                    { bitmap: "wall_f.png" },
                    { bitmap: "wall_l.png" }
                ]
        ];
        addChild( roomLayer = new Sprite() );
        for ( r in rooms )
            roomLayer.addChild( r );
        roomLayer.x = Main.w / 2;
        roomLayer.y = Main.h / 2;
        activeRoom = rooms[0];
        */
    }

    

    override private function reset():Void {
        GameLog.log( {
            level: PlayState.currentCase,
            event: "start"
        } );
    }

    override public function update( timeElapsed:Float ):Void {
    }


    private function onMouseHandler( e:MouseEvent ):Void {
        SoundLib.play("assets/sfx/click.mp3");
        Main.switchState( STATE_INTRO );
    }

}
