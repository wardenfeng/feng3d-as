package avmplus
{

	/**
	 * 获取类实例描述
	 * @param type		类类型
	 * @return			类实例描述
	 *
	 * @author feng 2012-10-23
	 */
	public function describeTypeInstance(type:Class):Object
	{
		return describeTypeJSON(type, DescribeTypeJSON.INSTANCE_FLAGS);
	}
}
