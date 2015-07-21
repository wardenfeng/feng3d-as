package avmplus
{

	/**
	 * 获取类实例描述
	 * @author warden_feng 2012-10-23
	 */
	public function describeTypeInstance(type:*):Object
	{
		return describeTypeJSON(type, INCLUDE_BASES | INCLUDE_INTERFACES //
			| INCLUDE_VARIABLES | INCLUDE_ACCESSORS | INCLUDE_METHODS | INCLUDE_METADATA //
			| INCLUDE_CONSTRUCTOR | INCLUDE_TRAITS | USE_ITRAITS | HIDE_OBJECT);
	}
}