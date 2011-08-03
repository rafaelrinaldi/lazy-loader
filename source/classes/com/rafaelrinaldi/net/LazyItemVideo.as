package com.rafaelrinaldi.net
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;

	/**
    *
    * LazyLoader item of video type.
    *
    * @since Nov 26, 2009
    * @author Rafael Rinaldi (rafaelrinaldi.com)
    *
	*/
	public class LazyItemVideo extends LazyItem {

		/** Timer who handles loading and stream data. **/
        public var timer : Timer;
		
		/** <code>NetConnection</code> instance. **/
        public var connection : NetConnection;
		
		/** <code>NetStream</code> instance. **/
        public var stream : NetStream;
		
		/** Loading progress data. **/
        public var progressEvent : ProgressEvent;

		/**
		 * Starts the loading process.
		 * @param p_url URL to be loaded.
		 * @param p_noCache Prevent cache?
		 */
		override public function load( p_url : String, p_noCache : Boolean ) : void
		{
		    super.load(p_url, p_noCache);

		    /** Creating a new connection. **/
            connection = new NetConnection;
		    connection.close();
		    connection.connect(null);

		    /** Creating the stream load proccess. **/
            stream = new NetStream(connection);
            stream.client = new CustomClient();
            stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            stream.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);

            /** A dummy check to get the load progress and load complete states. **/
            timer = new Timer(250);
            timer.addEventListener(TimerEvent.TIMER, timerHandler);
            timer.start();
		}

		/** Removing the dummy check. **/
		protected function removeTimer() : void
		{
		    if(timer != null) {
		        timer.stop();
		        timer.removeEventListener(TimerEvent.TIMER, timerHandler);
		        timer = null;
		    }
		}

		/** Force conversion to <code>NetStream</code>. **/
		override public function getAsNetStream() : NetStream
		{
			return NetStream(data);
		}
		
		/** Item raw data. **/
		override public function get data() : Object
		{
		    return _data;
        }

		override public function set data( value : Object ) : void
		{
		    _data = value;
        }

		/** Timer handler. **/
        protected function timerHandler( event : TimerEvent ) : void
        {
            /** Updating load progress info. **/
		    bytesLoaded = stream.bytesLoaded;
		    bytesTotal = stream.bytesTotal;
		    progressRatio = bytesLoaded / bytesTotal;

		    if(bytesLoaded >= bytesTotal) {
		        removeTimer();
				stream.play(url);
		        data = stream;
		        this.dispatchEvent(new Event(Event.COMPLETE));

		        return;
		    }

		    progressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
		    progressEvent.bytesLoaded = bytesLoaded;
		    progressEvent.bytesTotal = bytesTotal;
		    this.dispatchEvent(progressEvent);
        }

		/** @private **/
        protected function netStatusHandler( event : NetStatusEvent ) : void
        {
            // Duh
        }

		/** @private **/
		protected function asyncErrorHandler( event : AsyncErrorEvent ) : void
		{
		    // Duh
		}

		/** Error handler. **/
		protected function errorHandler( event : IOErrorEvent ) : void
		{
			this.dispatchEvent(event);
		}

		override public function dispose() : void
		{
		    if(stream == null) return;

			stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            stream.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);

			// Try to close the NetStream instance
			try {
            	stream.close();
			} catch( error : Error ) {
            	// None stream opened
			}

            stream = null;

		    if(connection != null) {
		        if(connection.connected) connection.close();
		        connection = null;
		    }

		    if(progressEvent != null) {
		        progressEvent.stopPropagation();
		        progressEvent = null;
		    }

		    data = null;

		    removeTimer();
		}

	}

}

/**
*   A custom client to NetStream instance.
*/
class CustomClient {

    /**
    * Fired when the stream receive a new entry of meta-data.
    * @param info Meta-data info.
    */
    public function onMetaData( p_info : Object = null ) : void
    {
    }

    /**
    * Fired when the stream receive a new entry of cue-point.
    * @param info Cue-point info.
    */
    public function onCuePoint( p_info : Object = null ) : void
    {
    }

}