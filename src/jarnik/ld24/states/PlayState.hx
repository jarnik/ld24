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

enum MATCH_TYPE {
    FIND_FATHER;
    FIND_KID;
    FIND_PARENT_TRIO;
    FIND_BROTHER;
    FIND_PARENTS;
}

typedef CaseConfig = {    
    var intro:Script;
    var brief:Script;
    var group:GroupConfig;
    var outro:Script;
}

typedef PhotoConfig = {    
    var alien:AlienConfig;
    var name:String;
    var scale:Float;
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

    public static inline var tips:Array<String> = [
        "Horns are always inherited from the paternal side.",
        "Anntenae is always inherited from the maternal side.",
        "Body color is always inherited from the paternal side.",
        "Spot color is always inherited from the maternal side.",
        "Leg count is always inherited as an average of mother's and father's, rounded up.",
        "Eye count is always inherited as an average of mother's and father's, rounded down.",
        "Robustness is always inherited as an average of mother's and father's, rounded down."
    ];
    public static inline var cases:Array<CaseConfig> = [
    { // cheating wife, find father
       intro: [ 
           { l:"<I had a bad feeling about that evening...>" },
           { l:"<A night sky was black as a yesterday's coffee and gathering clouds were promising another heavy storm.>" }, 
           { l:"<When suddenly, one of those damned squishy blobs came punching at my door.>" }, 
           { l:"Detective, I need your help.", img:"anon" }, 
           { l:"All right, come in and sit over there." }, 
           { l:"Thank you. I'm a bit nervous... #s The thing is, #s my wife has been #p cheating #p on me.", img:"anon" }, 
           { l:"I'd have forgiven her, it was a long time ago... #s But we have a kid. Twelve years old.", img:"anon" }, 
           { l:"I came to know about my wife's affair just recently and I've been suspecting if #p I'm the real father of our child.", img:"anon" }, 
           { l:"It's too late to #p punish my wife, so I need you to find that bastard and #p I'll give him a lesson.", img:"anon" }, 
           { l:"I'll see what I can do. I'll need some leads. Do you have a picture of your wife and kid? " }, 
           { l:"Here's a #p photo of my wife.", img:"anon" }, 
           { l:"And a #s picture of our child.", img:"anon" } 
       ],
       brief: [
           { l:"Here's a group of thugs I'm suspecting." }, 
           { l:"Okay, let's get on with it!", img:"mendel" }, 
           { l:"Who are you again?" }, 
           { l:"It's me, Mendel. Your assistant.", img:"mendel" }, 
           { l:"Ask me anything about the biology.", img:"mendel" }, 
           { l:"Ok. So which one of these is our man...?" }, 
           { l:"Don't forget to check out the clue photos - they're at the top of your desk.", img:"mendel" }, 
       ],
       group: {
           count: 5,
           select: 1,
           size: 1,
           xscatter: 0,
           yscatter: 0,
           match: FIND_FATHER
       },
       outro: [
           { l:"Come with me. There's a certain gentleman who might want to have a word with you." } 
       ]                
    },{ // lost kid, find among orphans
        intro: [
            { l:"<Sun came peeking through a window blinds like a cheeky girl and woke me up...>" },
            { l:"<I had a rough night chasing bad guys, didn't even remember how I got back to my place.>" },
            { l:"<A careful knocking on my door interrupted my hazy thoughts.>" },
            { l:"Come on in." },
            { l:"Good morning, detective Darwin. Me and my wife have come with a certain request.", img:"anon" },
            { l:"We had a most adorable little blob, but five years ago, #s he fell into a river. We thougt he'd #s drowned.", img:"anon" },
            { l:"But just a week ago, we got a message that he's at the local orphanage.", img:"anon" },
            { l:"He was too small to remember us and we've known him as a little blob, so we're #p worried we will not recognize him among other blobs.", img:"anon" },
            { l:"Would you please come with us and help us choose?", img:"anon" },
            { l:"OK, I'll just fetch my assistant Mendel." },
        ],
        brief: [
            { l:"Ahh, the smell of orphanage... Reminds me of you, Mendel." },
            { l:"Same to you, boss.", img:"mendel" }
        ],
        group: {
            count: 8,
            select: 1,
            size: 0.5,
            xscatter: 1,
            yscatter: 1,
            match: FIND_KID
        },
        outro: [
            { l:"This is your little blobber. I'm absolutely certain of it.." },
            { l:"Oh, thank you detective! You've brought #p happiness back to our lives!", img:"anon" }
        ]
    },{ // find mother
        intro: [
            { l:"<I was sitting on a park bench, crunching peanuts. I nervous young blob squiggled towards me.>" },
            { l:"Hello, detective. I've heard you're an expert on family matters.", img:"anon" },
            { l:"It depends. What can I do for you?" },
            { l:"You see, I am an #s orphan. Or had been. Because a while ago, I came to know that my parents may still be alive somewhere.", img:"anon" },
            { l:"The good thing is, they are both actually still alive. At the local retirement house.", img:"anon" },
            { l:"The bad thing is, #s they are probably too old to remember me and the retirement house database is a mess.", img:"anon" },
            { l:"I fear #p I might not recognize them among other elderly blobs there.", img:"anon" },
            { l:"Let's walk there. It's just across the park from here." }
        ],
        brief: [
            { l:"Retirement house... I wonder if I'm gonna live long enough to get here myself." },
            { l:"I don't think solving family relations is gonna get you killed any soon...", img:"mendel" },
            { l:"So... yeah, your chances are #p quite high.", img:"mendel" }
        ],
        group: {
            count: 9,
            select: 2,
            size: 0.6,
            xscatter: 0.2,
            yscatter: 0.2,
            match: FIND_PARENTS
        },
        outro: [
            { l:"These are your loving blobs." },
            { l:"Thanks, detective! I'll fetch the lawyer right away.", img: "anon" },
            { l:"Seems he was rather after their last will, rather than their #s love...", img:"mendel" }
        ]
    },{ // brother
        intro: [
            { l:"<Lazy evening crept into our office. I've been sucking on a lollipop, while Mendel went through a mail.>" },
            { l:"Detective, there's a postcard from my brother!", img:"mendel" },
            { l:"Well, good for you. Been on a vacation?" },
            { l:"I don't #p have any brother! At least, haven't had until now.", img:"mendel" },
            { l:"He states there, that his father was our milkman during the war.", img:"mendel" },
            { l:"My father was fighting abroad for several years and my mother #s had apparently too much time on her hands. It was before I was born.", img:"mendel" },
            { l:"He says there, he's coming to town to meet me. \"Be at the railway station at 6pm.\"", img:"mendel" },
            { l:"That's in 30 minutes. But... come with me, I've got an idea.", img:"mendel" },
            { l:"Ok, we can grab a drink downtown." }
        ],
        brief: [
            { l:"Let's see if you can find me brother on your own.", img:"mendel" },
            { l:"Hah... just look at your face. #p Ok, I'll give you pictures of both my mother and his father.", img:"mendel" }
        ],
        group: {
            count: 10,
            select: 1,
            size: 0.8,
            xscatter: 0.1,
            yscatter: 0.3,
            match: FIND_KID
        },
        outro: [
            { l:"Yeah, I think that's him. Let's greet him and get a drink together.", img:"mendel" }
        ]
    },{ // bus crash, find parents
        intro: [],
        brief: [],
        group: {
            count: 8,
            select: 1,
            size: 1,
            xscatter: 0.2,
            yscatter: 0,
            match: FIND_PARENTS
        },
        outro: []
    }
    ];
    public static var currentCase:Int;

    private var markers:Array<Bitmap>;
    private var thumbs:Array<Sprite>;
    private var currentMarker:Int;
    private var aliens:Array<Alien>;
    private var selected:Array<Alien>;
    private var alienLayer:Sprite;
    private var okbutton:Sprite;
    private var config:GroupConfig;
    private var photo:Photo;
    private var photos:Array<PhotoConfig>;
    public static var toolbar:Toolbar;
    private var toolbarLayer:Sprite;
    private var dialogue:Dialogue;
    private var finished:Bool;

    public static var cursor:AnimatedSprite;
    public static var cursorOffset:Point;

	public function new () 
	{
		super();
	}
    
    public static function init( stage:Stage ):Void {
        cursor = new AnimatedSprite("assets/hands.png",55,55);
        cursor.mouseEnabled = false;
        cursorOffset = new Point();
        //currentCase = 0;
        currentCase = 3;
        toolbar = new Toolbar();
        stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMoveHandler );        
    }

    override private function create():Void {

        addChild( new Bitmap(Assets.getBitmapData( "assets/scene.png" ), nme.display.PixelSnapping.AUTO, false ) );

        addChild( alienLayer = new Sprite() );
        alienLayer.y = 210;

        addChild( new Bitmap(Assets.getBitmapData( "assets/vignette.png" ), nme.display.PixelSnapping.AUTO, false ) );

        var marker:Bitmap;
        markers = [];
        for ( i in 0...10 ) {
            addChild( marker = new Bitmap(Assets.getBitmapData( "assets/marker.png" ), nme.display.PixelSnapping.AUTO, false ) );
            markers.push( marker );
            marker.visible = false;
        }
        var alien:Alien;
        aliens = [];
        for ( i in 0...10 ) {
            alien = new Alien();
            alienLayer.addChild( alien );
            alien.visible = false;
            aliens.push( alien );
            alien.addEventListener( MouseEvent.CLICK, alienClickHandler );
        }
        var thumb:Sprite;
        thumbs = [];
        for ( i in 0...10 ) {
            addChild( thumb = new Sprite() );
            thumb.addChild( new Bitmap(Assets.getBitmapData( "assets/photoThumb.png" ), nme.display.PixelSnapping.AUTO, false ) );
            thumb.addEventListener( MouseEvent.CLICK, thumbClickHandler );
            thumbs.push( thumb );
            thumb.visible = false;
        }
        
        addChild( okbutton = new Sprite() );
        okbutton.addChild( new Bitmap(Assets.getBitmapData( "assets/okbutton.png" ), nme.display.PixelSnapping.AUTO, false ) );
        okbutton.x = (Main.w - okbutton.width)/2;
        okbutton.y = 220;
        okbutton.addEventListener( MouseEvent.CLICK, okClickHandler );
        okbutton.visible = false;

        // mendel
        var mendel:Sprite;
        addChild( mendel = new Sprite());
        mendel.addChild( new Bitmap(Assets.getBitmapData( "assets/mendel.png" ), nme.display.PixelSnapping.AUTO, false ) );
        mendel.scaleX = -2;
        mendel.scaleY = 2;
        mendel.y = Main.h - mendel.height;
        mendel.x = Main.w;
        mendel.addEventListener( MouseEvent.CLICK, mendelClickHandler );

        addChild( dialogue = new Dialogue() );

        addChild( toolbarLayer = new Sprite() );

        addChild( photo = new Photo() );
        photo.hide();
        photo.addEventListener( MouseEvent.CLICK, photoClickHandler );

        /*
        cases = [
            

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
        addChild( cursor );
        toolbarLayer.addChild( toolbar );
        toolbar.setActiveTool( TOOL_POINT );
        finished = false;

        createScene( cases[ currentCase ].group );
        dialogue.play( cases[ currentCase ].brief );
    }

    private function createScene( config:GroupConfig ):Void {
        this.config = config;
        
        photos = [];
        var alienConfigs:Array<AlienConfig> = [];
        var father:AlienConfig = Alien.getRandomConfig();
        var mother:AlienConfig = Alien.getRandomConfig();
        var child:AlienConfig = Alien.breed(father, mother);
        switch ( config.match ) {
            case FIND_FATHER:
                photos.push( { alien:mother, name:"Mother", scale:1 } );
                photos.push( { alien:child, name:"Child", scale:0.5 } );
                alienConfigs.push( father );
            case FIND_KID:
                photos.push( { alien:father, name:"Father", scale:1 } );
                photos.push( { alien:mother, name:"Mother", scale:0.9 } );
                alienConfigs.push( child );
            case FIND_PARENTS:
                photos.push( { alien:child, name:"Son", scale:1 } );
                alienConfigs.push( father );
                alienConfigs.push( mother );
            default:
        }
        while ( alienConfigs.length < config.count ) {
            alienConfigs.push( Alien.getRandomConfig() );
        }

        var margin:Float = 100;
        var stride:Float = Math.min( 160, (Main.w - margin*2) / ( alienConfigs.length - 1) );
        margin = (Main.w - (alienConfigs.length - 1)*stride) / 2;
        var alien:Alien;
        var alienConfig:AlienConfig;
        for ( i in 0...aliens.length ) {
            alien = aliens[ i ];
            if ( i >= config.count ) {
                alien.visible = false;
                continue;
            }

            alienConfig = alienConfigs.splice(Math.floor( alienConfigs.length * Math.random() ),1)[0];
            alien.setConfig( alienConfig );
            alien.x = margin + i * stride + (Math.random()*2-1)*config.xscatter*30;
            alien.y = (Math.random()*2-1)*config.yscatter*20;
            alien.setScale( config.size );
            alien.visible = true;
        }

        var thumb:Sprite;
        for ( i in 0...thumbs.length ) {
            thumb = thumbs[ i ];
            if ( i >= photos.length ) {
                thumb.visible = false;
                continue;
            }
            thumb.x = Main.w/2 - (photos.length-1)*60/2 + i*60 - thumb.width/2;
            thumb.y = 5;
            thumb.visible = true;
        }
        okbutton.visible = false;
        selected = [];
        for ( m in markers )
            m.visible = false;
    }

    private function setMarker( a:Alien ):Void {
        var marker:Bitmap = markers[ currentMarker ];
        marker.visible = true;
        marker.x = a.x - marker.width/2;
        marker.y = alienLayer.y + a.y - a.scale*128 - marker.height;
        currentMarker = (currentMarker + 1) % config.select;
    }

    override public function update( timeElapsed:Float ):Void {
        if ( dialogue.shown() )
            dialogue.update( timeElapsed );
        else if ( finished ) {
            currentCase++;
            if ( currentCase >= cases.length )
                Main.switchState( STATE_END );
            else
                Main.switchState( STATE_INTRO );
        }
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

    private function checkComplete():Void {
        var done:Bool = false;
        switch ( config.match ) {
            case FIND_FATHER:
                Main.log("equaling "+photos[1].alien+" and "+Alien.breed( selected[ 0 ].config, photos[0].alien ));
                done = Alien.equal( photos[1].alien, Alien.breed( selected[ 0 ].config, photos[0].alien ) ); 
            case FIND_KID:
                done = Alien.equal( selected[0].config, Alien.breed( photos[ 0 ].alien, photos[1].alien ) ); 
            case FIND_PARENTS:
                Main.log("equaling kid "+photos[0].alien+" and parents "+ 
                    Alien.breed( selected[ 0 ].config, selected[ 1 ].config ) + " or "+ 
                    Alien.breed( selected[ 1 ].config, selected[ 0 ].config )  );
                done = Alien.equal( photos[0].alien, Alien.breed( selected[ 0 ].config, selected[ 1 ].config ) ) ||
                    Alien.equal( photos[0].alien, Alien.breed( selected[ 1 ].config, selected[ 0 ].config ) ); 
            default:
        }
        Main.log("done? "+done);
        if ( done ) {
            dialogue.play( cases[ currentCase ].outro );
            finished = true;
        } else
            dialogue.play([
                { l:"I think, you got it wrong, boss...", img:"mendel" }
            ]);
    }

    private static function onMouseMoveHandler( e:MouseEvent ):Void {
        cursor.x = e.stageX / Main.upscale - cursorOffset.x;
        cursor.y = e.stageY / Main.upscale - cursorOffset.y;
    }

    private function okClickHandler( e:MouseEvent ):Void {
        if ( !okbutton.visible )
            return;
        Main.log("clicked OK!");
        checkComplete();
    }

    private function photoClickHandler( e:MouseEvent ):Void {
        if ( photo.visible ) {
            photo.hide();
        }
    }

    private function mendelClickHandler( e:MouseEvent ):Void {
        dialogue.play([
            { l: tips[ Math.floor( Math.random()*tips.length ) ] , img:"mendel" }
        ]);
    }

    private function alienClickHandler( e:MouseEvent ):Void {
        if ( !e.target.visible || toolbar.activeTool != TOOL_POINT )
            return;
        selected[ currentMarker ] = e.target;
        setMarker( e.target );
        okbutton.visible = ( markers[ config.select-1 ].visible ) ;
    }

    private function thumbClickHandler( e:MouseEvent ):Void {        
        if ( !e.target.visible )
            return;
        var index:Int = -1;
        for ( i in 0...thumbs.length )
            if ( thumbs[i] == e.target )
                index = i;
        if ( index == -1 )
            return;

        photo.show( photos[ index ].alien, photos[ index ].name, photos[ index ].scale );
    }
}
