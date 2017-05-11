public class Stack<E>
{
 private static class Node<T>
 {
   private T value;
   private Node next;

   public Node(T value, Node next)
   {
     this.value=value;
     this.next=next;
   }
 }

 private Node<E> top;

 public void push(E elem)
 {
   if (top==null)
     top=new Node<E>(elem, null);
   else
     top=top.next=new Node<E>(elem, null);
 }
}
