package com.rafaelrinaldi.net
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	/**
    *
    * LazyLoader item of image type.
    *
    * @since Nov 26, 2009
    * @author Rafael Rinaldi (rafaelrinaldi.com)
    *
	*/
	public class LazyItemImage extends LazyItem {

		/** <code>Loader</code> instance. **/
        public var loader : Loader;
		
		/**
		 * Starts the loading process.
		 * @param p_url URL to be loaded.
		 * @param p_noCache Prevent cache?
		 */
		override public function load( p_url : String, p_noCache : Boolean ) : void
		{
		    super.load(p_url, p_noCache);

		    /** Creating the load proccess. **/
		    loader = new Loader;
		    loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);

		    loader.load(new URLRequest(url), context);
		}

		/** Force conversion to <code>Bitmap</code>. **/
		override public function getAsBitmap() : Bitmap
		{
			return Bitmap(data);
		}

		/** Force conversion to <code>BitmapData</code>. **/
		override public function getAsBitmapData() : BitmapData
		{
			return Bitmap(data).bitmapData;
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

		/** Fired when load process is in progress. **/
		protected function loadProgressHandler( event : ProgressEvent ):void
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
			data = event.target["content"];

		    this.dispatchEvent(event);
		}
		
		/** Fired when load process fails. **/
		protected function errorHandler( event : IOErrorEvent ) : void
		{
			this.dispatchEvent(event);
		}

		/** Clear from memory. **/
		override public function dispose() : void
		{
		    if(loader == null) return;

            loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		    loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		    loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);

			// Try to close the Loader instance
		    try {
		    	loader.close();
			} catch( error : Error ) {
		    	// None stream opened
			}

		    loader = null;
		    data = null;
		}
	}

}