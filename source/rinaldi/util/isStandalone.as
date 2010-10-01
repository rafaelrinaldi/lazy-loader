package rinaldi.util
{
	import flash.system.Capabilities;

	/**
	 *
	 * Just check if the swf is running standalone or not.
	 *
	 * @return					True if its running standalone otherwise returns false.
	 *
	 * @see rinaldi.util
	 *
	 * @date 01/10/2010
	 * @author Rafael Rinaldi (rafaelrinaldi.com)
	 */

	public function isStandalone() : Boolean
	{
		const playerType : String = Capabilities.playerType.toLowerCase();
		return Boolean(playerType == "activex" || playerType == "external" || playerType == "standalone");
	}
}
