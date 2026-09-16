void insertionSort(int arr[], int size)
{
  for (int i = 1; i < size; i++)
  {
    int key = arr[i];
    int j = i - 1;
    
    while (j >= 0 && arr[j] > key)
    {
      arr[j + 1] = arr[j];
      j--;
    }
    
    arr[j + 1] = key;
  }
}

void setup()
{
  int size = 10;
  int[] arr = new int[size];
  
  for (int i = 0; i < size; i++)
  {
    arr[i] = int(random(100));
  }
  
  print("Array: ");
  printArr(arr, size);
  
  insertionSort(arr, size);
  print("Sorted Array: ");
  printArr(arr, size);
}

void printArr(int arr[], int size)
{
  for (int i = 0; i < size; i++)
  {
    print(arr[i] + " ");
  }
  
  println();
}

void draw()
{

}
