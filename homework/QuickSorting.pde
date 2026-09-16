void setup()
{
  int size = 10;
  int[] arr = new int[size];
  
  for (int i = 0; i < size; i++)
  {
    arr[i] = int(random(100));
  }
  
  print("Array: ");
  printArr(arr);
  
  quickSort(arr, 0, size - 1);
  
  for (int i = 0; i < size - 1; i++)
    assert(arr[i] <= arr[i + 1]);
    
  print("Sorted Array: ");
  printArr(arr);
    
    
  
}

void quickSort(int[] arr, int low, int high)
{
  if (low < high)
  {
    int pi = partition(arr, low, high);
    
    quickSort(arr, low, pi - 1);
    quickSort(arr, pi + 1, high);
  }
}

int partition(int[] arr, int low, int high)
{
  int pivot = arr[high];
  int i = (low - 1);
  
  for (int j = low; j <= high - 1; j++)
  {
    if (arr[j] < pivot)
    {
      i++;
      
      swap(arr, i, j);
    }
  }
  
  swap(arr, i + 1, high);
  
  return (i + 1);
}

void printArr(int[] arr)
{
  for (int i = 0; i < arr.length; i++)
    print(arr[i] + " ");
    
  println();
}

void swap(int[] arr, int i, int j)
{
  int temp = arr[i];
  arr[i] = arr[j];
  arr[j] = temp;
  
}
