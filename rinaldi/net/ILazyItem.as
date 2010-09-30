package rinaldi.net {
    
    /**
    * 
    *   LazyItem interface.
    *   
    *   @date 26/11/2009
    *   @author Rafael Rinaldi (rafaelrinaldi.com)
    *   
    */
    
    public interface ILazyItem {
        
        function load( p_url : String ) : void;
        function dispose() : void;
        function toString() : String;
        
        function get data() : Object;
        function set data( value : Object ) : void;
        
    }

}

