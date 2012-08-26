package jarnik.ld24; 

/*
import flash.net.NetConnection;
import flash.net.Responder;
import flash.events.MouseEvent;

import flash.events.NetStatusEvent;
*/	

import haxe.remoting.AMFConnection;
import nme.errors.Error;

class GameLog
{
		
	private static var _gatewayURL:String;
	private static var connection:AMFConnection;
	//private static var connection:NetConnection;
	//private static var responder:Responder;		
	private static var _appName:String;		
	private static var _sessionID:String;

    public static var started:Bool = false;
	
	public static function init( appName:String, gatewayURL:String ):Void {
		_gatewayURL = gatewayURL;
		_appName = appName;
        if ( _sessionID == null )
    		_sessionID = Std.string( Math.floor(Math.random() * 10000000) );
	}

    public static function start():Void {
        if ( _gatewayURL == null )
            return;

		
        #if flash
        started = true;
        try {

            connection = AMFConnection.urlConnect( _gatewayURL );
            connection.setErrorHandler( onError );
        } catch ( e : Error ) {
            started = false;
        }
        #else
        started = false;
        #end

        /*
		responder = new Responder(onResult, onFault);
		connection = new NetConnection;
		connection.addEventListener( NetStatusEvent.NET_STATUS, connection_netStatusHandler );
		connection.connect(_gatewayURL);
        */
    }

	public static function log( data : Dynamic ):Void {
		// Send the data to the remote server. 
		if ( started && connection != null ) {
			connection.GameLog.log.call( [ _appName, _sessionID, data ] , onResult );
        }
	}

    private static function onResult( r : Dynamic ):Void {
        //r;
    }

    private static function onError( e : Dynamic ):Void {
        //Str.string( e );
    }

    /*
    public static function close():void {
        if ( started ) {
            started = false;
            connection.close();
        }
    }
	
	public static function log( data:Object ):void {
		// Send the data to the remote server. 
		if ( started && connection ) {
			connection.call("GameLog.log", responder, _appName, _sessionID, data );
        }
	}
	
	// Handle a successful AMF call. This method is defined by the responder. 
	private static function onResult(result:Object):void {
		//response_txt.text = String(result);
		trace("AMF result: "+result);
	}
	
	// Handle an unsuccessfull AMF call. This is method is dedined by the responder. 
	private static function onFault(fault:Object):void {
		//response_txt.text = String(fault.description);
		trace("AMF fault: "+fault);
	}		
	
	private static function connection_netStatusHandler( e:NetStatusEvent ):void {
		trace( "netstatus "+e.type);
		trace( "netstatus "+e.info.code);
	}
	*/	

}
