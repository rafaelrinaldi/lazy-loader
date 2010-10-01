package rinaldi.net
{
	import rinaldi.util.fire;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;

	/**
	*
    *	Lazy loader for basic file types.
    *	The intention of this class does not load a queue of files, also does not load many files at the same time.
    *	LazyLoader it's only the best way I found to load basic file types in ActionScript 3.0.
    *
    *	@see rinaldi.net
    *
    *   @date 26/11/2009
    *	@author Rafael Rinaldi (rafaelrinaldi.com)
    *
	**/

	public class LazyLoader {

        public var url : String; // File URL
        public var type : String; // File Type

        public var item : LazyItem;
        public var items : Dictionary;

        public var noCache : Boolean;

        public var onProgress : Function; // Load progress callback
        public var onLoad : Function; // Load complete callback
        public var onError : Function; // Load error callback

        /** Available extensions **/
        public static const EXTENSIONS_TEXT : Array = [".txt", ".xml", ".json", ".css", ".js", ".php"];
        public static const EXTENSIONS_SOUND : Array = [".aac", ".aiff", ".mp3", ".avi", ".wav", ".au", ".midi"];
        public static const EXTENSIONS_IMAGE : Array = [".jpg", ".jpeg", ".png", ".gif", ".bmp"];
        public static const EXTENSIONS_VIDEO : Array = [".flv", ".f4v"];
        public static const EXTENSIONS_MOVIECLIP : Array = [".swf"];

        /** File types **/
        public static const TYPE_TEXT : String = "type_text";
        public static const TYPE_SOUND : String = "type_sound";
        public static const TYPE_IMAGE : String = "type_image";
        public static const TYPE_VIDEO : String = "type_video";
        public static const TYPE_MOVIECLIP : String = "type_movieclip";

		public function LazyLoader( p_callBacks : Object = null, p_noCache : Boolean = false )
		{
			noCache = p_noCache;

		    /** A dictionary with items supported by the LazyLoader. **/
		    items = new Dictionary(true);
		    items[TYPE_TEXT] = LazyItemText;
		    items[TYPE_SOUND] = LazyItemSound;
		    items[TYPE_IMAGE] = LazyItemImage;
		    items[TYPE_VIDEO] = LazyItemVideo;
		    items[TYPE_MOVIECLIP] = LazyItemMovieClip;

		    setCallBacks(p_callBacks);
		}

		/**
		*
		*   Starts the file loading.
		*
		*   @param                  p_url                   File URL.
		*   @param                  p_callBacks             A optional parameter with callbacks of file loading.
		*
		*/
		public function load( p_url : String, p_callBacks : Object = null ) : void
		{
		    var lazyItemClass : Class;

		    url = p_url;
		    type = typeByURL(url);

		    if(url == null || url == "") {
		        throw new Error("Invalid file");
		    }

		    if(type == "") {
		        throw new Error("Sorry, LazyLoader don't have support for this file type yet");
		    }

		    lazyItemClass = items[type];

		    item = new lazyItemClass();
		    item.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			item.addEventListener(Event.COMPLETE, loadCompleteHandler);
			item.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		    item.load(url, noCache);

		    setCallBacks(p_callBacks);
		}

		public function loadProgressHandler( event : ProgressEvent ) : void
		{
		    const progressRatio : Number = LazyItem(event.currentTarget).progressRatio;

		    fire(onProgress, progressRatio);
		}

		public function loadCompleteHandler( event : Event ) : void
		{
		    const data : Object = LazyItem(event.currentTarget).data;

		    fire(onLoad, data);

		    item.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		    item.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		}

		public function errorHandler( event : IOErrorEvent ) : void
		{
			fire(onError, event);
		}

		/**
		*
		*   Returns the type of file based on his URL.
		*
		*   @param                  p_url                   File URL.
		*
		*   @return                                         File Type.
		*
		*/
		public static function typeByURL( p_url : String ) : String
        {
            const extension : String = p_url.substring(p_url.lastIndexOf("."), p_url.length);

            if(isExtensionOf(EXTENSIONS_TEXT)) {
                return TYPE_TEXT;
            } else if(isExtensionOf(EXTENSIONS_SOUND)) {
                return TYPE_SOUND;
            } else if(isExtensionOf(EXTENSIONS_IMAGE)) {
                return TYPE_IMAGE;
            } else if(isExtensionOf(EXTENSIONS_VIDEO)) {
                return TYPE_VIDEO;
            } else if(isExtensionOf(EXTENSIONS_MOVIECLIP)) {
                return TYPE_MOVIECLIP;
            }

            /**
            *
            *   Checks if current extension is an available extension.
            *
            *   @param                  p_arr                   Extensions array.
            *
            *   @return                                         "true" if current extension is an available extension, "false" otherwise.
            *
            */
            function isExtensionOf( p_extensions : Array ) : Boolean {

                for each(var item : String in p_extensions) {
                    if(item == extension) {
                        return true;
                        break;
                    }
                }

                return false;
            }

            return "";
		}

		public function setCallBacks( p_callBacks : Object ) : void
		{
			if(p_callBacks == null) return;
			if(p_callBacks.hasOwnProperty("onProgress")) onProgress = p_callBacks["onProgress"];
			if(p_callBacks.hasOwnProperty("onLoad")) onLoad = p_callBacks["onLoad"];
			if(p_callBacks.hasOwnProperty("onError")) onError = p_callBacks["onError"];
		}

        public function dispose() : void
        {
            if(items != null) {
                items = null;
            }

            if(item != null) {
                item.dispose();
                item = null;
            }

            url = null;
            type = null;
            onProgress = null;
            onLoad = null;
            onError = null;
        }

	}

}