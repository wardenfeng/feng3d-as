Fagal
=====

Fagal是渲染代码AGAL处理工具库 http://www.feng3d.me/?page_id=461

Fagal是渲染代码AGAL处理工具库，从feng3d项目中孕育而出，灵感来自于Cg语言实现过程吸收部分EasyAGAL，所以Fagal比EasyAGAL更Easy，目标是像Cg语言那样容易编写flash3D的渲染程序。

以下是Fagal首个实例BaseShaderTest的渲染函数类代码

package fagal
{

	import me.feng3d.agal.methods.AGALMethod;
	import me.feng3d.core.register.Register;
 
	/**
	 * 基础顶点渲染
	 * @author feng 2014-10-24
	 */
	[AGALMethod(methodName = "V_baseShader", methodType = "vertex")]
	public class V_baseShader extends AGALMethod
	{
		[Register(regName = "position_va_3", regType = "in", description="顶点坐标数据")]
		public var position:Register;
 
		[Register(regName = "color_va_3", regType = "in", description="顶点颜色数据"))]
		public var color:Register;
 
		[Register(regName = "color_v", regType = "out", description="颜色变量寄存器")]
		public var color_v:Register;
 
		[Register(regName = "projection_vc_matrix", regType = "uniform", description="顶点程序投影矩阵静态数据"))]
		public var projection:Register;
 
		[Register(regName = "op", regType = "out", description="位置输出寄存器")]
		public var out:Register;
 
		override public function runFunc():void
		{
			comment("应用投影矩阵" + projection + "使世界坐标" + position + "转换为投影坐标 并输出到顶点寄存器" + out + "");
			m44(out, position, projection);
 
			comment("传递顶点颜色数据"+color+"到变量寄存器"+color_v);
			mov(color_v, color);
		}
	}
}


package fagal
{
	import me.feng3d.agal.methods.AGALMethod;
	import me.feng3d.core.register.Register;
 
	/**
	 * 基础片段渲染
	 * @author feng 2014-10-24
	 */
	[AGALMethod(methodName = "F_baseShader", methodType = "fragment")]
	public class F_baseShader extends AGALMethod
	{
		[Register(regName = "color_v", regType = "in", description = "颜色变量寄存器")]
		public var color_v:Register;
 
		[Register(regName = "oc", regType = "out", description = "颜色输出寄存器")]
		public var out:Register;
 
		override public function runFunc():void
		{
			comment("传递顶点颜色数据" + color_v + "到片段寄存器" + out);
			mov(out, color_v);
		}
	}
}

以下是V_baseShader与F_baseShader的渲染结果

Compiling AGAL Code:
--------------------
//应用投影矩阵vc0使世界坐标va1转换为投影坐标 并输出到顶点寄存器op
m44 op, va1, vc0
//传递顶点颜色数据va0到变量寄存器v0
mov v0, va0
--------------------
//传递顶点颜色数据v0到片段寄存器oc
mov oc, v0
 

Fagal函数类必须继承于AGALMthod，都会使用两个元标签，分别是AGALMethod与Register。

元标签的属性的值定义方式有严格的规范。

[AGALMethod(methodName = "V_baseShader", methodType = "vertex")]

“vertex”表示该类是顶点渲染函数类的意思（“V_baseSahder”的V也是这个意思，当然这里有些重复了，以后也许会调整）。

[Register(regName = "position_va_3", regType = "in", description="顶点坐标数据")]

“position_va_3”是寄存器的名称，“position”表示顶点位置数据，“va”表示寄存器类似为顶点属性寄存器，“3”表示一个顶点有xyz三个值；

“in”表示该数据是输入数据；“description”是该寄存器的描述，将在调试中起很大作用。

 

元标签定义文件metadata.xml

<?xml version="1.0" encoding="utf-8"?>
<annotations version="1.0">
	<metadata name="Register"
			  description="寄存器">
		<context name="variable"/>
		<attribute name="regName"
				   type="String"
				   required="true"
				   description="寄存器名称，使用唯一的字符串来简述寄存器功能"/>
		<attribute name="regType"
				   type="String"
				   required="true"
				   values="in,out,uniform"
				   defaultValue="in"
				   description="寄存器输入输出类型。in：输入寄存器，必须已赋值；out：输出寄存器，函数运行完毕之后必须已赋值；uniform：常数寄存器，无法修改，通常是VC、FC类型。"/>
		<attribute name="description"
				   type="String"
				   required="true"
				   description="寄存器数据描述"/>
	</metadata>
	<metadata name="AGALMethod"
			  description="AGAL函数类">
		<context name="class"/>
		<attribute name="methodName"
				   type="String"
				   required="true"
				   description="函数名称，使用唯一的字符串来简述函数功能"/>
		<attribute name="methodType"
				   type="String"
				   required="true"
				   values="vertex,fragment"
				   defaultValue="vertex"
				   description="函数类型。vertex：顶点渲染函数。fragment：片段渲染函数。"/>
	</metadata>
</annotations>
 

Fagal项目进度：

2014.3.14-2014.10.22：Fagal隐身于feng3d，已经实现按名称自动分配寄存器，自动更新渲染时所用数据（顶点坐标、uv、投影矩阵等等一切渲染时所需数据）等功能。

2014.10.22-2014.10.27：Fagal独立于feng3d，利用EasyAGAL部分代码包装AGAL汇编语言，模仿Cg语言实现AGALMethod类，制作BaseShaderTest实例。

2014.10.27-now：优化Fagal，使Fagal可以更容易地编写渲染代码。


Fagal源码地址：http://pan.baidu.com/s/1kTKaKK3

Fagal库编译参数需加上 -keep-as3-metadata+=Register,AGALMethod

参考：

1、EasyAGAL

2、Cg语言


相关实例
http://www.feng3d.me/?page_id=8
https://github.com/wardenfeng/feng3d_examples
