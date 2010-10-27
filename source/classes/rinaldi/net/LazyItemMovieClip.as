package rinaldi.net
{
	import flash.display.MovieClip;

	/**
    *
    *   LazyLoader item of movie-clip type.
    *
    *   This class only extends LazyItemImage because the loading proccess is the same for both,
    *   but in the concept image(static) is different then movie-clip(interactive).
    *
    *   @date 26/11/2009
    *   @author Rafael Rinaldi (rafaelrinaldi.com)
    *
	 */


	public class LazyItemMovieClip extends LazyItemImage {

        public function LazyItemMovieClip()
		{
		}

		override public function getAsMovieClip() : MovieClip
		{
			return MovieClip(data);
		}

		override public function toString() : String
		{
		    return "[LazyItemMovieClip]";
		}

	}

}