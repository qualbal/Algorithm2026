int[] arr;


void setup()
{
  intArr(16);
  printArr();
  bubbleSort();
  printArr();

  
}
  
  void intArr(int n)
{
  int i;
  arr = new int[n];
  for (i = 0; i < arr.length; i++)
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
  
  void bubbleSort()
  {
    for (int i = 0; i < arr.length - 1; i++)
  {
    boolean swapped = false;
  
    for (int j = 0; j < arr.length - i - 1; j++)
    {
      if (arr[j] > arr[j + 1])
      {
        swapped = true;
        swap(j, j + 1);
      }
    }
  
    if (!swapped)
    {
    break;
    }

  
  }
  }
  
  void swap(int first, int second)
  {
    int temp = arr[first];
    arr[first] = arr[second];
    arr[second] = temp;
  }
  
  void draw()
  {
  }
