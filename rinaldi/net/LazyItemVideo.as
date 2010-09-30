package rinaldi.net
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;

	/**
    *   
    *   LazyLoader item of video type.
    *   
    *   @date 26/11/2009
    *   @author Rafael Rinaldi (rafaelrinaldi.com)
    *   
	 */

	
	public class LazyItemVideo extends LazyItem {
        
        public var timer : Timer;
        public var connection : NetConnection;
        public var stream : NetStream;
        public var progressEvent : ProgressEvent;
        
		public function LazyItemVideo()
		{
		}
		
		override public function load( p_url : String ) : void
		{
		    url = p_url;
		    
		    /** Creating a new connection **/
            connection = new NetConnection();
		    connection.close();
		    connection.connect(null);
		    
		    /** Creating the stream load proccess **/
            stream = new NetStream(connection);
            stream.client = new CustomClient();
            stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            stream.play(url);
            
            /** A dummy render to get the load progress and load complete states **/
            timer = new Timer(250);
            timer.addEventListener(TimerEvent.TIMER, timerHandler);
            timer.start();
		}
		
		/**
		* 
		*   Removing the dummy render.
		* 
		*/
		public function removeTimer() : void
		{
		    if(timer != null) {
		        
		        timer.stop();
		        
		        if(timer.hasEventListener(TimerEvent.TIMER)) {
		            timer.removeEventListener(TimerEvent.TIMER, timerHandler);
		        }
		        
		        timer = null;
		        
		    }
		}

		override public function getAsNetStream() : NetStream 
		{
			return NetStream(data);
		}

		override public function get data() : Object
		{
		    return _data;
        }
        
		override public function set data( value : Object ) : void
		{
		    _data = value;
        }
        
        public function timerHandler( event : TimerEvent ) : void
        {
            /** Updating load progress info **/
		    bytesLoaded = stream.bytesLoaded;
		    bytesTotal = stream.bytesTotal;
		    progressRatio = bytesLoaded / bytesTotal;
		    
		    if(bytesLoaded >= bytesTotal) {
		        
		        removeTimer();
		        
		        data = stream;
		        
		        /** Dispatching the load complete event **/
		        this.dispatchEvent(new Event(Event.COMPLETE));
		        
		        return;
		        
		    }
		    
		    /** Dispatching a clone of ProgressEvent instance **/
		    progressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
		    progressEvent.bytesLoaded = bytesLoaded;
		    progressEvent.bytesTotal = bytesTotal;
		    this.dispatchEvent(progressEvent);
        }
        
        public function netStatusHandler( event : NetStatusEvent ) : void
        {
            // Duh
        }
		
		public function asyncErrorHandler( event : AsyncErrorEvent ) : void
		{
		    // Duh
		}

		override public function dispose() : void
		{
		    if(stream != null) {
		        
                if(stream.hasEventListener(NetStatusEvent.NET_STATUS)) {
                    stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
                }
                
                if(stream.hasEventListener(AsyncErrorEvent.ASYNC_ERROR)) {
                    stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
                }
                
                try {
                    stream.close();
                } catch( error : Error ) {
                    // None stream opened
                }
                
                stream = null;
                
		    }
		    
		    if(connection != null) {
		        
		        if(connection.connected) {
		            connection.close();
		        }
		        
		        connection = null;
		    }
		    
		    if(progressEvent != null) {
		        progressEvent.stopPropagation();
		        progressEvent = null;
		    }
		    
		    data = null;
		    
		    removeTimer();
		}
		
		override public function toString() : String
		{
		    return "[LazyItemVideo]";
		}

	}

}

/**
*
*   A custom client to NetStream instance.
*
*/

class CustomClient {
    
    /**
    *   
    *   Fired when the stream receive a new entry of meta-data.
    *   
    *   @param                  info                    Meta-data info.
    *   
    */
    public function onMetaData( info : Object ) : void
    {
    }
    
    /**
    *   
    *   Fired when the stream receive a new entry of cue-point.
    *   
    *   @param                  info                    Cue-point info.
    *   
    */
    public function onCuePoint( info : Object ) : void
    {
    }
    
}