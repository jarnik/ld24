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

enum TOOL {
    TOOL_POINT;
    TOOL_PUNCH;
    TOOL_PET;
}

class Toolbar extends Sprite
{
    public var tools:Array<Sprite>;
    public var activeTool:TOOL;
    private var tip:TextField;

    public var toolLayer:Sprite;

	public function new () 
	{
		super();
        //mouseChildren = false;

        addChild( toolLayer = new Sprite() );
        tools = [];
        var tool:Sprite;
        var hands:AnimatedSprite = new AnimatedSprite( "assets/hands.png", 55, 55 );
        var frame:Bitmap;
        for ( i in 0...3 ) {            
            tool = new Sprite();
            tool.mouseChildren = false;
            tool.mouseChildren = false;
            tool.addChild( frame = new Bitmap(Assets.getBitmapData( "assets/tool.png" ), nme.display.PixelSnapping.AUTO, false ) );
            frame.alpha = 0.2;
            hands.setFrame( i );
            tool.addChild( new Bitmap( hands.getCurrentBitmap().bitmapData, nme.display.PixelSnapping.AUTO, false ) );
            tool.x = 60*i;
            toolLayer.addChild( tool );
            tools.push( tool );            
            tool.addEventListener( MouseEvent.MOUSE_OVER, tipHandler );
            tool.addEventListener( MouseEvent.MOUSE_OUT, tipHandler );
            tool.addEventListener( MouseEvent.CLICK, tipHandler );
        }
        toolLayer.x = ( Main.w - toolLayer.width ) / 2;
        toolLayer.y = Main.h - toolLayer.height - 10;
       
        /*
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
        */

        tip = new TextField(); 
        tip.defaultTextFormat =  new TextFormat (Main.font.fontName, 8, 0x000000, null, null, null, null, null, TextFormatAlign.CENTER );
        tip.width = 55;
        tip.selectable = false;
        tip.mouseEnabled = false;
        tip.embedFonts = true;
        toolLayer.addChild( tip );
        tip.x = 0;
        tip.y = 0;
        tip.text = "POINT";
        tip.visible = false;
	}

    public function setActiveTool( tool:TOOL ):Void {
        //Mouse.hide();
        var index:Int = -1;
        var offset:Point = new Point();
        activeTool = tool;
        switch ( tool ) {
            case TOOL_POINT:
                index = 0;
                offset = new Point( 5, 7 );
            case TOOL_PUNCH:
                index = 1;
                offset = new Point( 28, 28 );
            case TOOL_PET:
                index = 2;
                offset = new Point( 28, 28 );
        }
        PlayState.cursorOffset = offset;        
        PlayState.cursor.setFrame( index );        
    }

    private function tipHandler( e:MouseEvent ):Void {
        if ( e.type == MouseEvent.MOUSE_OUT ) {
            tip.visible = false;
            return;
        }

        var index:Int = -1;
        for ( i in 0...tools.length )
            if ( tools[i] == e.target )
                index = i;
        
        if ( index == -1 )
            return;

        tip.visible = true;
        tip.x = index * 60;
        tip.text = [ "POINT", "PUNCH", "PET" ][ index ];

        if ( e.type == MouseEvent.CLICK )
            setActiveTool( [ TOOL_POINT, TOOL_PUNCH, TOOL_PET ][ index ] );
    }

}
