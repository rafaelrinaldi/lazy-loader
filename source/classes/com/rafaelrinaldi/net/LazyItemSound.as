package com.rafaelrinaldi.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;

	/**
    *
    * LazyLoader item of sound type.
    *
    * @since Nov 26, 2009
    * @author Rafael Rinaldi (rafaelrinaldi.com)
    *
    */
	public class LazyItemSound extends LazyItem {
		
		/** <code>Sound</code> instance. **/
        public var sound : Sound;

		/**
		 * Starts the loading process.
		 * @param p_url URL to be loaded.
		 * @param p_noCache Prevent cache?
		 */
		override public function load( p_url : String, p_noCache : Boolean ) : void
		{
		    super.load(p_url, p_noCache);

		    if(context != null && !Boolean(context is SoundLoaderContext)) {
		    	trace("[LazyItemSound] :: load() :: 'context' parameter must be a SoundLoaderContext instance.");
		    	return;
		    }

		    /** Creating the load proccess. **/
		    sound = new Sound;
		    sound.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		    sound.addEventListener(Event.COMPLETE, loadCompleteHandler);
		    sound.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		    sound.load(new URLRequest(url), context);
		}

		/** Force conversion to <code>Sound</code>. **/
		override public function getAsSound() : Sound
		{
			return Sound(data);
		}

		/** Fired when load process is in progress. **/
        protected function loadProgressHandler( event : ProgressEvent ) : void
        {
        	/** Updating load progress info. **/
		    bytesLoaded = event.bytesLoaded;
		    bytesTotal = event.bytesTotal;
		    progressRatio = bytesLoaded / bytesTotal;

		    this.dispatchEvent(event);
        }
		
		/** Fired when load process finishes. **/
		protected function loadCompleteHandler( event : Event ) : void
		{
			data = sound;

		    this.dispatchEvent(new Event(Event.COMPLETE));
		}

		/** Fired when load process fails. **/
		protected function errorHandler( event : IOErrorEvent ) : void
		{
			this.dispatchEvent(event);
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
		
		/** Clear from memory. **/
		override public function dispose() : void
		{
		    if(sound == null) return;

			sound.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		    sound.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);

			// Try to close the Sound instance
			try {
		    	sound.close();
			} catch( error : Error ) {
		    	// None stream opened
			}

		    sound = null;
		    data = null;
		}

	}

}