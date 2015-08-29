package me.feng3d.animators
{
	import me.feng3d.animators.base.node.AnimationNodeBase;
	import me.feng3d.core.proxy.Stage3DProxy;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.passes.MaterialPassBase;

	/**
	 * Provides an interface for data set classes that hold animation data for use in animator classes.
	 *
	 * @see away3d.animators.IAnimator
	 */
	public interface IAnimationSet
	{
		/**
		 * Check to determine whether a state is registered in the animation set under the given name.
		 *
		 * @param stateName The name of the animation state object to be checked.
		 */
		function hasAnimation(name:String):Boolean;

		/**
		 * Retrieves the animation state object registered in the animation data set under the given name.
		 *
		 * @param stateName The name of the animation state object to be retrieved.
		 */
		function getAnimation(name:String):AnimationNodeBase;

		/**
		 * Indicates whether the properties of the animation data contained within the set combined with
		 * the vertex registers aslready in use on shading materials allows the animation data to utilise
		 * GPU calls.
		 */
		function get usesCPU():Boolean;

		/**
		 * Called by the material to reset the GPU indicator before testing whether register space in the shader
		 * is available for running GPU-based animation code.
		 *
		 * @private
		 */
		function resetGPUCompatibility():void;

		/**
		 * Called by the animator to void the GPU indicator when register space in the shader
		 * is no longer available for running GPU-based animation code.
		 *
		 * @private
		 */
		function cancelGPUCompatibility():void;

		/**
		 * Sets the GPU render state required by the animation that is independent of the rendered mesh.
		 *
		 * @param stage3DProxy The proxy currently performing the rendering.
		 * @param pass The material pass currently being used to render the geometry.
		 *
		 * @private
		 */
		function activate(shaderParams:ShaderParams, pass:MaterialPassBase):void
	}
}
