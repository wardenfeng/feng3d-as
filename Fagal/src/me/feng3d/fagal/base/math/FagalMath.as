package me.feng3d.fagal.base.math
{
	import me.feng3d.core.register.Register;
	import me.feng3d.core.register.RegisterMatrix;
	import me.feng3d.debug.Debug;
	import me.feng3d.fagal.FagalToken;
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagalRE.FagalRE;

	/**
	 * Fagal数学运算
	 * @author warden_feng 2015-7-22
	 */
	public class FagalMath
	{
		/**
		 * destination=abs(source1):一个寄存器的绝对值，分量形式
		 */
		public function abs(destination:IField, source1:IField):void
		{
			var code:String = "abs " + destination + ", " + source1;
			append(code);
		}

		/**
		 * destination=source1+source2:两个寄存器相加，分量形式
		 */
		public function add(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "add " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * destination=cos(source1):一个寄存器的余弦值，分量形式
		 */
		public function cos(destination:IField, source1:IField):void
		{
			var code:String = "cos " + destination + ", " + source1;
			append(code);
		}

		/**
		 * crs:两个寄存器间的叉积
		 * <p>destination.x=source1.y*source2.z-source1.z*source2.y</p>
		 * <p>destination.y=source1.z*source2.x-source1.x*source2.z</p>
		 * <p>destination.z=source1.x*source2.y-source1.y*source2.x</p>
		 */
		public function crs(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "crs " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * destination=source1/source2:两个寄存器相除，分量形式
		 */
		public function div(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "div " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * dp3:两个寄存器间的点积，3分量
		 * <br/>
		 * destination=source1.x*source2.x+source1.y*source2.y+source1.z*source2.z
		 */
		public function dp3(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "dp3 " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * dp4:两个寄存器间的点积，4分量
		 * <br/>
		 * destination=source1.x*source2.x+source1.y*source2.y+source1.z*source2.z+source1.w+source2.w
		 */
		public function dp4(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "dp4 " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * destination=2^source1:2的source1次方，分量形式
		 */
		public function exp(destination:IField, source1:IField):void
		{
			var code:String = "exp " + destination + ", " + source1;
			append(code);
		}

		/**
		 * destination=source1-(float)floor(source1)一个寄存器的分数部分，分量形式
		 */
		public function frc(destination:IField, source1:IField):void
		{
			var code:String = "frc " + destination + ", " + source1;
			append(code);
		}

		/**
		 * 如果寄存器有任意一个分量小于0，则丢弃该像素不进行绘制(只适用于片段着色器)
		 */
		public function kil(destination:IField, source1:IField):void
		{
			var code:String = "kil " + source1;
			append(code);
		}

		/**
		 * destination=log(source1)一个寄存器以2为底的对数，分量形式
		 */
		public function log(destination:IField, source1:IField):void
		{
			var code:String = "log " + destination + ", " + source1;
			append(code);
		}

		/**
		 * m33:由一个3*3的矩阵对一个3分量的向量进行矩阵乘法
		 * <br/>
		 * destination.x=(source1.x*source2[0].x)+(source1.y*source2[0].y)+(source1.z*source2[0].z)
		 * <br/>
		 * destination.y=(source1.x*source2[1].x)+(source1.y*source2[1].y)+(source1.z*source2[1].z)
		 * <br/>
		 * destination.z=(source1.x*source2[2].x)+(source1.y*source2[2].y)+(source1.z*source2[2].z)

		 */
		public function m33(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "m33 " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * m34:由一个3*4的矩阵对一个4分量的向量进行矩阵乘法
		 * <br/>
		 * destination.x=(source1.x*source2[0].x)+(source1.y*source2[0].y)+(source1.z*source2[0].z)+(source1.w*source2[0].w)
		 * <br/>
		 * destination.y=(source1.x*source2[1].x)+(source1.y*source2[1].y)+(source1.z*source2[1].z)+(source1.w*source2[1].w)
		 * <br/>destination.z=(source1.x*source2[2].x)+(source1.y*source2[2].y)+(source1.z*source2[2].z)+(source1.w*source2[2].w)

		 */
		public function m34(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "m34 " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * m44:由一个4*4的矩阵对一个4分量的向量进行矩阵乘法
		 * <br/>
		 * destination.x=(source1.x*source2[0].x)+(source1.y*source2[0].y)+(source1.z*source2[0].z)+(source1.w*source2[0].w)
		 * <br/>
		 * destination.y=(source1.x*source2[1].x)+(source1.y*source2[1].y)+(source1.z*source2[1].z)+(source1.w*source2[1].w)
		 * <br/>
		 * destination.z=(source1.x*source2[2].x)+(source1.y*source2[2].y)+(source1.z*source2[2].z)+(source1.w*source2[2].w)
		 * <br/>
		 * destination.w=(source1.x*source2[3].x)+(source1.y*source2[3].y)+(source1.z*source2[3].z)+(source1.w*source2[3].w)

		 */
		public function m44(destination:Register, source1:Register, source2:RegisterMatrix):void
		{
			var code:String = "m44 " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * max:destination=max(source1 ，source2): 两个寄存器之间的较大值，分量形式

		 */
		public function max(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "max " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * min:destination=min(source1 ， source2) : 两个寄存器之间的较小值，分量形式
		 */
		public function min(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "min " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * mov:destination=source :将数据从源寄存器复制到目标寄存器
		 */
		public function mov(destination:IField, source1:IField):void
		{
			var code:String = "mov " + destination + ", " + source1;
			append(code);
		}

		/**
		 * destination = source1 * source2:两个寄存器相乘，分量形式
		 */
		public function mul(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "mul " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * destination=-source1:一个寄存器取反，分量形式
		 */
		public function neg(destination:IField, source1:IField):void
		{
			var code:String = "neg " + destination + ", " + source1;
			append(code);
		}

		/**
		 * destination=normalize(source1):将一个寄存器标准化为长度1的单位向量
		 */
		public function nrm(destination:IField, source1:IField):void
		{
			var code:String = "nrm " + destination + ", " + source1;
			append(code);
		}

		/**
		 * destination=pow(source1 ，source2):source1的source2次冥，分量形式
		 */
		public function pow(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "pow " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * destination=1/source1:一个寄存器的倒数，分量形式
		 */
		public function rcp(destination:IField, source1:IField):void
		{
			var code:String = "rcp " + destination + ", " + source1;
			append(code);
		}

		/**
		 * destination=1/sqrt(source) 一个寄存器的平方根倒数，分量形式
		 */
		public function rsq(destination:IField, source1:IField):void
		{
			var code:String = "rsq " + destination + ", " + source1;
			append(code);
		}

		/**
		 * destination=max(min(source1,1),0):将一个寄存器锁0-1的范围里
		 */
		public function sat(destination:IField, source1:IField):void
		{
			var code:String = "sat " + destination + ", " + source1;
			append(code);
		}

		/**
		 * destination= source1==source2 ? 1 : 0
		 */
		public function seq(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "seq " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * destination = source1>=source2 ? 1 : 0 类似三元操作符 分量形式
		 */
		public function sge(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "sge " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * destination=sin(source1):一个寄存器的正弦值，分量形式
		 */
		public function sin(destination:IField, source1:IField):void
		{
			var code:String = "sin " + destination + ", " + source1;
			append(code);
		}

		/**
		 * destination = source1小于source2 ? 1 : 0
		 */
		public function slt(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "slt " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * destination=source1!=source2 ? 1:0
		 */
		public function sne(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "sne " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * destination=sqrt(source):一个寄存器的平方根，分量形式
		 */
		public function sqt(destination:IField, source1:IField):void
		{
			var code:String = "sqt " + destination + ", " + source1;
			append(code);
		}

		/**
		 * destination=source1-source2:两个寄存器相减，分量形式
		 */
		public function sub(destination:IField, source1:IField, source2:IField):void
		{
			var code:String = "sub " + destination + ", " + source1 + ", " + source2;
			append(code);
		}

		/**
		 * 纹理取样
		 * @param	colorReg	目标寄存器
		 * @param	uvReg		UV坐标
		 * @param	textureReg	纹理寄存器
		 * @param	flags		取样参数
		 */
		public function tex(colorReg:Register, uvReg:Register, textureReg:Register):void
		{
			var code:String = "tex " + colorReg + ", " + uvReg + ", " + textureReg;

			//获取法线纹理采样参数
			var flags:Array = getSampleFlags(textureReg);
			if (flags && flags.length > 0)
			{
				code += " <" + flags.join(",") + ">";
			}
			append(code);

			/**
			 * 获取取样参数
			 * @param textureReg 纹理寄存器
			 * @return 取样参数
			 */
			function getSampleFlags(textureReg:Register):Array
			{
				//抛出 获取取样标记 事件
				var shaderParams:ShaderParams = FagalRE.instance.context3DCache.shaderParams;

				//提取 渲染标记
				var flags:Array = shaderParams.getFlags(textureReg.regId);
				return flags;
			}
		}

		/**
		 * 混合数据
		 * <p>destination = source1 + (source2-source1) x factor</p>
		 * @author warden_feng 2015-7-4
		 */
		public function blend(destination:IField, source1:IField, source2:IField, factor:IField):void
		{
			sub(source2, source2, source1);
			mul(source2, source2, factor);
			add(destination, source1, source2);
		}

		/**
		 * 添加注释
		 */
		public function comment(... remarks):void
		{
			if (!Debug.agalDebug)
				return;
			append(FagalToken.COMMENT + remarks.join(" "));
		}

		/**
		 * 添加代码
		 * @author warden_feng 2015-4-24
		 */
		public function append(code:String):void
		{
			FagalRE.instance.append(code);
		}
	}
}
