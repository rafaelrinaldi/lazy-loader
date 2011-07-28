package com.rafaelrinaldi.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;

	/**
	*
    * Lazy loader for basic file types.
    *
    * @see http://github.com/rafaelrinaldi/lazy-loader
    *
    * @since Nov 26, 2009
    * @author Rafael Rinaldi (rafaelrinaldi.com)
    *
	**/
	public class LazyLoader {

		/** File URL. **/
        public var url : String;
		
		/** File type. **/
        public var type : String;

		/** Current item instance. **/
        public var item : LazyItem;
		
		/** A dictionary with items supported by <code>LazyLoader</code>. **/
        public var items : Dictionary;

		/** Loading context. **/
		public var context : *;

		/** Load progress callback. **/
        public var onProgress : Function;
		
		/** Load complete callback. **/
        public var onLoad : Function;
		
		/** Load error callback. **/
        public var onError : Function;

        /** Available text extensions. **/
        public static const EXTENSIONS_TEXT : Array = [".txt", ".xml", ".json"];
		
		/** Available sound extensions. **/
        public static const EXTENSIONS_SOUND : Array = [".mp3", ".wav", ".midi"];
		
		/** Available image extensions. **/
        public static const EXTENSIONS_IMAGE : Array = [".jpg", ".jpeg", ".png", ".gif", ".bmp"];
		
		/** Available video extensions. **/
        public static const EXTENSIONS_VIDEO : Array = [".flv", ".f4v"];
		
		/** Available movieclip extensions. **/
        public static const EXTENSIONS_MOVIECLIP : Array = [".swf"];

        /** Text file type. **/
        public static const TYPE_TEXT : String = "type_text";
		
		/** Sound file type. **/
        public static const TYPE_SOUND : String = "type_sound";
		
		/** Image file type. **/
        public static const TYPE_IMAGE : String = "type_image";
		
		/** Video file type. **/
        public static const TYPE_VIDEO : String = "type_video";
		
		/** MovieClip file type. **/
        public static const TYPE_MOVIECLIP : String = "type_movieclip";

		/**
		 * @param p_context The context can be a instance of <code>LoaderContext</code> or <code>SoundLoaderContext</code>
		 */
		public function LazyLoader( p_context : * = null )
		{
			context = p_context;

		    items = new Dictionary(true);
		    items[TYPE_TEXT] = LazyItemText;
		    items[TYPE_SOUND] = LazyItemSound;
		    items[TYPE_IMAGE] = LazyItemImage;
		    items[TYPE_VIDEO] = LazyItemVideo;
		    items[TYPE_MOVIECLIP] = LazyItemMovieClip;
		}

		/**
		* Starts the loading process.
		* @param p_url File URL.
		* @param p_noCache Prevent cache?
		*/
		public function load( p_url : String, p_noCache : Boolean = false ) : void
		{
		    var lazyItemClass : Class;

		    url = p_url;
		    type = typeByURL(url);

		    if(url == null || url == "") {
		        trace("[LazyLoader] :: load() :: Invalid file.");
		        return;
		    }

		    if(type == "") {
		        trace("[LazyLoader] :: load() :: Sorry, LazyLoader doesn't have support for this kind of file.");
		        return;
		    }

		    lazyItemClass = items[type];

			/** Creating the item. **/
		    item = new lazyItemClass();
			item.context = context;
		    item.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			item.addEventListener(Event.COMPLETE, loadCompleteHandler);
			item.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		    item.load(url, p_noCache);
		}
		
		/** Fired when load process is in progress. **/
		protected function loadProgressHandler( event : ProgressEvent ) : void
		{
		    const progressRatio : Number = LazyItem(event.currentTarget).progressRatio;

			if(onProgress != null) onProgress(progressRatio);
		}
		
		/** Fired when load process finishes. **/
		protected function loadCompleteHandler( event : Event ) : void
		{
		    const data : Object = LazyItem(event.currentTarget).data;

			if(onLoad != null) onLoad(data);

		    item.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		    item.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		}
		
		/** Fired when load process fails. **/
		protected function errorHandler( event : IOErrorEvent ) : void
		{
			if(onError != null) onError(event);
		}

		/**
		* Returns the type of file based on a URL.
		* @param p_url File URL.
		* @return File type.
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
            * Checking if is an available extension.
            * @param p_arr Extensions.
            * @return Returns "true" if the current extension is available otherwise returns "false".
            */
            function isExtensionOf( p_extensions : Array ) : Boolean {

                for each(var item : String in p_extensions) {
                    if(item == extension) {
                        return true;
                    }
                }

                return false;
            }

            return "";
		}
		
		/** Clear from memory. **/
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