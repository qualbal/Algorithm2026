int[] arr;

void setup() {
 
   intArr(16);
   printArr();
   selectionSort();
   printArr();
}

void intArr(int n)
{
  int i;
arr = new int[n];
  for (i = 0; i <arr.length; i++)
  {
    arr[i] = (int) random(100);
  }
}

void printArr()
{
  int i;
  for (i = 0; i < arr.length; i++)
  {
    print(arr[i], " ");
  }
  println();
}

void selectionSort()
{
   int i, j, max, index;
    for (i = 0; i < arr.length; i++)
  {
    max = index = -1;
    for (j = 0; j < arr.length - i; j++)
    {
      if (max <arr[j])
      {
        index = j;
        max = arr[j];
      }
    }
    swap(index, arr.length-i-1);
  }

}

void swap(int i, int j)
{
  int temp;
    temp = arr[j];
    arr[j] = arr[i];
    arr[i] = temp;
}

void draw() {
 
}
