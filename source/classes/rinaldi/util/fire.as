package rinaldi.util
{

	/**
	 *
	 * Useful method to fire a function without be careful about null pointer exception.
	 *
	 * @param					p_function					Function to be fired.
	 * @param					args						A list of parameters.
	 *
	 * @example
	 * <pre>
	 * import rinaldi.util.fire;
	 *
	 * const nullMethod : Function;
	 *
	 * // Fire the method "sum();" passing 5 and 5 as arguments
	 * fire(sum, 5, 5);
	 *
	 * function sum( p_a : Number, p_b : Number ) : void {
	 * 		trace(p_a + p_b); // 10
	 * }
	 *
	 * // Nothing will be fired
	 * fire(nullMethod);
	 * </pre>
	 *
	 * @see rinaldi.util
	 *
	 * @date 23/08/2010
	 * @author Rafael Rinaldi (rafaelrinaldi.com)
	 *
	 */

	public function fire( p_function : Function, ...args ) : void
	{
		if(p_function != null) p_function.apply(this, args);
	}
}