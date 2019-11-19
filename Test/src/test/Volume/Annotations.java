package test.Volume;

/**
 * Annotations code copied from:
 * http://en.wikipedia.org/wiki/Java_annotation
 * @author rvdw
 *
 */
public class Annotations {
	public void speak() {
	}

	public String getType() {
		return "Generic babaganoush";
	}

	public class BuildInAnnotation extends Annotations {

		@Override
		public void speak() {
			System.out.println("ahhhhh."); //comment here
		}

		public String gettype() { // comment hello.
			return "dog";
		}
	} // hello again

	// mimimi().
	@Twizzle
	public void toggle() {
	}

	// hello
	public @interface Twizzle {
	}

	// I want a good grade :D 
	@Edible(true)
	Carrot item = new Carrot();

	public @interface Edible {
		boolean value() default true;
	}

	@Author(first = "sss", last = "aa")
	Book german = new Book();

	public @interface Author {
		String first();

		String last();
	}

	public class Item {
	}

	public class Carrot {
	}

	public class Book {
	}
}