package me.feng.component
{
	import flexunit.framework.Assert;

	import me.feng.debug.assert;

	import org.flexunit.asserts.assertTrue;

	public class ComponentContainerTester
	{

		[Before]
		public function setUp():void
		{
		}

		[After]
		public function tearDown():void
		{
		}

		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}

		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}

		[Test]
		public function testAddComponent():void
		{
			var container:ComponentContainer = new ComponentContainer();
			var com:Component = new Component();
			container.addComponent(com);
			container.addComponent(com);

			assert(container.hasComponent(com));
			assert(container.numComponents == 1);

			var throwError:Boolean = false;
			try
			{
				container.addComponent(container);
			}
			catch (error:Error)
			{
				throwError = true;
			}
			assert(throwError);
		}

		[Test]
		public function testAddComponentAt():void
		{
			var container:ComponentContainer = new ComponentContainer();
			var com:Component = new Component();
			container.addComponentAt(com, 0);
			container.addComponentAt(com, 0);

			assert(container.hasComponent(com));
			assert(container.numComponents == 1);

			var throwError:Boolean = false;
			try
			{
				container.addComponentAt(com, 1);
			}
			catch (error:Error)
			{
				throwError = true;
			}
			assert(throwError);

			throwError = false;
			try
			{
				container.addComponentAt(container, 0);
			}
			catch (error:Error)
			{
				throwError = true;
			}
			assertTrue(throwError);
		}

		[Test]
		public function testGetComponentByClass():void
		{
			Assert.fail("Test method Not yet implemented");
		}

		[Test]
		public function testGetComponentByName():void
		{
			Assert.fail("Test method Not yet implemented");
		}

		[Test]
		public function testGetComponentIndex():void
		{
			Assert.fail("Test method Not yet implemented");
		}

		[Test]
		public function testGetComponentsByName():void
		{
			Assert.fail("Test method Not yet implemented");
		}

		[Test]
		public function testHasComponent():void
		{
			Assert.fail("Test method Not yet implemented");
		}

		[Test]
		public function testGet_numComponents():void
		{
			Assert.fail("Test method Not yet implemented");
		}

		[Test]
		public function testRemoveComponent():void
		{
			Assert.fail("Test method Not yet implemented");
		}

		[Test]
		public function testRemoveComponentAt():void
		{
			Assert.fail("Test method Not yet implemented");
		}

		[Test]
		public function testSetComponentIndex():void
		{
			Assert.fail("Test method Not yet implemented");
		}

		[Test]
		public function testSwapComponents():void
		{
			Assert.fail("Test method Not yet implemented");
		}

		[Test]
		public function testSwapComponentsAt():void
		{
			Assert.fail("Test method Not yet implemented");
		}
	}
}
