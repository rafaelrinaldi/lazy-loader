package com.rafaelrinaldi.net
{
	import com.rafaelrinaldi.abstract.IDisposable;
	import com.rafaelrinaldi.util.isStandalone;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.net.NetStream;
	import flash.utils.getTimer;

    /**
    *
    * LazyLoader file item. This is a base class for any kind of item.
    *
    * @since Nov 26, 2009
    * @author Rafael Rinaldi (rafaelrinaldi.com)
    *
    **/
	public class LazyItem extends EventDispatcher implements IDisposable {

		/** File URL. **/
        public var url : String;
		
		/** File data. **/
        public var _data : Object;

		/**  The context can be a instance of <code>LoaderContext</code> or <code>SoundLoaderContext</code>. **/
		/** @see flash.system.LoaderContext **/
		/** @see flash.media.SoundLoaderContext **/
        public var context : *;

		/** Bytes loaded. **/
        public var bytesLoaded : Number;
		
		/** Bytes total. **/
        public var bytesTotal : Number;
		
		/** Progress ratio. **/
        public var progressRatio : Number;

		/**
		 * Starts the loading process.
		 * @param p_url URL to be loaded.
		 * @param p_noCache Prevent cache?
		 */
		public function load( p_url : String, p_noCache : Boolean ) : void
		{
			if(p_noCache && !isStandalone())
		    	url = noCacheURL(p_url);
		    else
		    	url = p_url;
		}

		/**
		 * Apply the "noCache" param with random value to the file URL.
		 * @param p_url File URL.
		 * @return File URL with "noCache" param applied.
		 */
		public function noCacheURL( p_url : String ) : String
		{
			if(p_url == null) return "";
			return p_url.concat("?noCache=" + String(Math.random() * getTimer() * 1000).split(".").join(""));
		}

		/** Force conversion to <code>String</code>. **/
		public function getAsText() : String
		{
			return null;
		}

		/** Force conversion to <code>XML</code>. **/
		public function getAsXML() : XML
		{
			return null;
		}

		/** Force conversion to <code>Sound</code>. **/
		public function getAsSound() : Sound
		{
			return null;
		}

		/** Force conversion to <code>Bitmap</code>. **/
		public function getAsBitmap() : Bitmap
		{
			return null;
		}

		/** Force conversion to <code>BitmapData</code>. **/
		public function getAsBitmapData() : BitmapData
		{
			return null;
		}

		/** Force conversion to <code>NetStream</code>. **/
		public function getAsNetStream() : NetStream
		{
			return null;
		}

		/** Force conversion to <code>MovieClip</code>. **/
		public function getAsMovieClip() : MovieClip
		{
			return null;
		}

		/** Item raw data. **/
		public function get data() : Object
		{
		    return {};
        }

		public function set data( value : Object ) : void
		{
		}
		
		/** Clear from memory. **/
		public function dispose() : void
		{
		}

	}

}