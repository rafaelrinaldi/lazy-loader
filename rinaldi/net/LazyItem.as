package rinaldi.net
{
	import flash.net.NetStream;
	import flash.media.Sound;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
    
    /**
    *   
    *   LazyLoader file item.
    *   
    *   @date 26/11/2009
    *   @author Rafael Rinaldi (rafaelrinaldi.com)
    *   
    **/
    
	import flash.events.Event;
    import flash.events.EventDispatcher;
    
	import rinaldi.net.ILazyItem;
    
	public class LazyItem extends EventDispatcher implements ILazyItem {
        
        public var url : String; // File URL
        public var _data : Object; // File data
        
        /** Load progress info **/
        public var bytesLoaded : Number;
        public var bytesTotal : Number;
        public var progressRatio : Number;
        
        public function LazyItem()
		{
		}
		
		public function load( p_url : String ) : void
		{
		    url = p_url;
		    this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function getAsText() : String
		{
			return null;
		}
		
		public function getAsXML() : XML
		{
			return null;
		}

		public function getAsSound() : Sound 
		{
			return null;
		}
		
		public function getAsBitmap() : Bitmap 
		{
			return null;
		}

		public function getAsNetStream() : NetStream 
		{
			return null;
		}
		
		public function getAsMovieClip() : MovieClip 
		{
			return null;
		}

		public function get data() : Object
		{
		    return {};
        }
        
		public function set data( value : Object ) : void
		{
		}
		
		public function dispose() : void
		{
		}
		
		override public function toString() : String
		{
		    return "[LazyItem]";
		}

	}

}