void setup()
{
  int size = 10;
  int[] arr = new int[size];
  
  for (int i = 0; i < size; i++)
    arr[i] = int(random(100));
    
  print("Array: ");
  intArr(arr);
  
  heapSort(arr);
  
  print("Sorted Array: ");
  intArr(arr);
}

void heapSort(int[] arr)
{
  int n = arr.length;
  
  for (int i = n / 2 - 1; i >= 0; i--)
  {
    heapify(arr, n, i);
  }
  
  for (int i = n - 1; i > 0; i--)
  {
    int temp = arr[0];
    arr[0] = arr[i];
    arr[i] = temp;
    
    heapify(arr, i, 0);
  }
}

void heapify(int[] arr, int n, int i)
{
  int largest = i;
  int left = 2 * i + 1;
  int right = 2 * i + 2;
  
  if (left < n && arr[left] > arr[largest])
  {
    largest = left;
  }
  
  if (right < n && arr[right] > arr[largest])
  {
    largest = right;
  }
  
  if (largest != i)
  {
    int temp = arr[i];
    arr[i] = arr[largest];
    arr[largest] = temp;
    
    heapify(arr, n, largest);
  }
}

void intArr(int[] arr)
{
  for (int i = 0; i < arr.length; i++)
    print(arr[i] + " ");
    
  println();
}
