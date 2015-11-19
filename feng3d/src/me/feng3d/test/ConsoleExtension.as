package me.feng3d.test
{
	import com.junkbyte.console.Cc;
	import com.junkbyte.console.Console;
	
	import flash.net.FileReference;
	
	import me.feng3d.containers.ObjectContainer3D;
	import me.feng3d.core.base.Object3D;
	import me.feng3d.core.buffer.Context3DCache;
	import me.feng3d.debug.Context3DBufferDebug;

	public class ConsoleExtension
	{
		protected var console:Console;

		public function ConsoleExtension()
		{
			console = Cc.instance;

//			Cc.instance.cl.addCLCmd("filter", setFilterText, "Filter console logs to matching string. When done, click on the * (global channel) at top.", true);
			Cc.instance.cl.addCLCmd("map3d", mapCmd, "显示ObjectContainer3D内所有Object3D对象");
			Cc.instance.cl.addCLCmd("debugBuffer", debugBufferCmd, "输出Context3DCache中的渲染数据");
		}

		private function debugBufferCmd(param:String = "0"):void
		{
			var context3DCache:Context3DCache = console.cl.scope;
			if (!context3DCache)
			{
				report("Not a ObjectContainer3D.", 10, true, console.panels.mainPanel.reportChannel);
				return;
			}
			
			var debugInfos:Array = Context3DBufferDebug.debug(context3DCache);
			var debugInfoStr:String = JSON.stringify(debugInfos);
			trace(debugInfoStr);
			
			var file:FileReference = new FileReference();
			file.save(debugInfoStr, "context3DBufferDebug.txt");
		}
		
		private function mapCmd(param:String = "0"):void
		{
//			console.mapch(console.panels.mainPanel.reportChannel, console.cl.scope as ObjectContainer3D, int(param));

			map(console.cl.scope as ObjectContainer3D, int(param), console.panels.mainPanel.reportChannel);
		}

		public function map(base:ObjectContainer3D, maxstep:uint = 0, ch:String = null):void
		{
			if (!base)
			{
				report("Not a ObjectContainer3D.", 10, true, ch);
				return;
			}

			var steps:int = 0;
			var wasHiding:Boolean;
			var index:int = 0;
			var lastmcDO:Object3D = null;
			var list:Array = new Array();
			list.push(base);
			while (index < list.length)
			{
				var mcDO:Object3D = list[index];
				index++;
				// add children to list
				if (mcDO is ObjectContainer3D)
				{
					var mc:ObjectContainer3D = mcDO as ObjectContainer3D;
					var numC:int = mc.numChildren;
					for (var i:int = 0; i < numC; i++)
					{
						var child:Object3D = mc.getChildAt(i);
						list.splice(index + i, 0, child);
					}
				}
				// figure out the depth and print it out.
				if (lastmcDO)
				{
					if (lastmcDO is ObjectContainer3D && (lastmcDO as ObjectContainer3D).contains(mcDO))
					{
						steps++;
					}
					else
					{
						while (lastmcDO)
						{
							lastmcDO = lastmcDO.parent;
							if (lastmcDO is ObjectContainer3D)
							{
								if (steps > 0)
								{
									steps--;
								}
								if ((lastmcDO as ObjectContainer3D).contains(mcDO))
								{
									steps++;
									break;
								}
							}
						}
					}
				}
				var str:String = "";
				for (i = 0; i < steps; i++)
				{
					str += (i == steps - 1) ? " ∟ " : " - ";
				}
				if (maxstep <= 0 || steps <= maxstep)
				{
					wasHiding = false;
					var ind:uint = console.refs.setLogRef(mcDO);
					var n:String = mcDO.name;
					if (ind)
						n = "<a href='event:cl_" + ind + "'>" + n + "</a>";
					if (mcDO is ObjectContainer3D)
					{
						n = "<b>" + n + "</b>";
					}
					else
					{
						n = "<i>" + n + "</i>";
					}
					str += n + " " + console.refs.makeRefTyped(mcDO);
					report(str, mcDO is ObjectContainer3D ? 5 : 2, true, ch);
				}
				else if (!wasHiding)
				{
					wasHiding = true;
					report(str + "...", 5, true, ch);
				}
				lastmcDO = mcDO;
			}
			report(base.name + ":" + console.refs.makeRefTyped(base) + " has " + (list.length - 1) + " children/sub-children.", 9, true, ch);
			if (console.config.commandLineAllowed)
				report("Click on the child display's name to set scope.", -2, true, ch);
		}

		protected function report(obj:* = "", priority:int = 0, skipSafe:Boolean = true, ch:String = null):void
		{
			console.report(obj, priority, skipSafe, ch);
		}
	}
}
