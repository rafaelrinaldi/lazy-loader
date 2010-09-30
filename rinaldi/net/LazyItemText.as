package rinaldi.net
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
    *   
    *   LazyLoader item of text type.
    *   
    *   @date 26/11/2009
    *   @author Rafael Rinaldi (rafaelrinaldi.com)
    *   
	 */

	
	public class LazyItemText extends LazyItem {
        
        public var loader : URLLoader;
        
		public function LazyItemText()
		{
		}
		
		override public function load( p_url : String ) : void
		{
		    url = p_url;
		    
		    /** Creating the load proccess **/
		    loader = new URLLoader();
		    loader.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		    loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
		    loader.load(new URLRequest(url));
		}

		override public function getAsText() : String 
		{
			return String(data);
		}
		
		override public function getAsXML() : XML 
		{
			return XML(data);
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
        	data = event.target["data"];
        	
            /** Updating load progress info **/
		    bytesLoaded = event.bytesLoaded;
		    bytesTotal = event.bytesTotal;
		    progressRatio = bytesLoaded / bytesTotal;
		    
		    /** Dispatching a clone of ProgressEvent instance **/
		    this.dispatchEvent(event.clone());
        }
		
		public function loadCompleteHandler( event : Event ) : void
		{   
			data = event.target["data"];
			
		    /** Dispatching the load complete event **/
		    this.dispatchEvent(new Event(Event.COMPLETE));
		}

		override public function dispose() : void
		{
		    if(loader != null) {
		        
		        if(loader.hasEventListener(ProgressEvent.PROGRESS)) {
		            loader.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
		        }
		        
		        if(loader.hasEventListener(Event.COMPLETE)) {
		            loader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		        }
		        
		        try {
		            loader.close();
		        } catch( error : Error ) {
		            // None stream opened
		        }
		        
		        loader = null;
		        
		    }
		    
		    data = null;
		}
		
		override public function toString() : String
		{
		    return "[LazyItemText]";
		}

	}

}