package com.rafaelrinaldi.util
{
	import flash.system.Capabilities;

	/**
	 * Just check if the swf is running standalone or not.
	 *
	 * @since Oct 1, 2010
	 * @author Rafael Rinaldi (rafaelrinaldi.com)
	 * 
	 * @see rinaldi.util
	 * @return True if its running standalone otherwise returns false.
	 */
	public function isStandalone() : Boolean
	{
		const playerType : String = Capabilities.playerType.toLowerCase();
		return Boolean(playerType == "external" || playerType == "standalone");
	}
}
