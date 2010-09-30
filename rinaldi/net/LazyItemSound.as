package rinaldi.net
{
	import flash.events.Event;
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

		override public function load( p_url : String ) : void
		{
		    url = p_url;

		    /** Creating the load proccess **/
		    sound = new Sound();
		    sound.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		    sound.addEventListener(Event.COMPLETE, loadCompleteHandler);
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
		    this.dispatchEvent(event.clone());
        }

		public function loadCompleteHandler( event : Event ) : void
		{
			data = event.target["content"];

		    /** Dispatching the load complete event **/
		    this.dispatchEvent(new Event(Event.COMPLETE));
		}

		override public function dispose() : void
		{
		    if(sound != null) {

		        if(sound.hasEventListener(ProgressEvent.PROGRESS)) {
		            sound.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		        }

		        if(sound.hasEventListener(Event.COMPLETE)) {
		            sound.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		        }

		        try {
		            sound.close();
		        } catch( error : Error ) {
		            // None stream opened
		        }

		        sound = null;

		    }

		    data = null;
		}

		override public function toString() : String
		{
		    return "[LazyItemSound]";
		}

	}

}