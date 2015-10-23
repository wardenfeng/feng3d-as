package avmplus
{

	/**
	 * 获取类描述
	 * @param type		类类型
	 * @return 			类描述
	 *
	 * @author feng 2012-10-23
	 */
	public function describeTypeClass(type:Class):Object
	{
		return describeTypeJSON(type, DescribeTypeJSON.CLASS_FLAGS);
	}
}
