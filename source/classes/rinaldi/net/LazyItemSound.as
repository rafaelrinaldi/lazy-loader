package rinaldi.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;

	/**
    *
    *   LazyLoader item of sound type.
    *
    *   @date 26/11/2009
    *   @author Rafael Rinaldi (rafaelrinaldi.com)
    *
    */

	public class LazyItemSound extends LazyItem {

        public var sound : Sound;

		public function LazyItemSound()
		{
		}

		override public function load( p_url : String, p_noCache : Boolean ) : void
		{
		    super.load(p_url, p_noCache);

		    /** Creating the load proccess **/
		    sound = new Sound;
		    sound.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		    sound.addEventListener(Event.COMPLETE, loadCompleteHandler);
		    sound.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		    sound.load(new URLRequest(url));
		}

		override public function getAsSound() : Sound
		{
			return Sound(data);
		}

		override public function get data() : Object
		{
		    return _data;
        }

		override public function set data( value : Object ) : void
		{
		    _data = value;
        }

        public function loadProgressHandler( event : ProgressEvent ) : void
        {
        	/** Updating load progress info **/
		    bytesLoaded = event.bytesLoaded;
		    bytesTotal = event.bytesTotal;
		    progressRatio = bytesLoaded / bytesTotal;

		    /** Dispatching a clone of ProgressEvent instance **/
		    this.dispatchEvent(event);
        }

		public function loadCompleteHandler( event : Event ) : void
		{
			data = sound;

		    /** Dispatching the load complete event **/
		    this.dispatchEvent(new Event(Event.COMPLETE));
		}

		public function errorHandler( event : IOErrorEvent ) : void
		{
			this.dispatchEvent(event);
		}

		override public function dispose() : void
		{
		    if(sound == null) return;

			sound.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		    sound.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);

		    try {
		    	sound.close();
			} catch( error : Error ) {
		    	// None stream opened
			}

		    sound = null;
		    data = null;
		}

		override public function toString() : String
		{
		    return "[LazyItemSound]";
		}

	}

}