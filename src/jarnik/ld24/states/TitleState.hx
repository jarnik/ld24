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

import jarnik.rooms.Main;
import jarnik.rooms.Room;
import jarnik.rooms.Hinge;
import jarnik.rooms.Point3D;

class TitleState extends State 
{
    private var title:Bitmap;

    private var roomLayer:Sprite;
    private var rooms:Array<Room>;
    private var hinges:Array<Hinge>;
    private var activeRoom:Room;
    private var look:Point3D;

	public function new () 
	{
		super();
	}

    override private function create():Void {
        
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
            )/*,
            new Room(
                new Point3D( 0,0,0 ),
                new Point3D( 0,0,Math.PI/2 ),
                new Point3D( 200,100,100 ),
                [
                    { bitmap: "wall_b.png" },
                    { bitmap: "wall_r.png" },
                    { bitmap: "wall_f.png" },
                    { bitmap: "wall_l.png" }
                ]
            )*/
        ];
        addChild( roomLayer = new Sprite() );
        for ( r in rooms )
            roomLayer.addChild( r );
        roomLayer.x = Main.w / 2;
        roomLayer.y = Main.h / 2;
        activeRoom = rooms[0];

        hinges = [
        /*
            new Hinge( 
                new Point3D( 0,0,0 ),
                new Point3D( 0,0,0 ),
                new Point3D( 0,0,0 ),
                [
                    rooms[ 0 ],
                    rooms[ 1 ]
                ]
            )*/
        ];       
        look = new Point3D(0,0,0);
        activeRoom.render( look, look );
    }

    private function getBodyStack( startRoom:Room, startHinge:Hinge ):Array<IBody> {
        Main.log("getting body stack for "+startRoom+" from "+startHinge);
        var bodyStack:Array<IBody> = [];
        var roomStack:Array<Room> = [startRoom];
        var room:Room;
        while ( roomStack.length > 0 ) {
            room = roomStack.pop(); 
            Main.log("stack room "+room);
            bodyStack.push( room );
            for ( h in room.hinges ) {
                if ( h == startHinge )
                    continue;
                Main.log("found hinge "+h);
                bodyStack.push( h );
                for ( r in h.rooms ) {
                    if ( r == room )
                        continue;
                    roomStack.push( r );          
                    Main.log("found room "+r);
                }
            }
        }
        return bodyStack;
    }

    private function turn( right:Bool ):Void {
        Main.log("== turning towards "+(right?"right":"left"));
        look.y += (right?-1:1) * Math.PI / 2;
        Main.log("new look angle y "+look.y);
        renderRooms();
    }

    private function rotate( cw:Bool ):Void {
        var hinge = hinges[0];
        var foundActive:Bool;

        var group:Array<IBody> = [];
        var groups:Array<Array<IBody>> = [];
        for ( r in hinge.rooms )
            groups.push( getBodyStack( r, hinge ) );
        Main.log("built 2 groups "+groups);
        for ( g in groups ) {
            Main.log("checking group...");
            foundActive = false;
            for ( b in g )
                if ( b == activeRoom )
                    foundActive = true;
            if ( !foundActive ) {
                group = g;
                Main.log("group checked OK..." +group);
                break;
            }
        }

        rotateGroup( hinge, group, cw );
    }

    private function rotateGroup( h:Hinge, group:Array<IBody>, cw:Bool ):Void {
        // TODO
        Main.log("rotating "+group);
        for ( b in group ) {
            if ( Std.is(b, Room) ) {
                cast(b, Room).rotation += 45 * ( cw ? 1 : -1 );
            }
        }
    }

    private function sortRooms( a:Room, b:Room ):Int {
        // TODO
        var look:Point3D = null;
        var valueA:Float = a.getBackwallValue( look );
        var valueB:Float = b.getBackwallValue( look );
        if ( valueA == valueB )
            return 0;
        return valueA > valueB ? 1 : -1;
    }

    private function renderRooms():Void {
        var stand:Point3D = new Point3D(0,0,0);
        var roomStack:Array<Room> = [];
        for ( r in rooms )
            roomStack.push( r );
        // increasing towards look point
        var renderStack:Array<Room> = [];
        var foundActive:Bool = false;
        for ( r in roomStack ) {
            r.hide();
            if ( r == activeRoom )
                foundActive = true;
            if ( foundActive )
                renderStack.push( r );
        }
        for ( r in renderStack ) {
            //r.render( activeRoom.pos, look );
            r.render( stand, look );
        }
    }

    override private function reset():Void {
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
                }
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
                log("key "+e.keyCode);
        }
    }

    private function onMouseHandler( e:MouseEvent ):Void {
    }

}
