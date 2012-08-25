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

enum MATCH_TYPE {
    FIND_FATHER;
}

typedef GroupConfig = {
    var count:Int;
    var select:Int;
    var size:Float;
    var xscatter:Float;
    var yscatter:Float;
    var match:MATCH_TYPE;
}

class PlayState extends State 
{
    private var title:Bitmap;
    private var aliens:Array<Alien>;
    private var alienLayer:Sprite;

	public function new () 
	{
		super();
	}

    override private function create():Void {

        addChild( alienLayer = new Sprite() );
        /*
        cases = [
            { // cheating wife, find father
                intro: [ 
                    { l:"I've had a bad feeling about this evening..." }, 
                    { l:"When suddenly, one of those damned squishy blobs came punching at my door." }, 
                    { l:"Detective, I need your help." }, 
                    { l:"All right, come in and sit over there." }, 
                    { l:"Thank you. #s The thing is, #s my wife has been #p cheating #p on me." }, 
                    { l:"I'd have forgiven her, it was a long time ago...#s But we have a kid. Twelve years old." }, 
                    { l:"I came to know about my wife's affair just recently and I've been suspecting if #p I'm the real father of our child." }, 
                    { l:"It's too late to #p punish my wife, so I need you to find that bastard and #p I'll give him a lesson." }, 
                    { l:"I'll see what I can do. I'll need some leads. Do you have a picture of your wife and kid? " }, 
                    { l:"Here's a #p photo of my wife." }, 
                    { l:"And a #s picture of our child." } 
                ],
                brief: [
                    { l:"Here's a group of thugs I'm suspecting to be genetic father to that kid." }, 
                ],
                scene: { bgr: "somepicture.png" },
                denial: { l: "I think you have a wrong person." },
                group: {
                    count: 5,
                    select: 1,
                    size: 1,
                    xscatter: 0,
                    yscatter: 0,
                    match: "FIND_FATHER"
                }
                outro: [
                    { l:"Come with me. There's a certain gentleman who might want to have a word with you." } 
                ]                
            },{ // lost kid, find among orphans
                group: {
                    count: 8,
                    select: 1,
                    size: 0.5,
                    xscatter: 1,
                    yscatter: 1,
                    match: "FIND_KID"
                }
            },{ // triple parents - find 3 parents
                group: {
                    count: 5,
                    select: 3,
                    size: 1,
                    xscatter: 0.2,
                    yscatter: 0,
                    match: "FIND_PARENT_TRIO"
                }
            },{ // brother
                group: {
                    count: 5,
                    select: 1,
                    size: 1,
                    xscatter: 0.1,
                    yscatter: 0,
                    match: "FIND_BROTHER"
                }
            },{ // bus crash, find parents
                group: {
                    count: 8,
                    select: 1,
                    size: 1,
                    xscatter: 0.2,
                    yscatter: 0,
                    match: "FIND_PARENTS"
                }
            }

        ]*/
        
        //words.showText( startWords[ Std.int(startWords.length * Math.random()) ], null, false );
        //words.visible = true;
        /*
        addChild( new Bitmap(Assets.getBitmapData( "assets/screen_white.png" ), nme.display.PixelSnapping.AUTO, false ) );
        */
        //addChild( new Bitmap(Assets.getBitmapData( "assets/screen_title.png" ), nme.display.PixelSnapping.AUTO, false ) );

        /*
        stage.addEventListener( MouseEvent.CLICK, onMouseHandler );
        stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseHandler );
        stage.addEventListener( MouseEvent.MOUSE_UP, onMouseHandler );        
        */
        
        stage.addEventListener( KeyboardEvent.KEY_UP, keyHandler );

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
        createScene( {
            count: 5,
            select: 1,
            size: 1,
            xscatter: 0,
            yscatter: 0,
            match: FIND_FATHER
        } );
    }

    private function createScene( config:GroupConfig ):Void {
        Main.log( "createScene " );
        while ( alienLayer.numChildren > 0 )
            alienLayer.removeChildAt( 0 );
        aliens = [];
        var alien:Alien;
        for ( i in 0...3 ) {
            alien = new Alien();
            alien.randomize();
            aliens.push( alien );
        }
        var mandatory:Array<AlienConfig> = [];
        var margin:Float = 130;
        var stride:Float = Math.min( 80, (Main.w - margin*2) / ( aliens.length - 1) );
        margin = (Main.w - (aliens.length - 1)*stride) / 2;
        for ( i in 0...aliens.length ) {
            Main.log( "createScene "+i );
            alien = aliens[ i ];
            alienLayer.addChild( alien );
            alien.x = margin + i * stride;
        }
    }

    override public function update( timeElapsed:Float ):Void {
       
    }

    private function keyHandler( e:KeyboardEvent ):Void {
        switch ( e.keyCode ) {
            // SPACE
            case 32:
                if ( e.type == KeyboardEvent.KEY_DOWN ) {
                }
                if ( e.type == KeyboardEvent.KEY_UP ) {
                    aliens[ 0 ].randomize();
                }
                /*
            // I , tab
            case 73, 9:
                if ( e.type == KeyboardEvent.KEY_UP ) {
                }
            // [
            case 219:
                if ( e.type == KeyboardEvent.KEY_UP ) {
                }
            // ]
            case 221:
                if ( e.type == KeyboardEvent.KEY_UP ) {
                }
            // DOWN
            case 40:
                if ( e.type == KeyboardEvent.KEY_UP ) {
                    Main.log("rotate right");
                    rotate( true );
                }
            // UP
            case 38:
                if ( e.type == KeyboardEvent.KEY_UP ) {
                    Main.log("rotate left");
                    rotate( false );
                }
            // LEFT
            case 37:
                if ( e.type == KeyboardEvent.KEY_UP ) {
                    Main.log("look left");
                    turn( false );
                }                    
            // RIGHT
            case 39:
                if ( e.type == KeyboardEvent.KEY_UP ) {
                    Main.log("look right");
                    turn( true );
                }
            default:
                log("key "+e.keyCode);*/
        }
    }

    private function onMouseHandler( e:MouseEvent ):Void {
    }

}
